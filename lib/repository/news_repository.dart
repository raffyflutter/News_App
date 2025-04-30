// ignore_for_file: unnecessary_brace_in_string_interps, avoid_print

import 'dart:convert';

import 'package:get/get.dart';
import 'package:news_app/model/news_model.dart';
import 'package:http/http.dart' as http;

import '../constant/pakistan_news_channel.dart';
import '../model/news_category_model.dart';

class NewsRepository {
  RxList<Articles> countryArticles = <Articles>[].obs;
  RxList<Articles> channelArticles = <Articles>[].obs;

  var isLoading = false.obs;
  Future<NewsModel?> fetchNewsData() async {
    isLoading.value = true;
    try {
      String url =
          'https://gnews.io/api/v4/top-headlines?country=pk&max=20&token=97749c5f081ff37c79143cf5b47d870f';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print('data of newsPKkkkk${jsonData}');
        final newsModel = NewsModel.fromJson(jsonData);
        countryArticles.assignAll(newsModel.articles ?? []);
      }
    } catch (e) {
      print('Error: ${e.toString()}');
    }
    isLoading.value = false;
    return null;
  }

  Future<NewsModel?> fetchNewsFromChannel(PakistaniNewsChannel? channel) async {
    isLoading.value = true;
    var selectedValue = channel?.displayName ?? 'BOL';
    try {
      final url =
          'https://gnews.io/api/v4/search?q=${Uri.encodeComponent(selectedValue)}&lang=en&country=pk&max=20&apikey=97749c5f081ff37c79143cf5b47d870f';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final newsModel = NewsModel.fromJson(jsonDecode(response.body));
        channelArticles.assignAll(newsModel.articles ?? []);
        return newsModel;
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }

    return null;
  }

  Future<NewsCategorayModel?> fetchNewsCategory(String category) async {
    isLoading.value = true;
    try {
      final url =
          'https://gnews.io/api/v4/top-headlines?topic=$category&country=pk&lang=en&max=20&apikey=97749c5f081ff37c79143cf5b47d870f';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = NewsCategorayModel.fromJson(jsonDecode(response.body));
        return data;
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }

    return null;
  }
}
