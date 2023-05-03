// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:client/screen/HomeScreen.dart';
import 'package:client/theme/HomePageTheme.dart';
import 'package:flutter/material.dart';

import '../entity/User.dart';

class AppHomeScreen extends StatefulWidget {
  User user;

  AppHomeScreen({super.key, required this.user});

  @override
  _AppHomeScreenState createState() => _AppHomeScreenState(user: user);
}

class _AppHomeScreenState extends State<AppHomeScreen>
    with TickerProviderStateMixin {
  User user;
  AnimationController? animationController;

  Widget tabBody = Container(
    color: HomePageTheme.background,
  );

  _AppHomeScreenState({required this.user});

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = HomeScreen(animationController: animationController, user: user,);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HomePageTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Container(
                child: tabBody,
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }
}
