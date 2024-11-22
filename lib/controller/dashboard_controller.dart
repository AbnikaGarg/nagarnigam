import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:nagarnigam/models/EntryModel.dart';

import '../service/home_service.dart';
import '../view/login.dart';

class DashboardController extends GetxController {
  DashboardController();

  @override
  void onInit() {
    super.onInit();
    getData();
    // getReceipts();
    // getDashboard(0);
  }

  List<EntryModel> responseList = [];

  final searchController = TextEditingController();
  final searchController2 = TextEditingController();

  final searchController3 = TextEditingController();

  bool isloaded = false;
  void getData() async {
    HomepageService().apiGetData().then((value) {
      print(value.statusCode);
      switch (value.statusCode) {
        case 200:
          final decodedData = jsonDecode(value.body);
          responseList.clear();

          decodedData.forEach((v) {
            responseList.add(EntryModel.fromJson(v));
          });

          isloaded = true;
          update();
          break;
        case 401:
          responseList.clear();
          Get.offAll(LoginWidget());
          //  DialogHelper.showErroDialog(description: "Token not valid");
          break;
        case 1:
          responseList.clear();
          break;
        default:
          isloaded = true;
          responseList.clear();

          update();
          break;
      }
    });
  }

// //PaymentRecModel
//   SearchList(String query) async {
//     if (query.isNotEmpty) {
//       challanListData = challanList.first.data!
//           .where((elem) =>
//               elem.vehicleNo!.toLowerCase().contains(query) ||
//               elem.challanNo!.toLowerCase().contains(query))
//           .toList();
//     } else {
//       challanListData = challanList.first.data!;
//     }
//     update();
//   }

  onRefresh() {
    isloaded = false;
    update();
    getData();
  }
}
