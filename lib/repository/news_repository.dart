import 'dart:convert';

import 'package:news_app/model/news_model.dart';
import 'package:http/http.dart' as http;

class NewsRepository {
  Future<NewsModel?> fetchNewsData() async {
    try {
      String url =
          'https://newsapi.org/v2/top-headlines?country=us&apiKey=68ab3d58ae054506b01bc5579ca33af2';
      // String url =
      //     'https://gnews.io/api/v4/top-headlines?country=pk&token=97749c5f081ff37c79143cf5b47d870f';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return NewsModel.fromJson(jsonData);
      }
    } catch (e) {
      print('Error: ${e.toString()}');
      return null;
    }
    return null;
  }
}
