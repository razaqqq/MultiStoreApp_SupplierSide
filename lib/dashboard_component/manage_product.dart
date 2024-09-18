import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:multi_store_app_supplier/widgets/appbar_widgets.dart';

import '../models/product_model.dart';

class ManageProduct extends StatelessWidget {
  const ManageProduct({super.key});




  @override
  Widget build(BuildContext context) {

    final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
        .collection('products')
        .where('sid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const AppBarTitle(title: "Manage Product", color: Colors.black,),
          leading: const AppBarBackButton(color: Colors.black,)),
      body: StreamBuilder(
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

          return SingleChildScrollView(
            child: MasonryGridView.count(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              physics: NeverScrollableScrollPhysics(),
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
            ),
          );
        },
      ),
    );
  }
}
