import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<ArticleData> getArticles(dynamic params) async {
  final dio = Dio(BaseOptions(
    baseUrl: '${dotenv.get('BASE_URL')}/api/articles',
  ));
  final response = await dio.get('${params['sort']}', queryParameters: {
    'userId': params['userId'],
    'doName': params['doName'],
    'si': params['si'],
    'gun': params['gun'],
    'gu': params['gu'],
    'dong': params['dong'],
    'eup': params['eup'],
    'myeon': params['myeon']
  });

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.toString());
    final articleData = ArticleData.fromJson(jsonData);
    print('성공');
    return articleData;
  } else {
    print('실패');
    throw Exception('Failed to load articles');
  }
}

class ArticleData {
  final int pageSize;
  final int totalPageNumber;
  final int totalCount;
  final int pageNumber;
  final bool nextPage;
  final bool previousPage;
  final List<Article> articles;

  ArticleData({
    required this.pageSize,
    required this.totalPageNumber,
    required this.totalCount,
    required this.pageNumber,
    required this.nextPage,
    required this.previousPage,
    required this.articles,
  });

  factory ArticleData.fromJson(Map<String, dynamic> json) {
    final articlesList = json['articles'] as List<dynamic>;
    final articles = articlesList
        .map((articleJson) => Article.fromJson(articleJson))
        .toList();

    return ArticleData(
      pageSize: json['pageSize'],
      totalPageNumber: json['totalPageNumber'],
      totalCount: json['totalCount'],
      pageNumber: json['pageNumber'],
      nextPage: json['nextPage'],
      previousPage: json['previousPage'],
      articles: articles,
    );
  }
}

class Article {
  final int articleId;
  final int userId;
  final String nickname;
  final String profile;
  final String content;
  final String image;
  final int dailyLikeCount;
  final int totalLikeCount;
  final int commentCount;
  final bool likeYn;
  final DateTime createdAt;
  final String location;

  Article({
    required this.articleId,
    required this.userId,
    required this.nickname,
    required this.profile,
    required this.content,
    required this.image,
    required this.dailyLikeCount,
    required this.totalLikeCount,
    required this.commentCount,
    required this.likeYn,
    required this.createdAt,
    required this.location,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      articleId: json['articleId'],
      userId: json['userId'],
      nickname: json['nickname'],
      profile: json['profile'],
      content: json['content'],
      image: json['image'],
      dailyLikeCount: json['dailyLikeCount'],
      totalLikeCount: json['totalLikeCount'],
      commentCount: json['commentCount'],
      likeYn: json['likeYn'],
      createdAt: DateTime.parse(json['createdAt']),
      location: json['location'],
    );
  }
}
