import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> deleteArticle({
  required int articleId,
}) async {
  final dio = Dio(BaseOptions(
    baseUrl: '${dotenv.get('BASE_URL')}/api/articles',
  ));

  final storage = new FlutterSecureStorage();
  final userId = await storage.read(key: 'userId');

  final response = await dio.delete(
    '/$articleId',
    queryParameters: {'userId': userId},
  );

  if (response.statusCode == 200) {
    print('게시글 삭제 성공');
  } else {
    print('게시글 삭제 실패');
    throw Exception('Failed to delete article');
  }
}
