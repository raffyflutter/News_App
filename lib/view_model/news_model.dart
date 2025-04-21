import '../model/news_model.dart';
import '../repository/news_repository.dart';

class NewsViewModel {
  final repo = NewsRepository();
  Future<NewsModel?> fetchNewsData() async {
    final response = await repo.fetchNewsData();
    return response;
  }
}
