import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app_supplier/main_screen/suplier_home_screen.dart';
import 'package:multi_store_app_supplier/services/notifications_services.dart';
import 'auth/suplier_sign_up.dart';
import 'auth/supplier_login.dart';
import 'main_screen/welcome/onboarding_scrren.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(
      "Supplier APP ///// Handling a Background Message: ${message.messageId}");
  print(
      "Supplier APP /////  Handling a Background Message: ${message.notification!.title}");
  print(
      "Supplier APP ///// Handling a Background Message: ${message.notification!.body}");

  if (message.data.isNotEmpty) {
    if (message.data['key1'] != null) {
      print(
          "Supplier APP ///// Handling a Background Message: ${message.data['key1']}");
    } else if (message.data['key2'] != null) {
      print(
          "Supplier APP ///// Handling a Background Message: ${message.data['key2']}");
    } else if (message.data['key3'] != null) {
      print(
          "Supplier APP ///// Handling a Background Message: ${message.data['key3']}");
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  NotificationsServices.createNotificationChannelAndInitialize();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/onboarding_screen',
      routes: {
        '/onboarding_screen': (context) => const OnBoardingScreen(),
        '/supplier_home': (context) => const SuplierHomeScreen(),
        '/supplier_signup': (context) => const SuplierSignUp(),
        '/supplier_login': (context) => const SupplierLogin()
      },
    );
  }
}
