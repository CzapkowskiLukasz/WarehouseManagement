import 'package:flutter/cupertino.dart';

abstract class PlannerManagementInterface {
  Future<void> sendMail(
      BuildContext context, DateTime startDate, DateTime endDate);
}
