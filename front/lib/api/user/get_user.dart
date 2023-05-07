import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<UserData> getUser({
  required int userId,
}) async {
  final dio = Dio(BaseOptions(
    baseUrl: '${dotenv.get('BASE_URL')}/api/users',
  ));

  final storage = new FlutterSecureStorage();
  final myId = await storage.read(key: 'userId');

  final response = await dio.get('/$userId', queryParameters: {
    'myId': myId,
  });

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.toString());
    final userData = UserData.fromJson(jsonData["data"]);
    print('게시글 요청 성공');
    return userData;
  } else {
    print('실패');
    throw Exception('Failed to load articles');
  }
}

class UserData {
  final int userId;
  final String nickname;
  final String profile;
  final bool followYn;
  final int followCount;
  final int followingCount;

  UserData({
    required this.userId,
    required this.nickname,
    required this.profile,
    required this.followYn,
    required this.followCount,
    required this.followingCount,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json['userId'],
      nickname: json['nickname'],
      profile: json['profile'],
      followYn: json['followYn'],
      followCount: json['followCount'],
      followingCount: json['followingCount'],
    );
  }
}
