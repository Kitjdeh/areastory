import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_parser/http_parser.dart';

Future<void> patchComment({
  required int articleId,
  required int commentId,
  required String content,
}) async {
  final dio = Dio(BaseOptions(
    baseUrl: '${dotenv.get('BASE_URL')}/api/articles',
  ));

  final storage = new FlutterSecureStorage();
  final userId = await storage.read(key: 'userId');

  final response = await dio.patch(
    '/$articleId/comments/${commentId}',
    queryParameters: {
      'userId': userId,
      'content': content,
    },
  );

  if (response.statusCode == 200) {
    print('댓글 수정 성공');
  } else {
    print('댓글 수정 실패');
    throw Exception('Failed to create article');
  }
}
