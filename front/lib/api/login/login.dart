import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<LoginDataClass> getLogin(providerId, fcmToken) async {
  // print("fcmToken: $fcmToken");
  final dio = Dio(BaseOptions(
    baseUrl: '${dotenv.get('BASE_URL')}/api/users',
  ));
  final response = await dio.post(
    '/login',
    queryParameters: {'providerId': providerId, 'registrationToken':fcmToken},
  );

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.toString());
    final myData = LoginDataClass.fromJson(jsonData);
    return myData;
  } else {
    throw Exception('Failed to get data');
  }
}

class LoginDataClass {
  final int state;
  final bool success;
  final String msg;
  final dynamic? data;

  LoginDataClass({
    required this.state,
    required this.success,
    required this.msg,
    this.data,
  });

  factory LoginDataClass.fromJson(Map<String, dynamic> json) {
    return LoginDataClass(
      state: json['state'],
      success: json['success'],
      msg: json['msg'],
      data: json['data'],
    );
  }
}