// ignore_for_file: unnecessary_new, unused_import, library_private_types_in_public_api, file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dart:async';
import 'LoginScreen.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Scaffold(
        body: new Stack(
          children: <Widget>[
            Center(
              child: new Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.fill,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    countDown();
  }

  void countDown() {
    var duration = const Duration(seconds: 2);
    new Future.delayed(duration, newHomePage);
  }

  void newHomePage() async {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800), // //动画时间为0.25秒
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation secondaryAnimation) {
          return FadeTransition(
            //渐隐渐入过渡动画
            opacity: animation,
            child: const LoginScreen(),
          );
        }));
  }
}
