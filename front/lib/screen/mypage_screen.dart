import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front/api/follow/create_following.dart';
import 'package:front/api/follow/delete_following.dart';
import 'package:front/api/login/delete_user.dart';
import 'package:front/api/login/kakao/kakao_login.dart';
import 'package:front/api/login/kakao/login_view_model.dart';
import 'package:front/api/user/get_user.dart';
import 'package:front/component/alarm/alarm_screen.dart';
import 'package:front/component/alarm/toast.dart';
import 'package:front/component/mypage/follow/follow.dart';
import 'package:front/component/mypage/mypage_tabbar.dart';
import 'package:front/component/mypage/report.dart';
import 'package:front/component/mypage/updateprofile/updateprofile.dart';
import 'package:front/constant/home_tabs.dart';
import 'package:front/controllers/mypage_screen_controller.dart';
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
  late String? selectedReportType = "불건전한 닉네임";
  late bool followYn = false;
  final MyPageController _mypageController = Get.find<MyPageController>();

  void setMyId() async {
    myId = await storage.read(key: "userId");
    tabController = TabController(length: 2, vsync: this);

    final userData = await getUser(userId: int.parse(widget.userId));
    setState(() {
      followYn = userData.followYn;
    });
  }

  void chgtoggle() {
    setState(() {
      followYn = !followYn;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    setMyId();
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
                GestureDetector(
                  onTap: () {
                    widget.userId == myId
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateProfileScreen(
                                userId: widget.userId,
                                img: snapshot.data!.profile.toString(),
                                nickname: snapshot.data!.nickname,
                              ),
                            ),
                          ).then((result) {
                            if (result == true) {
                              setState(() {
                                // 정보를 업데이트하기 위한 필요한 작업 수행
                                // 예: _information() 호출 또는 AppBar의 타이틀 업데이트
                              });
                            }
                          })
                        //     ? Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => UpdateProfileScreen(
                        //       userId: widget.userId,
                        //       img: snapshot.data!.profile.toString(),
                        //       nickname: snapshot.data!.nickname,
                        //     ),
                        //   ),
                        // )
                        : null;
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
                    // Get.to(MypageFollowScreen(index: '0'));
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MypageFollowScreen(
                                    index: '0',
                                    userId: widget.userId,
                                    nickname: snapshot.data!.nickname)))
                        .then((result) {
                      if (result == true) {
                        setState(() {
                          // 정보를 업데이트하기 위한 필요한 작업 수행
                          // 예: _information() 호출 또는 AppBar의 타이틀 업데이트
                        });
                      }
                    });
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
                    // Get.to(MypageFollowScreen(index: '1'));
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MypageFollowScreen(
                                    index: '1',
                                    userId: widget.userId,
                                    nickname: snapshot.data!.nickname)))
                        .then((result) {
                      if (result == true) {
                        setState(() {
                          // 정보를 업데이트하기 위한 필요한 작업 수행
                          // 예: _information() 호출 또는 AppBar의 타이틀 업데이트
                        });
                      }
                    });
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

  Widget _optionList() {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // TextButton.icon(
          //   onPressed: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => AlarmScreen(
          //                   userId: int.parse(widget.userId),
          //                   signal: '1',
          //                 )));
          //   },
          //   icon: Icon(
          //     Icons.access_alarm,
          //     color: Colors.black,
          //   ),
          //   label: Text(
          //     "알람",
          //     style: TextStyle(color: Colors.black),
          //   ),
          // ),
          TextButton.icon(
            onPressed: () async {
              // postFollowing(followingId: int.parse(widget.userId));
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
          if (myId != widget.userId)
            TextButton.icon(
              onPressed: () async {
                print("신고하기");
                // await _showReportDialog();
                final msg =
                    await reportUser(targetUserId: int.parse(widget.userId));
                print(msg);
                toast(context, msg.toString());
              },
              icon: Icon(
                Icons.alarm_on,
                color: Colors.black,
              ),
              label: Text(
                "신고하기",
                style: TextStyle(color: Colors.black),
              ),
            ),
          if (myId == widget.userId)
            TextButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("경고"),
                      content: Text("서비스를 탈퇴하시겠습니까?"),
                      actions: [
                        TextButton(
                          child: Text("취소"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text("확인"),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            try {
                              await deleteUser(
                                  userId: int.parse(
                                      myId!)); // userId는 적절한 값으로 대체해야 합니다.
                              await viewModel.logout();
                              setState(() {});
                              await storage.delete(key: "userId");
                              /// 기존 FCM 토큰을 삭제.
                              FirebaseMessaging.instance.deleteToken();
                              SystemNavigator.pop();
                            } catch (e) {
                              // 탈퇴 실패 시 처리할 작업을 추가할 수 있습니다.
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
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
            title: FutureBuilder<UserData>(
                future: getUser(userId: int.parse(widget.userId)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    final bool isFollowing =
                        snapshot.data!.followYn == true || followYn == true;
                    final bool isNotFollowing =
                        snapshot.data!.followYn == false || followYn == false;

                    return Row(
                      children: [
                        Text(
                          snapshot.data!.nickname.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        if (myId != widget.userId && !followYn)
                          GestureDetector(
                              onTap: () {
                              print("팔로잉신청합니다..${snapshot.data!.followYn}");
                              postFollowing(
                                  followingId: int.parse(widget.userId));
                              chgtoggle();
                            },
                            child: Icon(Icons.group_add)
                          ),
                        if (myId != widget.userId && followYn)
                          GestureDetector(
                              onTap: () {
                                print("팔로잉취소합니다..${snapshot.data!.followYn}");
                                deleteFollowing(
                                    followingId: int.parse(widget.userId));
                                chgtoggle();
                              },
                              child: Icon(Icons.group_remove)
                          ),
                        // if (myId != widget.userId && !followYn)
                        //   TextButton(
                        //     onPressed: () {
                        //       print("팔로잉신청합니다..${snapshot.data!.followYn}");
                        //       postFollowing(
                        //           followingId: int.parse(widget.userId));
                        //       chgtoggle();
                        //     },
                        //     child: Text(
                        //       "팔로잉신청",
                        //       style: const TextStyle(
                        //         fontWeight: FontWeight.bold,
                        //         fontSize: 10,
                        //         color: Colors.blue,
                        //       ),
                        //     ),
                        //   ),
                        // if (myId != widget.userId && followYn)
                        //   TextButton(
                        //     onPressed: () {
                        //       deleteFollowing(
                        //           followingId: int.parse(widget.userId));
                        //
                        //       chgtoggle();
                        //     },
                        //     child: Text(
                        //       "팔로잉취소",
                        //       style: const TextStyle(
                        //         fontWeight: FontWeight.bold,
                        //         fontSize: 10,
                        //         color: Colors.red,
                        //       ),
                        //     ),
                        //   ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Text('No data');
                  }
                }),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AlarmScreen(
                            userId: int.parse(widget.userId),
                            signal: '1',
                          )));
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Icon(
                  Icons.access_alarm,
                  color: Colors.black,
                )
                ),
              ),
              GestureDetector(
                onTap: () {
                  // print(widget.userId);
                  // print(myId);
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
            ]),
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
