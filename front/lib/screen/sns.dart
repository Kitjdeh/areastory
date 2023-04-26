import 'package:flutter/material.dart';
import 'package:front/component/article.dart';
import 'package:front/const/article_test.dart';
import 'package:front/const/colors.dart';

class SnsScreen extends StatefulWidget {
  const SnsScreen({Key? key}) : super(key: key);

  @override
  State<SnsScreen> createState() => _SnsScreenState();
}

class _SnsScreenState extends State<SnsScreen> {
  int _currentPage = 1;
  List _articles = [];

  // void _loadMoreData() async {
  void _loadMoreData() async {
    // final newArticles = await api.fetchArticles(page: _currentPage + 1);
    // _articles.addAll(newArticles["articles"]);
    if (_currentPage == 1) {
      _articles.addAll(articleTest["articles"]);
    } else {
      _articles.addAll(articleTest2["articles"]);
    }
    await _currentPage++;
    setState(() {});
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
      backgroundColor: Color(0xFFECF9FF),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'asset/img/logo.png',
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: PopupMenuButton(
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          child: Text('Option 1'),
                          value: 1,
                        ),
                        PopupMenuItem(
                          child: Text('Option 2'),
                          value: 2,
                        ),
                        PopupMenuItem(
                          child: Text('Option 3'),
                          value: 3,
                        ),
                      ];
                    },
                    onSelected: (value) {
                      // Do something when an option is selected
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                child: RefreshIndicator(
                  onRefresh: () async {
                    // 서버 요청
                    await Future.delayed(Duration(seconds: 3));
                  },
                  child: ListView.separated(
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
