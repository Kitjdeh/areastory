import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AreaData {
  final Map<String, String>? locationDto;
  final String? image;
  final int? articleId;
  AreaData({this.locationDto, this.image, this.articleId});
  factory AreaData.fromJson(Map<String, dynamic> json) {
    return AreaData(
        locationDto: Map<String, String>.from(json["locationDto"]),
        image: json["image"],
        articleId: json["articleId"]);
  }
}

Future<Map<String, AreaData>> postAreaData(
    List<Map<String, String>> data) async {
  print('post요청함수 시작');
  List<Map<String, dynamic>> responseJson = [];
  // print('data값${data.first}');
  List<AreaData> areadata = [];
  Map<String, AreaData> AreaInfo = {};
  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };
  String url = '${dotenv.get('BASE_URL')}/api/map';
  http.Response response = await http.post(Uri.parse(url),
      body: json.encode(data), headers: headers);
  final int statuscode = response.statusCode;
  print("statuscode${statuscode}");
  // print(response.body);
  await statuscode == 200
      ? responseJson = List<Map<String, dynamic>>.from(
          jsonDecode(utf8.decode(response.bodyBytes))) // 응답 데이터를 변환하여 저장
      // areadata = jsonDecode(utf8.decode(response.bodyBytes))
      : print("에러가 발생 에러코드${response.statusCode}");
  await Future.forEach(responseJson, (e) {
    areadata.add(AreaData.fromJson(e));
  });
  print(areadata.first.locationDto.runtimeType);
  // print(areadata.first.)
  await areadata != null
      ? areadata.map((e) => e.locationDto!.containsKey('dongeupmyeon')
          ? AreaInfo.addAll({e.locationDto!['dongupyeon'].toString() ?? "": e})
          : e.locationDto!.containsKey('sigungu')
              ?
              // AreaInfo.addAll({e.locationDto!['sigungu'].toString() ?? "": e})
              print(areadata.first.locationDto)
              : AreaInfo.addAll({e.locationDto!['dosi'].toString() ?? "": e}))
      : null;
  print("Areainfo${AreaInfo}");
  return AreaInfo;
}
