import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:front/api/follow/create_following.dart';
import 'package:front/api/follow/delete_following.dart';
import 'package:front/api/like/create_article_like.dart';
import 'package:front/api/like/delete_article_like.dart';
import 'package:front/api/sns/get_article.dart';
import 'package:front/api/test_api.dart';

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
      Key? key,
      Object? snapshotData})
      : super(key: key);

  @override
  State<ArticleComponent> createState() => _ArticleComponentState();
}

class _ArticleComponentState extends State<ArticleComponent> {
  bool isExpanded = false;
  ArticleData? detailData;

  void createFollowing(followingId) async {
    await postFollowing(followingId: followingId);
    detailData =
        (await getArticle(articleId: widget.articleId)) as ArticleData?;
    setState(() {});
  }

  void delFollowing(followingId) async {
    await deleteFollowing(followingId: followingId);
    detailData =
        (await getArticle(articleId: widget.articleId)) as ArticleData?;
    setState(() {});
  }

  void createArticleLike(articleId) async {
    await postArticleLike(articleId: articleId);
    detailData = (await getArticle(articleId: articleId)) as ArticleData?;
    setState(() {});
  }

  void delArticleLike(articleId) async {
    await deleteArticleLike(articleId: articleId);
    detailData = (await getArticle(articleId: articleId)) as ArticleData?;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String displayText = widget.content;

    if (!isExpanded && widget.content.length > 10) {
      displayText = widget.content.substring(0, 10) + '...';
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
                      detailData != null
                          ? detailData!.followYn
                              ? delFollowing(widget.followingId)
                              : createFollowing(widget.followingId)
                          : widget.followYn
                              ? delFollowing(widget.followingId)
                              : createFollowing(widget.followingId);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: detailData != null
                          ? detailData!.followYn
                              ? Colors.transparent
                              : Colors.blue
                          : widget.followYn
                              ? Colors.transparent
                              : Colors.blue,
                      side: BorderSide(color: Colors.white),
                    ),
                    child: Text(
                      detailData != null
                          ? detailData!.followYn
                              ? '팔로잉'
                              : '팔로우'
                          : widget.followYn
                              ? '팔로잉'
                              : '팔로우',
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
                          detailData != null
                              ? detailData!.likeYn
                                  ? delArticleLike(widget.articleId)
                                  : createArticleLike(widget.articleId)
                              : widget.likeYn
                                  ? delArticleLike(widget.articleId)
                                  : createArticleLike(widget.articleId);
                        },
                        child: Image.asset(
                          detailData != null
                              ? detailData!.likeYn
                                  ? 'asset/img/like.png'
                                  : 'asset/img/nolike.png'
                              : widget.likeYn
                                  ? 'asset/img/like.png'
                                  : 'asset/img/nolike.png',
                          height: 30,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Beamer.of(context)
                              .beamToNamed('/sns/comment/${widget.articleId}');
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
                          '/sns/like/${widget.articleId}',
                        );
                      },
                      child: Text(
                        detailData != null
                            ? '좋아요 ' +
                                detailData!.totalLikeCount.toString() +
                                '개'
                            : '좋아요 ' + widget.totalLikeCount.toString() + '개',
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
                        Beamer.of(context)
                            .beamToNamed('/sns/comment/${widget.articleId}');
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
