import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<AlarmData> getAlarm({
  required int notificationId,
  required int userId,
}) async {
  final dio = Dio(BaseOptions(
    baseUrl: '${dotenv.get('BASE_URL')}/api/notifications',
  ));

  final response = await dio.get('/$notificationId', queryParameters: {
    'userId': userId,
  });

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.toString());
    final alarmData = AlarmData.fromJson(jsonData);

    return alarmData;
  } else {
    print('알림 요청 실패');
    throw Exception('Failed to load articles');
  }
}

class AlarmData {
  final int? notificationId;
  final bool checked;
  final String title;
  final String? body;
  final String? createdAt;
  final int? articleId;
  final int? commentId;
  final int? userId;
  final String? type;
  final int? otherUserId;

  AlarmData({
    this.notificationId,
    required this.checked,
    required this.title,
    this.body,
    this.createdAt,
    this.articleId,
    this.commentId,
    this.userId,
    this.otherUserId,
    this.type,
  });

  factory AlarmData.fromJson(Map<String, dynamic> json) {
    return AlarmData(
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
