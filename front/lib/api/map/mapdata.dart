import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AreaData {
  final String? doName;
  final String? si;
  final String? gun;
  final String? gu;
  final String? dong;
  final String? eup;
  final String? myeon;
  final String? image;
  final int? articleId;
  AreaData(
      {this.doName,
      this.si,
      this.gun,
      this.gu,
      this.dong,
      this.eup,
      this.myeon,
      this.image,
      this.articleId});

  factory AreaData.fromJson(Map<String, dynamic> json) {
    return AreaData(
        doName: json["doName"],
        si: json["si"],
        gun: json["gun"],
        gu: json["gu"],
        dong: json["dong"],
        eup: json["eup"],
        myeon: json["myeon"],
        image: json["image"],
        articleId: json["articleId"]);
  }
}

Future<dynamic> postAreaData(List<Map<String, String>> data) async {
  print('post요청함수 시작');
  // print('data값${data.first}');
  List<AreaData> areadata = [];
  Map<String, String> headers = {
    'Content-Type': 'application/json',

  };
  // 'Accept': 'application/json',
  // 'Content-Type': 'application/json',
  // 'contentType': 'application/json',
  String url = '${dotenv.get('BASE_URL')}/api/map';
  http.Response response = await http.post(Uri.parse(url),
      body: json.encode(data), headers: headers);
  final int statuscode = response.statusCode;
  print("statuscode${statuscode}");
  await statuscode == 200
      ? areadata = jsonDecode(utf8.decode(response.bodyBytes))
      : print("에러가 발생 에러코드${response.statusCode}");
  return areadata;
}
