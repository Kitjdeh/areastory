import 'package:flutter/material.dart';
import 'package:front/api/follow/create_following.dart';
import 'package:front/api/follow/delete_following.dart';

import '../../../api/user/get_user.dart';

class LikeComponent extends StatefulWidget {
  final int followingId;
  final String nickname;
  final String profile;
  final bool followYn;
  final double height;
  final Function(bool isChildActive) onUpdateIsChildActive;

  const LikeComponent({
    Key? key,
    required this.followingId,
    required this.nickname,
    required this.profile,
    required this.followYn,
    required this.height,
    required this.onUpdateIsChildActive,
  }) : super(key: key);

  @override
  State<LikeComponent> createState() => _LikeComponentState();
}

class _LikeComponentState extends State<LikeComponent> {
  UserData? detailData;

  void createFollowing(followingId) async {
    await postFollowing(followingId: followingId);
    detailData = (await getUser(userId: widget.followingId)) as UserData?;
    setState(() {});
  }

  void delFollowing(followingId) async {
    await deleteFollowing(followingId: followingId);
    detailData = (await getUser(userId: widget.followingId)) as UserData?;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.profile),
                radius: 20,
              ),
              SizedBox(width: 16),
              Text(
                widget.nickname,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              // detailData != null
              //     ? detailData!.followYn
              //         ? delFollowing(widget.followingId)
              //         : createFollowing(widget.followingId)
              //     : widget.followYn
              //         ? delFollowing(widget.followingId)
              //         : createFollowing(widget.followingId);
              widget.followYn
                  ? delFollowing(widget.followingId)
                  : createFollowing(widget.followingId);
            },
            style: ElevatedButton.styleFrom(
              // primary: detailData != null
                  // ? detailData!.followYn
                  //     ? Colors.transparent
                  //     : Colors.blue
                  // : widget.followYn
                  //     ? Colors.transparent
                  //     : Colors.blue,
             primary: widget.followYn
                  ? Colors.transparent
                  : Colors.blue,
              side: BorderSide(color: Colors.white),
            ),
            child: Text(
              // detailData != null
                  // ? detailData!.followYn
                  //     ? '팔로잉'
                  //     : '팔로우'
                  // : widget.followYn
                  //     ? '팔로잉'
                  //     : '팔로우',
              widget.followYn
                  ? '팔로잉'
                  : '팔로우',
              style: TextStyle(
                color: Colors.white, // 텍스트 색상을 하얀색으로 설정
              ),
            ),
          ),
        ],
      ),
    );
  }
}
