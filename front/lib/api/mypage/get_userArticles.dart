import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<UserAriclesInfo> getUserArticles({
  required int userId,
  required int page,
}) async {
  final dio = Dio(BaseOptions(
    baseUrl: '${dotenv.get('BASE_URL')}/api/users',
  ));
  final response = await dio.get('/$userId/articles', queryParameters: {
    'userId': userId,
    'page': page,
  });

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.toString());
    final userArticlesData = UserAriclesInfo.fromJson(jsonData["data"]);
    print('내 게시글 정보 불러오기 성공');
    return userArticlesData;
  } else {
    print('내 게시글 정보 불러오기 실패');
    throw Exception('Failed to load userArticles');
  }
}

class UserAriclesInfo {
  final int pageSize;
  final int totalPageNumber;
  final int totalCount;
  final int pageNumber;
  final bool nextPage;
  final bool previousPage;
  final List<Article> articles;

  UserAriclesInfo({
    required this.pageSize,
    required this.totalPageNumber,
    required this.totalCount,
    required this.pageNumber,
    required this.nextPage,
    required this.previousPage,
    required this.articles,
  });

  factory UserAriclesInfo.fromJson(Map<String, dynamic> json) {
    final articlesList = json['articles'] as List<dynamic>;
    final articles = articlesList
        .map((articleJson) => Article.fromJson(articleJson))
        .toList();

    return UserAriclesInfo(
      pageSize: json['pageSize'],
      totalPageNumber: json['totalPageNumber'],
      totalCount: json['totalCount'],
      pageNumber: json['pageNumber'],
      nextPage: json['nextPage'],
      previousPage: json['previousPage'],
      articles:articles,
    );
  }
}

class Article {
  final int articleId;
  final String image;

  Article(
      {required this.articleId,
        required this.image,
      }
      );

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      articleId: json['articleId'],
      image: json['image'],
    );
  }
}
