import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_application/DAL/managers/plannerManagement.dart';
import 'package:mobile_application/utils/extensions/dateTimeExtension.dart';
import 'package:mobile_application/utils/shared/calendar.dart';
import 'package:mobile_application/utils/shared/navigation.dart';
import 'package:mobile_application/utils/shared/numeric.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime _focusedDay = DateTime.now();
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;

  String kod = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: appBarSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          calendarCard(),
        ],
      ),
    );
  }

  Padding calendarCard() {
    return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: edgePadding - 2, vertical: containerPadding),
        child: Card(
          color: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: containerPadding),
            child: configuredCalendar(),
          ),
        ));
  }

  TableCalendar configuredCalendar() {
    return TableCalendar(
      locale: 'pl_PL',
      startingDayOfWeek: StartingDayOfWeek.monday,
      rangeSelectionMode: _rangeSelectionMode,
      rangeStartDay: _rangeStart,
      rangeEndDay: _rangeEnd,
      daysOfWeekStyle: daysOfWeekStyle,
      calendarStyle: getCalendarStyle(context),
      availableCalendarFormats: const {CalendarFormat.month: 'Month'},
      headerVisible: true,
      calendarFormat: CalendarFormat.month,
      firstDay: kFirstDay,
      lastDay: kLastDay,
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onRangeSelected: (start, end, focusedDay) {
        setState(() {
          _selectedDay = null;
          _focusedDay = focusedDay;
          _rangeStart = start;
          _rangeEnd = end;
          _rangeSelectionMode = RangeSelectionMode.toggledOn;
        });
        if (focusedDay.isBetween(_rangeStart, _rangeEnd, focusedDay)) {
          showDialog(
            context: context,
            builder: (BuildContext context) => getPlatform(context),
          );
        }
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            _rangeStart = null; // Important to clean those
            _rangeEnd = null;
            _rangeSelectionMode = RangeSelectionMode.toggledOff;
          });
        }
      },
      calendarBuilders: getCalendarBuilder(context),
    );
  }

  Widget getPlatform(BuildContext context) {
    if (Platform.isAndroid) {
      return showAlertDialogAndroid(context);
    }
    return _buildPopupDialogIos(context);
  }

  Widget showAlertDialogAndroid(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Wyślij prośbę"),
      onPressed: () {
        var api = PlannerManagement();
        api.sendMail(context, _rangeStart!, _rangeEnd!);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Cofnij"),
      onPressed: () {
        removeLast(context);
      },
    );

    return AlertDialog(
      title: const Text("Prośba o urlop"),
      content: Text("Urlop między " +
          formatDate(_rangeStart!).toString() +
          " a " +
          formatDate(_rangeEnd!).toString()),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
  }

  Widget _buildPopupDialogIos(BuildContext context) {
    return CupertinoAlertDialog(
      actions: [
        TextButton(
          onPressed: () {
            var api = PlannerManagement();
            api.sendMail(context, _rangeStart!, _rangeEnd!);
          },
          child: const Text("Wyślij prośbę"),
        ),
        TextButton(
          onPressed: () {
            removeLast(context);
          },
          child: const Text("Cofnij"),
        )
      ],
      title: const Text("Prośba o urlop"),
      content: Text("Urlop między " +
          formatDate(_rangeStart!).toString() +
          " a " +
          formatDate(_rangeEnd!).toString()),
    );
  }
}
