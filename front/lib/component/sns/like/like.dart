import 'package:flutter/material.dart';
import 'package:front/api/follow/create_following.dart';
import 'package:front/api/follow/delete_following.dart';
import 'package:front/constant/home_tabs.dart';
import 'package:front/screen/mypage_screen.dart';

import '../../../api/user/get_user.dart';

class LikeComponent extends StatefulWidget {
  final int followingId;
  final double height;
  final Function(bool isChildActive) onUpdateIsChildActive;
  final int myId;

  const LikeComponent(
      {Key? key,
      required this.followingId,
      required this.height,
      required this.onUpdateIsChildActive,
      required this.myId})
      : super(key: key);

  @override
  State<LikeComponent> createState() => _LikeComponentState();
}

class _LikeComponentState extends State<LikeComponent> {
  void createFollowing(followingId) async {
    await postFollowing(followingId: followingId);
    setState(() {});
  }

  void delFollowing(followingId) async {
    await deleteFollowing(followingId: followingId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserData>(
        future: getUser(userId: widget.followingId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyPageScreen(
                                  userId: widget.followingId.toString())));
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(snapshot.data!.profile),
                          radius: 20,
                        ),
                        SizedBox(width: 16),
                        Text(
                          snapshot.data!.nickname,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  if (widget.myId != widget.followingId)
                    GestureDetector(
                      onTap: () {
                        snapshot.data!.followYn
                            ? delFollowing(widget.followingId)
                            : createFollowing(widget.followingId);
                      },
                      child: ImageData(
                        snapshot.data!.followYn
                            ? IconsPath.following
                            : IconsPath.follow,
                        width: 300,
                      ),
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
