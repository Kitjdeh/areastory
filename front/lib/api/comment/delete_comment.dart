import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> deleteComment({
  required int articleId,
  required int commentId,
}) async {
  final dio = Dio(BaseOptions(
    baseUrl: '${dotenv.get('BASE_URL')}/api/articles',
  ));

  final storage = new FlutterSecureStorage();
  final userId = await storage.read(key: 'userId');

  final response = await dio.delete(
    '/$articleId/comments/$commentId',
    queryParameters: {'userId': userId},
  );

  if (response.statusCode == 200) {
    print('성공');
  } else {
    print('실패');
    throw Exception('Failed to delete article');
  }
}
