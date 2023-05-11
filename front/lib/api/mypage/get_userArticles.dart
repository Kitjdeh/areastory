import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<List<UserAriclesInfo>> getUserArticles({
  required int userId,
}) async {
  final dio = Dio(BaseOptions(
    baseUrl: '${dotenv.get('BASE_URL')}/api/users',
  ));
  final response = await dio.get('/$userId/articles', queryParameters: {
    'userId': userId,
  });

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.toString());
    final List<dynamic>articlesJson = jsonData["data"];
    print('내 게시글 정보 불러오기 성공');
    final userArticlesData = articlesJson.map((json) => UserAriclesInfo.fromJson(json)).toList();
    return userArticlesData;
  } else {
    print('내 게시글 정보 불러오기 실패');
    throw Exception('Failed to load userArticles');
  }
}

class UserAriclesInfo {
  final int articleId;
  final String image;

  UserAriclesInfo(
      {required this.articleId,
        required this.image,
      }
      );

  factory UserAriclesInfo.fromJson(Map<String, dynamic> json) {
    return UserAriclesInfo(
      articleId: json['articleId'],
      image: json['image'],
    );
  }
}

// class UserAriclesInfo {
//   final List<Article> articles;
//
//   UserAriclesInfo({
//     required this.articles,
//   });
//
//   factory UserAriclesInfo.fromJson(Map<String, dynamic> json) {
//     final articlesList = json['articles'] as List<dynamic>;
//     final articles = articlesList
//         .map((articleJson) => Article.fromJson(articleJson))
//         .toList();
//
//     return UserAriclesInfo(
//       articles:articles,
//     );
//   }
// }