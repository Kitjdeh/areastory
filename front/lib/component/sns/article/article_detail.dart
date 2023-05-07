import 'package:flutter/material.dart';
import 'package:front/api/follow/create_following.dart';
import 'package:front/api/follow/delete_following.dart';
import 'package:front/api/like/create_article_like.dart';
import 'package:front/api/like/delete_article_like.dart';
import 'package:front/api/sns/get_article.dart';

class ArticleDetailComponent extends StatefulWidget {
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
  final double height;

  ArticleDetailComponent(
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
      Key? key,
      Object? snapshotData})
      : super(key: key);

  @override
  State<ArticleDetailComponent> createState() => _ArticleDetailComponentState();
}

class _ArticleDetailComponentState extends State<ArticleDetailComponent> {
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
            height: widget.height ?? 500,
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
                          widget.profile,
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
                            widget.nickname,
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
                        image: NetworkImage(widget.image),
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
                                      detailData != null
                                          ? detailData!.likeYn
                                              ? delArticleLike(widget.articleId)
                                              : createArticleLike(
                                                  widget.articleId)
                                          : widget.likeYn
                                              ? delArticleLike(widget.articleId)
                                              : createArticleLike(
                                                  widget.articleId);
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
                                ),
                                Expanded(
                                  child: Text(
                                    widget.totalLikeCount.toString(),
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
                                    widget.commentCount.toString(),
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
                                widget.content,
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
