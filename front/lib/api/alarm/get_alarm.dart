// Future<AllAlarmData> getAlarm(
//   int userId,
// ) async {
//   AllAlarmData responseJson;
//   final dio = Dio(BaseOptions(
//     baseUrl: '${dotenv.get('BASE_URL')}/api/notifications',
//   ));
//   final response = await dio.get('/$userId', queryParameters: {
//     'userId': userId,
//   });
//   if (response.statusCode == 200) {
//     final responseJson = AllAlarmData.fromJson(response.data);
//   }
//   else{
//
//   }
//   return responseJson;
// }
//
//
// class AllAlarmData {
//   final int? pageSize;
//   final int? totalPageNumber;
//   final int? totalCount;
//   final List<AlarmData>? notificatio;
//   AllAlarmData(
//       {this.pageSize, this.totalPageNumber, this.totalCount, this.notificatio});
//   factory AllAlarmData.fromJson(Map<String, dynamic> json) {
//     return AllAlarmData(
//         pageSize: json["pageSize"],
//         totalPageNumber: json["totalPageNumber"],
//         totalCount: json["totalCount"],
//         notificatio: json["notificatio"]);
//   }
// }
//
// class AlarmData {
//   final int? notificationId;
//   final bool? checked;
//   final String? title;
//   final String? body;
//   final DateTime? createdAt;
//   final int? articleId;
//   final int? commentId;
//   final int? userId;
//
//   AlarmData(
//       {this.notificationId,
//       this.checked,
//       this.title,
//       this.body,
//       this.createdAt,
//       this.articleId,
//       this.commentId,
//       this.userId});
//
//   factory AlarmData.fromJson(Map<String, dynamic> json) {
//     return AlarmData(
//       notificationId: json["notificationId"],
//       checked: json["checked"],
//       title: json["title"],
//       body: json["body"],
//       createdAt: json["createdAt"],
//       articleId: json["articleId"],
//       commentId: json["commentId"],
//       userId: json["userId"],
//     );
//   }
// }
