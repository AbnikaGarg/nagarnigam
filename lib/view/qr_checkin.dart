import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nagarnigam/service/home_service.dart';
import 'package:nagarnigam/util/app_colors.dart';
import 'package:nagarnigam/view/dashboard.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../components/base_elements.dart';

class QrCheckin extends StatefulWidget {
  const QrCheckin({super.key});

  @override
  State<QrCheckin> createState() => _nameState();
}

class _nameState extends State<QrCheckin> {
  // List changetoList(input) {
  //   // Step 1: Split the string by commas
  //   List<String> items = input.split(',');

  //   // Step 2: Trim whitespace from each item
  //   return items;
  // }

  Barcode? result;
  String response = "";
 String msg = "";
  ///final controller = MobileScannerController();
  int counter = 0;
  final service = HomepageService();
  //var bodyRes;
  void _submit(code) {
    DialogHelper.showLoading();
    service.apiCreatePickup(code).then((value) {
      print("JJj");

      Navigator.pop(context);

      switch (value.statusCode) {
        case 200:
          var data2 = jsonDecode(value.body);

          if (data2["errorCode"].toString() == "1") {
            DialogHelper.showToast(data2["errorDesc"].toString());
            Future.delayed(Duration(milliseconds: 400), () {
              Get.deleteAll();
              Get.offAll(DashBoard());
            });
          } else {
            response = "0";msg=data2["errorDesc"].toString();
            setState(() {});
            DialogHelper.showToast(data2["errorDesc"].toString());
          }

          break;
        case 1:
          DialogHelper.showToast("No Internet");
          break;
        default:
          response = "0";
          setState(() {});
          DialogHelper.showToast("Something went wrong");

          break;
      }
    });
  }

  resetscan() async {
    if (mounted) {
      qRViewController!.resumeCamera();
      setState(() {
        counter = 0;
        result = null;
        response = "";
      });
    }
  }

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController? qRViewController;
  // @override
  // void dispose() async {
  //   // Stop listening to lifecycle changes.

  //   super.dispose();
  //   // Finally, dispose of the controller.
  //   await controller.dispose();
  // }
  void _onQRViewCreated(QRViewController controller) {
    qRViewController = controller;
    controller.resumeCamera();
    controller.scannedDataStream.listen((scanData) async {
      counter++;
      controller.pauseCamera();
      setState(() {
        result = scanData;
        if (counter == 1) {
          Uri uri = Uri.parse(result!.code.toString());
          // Get the last segment of the URL path
          String id = uri.pathSegments.last;
          print('Extracted ID: $id');
          _submit(id);
        }
      });
    });
  }

  @override
  void dispose() {
    qRViewController?.dispose();
    super.dispose();
  }

  Future<bool> onWillPop() async {
    Future.delayed(Duration(milliseconds: 400), () {
      Get.offAll(DashBoard());
    });

    return false;
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qRViewController!.pauseCamera();
    } else if (Platform.isIOS) {
      qRViewController!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          titleSpacing: 0,
          leading: GestureDetector(
            onTap: () {
              onWillPop();
            },
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 18,
            ),
          ),
          elevation: 1,
          title: Text(
            "Qr Scan",
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color.fromARGB(255, 35, 35, 35),
            ),
          ),
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              if (response != "")
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 40,
                    ),
                    child: Container(
                      height: 45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Color(0x8C333335).withOpacity(0.1),
                              offset: Offset(1, 1),
                              blurRadius: 4.0,
                              spreadRadius: 2),
                        ],
                        color: response == "1"
                            ? Color.fromRGBO(28, 213, 160, 1)
                            : Color.fromRGBO(234, 99, 99, 1),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Center(
                          child: Text(
                        response == "1"
                            ? "Scanned Successfully"
                            : msg,
                        style: Get.theme.textTheme.headlineMedium!.copyWith(
                            fontSize: 16,
                            color: AppColors.whiteBackgroundColor),
                      )),
                    ),
                  ),
                )
              else
                Text(
                  "Align the Qr Code within\nthe frame for scan",
                  style: Get.theme.textTheme.bodySmall!.copyWith(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              SizedBox(
                height: 50,
              ),
              Container(
                height: 280,
                width: 280,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                      borderRadius: 10,
                      borderLength: 20,
                      borderColor: AppColors.primaryColor),
                ),
              ),
              // child: MobileScanner(
              //     overlayBuilder: (context, constraints) {
              //       return Container(
              //         color:i>0? AppTheme.darkTextColor:Colors.transparent,
              //       );
              //     },
              //     controller: controller,
              //     onDetect: _handleBarcode)),
              SizedBox(
                height: 30,
              ),
              if (response != "")
                GestureDetector(
                  onTap: () {
                    resetscan();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromRGBO(208, 208, 208, 1),
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Text(
                      "Continue Scan",
                      style: Get.theme.textTheme.bodyMedium!.copyWith(
                          fontSize: 14, color: AppColors.primaryColor),
                    ),
                  ),
                ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 22),
              //   child: Column(
              //     children: [
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(
              //             "1 x ame",
              //             style: Get.theme.textTheme.labelSmall!
              //                 .copyWith(fontSize: 14),
              //           ),

              //             Text(
              //               "1 x ame",
              //               style: Get.theme.textTheme.labelSmall!
              //                   .copyWith(fontSize: 14),
              //             ),
              //         ],
              //       ),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
// {
//   "status": 0,
//   "message": "Already Scanned",
//   "data": [
//     {
//       "eventId": 0,
//       "ticketBookingNo": null,
//       "ticketDate": null,
//       "manualCheckInTag": 0,
//       "errorCode": 0,
//       "errorDesc": "Already Scanned"
//     }
//   ]
// }