import 'package:flutter/material.dart';
import 'package:front/api/sns/get_follow_articles.dart';
import 'package:front/component/sns/avatar_widget.dart';
import 'package:front/component/sns/post_widget.dart';
import 'package:front/constant/home_tabs.dart';
import 'package:front/controllers/follow_screen_controller.dart';
import 'package:get/get.dart';

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

Widget _storyBoardList() {
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
          100,
          (index) => AvatarWidget(
            type: AvatarType.TYPE1,
            thumbPath: 'https://img.ridicdn.net/cover/1250058267/large',
            size: 70,
          ),
        ),
      ],
    ),
  );
}

class _FollowScreenState extends State<FollowScreen> {
  final FollowController _followController = Get.put(FollowController());

  int _currentPage = 1;
  int _lastPage = 0;
  List _articles = [];

  late final userId = int.parse(widget.userId);

  @override
  void initState() {
    super.initState();
    printArticles();
  }

  void printArticles() async {
    _currentPage = 1;
    _articles.clear();
    final articleData = await getFollowArticles(
      page: _currentPage,
    );
    _articles.addAll(articleData.articles);
    _lastPage = articleData.totalPageNumber;
    setState(() {});
  }

  void _loadMoreData() async {
    _currentPage++;
    final newArticles = await getFollowArticles(
      page: _currentPage,
    );
    _articles.addAll(newArticles.articles);
    _lastPage = newArticles.totalPageNumber;

    setState(() {
      // scrollToIndex(5);
    });
  }

  final ScrollController _scrollController = ScrollController();

  void scrollToIndex(int index) {
    _scrollController.jumpTo(index * 520); // jumpTo 메서드를 사용하여 스크롤합니다.
  }

  void onDelete(int articleId) {
    setState(() {});
  }

  void _updateIsChildActive(followingId) async {}

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
      body: GetBuilder<FollowController>(
        builder: (controller) {
          return ListView(
            children: [
              _storyBoardList(),
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
          );
        }
      ),
    );
  }
}
