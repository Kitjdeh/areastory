import 'package:flutter/material.dart';
import 'package:front/api/follow/create_following.dart';
import 'package:front/api/follow/delete_following.dart';
import 'package:front/api/like/create_article_like.dart';
import 'package:front/api/like/delete_article_like.dart';
import 'package:front/api/sns/get_article.dart';
import 'package:front/api/user/get_user.dart';
import 'package:front/component/sns/article/article_alert.dart';
import 'package:front/component/sns/comment_screen.dart';
import 'package:front/constant/home_tabs.dart';
import 'package:front/screen/mypage_screen.dart';
import 'package:front/screen/sns_screen.dart';

class ArticleDetailComponent extends StatefulWidget {
  final int articleId;
  final int userId;
  final double height;
  String? location;

  ArticleDetailComponent({
    required this.articleId,
    required this.userId,
    required this.height,
    this.location,
    Key? key,
  }) : super(key: key);

  @override
  State<ArticleDetailComponent> createState() => _ArticleDetailComponentState();
}

class _ArticleDetailComponentState extends State<ArticleDetailComponent> {
  late final profile;

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  void getProfile() async {
    final mine = await getUser(userId: widget.userId);
    profile = mine.profile;
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ArticleData>(
        future: getArticle(
          articleId: widget.articleId,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
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
                          color: Color(0xFFFFFFFF),
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyPageScreen(
                                                      userId: snapshot
                                                          .data!.userId
                                                          .toString())));
                                    },
                                    child: ClipOval(
                                      child: Image.network(
                                        snapshot.data!.profile,
                                        width: 45,
                                        height: 45,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data!.nickname,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        widget.location != null
                                            ? '${widget.location}'
                                            : '${snapshot.data!.dosi} ${snapshot.data!.sigungu} ${snapshot.data!.dongeupmyeon}',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  if (widget.userId != snapshot.data!.userId)
                                    GestureDetector(
                                      onTap: () {
                                        snapshot.data!.followYn
                                            ? delFollowing(
                                                snapshot.data!.userId)
                                            : createFollowing(
                                                snapshot.data!.userId);
                                      },
                                      child: ImageData(
                                        snapshot.data!.followYn
                                            ? IconsPath.following
                                            : IconsPath.follow,
                                        width: 250,
                                      ),
                                    ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(snapshot.data!.image),
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
                                  flex: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0x65FFFFFF),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 8,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            snapshot.data!
                                                                    .likeYn
                                                                ? delArticleLike(
                                                                    widget
                                                                        .articleId)
                                                                : createArticleLike(
                                                                    widget
                                                                        .articleId);
                                                          },
                                                          child: ImageData(
                                                            snapshot.data!
                                                                    .likeYn
                                                                ? IconsPath.like
                                                                : IconsPath
                                                                    .nolike,
                                                            width: 102,
                                                          ),
                                                        ),
                                                        Text(
                                                          snapshot.data!
                                                              .totalLikeCount
                                                              .toString(),
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            SnsCommentScreen(
                                                                              articleId: widget.articleId,
                                                                              userId: widget.userId,
                                                                              profile: profile,
                                                                            )));
                                                          },
                                                          child: ImageData(
                                                            IconsPath.comment,
                                                            width: 95,
                                                          ),
                                                        ),
                                                        Text(
                                                          snapshot.data!
                                                              .commentCount
                                                              .toString(),
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  snapshot.data!.content,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black,
                                                  ),
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => SnsScreen(
                                                            location: widget
                                                                        .location !=
                                                                    null
                                                                ? widget
                                                                    .location
                                                                : '${snapshot.data!.dosi} ${snapshot.data!.sigungu} ${snapshot.data!.dongeupmyeon}',
                                                            userId: widget
                                                                .userId
                                                                .toString()),
                                                      ),
                                                    );
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      widget.location != null
                                                          ? (widget.location!
                                                                  .contains(snapshot
                                                                          .data!
                                                                          .dongeupmyeon
                                                                      as Pattern)
                                                              ? Text(
                                                                  '${snapshot.data!.dongeupmyeon}')
                                                              : (widget
                                                                      .location!
                                                                      .contains(snapshot
                                                                              .data!
                                                                              .sigungu
                                                                          as Pattern)
                                                                  ? Text(
                                                                      '${snapshot.data!.sigungu}')
                                                                  : (widget.location!.contains(snapshot
                                                                              .data!
                                                                              .dosi
                                                                          as Pattern)
                                                                      ? Text(
                                                                          '${snapshot.data!.dosi}')
                                                                      : Text(
                                                                          'SNS 가기'))))
                                                          : Text('${snapshot.data!.dosi}\n${snapshot.data!.sigungu}\n${snapshot.data!.dongeupmyeon}\nSNS 가기')
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => SnsScreen(
                                                            location: widget
                                                                        .location !=
                                                                    null
                                                                ? widget
                                                                    .location
                                                                : '${snapshot.data!.dosi} ${snapshot.data!.sigungu} ${snapshot.data!.dongeupmyeon}',
                                                            userId: widget
                                                                .userId
                                                                .toString()),
                                                      ),
                                                    );
                                                  },
                                                  child: ImageData(
                                                    IconsPath.gosns,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
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
          } else if (snapshot.hasError) {
            return AlertModal(
              message: '삭제된 게시글입니다',
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
