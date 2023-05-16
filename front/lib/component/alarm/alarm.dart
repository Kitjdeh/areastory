import 'package:flutter/material.dart';
import 'package:front/api/alarm/delete_alarm.dart';
import 'package:front/api/alarm/get_alarm.dart';
import 'package:front/api/alarm/patch_alarm.dart';
import 'package:front/component/sns/article/article_detail.dart';
import 'package:front/component/sns/avatar_widget.dart';
import 'package:front/constant/home_tabs.dart';
import 'package:front/screen/mypage_screen.dart';

import '../../api/user/get_user.dart';

class AlarmComponent extends StatefulWidget {
  final int userId;
  final int notificationId;
  final double height;
  final Function(bool isChildActive) onUpdateIsChildActive;
  final Function(int commentId) onDelete;

  const AlarmComponent({
    Key? key,
    required this.notificationId,
    required this.userId,
    required this.onDelete,
    required this.onUpdateIsChildActive,
    required this.height,
  }) : super(key: key);

  @override
  State<AlarmComponent> createState() => _AlarmComponentState();
}

class _AlarmComponentState extends State<AlarmComponent> {
  @override
  void initState() {
    super.initState();
  }

  void cheAlarm(notificationId) async {
    await checkAlarm(notificationId: notificationId);

    setState(() {});
  }

  void delAlarm(notificationId) async {
    await deleteAlarm(notificationId: notificationId);
    setState(() {});
    // widget.onDelete(commentId);
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

  Widget _profile({
    required String type,
    required String title,
    required String userId,
    required int articleId,
    required bool checked,
  }) {
    return FutureBuilder<UserData>(
      future: getUser(userId: widget.userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 로딩중일 때 표시할 위젯
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // 에러가 발생했을 때 표시할 위젯
          return Text('에러 발생: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          // 데이터가 없을 때 표시할 위젯
          return Text('데이터가 없습니다.');
        } else {
          return Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyPageScreen(userId: userId)));
                },
                child: AvatarWidget(
                  type: AvatarType.TYPE1,
                  thumbPath: snapshot.data!.profile,
                  size: 30,
                ),
              ),
              GestureDetector(
                  onTap: () {
                    if (!checked) {
                      cheAlarm(widget.notificationId);
                    }
                    if (type == 'comment' ||
                        type == 'article-like' ||
                        type == 'comment-like') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ArticleDetailComponent(
                                  articleId: articleId,
                                  userId: widget.userId,
                                  height: 500)));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyPageScreen(userId: userId)));
                    }
                  },
                  child: Text('${snapshot.data!.nickname}님이 $title')),
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AlarmData>(
        future: getAlarm(
            userId: widget.userId, notificationId: widget.notificationId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              color: snapshot.data!.checked ? Colors.white : Colors.grey,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _profile(
                    type: snapshot.data!.type,
                    title: snapshot.data!.title,
                    userId: snapshot.data!.userId.toString(),
                    articleId: snapshot.data!.articleId,
                    checked: snapshot.data!.checked,
                  ),
                  Row(
                    children: [
                      Text(
                        _formatDate(snapshot.data!.createdAt),
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          delAlarm(snapshot.data!.notificationId);
                        },
                        child: ImageData(
                          IconsPath.delete,
                          width: 60,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Container();
          }
        });
  }
}
