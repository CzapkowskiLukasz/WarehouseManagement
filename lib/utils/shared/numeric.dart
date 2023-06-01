import 'package:flutter/material.dart';

double appBarSize = (AppBar().preferredSize.height) * 2;
const double edgePadding = 10;

const double containerPadding = 10;

double borderRadius = 15;

double getWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

EdgeInsets paddingEdge = const EdgeInsets.symmetric(horizontal: edgePadding);
