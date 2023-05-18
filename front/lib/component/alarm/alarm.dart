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
    // widget.onDelete(notificationId);
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
    required int otherUserId,
    int? articleId,
    required bool checked,
  }) {
    return FutureBuilder<UserData>(
        future: getUser(userId: otherUserId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MyPageScreen(userId: otherUserId.toString())));
                  },
                  child: AvatarWidget(
                    type: AvatarType.TYPE1,
                    thumbPath: snapshot.data!.profile,
                    size: 30,
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (!checked) {
                        cheAlarm(widget.notificationId);
                      }
                      if (type == 'comment' ||
                          type == 'article-like' ||
                          type == 'comment-like') {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: GestureDetector(
                                onTap: () {},
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  child: Center(
                                    child: ArticleDetailComponent(
                                      articleId: articleId!,
                                      userId: widget.userId,
                                      height: 500,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyPageScreen(
                                    userId: otherUserId.toString())));
                      }
                    },
                    child: Text(
                      title,
                    ),
                  ),
                ),
              ],
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
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AlarmData>(
        future: getAlarm(
            userId: widget.userId, notificationId: widget.notificationId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              color: snapshot.data!.checked ? Colors.grey : Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 8,
                    child: _profile(
                      type: snapshot.data!.type!,
                      title: snapshot.data!.title,
                      otherUserId: snapshot.data!.otherUserId!,
                      articleId: snapshot.data!.articleId,
                      checked: snapshot.data!.checked,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          _formatDate(snapshot.data!.createdAt),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          width: 5,
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
        });
  }
}
