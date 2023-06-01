import 'dart:convert';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:mobile_application/DAL/managers/productManagement.dart';
import 'package:mobile_application/DAL/managers/sharedPreferences.dart';
import 'package:mobile_application/DAL/managers/taskManagement.dart';
import 'package:mobile_application/models/assignment.dart';
import 'package:mobile_application/models/product.dart';
import 'package:mobile_application/utils/shared/appBar.dart';
import 'package:mobile_application/utils/shared/navigation.dart';
import 'package:mobile_application/utils/shared/numeric.dart';
import 'package:mobile_application/utils/shared/svgAndImages.dart';
import 'package:mobile_application/utils/shared/text.dart';

import '../utils/shared/colors.dart';
import 'mainView.dart';

class TaskDetails extends StatefulWidget {
  const TaskDetails({Key? key, required this.assignment, required this.id})
      : super(key: key);

  final int? id;
  final Assignment assignment;

  @override
  _TaskDetailsState createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  final ProductManagement productManagement = ProductManagement();

  final TaskManagement taskManagement = TaskManagement();

  late List<Product> listOfProducts = [];

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  final SharedPreferencesManagement preferences = SharedPreferencesManagement();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(
        shouldSeeArrow: true,
      ),
      body: FutureBuilder(
        future: _fetchData(),
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: edgePadding - 2, vertical: containerPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: getMainHeader('Szczegóły zadania', context),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(borderRadius)),
                        child: Container(
                          width: getWidth(context),
                          height: getHeight(context) * 0.30,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 2 * containerPadding,
                              vertical: containerPadding),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              getCardHeader(widget.assignment.name, context),
                              Padding(
                                padding: const EdgeInsets.all(edgePadding),
                                child: getSvgWidth(
                                    widget.assignment.assetIconPath,
                                    Theme.of(context).buttonColor,
                                    getHeight(context) * 0.08),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: edgePadding),
                                child: getMainText(
                                    widget.assignment.description, context),
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      getCardLabelLarge(
                                          "Typ zadania: ", context),
                                      getCardBodyBigger(
                                          getType(widget.assignment.taskType),
                                          context)
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: getMainHeader('Produkty', context),
                        ),
                      ),
                      snapshot.data as Widget,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: getMainHeader('Dodatkowe informacje', context),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          additionalInfoCard(
                              'assets/map-svgrepo-com.svg',
                              widget.assignment.taskType == 'Order'
                                  ? "Mapa jest dostepna"
                                  : "Mapa nie jest dostępna"),
                          additionalInfoCard('assets/weight-svgrepo-com.svg',
                              "Waga produktow wynosi " + getWeight())
                        ],
                      ),
                      widget.id == null
                          ? SizedBox(
                              width:
                                  getWidth(context) * 0.5, // <-- match_parent
                              height: getHeight(context) * 0.05,
                              child: ElevatedButton(
                                onPressed: () async {
                                  preferences
                                      .setAssingmentId(widget.assignment.id);
                                  var product = await productManagement
                                      .getProductList(widget.assignment.id);
                                  String jsonProducts = jsonEncode(product);
                                  preferences.setAssingment(jsonProducts);
                                  taskManagement.setAssignmentState(
                                      widget.assignment.id, 2);
                                  moveToNewCleanPage(
                                      context, const MainView(), false);
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            borderRadius))),
                                child: Ink(
                                  decoration: BoxDecoration(
                                      gradient: mainGradient,
                                      borderRadius:
                                          BorderRadius.circular(borderRadius)),
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: containerPadding),
                                          child: Center(
                                            child: getText(
                                                'Rozpocznij zadanie',
                                                cardBasicTextStyle(
                                                    16, Colors.white)),
                                          ))),
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ));
            default:
              return Container();
          }
        }),
      ),
    );
  }

  String getType(String type) {
    if (type.toLowerCase() == 'order') {
      return 'Zamówienie';
    }
    return 'Dostawa';
  }

  String getWeight() {
    num suma = 0;
    for (var element in listOfProducts) {
      suma += element.weight;
    }

    return suma.toString() + ' kg';
  }

  Widget additionalInfoCard(String path, String text) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius)),
      child: Container(
          width: getWidth(context) / 2.5,
          height: getWidth(context) / 3.5,
          padding: const EdgeInsets.symmetric(
              horizontal: 2 * containerPadding, vertical: containerPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Column(
            children: [
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    width: (getWidth(context) / 8) + 6,
                    height: (getWidth(context) / 8) + 6,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, gradient: mainGradient),
                  ),
                  Container(
                    width: (getWidth(context) / 8) + 2,
                    height: (getWidth(context) / 8) + 2,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).cardColor),
                  ),
                  getSvg(
                    path,
                    getWidth(context) / 8.2,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: getCardBodyTextCenter(text, context),
              ),
            ],
          )),
    );
  }

  Widget productList(List<Product> list) {
    return SizedBox(
      height: getHeight(context) * 0.15,
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: list.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return productOrderCard(list[index]);
                }),
          ),
        ],
      ),
    );
  }

  Card productOrderCard(Product product) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 2 * containerPadding,
            vertical: 2 * containerPadding - 10),
        child: SizedBox(
          width: getWidth(context) * 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: getSvgWidth(
                        product.assetIcon,
                        Theme.of(context).buttonColor,
                        getWidth(context) * 0.13),
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          getCardLabel('Waga[kg]:', context),
                          getCardLabel('Ilość[szt.]:', context),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            getCardBodyTextCenter(
                                product.weight.toString(), context),
                            getCardBodyTextCenter(
                                product.count.toString(), context),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  getCardLabelLarge(product.name, context),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  TextStyle? cardBasicTextStyle(double fontSize, Color color) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
    );
  }

  TextStyle? cardHeaderStyle(double fontSize, Color color) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
    );
  }

  _fetchData() {
    return _memoizer.runOnce(() async {
      var product =
          await productManagement.getProductList(widget.assignment.id);
      if (mounted) {
        listOfProducts = product;
        return productList(product);
      }
      return Container();
    });
  }

  // TextStyle? settingsTextStyle(double fontSize, Color color) {
  //   return TextStyle(
  //     fontWeight: FontWeight.w300,
  //     fontSize: fontSize,
  //     color: color,
  //   );
  // }
}
