import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<UserInfo> getUserInfo({
  required int userId,
}) async {
  final dio = Dio(BaseOptions(
    baseUrl: '${dotenv.get('BASE_URL')}/api/users',
  ));
  final response = await dio.get('/$userId', queryParameters: {
    'userId': userId,
  });

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.toString());
    final userInfo = UserInfo.fromJson(jsonData);
    print('유저 정보 불러오기 성공');
    return userInfo;
  } else {
    print('유저 정보 불러오기 실패');
    throw Exception('Failed to load articles');
  }
}

class UserInfo {
  final int userId;
  final String nickname;
  final String? profile;
  final int followCount;
  final int followingCount;

  UserInfo({
    required this.userId,
    required this.nickname,
    required this.profile,
    required this.followCount,
    required this.followingCount,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      userId: json['userId'],
      nickname: json['nickname'],
      profile: json['profile'],
      followCount: json['followCount'],
      followingCount: json['followingCount'],
    );
  }
}
