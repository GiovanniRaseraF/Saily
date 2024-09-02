/*
author: Giovanni Rasera
at: Huracan Marine s.r.l.
*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:saily/settings/settings_controller.dart';

class ExpandableTile extends StatefulWidget {
  ExpandableTile({
    required this.collapsed,
    required this.expanded,
    required this.header,
    required this.expandedatstart,
    required this.settingsController,
    required this.leftTopComponent,
    required this.rightTopComponent,
  });

  Widget collapsed;
  Widget expanded;
  Text header;
  bool expandedatstart;

  Widget leftTopComponent;
  Widget rightTopComponent;

  SettingsController settingsController;

  @override
  State<ExpandableTile> createState() => _ExpandableTileState(
      collapsed: collapsed,
      expanded: expanded,
      header: header,
      expandedatstart: expandedatstart,
      settingsController: settingsController,
      leftTopComponent: leftTopComponent,
      rightTopComponent: rightTopComponent);
}

class _ExpandableTileState extends State<ExpandableTile> {
  _ExpandableTileState({
    required this.collapsed,
    required this.expanded,
    required this.header,
    required this.expandedatstart,
    required this.settingsController,
    required this.leftTopComponent,
    required this.rightTopComponent,
  }) {
    nowexpanded = expandedatstart;
  }

  SettingsController settingsController;
  Widget collapsed;
  Widget expanded;
  Text header;
  bool expandedatstart;
  bool nowexpanded = false;

  Widget leftTopComponent;
  Widget rightTopComponent;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext c) {
    return StreamBuilder(
        stream: settingsController.getExpandTileStream(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
          } else {
            nowexpanded = snapshot.data!;
          }

          if (nowexpanded) {
            print("reprint expanded");

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    leftTopComponent,
                    GestureDetector(
                        child: Card(
                            child: Icon(
                          Icons.arrow_downward,
                          color: Colors.blue,
                          size: 30,
                        )),
                        onTap: () {
                          settingsController.setExpandedTileValue(false);
                        }),
                    rightTopComponent
                  ],
                ),
                expanded,
              ],
            );
          } else {
            print("reprint not expanded");
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    leftTopComponent,
                    GestureDetector(
                        child: Card(
                            child: Icon(Icons.arrow_upward,
                                color: Colors.blue, size: 40)),
                        onTap: () {
                          settingsController.setExpandedTileValue(true);
                        }),
                    rightTopComponent,
                  ],
                ),
                collapsed
              ],
            );
          }
        });
  }
}
