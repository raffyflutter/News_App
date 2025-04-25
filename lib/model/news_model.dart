class NewsModel {
  int? totalArticles;
  List<Articles>? articles;

  NewsModel({this.totalArticles, this.articles});

  NewsModel.fromJson(Map<String, dynamic> json) {
    totalArticles = json['totalArticles'];
    if (json['articles'] != null) {
      articles = <Articles>[];
      json['articles'].forEach((v) {
        articles!.add(Articles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalArticles'] = totalArticles;
    if (articles != null) {
      data['articles'] = articles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Articles {
  String? title;
  String? description;
  String? content;
  String? url;
  String? urlToimage;
  String? image;
  String? publishedAt;
  String? author;
  Source? source;

  Articles(
      {this.title,
      this.description,
      this.content,
      this.urlToimage,
      this.url,
      this.author,
      this.image,
      this.publishedAt,
      this.source});

  Articles.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    content = json['content'];
    url = json['url'];
    urlToimage = json['urlToImage'];
    image = json['image'];
    publishedAt = json['publishedAt'];
    author = json['author'];
    source = json['source'] != null ? Source.fromJson(json['source']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['content'] = content;
    data['url'] = url;
    data['image'] = image;
    data['urlToImage'] = urlToimage;
    data['author'] = author;
    data['publishedAt'] = publishedAt;
    if (source != null) {
      data['source'] = source!.toJson();
    }
    return data;
  }
}

class Source {
  String? name;
  String? url;

  Source({this.name, this.url});

  Source.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    return data;
  }
}
