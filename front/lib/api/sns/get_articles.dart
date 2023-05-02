import 'package:dio/dio.dart';

Future<ArticleData> getArticles(String params) async {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://k8a302.p.ssafy.io/api/articles/',
  ));
  final response = await dio.get(params.toString());

  if (response.statusCode == 200) {
    final jsonData = response.data;
    final articleData = ArticleData.fromJson(jsonData);

    return articleData;
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
