import 'package:flutter/material.dart';
import 'package:front/api/comment/delete_comment.dart';
import 'package:front/api/comment/get_comment.dart';
import 'package:front/api/comment/update_comment.dart';
import 'package:front/api/like/create_comment_like.dart';
import 'package:front/api/like/delete_comment_like.dart';

class CommentComponent extends StatefulWidget {
  final int commentId;
  final int articleId;
  final int userId;
  final String nickname;
  final String profile;
  final String content;
  final int likeCount;
  final bool likeYn;
  final DateTime createdAt;
  final double height;
  final Function(bool isChildActive) onUpdateIsChildActive;
  final int myId;
  final Function(int commentId) onDelete;

  const CommentComponent({
    Key? key,
    required this.commentId,
    required this.articleId,
    required this.userId,
    required this.nickname,
    required this.profile,
    required this.content,
    required this.likeCount,
    required this.likeYn,
    required this.createdAt,
    required this.height,
    required this.onUpdateIsChildActive,
    required this.myId,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<CommentComponent> createState() => _CommentComponentState();
}

class _CommentComponentState extends State<CommentComponent> {
  CommentData? detailData;
  bool isEditing = false;
  late TextEditingController _editCommentController;

  @override
  void initState() {
    super.initState();
    _editCommentController = TextEditingController(text: widget.content);
  }

  void createCommentLike(articleId, commentId) async {
    await postCommentLike(articleId: articleId, commentId: commentId);
    // detailData = (await getComment(articleId: articleId, commentId: commentId))
    //     as CommentData?;
    // setState(() {});
  }

  void delCommentLike(articleId, commentId) async {
    await deleteCommentLike(articleId: articleId, commentId: commentId);
    // detailData = (await getComment(articleId: articleId, commentId: commentId))
    //     as CommentData?;
    // setState(() {});
  }

  void delComment(articleId, commentId) async {
    await deleteComment(articleId: articleId, commentId: commentId);
    detailData = null;
    widget.onDelete(commentId);
  }

  String _formatDate(dynamic createdAt) {
    DateTime dateTime;

    if (createdAt is String) {
      dateTime = DateTime.parse(createdAt);
    } else if (createdAt is DateTime) {
      dateTime = createdAt;
    } else {
      // Handle invalid createdAt format
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

  void startEditing() {
    setState(() {
      isEditing = true;
    });
  }

  void cancelEditing() {
    setState(() {
      isEditing = false;
      _editCommentController.text = widget.content;
    });
  }

  void saveEditing() async {
    final editedValue = _editCommentController.text;
    await patchComment(
      articleId: widget.articleId,
      commentId: widget.commentId,
      content: editedValue,
    );

    detailData = (await getComment(
        articleId: widget.articleId,
        commentId: widget.commentId)) as CommentData?;
    setState(() {
      isEditing = false;
    });
    detailData = null;
  }

  Widget buildContent() {
    if (isEditing) {
      return Expanded(
        child: TextFormField(
          controller: _editCommentController,
        ),
      );
    } else {
      return Expanded(
        child: Text(
          detailData != null ? detailData!.content : widget.content,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isEditing) {
          cancelEditing();
        }
      },
      child: SizedBox(
        height: widget.height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 10,
            ),
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(widget.profile),
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
                          Text(
                            widget.nickname,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            _formatDate(widget.createdAt),
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          if (widget.myId == widget.userId)
                            Row(
                              children: [
                                IconButton(
                                  icon: isEditing
                                      ? Icon(Icons.abc)
                                      : Icon(Icons.update),
                                  onPressed: () {
                                    isEditing ? saveEditing() : startEditing();
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    delComment(
                                        widget.articleId, widget.commentId);
                                  },
                                ),
                              ],
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          // GestureDetector(
                          //   onTap: () {
                          //     detailData != null
                          //         ? detailData!.likeYn
                          //             ? delCommentLike(
                          //                 widget.articleId, widget.commentId)
                          //             : createCommentLike(
                          //                 widget.articleId, widget.commentId)
                          //         : widget.likeYn
                          //             ? delCommentLike(
                          //                 widget.articleId, widget.commentId)
                          //             : createCommentLike(
                          //                 widget.articleId, widget.commentId);
                          //   },
                          //   child: Image.asset(
                          //     detailData != null
                          //         ? detailData!.likeYn
                          //             ? 'asset/img/like.png'
                          //             : 'asset/img/nolike.png'
                          //         : widget.likeYn
                          //             ? 'asset/img/like.png'
                          //             : 'asset/img/nolike.png',
                          //     height: 30,
                          //   ),
                          // ),

                          FutureBuilder<CommentData>(
                              future: getComment(
                                  articleId: widget.articleId,
                                  commentId: widget.commentId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasData) {
                                  return GestureDetector(
                                    onTap: () {
                                      snapshot.data!.likeYn
                                          ? delCommentLike(widget.articleId,
                                              widget.commentId)
                                          : createCommentLike(widget.articleId,
                                              widget.commentId);
                                    },
                                    child: Image.asset(
                                      snapshot.data!.likeYn
                                          ? 'asset/img/like.png'
                                          : 'asset/img/nolike.png',
                                      height: 30,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return Text('No data');
                                }
                              }),

                          Text(detailData != null
                              ? '${detailData!.likeCount}'
                              : '${widget.likeCount}'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  buildContent(),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
