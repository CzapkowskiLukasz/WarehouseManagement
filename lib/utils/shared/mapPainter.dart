import 'package:flutter/material.dart';
import 'package:mobile_application/models/graph.dart';
import 'package:mobile_application/models/map.dart';
import 'package:mobile_application/utils/shared/colors.dart';
import 'package:vector_math/vector_math.dart';

class MapPainter extends CustomPainter {
  late Map map;
  late double topPadding;
  late double leftPadding;

  late Graph graph;

  late BuildContext context;

  MapPainter(this.map, this.context) {
    if (map.listOfProducts.isNotEmpty) {
      graph = Graph(map);
      graph.findShortestPath();
    }

    topPadding = MediaQuery.of(context).size.height * 0.15;
    leftPadding = (MediaQuery.of(context).size.width * 0.1) / 2;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Theme.of(context).indicatorColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    drawMap(canvas, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  void drawBorders(Canvas canvas, Paint paint) {
    canvas.drawRect(
        Offset(leftPadding, topPadding) &
            Size(map.warehouseWidth, map.warehouseHeight),
        paint);
  }

  bool shouldColor(int regionId) {
    for (var product in map.listOfProducts) {
      if (product.mapRegionId == regionId) {
        return true;
      }
    }
    return false;
  }

  void drawRectangle(Canvas canvas, Paint paint, double regionX, double regionY,
      double width, double height) {
    canvas.drawRect(
        Offset(leftPadding + regionX, topPadding + regionY) &
            Size(width, height),
        paint);
  }

  void drawRacks(Canvas canvas, Paint paint) {
    for (var mapRegion in map.mapRegions) {
      if (mapRegion.mapRegionType.toLowerCase() == "rack" ||
          mapRegion.mapRegionType.toLowerCase() == "obstacle") {
        if (shouldColor(mapRegion.mapRegionId)) {
          var paintFilled = Paint()
            ..color = gradientFirst
            ..style = PaintingStyle.fill
            ..strokeWidth = 4;
          drawRectangle(canvas, paintFilled, mapRegion.x, mapRegion.y,
              mapRegion.width, mapRegion.height);
        } else {
          if (mapRegion.mapRegionType.toLowerCase() == 'obstacle') {
            var paintObstacle = Paint()
              ..color = warningColor
              ..style = PaintingStyle.fill
              ..strokeWidth = 4;
            drawRectangle(canvas, paintObstacle, mapRegion.x, mapRegion.y,
                mapRegion.width, mapRegion.height);
          } else {
            drawRectangle(canvas, paint, mapRegion.x, mapRegion.y,
                mapRegion.width, mapRegion.height);
          }
        }
      }
      if (mapRegion.mapRegionType.toLowerCase() == "loadingarea") {
        var paintLoading = Paint()
          ..color = gradientFirst
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4;
        drawRectangle(canvas, paintLoading, mapRegion.x, mapRegion.y,
            mapRegion.width, mapRegion.height);
      }
    }
  }

  void drawPath(Canvas canvas, Paint paint) {
    var paintPath = Paint()
      ..color = gradientSecond
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    for (int i = 0; i < graph.finalPath.length - 2; i++) {
      canvas.drawLine(
          Offset(leftPadding + graph.finalPath[i].x,
              topPadding + graph.finalPath[i].y),
          Offset(leftPadding + graph.finalPath[i + 1].x,
              topPadding + graph.finalPath[i + 1].y),
          paintPath);
    }
  }

  void drawMap(Canvas canvas, Paint paint) {
    drawBorders(canvas, paint);

    drawRacks(canvas, paint);
    if (map.listOfProducts.isNotEmpty) {
      drawPath(canvas, paint);

      drawUsedRacks(canvas, paint);
    }
  }

  void drawUsedRacks(canvas, paint) {
    for (var mapRegion in map.mapRegions) {
      if (mapRegion.mapRegionType == "Rack".toLowerCase()) {
        if (shouldColor(mapRegion.mapRegionId)) {
          var paintFilled = Paint()
            ..color = gradientFirst
            ..style = PaintingStyle.fill
            ..strokeWidth = 4;
          drawRectangle(canvas, paintFilled, mapRegion.x, mapRegion.y,
              mapRegion.width, mapRegion.height);
        }
      }
    }
  }

  void rotate(Canvas canvas, double cx, double cy, Paint paint) {
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(radians(90));
    canvas.translate(-cx, -cy);
    drawMap(canvas, paint);
    canvas.restore();
  }
}
