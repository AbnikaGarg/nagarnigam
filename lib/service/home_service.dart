import 'dart:convert';
import 'dart:io';
import 'package:nagarnigam/service/pref_service.dart';
import 'package:nagarnigam/util/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class HomepageService {
  final String noInternetMessage =
      'Connection to API server failed due to internet connection';
  Future<Response> apiGetData() async {
    var ur = Uri.parse(AppUrl.getEntryList);
    var token = PreferenceUtils.getUserToken();

    try {
      final response = await http.get(ur, headers: {
        "Content-Type": "application/json; charset=utf-8",
        'Authorization': 'Bearer $token',
      });

      print(response.body);

      return Response(
        statusCode: response.statusCode,
        body: utf8.decode(response.body.codeUnits),
      );
    } on SocketException catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> apiCreatePickup(String? propertyNo) async {
    var ur = Uri.parse(AppUrl.pickup);
    var token = PreferenceUtils.getUserToken();
    try {
      Position? position;
      try {
        position = await Geolocator.getCurrentPosition();
      } catch (e) {
        print("Failed to get position: $e");
        // Handle the case where the position cannot be retrieved
      }

      if (position == null) {
        print("Position is null");
        // Handle the case where the position is null
      }

      final response2 = await http.post(ur,
          body: json.encode({
            "propertyNo": propertyNo,
            "latitude": position == null ? "" : position.latitude.toString(),
            "longitude": position == null ? "" : position.longitude.toString()
          }),
          headers: {
            "Content-Type": "application/json; charset=utf-8",
            'Authorization': 'Bearer $token',
          });
      print(response2.body);

      return Response(
        statusCode: response2.statusCode,
        body: utf8.decode(response2.body.codeUnits),
      );
    } on SocketException catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }
}
