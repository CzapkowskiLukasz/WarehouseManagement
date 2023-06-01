import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_application/utils/shared/colors.dart';
import 'package:mobile_application/utils/shared/numeric.dart';

void infoToast(String msg, FToast fToast) {
  Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius), color: infoColor),
      child: toastBody(msg, 'info'));

  showToast(toast, fToast);
}

void errorToast(String msg, FToast fToast) {
  Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: warningColor,
      ),
      child: toastBody(msg, 'error'));

  showToast(toast, fToast);
}

void showToast(Widget toast, FToast fToast) {
  fToast.showToast(
    child: toast,
    gravity: ToastGravity.TOP,
    toastDuration: const Duration(seconds: 5),
  );
}

Row toastBody(String msg, String type) {
  Icon icon;
  if (type == 'error') {
    icon = const Icon(Icons.cancel_outlined, color: Colors.white);
  } else {
    if (type == 'done') {
      icon = const Icon(Icons.check_circle_outline, color: Colors.white);
    } else {
      icon = const Icon(Icons.info_outline, color: Colors.white);
    }
  }
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      icon,
      const SizedBox(
        width: 12.0,
      ),
      Text(
        msg,
        style: const TextStyle(color: Colors.white),
      ),
    ],
  );
}

void doneToast(String msg, FToast fToast) {
  Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: const Color.fromRGBO(37, 154, 53, 1),
      ),
      child: toastBody(msg, 'done'));

  showToast(toast, fToast);
}
