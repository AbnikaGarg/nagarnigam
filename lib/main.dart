import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

import 'service/pref_service.dart';
import 'util/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceUtils.init();
  requestPermissions();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MyApp());
}
  Future<void> requestPermissions() async {
  final status = await Permission.location.request();
 
  if (!status.isGranted) {
    //throw Exception('Location permission not granted');
  }
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MCB Challan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        dialogBackgroundColor: Colors.white,
        popupMenuTheme: PopupMenuThemeData(color: Colors.white),
        dropdownMenuTheme: DropdownMenuThemeData(
            inputDecorationTheme:
                InputDecorationTheme(fillColor: Colors.white)),
        fontFamily: GoogleFonts.montserrat().fontFamily,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        // useMaterial3: true,
      ),
      initialRoute: Routes.splash,
      getPages: appRoutes(),
    );
  }
}
