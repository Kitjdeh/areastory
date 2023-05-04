import 'package:flutter/material.dart';

class FollowerListScreen extends StatelessWidget {
  final List<int> numbers = List.generate(100, (index) => index);

  FollowerListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: renderSeparated(),
    );
  }

  Widget renderSeparated() {
    return ListView.separated(
      itemCount: 100,
      itemBuilder: (context, index) {
        return renderContainer();
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 10,
        );
      },
    );
  }

  Widget renderContainer({
    double? height,
  }) {
    return Container(
      height: height ?? 70,
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
                child: Image.asset(
                  'asset/img/test01.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 20),
                child: Text(
                  "유저 닉네임",
                  overflow: TextOverflow.ellipsis, // 글자가 너무 길 경우 생략되도록 설정
                ),
              ),
            ),

            /// 버튼은 분기처리해야함.(팔로워 해제)
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                  onPressed: () {

                  },
                  icon: Icon(Icons.restore_from_trash)
              ),
            )
            /// 팔로워 신청
            // IconButton(onPressed: (){}, icon: Icon(Icons.restore_from_trash))
          ],
        ),
      ),
    );
  }
}
