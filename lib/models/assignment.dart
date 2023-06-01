class Assignment {
  late int id;
  int? tenantId;
  String name;
  String description;
  DateTime? startDate;
  DateTime? endDate;
  late String taskType;
  int taskStatus;
  int? userId;
  late String assetIconPath = "";

  Assignment(
      this.id,
      this.tenantId,
      this.name,
      this.description,
      this.startDate,
      this.endDate,
      this.taskType,
      this.taskStatus,
      this.userId) {
    assetIconPath = 'assets/' + getIconPath(taskType);
  }

  String getIconPath(String? type) {
    switch (type) {
      case "Order":
        return 'collect.svg';
      default:
        return 'delivery.svg';
    }
  }

  factory Assignment.fromJson(json) {
    String? descriptionTmp = json['description'] as String;
    return Assignment(
      json['assignmentId'] as int,
      json['tenatId'] as int?,
      json['name'] as String,
      descriptionTmp,
      DateTime.tryParse(json['startDate']),
      DateTime.tryParse(json['endDate']),
      json['assignmentType'] as String,
      json['assignmentStatus'] as int,
      json['userId'] as int?,
    );
  }
}
