import 'package:flutter/material.dart';
import 'package:front/component/mypage/myalbum.dart';
import 'package:front/constant/home_tabs.dart';
import 'package:front/constant/mypage_tabs.dart';

class MypageTabbar extends StatefulWidget {
  const MypageTabbar({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<MypageTabbar> createState() => _MypageTabbarState();
}

class _MypageTabbarState extends State<MypageTabbar>
    with TickerProviderStateMixin {
  late TabController mypagecontroller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    mypagecontroller = TabController(length: 2, vsync: this);

    // 이건 나중에 데이터 작업할때
    mypagecontroller.addListener(() {
      setState(() {
        _currentIndex = mypagecontroller.index;
      });
    });
  }

  @override
  void dispose() {
    mypagecontroller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Column(
          children: [
            TabBar(
              controller: mypagecontroller,
              indicatorColor: Colors.black,
              indicatorWeight: 1,
              tabs: [
                Tab(
                  icon: _currentIndex == 0 ? ImageData(IconsPath.albumOn) : ImageData(IconsPath.albumOff),
                ),
                Tab(
                  icon: _currentIndex == 1 ? ImageData(IconsPath.mapOn) : ImageData(IconsPath.mapOff),
                ),
              ]),
            Expanded(
              child: TabBarView(
                controller: mypagecontroller,
                  children: [MyAlbum(userId: widget.userId), Text("고구마")]),
            )
          ],
        ),
      ),
    );
  }
}
