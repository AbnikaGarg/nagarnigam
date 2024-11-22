import 'package:flutter/cupertino.dart';
import 'package:nagarnigam/controller/dashboard_controller.dart';
import 'package:nagarnigam/service/pref_service.dart';
import 'package:nagarnigam/util/app_colors.dart';
import 'package:nagarnigam/util/app_routes.dart';
import 'package:nagarnigam/util/app_url.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nagarnigam/view/qr_checkin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/user_input.dart';
import '../util/utils.dart';
import 'login.dart';

class DashBoard extends StatelessWidget {
  DashBoard({super.key});
  final _controller = Get.put<DashboardController>(DashboardController());

  logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    Get.dialog(
        barrierDismissible: false,
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(50)),
              width: 50,
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: CupertinoActivityIndicator(
                    color: AppColors.primaryColor, radius: 14),
              ),
            ),
          ],
        ));

    preferences.clear();
    await Future.delayed(Duration(seconds: 1));
    Get.offAll(LoginWidget());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.backGround2,
        appBar: AppBar(
          backgroundColor: AppColors.backGround2,
          elevation: 0,
          titleSpacing: 20,
          centerTitle: false,
          // leading: const Icon(Icons.menu),
          title: Text(
            "Dashboard",
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color.fromARGB(255, 35, 35, 35),
            ),
          ),
          actions: [
            PopupMenuButton<int>(
              icon: Icon(Icons.account_circle),
              itemBuilder: (context) => [
                // PopupMenuItem 1

                PopupMenuItem(
                  value: 2,
                  // row with two children
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        size: 20,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        " Logout ",
                      )
                    ],
                  ),
                ),
              ],
              offset: Offset(-25, 20),

              elevation: 2,
              // on selected we show the dialog box
              onSelected: (value) {
                if (value == 2) {
                  logout();
                }
              },
            )
          ],
        ),
        body: GetBuilder<DashboardController>(builder: (controller) {
          return !controller.isloaded
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () {
                    return Future.delayed(
                      Duration(milliseconds: 400),
                      () {
                        controller.onRefresh();
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: AppColors.lightHintTextColor.withOpacity(0.3),
                                    offset: const Offset(1, 1),
                                    blurRadius: 2.0,
                                    spreadRadius: 2),
                              ],
                              borderRadius: BorderRadius.circular(12),
                              color: Color.fromARGB(255, 255, 255, 255)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    Utils().getGreetingMsg(),
                                    style: GoogleFonts.inter(
                                        color: AppColors.blackColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18),
                                  ),
                                  Text(
                                    "${DateFormat('dd MMM yyyy').format(DateTime.now())}",
                                    style: GoogleFonts.inter(
                                        color: AppColors.blackColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "${PreferenceUtils.getString("name")}",
                                      style: GoogleFonts.inter(
                                          color: AppColors.blackColor,
                                          fontSize: 16),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  QrCheckin()));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: 5),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Text(
                                        "Scan here",
                                        style: GoogleFonts.inter(
                                            color:
                                                AppColors.whiteBackgroundColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 6,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 14),
                        //   child: MyTextField(
                        //       textEditingController: controller.searchController,
                        //       onChanged: (value) {
                        //         controller.SearchList(value);
                        //       },
                        //       icon: Icon(
                        //         Icons.search,
                        //         color: AppColors.blackColor,
                        //         size: 22,
                        //       ),
                        //       hintText: "Search",
                        //       color: AppColors.whiteBackgroundColor),
                        // ),
                        Text(
                          "Scanned Properties",
                          style: Get.theme.textTheme.headlineLarge!.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        if (controller.responseList.isNotEmpty)
                          Expanded(
                            child: ListView.builder(
                                itemCount: controller.responseList.length,
                                shrinkWrap: true,
                                //   primary: false,
                                itemBuilder: (context, index) {
                                  return Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 12),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border(
                                              left: BorderSide(
                                                  color: AppColors.maincolor
                                                      .withOpacity(0.5),
                                                  width: 9),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: AppColors.backGround2,
                                                  offset: const Offset(0, 0),
                                                  blurRadius: 2.0,
                                                  spreadRadius: 2),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Property No: ${controller.responseList[index].propertyNo} ",
                                                style: GoogleFonts.inter(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                              ),

                                              SizedBox(height: 6),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text("Type: ",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      )),
                                                  Expanded(
                                                    child: Text(
                                                      " ${controller.responseList[index].propertyType} ",
                                                      style: GoogleFonts.inter(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: AppColors
                                                              .blackColor),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              //                                     static const primary = Color(0xFF2A85FF);
                                              // static const primaryPurple = Color(0xFF8E59FF);
                                              // static const success = Color(0xFF83BF6E);
                                              // static const error = Color(0xFFFF6A55);
                                              SizedBox(
                                                height: 6,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("Owner: ",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      )),
                                                  Flexible(
                                                    child: Text(
                                                      " ${controller.responseList[index].ownerName} ",
                                                      style: GoogleFonts.inter(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Color.fromRGBO(
                                                              43, 48, 52, 1)),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              SizedBox(
                                                height: 6,
                                              ),
                                            ]),
                                      ));
                                }),
                          )
                        else
                          Center(
                            child: Text("No Records Found"),
                          )
                      ],
                    ),
                  ),
                );
        }),
      ),
    );
  }
}
