import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:front/component/mypage/mypage_tabbar.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {

  @override
  Widget build(BuildContext context) {
    return _buildMyPageScreen();
  }

  Widget _buildMyPageScreen() {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children:
          [
            // 1.닉네임, 설정버튼
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 50,
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("nickname"),
                  // 추후 아이콘 버튼 + Icon이미지 변경
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      // 설정버튼 클릭시 하단 모달up
                      showModalBottomSheet(
                          context: context,
                          // 모달 이외 클릭시 모달창 닫힘.
                          isDismissible: true,
                          builder: (BuildContext context) {
                            return Container(
                              height: 200,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TextButton.icon(
                                    // 아마 라우터로 페이지 이동시켜야될듯?
                                    onPressed: () {
                                      print("설정 및 개인정보");
                                    },
                                    icon: Icon(Icons.settings),
                                    label: Text("설정 및 개인정보"),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      print("로그아웃");
                                    },
                                    icon: Icon(Icons.logout),
                                    label: Text("로그아웃"),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      print("서비스 탈퇴");
                                    },
                                    icon: Icon(Icons.accessible_outlined),
                                    label: Text("서비스 탈퇴"),
                                  ),
                                ],
                              ),
                            );
                          }
                      );
                    },
                  )
                ],
              ),
            ),
            // 2. 유저 프로필사진 및 게시글 정보
            Container(
              color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // 프로필 사진
                  // 컨테이너는 넓이, 높이 설정안하면 -> 자동으로 최대크기
                  // sizedbox는 하나라도 설정안하면 -> 자동으로 child의 최대크기
                  Container(
                    color: Colors.green,
                    width: 100,
                    height: 100,
                    // ClipRRect: R이 2개다. 그리고 강제로 차일드의 모양을 강제로 잡아주는 용도.
                    child: ClipRRect(
                      // 가장 완벽한 원을 만드는 방법은 상위가 되었든 뭐든, 높이길이의 50%(높이=넓이)
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        'asset/img/test01.jpg', fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // 게시물(수)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("게시물"),
                      // 추후 데이터받아서 표시
                      Text("28")
                    ],
                  ),
                  // 팔로워(수)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("팔로워"),
                      Text("52")
                    ],
                  ),
                  // 팔로잉(수)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("팔로잉"),
                      Text("46")
                    ],
                  ),
                ],
              ),
            ),

            // 3. 프로필 편집, 체지방 28% 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    ),
                    onPressed: () {
                    },
                    child: Text("프로필 편집")),
                ElevatedButton(
                    onPressed: () {
                      Beamer.of(context).beamToNamed('/mypage/follow');
                    },
                    child: Text("팔로워/팔로잉")),
              ],
            ),
            // 4. 사진첩 및 지도 탭바
            MypageTabbar(),
          ],
        ),
      ),
    );
  }
}
