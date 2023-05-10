import 'package:flutter/material.dart';
import 'package:front/api/sns/get_follow_articles.dart';
import 'package:front/component/sns/article/article.dart';



class FollowScreen extends StatefulWidget {
  const FollowScreen({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<FollowScreen> createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen> {
  int _currentPage = 1;
  int? _lastPage = 0;
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(30.0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Image.asset(
            'asset/img/logo.png',
            height: 120,
            width: 120,
          ),
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
                    printArticles();
                  },
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: _articles.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index < _articles.length) {
                        return ArticleComponent(
                          userId: userId,
                          onDelete: onDelete,
                          articleId: _articles[index].articleId,
                          followingId: _articles[index].userId,
                          height: 350,
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
                      return renderContainer(height: 20);
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