import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:front/component/mypage/follow/follower.dart';
import 'package:front/component/mypage/follow/following.dart';
import 'package:front/component/mypage/search/search.dart';
import 'package:front/constant/follow_tabs.dart';
import 'package:front/constant/home_tabs.dart';
import 'package:front/controllers/bottom_nav_controller.dart';
import 'package:get/get.dart';

class MypageFollowScreen extends StatefulWidget {
  const MypageFollowScreen(
      {Key? key, required this.index, required this.userId, required this.nickname})
      : super(key: key);
  final String index;
  final String userId;
  final String nickname;

  @override
  State<MypageFollowScreen> createState() => _MypageFollowScreenState();
}

class _MypageFollowScreenState extends State<MypageFollowScreen>
    with TickerProviderStateMixin {
  String? _inputValue;

  late final TabController followcontroller;

  @override
  void initState() {
    super.initState();
    followcontroller = TabController(length: FOLLOWTABS.length, vsync: this);
    followcontroller.index = int.parse(widget.index);
    followcontroller.addListener(() {
      setState(() {});
    });
  }

  Widget _appbar() {
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SearchScreen(userId: widget.userId))).then((result) {
          if (result == true) {
            setState(() {
              // 정보를 업데이트하기 위한 필요한 작업 수행
              // 예: _information() 호출 또는 AppBar의 타이틀 업데이트
            });
          }
        });
      },
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xffefefef),
              ),
              child: Row(
                children: const [
                  Icon(Icons.search),
                  Text(
                    '검색',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xff838383),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.nickname.toString(),
          style: TextStyle(color: Colors.black),
        ),
        // leading: GestureDetector(
        //   onTap: (){
        //     Get.find<BottomNavController>().willPopAction();
        //   },
        //   child: ImageData(IconsPath.backIcon),
        // ),
        /// 앱바 그림자효과 제거
        leading: IconButton(
          /// 뒤로가기버튼설정
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          color: Colors.black,
          onPressed: () {
            // Get.find<BottomNavController>().willPopAction();
            Navigator.pop(context, true);
          },
        ),
      ),
      body: Column(
        children: [
          _appbar(),
          Expanded(
            child: Container(
              child: Column(
                children: [
                  TabBar(
                      controller: followcontroller,
                      labelColor: Colors.black,
                      tabs: FOLLOWTABS
                          .map((e) => Tab(
                                text: e.label,
                              ))
                          .toList()),
                  Expanded(
                      child:
                          TabBarView(controller: followcontroller, children: [
                    FollowerListScreen(userId: widget.userId),
                    FollowingListScreen(userId: widget.userId),
                  ]))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
