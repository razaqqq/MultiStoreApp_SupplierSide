import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app_supplier/dashboard_component/edit_bussiness.dart';
import 'package:multi_store_app_supplier/dashboard_component/manage_product.dart';
import 'package:multi_store_app_supplier/dashboard_component/supplier_balance.dart';
import 'package:multi_store_app_supplier/dashboard_component/supplier_static.dart';
import 'package:multi_store_app_supplier/dashboard_component/suup_orders.dart';
import 'package:multi_store_app_supplier/main_screen/minor_screen/visit_store.dart';
import 'package:multi_store_app_supplier/profiders/authentication_repository.dart';
import 'package:multi_store_app_supplier/widgets/alert_dialog.dart';
import 'package:multi_store_app_supplier/widgets/appbar_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';


List<Map> cardMap = [
  {
    'label': 'my store',
    'icon': Icons.store
  },
  {
    'label': 'orders',
    'icon': Icons.shop_2_outlined
  },
  {
    'label': 'edit profile',
    'icon': Icons.edit
  },
  {
    'label': 'manage product',
    'icon': Icons.settings
  },
  {
    'label': 'balance',
    'icon': Icons.attach_money
  },
  {
    'label': 'static',
    'icon': Icons.show_chart
  }
];


List<Widget> dashboardComponentList = [
  VisitStore(suppId: FirebaseAuth.instance.currentUser!.uid),
  const SupliyerOrders(),
  const EditBussiness(),
  const ManageProduct(),
  const BalanceScreen(),
  const StaticScreen(),
];



class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final Future<SharedPreferences> _sharedPreferences = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          elevation: 0,
          title: const AppBarTitle(title: 'Dashboard', color: Colors.white,),
          actions: [
            IconButton(
                onPressed: () {
                  MyAlertDialog.showMyDialog(context: context,
                      title: "Log Out",
                      content: "Do You Want to Log Out? ",
                      tabYes: () async {
                        final SharedPreferences preferences = await _sharedPreferences;
                        preferences.setString('supplier_id', '');

                        AuthenticationRepository.logOut();
                        await Future.delayed(Duration(milliseconds: 100)).whenComplete(() {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/onboarding_screen');
                        });
                      },
                      tabNo: () {
                        Navigator.pop(context);
                      });


                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: GridView.count(
            mainAxisSpacing: 50,
            crossAxisSpacing: 50,
            crossAxisCount: 2,
            children: List.generate(6, (index) {
              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => dashboardComponentList[index],));
                },
                child: Card(
                  elevation: 5,
                  shadowColor: Colors.black,
                  color: Colors.blueGrey.withOpacity(0.7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        cardMap[index]['icon'],
                        size: 50,
                        color: Colors.yellow,
                      ),
                      Text(
                        cardMap[index]['label'].toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.yellowAccent,
                            letterSpacing: 2,
                            fontFamily: 'Acme'),
                      )
                    ],
                  ),
                ),
              );
            }),
          ),
        ));
  }
}
