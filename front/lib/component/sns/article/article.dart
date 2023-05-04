import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:front/api/follow/create_following.dart';
import 'package:front/api/follow/delete_following.dart';
import 'package:front/api/like/create_article_like.dart';
import 'package:front/api/like/delete_article_like.dart';
import 'package:front/api/test_api.dart';

class ArticleComponent extends StatefulWidget {
  final int articleId;
  final int followingId;
  final String nickname;
  final String image;
  final String profile;
  final String content;
  final int likeCount;
  final int commentCount;
  final bool isLike;
  final Function(bool) onUpdateIsChildActive;
  final double height;

  ArticleComponent(
      {required this.articleId,
      required this.followingId,
      required this.nickname,
      required this.height,
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
  State<ArticleComponent> createState() => _ArticleComponentState();
}

class _ArticleComponentState extends State<ArticleComponent> {
  bool isExpanded = false;

  void createFollowing(followingId) async {
    await postFollowing(followingId: followingId);
    await widget.onUpdateIsChildActive(true);
    // 백수정 후 테스트해봐야함
    setState(() {});
  }

  void delFollowing(followingId) async {
    await deleteFollowing(followingId: followingId);
    await widget.onUpdateIsChildActive(true);
    // 백수정 후 테스트해봐야함
    setState(() {});
  }

  void createArticleLike(articleId) async {
    await postArticleLike(articleId: articleId);
    await widget.onUpdateIsChildActive(true);
    setState(() {});
  }

  void delArticleLike(articleId) async {
    await deleteArticleLike(articleId: articleId);
    await widget.onUpdateIsChildActive(true);
    // 백수정 후 테스트해봐야함
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String displayText = widget.content;

    if (!isExpanded && widget.content.length > 10) {
      displayText = widget.content.substring(0, 10) + '...';
    }

    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: Image.network(
                          widget.profile,
                          width: 35,
                          height: 35,
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
                            widget.nickname,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '서울특별시 강남구 언주로',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // widget.followYn ? delFollowing(widget.followingId) : createFollowing(widget.followingId);
                    },
                    style: ElevatedButton.styleFrom(
                      // primary: widget.followYn ? Colors.transparent : Colors.blue,
                      primary: Colors.blue,
                      side: BorderSide(color: Colors.white),
                    ),
                    child: Text(
                      // widget.followYn ? '팔로잉' : '팔로우',
                      '팔로우',
                      style: TextStyle(
                        color: Colors.white, // 텍스트 색상을 하얀색으로 설정
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          height: widget.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(widget.image),
            ),
          ),
        ),
        Container(
          child: Column(
            children: [
              SizedBox(
                height: 6,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          widget.isLike
                              ? delArticleLike(widget.articleId)
                              : createArticleLike(widget.articleId);
                        },
                        child: Image.asset(
                          widget.isLike
                              ? 'asset/img/like.png'
                              : 'asset/img/nolike.png',
                          height: 30,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Beamer.of(context).beamToNamed('/sns/comment');
                        },
                        child: Image.asset(
                          'asset/img/comment.png',
                          height: 30,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Beamer.of(context).beamToNamed('/sns/chat');
                        },
                        child: Image.asset(
                          'asset/img/comment.png',
                          height: 30,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Beamer.of(context).beamToNamed('/sns/like');
                      },
                      child: Text(
                        '좋아요 ' + widget.likeCount.toString() + '개',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.content.length <= 10)
                      Text(
                        displayText,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (!isExpanded && widget.content.length > 10)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpanded = true;
                          });
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: displayText,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              TextSpan(
                                text: ' 더보기',
                                style: TextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (isExpanded)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpanded = false;
                          });
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: displayText,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              TextSpan(
                                text: ' 접기',
                                style: TextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Beamer.of(context).beamToNamed('/sns/comment');
                      },
                      child: Text(
                        '댓글 ${widget.commentCount}개 모두 보기',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black38,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
