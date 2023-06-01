import 'package:flutter/material.dart';

import 'colors.dart';

TextStyle? todayTextStyle = TextStyle(
  foreground: Paint()
    ..shader = mainGradient.createShader(
      const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0),
    ),
);

Text getText(String text, TextStyle? textStyle) {
  return Text(text, style: textStyle);
}

Text getMainHeader(String text, BuildContext context) {
  return Text(
    text,
    style: Theme.of(context).primaryTextTheme.headline1,
  );
}

Text getMediumHeader(String text, BuildContext context) {
  return Text(
    text,
    style: Theme.of(context).primaryTextTheme.headline2,
  );
}

Text getCardHeaderSmall(String text, BuildContext context) {
  return Text(
    text,
    style: Theme.of(context).primaryTextTheme.headline4,
  );
}

Text getCardHeader(String text, BuildContext context) {
  return Text(
    text,
    style: Theme.of(context).primaryTextTheme.headline3,
  );
}

Text getMainText(String text, BuildContext context) {
  return Text(
    text,
    style: Theme.of(context).primaryTextTheme.caption,
  );
}

Text getMainTextCentered(String text, BuildContext context) {
  return Text(
    text,
    style: Theme.of(context).primaryTextTheme.caption,
    textAlign: TextAlign.center,
  );
}

Text getCardBodyText(String text, BuildContext context) {
  return Text(
    text,
    style: Theme.of(context).primaryTextTheme.subtitle1,
  );
}

Text getCardBodyBigger(String text, BuildContext context) {
  return Text(
    text,
    style: Theme.of(context).primaryTextTheme.subtitle2,
  );
}

Text getCardBodyTextCenter(String text, BuildContext context) {
  return Text(
    text,
    style: Theme.of(context).primaryTextTheme.subtitle1,
    textAlign: TextAlign.center,
  );
}

Text getCardLabel(String text, BuildContext context) {
  return Text(
    text,
    style: Theme.of(context).primaryTextTheme.headline5,
  );
}

Text getCardLabelLarge(String text, BuildContext context) {
  return Text(text, style: Theme.of(context).primaryTextTheme.bodyText2);
}

TextTheme getDarkTheme() {
  return TextTheme(
      bodyText2: headerStyle(14, Colors.white),
      headline1: headerStyle(24, Colors.white),
      headline2: headerStyle(18, Colors.white),
      headline3: headerStyle(18, Colors.white),
      headline4: headerStyle(14, Colors.white),
      headline5: headerStyle(11, Colors.white),
      caption: basicStyle(16, Colors.white),
      subtitle1: basicStyle(11, Colors.white),
      subtitle2: basicStyle(13, Colors.white));
}

TextTheme getLightTheme() {
  return TextTheme(
      bodyText2: headerStyle(14, grey),
      headline1: headerStyle(24, grey),
      headline2: headerStyle(18, grey),
      headline3: headerStyle(18, grey),
      headline4: headerStyle(14, grey),
      headline5: headerStyle(11, grey),
      caption: basicStyle(16, grey),
      subtitle1: basicStyle(11, grey),
      subtitle2: basicStyle(13, grey));
}

TextStyle? headerStyle(double fontSize, Color color) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: FontWeight.bold,
    color: color,
  );
}

TextStyle? basicStyle(double fontSize, Color color) {
  return TextStyle(
    fontSize: fontSize,
    color: color,
  );
}
