import 'package:get/get.dart';
import 'package:front/api/sns/get_follow_articles.dart';

class FollowController extends GetxController {
  int _currentPage = 1;
  bool _hasNextPage = false;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  int _lastPage = 0;
  List articles = [];
  List _followings = [];


  void printArticles() async {
    print("오모나 세상에나");
    _currentPage = 1;
    articles.clear();
    final articleData = await getFollowArticles(page: _currentPage);
    articles.addAll(articleData.articles);
    _lastPage = articleData.totalPageNumber;
    update(); // 상태 변경을 리스너에게 알립니다
  }

  void loadMoreData() async {
    _currentPage++;
    final newArticles = await getFollowArticles(page: _currentPage);
    articles.addAll(newArticles.articles);
    _lastPage = newArticles.totalPageNumber;
    update(); // 상태 변경을 리스너에게 알립니다
  }

}