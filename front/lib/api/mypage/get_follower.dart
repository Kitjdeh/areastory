import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<List<UserFollowersInfo>> getUserFollowers({
  required int userId,
}) async {
  final dio = Dio(BaseOptions(
    baseUrl: '${dotenv.get('BASE_URL')}/api/following',
    // baseUrl: '${dotenv.get('BASE_URL')}/api/follow',
  ));
  final response = await dio.get('/$userId', queryParameters: {
    'search': null
  });

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.toString());
    final List<dynamic>articlesJson = jsonData["data"];
    print('내 팔로워 정보 불러오기 성공');
    final userArticlesData = articlesJson.map((json) => UserFollowersInfo.fromJson(json)).toList();
    return userArticlesData;
  } else {
    print('내 팔로워 정보 불러오기 실패');
    throw Exception('Failed to load userArticles');
  }
}

class UserFollowersInfo {
  final int userId;
  final String profile;
  final String nickname;

  UserFollowersInfo(
      {
        required this.userId,
        required this.profile,
        required this.nickname,
      }
      );

  factory UserFollowersInfo.fromJson(Map<String, dynamic> json) {
    return UserFollowersInfo(
      userId: json['userId'],
      profile: json['profile'],
      nickname: json['nickname'],
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