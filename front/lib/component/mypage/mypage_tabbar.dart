import 'package:flutter/material.dart';
import 'package:front/component/mypage/myalbum.dart';
import 'package:front/constant/mypage_tabs.dart';

class MypageTabbar extends StatefulWidget {
  const MypageTabbar({Key? key}) : super(key: key);

  @override
  State<MypageTabbar> createState() => _MypageTabbarState();
}

class _MypageTabbarState extends State<MypageTabbar>
    with TickerProviderStateMixin {
  late final TabController mypagecontroller;

  @override
  void initState() {
    super.initState();

    mypagecontroller = TabController(length: MYPAGETABS.length, vsync: this);

    // 이건 나중에 데이터 작업할때
    mypagecontroller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.green,
        child: Column(
          children: [
            TabBar(
              controller: mypagecontroller,
              tabs: MYPAGETABS
            .map((e) => Tab(icon: Icon(e.icon),)).toList()),
            Expanded(
              child: TabBarView(
                controller: mypagecontroller,
                  children: [MyAlbum(), Text("고구마")]),
            )
          ],
        ),
      ),
    );
  }
}
