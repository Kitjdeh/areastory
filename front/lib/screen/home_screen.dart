import 'package:flutter/material.dart';
import 'package:front/constant/home_tabs.dart';
import 'package:front/screen/mypage.dart';
import 'package:front/screen/sns.dart';

// 홈 + 바텀탭바
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// with TickerProviderStateMixin 가 필수인데 이게 프레임관리하는거임
class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final TabController controller;

  @override
  void initState() {
    super.initState();

    controller = TabController(length: MAINTABS.length, vsync: this);

    // 이건 나중에 데이터 작업할때
    controller.addListener(() {
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Home Screen'),
      // ),

      body: TabBarView(controller: controller, children: [
        // 인덱스에 맞춰서 각 페이지를 넣어야 한다.
        Text("지도"),
        SnsScreen(),
        Text("게시글생성"),
        Text("랜덤"),
        MyPageScreen()
      ]),
      bottomNavigationBar: BottomNavigationBar(
          // 선택 유무 Icon 색깔 선정
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,

          // bottomNavigationBar은 label이 필수다. 그래서 show를 안하겠다는 설정을 해야한다.
          showSelectedLabels: false,
          showUnselectedLabels: false,
          // backgroundColor: Colors.black,
          currentIndex: controller.index,
          type: BottomNavigationBarType.shifting,
          onTap: (index) {
            controller.animateTo(index);
          },
          items: MAINTABS
              .map((e) => BottomNavigationBarItem(
                    icon: Icon(e.icon),
                    label: e.label,
                  ))
              .toList()),
    );
  }
}
