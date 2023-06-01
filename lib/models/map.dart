import 'package:mobile_application/models/mapRegion.dart';
import 'package:mobile_application/models/product.dart';

class Map {
  late double warehouseWidth = 0;
  late double warehouseHeight = 0;
  List<MapRegion> mapRegions;
  String dimension;

  late List<List<String>> stringMap = [];
  late List<List<int>> nodesNumber = [];

  late int nodesCount = 0;

  late List<Product> listOfProducts = [];

  Map(double warehouseWidth, double warehouseHeight, this.mapRegions, scale,
      this.dimension) {
    this.warehouseHeight = warehouseHeight * scale;
    this.warehouseWidth = warehouseWidth * scale;
  }

  bool checkForRegion(int regionId) {
    for (int i = 0; i < listOfProducts.length; i++) {
      if (regionId == listOfProducts[i].mapRegionId) {
        return true;
      }
    }
    return false;
  }

  void walktroughtRegion(MapRegion regions) {
    // for (int i = 0; i < regions.length; i++) {
    int x = regions.x.round() + (regions.width / 2).round();

    var list = stringMap[x];

    for (int j = regions.y.round();
        j < regions.height + regions.y.round() - 1;
        j++) {
      if (list[j] == "#") {
        list[j] = ".";
      }
    }
    stringMap[x] = list;

    int y = regions.y.round() + (regions.height / 2).round();
    for (int j = regions.x.round();
        j < regions.x.round() + regions.width;
        j++) {
      stringMap[j][y] = ".";
    }
    // }
  }

  void countNodes() {
    for (int i = 0; i < stringMap.length; i++) {
      var list = stringMap[i];
      var nodesNumberList = List<int>.filled(warehouseHeight.round(), -1);
      for (int x = 0; x < list.length; x++) {
        if (list[x] == ".") {
          nodesNumberList[x] = nodesCount;
          nodesCount += 1;
        }
      }
      nodesNumber.add(nodesNumberList);
    }
  }

  void createBase() {
    for (int i = 0; i < warehouseWidth.floor(); i++) {
      if (i == 0 || i == warehouseWidth.floor() - 1) {
        var list =
            List<String>.filled(warehouseHeight.round(), "#", growable: true);
        stringMap.add(list);
      } else {
        var list =
            List<String>.filled(warehouseHeight.round(), ".", growable: true);
        list[0] = "#";
        list.last = "#";
        stringMap.add(list);
      }
    }
  }

  void redrawBorders() {
    for (int i = 0; i < warehouseWidth.floor(); i++) {
      if (i == 0 || i == warehouseWidth.floor() - 1) {
        var list =
            List<String>.filled(warehouseHeight.round(), "#", growable: true);
        stringMap.add(list);
      } else {
        var tmp = stringMap[i];
        tmp[0] = '#';
        tmp.last = '#';
        stringMap[i] = tmp;
      }
    }
  }

  void createRegions() {
    for (int i = 0; i < mapRegions.length; i++) {
      var mapRegion = mapRegions[i];
      var x = mapRegion.x.round();

      for (int j = 0; j < mapRegion.width.round(); j++) {
        var y = mapRegion.y.round();
        var list = stringMap[j + x];
        var replacements = List<String>.filled(mapRegion.height.round(), "#");
        list.replaceRange(y, y + mapRegion.height.round(), replacements);
      }
    }
  }

  bool isRegionUseful(MapRegion region) {
    for (var product in listOfProducts) {
      if (product.mapRegionId == region.mapRegionId) return true;
    }
    return false;
  }

  void createStringMap() {
    if (warehouseHeight > 0 || warehouseWidth > 0) {
      createBase(); //stworzenie mapy składającej się z '.' i '#' na granicach

      createRegions(); //uzupełnienie mapy o regiony

      for (var region in mapRegions) {
        if ((region.mapRegionType.toLowerCase() == 'loadingarea') ||
            isRegionUseful(region)) {
          walktroughtRegion(region); //przecięcie uywanych regionów
        }
      }

      redrawBorders(); //ponowne uzupełnienie granic znakiem '#'

      countNodes(); //policzenie znaków '.'
    }
  }
}
