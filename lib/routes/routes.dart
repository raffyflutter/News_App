import 'package:get/get.dart';
import 'package:news_app/views/splash_screen.dart';

import '../views/home_screen.dart';

class Routes {
  static const String home = '/';
  static const String portfolio = '/portfolio';
  static const String services = '/services';

  static const String services_description = '/services_description';
  static const String splashScreen = '/splashScreen';
  static const String ai_learning = '/ai_learning';
}

class AppPages {
  static final List<GetPage> pages = [
    GetPage(name: Routes.home, page: () => HomeScreen()),
    GetPage(name: Routes.splashScreen, page: () => SplashScreen()),
    // GetPage(name: Routes.services, page: () => OurservicesScreen()),
    // GetPage(name: Routes.ai_learning, page: () => AIMLScreen()),
  ];
}
