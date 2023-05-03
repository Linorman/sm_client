// ignore_for_file: file_names, library_private_types_in_public_api, non_constant_identifier_names, prefer_const_constructors, unused_element, unnecessary_new, prefer_const_constructors_in_immutables, await_only_futures, avoid_print, unused_import, use_build_context_synchronously

import 'dart:ui';

import 'package:client/entity/User.dart';
import 'package:client/module/UserTextField.dart';
import 'package:dio/dio.dart';
import 'package:client/screen/NavigationHomeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:client/constant/ServerConstants.dart';
import 'HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _MyLoginScreen createState() => _MyLoginScreen();
}

class _MyLoginScreen extends State<LoginScreen> with WidgetsBindingObserver {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late User user;

  // 软键盘高度
  double _keyboardHeight = 0;

  // 可控制ListView滑动
  final _scrollController = ScrollController();

  // 用于获取目标Widget的位置坐标
  final _targetWidgetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // 添加监听，didChangeMetrics
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    // 获取页面高度
    var pageHeight = MediaQuery.of(context).size.height;
    if (pageHeight <= 0) {
      return;
    }

    // 软键盘顶部  px
    final keyboardTopPixels =
        window.physicalSize.height - window.viewInsets.bottom;
    // 转换为 dp
    final keyboardTopPoints = keyboardTopPixels / window.devicePixelRatio;
    // 软键盘高度
    final keyboardHeight = pageHeight - keyboardTopPoints;

    setState(() {
      _keyboardHeight = keyboardHeight;
    });
    if (keyboardHeight <= 0) {
      return;
    }
    // 获取目标位置的坐标
    RenderBox? renderBox =
        _targetWidgetKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return;
    }
    // 转换为全局坐标
    final bottomOffset =
        renderBox.localToGlobal(Offset(0, renderBox.size.height));
    final targetDy = bottomOffset.dy;
    // 获取要滚动的距离
    // 即被软键盘挡住的那段距离 加上 _scrollController.offset 已经滑动过的距离
    final offsetY =
        keyboardHeight - (pageHeight - targetDy) + _scrollController.offset;
    // 滑动到指定位置
    if (offsetY > 0) {
      _scrollController.animateTo(
        offsetY,
        duration: kTabScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  void _LoginHandler() async {
    if (userController.text.isEmpty || passwordController.text.isEmpty) {
      return;
    }
    try {
      final response = await Dio().post(LOGIN_URL, data: {
        'username': userController.text,
        'password': passwordController.text
      });
      print(response.data);
      if (response.data['code'] == "3000") {
        user = User.fromJson(response.data);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NavigationHomeScreen(user: user)),
        );
      } else {
        _showAlertDialog(response.data['msg']);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _showAlertDialog(String msg) async {
    setState(() {
      showDialog(
          // 设置点击 dialog 外部不取消 dialog，默认能够取消
          context: context,
          builder: (context) => AlertDialog(
                title: Text('提示'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                icon: new Icon(Icons.error),
                titleTextStyle: TextStyle(color: Colors.red),
                content: Text(msg),
                contentTextStyle: TextStyle(color: Colors.black),
                backgroundColor: CupertinoColors.white,
                elevation: 8.0,
                semanticLabel: 'Label',
                actions: <Widget>[
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK')),
                ],
              ));
    });
    userController.clear();
    passwordController.clear();
  }

  Future<void> _openNewPage() async {
    userController.clear();
    passwordController.clear();

    setState(() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (BuildContext context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: NavigationHomeScreen(
            user: user,
          ),
        );
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                controller: _scrollController,
                children: [
                  SafeArea(
                    child: Align(alignment: Alignment.centerRight, child: null),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 350,
                      height: 350,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: UserTextField(
                      controller: userController,
                      keyboardType: TextInputType.text,
                      placeholder: '请输入用户名',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: UserTextField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      usedInPassword: true,
                      placeholder: '请输入密码',
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  CupertinoButton(
                    padding: const EdgeInsets.all(16),
                    onPressed: _LoginHandler,
                    child: Container(
                      height: 44,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(22)),
                      ),
                      child: const Text(
                        '登录',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: _keyboardHeight)
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
