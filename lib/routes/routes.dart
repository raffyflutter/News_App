import 'package:get/get.dart';
import 'package:news_app/views/category_news.dart';
import 'package:news_app/views/splash_screen.dart';

import '../views/homes_screen.dart';

class Routes {
  static const String home = '/';
  static const String splashScreen = '/splashScreen';
  static const String categoryScreen = '/categoryScreen';
}

class AppPages {
  static final List<GetPage> pages = [
    GetPage(name: Routes.home, page: () => HomesScreen()),
    GetPage(name: Routes.splashScreen, page: () => SplashScreen()),
    GetPage(name: Routes.categoryScreen, page: () => CategoriesTabScreen()),
  ];
}
