import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class UserManagementInterface {
  Future<bool> login(String phoneNumber, String password, BuildContext context);

  Future<bool> logout();

  Future<String?> isLogged();

  Future<bool?> isIntroShown();

  Future<bool> resetPassword(String phoneNumber, FToast fToast);

  Future<void> introShown();
}
