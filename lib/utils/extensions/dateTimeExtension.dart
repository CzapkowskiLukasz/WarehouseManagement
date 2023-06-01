extension DateTimeExtension on DateTime? {
  bool? isAfterOrEqualTo(DateTime dateTime, DateTime now) {
    final date = now;
    final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
    return isAtSameMomentAs | date.isAfter(dateTime);
  }

  bool? isBeforeOrEqualTo(DateTime dateTime, DateTime now) {
    final date = now;
    final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
    return isAtSameMomentAs | date.isBefore(dateTime);
  }

  bool isBetween(DateTime? fromDateTime, DateTime? toDateTime, DateTime now) {
    final date = now;
    if (fromDateTime == null || toDateTime == null) {
      return false;
    } else {
      final isAfter = date.isAfterOrEqualTo(fromDateTime, date) ?? false;
      final isBefore = date.isBeforeOrEqualTo(toDateTime, date) ?? false;
      return isAfter && isBefore;
    }
  }
}
