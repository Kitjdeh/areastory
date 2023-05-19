import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<List<Followers>> getFollowers({
  required int page,
  required String? search,
}) async {
  final dio = Dio(BaseOptions(
    baseUrl: '${dotenv.get('BASE_URL')}/api',
  ));

  final storage = FlutterSecureStorage();
  final userId = await storage.read(key: 'userId');

  final response = await dio.get('/follow/$userId', queryParameters: {
    'page': page,
    'search': search,
  });

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.toString());
    final List<dynamic> followersList = jsonData['data'];
    final List<Followers> followers = followersList
        .map((followersJson) => Followers.fromJson(followersJson))
        .toList();

    print('팔로워 유저 요청 성공');
    return followers;
  } else {
    print('팔로워 유저 요청 실패');
    throw Exception('Failed to load followers');
  }
}

class Followers {
  final int userId;
  final String nickname;
  final String profile;
  final bool check;

  Followers({
    required this.userId,
    required this.nickname,
    required this.profile,
    required this.check,
  });

  factory Followers.fromJson(Map<String, dynamic> json) {
    return Followers(
      userId: json['userId'],
      nickname: json['nickname'],
      profile: json['profile'],
      check: json['check'],
    );
  }
}
