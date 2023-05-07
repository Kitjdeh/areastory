import 'package:beamer/beamer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front/api/login/kakao/kakao_login.dart';
import 'package:front/api/login/kakao/login_view_model.dart';
import 'package:front/api/mypage/get_userInfo.dart';
import 'package:front/component/mypage/mypage_tabbar.dart';
import 'package:front/component/signup/login.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  final storage = new FlutterSecureStorage();
  final viewModel = LoginViewModel(KakaoLogin());
  late int userId;
  Future<UserInfo>? _userInfo;
  // late Future<UserInfo> _userInfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userId = int.parse(widget.userId);
    // _userInfo = getUserInfo(userId: userId);
    // getUserInfo(userId: userId).then((userInfo) {
    //   setState(() {
    //     _userInfo = userInfo;
    //   });
    // });
  }

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
                              height: 300,
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
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      print("설정");
                                    },
                                    icon: Icon(Icons.settings),
                                    label: Text("설정"),
                                  ),
                                  TextButton.icon(
                                    onPressed: () async {
                                      // String? userId = await storage.read(key: "userId");
                                      print("감자ㅁㄴㅇㅁㅇㅁㄴㅇㅁ");
                                      print(userId);
                                      // print(_userInfo.nickname);
                                      Navigator.of(context).pop();
                                      print("개인정보 수정");
                                      String? token = await FirebaseMessaging.instance.getToken();

                                      // print("token : ${token ?? 'token NULL!'}");
                                    },
                                    icon: Icon(Icons.settings),
                                    label: Text("개인정보 수정"),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Beamer.of(context).beamToNamed('/mypage/follow');
                                    },
                                    icon: Icon(Icons.settings),
                                    label: Text("팔로잉/팔로워"),
                                  ),
                                  TextButton.icon(
                                    onPressed: () async {
                                      // String? userId =  await storage.read(key: 'userId');
                                      print(userId);
                                      Navigator.of(context).pop();
                                      print("설정");
                                    },
                                    icon: Icon(Icons.settings),
                                    label: Text("사용자 검색"),
                                  ),
                                  TextButton.icon(
                                    onPressed: () async {
                                      await viewModel.logout();
                                      setState(() {

                                      });
                                      /// 로그아웃시
                                      await storage.delete(key: "userId");
                                      Navigator.of(context).pop();
                                      print("로그아웃");
                                      SystemNavigator.pop();
                                      // Navigator.pushAndRemoveUntil(
                                      //   context,
                                      //   MaterialPageRoute(builder: (context) => LoginScreen()),
                                      //       (route) => false,
                                      // );
                                    },
                                    icon: Icon(Icons.logout),
                                    label: Text("로그아웃"),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      print("서비스 탈퇴");
                                      SystemNavigator.pop();
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // 프로필 사진
                  // 컨테이너는 넓이, 높이 설정안하면 -> 자동으로 최대크기
                  // sizedbox는 하나라도 설정안하면 -> 자동으로 child의 최대크기
                  Container(
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
                  GestureDetector(
                    onTap: (){
                      print("팔로워 리스트로 이동");
                      Beamer.of(context).beamToNamed('/mypage/followList/0',
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("팔로워"),
                        Text("52")
                      ],
                    ),
                  ),
                  // 팔로잉(수)
                  GestureDetector(
                    onTap: (){
                      print("팔로잉 리스트로 이동");
                      Beamer.of(context).beamToNamed('/mypage/followList/1',
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("팔로잉"),
                        Text("46")
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // // 3. 프로필 편집, 체지방 28% 버튼
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     ElevatedButton(
            //         style: ElevatedButton.styleFrom(
            //         ),
            //         onPressed: () {
            //         },
            //         child: Text("프로필 편집")),
            //     ElevatedButton(
            //         onPressed: () {
            //           Beamer.of(context).beamToNamed('/mypage/follow');
            //         },
            //         child: Text("팔로워/팔로잉")),
            //   ],
            // ),
            // 4. 사진첩 및 지도 탭바
            MypageTabbar(),
          ],
        ),
      ),
    );
  }
}
