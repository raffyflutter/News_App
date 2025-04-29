import 'package:get/get.dart';
import 'package:news_app/views/splash_screen.dart';

import '../views/homes_screen.dart';

class Routes {
  static const String home = '/';
  static const String splashScreen = '/splashScreen';
  static const String categoryScreen = '/splashScreen';
}

class AppPages {
  static final List<GetPage> pages = [
    GetPage(name: Routes.home, page: () => HomesScreen()),
    GetPage(name: Routes.splashScreen, page: () => SplashScreen()),
  ];
}
