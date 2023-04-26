import 'package:flutter/material.dart';

class ArticleComponent extends StatelessWidget {
  final String nickname;
  final String image;
  final String profile;
  final String content;
  final int likeCount;
  final int commentCount;
  final bool isLike;
  final Function(bool) onUpdateIsChildActive;
  double? height;

  ArticleComponent(
      {required this.nickname,
      this.height,
      required this.image,
      required this.profile,
      required this.content,
      required this.likeCount,
      required this.commentCount,
      required this.isLike,
      required this.onUpdateIsChildActive,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.8),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(3, 3), // changes position of shadow
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: height ?? 500,
            child: Column(
              children: [
                Container(
                  color: Color(0xFF0A2647),
                  height: 60,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      ClipOval(
                        child: Image.network(
                          profile,
                          width: 45,
                          height: 45,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nickname,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '서울특별시 강남구 언주로',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(image),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 6,
                          child: SizedBox(),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      onUpdateIsChildActive(true);
                                    },
                                    child: Image.asset(
                                      isLike
                                          ? 'asset/img/like.png'
                                          : 'asset/img/nolike.png',
                                      height: 30,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    likeCount.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Image.asset(
                                    'asset/img/comment.png',
                                    height: 30,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    commentCount.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0x65FFFFFF),
                            ),
                            child: Center(
                              child: Text(
                                content,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
