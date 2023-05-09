import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AreaData {
  final Map<String, String>? locationDto;
  final String? image;
  final int? articleId;
  AreaData(
      {this.locationDto,
      this.image,
      this.articleId});
//   {
//   locationDto : {
//   "dosi" : "경기도",
//   "sigungu" : "연천군",
//   "dongeupmyeon" : "역삼동"
//   },
//   image : "http://localhost",
//   articleId : 3
// },
  factory AreaData.fromJson(Map<String, dynamic> json) {
    return AreaData(
        locationDto: json["locationDto"],
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
