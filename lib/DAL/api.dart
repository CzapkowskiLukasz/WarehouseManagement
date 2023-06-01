import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_application/DAL/enviroments.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_application/DAL/managers/sharedPreferences.dart';
import 'package:mobile_application/models/assignment.dart';
import 'package:mobile_application/models/mapRegion.dart';
import 'package:mobile_application/models/map.dart' as appMap;
import 'package:mobile_application/models/product.dart';
import 'package:mobile_application/utils/shared/calendar.dart';

class ApiAgent {
  String baseUrl = urlBase;
  SharedPreferencesManagement sharedPreferencesManagement =
      SharedPreferencesManagement();

  Future<bool> loginUser(String login, String password) async {
    var body = {'phoneNumber': login, 'password': password};
    var uri = Uri.https(baseUrl, "/api/Authentication/login/phone");
    var response = await http.post(uri,
        headers: {"Content-Type": "application/json", "accept": "*/*"},
        body: jsonEncode(body));

    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      await sharedPreferencesManagement.signToken(decodedResponse['token']);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> resetPassword(String phoneNumber, FToast fToast) async {
    var body = {'phoneNumber': phoneNumber};
    var uri = Uri.https(baseUrl, "/api/User/forgot-password/phone");
    var response = await http.post(uri,
        headers: {"Content-Type": "application/json", "accept": "*/*"},
        body: jsonEncode(body));

    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Assignment>> getTasks(
      String? token, DateTime startDate, DateTime endDate) async {
    var uri = Uri.https(baseUrl, "/api/Assignment/between-dates",
        {"startDate": formatDate(startDate), "endDate": formatDate(endDate)});
    var response = await http.get(uri,
        headers: {"accept": "*/*", "Authorization": "Bearer " + token!});
    if (response.statusCode == 200) {
      var tags = jsonDecode(response.body)['assignments'] as List;
      List<Assignment> assignments =
          tags.map((tagJson) => Assignment.fromJson(tagJson)).toList();

      assignments.removeWhere((element) => element.taskStatus == 3);
      return assignments;
    } else {
      return <Assignment>[];
    }
  }

  Future<List<Product>> getProductsByAssignment(
      String? token, int assignmentId) async {
    var uri =
        Uri.https(baseUrl, "api/Product/assignment/" + assignmentId.toString());
    var response = await http.get(uri,
        headers: {"accept": "*/*", "Authorization": "Bearer " + token!});
    if (response.statusCode == 200) {
      var tags = jsonDecode(response.body)['products'] as List;
      List<Product> products =
          tags.map((tagJson) => Product.fromJson(tagJson)).toList();
      products.sort((a, b) => a.mapRegionId.compareTo(b.mapRegionId));
      return products;
    } else {
      return <Product>[];
    }
  }

  Future<appMap.Map> getMap(String? token, BuildContext context) async {
    double deviceWidth = 0;
    double deviceHeight = 0;

    try {
      deviceWidth = MediaQuery.of(context).size.width;
      deviceHeight = MediaQuery.of(context).size.height;
    } catch (e) {}

    var uri = Uri.https(baseUrl, "/api/Map");
    var response = await http.get(uri,
        headers: {"accept": "*/*", "Authorization": "Bearer " + token!});
    if (response.statusCode == 200) {
      var tags = jsonDecode(response.body)['mapRegions'] as List;

      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      int werehouseWidth = (decodedResponse['warehouseWidth'] as int);
      int werehouseHeight = (decodedResponse['warehouseHeight'] as int);
      double scale;
      String primaryDimension;
      if (werehouseWidth >= werehouseHeight) {
        scale = ((deviceWidth.toInt() / werehouseHeight).toDouble()) * 0.9;
        primaryDimension = "vertical";
      } else {
        scale = ((deviceHeight.toInt() / werehouseHeight).toDouble()) * 0.95;
        primaryDimension = "horizontal";
      }

      scale -= 0.1; ///// USUNAC POTEM ASFDKASDF

      List<MapRegion> mapRegions =
          tags.map((tagJson) => MapRegion.fromJson(tagJson, scale)).toList();

      return appMap.Map(werehouseWidth.toDouble(), werehouseHeight.toDouble(),
          mapRegions, scale, primaryDimension);
    } else {
      return appMap.Map(0, 0, <MapRegion>[], 0, "horizontal");
    }
  }

  Future<void> sendEmail(
      String? token, DateTime startDate, DateTime endDate) async {
    var uri = Uri.https(baseUrl, "/api/Planner/planner/",
        {"startDate": formatDate(startDate), "endDate": formatDate(endDate)});
    await http.get(uri,
        headers: {"accept": "*/*", "Authorization": "Bearer " + token!});
  }

  Future<void> setAssignmentState(
      int assignmentId, int status, String? token) async {
    var body = {'assingmentId': assignmentId, 'assignmentStatus': status};
    var uri = Uri.https(baseUrl, "/api/Assignment/status");

    await http.patch(uri,
        headers: {
          "Content-Type": "application/json",
          "accept": "*/*",
          "Authorization": "Bearer " + token!
        },
        body: jsonEncode(body));
  }
}
