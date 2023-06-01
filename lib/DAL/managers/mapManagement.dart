import 'package:flutter/material.dart';
import 'package:mobile_application/DAL/api.dart';
import 'package:mobile_application/DAL/managers/userManagement.dart';

import 'package:mobile_application/DAL/interfaces/mapManagementInteraface.dart';
import 'package:mobile_application/models/map.dart' as map;

class MapManagement implements MapManagementInterface {
  ApiAgent api = ApiAgent();
  UserManagement userManagement = UserManagement();

  @override
  Future<map.Map> getActualMap(BuildContext context) async {
    String? userKey = await userManagement.isLogged();
    map.Map werehouseMap = await api.getMap(userKey, context);
    return werehouseMap;
  }
}
