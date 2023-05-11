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
      {Key? key, required this.index, required this.userId})
      : super(key: key);
  final String index;
  final String userId;

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
                    SearchScreen(userId: widget.userId)));
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
          "유저 닉네임",
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
            Get.find<BottomNavController>().willPopAction();
          },
        ),
      ),
      body: Column(
        children: [
          _appbar(),
          // TextField(
          //   decoration: InputDecoration(
          //     hintText: "Search",
          //
          //     /// 배경색을 채운다 -> 배경색 변경 가능.
          //     filled: true,
          //     fillColor: Colors.blue,
          //     border: OutlineInputBorder(),
          //     prefixIcon: Icon(Icons.search),
          //   ),
          //   onChanged: (val) {
          //     setState(() {
          //       _inputValue = val;
          //     });
          //   },
          //   onSubmitted: (val) {
          //     /// 전송할 값
          //     print(_inputValue);
          //
          //     /// 현재 선택된 탭바 인덱스 -> 0: 팔로우, 1: 팔로잉
          //     print(followcontroller.index);
          //
          //     /// 입력 완료 후 처리할 로직
          //     setState(() {
          //       _inputValue = '';
          //     });
          //   },
          // ),
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
                    FollowerListScreen(),
                    FollowingListScreen(),
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
