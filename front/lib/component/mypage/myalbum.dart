import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front/api/mypage/get_userArticles.dart';
import 'package:front/component/mypage/articles/detail_articles.dart';
import 'package:front/component/sns/article/article_detail.dart';
import 'package:get/get.dart';

class MyAlbum extends StatefulWidget {
  MyAlbum({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<MyAlbum> createState() => _MyAlbumState();
}

class _MyAlbumState extends State<MyAlbum> {
  int _currentPage = 0;
  List<dynamic> _articles = [];
  bool nextPage = true; // 다음페이지를 불러올 수 있는가?
  bool _isLoading = false; // 로딩 중인지 여부
  final storage = new FlutterSecureStorage();
  String? myId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    printArticles(int.parse(widget.userId), _currentPage);
  }

  void setMyId() async {
    myId = await storage.read(key: "userId");
  }


  void printArticles(userId, page) async {
    _articles.clear();
    myId = await storage.read(key: "userId");

    final articleData = myId == widget.userId
        ? await getUserArticles(userId: userId, page: 0)
        : await getOtherArticles(userId: userId, page: 0);
    setState(() {
      _currentPage = 0;
      _articles.addAll(articleData.articles);
      print(_articles.length);
    });
  }

  void getuserarticle(userId) async {
    if (_isLoading) return; // 이미 로딩 중인 경우 중복 요청 방지
    ++_currentPage;
    final articleData =
        await getUserArticles(userId: userId, page: _currentPage);
    setState(() {
      _articles.addAll(articleData.articles);
      nextPage = articleData.nextPage;
      _isLoading = false; // 로딩 완료 상태로 설정
    });
  }

  void getortherarticle(userId) async {
    if (_isLoading) return; // 이미 로딩 중인 경우 중복 요청 방지
    ++_currentPage;
    final articleData =
        await getOtherArticles(userId: userId, page: _currentPage);
    setState(() {
      _articles.addAll(articleData.articles);
      nextPage = articleData.nextPage;
      _isLoading = false; // 로딩 완료 상태로 설정
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: renderMaxExtent(),
    );
  }

  Widget renderMaxExtent() {
    // if (_articles.length == 0) {
    //   return Container(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [Text("등록된 게시글이")],
    //         ),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [Text("없습니다")],
    //         ),
    //       ],
    //     ),
    //   );
    // }

    return RefreshIndicator(
      onRefresh: () {
        // 당겨서 새로고침 시 동작할 로직을 여기에 작성
        // 새로운 데이터를 가져오고 상태를 업데이트하는 등의 작업을 수행
        return Future<void>.delayed(Duration(seconds: 2), () {
          printArticles(int.parse(widget.userId), _currentPage);
        });
      },
      child: _articles.length == 0
          ? Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("등록된 게시글이")],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("없습니다")],
                  ),
                ],
              ),
            )
          : NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification notification) {
                if (notification is ScrollEndNotification) {
                  final double scrollPosition = notification.metrics.pixels;
                  final double maxScrollExtent =
                      notification.metrics.maxScrollExtent;
                  final double triggerThreshold = 400.0; // 일정 높이

                  if (scrollPosition > maxScrollExtent - triggerThreshold &&
                      nextPage &&
                      !_isLoading) {
                    getuserarticle(int.parse(widget.userId));
                  }
                }
                return false;
              },
              child: Stack(
                children: [
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      mainAxisSpacing: 1,
                    ),
                    itemBuilder: (context, index) {
                      if (index < _articles.length) {
                        return renderContainer(
                          image: _articles[index].image.toString(),
                          articleId: _articles[index].articleId,
                        );
                      }
                    },
                    itemCount: _articles.length + 1,
                  ),
                  if (_isLoading)
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
    );
  }

  // 가로세로를 강제로 설정하는 방법을 모르겠습니다..?
  Widget renderContainer({
    required String image,
    required int articleId,
    // double? height,
  }) {
    return GestureDetector(
      onTap: () {
        Get.to(() => AlbumDetail(
              articleId: articleId,
              userId: int.parse(myId!),
              followingId: int.parse(widget.userId),
            ));
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => AlbumDetail(articleId: articleId),
        //   ),
        // );
      },
      child: Container(
        // child: Text(articleId.toString()),
        child: Image.network(
          image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
