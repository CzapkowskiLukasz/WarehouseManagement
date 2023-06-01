import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../interfaces/sharedPreferencesManagementInterface.dart';

class SharedPreferencesManagement
    implements SharedPreferencesManagementInterface {
  @override
  Future<int?> getAssingmentId() async {
    await Permission.storage.request();
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('assingmentId');
  }

  Future<bool> signToken(String token) async {
    await Permission.storage.request();
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString('userKey', token);
  }

  @override
  Future<bool> setAssingmentId(int id) async {
    await Permission.storage.request();
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setInt('assingmentId', id);
  }

  @override
  Future<bool> removeAssingmentId() async {
    await Permission.storage.request();
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove('assingmentId');
  }

  Future<bool> setAssingment(String assingmentJson) async {
    await Permission.storage.request();
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString('assingment', assingmentJson);
  }

  Future<String?> getAssingment() async {
    await Permission.storage.request();
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('assingment');
  }
}
