import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  Future<bool> isInternetConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  String getGreetingMsg() {
    String time = DateFormat("HH:mm:ss").format(DateTime.now());
    int hrs = int.parse(time.split(":")[0]);
    String mins = time.split(":")[1];
    String msg = "";
    // if (int.parse(hrs) >= 0 && int.parse(hrs) <= 12) {
    //   msg = 'Good Morning';
    // } else if ((int.parse(hrs) >= 12 && int.parse(mins) >= 0) &&
    //     int.parse(hrs) < 17) {
    //   msg = 'Good Afternoon';
    // } else if ((int.parse(hrs) >= 17 && int.parse(mins) >= 0) &&
    //     int.parse(hrs) < 24) {
    //   msg = 'Good Evening';
    // }
    if (hrs >= 0 && hrs < 12) {
      msg = 'Good Morning';
    } else if (hrs >= 12 && hrs < 17) {
      msg = 'Good Afternoon';
    } else if (hrs >= 17 && hrs < 24) {
      msg = 'Good Evening';
    }
    print("==== hrs :: ${hrs}");
    print("==== min :: ${mins}");

    print("==== message :: ${msg}");
    return msg;
  }
}
