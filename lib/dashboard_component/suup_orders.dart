import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app_supplier/dashboard_component/supplier_order_tabbar_view/preparing_tabbar_view_temp.dart';
import 'package:multi_store_app_supplier/dashboard_component/supplier_order_tabbar_view/delivered_tabbar_view.dart';
import 'package:multi_store_app_supplier/dashboard_component/supplier_order_tabbar_view/shipping_tabbar_view.dart';
import 'package:multi_store_app_supplier/widgets/appbar_widgets.dart';

class SupliyerOrders extends StatelessWidget {
  const SupliyerOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const AppBarTitle(title: "Supliyer Orders", color: Colors.black,),
          leading: const AppBarBackButton(
            color: Colors.black,
          ),
          bottom: const TabBar(
            indicatorColor: Colors.teal,
            indicatorWeight: 8,
            tabs: [
              RepeatedTab(label: 'Preparing'),
              RepeatedTab(label: 'Shipping'),
              RepeatedTab(label: 'Delivering'),
            ],
          ),
        ),
        body: TabBarView(children: [
          Preparing(),
          Shipping(),
          Delivering(),
        ]),
      ),
    );
  }
}

class RepeatedTab extends StatelessWidget {
  const RepeatedTab({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Tab(child: Center(child: Text(label),),);
  }
}

