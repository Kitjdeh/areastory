import 'package:flutter/material.dart';
import 'package:front/api/mypage/get_userArticles.dart';

class MyAlbum extends StatefulWidget {
  MyAlbum({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<MyAlbum> createState() => _MyAlbumState();
}

class _MyAlbumState extends State<MyAlbum> {
  int _currentPage = 0;
  List _articles = [];
  bool _nextPage = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuserarticle(int.parse(widget.userId), _currentPage);
  }

  void getuserarticle(userId, page) async {
      final articleData = await getUserArticles(userId: userId, page: page);
      setState(() {
        _articles.addAll(articleData.articles);
        _nextPage = articleData.nextPage;
        _currentPage += 1;
      });
      print(_articles);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: renderMaxExtent(),
    );
  }

  Widget renderMaxExtent() {
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
          if(_articles.length == 0){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("아직 등록된 게시글이 없습니다.")
              ],
            );
          }
        else if (index < _articles.length) {
          return renderContainer(
            image: _articles[index].image.toString(),
            articleId: _articles[index].articleId,
          );
        } else if( _nextPage && index + 20 > _articles.length){
          getuserarticle(int.parse(widget.userId), _currentPage);
        }
      },
      // 내꺼 아이템의 총 개수.
      itemCount: _articles.length + 1,
    );
  }

  // 가로세로를 강제로 설정하는 방법을 모르겠습니다..?
  Widget renderContainer({
    required String image,
    required int articleId,
    // double? height,
  }) {
    return GestureDetector(
      onTap: (){
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