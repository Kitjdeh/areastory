import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> deleteAlarm({
  required int notificationId,
}) async {
  final dio = Dio(BaseOptions(
    baseUrl: '${dotenv.get('BASE_URL')}/api/notifications',
  ));

  final storage = new FlutterSecureStorage();
  final userId = await storage.read(key: 'userId');

  final response = await dio.delete(
    '/${notificationId}',
    queryParameters: {'userId': userId},
  );

  if (response.statusCode == 200) {
    print('알람 삭제 성공');
  } else {
    print('알림 삭제 실패');
    throw Exception('Failed to delete article');
  }
}
