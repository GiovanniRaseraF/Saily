import 'package:flutter/material.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/utils/saily_utils.dart';

class FractBox extends StatelessWidget{
  FractBox({hscale, wscale, child, required this.c});

  double hscale = 1;
  double wscale = 1;
  Widget child = Card(color: SailySuperRed,);
  BuildContext c;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ctxH(c) * hscale,
      width: ctxW(c) * wscale,
        child: Card(
          color: SailySuperGreen,
        ),
    );
  }
}