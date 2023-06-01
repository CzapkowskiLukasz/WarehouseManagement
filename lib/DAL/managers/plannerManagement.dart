import 'package:flutter/material.dart';
import 'package:mobile_application/DAL/api.dart';
import 'package:mobile_application/DAL/interfaces/plannerManagementInterface.dart';
import 'package:mobile_application/DAL/managers/userManagement.dart';

class PlannerManagement implements PlannerManagementInterface {
  ApiAgent api = ApiAgent();
  UserManagement userManagement = UserManagement();

  @override
  Future<void> sendMail(
      BuildContext context, DateTime startDate, DateTime endDate) async {
    String? userKey = await userManagement.isLogged();
    api.sendEmail(userKey, startDate, endDate);
  }
}
