import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:front/component/mypage/follow/follower.dart';
import 'package:front/component/mypage/follow/following.dart';
import 'package:front/constant/follow_tabs.dart';

class MypageFollowScreen extends StatefulWidget {
  const MypageFollowScreen({Key? key}) : super(key: key);

  @override
  State<MypageFollowScreen> createState() => _MypageFollowScreenState();
}

class _MypageFollowScreenState extends State<MypageFollowScreen>
    with TickerProviderStateMixin {
  String? _inputValue;
  String? _categoryVal;

  late final TabController followcontroller;

  @override
  void initState() {
    super.initState();

    followcontroller = TabController(length: FOLLOWTABS.length, vsync: this);
    // final location = 0;
    // print(location);
    // followcontroller.index = (context.currentBeamLocation.state.queryParameters['index'] as int?) ?? 0;

    followcontroller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "유저 닉네임",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,

        /// 앱바 그림자효과 제거
        leading: IconButton(
          /// 뒤로가기버튼설정
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: "Search",

              /// 배경색을 채운다 -> 배경색 변경 가능.
              filled: true,
              fillColor: Colors.blue,
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (val) {
              setState(() {
                _inputValue = val;
              });
            },
            onSubmitted: (val) {
              /// 전송할 값
              print(_inputValue);
              /// 현재 선택된 탭바 인덱스 -> 0: 팔로우, 1: 팔로잉
              print(followcontroller.index);
              /// 입력 완료 후 처리할 로직
              setState(() {
                _inputValue = '';
              });
            },
          ),
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
                      child: TabBarView(
                          controller: followcontroller,
                          children: [FollowerListScreen(), FollowingListScreen(),]))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
