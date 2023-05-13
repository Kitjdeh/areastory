import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front/api/login/kakao/kakao_login.dart';
import 'package:front/api/login/kakao/login_view_model.dart';
import 'package:front/api/user/get_user.dart';
import 'package:front/component/mypage/follow/follow.dart';
import 'package:front/component/mypage/mypage_tabbar.dart';
import 'package:front/component/mypage/updateprofile/updateprofile.dart';
import 'package:front/constant/home_tabs.dart';
import 'package:get/get.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen>
    with TickerProviderStateMixin {
  final storage = new FlutterSecureStorage();
  final viewModel = LoginViewModel(KakaoLogin());
  String? myId;
  late TabController tabController;
  int? cntArticles;

  void setMyId() async {
    myId = await storage.read(key: "userId");
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    setMyId();
    print("마이페이지 이닛스테이트가 돌아가요");
  }

  @override
  Widget build(BuildContext context) {
    return _buildMyPageScreen();
  }

  /// 유저 정보 위젯
  Widget _information() {
    return FutureBuilder<UserData>(
      future: getUser(userId: int.parse(widget.userId)),
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
          return Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 프로필 사진
                // 컨테이너는 넓이, 높이 설정안하면 -> 자동으로 최대크기
                // sizedbox는 하나라도 설정안하면 -> 자동으로 child의 최대크기
                GestureDetector(
                  onTap: () {
                    widget.userId == myId
                        ?
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateProfileScreen(
                          userId: widget.userId,
                          img: snapshot.data!.profile.toString(),
                          nickname: snapshot.data!.nickname,
                        ),
                      ),
                    )
                    // Get.to(UpdateProfileScreen(
                    //         userId: widget.userId,
                    //         img: snapshot.data!.profile.toString(),
                    //         nickname: snapshot.data!.nickname))
                        : null;
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             UpdateProfileScreen(userId: widget.userId, img: snapshot.data!.profile.toString())))
                    // : null;
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    // ClipRRect: R이 2개다. 그리고 강제로 차일드의 모양을 강제로 잡아주는 용도.
                    child: ClipRRect(
                      // 가장 완벽한 원을 만드는 방법은 상위가 되었든 뭐든, 높이길이의 50%(높이=넓이)
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        snapshot.data!.profile.toString(),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // 게시물(수)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      snapshot.data!.articleCount.toString(),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text("게시물",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ],
                ),
                // 팔로워(수)
                GestureDetector(
                  onTap: () {
                    print("팔로워 리스트로 이동");
                    // Get.to(MypageFollowScreen(index: '0'));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MypageFollowScreen(
                                index: '0', userId: widget.userId, nickname: snapshot.data!.nickname)));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(snapshot.data!.followCount.toString(),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Text("팔로워",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ],
                  ),
                ),
                // 팔로잉(수)
                GestureDetector(
                  onTap: () {
                    print("팔로잉 리스트로 이동");
                    // Get.to(MypageFollowScreen(index: '1'));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MypageFollowScreen(
                                index: '1', userId: widget.userId, nickname: snapshot.data!.nickname)));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(snapshot.data!.followingCount.toString(),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Text("팔로잉",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  /// 마이앨범과 지도
  // Widget _tabMenu() {
  //   return TabBar(
  //       controller: tabController,
  //       indicatorColor: Colors.black,
  //       indicatorWeight: 1,
  //       tabs: [
  //         Container(
  //           padding: const EdgeInsets.symmetric(vertical: 10),
  //           child: ImageData(IconsPath.albumOn),
  //         ),
  //         Container(
  //           child: ImageData(IconsPath.mapOff),
  //         ),
  //       ]
  //   );
  // }

  // Widget _tabView() {
  //   return GridView.builder(
  //     physics: const NeverScrollableScrollPhysics(),
  //     shrinkWrap: true,
  //     itemCount: 100,
  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 3,
  //       childAspectRatio: 1,
  //       mainAxisSpacing: 1,
  //       crossAxisSpacing: 1,
  //     ),
  //     itemBuilder: (BuildContext context, int index) {
  //       return Container(
  //         color: Colors.grey,
  //       );
  //     },
  //   );
  // }

  Widget _optionList() {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton.icon(
            onPressed: () async {
              await viewModel.logout();
              setState(() {});

              /// 로그아웃시
              await storage.delete(key: "userId");
              Navigator.of(context).pop();
              print("로그아웃");

              /// 시스템 강제종료
              SystemNavigator.pop();
            },
            icon: Icon(
              Icons.logout,
              color: Colors.black,
            ),
            label: Text(
              "로그아웃",
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              print("서비스 탈퇴");
              SystemNavigator.pop();
            },
            icon: Icon(
              Icons.group_off,
              color: Colors.black,
            ),
            label: Text(
              "서비스 탈퇴",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyPageScreen() {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          // automaticallyImplyLeading: false,
          // leading:IconButton(
          //   icon: Icon(Icons.arrow_back, color: Colors.black,),
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //   },
          // ),
          // leading: myId == null || widget.userId == myId
          //     ? null
          //     : IconButton(
          //         icon: Icon(Icons.arrow_back, color: Colors.black,),
          //         onPressed: () {
          //           Navigator.of(context).pop();
          //         },
          //       ),
          title: FutureBuilder<UserData>(
              future: getUser(userId: int.parse(widget.userId)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  return Text(
                    snapshot.data!.nickname.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text('No data');
                }
              }),
          actions: widget.userId == myId
              ? [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        // 모달 이외 클릭시 모달창 닫힘.
                        builder: (BuildContext context) {
                          return _optionList();
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: ImageData(
                        IconsPath.menunIcon,
                        width: 100,
                      ),
                    ),
                  )
                ]
              : null,
        ),
        body: SafeArea(
            child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            _information(),
            const SizedBox(
              height: 15,
            ),
            MypageTabbar(userId: widget.userId),
            // _tabMenu(),
            // _tabView(),
          ],
        )));
  }
}
