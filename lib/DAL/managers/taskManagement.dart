import 'package:mobile_application/DAL/api.dart';
import 'package:mobile_application/DAL/managers/userManagement.dart';
import 'package:mobile_application/DAL/interfaces/taskManagementInterface.dart';
import 'package:mobile_application/models/assignment.dart';

class TaskManagement implements TaskManagementInterface {
  ApiAgent api = ApiAgent();
  UserManagement userManagement = UserManagement();

  @override
  Future<List<Assignment>> getUserAssignment(
      DateTime startDate, DateTime endDate) async {
    String? userKey = await userManagement.isLogged();
    List<Assignment> listOfAssignments =
        await api.getTasks(userKey, startDate, endDate);
    return listOfAssignments;
  }

  @override
  Future<void> setAssignmentState(int assignmentId, int status) async {
    String? userKey = await userManagement.isLogged();
    api.setAssignmentState(assignmentId, status, userKey);
  }
}
