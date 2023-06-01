import 'package:flutter/material.dart';
import 'package:mobile_application/models/map.dart' as map;

abstract class MapManagementInterface {
  Future<map.Map> getActualMap(BuildContext context);
}
