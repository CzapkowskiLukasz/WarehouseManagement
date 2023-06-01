import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:mobile_application/DAL/managers/productManagement.dart';
import 'package:mobile_application/DAL/managers/sharedPreferences.dart';
import 'package:mobile_application/utils/shared/numeric.dart';
import 'package:mobile_application/utils/shared/svgAndImages.dart';
import '../DAL/managers/mapManagement.dart';
import '../models/product.dart';
import '../utils/shared/colors.dart';
import '../utils/shared/mapPainter.dart';
import '../utils/shared/navigation.dart';
import '../utils/shared/progressBar.dart';
import '../utils/shared/slideableSheet.dart';
import '../utils/shared/text.dart';
import '../views/confirmation.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:zoom_widget/zoom_widget.dart';

import '../models/map.dart';
import '../utils/shared/toast.dart';

class MapPage extends StatefulWidget {
  const MapPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MapPage> createState() => _MapPage();
}

class _MapPage extends State<MapPage> with TickerProviderStateMixin {
  late FToast fToast;

  final MapManagement mapManagement = MapManagement();

  final ProductManagement productManagement = ProductManagement();

  late Future<Map> map;
  late List<Product> listOfProducts;

  late int taskId;

  late AnimationController _animationController;

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  final SharedPreferencesManagement preferences = SharedPreferencesManagement();

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController.addListener(() => setState(() {}));
    _animationController.repeat();
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  _fetchData(BuildContext context) {
    return _memoizer.runOnce(() async {
      int? assingmentId = await preferences.getAssingmentId();

      var product = <Product>[];

      if (assingmentId != null) {
        String? assingment = await preferences.getAssingment();
        var tags = jsonDecode(assingment!) as List;
        product = tags
            .map((tagJson) => Product.fromJsonWithCollectedFlag(tagJson))
            .toList();
        taskId = assingmentId;
      }

      var mapa = await mapManagement.getActualMap(context);
      mapa.listOfProducts = product;
      listOfProducts = product;
      mapa.createStringMap();
      if (mounted) {
        return panel(mapBody(mapa, listOfProducts), listOfProducts, 'done');
      }
      return Container();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetchData(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return panel(emptyMap(), [], 'waiting');
            default:
              if (mounted) {
                return snapshot.data as Widget;
              }
              return panel(emptyMap(), [], 'default');
          }
        });
  }

  bool isFullScaned(List<Product> list) {
    for (var element in list) {
      if (element.collected == false) {
        return false;
      }
    }
    return true;
  }

  Widget panel(Widget child, List<Product> list, String state) {
    return SlidingUpPanel(
        color: Theme.of(context).hintColor,
        collapsed: collapseHeader(context, 'Aktualne zadanie'),
        defaultPanelState: PanelState.OPEN,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(borderRadius),
            topRight: Radius.circular(borderRadius)),
        minHeight: 60,
        maxHeight: getHeight(context) * 0.26,
        header: sheetHeader(context, 'Aktualne zadanie'),
        panel: Padding(
          padding: sheetPadding(),
          child: list.isEmpty
              ? emptyPanelBody(state)
              : Row(
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
        ),
        body: child);
  }

  Widget emptyPanelBody(String state) {
    return Container(
      color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      child: Center(
          child: state == 'waiting'
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      getProgressBar(
                          _animationController,
                          Theme.of(context)
                              .bottomNavigationBarTheme
                              .backgroundColor!),
                    ])
              : getMainText('Brak zaakceptowanego zadania', context)),
    );
  }

  Widget mapBody(Map map, List<Product> list) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Zoom(
        enableScroll: false,
        canvasColor: Theme.of(context).backgroundColor,
        backgroundColor: Theme.of(context).backgroundColor,
        maxZoomWidth: 2 * deviceWidth,
        maxZoomHeight: 2 * deviceHeight,
        child: CustomPaint(
          painter: MapPainter(map, context),
        ),
      ),
    );
  }

  Widget emptyMap() {
    return Container(
      color: Theme.of(context).backgroundColor,
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

  Card productOrderCard(Product product) {
    return Card(
      margin: const EdgeInsets.all(containerPadding),
      elevation: 6,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 2 * containerPadding, vertical: 2 * containerPadding),
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
                        product.assetIcon, grey, getWidth(context) * 0.10),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getText(product.name, cardHeaderStyle(16, grey)),
                  scanButton(product)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  bool isAssingmentCompleted(List<Product> list) {
    for (var product in list) {
      if (product.collected == false) {
        return false;
      }
    }
    return true;
  }

  Future<String> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cofnij', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Błąd';
    }

    if (!mounted) return 'Unknown';

    //setState(() {
    return barcodeScanRes;
    //});
  }

  Widget scanButton(Product product) {
    return SizedBox(
      width: 90,
      height: 25,
      child: ElevatedButton(
        onPressed: () async {
          for (int i = 0; i < listOfProducts.length; i++) {
            if (listOfProducts[i].barcode == product.barcode) {
              if (listOfProducts[i].collected == false) {
                print(listOfProducts[i].barcode);
                var code = scanBarcodeNormal();
                code.then((value) {
                  //if (_scanBarcode != '-1' && _scanBarcode != 'Unknown') {
                  if (value == product.barcode) {
                    List<Product> products = listOfProducts;
                    products[i].collected = true;
                    String jsonProducts = jsonEncode(products);
                    preferences.setAssingment(jsonProducts);
                    if (isAssingmentCompleted(products)) {
                      moveToNewCleanPage(
                          context,
                          ConfirmationView(
                            id: taskId,
                          ),
                          false);
                    } else {
                      doneToast('Pomyślnie zeskanowano', fToast);
                      setState(() {
                        listOfProducts = products;
                        //_scanBarcode = '-1';
                      });
                    }
                  } else {
                    errorToast('Zeskanowano niewłaściwy produkt', fToast);
                  }
                  //}
                });
              } else {
                infoToast('Produkt został ju zeskanowany', fToast);
              }
            }
          }
        },
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius))),
        child: Ink(
          decoration: BoxDecoration(
              gradient: mainGradient,
              borderRadius: BorderRadius.circular(borderRadius)),
          child: Container(
              alignment: Alignment.center,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: containerPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getText('Skanuj', cardHeaderStyle(10, Colors.white)),
                    getSvgStaticHeight('assets/scan.svg', Colors.white, 15)
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
