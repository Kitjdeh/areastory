import 'package:flutter/material.dart';

class CommentComponent extends StatelessWidget {
  final String writer;
  final String writerProfile;
  final String content;
  final int likeCount;
  final bool isLike;
  final String createdAt;
  final double height;
  final Function(bool isChildActive) onUpdateIsChildActive;

  const CommentComponent({
    Key? key,
    required this.writer,
    required this.writerProfile,
    required this.content,
    required this.likeCount,
    required this.isLike,
    required this.createdAt,
    required this.height,
    required this.onUpdateIsChildActive,
  }) : super(key: key);

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
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 10,
          ),
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(writerProfile),
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
                          writer,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          _formatDate(createdAt),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            onUpdateIsChildActive(false);
                          },
                          child: Image.asset(
                            isLike
                                ? 'asset/img/like.png'
                                : 'asset/img/nolike.png',
                            height: 30,
                          ),
                        ),
                        Text('$likeCount'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  content,
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
