// ignore_for_file: file_names, prefer_const_literals_to_create_immutables, prefer_const_constructors, await_only_futures

import 'package:client/constant/ServerConstants.dart';
import 'package:client/theme/AppTheme.dart';
import 'package:client/ui/HexColor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theme/HomePageTheme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<DataRow> listTemp = <DataRow>[];
  List<DataRow> listWater = <DataRow>[];
  List<DataRow> listLux = <DataRow>[];
  final ScrollController scrollController = ScrollController();

  void addData() async {
    try {
      final response = await Dio().get(DATA_GET_ALL_URL);
      setState(() {
        if (response.data['code'] == "800") {
          List<dynamic> data = response.data['data'];
          for (int i = 0; i < data.length; i++) {
            for (int j = 0; j < data[i].length; j++) {
              if (data[i][j]['type'] == 'temperature') {
                listTemp.add(DataRow(cells: [
                  DataCell(Text(data[i][j]['deviceId'].toString())),
                  DataCell(Text(data[i][j]['createTime'].toString())),
                  DataCell(Text(data[i][j]['value'].toString())),
                ]));
              } else if (data[i][j]['type'] == 'humidity') {
                listWater.add(DataRow(cells: [
                  DataCell(Text(data[i][j]['deviceId'].toString())),
                  DataCell(Text(data[i][j]['createTime'].toString())),
                  DataCell(Text(data[i][j]['value'].toString())),
                ]));
              } else if (data[i][j]['type'] == 'illumination') {
                listLux.add(DataRow(cells: [
                  DataCell(Text(data[i][j]['deviceId'].toString())),
                  DataCell(Text(data[i][j]['createTime'].toString())),
                  DataCell(Text(data[i][j]['value'].toString())),
                ]));
              }
            }
          }
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    addData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: AppTheme.notWhite,
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              '历史数据',
              style: TextStyle(
                fontFamily: HomePageTheme.fontName,
                fontWeight: FontWeight.w700,
                fontSize: 23,
                letterSpacing: 1.2,
                color: HomePageTheme.darkerText,
              ),
            ),
            backgroundColor: AppTheme.notWhite,
            foregroundColor: AppTheme.notWhite,
            shadowColor: AppTheme.notWhite,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "温度",
                style: TextStyle(
                  fontFamily: HomePageTheme.fontName,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  letterSpacing: 1.2,
                  color: HomePageTheme.darkerText,
                ),
              ),
              Flexible(
                child: DataTable(
                  sortAscending: true, // 开启升序排序
                  showCheckboxColumn: true, // 显示复选框列
                  columns: [
                    DataColumn(label: Text('机器编号')),
                    DataColumn(label: Text('时间')),
                    DataColumn(label: Text('数据')),
                  ],
                  rows: listTemp,
                ),
              ),
              Text(
                "湿度",
                style: TextStyle(
                  fontFamily: HomePageTheme.fontName,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  letterSpacing: 1.2,
                  color: HomePageTheme.darkerText,
                ),
              ),
              Flexible(
                child: DataTable(
                  sortAscending: true, // 开启升序排序
                  showCheckboxColumn: true, // 显示复选框列
                  columns: [
                    DataColumn(label: Text('机器编号')),
                    DataColumn(label: Text('时间')),
                    DataColumn(label: Text('数据')),
                  ],
                  rows: listWater,
                ),
              ),
              Text(
                "光照",
                style: TextStyle(
                  fontFamily: HomePageTheme.fontName,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  letterSpacing: 1.2,
                  color: HomePageTheme.darkerText,
                ),
              ),
              Flexible(
                child: DataTable(
                  sortAscending: true, // 开启升序排序
                  showCheckboxColumn: true, // 显示复选框列
                  columns: [
                    DataColumn(label: Text('机器编号')),
                    DataColumn(label: Text('时间')),
                    DataColumn(label: Text('数据')),
                  ],
                  rows: listLux,
                ),
              ),
            ],
          )),
    );
  }
}
