import 'package:flutter/material.dart';
import 'package:front/api/comment/get_comment.dart';
import 'package:front/api/like/create_comment_like.dart';
import 'package:front/api/like/delete_comment_like.dart';

class CommentComponent extends StatefulWidget {
  final String commentId;
  final String articleId;
  final String userId;
  final String nickname;
  final String profile;
  final String content;
  final int likeCount;
  final bool likeYn;
  final String createdAt;
  final double height;
  final Function(bool isChildActive) onUpdateIsChildActive;

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
  }) : super(key: key);

  @override
  State<CommentComponent> createState() => _CommentComponentState();
}

class _CommentComponentState extends State<CommentComponent> {
  CommentData? detailData;

  void createCommentLike(articleId, commentId) async {
    await postCommentLike(articleId: articleId, commentId: commentId);
    detailData = (await getComment(articleId: articleId, commentId: commentId))
        as CommentData?;
    setState(() {});
  }

  void delCommentLike(articleId, commentId) async {
    await deleteCommentLike(articleId: articleId, commentId: commentId);
    detailData = (await getComment(articleId: articleId, commentId: commentId))
        as CommentData?;
    setState(() {});
  }

  String _formatDate(String createdAt) {
    final now = DateTime.now();
    final dateTime = DateTime.parse(createdAt);
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            detailData != null
                                ? detailData!.likeYn
                                    ? delCommentLike(
                                        widget.articleId, widget.commentId)
                                    : createCommentLike(
                                        widget.articleId, widget.commentId)
                                : widget.likeYn
                                    ? delCommentLike(
                                        widget.articleId, widget.commentId)
                                    : createCommentLike(
                                        widget.articleId, widget.commentId);
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
                        Text('${widget.likeCount}'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  widget.content,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
