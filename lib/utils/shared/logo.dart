import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mobile_application/utils/shared/text.dart';

Widget getLogo() {
  return Column(
    children: [
      const Icon(
        LineIcons.boxOpen,
        size: 70,
        color: Colors.white,
      ),
      getText('ZMPI', cardHeaderStyle(30, Colors.white)),
    ],
  );
}

TextStyle? cardHeaderStyle(double fontSize, Color color) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: FontWeight.bold,
    color: color,
  );
}
