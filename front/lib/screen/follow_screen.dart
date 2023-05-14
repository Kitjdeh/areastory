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
  const FollowScreen({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<FollowScreen> createState() => _FollowScreenState();
}

Widget _myStory() {
  return Stack(
    children: [
      AvatarWidget(
        type: AvatarType.TYPE2,
        thumbPath:
            'https://areastory-user.s3.ap-northeast-2.amazonaws.com/profile/8373fb5d-78e7-4613-afc9-5269c247f36a.1683607649926',
        size: 70,
      ),
    ],
  );
}

Widget _postList({
  required int userId,
  required void Function(int articleId) onDelete,
  required int height,
  required List articles,
  required int currentPage,
  required int lastPage,
  required void Function() loadMoreData,
}) {
  return Column(
    children: List.generate(
      articles.length + 1,
      (index) {
        if (index < articles.length) {
          return ArticleComponent(
            userId: userId,
            onDelete: onDelete,
            articleId: articles[index].articleId,
            followingId: articles[index].userId,
            height: 350,
          );
        } else if (currentPage < lastPage!) {
          loadMoreData();
          return Container(
            height: 50,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        }
        return SizedBox
            .shrink(); // Return an empty widget if the condition is not met
      },
    ),
  );
}

Widget _storyBoardList({
  required List followings,
}) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        _myStory(),
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
  final FollowController _followController = Get.put(FollowController());

  int _currentPage = 1;
  bool _hasNextPage = false;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  int _lastPage = 0;
  List _articles = [];
  List _followings = [];

  late final userId = int.parse(widget.userId);
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    printArticles();
    // _followController.printArticles();
    _controller.addListener(_loadMoreData);
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
    _articles.addAll(articleData.articles);
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: ImageData(
          IconsPath.logo,
          width: 270,
        ),
      ),
      // body: GetBuilder<FollowController>(
      //   builder: (controller) {
      //     return ListView(
      //       children: [
      //         _storyBoardList(followings: _followings),
      //         _postList(
      //           userId: userId,
      //           onDelete: onDelete,
      //           height: 350,
      //           articles: _followController.articles,
      //           loadMoreData: _loadMoreData,
      //           currentPage: _currentPage,
      //           lastPage: _lastPage,
      //         ),
      //       ],
      //     );
      //   })
      body: ListView(
        children: [
          _storyBoardList(followings: _followings),
          _postList(
            userId: userId,
            onDelete: onDelete,
            height: 350,
            articles: _articles,
            loadMoreData: _loadMoreData,
            currentPage: _currentPage,
            lastPage: _lastPage,
          ),
        ],
      ),
    );
  }
}
