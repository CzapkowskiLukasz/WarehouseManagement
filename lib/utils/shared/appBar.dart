import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mobile_application/DAL/managers/themeProvider.dart';
import 'package:mobile_application/DAL/managers/userManagement.dart';
import 'package:mobile_application/utils/shared/colors.dart';
import 'package:mobile_application/utils/shared/navigation.dart';
import 'package:mobile_application/utils/shared/numeric.dart';
import 'package:mobile_application/views/introduction.dart';
import 'package:provider/provider.dart';

import '../../views/loginPage.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool shouldSeeArrow;

  const BaseAppBar({Key? key, required this.shouldSeeArrow}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: shouldSeeArrow
          ? IconButton(
              icon: iconGradientMask(mainGradient, Icons.arrow_back),
              onPressed: (() => Navigator.of(context).pop()),
            )
          : IconButton(
              icon: Icon(Icons.arrow_back, color: backgroundColor),
              onPressed: (() {}),
            ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: edgePadding),
          child: GestureDetector(
              onTap: () {
                Platform.isAndroid
                    ? showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                title: Text(isDarkMode(context)),
                                onTap: () {
                                  changeTheme(context);
                                  removeLast(context);
                                },
                              ),
                              ListTile(
                                title: const Text("Wyloguj się"),
                                onTap: () {
                                  final UserManagement userManagement =
                                      UserManagement();
                                  userManagement.logout();
                                  moveToNewCleanPage(
                                      context, const LoginPage(), true);
                                },
                              ),
                              ListTile(
                                title: const Text("Cofnij"),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        })
                    : showCupertinoModalPopup(
                        context: context, builder: cupertinoModalPopup);
              },
              child: iconGradientMaskWithSize(mainGradient, LineIcons.cog, 30)),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void changeTheme(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context, listen: false);
    themeChange.darkTheme = !themeChange.darkTheme;
  }

  String isDarkMode(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context, listen: false);
    if (themeChange.darkTheme == true) {
      return "Tryb jasny";
    } else {
      return "Tryb ciemny";
    }
  }

  Widget cupertinoModalPopup(BuildContext context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
              onPressed: () {
                changeTheme(context);
                removeLast(context);
              },
              child: Text(isDarkMode(context))),
          CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () async {
                final UserManagement userManagement = UserManagement();
                await userManagement.logout();
                moveToNewCleanPage(context, const OnBoardingPage(), true);
              },
              child: const Text("Wyloguj się")),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          child: const Text("Cofnij"),
          onPressed: () {
            removeLast(context);
          },
        ),
      );
}
