



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../models/product_model.dart';

class KidsGardenGalleryScreen extends StatefulWidget {
  const KidsGardenGalleryScreen({super.key});

  @override
  State<KidsGardenGalleryScreen> createState() => _KidsGardenGalleryScreenState();
}

class _KidsGardenGalleryScreenState extends State<KidsGardenGalleryScreen> {
  final Stream<QuerySnapshot> _productStream =
  FirebaseFirestore.instance.collection('products').where('main_category', isEqualTo: 'kids').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _productStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("There Some Thing Wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(),);
        }
        if (snapshot.data!.docs.isEmpty) {
          return Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('images/inapp/empty.png', height: 100, width: 100,),
                  SizedBox(height: 20,),
                  Center(
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
                  ),
                ],
              ));
        }


        return SingleChildScrollView(
          child: MasonryGridView.count(
            padding: EdgeInsets.all(15),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            itemBuilder: (context, index) {
              var productData = snapshot.data!.docs[index];
              return ProductModel(productData: productData,products: productData,);
            },
          ),
        );
      },
    );
  }
}


