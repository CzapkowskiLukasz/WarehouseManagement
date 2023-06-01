import 'dart:convert';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:mobile_application/DAL/managers/productManagement.dart';
import 'package:mobile_application/DAL/managers/sharedPreferences.dart';
import 'package:mobile_application/DAL/managers/taskManagement.dart';
import 'package:mobile_application/models/assignment.dart';
import 'package:mobile_application/utils/shared/calendar.dart';
import 'package:mobile_application/utils/shared/colors.dart';
import 'package:mobile_application/utils/shared/navigation.dart';
import 'package:mobile_application/utils/shared/numeric.dart';
import 'package:mobile_application/utils/shared/svgAndImages.dart';
import 'package:mobile_application/utils/shared/text.dart';
import 'package:mobile_application/views/taskDetails.dart';
import 'package:table_calendar/table_calendar.dart';

import '../utils/shared/progressBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);
  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> with TickerProviderStateMixin {
  final SharedPreferencesManagement preferences = SharedPreferencesManagement();
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();

  TaskManagement taskManagement = TaskManagement();

  late Future<List<Assignment>> assingments;

  late int? assingmentId;

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  final ProductManagement productManagement = ProductManagement();

  late AnimationController _animationController;
  @override
  void initState() {
    assingments = getTasksList(_focusedDay, DateTime.now());
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController.addListener(() => setState(() {}));
    _animationController.repeat();
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  _fetchData(BuildContext context) {
    return _memoizer.runOnce(() async {
      int? _assingmentId = await preferences.getAssingmentId();

      if (_assingmentId != null) {
        assingmentId = _assingmentId;
      }

      if (mounted) {
        return _assingmentId;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetchData(context),
        builder: (context, snapshot2) {
          switch (snapshot2.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return entireBody(progressBarBody(), [], null);
            case ConnectionState.done:
              if (mounted) {
                if (snapshot2.data != null) {
                  return FutureBuilder<List<Assignment>>(
                      future: assingments,
                      builder: (context2, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return Container();
                          case ConnectionState.done:
                            var listTmp = snapshot.data!;

                            Assignment actualTask;
                            var listConnected;
                            int? index = isInProgress(snapshot.data!);
                            if (listTmp.isNotEmpty) {
                              if (index == null) {
                                actualTask = listTmp.firstWhere(
                                    (element) => element.id == snapshot2.data);

                                //var product = productManagement.getProductList(actualTask.id);
                                //String jsonProducts = jsonEncode(product);
                                //preferences.setAssingment(jsonProducts);
                                listConnected = getListCropped(
                                    listTmp, snapshot2.data! as int?);
                              } else {
                                actualTask = snapshot.data![index];

                                listConnected = getListCropped(
                                    listTmp, snapshot.data![index].id);
                              }
                              return entireBody(
                                  upcomingTasksListview(
                                      listConnected, snapshot2.data! as int?),
                                  listTmp,
                                  snapshot2.data! as int?,
                                  actualTask);
                            } else {
                              Expanded center = Expanded(
                                child: Center(
                                    child: getMainText('Brak zadań', context)),
                              );
                              return entireBody(center, [], null);
                            }
                          default:
                            return entireBody(progressBarBody(), [], null);
                        }
                      });
                } else {
                  return FutureBuilder<List<Assignment>>(
                      future: assingments,
                      builder: (context2, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return Container();
                          case ConnectionState.done:
                            int? index = isInProgress(snapshot.data!);
                            if (index == null) {
                              return entireBody(
                                  upcomingTasksListview(
                                      snapshot.data!, snapshot2.data as int?),
                                  snapshot.data!,
                                  null);
                            } else {
                              var actualTask = snapshot.data![index];
                              var listConnected =
                                  getListCropped(snapshot.data!, actualTask.id);
                              return entireBody(
                                  upcomingTasksListview(
                                      listConnected, snapshot2.data as int?),
                                  snapshot.data!,
                                  index,
                                  actualTask);
                            }
                          default:
                            return entireBody(progressBarBody(), [], null);
                        }
                      });
                }
              }
              return entireBody(progressBarBody(), [], null);
            default:
              return Container();
          }
        });
  }

  List<Assignment> getListCropped(List<Assignment> all, int? index) {
    var listPart1 =
        all.sublist(0, all.indexWhere((element) => element.id == index));

    var listPart2 = all.sublist(
        all.indexWhere((element) => element.id == index) + 1, all.length);

    return listPart1 + listPart2;
  }

  int? isInProgress(List<Assignment> lista) {
    for (int i = 0; i < lista.length; i++) {
      if (lista[i].taskStatus == 2) {
        return i;
      }
    }

    return null;
  }

  Future<List<Assignment>> getTasksList(DateTime startDate, DateTime endDate) {
    return taskManagement.getUserAssignment(startDate, endDate);
  }

  Widget progressBarBody() {
    return Flexible(
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              getProgressBar(
                  _animationController, Theme.of(context).backgroundColor),
            ]),
      ),
    );
  }

  Card calendarCard() {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: containerPadding, vertical: containerPadding),
        child: configuredCalendar(),
      ),
    );
  }

  Widget entireBody(Widget upcomingTasks, List<Assignment> list, int? actualId,
      [Assignment? assignment]) {
    return Container(
      padding: EdgeInsets.only(top: appBarSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: paddingEdge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getMainText('Witaj', context),
                getMainHeader(
                    'Masz ' + list.length.toString() + ' zaplanowanych zadań',
                    context)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: edgePadding - 2, vertical: containerPadding),
            child: calendarCard(),
          ),
          Padding(
            padding: paddingEdge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getMainHeader('Aktualne zadanie', context),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: containerPadding),
                  child: assignment != null
                      ? actualTaskCard(assignment, actualId)
                      : Center(
                          child:
                              getMainText('Brak rozpoczętych zadań', context)),
                ),
              ],
            ),
          ),
          Padding(
              padding: paddingEdge,
              child: getMainHeader('Zaplanowane zadania', context)),
          upcomingTasks
        ],
      ),
    );
  }

  GestureDetector actualTaskCard(Assignment task, int? actualId) {
    return GestureDetector(
        onTap: (() {
          moveToPage(
              context,
              TaskDetails(
                assignment: task,
                id: actualId,
              ));
        }),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius)),
          child: Container(
            width: getWidth(context),
            height: getHeight(context) * 0.15,
            padding: const EdgeInsets.symmetric(
                horizontal: 2 * containerPadding, vertical: containerPadding),
            decoration: BoxDecoration(
              gradient: mainGradient,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: containerPadding * 2),
                  child: Center(
                    child: getSvgWidth(task.assetIconPath, Colors.white,
                        getHeight(context) * 0.06),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getText(task.name, headerStyle(18, Colors.white)),
                    getText(
                        task.description, cardBasicTextStyle(14, Colors.white))
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  TableCalendar configuredCalendar() {
    return TableCalendar(
      locale: 'pl_PL',
      startingDayOfWeek: StartingDayOfWeek.monday,
      daysOfWeekStyle: daysOfWeekStyle,
      calendarStyle: getCalendarStyle(context),
      headerVisible: false,
      calendarFormat: CalendarFormat.week,
      firstDay: kFirstDay,
      lastDay: kLastDay,
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            assingments = Future<List<Assignment>>.value(<Assignment>[]);
            assingments = getTasksList(selectedDay, selectedDay);
          });
        }
      },
      calendarBuilders: getCalendarBuilder(context),
    );
  }

  Expanded upcomingTasksListview(List<Assignment> list, int? actualId) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: (() {
              moveToPage(
                  context,
                  TaskDetails(
                    assignment: list[index],
                    id: actualId,
                  ));
            }),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius)),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 2 * containerPadding,
                    vertical: containerPadding),
                child: SizedBox(
                  height: getHeight(context) * 0.06,
                  width: getWidth(context),
                  child: Row(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 2 * containerPadding),
                        child: Center(
                          child: getSvgWidth(list[index].assetIconPath, grey,
                              getHeight(context) * 0.04),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getCardHeaderSmall(list[index].name, context),
                          getCardBodyText(list[index].description, context)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  TextStyle? cardBasicTextStyle(double fontSize, Color color) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
    );
  }
}
