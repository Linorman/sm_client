// ignore_for_file: file_names, no_logic_in_create_state

import 'package:flutter/material.dart';

//封装 通用局部刷新工具类
//定义函数别名
// typedef BuildWidget = Widget Function();

class PartRefreshWidget extends StatefulWidget {
  const PartRefreshWidget(Key key, this._child) : super(key: key);
  final Widget _child;

  @override
  State<StatefulWidget> createState() {
    return PartRefreshWidgetState(_child);
  }
}


class PartRefreshWidgetState extends State<PartRefreshWidget> {
  Widget child;

  PartRefreshWidgetState(this.child);

  @override
  Widget build(BuildContext context) {
    return child;
  }

  void update() {
    print('update');
    setState(() {});
  }
}