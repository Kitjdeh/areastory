import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front/api/follow/create_following.dart';
import 'package:front/api/follow/delete_following.dart';
import 'package:front/api/like/create_article_like.dart';
import 'package:front/api/like/delete_article_like.dart';
import 'package:front/api/sns/delete_article.dart';
import 'package:front/api/sns/get_article.dart';
import 'package:front/api/user/get_user.dart';
import 'package:front/component/sns/article_update_screen.dart';
import 'package:front/component/sns/avatar_widget.dart';
import 'package:front/component/sns/comment_screen.dart';
import 'package:front/component/sns/image_screen.dart';
import 'package:front/component/sns/like_screen.dart';
import 'package:front/constant/home_tabs.dart';
import 'package:front/screen/mypage_screen.dart';
import 'package:get/get.dart';

class ArticleComponent extends StatefulWidget {
  final int articleId;
  final int followingId;
  final double height;
  final int userId;
  final Function(int commentId) onDelete;
  const ArticleComponent({
    Key? key,
    required this.articleId,
    required this.followingId,
    required this.height,
    required this.userId,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<ArticleComponent> createState() => _ArticleComponentState();
}

class _ArticleComponentState extends State<ArticleComponent> {
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

  void delArticle(articleId) async {
    await deleteArticle(articleId: articleId);
    // setState(() {});
    widget.onDelete(articleId);
  }

  String _formatDate(dynamic createdAt) {
    DateTime dateTime;

    if (createdAt is String) {
      dateTime = DateTime.parse(createdAt);
    } else if (createdAt is DateTime) {
      dateTime = createdAt;
    } else {
      return '';
    }

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}초 전';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}시간 전';
    } else {
      return '${difference.inDays}일 전';
    }
  }

  Widget _optionList() {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SnsUpdateScreen(
                            articleId: widget.articleId,
                          ))).then((result) {
                if (result == true) {
                  setState(() {
                    print('업데이트 성공');
                  });
                }
              });
            },
            icon: Icon(
              Icons.update,
              color: Colors.black,
            ),
            label: Text(
              "수정하기",
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              showDeleteConfirmationDialog();
            },
            icon: Icon(
              Icons.delete,
              color: Colors.black,
            ),
            label: Text(
              "삭제하기",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  void showDeleteConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // 대화 상자 바깥을 터치하여 닫히지 않도록 설정
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('게시글 삭제'),
          content: Text('정말로 이 게시글을 삭제하시겠습니까?'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop(); // 대화 상자 닫기
              },
            ),
            CupertinoDialogAction(
              child: Text('확인'),
              onPressed: () {
                delArticle(widget.articleId);
                Navigator.of(context).pop(); // 대화 상자 닫기
              },
            ),
          ],
        );
      },
    );
  }

  Widget _header({
    required String profile,
    required String nickname,
    required bool followYn,
    String? dosi,
    String? sigungu,
    String? dongeupmyeon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MyPageScreen(userId: widget.followingId.toString())));
            },
            child: AvatarWidget(
              type: AvatarType.TYPE3,
              nickname: nickname,
              location: '${dosi} ${sigungu} ${dongeupmyeon}',
              size: 40,
              thumbPath: profile,
            ),
          ),
          Row(
            children: [
              if (widget.userId == widget.followingId)
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      // 모달 이외 클릭시 모달창 닫힘.
                      builder: (BuildContext context) {
                        return _optionList();
                      },
                    );
                  },
                  child: ImageData(
                    IconsPath.postMoreIcon,
                    width: 60,
                  ),
                ),
              if (widget.userId != widget.followingId)
                GestureDetector(
                  onTap: () {
                    followYn
                        ? delFollowing(widget.followingId)
                        : createFollowing(widget.followingId);
                  },
                  child: ImageData(
                    followYn ? IconsPath.following : IconsPath.follow,
                    width: 250,
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }

  Widget _image({
    required String image,
    required String thumbnail,
    required bool likeYn,
  }) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ImageScreen(
              image: image,
            ));
      },
      onDoubleTap: () {
        likeYn
            ? delArticleLike(widget.articleId)
            : createArticleLike(widget.articleId);
      },
      child: Image.network(
        thumbnail,
      ),
    );
    // return CachedNetworkImage(
    //   imageUrl: image,
    // );
  }

  Widget _infoCount({
    required bool likeYn,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  likeYn
                      ? delArticleLike(widget.articleId)
                      : createArticleLike(widget.articleId);
                },
                child: ImageData(
                  likeYn ? IconsPath.likeOnIcon : IconsPath.likeOffIcon,
                  width: 65,
                ),
              ),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SnsCommentScreen(
                                articleId: widget.articleId,
                                userId: widget.userId,
                                profile: profile,
                              )));
                },
                child: ImageData(
                  IconsPath.replyIcon,
                  width: 60,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoDescription({
    required int totalLikeCount,
    required String nickname,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SnsLikeScreen(
                          articleId: widget.articleId, userId: widget.userId)));
            },
            child: Text(
              '좋아요 ${totalLikeCount}개',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ExpandableText(
            content,
            prefixText: nickname,
            prefixStyle: const TextStyle(fontWeight: FontWeight.bold),
            expandText: '더보기',
            collapseText: '접기',
            maxLines: 2,
            expandOnTextTap: true,
            collapseOnTextTap: true,
          ),
        ],
      ),
    );
  }

  Widget _replyTextBtn({
    required int commentCount,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SnsCommentScreen(
                        articleId: widget.articleId,
                        userId: widget.userId,
                        profile: profile,
                      )));
        },
        child: Text(
          '댓글 ${commentCount}개 모두 보기',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ),
    );
  }

  Widget _dateAgo({
    required String createAt,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Text(
        _formatDate(createAt),
        style: const TextStyle(color: Colors.grey, fontSize: 11),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ArticleData>(
      future: getArticle(
        articleId: widget.articleId,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            margin: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _header(
                  profile: snapshot.data!.profile,
                  nickname: snapshot.data!.nickname,
                  followYn: snapshot.data!.followYn,
                  dosi: snapshot.data!.dosi,
                  sigungu: snapshot.data!.sigungu,
                  dongeupmyeon: snapshot.data!.dongeupmyeon,
                ),
                const SizedBox(height: 15),
                _image(
                  image: snapshot.data!.image,
                  thumbnail: snapshot.data!.thumbnail,
                  likeYn: snapshot.data!.likeYn,
                ),
                const SizedBox(height: 15),
                _infoCount(
                  likeYn: snapshot.data!.likeYn,
                ),
                const SizedBox(height: 5),
                _infoDescription(
                  totalLikeCount: snapshot.data!.totalLikeCount,
                  nickname: snapshot.data!.nickname,
                  content: snapshot.data!.content,
                ),
                const SizedBox(height: 5),
                _replyTextBtn(
                  commentCount: snapshot.data!.commentCount,
                ),
                const SizedBox(height: 5),
                _dateAgo(
                  createAt: snapshot.data!.createdAt,
                ),
              ],
            ),
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
      },
    );
  }
}
