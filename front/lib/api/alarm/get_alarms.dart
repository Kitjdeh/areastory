import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<AllAlarmData> getAlarms({
  required int userId,
  required int page,
}) async {
  final dio = Dio(BaseOptions(
    baseUrl: '${dotenv.get('BASE_URL')}/api/notifications',
  ));
  final response = await dio.get('', queryParameters: {
    'userId': userId,
    'page': page,
  });
  if (response.statusCode == 200) {
    final jsonData = json.decode(response.toString());
    final alarmData = AllAlarmData.fromJson(jsonData);
    print('all알람 요청 성공');
    return alarmData;
  } else {
    print('all알람 요청 실패');
    throw Exception('Failed to load articles');
  }
}

class AllAlarmData {
  final int pageSize;
  final int totalPageNumber;
  final int totalCount;
  final int pageNumber;
  final bool nextPage;
  final bool previousPage;
  final List<Notification> notifications;

  AllAlarmData({
    required this.pageSize,
    required this.totalPageNumber,
    required this.totalCount,
    required this.nextPage,
    required this.notifications,
    required this.pageNumber,
    required this.previousPage,
  });
  factory AllAlarmData.fromJson(Map<String, dynamic> json) {
    final notificationsList = json['notifications'] as List<dynamic>;
    final notifications = notificationsList
        .map((notificationJson) => Notification.fromJson(notificationJson))
        .toList();

    return AllAlarmData(
      pageSize: json["pageSize"],
      totalPageNumber: json["totalPageNumber"],
      totalCount: json["totalCount"],
      nextPage: json["nextPage"],
      pageNumber: json["pageNumber"],
      previousPage: json["previousPage"],
      notifications: notifications,
    );
  }
}

class Notification {
  final int? notificationId;
  final bool? checked;
  final String? title;
  final String? body;
  final String? createdAt;
  final int? articleId;
  final int? commentId;
  final int? userId;
  final String? type;
  final int? otherUserId;

  Notification({
    this.notificationId,
    this.checked,
    this.title,
    this.body,
    this.createdAt,
    this.articleId,
    this.commentId,
    this.userId,
    this.otherUserId,
    this.type,
    // required this.type,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      notificationId: json["notificationId"],
      checked: json["checked"],
      title: json["title"],
      body: json["body"],
      createdAt: json['createdAt'],
      articleId: json["articleId"],
      commentId: json["commentId"],
      userId: json["userId"],
      otherUserId: json["otherUserId"],
      type: json["type"],
    );
  }
}
