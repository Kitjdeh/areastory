import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<ArticleData> getFollowArticles({
  int? page,
}) async {
  final dio = Dio(BaseOptions(
    baseUrl: '${dotenv.get('BASE_URL')}/api/articles',
  ));

  final storage = new FlutterSecureStorage();
  final userId = await storage.read(key: 'userId');

  final response = await dio.get('/follow', queryParameters: {
    'userId': userId,
    'page': page,
  });

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.toString());
    final articleData = ArticleData.fromJson(jsonData);
    print('all팔로우게시글 요청 성공');
    return articleData;
  } else {
    print('all팔로우게시글 요청 실패');
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
  final bool followYn;
  final DateTime createdAt;
  String? dosi;
  String? sigungu;
  String? dongeupmyeon;

  Article(
      {required this.articleId,
      required this.userId,
      required this.nickname,
      required this.profile,
      required this.content,
      required this.image,
      required this.dailyLikeCount,
      required this.totalLikeCount,
      required this.commentCount,
      required this.likeYn,
      required this.followYn,
      required this.createdAt,
      this.dosi,
      this.sigungu,
      this.dongeupmyeon});

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
      followYn: json['followYn'],
      createdAt: DateTime.parse(json['createdAt']),
      dosi: json['dosi'],
      sigungu: json['sigungu'],
      dongeupmyeon: json['dongeupmyeon'],
    );
  }
}
