import 'package:flutter/material.dart';
import 'package:front/api/like/get_article_likes.dart';
import 'package:front/component/sns/like/like.dart';
import 'package:front/controllers/bottom_nav_controller.dart';
import 'package:get/get.dart';

class SnsLikeScreen extends StatefulWidget {
  const SnsLikeScreen({Key? key, required this.articleId, required this.userId})
      : super(key: key);
  final int articleId;
  final int userId;

  @override
  State<SnsLikeScreen> createState() => _SnsLikeScreenState();
}

class _SnsLikeScreenState extends State<SnsLikeScreen>
    with TickerProviderStateMixin {
  int _currentPage = 1;
  int? _lastPage = 0;

  List _likes = [];

  @override
  void initState() {
    super.initState();
    printLikes();
  }

  void printLikes() async {
    _currentPage = 1;
    _likes.clear();
    final likeData = await getArticleLikes(
      articleId: widget.articleId,
    );
    _likes.addAll(likeData.users);
    _lastPage = likeData.totalPageNumber;
    setState(() {});
  }

  void _loadMoreData() async {
    _currentPage++;
    final newLikes = await getArticleLikes(
      articleId: widget.articleId,
    );
    _likes.addAll(newLikes.users);
    _lastPage = newLikes.totalPageNumber;

    setState(() {
      // scrollToIndex(5);
    });
  }

  final ScrollController _scrollController = ScrollController();

  void scrollToIndex(int index) {
    _scrollController.jumpTo(index * 100); // jumpTo 메서드를 사용하여 스크롤합니다.
  }

  void _updateIsChildActive(bool isChildActive) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "좋아요",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,

          /// 앱바 그림자효과 제거
          leading: IconButton(
            /// 뒤로가기버튼설정
            icon: Icon(Icons.arrow_back_ios_new_outlined),
            color: Colors.black,
            onPressed: () {
              // Get.find<BottomNavController>().willPopAction();
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                child: RefreshIndicator(
                  onRefresh: () async {
                    printLikes();
                  },
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: _likes.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index < _likes.length) {
                        return LikeComponent(
                          myId: widget.userId,
                          followingId: _likes[index].userId,
                          height: 100,
                          onUpdateIsChildActive: _updateIsChildActive,
                        );
                      } else if (_currentPage < _lastPage!) {
                        _loadMoreData();
                        return Container(
                          height: 50,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        );
                      }
                    },
                    separatorBuilder: (context, index) {
                      return renderContainer(height: 3);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget renderContainer({
    double? height,
  }) {
    return Container(
      height: height,
    );
  }
}
