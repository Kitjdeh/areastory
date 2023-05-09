import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:front/api/like/get_article_likes.dart';
import 'package:front/component/sns/like/like.dart';


class SnsLikeScreen extends StatefulWidget {
  const SnsLikeScreen({Key? key, required this.index, required this.userId})
      : super(key: key);
  final String index;
  final String userId;

  @override
  State<SnsLikeScreen> createState() => _SnsLikeScreenState();
}

class _SnsLikeScreenState extends State<SnsLikeScreen>
    with TickerProviderStateMixin {
  int _currentPage = 1;
  int? _lastPage = 0;

  List _likes = [];

  late final articleId = int.parse(widget.index);
  late final userId = int.parse(widget.userId);

  @override
  void initState() {
    super.initState();
    printLikes();
  }

  void printLikes() async {
    _currentPage = 1;
    _likes.clear();
    final likeData = await getArticleLikes(
      articleId: articleId,
    );
    _likes.addAll(likeData.users);
    _lastPage = likeData.totalPageNumber;
    setState(() {});
  }

  void _loadMoreData() async {
    _currentPage++;
    final newLikes = await getArticleLikes(
      articleId: articleId,
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
            Beamer.of(context).beamBack();
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
                    printLikes();
                  },
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: _likes.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index < _likes.length) {
                        return LikeComponent(
                          myId: userId,
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
