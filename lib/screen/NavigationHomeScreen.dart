// ignore_for_file: library_private_types_in_public_api, file_names, prefer_const_constructors, must_be_immutable


import 'package:client/entity/User.dart';
import 'package:client/module/CustomDrawer/DrawerUserController.dart';
import 'package:client/module/CustomDrawer/HomeDrawer.dart';
import 'package:client/screen/AppHomeScreen.dart';
import 'package:client/theme/AppTheme.dart';
import 'package:flutter/material.dart';

class NavigationHomeScreen extends StatefulWidget {
  User user;
  NavigationHomeScreen({super.key, required this.user});
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState(user:user);
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  late User user;
  Widget? screenView;
  DrawerIndex? drawerIndex;

  _NavigationHomeScreenState({required this.user});
  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = AppHomeScreen(user: user,);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.white,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      switch (drawerIndex) {
        case DrawerIndex.HOME:
          setState(() {
            screenView = AppHomeScreen(user: user,);
          });
          break;
        case DrawerIndex.FeedBack:
          setState(() {
            screenView = AppHomeScreen(user: user,);
          });
          break;
        default:
          break;
      }
    }
  }
}
