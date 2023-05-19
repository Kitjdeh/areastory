import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_parser/http_parser.dart';

Future<void> deleteFollower({
  required int followerId,
}) async {
  final dio = Dio(BaseOptions(
    baseUrl: '${dotenv.get('BASE_URL')}/api',
  ));

  final storage = new FlutterSecureStorage();
  final userId = await storage.read(key: 'userId');

  final response = await dio.delete('/follow', queryParameters: {
    'userId': userId,
    'followerId': followerId,
  });

  if (response.statusCode == 200) {
    print('팔로워 취소 성공');
  } else {
    print('팔로워 취소 실패');
    throw Exception('Failed to create article');
  }
}