import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app_supplier/main_screen/category/category_screen.dart';
import 'package:multi_store_app_supplier/main_screen/dashboard_screen/dashboard_screen.dart';
import 'package:multi_store_app_supplier/main_screen/home/home_screen.dart';
import 'package:multi_store_app_supplier/main_screen/store/stores_screen.dart';
import 'package:multi_store_app_supplier/main_screen/upload_product/upload_product_screen.dart';
import 'package:multi_store_app_supplier/services/notifications_services.dart';

class SuplierHomeScreen extends StatefulWidget {
  const SuplierHomeScreen({super.key});

  @override
  State<SuplierHomeScreen> createState() => _SuplierHomeScreenState();
}

class _SuplierHomeScreenState extends State<SuplierHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = [
    const HomeScreen(),
    const CategoryScreen(),
    const StoresScreen(),
    DashboardScreen(),
    const UploadProductScreen(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseMessaging.instance.getInitialMessage();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Supplier APP ///// Got Message Whilst in the Foreground');
      print('Supplier APP ///// Got Message Whilst in the Foreground ,title: ${message.notification!.title}');
      print('Supplier APP ///// Got Message Whilst in the Foreground ,title: ${message.notification!.body}');
      print('Supplier APP ///// Got Message Whilst in the Foreground ,data: ${message.data['key1']}');
      if (message.notification != null) {
        print('Message also Contained a notification: ${message.notification}');
        NotificationsServices.displayNotifications(message);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('sid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('delivery_status', isEqualTo: "preparing")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Scaffold(
          body: _tabs[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            elevation: 0,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.black,
            currentIndex: _selectedIndex,
            items: [
              const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: "Category"),
              const BottomNavigationBarItem(icon: Icon(Icons.shop), label: "Stores"),
              BottomNavigationBarItem(
                  icon: Badge(
                      isLabelVisible:
                          snapshot.data!.docs.isEmpty ? false : true,
                      padding: const EdgeInsets.all(2),
                      backgroundColor: Colors.teal,
                      label: Text(
                        snapshot.data!.docs.length.toString(),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      child: Icon(Icons.dashboard)),
                  label: "DashBoard"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.upload), label: "Upload"),
            ],
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        );
      },
    );
  }
}
