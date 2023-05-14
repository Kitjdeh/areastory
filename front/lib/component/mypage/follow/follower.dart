import 'package:flutter/material.dart';
import 'package:front/api/mypage/get_follower.dart';

class FollowerListScreen extends StatefulWidget {

  FollowerListScreen({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<FollowerListScreen> createState() => _FollowerListScreenState();
}

class _FollowerListScreenState extends State<FollowerListScreen> {
  List _followers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: renderSeparated(),
    );
  }

  Widget renderSeparated() {
    return FutureBuilder(
      future: getUserFollowers(userId: int.parse(widget.userId)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 로딩 중인 경우 표시할 UI
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // 에러가 발생한 경우 표시할 UI
          return Text('Error: ${snapshot.error}');
        } else {
          // 데이터를 성공적으로 불러온 경우 표시할 UI
          List followersData = snapshot.data!;
          _followers = snapshot.data!;
          if (followersData.isEmpty) {
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("팔로워한 사람이")],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("없습니다")],
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            itemCount: _followers.length + 1,
            itemBuilder: (context, index) {
              return renderContainer(
                image: _followers[index].profile.toString(),
                otherId: _followers[index].userId,
                nickname: _followers[index].nickname.toString(),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 10,
              );
            },
          );
        }
      },
    );
  }

  Widget renderContainer({
    // double? height,
    required String image,
    required int otherId,
    required String nickname,
  }) {
    return Container(
      // height: height ?? 70,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// 프로필 사진
            /// 컨테이너는 넓이, 높이 설정안하면 -> 자동으로 최대크기
            /// sizedbox는 하나라도 설정안하면 -> 자동으로 child의 최대크기
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: 70,
              height: 70,

              /// ClipRRect: R이 2개다. 그리고 강제로 차일드의 모양을 강제로 잡아주는 용도.
              child: ClipRRect(
                /// 가장 완벽한 원을 만드는 방법은 상위가 되었든 뭐든, 높이길이의 50%(높이=넓이)
                borderRadius: BorderRadius.circular(35),
                // child: Image.asset(
                //   'asset/img/test01.jpg',
                //   fit: BoxFit.cover,
                // ),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 20),
                child: Text(
                  nickname,
                  overflow: TextOverflow.ellipsis, // 글자가 너무 길 경우 생략되도록 설정
                ),
              ),
            ),

            /// 버튼은 분기처리해야함.(팔로워 해제)
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                  onPressed: () {
                    print("otherId: $otherId");
                  },
                  icon: Icon(Icons.restore_from_trash)
              ),
            )
            /// 팔로워 신청
          ],
        ),
      ),
    );
  }
}
