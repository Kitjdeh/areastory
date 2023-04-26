// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// Future<List<Schedule>> getArticles(params) async {
//   final response = await http.get(Uri.parse(
//       'http://j8a302.p.ssafy.io:8080/api/v1/schedule-info/2?localDate=${params}'));
//
//   if (response.statusCode == 200) {
//     List dataList = jsonDecode(utf8.decode(response.bodyBytes));
//
//     var Schedules = dataList.map((e) => Schedule.fromJson(e)).toList();
//     return Schedules;
//   } else {
//     throw Exception('Failed to load album');
//   }
// }
//
// class Schedule {
//   final int? scheduleId;
//   final int? homeId;
//   final int? scheduleTime;
//   final String? content;
//   final String? startDate;
//   final String? endDate;
//
//   Schedule(
//       {this.scheduleId,
//       this.homeId,
//       this.scheduleTime,
//       this.content,
//       this.endDate,
//       this.startDate});
//
//   factory Schedule.fromJson(Map<String, dynamic> json) {
//     return Schedule(
//         scheduleId: json["scheduleId"],
//         homeId: json["homeId"],
//         scheduleTime: json["scheduleTime"],
//         content: json["content"],
//         startDate: json["startDate"],
//         endDate: json["endDate"]);
//   }
// }
