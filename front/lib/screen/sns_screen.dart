import 'package:flutter/material.dart';
import 'package:front/api/sns/get_articles.dart';
import 'package:front/component/sns/article/article.dart';
import 'package:front/component/sns/article/article_detail.dart';
import 'package:front/const/article_test.dart';
import 'package:front/const/auto_search_test.dart';

const List<String> list = <String>['인기순', '최신순'];

class SnsScreen extends StatefulWidget {
  const SnsScreen({Key? key}) : super(key: key);

  @override
  State<SnsScreen> createState() => _SnsScreenState();
}

class _SnsScreenState extends State<SnsScreen> {
  int _currentPage = 1;
  int? _lastPage = 0;
  List _articles = [];
  String dropdownValue = list.first;

  @override
  void initState() {
    super.initState();
    printArticles();
  }

  void printArticles() async {
    final articleData = await getArticles(
      sort: 'likeCount',
      dosi: null,
      sigungu: null,
      dongeupmyeon: null,
    );
    _articles.addAll(articleData.articles);
    _lastPage = articleData.totalPageNumber;
    setState(() {});
  }

  void _loadMoreData() async {
    // 나중에 페이지 추가해서 넣어야할듯??
    // sort는 articleId or likeCount
    final newArticles = await getArticles(
      sort: 'likeCount',
      dosi: null,
      sigungu: null,
      dongeupmyeon: null,
    );
    _articles.addAll(newArticles.articles);
    _currentPage++;

    setState(() {
      // scrollToIndex(5);
    });
  }

  final ScrollController _scrollController = ScrollController();

  void scrollToIndex(int index) {
    _scrollController.jumpTo(index * 520); // jumpTo 메서드를 사용하여 스크롤합니다.
  }

  void _updateIsChildActive(bool isChildActive) async {
    setState(() {});
  }

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
          actions: [
            Container(
              margin: EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              width: 190,
              child: LocationSearch(),
            ),
            DropdownButton<String>(
              value: dropdownValue,
              style: const TextStyle(color: Colors.black),
              underline: null,
              autofocus: true,
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownValue = value!;
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ElevatedButton(
            //   child: Text('Show Article Detail'),
            //   onPressed: () {
            //     showModalBottomSheet(
            //       context: context,
            //       backgroundColor: Colors.transparent,
            //       isScrollControlled: true,
            //       builder: (BuildContext context) {
            //         return SizedBox(
            //           height: MediaQuery.of(context).size.height * 0.8,
            //           child: Center(
            //             child: ArticleDetailComponent(
            //               nickname: '치킨먹고싶다',
            //               image:
            //                   'https://image.dongascience.com/Photo/2020/03/5bddba7b6574b95d37b6079c199d7101.jpg',
            //               profile:
            //                   'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKFOtP8DmiYHZ-HkHpmLq9Oydg8JB4CuyOVg&usqp=CAU',
            //               content: '왜이리 화나있너 ;;; ㅎㅎㅎㅎㅎㅎㅎㅎ',
            //               likeCount: 33,
            //               commentCount: 14,
            //               isLike: true,
            //             ),
            //           ),
            //         );
            //       },
            //     );
            //   },
            // ),
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
                          articleId: _articles[index].articleId,
                          followingId: _articles[index].userId,
                          nickname: _articles[index].nickname,
                          image: _articles[index].image,
                          profile: _articles[index].profile,
                          content: _articles[index].content,
                          dailyLikeCount: _articles[index].dailyLikeCount,
                          totalLikeCount: _articles[index].totalLikeCount,
                          commentCount: _articles[index].commentCount,
                          likeYn: _articles[index].likeYn,
                          followYn: _articles[index].followYn,
                          createdAt: _articles[index].createdAt,
                          dosi: _articles[index].dosi,
                          sigungu: _articles[index].sigungu,
                          dongeupmyeon: _articles[index].dongeupmyeon,
                          height: 500,
                          onUpdateIsChildActive: _updateIsChildActive,
                        );
                      } else if (_currentPage < _lastPage!) {
                        _loadMoreData();
                        // return Container(
                        //   height: 50,
                        //   alignment: Alignment.center,
                        //   child: const CircularProgressIndicator(),
                        // );
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
