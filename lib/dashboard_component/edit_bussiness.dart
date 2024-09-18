import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app_supplier/widgets/appbar_widgets.dart';

class EditBussiness extends StatelessWidget {
  const EditBussiness({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const AppBarTitle(title: "Edit Profile", color: Colors.black,),
          leading: const AppBarBackButton(color: Colors.black,)),
    );
  }
}
