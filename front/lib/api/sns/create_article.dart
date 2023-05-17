import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_parser/http_parser.dart';

Future<void> postArticle({
  required bool publicYn,
  required String content,
  required File image,
  required String dosi,
  required String sigungu,
  required String dongeupmyeon,
}) async {
  final dio = Dio(BaseOptions(
    baseUrl: '${dotenv.get('BASE_URL')}/api/articles',
  ));

  final storage = new FlutterSecureStorage();
  final userId = await storage.read(key: 'userId');

  // print(userId);

  final formData = FormData.fromMap({
    'articleWriteReq': MultipartFile.fromString(
        json.encode({
          'userId': userId,
          'publicYn': publicYn,
          'content': content,
          'dosi': dosi,
          'sigungu': sigungu,
          'dongeupmyeon': dongeupmyeon
        }),
        contentType: MediaType.parse('application/json')),
    'picture': await MultipartFile.fromFile(
      image!.path,
      filename: image!.path.split('/').last,
    )
  });


  final response = await dio.post(
    '',
    data: formData,
  );

  if (response.statusCode == 200) {
    print('게시글 생성 성공');
  } else {
    print('게시글 생성 실패');
    throw Exception('Failed to create article');
  }
}
