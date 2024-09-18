
import 'package:flutter/material.dart';
import 'package:multi_store_app_supplier/galleries/accesories_gallery.dart';
import 'package:multi_store_app_supplier/galleries/bag_gallery.dart';
import 'package:multi_store_app_supplier/galleries/beauty_gallery.dart';
import 'package:multi_store_app_supplier/galleries/electroic_gallery.dart';
import 'package:multi_store_app_supplier/galleries/homeandgarden_gallery.dart';
import 'package:multi_store_app_supplier/galleries/kids_gallery.dart';
import 'package:multi_store_app_supplier/galleries/men_gallery.dart';
import 'package:multi_store_app_supplier/galleries/shoes_gallery.dart';
import 'package:multi_store_app_supplier/galleries/woman_gallery.dart';

import '../../widgets/fake_search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 9,
        child: Scaffold(
          backgroundColor: Colors.blueGrey.shade100.withOpacity(0.5),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const FakeSearch(),
            bottom: const TabBar(
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Colors.yellow,
              indicatorWeight: 8,
              tabs: [
                RepeatedTab(tabName: "Mens"),
                RepeatedTab(tabName: "Women"),
                RepeatedTab(tabName: "Shoes"),
                RepeatedTab(tabName: "Bags"),
                RepeatedTab(tabName: "Electronics"),
                RepeatedTab(tabName: "Accesories"),
                RepeatedTab(tabName: "Home and Garden"),
                RepeatedTab(tabName: "Kids"),
                RepeatedTab(tabName: "Beuty"),
              ],
            ),
          ),
          body: const TabBarView(children: [
            MenGalleryScreen(),
            WomanGalleryScreen(),
            ShoesGalleryScreen(),
            BagGalleryScreen(),
            ElectronicGalleryScreen(),
            AccesoriesGalleryScreen(),
            HomeGardenGalleryScreen(),
            KidsGardenGalleryScreen(),
            BeautyGalleryScreen(),
          ],),
        ));
  }
  
  
  
}



class RepeatedTab extends StatelessWidget {
  final String tabName;
  const RepeatedTab({super.key, required this.tabName});

  @override
  Widget build(BuildContext context) {
    return Tab(child: Text(tabName, style: TextStyle(color: Colors.grey.shade600, ),),);
  }
}

