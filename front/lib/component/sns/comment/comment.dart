import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front/api/comment/delete_comment.dart';
import 'package:front/api/comment/get_comment.dart';
import 'package:front/api/comment/update_comment.dart';
import 'package:front/api/like/create_comment_like.dart';
import 'package:front/api/like/delete_comment_like.dart';
import 'package:front/constant/home_tabs.dart';
import 'package:front/screen/mypage_screen.dart';

class CommentComponent extends StatefulWidget {
  final int commentId;
  final int articleId;
  final int userId;
  final double height;
  final Function(bool isChildActive) onUpdateIsChildActive;
  final int myId;
  final Function(bool editing) onDelete;

  const CommentComponent({
    Key? key,
    required this.commentId,
    required this.articleId,
    required this.userId,
    required this.height,
    required this.onUpdateIsChildActive,
    required this.myId,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<CommentComponent> createState() => _CommentComponentState();
}

class _CommentComponentState extends State<CommentComponent> {
  bool isEditing = false;
  TextEditingController _editCommentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    firstComment();
  }

  void firstComment() {
    getComment(articleId: widget.articleId, commentId: widget.commentId)
        .then((commentData) {
      _editCommentController.text = commentData.content;
    });
  }

  void createCommentLike(articleId, commentId) async {
    await postCommentLike(articleId: articleId, commentId: commentId);

    setState(() {});
  }

  void delCommentLike(articleId, commentId) async {
    await deleteCommentLike(articleId: articleId, commentId: commentId);

    setState(() {});
  }

  void delComment(articleId, commentId) async {
    await deleteComment(articleId: articleId, commentId: commentId);
    // widget.onDelete(commentId);
    setState(() {});
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

  void startEditing(content) {
    _editCommentController.text = content;
    setState(() {
      isEditing = true;
    });
    widget.onDelete(isEditing);
  }

  void cancelEditing() {
    setState(() {
      isEditing = false;
    });
    widget.onDelete(isEditing);
  }

  void saveEditing() async {
    final editedValue = _editCommentController.text;
    await patchComment(
      articleId: widget.articleId,
      commentId: widget.commentId,
      content: editedValue,
    );

    setState(() {
      isEditing = false;
    });
    widget.onDelete(isEditing);
  }

  void showDeleteConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // 대화 상자 바깥을 터치하여 닫히지 않도록 설정
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('댓글 삭제'),
          content: Text('정말로 이 댓글을 삭제하시겠습니까?'),
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
                delComment(widget.articleId, widget.commentId);
                Navigator.of(context).pop(); // 대화 상자 닫기
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isEditing) {
          cancelEditing();
        }
      },
      child: FutureBuilder<CommentData>(
          future: getComment(
              articleId: widget.articleId, commentId: widget.commentId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _editCommentController.selection = TextSelection.fromPosition(
                TextPosition(offset: _editCommentController.text.length),
              );
              return SizedBox(
                height: widget.height,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyPageScreen(
                                    userId: widget.userId.toString())));
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(snapshot.data!.profile),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyPageScreen(
                                                      userId: widget.userId
                                                          .toString())));
                                    },
                                    child: Text(
                                      snapshot.data!.nickname,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    _formatDate(snapshot.data!.createdAt),
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  if (widget.myId == widget.userId)
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            isEditing
                                                ? saveEditing()
                                                : startEditing(
                                                    snapshot.data!.content);
                                          },
                                          child: isEditing
                                              ? Text(
                                                  '수정',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              : ImageData(
                                                  IconsPath.update,
                                                  width: 60,
                                                ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            isEditing
                                                ? cancelEditing()
                                                : showDeleteConfirmationDialog();
                                          },
                                          child: isEditing
                                              ? Text(
                                                  '취소',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              : ImageData(
                                                  IconsPath.delete,
                                                  width: 60,
                                                ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        snapshot.data!.likeYn
                                            ? delCommentLike(widget.articleId,
                                                widget.commentId)
                                            : createCommentLike(
                                                widget.articleId,
                                                widget.commentId);
                                      },
                                      child: Image.asset(
                                        snapshot.data!.likeYn
                                            ? 'asset/img/like.png'
                                            : 'asset/img/nolike.png',
                                        height: 30,
                                      ),
                                    ),
                                    Text('${snapshot.data!.likeCount}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          if (isEditing)
                            Expanded(
                              child: TextFormField(
                                controller: _editCommentController,
                              ),
                            )
                          else
                            Expanded(
                              child: Text(
                                snapshot.data!.content,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          const SizedBox(height: 5),
                        ],
                      ),
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
          }),
    );
  }
}
