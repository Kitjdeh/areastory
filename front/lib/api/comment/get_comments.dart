import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<CommentData> getComments({
  String? sort,
  required int articleId,
  int? page,
}) async {
  final dio = Dio(BaseOptions(
    baseUrl: '${dotenv.get('BASE_URL')}/api/articles',
  ));

  final storage = new FlutterSecureStorage();
  final userId = await storage.read(key: 'userId');

  final response = await dio.get('/$articleId/comments', queryParameters: {
    'sort': sort,
    'userId': userId,
    'page': page,
  });

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.toString());
    final commentData = CommentData.fromJson(jsonData);
    print('게시글의 댓글 조회 성공');
    return commentData;
  } else {
    print('게시글의 댓글 조회 실패');
    throw Exception('Failed to load articles');
  }
}

class CommentData {
  final int pageSize;
  final int totalPageNumber;
  final int totalCount;
  final int pageNumber;
  final bool nextPage;
  final bool previousPage;
  final List<Comment> comments;

  CommentData({
    required this.pageSize,
    required this.totalPageNumber,
    required this.totalCount,
    required this.pageNumber,
    required this.nextPage,
    required this.previousPage,
    required this.comments,
  });

  factory CommentData.fromJson(Map<String, dynamic> json) {
    final commentsList = json['comments'] as List<dynamic>;
    final comments = commentsList
        .map((commentJson) => Comment.fromJson(commentJson))
        .toList();

    return CommentData(
      pageSize: json['pageSize'],
      totalPageNumber: json['totalPageNumber'],
      totalCount: json['totalCount'],
      pageNumber: json['pageNumber'],
      nextPage: json['nextPage'],
      previousPage: json['previousPage'],
      comments: comments,
    );
  }
}

class Comment {
  final int commentId;
  final int articleId;
  final int userId;
  final String nickname;
  final String profile;
  final String content;
  final int likeCount;
  final bool likeYn;
  final DateTime createdAt;

  Comment({
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

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
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
