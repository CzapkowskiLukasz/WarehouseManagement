import 'package:mobile_application/models/assignment.dart';

abstract class TaskManagementInterface {
  Future<List<Assignment>> getUserAssignment(
      DateTime startDate, DateTime endDate);

  Future<void> setAssignmentState(int assignmentId, int status);
}
