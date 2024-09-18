import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:multi_store_app_supplier/widgets/appbar_widgets.dart';

import '../minor_screen/visit_store.dart';

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});

  @override
  State<StoresScreen> createState() => _StoresScreenState();

}

class _StoresScreenState extends State<StoresScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        title: const AppBarTitle(title: 'Stores', color: Colors.white,),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('supliers').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("there Something Wrong"),
            );
          } else if (snapshot.hasData) {
            return MasonryGridView.builder(
              padding: EdgeInsets.all(16),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              itemCount: snapshot.data!.docs.length,
              gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => VisitStore(suppId: snapshot.data!.docs[index]['sid']),));
                  },
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            height: 120,
                            width: 120,
                            child: Image.asset('images/inapp/store.jpg'),
                          ),
                          Positioned(top: 43,left: 15,child: SizedBox(height: 48, width: 90, child: Image.network(snapshot.data!.docs[index]['store_logo'], fit: BoxFit.fitWidth,),))
                        ],
                      ),

                      Text(snapshot.data!.docs[index]['store_name'].toLowerCase(), style: const TextStyle(fontFamily: 'Akaya', fontSize: 26)),
                    ],
                  ),
                );
              },
            );
          }
          else {
            return const Center(child: Text("No Stores"),);
          }
        },
      ),
    );
  }
}
