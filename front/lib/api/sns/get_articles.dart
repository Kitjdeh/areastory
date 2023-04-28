import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Article>> getArticles(params) async {
  final response = await http.get(Uri.parse(
      'http://j8a302.p.ssafy.io:8080/api/v1/article-info/2?localDate=${params}'));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final articleData = ArticleData.fromJson(jsonData);

    var articles = articleData.articles;
    return articles;
  } else {
    throw Exception('Failed to load articles');
  }
}

class ArticleData {
  final int pageSize;
  final int totalPageNumber;
  final int totalCount;
  final List<Article> articles;

  ArticleData({
    required this.pageSize,
    required this.totalPageNumber,
    required this.totalCount,
    required this.articles,
  });

  factory ArticleData.fromJson(Map<String, dynamic> json) {
    final List<dynamic> articlesJson = json['articles'];
    final articles = articlesJson.map((e) => Article.fromJson(e)).toList();

    return ArticleData(
      pageSize: json['pageSize'],
      totalPageNumber: json['totalPageNumber'],
      totalCount: json['totalCount'],
      articles: articles,
    );
  }
}

class Article {
  final int articleId;
  final String nickname;
  final String profile;
  final String content;
  final String image;
  final int likeCount;
  final int commentCount;
  final bool isLike;
  final DateTime createdAt;
  final String location;

  Article({
    required this.articleId,
    required this.nickname,
    required this.profile,
    required this.content,
    required this.image,
    required this.likeCount,
    required this.commentCount,
    required this.isLike,
    required this.createdAt,
    required this.location,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      articleId: json['articleId'],
      nickname: json['nickname'],
      profile: json['profile'],
      content: json['content'],
      image: json['image'],
      likeCount: json['likeCount'],
      commentCount: json['commentCount'],
      isLike: json['isLike'],
      createdAt: DateTime.parse(json['createdAt']),
      location: json['location'],
    );
  }
}