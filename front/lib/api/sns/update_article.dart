import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_parser/http_parser.dart';

Future<void> patchArticle({
  required int articleId,
  required bool publicYn,
  required String content,
}) async {
  final dio = Dio(BaseOptions(
    baseUrl: '${dotenv.get('BASE_URL')}/api/articles',
  ));

  final storage = new FlutterSecureStorage();
  final userId = await storage.read(key: 'userId');

  final formData = FormData.fromMap({
    'param': MultipartFile.fromString(
        json.encode({
          'userId': userId,
          'content': content,
          'publicYn': publicYn,
        }),
        contentType: MediaType.parse('application/json')),
  });

  final response = await dio.patch(
    '/$articleId',
    data: formData,
  );

  if (response.statusCode == 200) {
    print('게시글 수정 성공');
  } else {
    print('게시글 수정 실패');
    throw Exception('Failed to update article');
  }
}
