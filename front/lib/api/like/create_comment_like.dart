import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_parser/http_parser.dart';

Future<void> postCommentLike({
  required int articleId,
  required int commentId,
}) async {
  final dio = Dio(BaseOptions(
    baseUrl: '${dotenv.get('BASE_URL')}/api/articles',
  ));

  final storage = new FlutterSecureStorage();
  final userId = await storage.read(key: 'userId');

  final response =
      await dio.post('/$articleId/comments/like/$commentId', queryParameters: {'userId': userId});

  if (response.statusCode == 200) {
    print('댓글 좋아요 성공');
  } else {
    print('댓글 좋아요 실패');
    throw Exception('Failed to create article');
  }
}
