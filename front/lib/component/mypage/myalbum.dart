import 'package:flutter/material.dart';
import 'package:front/api/mypage/get_userArticles.dart';

class MyAlbum extends StatefulWidget {
  MyAlbum({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<MyAlbum> createState() => _MyAlbumState();
}

class _MyAlbumState extends State<MyAlbum> {
  List _articles = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // printArticles(int.parse(widget.userId));
  }

  // void printArticles(userId) async {
  //   _articles.clear();
  //   final articleData = await getUserArticles(userId: userId);
  //   setState(() {
  //     _articles = articleData;
  //   });
  //   print("최초의 앨범사진 요청했습니다.");
  // }

  // void getuserarticle(userId) async {
  //   final articleData = await getUserArticles(userId: userId);
  //   setState(() {
  //     _articles = articleData;
  //   });
  //   print("들어간 게시글");
  //   print("앨범사진 요청했습니다");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: renderMaxExtent(),
    );
  }

  Widget renderMaxExtent() {
    return FutureBuilder(
      future: getUserArticles(userId: int.parse(widget.userId)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 로딩 중인 경우 표시할 UI
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // 에러가 발생한 경우 표시할 UI
          return Text('Error: ${snapshot.error}');
        } else {
          // 데이터를 성공적으로 불러온 경우 표시할 UI
          List articleData = snapshot.data!;
          _articles = snapshot.data!;
          if (articleData.isEmpty) {
            return Container(
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
            );
          }
          return GridView.builder(
            // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              // 가로 크기 150으로 설정시 3개가 나온다.
              // maxCrossAxisExtent: 150,
              crossAxisCount: 3,
              childAspectRatio: 1,
              mainAxisSpacing: 1,
            ),
            // 아이템 빌더시 현재는 컬러랑 인덱스를 출력하는데 나중에는 이미지 리스트를 받아와야한다.
            itemBuilder: (context, index) {
              if (index < _articles.length) {
                print("index: $index, length: ${_articles.length}");
                return renderContainer(
                  image: _articles[index].image.toString(),
                  articleId: _articles[index].articleId,
                );
              }
            },
            // 내꺼 아이템의 총 개수.
            itemCount: _articles.length + 1,
          );
        }
      },
    );
  }

  // Widget renderMaxExtent() {
  //   if (_articles.length == 0) {
  //     return Container(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [Text("등록된 게시글이")]),
  //           Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [Text("없습니다")]),
  //         ],
  //       ),
  //     );
  //   }
  //   return GridView.builder(
  //     // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //       // 가로 크기 150으로 설정시 3개가 나온다.
  //       // maxCrossAxisExtent: 150,
  //       crossAxisCount: 3,
  //       childAspectRatio: 1,
  //       mainAxisSpacing: 1,
  //     ),
  //     // 아이템 빌더시 현재는 컬러랑 인덱스를 출력하는데 나중에는 이미지 리스트를 받아와야한다.
  //     itemBuilder: (context, index) {
  //       if (index < _articles.length) {
  //         print("index: $index, length: ${_articles.length}");
  //         return renderContainer(
  //           image: _articles[index].image.toString(),
  //           articleId: _articles[index].articleId,
  //         );
  //       }
  //     },
  //     // 내꺼 아이템의 총 개수.
  //     itemCount: _articles.length + 1,
  //   );
  // }

  // 가로세로를 강제로 설정하는 방법을 모르겠습니다..?
  Widget renderContainer({
    required String image,
    required int articleId,
    // double? height,
  }) {
    return GestureDetector(
      onTap: () {
        print(articleId);
      },
      child: Container(
        child: Image.network(
            image,
            fit: BoxFit.cover,
          ),
      ),
    );
  }
}
