import 'package:flutter/material.dart';
import 'package:front/api/follow/get_followings_sort.dart';
import 'package:front/api/sns/get_follow_articles.dart';
import 'package:get/get.dart';

class FollowController extends GetxController {
  bool _isToggleOn = false; // 토글 상태 변수
  Duration _animationDuration = Duration(milliseconds: 300);

  int _currentPage = 1;
  bool hasNextPage = false;
  bool isFirstLoadRunning = false;
  bool isLoadMoreRunning = false;
  List articles = [];
  List followings = [];

  late int userId;
  late ScrollController scrollController = ScrollController();

  void init(userId){
    print("팔로우컨트롤러 진짜 돌아가요---------------------------");
    scrollController.addListener(loadMoreData);
    this.userId = userId;
    printArticles();
    update();
  }

  void dispose(){
    scrollController.removeListener(loadMoreData);
    update();
  }


  void printArticles() async {
    isFirstLoadRunning = true;
    update();
    _currentPage = 1;
    articles.clear();
    followings.clear();
    final articleData = await getFollowArticles(
      page: _currentPage,
    );
    final followData = await getFollowingsSort();

    articles.addAll(articleData.articles);
    followings.addAll(followData);
    hasNextPage = articleData.nextPage;
    isFirstLoadRunning = false;
    update();
    print("팔로우컨트롤러${articles.length}");
  }

  void loadMoreData() async {
    if (hasNextPage == true &&
        isFirstLoadRunning == false &&
        isLoadMoreRunning == false &&
        scrollController.position.extentAfter < 3000) {
      isLoadMoreRunning = true;
      update();
      _currentPage += 1;
      final newArticles = await getFollowArticles(
        page: _currentPage,
      );
      articles.addAll(newArticles.articles);
      hasNextPage = newArticles.nextPage;
      isLoadMoreRunning = false;
      update();
    }
  }

  void ondelete(int articleId) {
    update();
  }

}