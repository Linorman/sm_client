import 'package:client/pages/home.dart';
import 'package:client/pages/second.dart';
import 'package:client/pages/setting.dart';
import 'package:client/screen/Splash.dart';
import 'package:get/get.dart';

final routes = [
  GetPage(name: '/', page: () => const Splash()),
  GetPage(name: '/gpt', page: () => MyHomePage()),
  GetPage(name: '/second', page: () => const SecondPage()),
  GetPage(name: '/setting', page: () => SettingPage())
];
