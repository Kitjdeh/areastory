import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChatComponent extends StatelessWidget {
  final String profile;
  final String nickname;
  final String content;
  // final DateTime createdAt;
  final int userId;
  final double height;
  final String myId;

  const ChatComponent({
    Key? key,
    required this.profile,
    required this.nickname,
    required this.content,
    // required this.createdAt,
    required this.userId,
    required this.height,
    required this.myId,
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 20,
      ),
      child: SizedBox(
        height: height,
        child: Row(
          // mainAxisAlignment:
          // userId != int.parse(myId) ? MainAxisAlignment.start : MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 10,
            ),
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(profile),
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
                            nickname,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          // Text(
                          //   _formatDate(createdAt),
                          //   style: TextStyle(
                          //     color: Colors.grey,
                          //     fontSize: 12,
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: Text(
                      content,
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
      ),
    );
  }
}
