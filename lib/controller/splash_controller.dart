import 'dart:async';

import 'package:nagarnigam/service/pref_service.dart';
import 'package:get/get.dart';

import '../view/dashboard.dart';
import '../view/login.dart';

class SplashController extends GetxController {
  SplashController();
  final image = "assets/mcb.jpeg";

  @override
  void onReady() {
    super.onReady();
    Timer(const Duration(seconds: 2), () {
      if (PreferenceUtils.isLoggedIn()) {
        Get.offAll(DashBoard());
      } else {
       Get.offAll(LoginWidget());
      }
    });
    // }
  }
}
