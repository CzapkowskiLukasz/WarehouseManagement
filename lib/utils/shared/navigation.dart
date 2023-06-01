import 'package:flutter/material.dart';

void moveToNewCleanPage(BuildContext context, Widget page, bool isLogout) {
  // if (isLogout) {
  //   UserManagement userManagement = UserManagement();
  //   userManagement.logout();
  // }
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => page));
}

void removeLast(BuildContext context) {
  Navigator.of(context).pop();
}

void moveToPage(BuildContext context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
}

void moveToNewCleanPageWithoutAnimation(BuildContext context, Widget page) {
  Navigator.pushReplacement(
      context,
      PageRouteBuilder(
          opaque: false,
          maintainState: false,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(seconds: 0)));
}
