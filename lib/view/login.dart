import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbols.dart';
import '../components/user_input.dart';
import '../service/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/app_colors.dart';
import '../util/base.dart';
import 'dashboard.dart';

class LoginWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color.fromARGB(255, 243, 241, 241),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 60,
                ),
                Center(
                  child: Image.asset(
                    "assets/mcb.jpeg",
                    width: 120,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    "Nagar Nigam Varanasi",
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Center(
                  child: Text(
                    "Sweeper Attendance Monitoring",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SignInForm(),
                // Padding(
                //   padding: EdgeInsets.symmetric(vertical: 20.h),
                //   child: const Text(
                //     "Sign Up with Email, Apple or Google",
                //     style: TextStyle(
                //       color: Colors.black54,
                //     ),
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     Container(
                //       height: 50.0,
                //       width: 50.0,
                //       decoration: BoxDecoration(
                //         shape: BoxShape.circle,
                //         border: Border.all(color: Colors.black26),
                //       ),
                //       child: Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Container(
                //           decoration: const BoxDecoration(
                //             image: DecorationImage(
                //               image: AssetImage('assets/google.png'),
                //               fit: BoxFit.cover,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //     Container(
                //       height: 50.0,
                //       width: 50.0,
                //       decoration: BoxDecoration(
                //         shape: BoxShape.circle,
                //         border: Border.all(color: Colors.black26),
                //       ),
                //       child: Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Container(
                //           decoration: BoxDecoration(
                //             image: DecorationImage(
                //               image: AssetImage('assets/apple.png'),
                //               fit: BoxFit.cover,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //     Container(
                //       height: 50.0,
                //       width: 50.0,
                //       decoration: BoxDecoration(
                //         shape: BoxShape.circle,
                //         border: Border.all(color: Colors.black26),
                //       ),
                //       child: Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Container(
                //           decoration: const BoxDecoration(
                //             image: DecorationImage(
                //               image: AssetImage('assets/email.png'),
                //               fit: BoxFit.cover,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                // ],
                //   )
              ]),
        ),
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  const SignInForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  bool selected = false;
  bool _isValid = false;
  bool iconChange = false;
  final emailController = TextEditingController();
  final password = TextEditingController();

  Future<void> _submit() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    if (_formKey.currentState!.validate()) {
      DialogHelp.showLoading("", context);
      final service = ApiLoginPasswordService();
      service.ApiLoginService(emailController.text, password.text)
          .then((value) {
        DialogHelp.hideLoading(context);
        if (value != null) {
          if (value["errorCode"] == 1) {
            prefs.setString("Token", value["token"].toString());
            prefs.setString("name", value["fullName"].toString());
            prefs.setString("userId", value["userId"].toString());
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => DashBoard()),
                (_) => false);
          } else {
            Fluttertoast.showToast(
                msg: "Invalid Credentials",
                backgroundColor: Colors.red,
                gravity: ToastGravity.TOP,
                textColor: Colors.white);
          }
        } else {
          Fluttertoast.showToast(
              msg: "Invalid Credentials",
              backgroundColor: Colors.red,
              gravity: ToastGravity.TOP,
              textColor: Colors.white);
        }
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: () {
        final isValid = _formKey.currentState!.validate();
        if (_isValid != isValid) {
          setState(() {
            _isValid = isValid;
          });
        }
      },
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Username",
          style: GoogleFonts.inter(color: Colors.black),
        ),
        MyTextField(
            icon: Icon(CupertinoIcons.mail),
            textEditingController: emailController,
            validation: (value) {
              if (value == null || value.isEmpty) {
                return "Username is required";
              }

              return null;
            },
            hintText: "Enter username",
            color: Color.fromARGB(255, 255, 255, 255)),
        SizedBox(
          height: 10,
        ),
        Text(
          "Password",
          style: GoogleFonts.inter(color: Colors.black),
        ),
        MyTextField(
            icon: Icon(Icons.lock_open_rounded),
            obsecureText: true,
            textEditingController: password,
            validation: (value) {
              if (value == null || value.isEmpty) {
                return "Password is required";
              }

              return null;
            },
            hintText: "*********",
            color: Color.fromARGB(255, 255, 255, 255)),
        Padding(
          padding: EdgeInsets.only(
            top: 30,
          ),
          child: InkWell(
            onTap: () {
              _submit();
            },
            child: Center(
              child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 1.1,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4.0,
                          color: Color(0x430F1113),
                          offset: Offset(0.0, 3.0),
                        )
                      ],
                      color: AppColors.maincolor,
                      borderRadius: BorderRadius.circular(25)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // TweenAnimationBuilder<double>(
                      //   tween: Tween(begin: 1.0, end: 0.0),
                      //   duration: const Duration(seconds: 2),
                      //   child: Icon(
                      //     CupertinoIcons.arrow_right,
                      //     color: Colors.white,
                      //   ),
                      //   builder: (context, value, child) {
                      //     return Opacity(opacity: 1);
                      //   },
                      // ),

                      Text(
                        "Sign In",
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  )),
            ),
          ),
        ),
      //  Spacer(),
        // Padding(
        //   padding: EdgeInsets.only(top: 8, bottom: 24),
        //   child: ElevatedButton.icon(
        //       onPressed: () {
        //         _submit();
        //       },
        //       style: ElevatedButton.styleFrom(
        //           primary: AppColors.maincolor,
        //           minimumSize: Size(double.infinity, 56),
        //           shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.only(
        //                   topRight: Radius.circular(25),
        //                   topLeft: Radius.circular(10),
        //                   bottomLeft: Radius.circular(25),
        //                   bottomRight: Radius.circular(25)))),
        //       icon: Icon(CupertinoIcons.arrow_right),
        //       label: Text("Sign In")),
        // ),
       
      ]),
    );
  }
}
