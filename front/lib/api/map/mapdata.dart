import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AreaData {
  final Map<String, String?>? locationDto;
  final String? image;
  final int? articleId;
  AreaData({this.locationDto, this.image, this.articleId});
  factory AreaData.fromJson(Map<String, dynamic> json) {
    print('22');
    return AreaData(
        locationDto: Map<String, String?>.from(json["locationDto"]),
        image: json["image"],
        articleId: json["articleId"]);
  }
}

Future<Map<String, AreaData>> postAreaData(
    List<Map<String, String>> data) async {

  List<Map<String, dynamic>> responseJson = [];

  List<AreaData> areadata = [];
  Map<String, AreaData> AreaInfo = {};
  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };
  String url = '${dotenv.get('BASE_URL')}/api/map';
  http.Response response = await http.post(Uri.parse(url),
      body: json.encode(data), headers: headers);
  final int statuscode = response.statusCode;

  await statuscode == 200
      ? responseJson = List<Map<String, dynamic>>.from(
          jsonDecode(utf8.decode(response.bodyBytes))) // 응답 데이터를 변환하여 저장
      // areadata = jsonDecode(utf8.decode(response.bodyBytes))
      : print("에러가 발생 에러코드${response.statusCode}");
  await statuscode == 200
      ? Future.forEach(responseJson, (e) {
          areadata.add(AreaData.fromJson(e));
        })
      : null;

  // print('areadata${areadata}');
  await areadata != null
      ? Future.forEach(areadata, (e) {
          e.locationDto!['dongeupmyeon'] != null
              ? AreaInfo.addAll({e.locationDto!['dongeupmyeon'] ?? "": e})
              : e.locationDto!['sigungu'] != null
                  ? AreaInfo.addAll({e.locationDto!['sigungu'] ?? "": e})
                  : AreaInfo.addAll({e.locationDto!['dosi'] ?? "": e});
        })
      : null;
  // Future.forEach(areadata, (e) {
  //  print('e${e.locationDto}');
  // });
  return AreaInfo;
}
Future<Map<String, AreaData>> postmyAreaData(
    List<Map<String, String>> data,String userid) async {

  List<Map<String, dynamic>> responseJson = [];

  List<AreaData> areadata = [];
  Map<String, AreaData> AreaInfo = {};
  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };
  String url = '${dotenv.get('BASE_URL')}/api/map/${userid}';
  print('요청url${url}');
  http.Response response = await http.post(Uri.parse(url),
      body: json.encode(data), headers: headers);
  final int statuscode = response.statusCode;

  await statuscode == 200
      ? responseJson = List<Map<String, dynamic>>.from(
      jsonDecode(utf8.decode(response.bodyBytes))) // 응답 데이터를 변환하여 저장
  // areadata = jsonDecode(utf8.decode(response.bodyBytes))
      : print("에러가 발생 에러코드${response.statusCode}");
  await statuscode == 200
      ? Future.forEach(responseJson, (e) {
    areadata.add(AreaData.fromJson(e));
  })
      : null;

  await areadata != null
      ? Future.forEach(areadata, (e) {
    e.locationDto!['dongeupmyeon'] != null
        ? AreaInfo.addAll({e.locationDto!['dongeupmyeon'] ?? "": e})
        : e.locationDto!['sigungu'] != null
        ? AreaInfo.addAll({e.locationDto!['sigungu'] ?? "": e})
        : AreaInfo.addAll({e.locationDto!['dosi'] ?? "": e});
  })
      : null;
  return AreaInfo;
}