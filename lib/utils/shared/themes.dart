import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_application/utils/shared/colors.dart';
import 'package:mobile_application/utils/shared/text.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
        primaryTextTheme: isDarkTheme ? getDarkTheme() : getLightTheme(),
        dividerColor: isDarkTheme ? Colors.white : darkGrey,
        buttonColor: isDarkTheme ? backgroundColor : grey,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor:
                isDarkTheme ? const Color(0xff1A1A1C) : Colors.white),
        primaryColor: isDarkTheme ? Colors.black : Colors.white,
        backgroundColor: isDarkTheme ? Colors.black : backgroundColor,
        indicatorColor: isDarkTheme ? Colors.grey[400] : darkGrey,
        hintColor: isDarkTheme ? const Color(0xff1A1A1C) : Colors.white,
        highlightColor:
            isDarkTheme ? const Color(0xff372901) : const Color(0xffFCE192),
        hoverColor:
            isDarkTheme ? const Color(0xff3A3A3B) : const Color(0xff4285F4),
        focusColor:
            isDarkTheme ? const Color(0xff0B2512) : const Color(0xffA8DAB5),
        disabledColor: Colors.grey,
        cardColor: isDarkTheme ? const Color(0xFF505055) : Colors.white,
        canvasColor: isDarkTheme ? Colors.black : backgroundColor,
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
            colorScheme: isDarkTheme
                ? const ColorScheme.dark()
                : const ColorScheme.light()),
        appBarTheme: AppBarTheme(
          systemOverlayStyle: isDarkTheme
              ? const SystemUiOverlayStyle(
                  statusBarIconBrightness: Brightness.light,
                  statusBarBrightness: Brightness.dark)
              : const SystemUiOverlayStyle(
                  statusBarIconBrightness: Brightness.light,
                  statusBarBrightness: Brightness.light),
        ));
  }
}
