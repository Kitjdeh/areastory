import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> createArticle({
  required int userId,
  required bool publicYn,
  required String content,
  required String si,
  required String gu,
  required String dong,
  required MultipartFile image,
}) async {
  final dio = Dio(BaseOptions(
    baseUrl: '${dotenv.get('BASE_URL')}/api/articles',
  ));

  final formData = FormData.fromMap({
    'userId': userId,
    'publicYn': publicYn,
    'content': content,
    'si': si,
    'gu': gu,
    'dong': dong,
    // 'image': await MultipartFile.fromFile(image.path),
  });

  final response = await dio.post(
    '',
    data: formData,
    options: Options(contentType: 'multipart/form-data'),
  );

  if (response.statusCode == 200) {
    print('성공');
  } else {
    print('실패');
    throw Exception('Failed to create article');
  }
}
