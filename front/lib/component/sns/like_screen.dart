import 'package:flutter/material.dart';
import 'package:front/api/like/get_article_likes.dart';
import 'package:front/component/sns/like/like.dart';

class SnsLikeScreen extends StatefulWidget {
  const SnsLikeScreen({Key? key, required this.articleId, required this.userId})
      : super(key: key);
  final int articleId;
  final int userId;

  @override
  State<SnsLikeScreen> createState() => _SnsLikeScreenState();
}

class _SnsLikeScreenState extends State<SnsLikeScreen> {
  int _currentPage = 1;
  bool _hasNextPage = false;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  int? _lastPage = 0;

  List _likes = [];
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    printLikes();
    _controller.addListener(_loadMoreData);
  }

  void printLikes() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    _currentPage = 1;
    _likes.clear();
    final likeData = await getArticleLikes(
      articleId: widget.articleId,
      page: _currentPage,
    );
    _likes.addAll(likeData.users);
    _hasNextPage = likeData.nextPage;

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _loadMoreData() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 3000)
      setState(() {
        _isLoadMoreRunning = true;
      });
    _currentPage += 1;
    final newLikes = await getArticleLikes(
      articleId: widget.articleId,
      page: _currentPage,
    );
    _likes.addAll(newLikes.users);
    _hasNextPage = newLikes.nextPage;

    setState(() {
      print('성공');
      _isLoadMoreRunning = false;
    });
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
                  onRefresh: () {
                    return Future<void>.delayed(Duration(seconds: 2), () {
                      printLikes();
                    });
                  },
                  child: ListView(
                    controller: _controller,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(
                          _likes.length,
                          (index) => LikeComponent(
                            myId: widget.userId,
                            followingId: _likes[index].userId,
                            height: 100,
                            onUpdateIsChildActive: _updateIsChildActive,
                          ),
                        ),
                      ),
                      if (_isLoadMoreRunning)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      if (!_isLoadMoreRunning && !_hasNextPage)
                        Container(
                          padding: const EdgeInsets.only(bottom: 10),
                          color: Colors.white,
                          child: const Center(
                            child: Text('더이상 좋아요가 없습니다'),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
