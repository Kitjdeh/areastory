import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:front/api/follow/create_following.dart';
import 'package:front/api/follow/delete_following.dart';
import 'package:front/api/like/create_article_like.dart';
import 'package:front/api/like/delete_article_like.dart';
import 'package:front/api/sns/delete_article.dart';
import 'package:front/api/sns/get_article.dart';

class ArticleComponent extends StatefulWidget {
  final int articleId;
  final int followingId;
  final String nickname;
  final String image;
  final String profile;
  final String content;
  final int dailyLikeCount;
  final int totalLikeCount;
  final int commentCount;
  final bool likeYn;
  final bool followYn;
  final DateTime createdAt;
  final String? dosi;
  final String? sigungu;
  final String? dongeupmyeon;
  final Function(int followingId) onUpdateIsChildActive;
  final double height;
  final userId;
  final Function(int commentId) onDelete;

  ArticleComponent(
      {required this.articleId,
      required this.followingId,
      required this.nickname,
      required this.height,
      required this.image,
      required this.profile,
      required this.content,
      required this.dailyLikeCount,
      required this.totalLikeCount,
      required this.commentCount,
      required this.likeYn,
      required this.followYn,
      required this.createdAt,
      this.dosi,
      this.sigungu,
      this.dongeupmyeon,
      required this.onUpdateIsChildActive,
      required this.userId,
      required this.onDelete,
      Key? key,
      Object? snapshotData})
      : super(key: key);

  @override
  State<ArticleComponent> createState() => _ArticleComponentState();
}

class _ArticleComponentState extends State<ArticleComponent> {
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  void createFollowing(followingId) async {
    await postFollowing(followingId: followingId);
    setState(() {});
  }

  void delFollowing(followingId) async {
    await deleteFollowing(followingId: followingId);
    setState(() {});
  }

  void createArticleLike(articleId) async {
    await postArticleLike(articleId: articleId);
    setState(() {});
  }

  void delArticleLike(articleId) async {
    await deleteArticleLike(articleId: articleId);
    setState(() {});
  }

  void delArticle(articleId) async {
    await deleteArticle(articleId: articleId);

    widget.onDelete(articleId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ArticleData>(
        future: getArticle(
          articleId: widget.articleId,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String displayText = snapshot.data!.content;

            if (!isExpanded && snapshot.data!.content.length > 10) {
              displayText = snapshot.data!.content.substring(0, 10) + '...';
            }

            bool isLikeCheck = true;

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
                                  snapshot.data!.profile,
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
                                    snapshot.data!.nickname,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '${snapshot.data!.dosi} ${snapshot.data!.sigungu} ${snapshot.data!.dongeupmyeon}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              if (widget.userId == widget.followingId)
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.update),
                                      onPressed: () {
                                        Beamer.of(context).beamToNamed(
                                            '/sns/update/${widget.articleId}');
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        delArticle(widget.articleId);
                                      },
                                    ),
                                  ],
                                ),
                              if (widget.userId != widget.followingId)
                                ElevatedButton(
                                  onPressed: () {
                                    snapshot.data!.followYn
                                        ? delFollowing(widget.followingId)
                                        : createFollowing(widget.followingId);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: snapshot.data!.followYn
                                        ? Colors.transparent
                                        : Colors.blue,
                                    side: BorderSide(color: Colors.white),
                                  ),
                                  child: Text(
                                    snapshot.data!.followYn ? '팔로잉' : '팔로우',
                                    style: TextStyle(
                                      color: Colors.white, // 텍스트 색상을 하얀색으로 설정
                                    ),
                                  ),
                                ),
                            ],
                          )
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
                      image: NetworkImage(snapshot.data!.image),
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
                                  snapshot.data!.likeYn
                                      ? delArticleLike(widget.articleId)
                                      : createArticleLike(widget.articleId);
                                },
                                child: Image.asset(
                                  snapshot.data!.likeYn
                                      ? 'asset/img/like.png'
                                      : 'asset/img/nolike.png',
                                  height: 30,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Beamer.of(context).beamToNamed(
                                      '/sns/comment/${widget.articleId}/${widget.userId}');
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
                                Beamer.of(context).beamToNamed(
                                    '/sns/like/${widget.articleId}/${widget.userId}');
                              },
                              child: Text(
                                '좋아요 ' +
                                    snapshot.data!.totalLikeCount.toString() +
                                    '개',
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
                            if (snapshot.data!.content.length <= 10)
                              Text(
                                displayText,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                                maxLines: 10,
                                overflow: TextOverflow.ellipsis,
                              ),
                            if (!isExpanded &&
                                snapshot.data!.content.length > 10)
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
                                Beamer.of(context).beamToNamed(
                                    '/sns/comment/${widget.articleId}/${widget.userId}');
                              },
                              child: Text(
                                '댓글 ${snapshot.data!.commentCount}개 모두 보기',
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
          } else if (snapshot.hasError) {
            return Container(
              height: 0,
            );
          } else {
            return Container(
              height: 0,
            );
          }
        });
  }
}
