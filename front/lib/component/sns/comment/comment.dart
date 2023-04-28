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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(writerProfile),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    const SizedBox(width: 10),
                    Text(
                      createdAt,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
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
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        onUpdateIsChildActive(false);
                      },
                      child: Icon(
                        Icons.thumb_up_alt_outlined,
                        color: isLike ? Colors.blue : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text('$likeCount'),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        onUpdateIsChildActive(true);
                      },
                      child: Icon(
                        Icons.comment_outlined,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
