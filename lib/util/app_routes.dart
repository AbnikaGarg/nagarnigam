
import 'package:nagarnigam/bindings/splash_bindings.dart';

import 'package:nagarnigam/view/splash_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class Routes {
  static String home = '/home';
  static String splash = '/';
  static String login = '/login';
  static String signup = '/signup';
  static String addChallan = '/addchallan';
  static String addReceipt = '/addReceipt';
  static String withdrawal = '/withdrawal';
  static String transferFunds = '/transferFunds';
}

appRoutes() => [
      GetPage(
        name: Routes.splash,
        binding: SplashScreenBindings(),
        page: () => SplashScreen(),
      ),
    ];
