import 'dart:convert';
import 'package:dio/dio.dart';


Future<MyDataClass> getData(params) async {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://k8a302.p.ssafy.io/api/users/',
  ));
  final response = await dio.get(params.toString());

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.toString());
    final myData = MyDataClass.fromJson(jsonData);

    return myData;
  } else {
    throw Exception('Failed to get data');
  }
}

class MyDataClass {
  final int state;
  final bool success;
  final String msg;
  final dynamic? data;

  MyDataClass({
    required this.state,
    required this.success,
    required this.msg,
    this.data,
  });

  factory MyDataClass.fromJson(Map<String, dynamic> json) {
    return MyDataClass(
      state: json['state'],
      success: json['success'],
      msg: json['msg'],
      data: json['data'],
    );
  }
}
