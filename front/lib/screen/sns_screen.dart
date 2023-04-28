import 'package:flutter/material.dart';
import 'package:front/component/sns/article/article.dart';
import 'package:front/const/article_test.dart';

class SnsScreen extends StatefulWidget {
  const SnsScreen({Key? key}) : super(key: key);

  @override
  State<SnsScreen> createState() => _SnsScreenState();
}

class _SnsScreenState extends State<SnsScreen> {
  int _currentPage = 1;
  List _articles = [];
  final ScrollController _scrollController = ScrollController();

  // void _loadMoreData() async {
  void _loadMoreData() async {
    // final newArticles = await api.fetchArticles(page: _currentPage + 1);
    // _articles.addAll(newArticles["articles"]);
    if (_currentPage == 1) {
      _articles.addAll(articleTest["articles"]);
    } else if (_currentPage == 2) {
      _articles.addAll(articleTest2["articles"]);
    } else if (_currentPage == 3) {
      _articles.addAll(articleTest3["articles"]);
    }
    await _currentPage++;
    setState(() {
      // scrollToIndex(5);
    });
  }

  void scrollToIndex(int index) {
    _scrollController.jumpTo(index * 520); // jumpTo 메서드를 사용하여 스크롤합니다.
  }

  void _updateIsChildActive(bool isChildActive) {
    setState(() {
      print('성공!!!');
      print(_currentPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset(
          'asset/img/logo.png',
          height: 120,
          width: 120,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
              size: 25,
            ),
            onPressed: () {
              // Perform search action
            },
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
              size: 25,
            ),
            onPressed: () {
              // Show more options
            },
          ),
        ],
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
                    itemCount: _articles.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index < _articles.length) {
                        return ArticleComponent(
                          nickname: _articles[index]["nickname"],
                          image: _articles[index]["image"],
                          profile: _articles[index]["profile"],
                          content: _articles[index]["content"],
                          likeCount: _articles[index]["likeCount"],
                          commentCount: _articles[index]["commentCount"],
                          isLike: _articles[index]["isLike"],
                          height: 500,
                          onUpdateIsChildActive: _updateIsChildActive,
                        );
                      } else {
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
