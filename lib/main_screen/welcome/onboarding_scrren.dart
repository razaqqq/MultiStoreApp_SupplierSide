import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Offer { menShirt, shoes, sale }

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Timer? countDownTimer;
  int seconds = 3;
  List<int> discountList = [];
  String supplierId = '';

  @override
  void initState() {
    startTimer();
    _prefs.then((SharedPreferences prefs) {
      return prefs.getString('supplier_id') ?? '';
    }).then((String value) {
      setState(() {
        supplierId = value;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void startTimer() {
    countDownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        seconds--;
      });
      if (seconds < 0) {
        stopTimer();
        supplierId != ''
            ? Navigator.pushReplacementNamed(context, '/supplier_home')
            : Navigator.pushReplacementNamed(context, '/supplier_login');
      }
    });
  }

  void stopTimer() {
    countDownTimer!.cancel();
  }

  Widget buildAsset() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Image.asset(
        'images/onboarding/nature_0.jpg',
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildAsset(),
          Positioned(
            top: 60,
            right: 30,
            child: Container(
              width: 100,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.5),
                borderRadius: BorderRadius.circular(25),
              ),
              child: MaterialButton(
                onPressed: () {
                  supplierId != ''
                      ? Navigator.pushReplacementNamed(
                          context, '/supplier_home')
                      : Navigator.pushReplacementNamed(
                          context, '/supplier_login');
                },
                child: seconds < 0 ? Text('Skip') : Text('Skip | $seconds'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
