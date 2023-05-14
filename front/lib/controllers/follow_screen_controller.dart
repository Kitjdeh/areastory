import 'package:get/get.dart';
import 'package:front/api/sns/get_follow_articles.dart';

class FollowController extends GetxController {
  int currentPage = 1;
  int lastPage = 0;
  List articles = [];

  void printArticles() async {
    currentPage = 1;
    articles.clear();
    final articleData = await getFollowArticles(page: currentPage);
    articles.addAll(articleData.articles);
    lastPage = articleData.totalPageNumber;
    update(); // 상태 변경을 리스너에게 알립니다
  }

  // void loadMoreData() async {
  //   currentPage++;
  //   final newArticles = await getFollowArticles(page: currentPage);
  //   articles.addAll(newArticles.articles);
  //   lastPage = newArticles.totalPageNumber;
  //   update(); // 상태 변경을 리스너에게 알립니다
  // }
  //
  // void onDelete(int articleId) {
  //   // 삭제 로직을 수행합니다
  //   update(); // 상태 변경을 리스너에게 알립니다
  // }
}