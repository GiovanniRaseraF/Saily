/*
author: Giovanni Rasera
*/

import 'package:flutter/material.dart';

class MicrodividerWidgetd extends StatelessWidget {
  MicrodividerWidgetd({required this.height});
  double height;

  @override
  Widget build(BuildContext c) {
    return SizedBox(
      width: 10,
      height: height,
      child: Card(
        color: Colors.black,
      ),
    );
  }
}

class Div extends Divider{
  Div(this.color, this.height) : super(color : color, height : height){
  }
  Color color = Colors.transparent;
  double height = 10;

  @override
  Widget build(BuildContext c) {
    return super.build(c);
  }
}
