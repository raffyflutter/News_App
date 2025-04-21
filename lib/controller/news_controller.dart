import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsViewModelController extends GetxController {
  RxBool isLaunching = false.obs;

  Future<void> launchArticle(String url) async {
    isLaunching.value = true;
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar("Error", "Could not launch the article");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLaunching.value = false;
    }
  }
}
