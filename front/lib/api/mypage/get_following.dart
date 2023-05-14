import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<UserFollowingsInfo> getUserFollowings({
  required int userId,
  required int page,
  required int type
}) async {
  final dio = Dio(BaseOptions(
    baseUrl: '${dotenv.get('BASE_URL')}/api/following',
    // baseUrl: '${dotenv.get('BASE_URL')}/api/follow',
  ));
  final response = await dio.get('/$userId', queryParameters: {
    'page': page,
    'type': type+1,
  });

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.toString());
    final articleData = UserFollowingsInfo.fromJson(jsonData["data"]);
    print('내 팔로잉 정보 불러오기 성공');
    return articleData;
  } else {
    print('내 팔로잉 정보 불러오기 실패');
    throw Exception('Failed to load userArticles');
  }
}

class UserFollowingsInfo {
  final int pageSize;
  final int totalPageNumber;
  final int totalCount;
  final int pageNumber;
  final bool nextPage;
  final bool previousPage;
  final List<Follow> followings;

  UserFollowingsInfo({
    required this.pageSize,
    required this.totalPageNumber,
    required this.totalCount,
    required this.pageNumber,
    required this.nextPage,
    required this.previousPage,
    required this.followings,
  });

  factory UserFollowingsInfo.fromJson(Map<String, dynamic> json) {
    // final articlesList = json['articles'] as List<dynamic>;
    // final articles = articlesList
    //     .map((articleJson) => Follow.fromJson(articleJson))
    //     .toList();
    final List<dynamic> followingsList = json['followings'];
    final List<Follow> followings = followingsList
        .map((followJson) => Follow.fromJson(followJson))
        .toList();

    return UserFollowingsInfo(
      pageSize: json['pageSize'],
      totalPageNumber: json['totalPageNumber'],
      totalCount: json['totalCount'],
      pageNumber: json['pageNumber'],
      nextPage: json['nextPage'],
      previousPage: json['previousPage'],
      followings: followings,
      // followings:articles,
    );
  }
}

class Follow {
  final int userId;
  final String profile;
  final String nickname;

  Follow(
      {required this.userId,
        required this.profile,
        required this.nickname
      });

  factory Follow.fromJson(Map<String, dynamic> json) {
    return Follow(
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