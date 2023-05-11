import 'package:flutter/material.dart';
import 'package:front/screen/mypage_screen.dart';

class FollowingListScreen extends StatefulWidget {
  FollowingListScreen({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<FollowingListScreen> createState() => _FollowingListScreenState();
}

class _FollowingListScreenState extends State<FollowingListScreen> {
  // final List<int> numbers = List.generate(100, (index) => index);

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
          height: 30,
        );
      },
    );
  }

  Widget renderContainer({
    double? height,
  }) {
    return Container(
      height: MediaQuery.of(context).size.width*0.14,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// 프로필 사진
            /// 컨테이너는 넓이, 높이 설정안하면 -> 자동으로 최대크기
            /// sizedbox는 하나라도 설정안하면 -> 자동으로 child의 최대크기
            Expanded(
              flex: 7,
              child: GestureDetector(
                onTap: (){
                  print("감자입니다.");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MyPageScreen(userId: '1')));
                },
                child: Row(
                  children: [Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    width: MediaQuery.of(context).size.width*0.14,
                    height: MediaQuery.of(context).size.width*0.14,

                    /// ClipRRect: R이 2개다. 그리고 강제로 차일드의 모양을 강제로 잡아주는 용도.
                    child: ClipRRect(
                      /// 가장 완벽한 원을 만드는 방법은 상위가 되었든 뭐든, 높이길이의 50%(높이=넓이)
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.1),
                      child: Image.asset(
                        'asset/img/test01.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                      Expanded(
                        child: Container(
                          child: Text(
                            "유저 닉네임",
                            overflow: TextOverflow.ellipsis, // 글자가 너무 길 경우 생략되도록 설정
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                    ),
                      ),
                  ]
                ),
              ),
            ),



            /// 버튼은 분기처리해야함.(팔로잉 해제)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                    onPressed: (){

                    },
                    child: Text("팔로잉")),
              ),
          ],
        ),
      ),
    );
  }
}
