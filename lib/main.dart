// ignore_for_file: unnecessary_new, unused_import, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/screen/Splash.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(ClientApp()));
}

class ClientApp extends StatelessWidget {
  const ClientApp({super.key});

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      initialRoute: "/",

      debugShowCheckedModeBanner: false,
      title: "智农",
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Splash(),
    );
  }
}