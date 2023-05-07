import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:front/api/like/get_article_likes.dart';
import 'package:front/component/sns/comment/comment.dart';
import 'package:front/component/sns/like/like.dart';
import 'package:front/const/comment_test.dart';
import 'package:front/const/like_test.dart';
import 'package:front/constant/follow_tabs.dart';

class SnsLikeScreen extends StatefulWidget {
  const SnsLikeScreen({Key? key, required this.index}) : super(key: key);
  final String index;

  @override
  State<SnsLikeScreen> createState() => _SnsLikeScreenState();
}

class _SnsLikeScreenState extends State<SnsLikeScreen>
    with TickerProviderStateMixin {
  int _currentPage = 1;
  int? _lastPage = 0;

  List _likes = [];

  late final articleId = int.parse(widget.index);

  @override
  void initState() {
    super.initState();

    printLikes();
  }

  void printLikes() async {
    final likeData = await getArticleLikes(
      articleId: articleId,
    );
    _likes.addAll(likeData.users);
    _lastPage = likeData.totalPageNumber;
    setState(() {});
  }

  void _loadMoreData() async {
    final newLikes = await getArticleLikes(
      articleId: articleId,
    );
    _likes.addAll(newLikes.users);
    _currentPage++;

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
    return Scaffold(
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
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await Future.delayed(Duration(seconds: 3));
                  },
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: _likes.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index < _likes.length) {
                        return LikeComponent(
                          followingId: _likes[index].userId,
                          nickname: _likes[index].nickname,
                          profile: _likes[index].profile,
                          followYn: _likes[index].followYn,
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
