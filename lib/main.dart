import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "mainpage.dart";
import "login.dart";
import "test.dart";
import "newuser.dart";
import 'addcontact.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'profile.dart';
import 'fullscreen.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.wanderingCubes
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.white
      ..backgroundColor = Colors.blue
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = false
      ..dismissOnTap = false;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      routes: {
        "/add": (context) => AddContact(),
        "/newuser": (context) => NewUser(),
        "/test": (context) => MsgScreen(),
        "/": (context) => Login(),
        "/main": (context) => Mainpage(),
        '/profile': (context) => Profile(),
        '/fullscreen': (context) => FullScreen()
      },
      initialRoute: "/",
      builder: EasyLoading.init(),
    );
  }
}
