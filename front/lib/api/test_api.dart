import 'dart:convert';
import 'package:http/http.dart' as http;

Future<MyDataClass> getData(params) async {
  final response =
      await http.get(Uri.parse('https://k8a302.p.ssafy.io/api/users/${params}'));
  print(response);
  if (response.statusCode == 404) {
    print('11');
    // 성공적인 응답을 받았을 때
    final jsonData = json.decode(response.body);
    final myData = MyDataClass.fromJson(jsonData);

    return myData;
  } else {
    throw Exception('Failed to get data'); // 요청 실패
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
