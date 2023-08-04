// ignore_for_file: library_private_types_in_public_api, file_names, non_constant_identifier_names, avoid_print, await_only_futures

import 'dart:async';

import 'package:client/entity/User.dart';
import 'package:client/module/SensorData.dart';
import 'package:client/screen/HistoryScreen.dart';
import 'package:client/theme/HomePageTheme.dart';
import 'package:client/ui/DataView.dart';
import 'package:client/ui/TittleView.dart';
import 'package:client/ui/WaterView.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../constant/ServerConstants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, this.animationController, required this.user})
      : super(key: key);

  final AnimationController? animationController;
  final User user;

  @override
  _HomeScreenState createState() => _HomeScreenState(user: user);
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  GlobalKey<DataViewState> globalKey_data = GlobalKey();
  GlobalKey<WaterViewState> globalKey_water = GlobalKey();

  // ignore: prefer_final_fields
  late User user;
  Animation<double>? topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  _HomeScreenState({required this.user});

  void recvData() async {
    try {
      final response = await Dio().get(
        DATA_GET_URL,
      );
      if (response.data['code'] == "800") {
        bool isUpdate = false;
        double tempTemp = tmp;
        double tempWater = water;
        double tempLux = lux;
        List<dynamic> data = response.data['data'];
        for (int i = 0; i < data.length; i++) {
          if (data[i]['type'] == 'temperature') {
            if (tmp != double.parse(data[i]['value'].toString())) {
              tempTemp = double.parse(data[i]['value'].toString());
            }
          } else if (data[i]['type'] == 'humidity') {
            if (water != double.parse(data[i]['value'].toString())) {
              tempWater = double.parse(data[i]['value'].toString());
              isUpdate = true;
            }
          } else if (data[i]['type'] == 'illumination') {
            if (lux != double.parse(data[i]['value'].toString())) {
              tempLux = double.parse(data[i]['value'].toString());
            }
          }
          change(
            tempTemp,
            tempWater,
            tempLux,
          );
          globalKey_data.currentState!.update();
          if (isUpdate) {
            globalKey_water.currentState!.update();
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void gotoHistory() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HistoryScreen()),
    );
  }

  @override
  void initState() {
    Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      recvData();
    });
    if (!timer.isActive) {
      timer.cancel();
    }
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: const Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  void addAllListData() {
    const int count = 9;

    listViews.add(
      TitleView(
        titleTxt: '数据面板',
        subTxt: '历史',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve: const Interval((1 / count) * 0, 1.0,
                curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
        onTap: gotoHistory,
      ),
    );
    listViews.add(
      DataView(
        globalKey_data,
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve: const Interval((1 / count) * 1, 1.0,
                curve: Curves.fastOutSlowIn))),
        widget.animationController!,
      ),
    );
    listViews.add(
      WaterView(
        key: globalKey_water,
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController!,
                curve: const Interval((1 / count) * 2, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController!,
      ),
    );
    listViews.add(
      // 创建一个方形按钮来将路由跳转至'/gpt'
      Container(
        margin: const EdgeInsets.only(top: 20),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/gpt');
          },
          child: const Text('聊一聊'),
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HomePageTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController?.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: HomePageTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: HomePageTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '控制台',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: HomePageTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: HomePageTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
