import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future reportUser({
  required int targetUserId,
}) async {
  final dio = Dio(BaseOptions(
    baseUrl: '${dotenv.get('BASE_URL')}/api/users/report',
  ));

  final storage = new FlutterSecureStorage();
  final myId = await storage.read(key: 'userId');

  try{
    final data = {
      'reportUserId': myId,
      'targetUserId': targetUserId,
      'reportContent': '',
    };

    final response = await dio.post('',
    data: data
    //     queryParameters: {
    //   'reportUserId': myId,
    //   'targetUserId': targetUserId,
    // }
    );
    if (response.statusCode == 200) {
        final jsonData = json.decode(response.toString());
        final msg = jsonData["msg"];
        return msg;
      } else {
        print("신고 실패.");
        throw Exception('Failed to load articles');
      }
  }catch(e){
    print("신고 실패.");
    print(e);
    throw Exception('Failed to load articles');
  }
}