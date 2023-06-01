import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

SvgPicture getSvgWidth(String assetName, Color color, double width) {
  return SvgPicture.asset(
    assetName,
    color: color,
    width: width,
  );
}

SvgPicture getSvg(String assetName, double width) {
  return SvgPicture.asset(
    assetName,
    width: width,
  );
}

SvgPicture getSvgStaticHeight(String assetName, Color color, double height) {
  return SvgPicture.asset(
    assetName,
    color: color,
    height: height,
  );
}
