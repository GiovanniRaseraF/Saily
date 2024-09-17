/*
author: Giovanni Rasera
at: Huracan Marine s.r.l.
*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/widgets/microdivider_widget.dart';

class ExpandableTile extends StatefulWidget {
  ExpandableTile({
    required this.collapsed,
    required this.expanded,
    required this.header,
    required this.expandedatstart,
    required this.settingsController,
  });

  Widget collapsed;
  Widget expanded;
  Text header;
  bool expandedatstart;

  SettingsController settingsController;

  @override
  State<ExpandableTile> createState() => _ExpandableTileState(
      collapsed: collapsed,
      expanded: expanded,
      header: header,
      expandedatstart: expandedatstart,
      settingsController: settingsController,
      );
}

class _ExpandableTileState extends State<ExpandableTile> {
  _ExpandableTileState({
    required this.collapsed,
    required this.expanded,
    required this.header,
    required this.expandedatstart,
    required this.settingsController,
  }) {
    nowexpanded = expandedatstart;
  }

  SettingsController settingsController;
  Widget collapsed;
  Widget expanded;
  Text header;
  bool expandedatstart;
  bool nowexpanded = false;

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
                    GestureDetector(
                        child: Card(
                            child: Icon(
                          Icons.arrow_downward,
                          color: Colors.blue,
                          size: 40,
                        )),
                        onTap: () {
                          settingsController.setExpandedTileValue(false);
                        }),
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
                    GestureDetector(
                        child: Card(
                            child: Icon(Icons.arrow_upward,
                                color: Colors.blue, size: 40)),
                        onTap: () {
                          settingsController.setExpandedTileValue(true);
                        }),
                  ],
                ),

                // swipe
                GestureDetector(
                  child: collapsed,
                  onVerticalDragUpdate: (details) {
                    int sensitivity = 10;
                    if (details.delta.dy < -sensitivity) {
                        // Down Swipe
                        settingsController.setExpandedTileValue(true);
                    }                   
                  }
                )
              ],
            );
          }
        });
  }
}
