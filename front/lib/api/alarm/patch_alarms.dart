import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> checkAlarms() async {
  final dio = Dio(BaseOptions(
    baseUrl: '${dotenv.get('BASE_URL')}/api/notifications',
  ));

  final storage = new FlutterSecureStorage();
  final userId = await storage.read(key: 'userId');

  final response = await dio.patch(
    '',
    queryParameters: {'userId': userId},
  );

  if (response.statusCode == 200) {
    print('All 알람 체크 성공');
  } else {
    print('All 알람 체크 실패');
    throw Exception('Failed to delete article');
  }
}
