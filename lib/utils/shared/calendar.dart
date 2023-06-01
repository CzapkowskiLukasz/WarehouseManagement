import 'package:flutter/material.dart';
import 'package:mobile_application/utils/shared/colors.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year + 10, kToday.month, kToday.day);

CalendarStyle getCalendarStyle(BuildContext context) {
  return CalendarStyle(
    rangeStartDecoration:
        BoxDecoration(shape: BoxShape.circle, gradient: mainGradient),
    rangeEndDecoration:
        BoxDecoration(shape: BoxShape.circle, gradient: mainGradient),
    withinRangeTextStyle: basicTextStyle(),
    weekendTextStyle: basicTextStyle(),
    todayDecoration: const BoxDecoration(color: Colors.transparent),
    todayTextStyle: todayTextStyle(),
    defaultTextStyle: basicTextStyle(),
  );
}

String formatDate(DateTime formatDate) {
  var inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  var inputDate = inputFormat.parse(formatDate.toString());

  var outputFormat = DateFormat('yyyy-MM-dd');
  String outputDate = outputFormat.format(inputDate);
  return outputDate;
}

TextStyle todayTextStyle() {
  return TextStyle(
    foreground: Paint()
      ..shader = mainGradient.createShader(
        const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0),
      ),
  );
}

TextStyle basicTextStyle() {
  return TextStyle(color: grey);
}

DaysOfWeekStyle daysOfWeekStyle = DaysOfWeekStyle(
  weekdayStyle: TextStyle(color: darkGrey),
  weekendStyle: const TextStyle(color: Colors.red),
);

CalendarBuilders getCalendarBuilder(BuildContext context) {
  return CalendarBuilders(
    selectedBuilder: (context, day, _focusedDay) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            gradient: mainGradient),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                color: Theme.of(context).cardColor),
            child: Center(
              child: Text(
                _focusedDay.day.toString(),
                style: isSameDay(_focusedDay, DateTime.now())
                    ? todayTextStyle()
                    : basicTextStyle(),
              ),
            ),
          ),
        ),
      );
    },
  );
}
