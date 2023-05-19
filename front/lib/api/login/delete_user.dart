import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future deleteUser({required int userId}) async {
  final dio = Dio(BaseOptions(
    baseUrl: '${dotenv.get('BASE_URL')}/api/users',
  ));
  final response = await dio.delete(
    '/${userId}',
  );

  if (response.statusCode == 200) {
    print("회원탈퇴 성공");
    return response.statusCode;
  } else {
    print("회원탈퇴 실패");
    throw Exception('Failed to get data');
  }
}