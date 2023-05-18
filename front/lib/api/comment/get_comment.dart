import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<CommentData> getComment({
  required int articleId,
  required int commentId,
}) async {
  final dio = Dio(BaseOptions(
    baseUrl: '${dotenv.get('BASE_URL')}/api/articles',
  ));

  final storage = new FlutterSecureStorage();
  final userId = await storage.read(key: 'userId');

  final response =
      await dio.get('/$articleId/comments/$commentId', queryParameters: {
    'userId': userId,
  });

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.toString());
    final commentData = CommentData.fromJson(jsonData);
    return commentData;
  } else {
    print('댓글 조회 실패');
    throw Exception('Failed to load articles');
  }
}

class CommentData {
  final int commentId;
  final int articleId;
  final int userId;
  final String nickname;
  final String profile;
  final String content;
  final int likeCount;
  final bool likeYn;
  final DateTime createdAt;

  CommentData({
    required this.commentId,
    required this.articleId,
    required this.userId,
    required this.nickname,
    required this.profile,
    required this.content,
    required this.likeCount,
    required this.likeYn,
    required this.createdAt,
  });

  factory CommentData.fromJson(Map<String, dynamic> json) {
    return CommentData(
      commentId: json['commentId'],
      articleId: json['articleId'],
      userId: json['userId'],
      nickname: json['nickname'],
      profile: json['profile'],
      content: json['content'],
      likeCount: json['likeCount'],
      likeYn: json['likeYn'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
