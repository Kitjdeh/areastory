import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<SearchUsersInfo> getSearchUsers({
  required int userId,
  required int page,
  required String? search
}) async {
  final dio = Dio(BaseOptions(
    baseUrl: '${dotenv.get('BASE_URL')}/api/users',
    // baseUrl: '${dotenv.get('BASE_URL')}/api/follow',
  ));
  final response = await dio.get('/$userId/search', queryParameters: {
    'page': page,
    'search': search,
  });

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.toString());
    final articleData = SearchUsersInfo.fromJson(jsonData["data"]);
    print('내 검색 정보 불러오기 성공');
    return articleData;
  } else {
    print('내 검색 정보 불러오기 실패');
    throw Exception('Failed to load userArticles');
  }
}

class SearchUsersInfo {
  final int pageSize;
  final int totalPageNumber;
  final int totalCount;
  final int pageNumber;
  final bool nextPage;
  final bool previousPage;
  final List<Follow> followers;

  SearchUsersInfo({
    required this.pageSize,
    required this.totalPageNumber,
    required this.totalCount,
    required this.pageNumber,
    required this.nextPage,
    required this.previousPage,
    required this.followers,
  });

  factory SearchUsersInfo.fromJson(Map<String, dynamic> json) {
    // final articlesList = json['articles'] as List<dynamic>;
    // final articles = articlesList
    //     .map((articleJson) => Follow.fromJson(articleJson))
    //     .toList();
    final List<dynamic> followersList = json['followers'];
    final List<Follow> followers = followersList
        .map((followJson) => Follow.fromJson(followJson))
        .toList();

    return SearchUsersInfo(
      pageSize: json['pageSize'],
      totalPageNumber: json['totalPageNumber'],
      totalCount: json['totalCount'],
      pageNumber: json['pageNumber'],
      nextPage: json['nextPage'],
      previousPage: json['previousPage'],
      followers: followers,
      // followings:articles,
    );
  }
}

class Follow {
  final int userId;
  final String profile;
  final String nickname;
  final bool check;

  Follow(
      {required this.userId,
        required this.profile,
        required this.nickname,
        required this.check
      });

  factory Follow.fromJson(Map<String, dynamic> json) {
    return Follow(
      userId: json['userId'],
      profile: json['profile'],
      nickname: json['nickname'],
      check: json['check'],
    );
  }
}

