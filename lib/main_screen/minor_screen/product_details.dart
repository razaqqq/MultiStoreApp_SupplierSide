import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:provider/provider.dart';

import '../../models/product_model.dart';

import 'full_screen_view.dart';
import 'package:collection/collection.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.proList});

  final dynamic proList;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  late final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
      .collection('products')
      .where('main_category', isEqualTo: widget.proList['main_category'])
      .where('sub_category', isEqualTo: widget.proList['sub_category'])
      .snapshots();

  late final Stream<QuerySnapshot> _reviewsStream = FirebaseFirestore.instance
      .collection('products')
      .doc(widget.proList['pid'])
      .collection('reviews')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    // var existingItemsWishList = context
    //     .read<Wish>()
    //     .getWishItems
    //     .firstWhereOrNull(
    //         (product) => product.documentId == widget.proList['pid']);

    var onsale = widget.proList['in_stock'];

    return Material(
      child: SafeArea(
        child: ScaffoldMessenger(
          key: _scaffoldKey,
          child: Scaffold(
            appBar: AppBar(
              elevation: 3,
              title: Text("Product Details", style: TextStyle(color: Colors.white),),
              shadowColor: Colors.black,
              backgroundColor: Colors.teal,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              actions: [
                IconButton(onPressed: (){}, icon: Icon(Icons.share, color: Colors.white)),
                IconButton(onPressed: (){}, icon: Icon(Icons.more_vert, color: Colors.white,))
              ],
            ),
            body: ProductDetailsBodey(
                widget: widget,
                productStream: _productStream,
                onsale: onsale,
                reviewsStream: _reviewsStream),
          ),
        ),
      ),
    );
  }
}

class ProductDetailsBodey extends StatelessWidget {
  ProductDetailsBodey(
      {super.key,
      required this.widget,
      required Stream<QuerySnapshot<Object?>> productStream,
      required this.onsale,
      required this.reviewsStream})
      : _productStream = productStream;

  final ProductDetailsScreen widget;
  final Stream<QuerySnapshot<Object?>> _productStream;
  final int onsale;
  var reviewsStream;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenView(
                          imageList: widget.proList['product_images']),
                    ));
              },
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.45,
                child: Swiper(
                  pagination: const SwiperPagination(
                      builder: SwiperPagination.dots),
                  itemCount: widget.proList['product_images'].length,
                  itemBuilder: (context, index) {
                    return Image(
                      width: double.infinity,
                      height: double.infinity,
                      image: NetworkImage(
                          widget.proList['product_images'][index]),
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            Text(
              widget.proList['product_name'],
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'USD',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.proList['price'].toStringAsFixed(2),
                          style: widget.proList['discount'] != 0
                              ? const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  decoration: TextDecoration.lineThrough,
                                  fontWeight: FontWeight.w600)
                              : const TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        widget.proList['discount'] != 0
                            ? Text(
                                ((1 - (widget.proList['discount'] / 100)) *
                                        widget.proList['price'])
                                    .toStringAsFixed(2),
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              )
                            : const Text(''),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            widget.proList['in_stock'] == 0
                ? const Text(
                    'This item is Out of Stock',
                    style: TextStyle(color: Colors.blueGrey, fontSize: 16),
                  )
                : Text(
                    '${widget.proList['in_stock']} pieces available in stock',
                    style:
                        const TextStyle(color: Colors.blueGrey, fontSize: 16),
                  ),
            const ProductDetailsHeader(
              label: "Item Description",
            ),
            Text(
              widget.proList['product_description'],
              textScaler: const TextScaler.linear(1.1),
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey.shade800),
            ),
            Stack(
              children: [
                const Positioned(right: 50,top: 15,child: Text('Total')),
                ExpandableTheme(
                    data: ExpandableThemeData(
                      iconColor: Colors.blue,
                      iconSize: 24,
                    ), child: reviews(reviewsStream)),
              ],
            ),
            const ProductDetailsHeader(label: 'Similar Items'),
            SizedBox(
                child: StreamBuilder(
              stream: _productStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("There Some Thing Wrong");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "This Category Has No Items Here",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 26,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Acme',
                          letterSpacing: 1.5),
                    ),
                  );
                }
                return MasonryGridView.count(
                  padding: const EdgeInsets.all(5),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  itemBuilder: (context, index) {
                    var productData = snapshot.data!.docs[index];
                    return ProductModel(
                      productData: productData,
                      products: productData,
                    );
                  },
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}



class ProductDetailsHeader extends StatelessWidget {
  final String label;

  const ProductDetailsHeader({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 40,
          width: 50,
          child: Divider(
            color: Colors.teal.shade900,
            thickness: 1,
          ),
        ),
        Text(
          '  $label  ',
          style: TextStyle(
              color: Colors.grey, fontSize: 30, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 40,
          width: 50,
          child: Divider(
            color: Colors.teal.shade900,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}

Widget reviews(var reviewsStream) {
  return ExpandablePanel(
      header: const Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          'Reviews',
          style: TextStyle(
              color: Colors.blue, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      collapsed: SizedBox(
        height: 230,
        child: reviewsAll(reviewsStream),
      ),
      expanded: reviewsAll(reviewsStream));
}

Widget reviewsAll(var reviewsStream) {
  return StreamBuilder<QuerySnapshot>(
    stream: reviewsStream,
    builder: (context, snapshot2) {
      if (snapshot2.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (snapshot2.data!.docs.isEmpty) {
        return const Center(
          child: Text(
            "This Product Doesnt Has Preview yet",
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 26,
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
                fontFamily: 'Acme',
                letterSpacing: 1.5),
          ),
        );
      }

      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: snapshot2.data!.docs.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(snapshot2.data!.docs[index]['profile_image']),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(snapshot2.data!.docs[index]['name']),
                Row(
                  children: [
                    Text(snapshot2.data!.docs[index]['rate'].toString()),
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                    )
                  ],
                )
              ],
            ),
            subtitle: Text(snapshot2.data!.docs[index]['comment']),
          );
        },
      );
    },
  );
}
