import 'package:flutter/material.dart';
import 'package:mobile_application/utils/shared/colors.dart';
import 'package:mobile_application/utils/shared/numeric.dart';
import 'package:mobile_application/utils/shared/text.dart';

SizedBox sheetHeader(BuildContext context, String header) {
  return SizedBox(
    width: getWidth(context),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: containerPadding),
              child: Container(
                width: 30,
                height: 5,
                decoration: BoxDecoration(
                    gradient: mainGradient,
                    borderRadius:
                        BorderRadius.all(Radius.circular(borderRadius))),
              ),
            ),
            getText(header, cardBasicTextStyle(16, grey)),
          ],
        ),
      ],
    ),
  );
}

SizedBox collapseHeader(BuildContext context, String header) {
  return SizedBox(
    width: getWidth(context),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: containerPadding),
              child: Container(
                width: 30,
                height: 5,
                decoration: BoxDecoration(
                    color: grey,
                    borderRadius:
                        BorderRadius.all(Radius.circular(borderRadius))),
              ),
            ),
            getText(header, cardBasicTextStyle(16, grey)),
          ],
        ),
      ],
    ),
  );
}

EdgeInsets sheetPadding() {
  return const EdgeInsets.only(
      right: edgePadding,
      left: edgePadding,
      top: 60,
      bottom: containerPadding - 6);
}

TextStyle? cardBasicTextStyle(double fontSize, Color color) {
  return TextStyle(
    fontSize: fontSize,
    color: color,
  );
}
