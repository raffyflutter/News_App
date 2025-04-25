// ignore_for_file: file_names

import 'package:get/get.dart';
import '../model/news_category_model.dart';
import '../repository/news_repository.dart';

final NewsRepository newsRepository = Get.put(NewsRepository());

class CategoryController extends GetxController {
  var categories = [
    'general',
    'business',
    'entertainment',
    'health',
    'science',
    'sports',
    'technology',
  ].obs;

  var selectedCategory = 'general'.obs;
  var newsDataMap = <String, NewsCategorayModel>{}.obs;
  var isLoading = false.obs;

  void selectCategory(int index) {
    selectedCategory.value = categories[index];
    fetchNewsCategory(selectedCategory.value);
  }

  Future fetchNewsCategory(String category) async {
    isLoading.value = true;
    final response = await newsRepository.fetchNewsCategory(category);
    if (response != null) {
      newsDataMap[category] = response;
    }
    isLoading.value = false;
  }
}
