import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_application/DAL/api.dart';
import 'package:mobile_application/DAL/interfaces/userManagementInterface.dart';
import 'package:mobile_application/DAL/managers/sharedPreferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserManagement implements UserManagementInterface {
  ApiAgent agent = ApiAgent();
  SharedPreferencesManagement preferences = SharedPreferencesManagement();

  @override
  Future<bool> login(
      String phoneNumber, String password, BuildContext context) async {
    return await agent.loginUser(phoneNumber, password);
  }

  @override
  Future<bool> logout() async {
    await Permission.storage.request();
    final prefs = await SharedPreferences.getInstance();
    var id = await preferences.getAssingmentId();
    String? userKey = await isLogged();
    if (id != null) {
      agent.setAssignmentState(id, 1, userKey);
    }
    return await prefs.clear();
  }

  @override
  Future<String?> isLogged() async {
    await Permission.storage.request();
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userKey');
  }

  @override
  Future<bool?> isIntroShown() async {
    await Permission.storage.request();
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('intro');
  }

  @override
  Future<bool> resetPassword(String phoneNumber, FToast fToast) async {
    return await agent.resetPassword(phoneNumber, fToast);
  }

  @override
  Future<void> introShown() async {
    await Permission.storage.request();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('intro', true);
  }
}
