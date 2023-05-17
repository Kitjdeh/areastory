import 'package:flutter/material.dart';
import 'package:front/api/follow/get_followings_sort.dart';
import 'package:front/api/sns/get_follow_articles.dart';
import 'package:front/component/sns/avatar_widget.dart';
import 'package:front/component/sns/post_widget.dart';
import 'package:front/constant/home_tabs.dart';
import 'package:front/controllers/follow_screen_controller.dart';
import 'package:get/get.dart';
import 'package:front/screen/mypage_screen.dart';

class FollowScreen extends StatefulWidget {
  const FollowScreen({
    Key? key,
    required this.userId,
    this.signal,
  }) : super(key: key);
  final String userId;
  final String? signal;

  @override
  State<FollowScreen> createState() => _FollowScreenState();
}

Widget _storyBoardList({
  required List followings,
}) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        const SizedBox(
          width: 5,
        ),
        ...List.generate(
          followings.length,
          (index) => Builder(
            builder: (BuildContext builderContext) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    builderContext, // builderContext를 사용하여 Navigator.push() 호출
                    MaterialPageRoute(
                      builder: (context) => MyPageScreen(
                        userId: followings[index].userId.toString(),
                      ),
                    ),
                  );
                },
                child: AvatarWidget(
                  type: AvatarType.TYPE1,
                  thumbPath: followings[index].profile,
                  size: 70,
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

class _FollowScreenState extends State<FollowScreen> {
  final FollowController _followController = Get.find<FollowController>();
  bool _isToggleOn = false; // 토글 상태 변수
  Duration _animationDuration = Duration(milliseconds: 300);

  int _currentPage = 1;
  bool _hasNextPage = false;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  List _articles = [];
  List _followings = [];
  String signal = '';

  late final userId = int.parse(widget.userId);
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    // _controller = ScrollController();
    // printArticles();
    // _controller.addListener(_loadMoreData);
    _followController.init(int.parse(widget.userId));
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMoreData);
    super.dispose();
  }

  void printArticles() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    _currentPage = 1;
    _articles.clear();
    _followings.clear();
    final articleData = await getFollowArticles(
      page: _currentPage,
    );
    final followData = await getFollowingsSort();

    _articles.addAll(articleData.articles);
    _followings.addAll(followData);
    _hasNextPage = articleData.nextPage;
    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _loadMoreData() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 3000) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      _currentPage += 1;
      final newArticles = await getFollowArticles(
        page: _currentPage,
      );
      _articles.addAll(newArticles.articles);
      _hasNextPage = newArticles.nextPage;

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  void onDelete(int articleId) {
    // setState(() {});
    _followController.ondelete(articleId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: ImageData(
            IconsPath.logo,
            width: 270,
          ),
          title: Text(
            "Followings",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,

          /// 앱바 그림자효과 제거
        ),
        body: GetBuilder<FollowController>(
          builder: (controller) {
            return _followController.isFirstLoadRunning
                ? const Center(
                    child: const CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () {
                      return Future<void>.delayed(Duration(seconds: 2), () {
                        _followController.printArticles();
                      });
                    },
                    child: ListView(
                      controller: _followController.scrollController,
                      children: [
                        _storyBoardList(
                            followings: _followController.followings),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: List.generate(
                            _followController.articles.length,
                            (index) => ArticleComponent(
                              userId: _followController.userId,
                              onDelete: onDelete,
                              articleId:
                                  _followController.articles[index].articleId,
                              followingId:
                                  _followController.articles[index].userId,
                              height: 300,
                            ),
                          ),
                        ),
                        if (_followController.isLoadMoreRunning)
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 40),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        if (!_followController.isLoadMoreRunning &&
                            !_followController.hasNextPage)
                          Container(
                            padding: const EdgeInsets.only(top: 30, bottom: 40),
                            color: Colors.white,
                            child: const Center(
                              child: Text('더이상 게시글이 없습니다'),
                            ),
                          ),
                      ],
                    ),
                  );
          },
        ));
  }
}
