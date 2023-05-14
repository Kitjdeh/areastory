import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future deleteUser({required int userId}) async {
  print("회원탈퇴 진행합니다?~!!!!!");
  final dio = Dio(BaseOptions(
    baseUrl: '${dotenv.get('BASE_URL')}/api/users',
  ));
  final response = await dio.delete(
    '/${userId}',
  );

  if (response.statusCode == 200) {
    return response.statusCode;
  } else {
    throw Exception('Failed to get data');
  }
}