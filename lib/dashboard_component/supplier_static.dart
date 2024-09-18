import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_store_app_supplier/widgets/appbar_widgets.dart';

class StaticScreen extends StatelessWidget {
  const StaticScreen({super.key});

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
        num itemCount = 0;

        for (var item in snapshot.data!.docs) {
          itemCount += item['order_qty'];
        }

        double totalPrice = 0.0;

        for (var item in snapshot.data!.docs) {
          totalPrice += item['order_qty'] * item['order_price'];
        }

        return Scaffold(
          appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              title: const AppBarTitle(title: "Static", color: Colors.black,),
              leading: const AppBarBackButton(
                color: Colors.black,
              )),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StaticModel(
                  label: 'Sold Out',
                  value: snapshot.data!.docs.length.toString(),
                  decimal: 0,
                ),
                StaticModel(
                  label: 'Item Count',
                  value: itemCount,
                  decimal: 0,
                ),
                StaticModel(
                  label: 'Total Balance',
                  value: totalPrice,
                  decimal: 2,
                  iconWidget: const Icon(FontAwesomeIcons.dollarSign, color: Colors.red,),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}



class StaticModel extends StatelessWidget {
  const StaticModel({super.key, required this.label, required this.value, required this.decimal, this.iconWidget});

  final String label;
  final dynamic value;
  final int decimal;
  final Widget? iconWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          width: MediaQuery.of(context).size.width * 0.55,
          decoration: const BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(15),
              )),
          child: Center(
            child: Text(
              label.toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
        Container(
          height: 90,
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
              color: Colors.blueGrey.shade100,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(15),
              )),
          child: Row(
            children: [
              AnimatedCounter(value:  value, decimal: decimal),
              iconWidget != null ? iconWidget! : const SizedBox()
            ],
          ),
        ),
      ],
    );
  }
}

class AnimatedCounter extends StatefulWidget {
  const AnimatedCounter({super.key, required this.value, required this.decimal});

  final dynamic value;
  final int decimal;

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 20));
    _animation = _animationController;
    setState(() {
      _animation =
          Tween(begin: _animation.value, end: widget.value).animate(_animationController);
    });
    _animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Center(
          child: Text(
            _animation.value.toStringAsFixed(widget.decimal),
            style: const TextStyle(
                color: Colors.pink,
                fontSize: 40,
                fontFamily: 'Acme',
                fontWeight: FontWeight.bold,
                letterSpacing: 2),
          ),
        );
      },
    );
  }
}
