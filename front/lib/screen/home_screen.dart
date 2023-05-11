import 'package:flutter/material.dart';
import 'package:front/constant/home_tabs.dart';
import 'package:front/controllers/bottom_nav_controller.dart';
import 'package:front/screen/camera_screen.dart';
import 'package:front/screen/follow_screen.dart';
import 'package:front/screen/map_screen.dart';
import 'package:front/screen/mypage_screen.dart';
import 'package:front/screen/sns_screen.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView<BottomNavController> {
  const HomeScreen({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  Widget build(BuildContext context) {
    /// willPopScore: 뒤로가기 이벤트 처리할때 사용한다.
    return WillPopScope(
        child: Obx(
          () => Scaffold(
            // appBar: AppBar(
            //   title: Text(
            //     'AreaStory',
            //     style: TextStyle(
            //       color: Colors.blue,
            //       fontWeight: FontWeight.w700,
            //     ),
            //   ),
            //   backgroundColor: Colors.white,
            //   actions: [
            //     IconButton(
            //       onPressed: () async {},
            //       color: Colors.blue,
            //       icon: Icon(
            //         Icons.my_location,
            //       ),
            //     ),
            //   ],
            // ),
            body: SafeArea(
              child: IndexedStack(
                index: controller.pageIndex.value,
                children: [
                  MapScreen(),
                  Navigator(
                    key: controller.snsPageNavigationKey,
                    onGenerateRoute: (routeSetting) {
                      return MaterialPageRoute(
                        builder: (context) => SnsScreen(userId: userId),
                      );
                    },
                  ),
                  CameraScreen(userId: userId),
                  Navigator(
                    key: controller.followPageNavigationKey,
                    onGenerateRoute: (routeSetting) {
                      return MaterialPageRoute(
                        builder: (context) => FollowScreen(userId: userId),
                      );
                    },
                  ),
                  Navigator(
                    key: controller.myPageNavigationKey,
                    onGenerateRoute: (routeSetting) {
                      return MaterialPageRoute(
                        builder: (context) => MyPageScreen(userId: userId),
                      );
                    },
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              /// 바텀 내브바 css효과들 건드릴때 쓰십쇼
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: false,
              showSelectedLabels: false,
              elevation: 0,

              /// 앞으로 어디선가 컨트롤러값을 변경시킬때는 쓰세요.
              currentIndex: controller.pageIndex.value,
              onTap: controller.changeBottomNav,
              items: [
                BottomNavigationBarItem(
                  icon: ImageData(IconsPath.mapOff),
                  activeIcon: ImageData(IconsPath.mapOn),
                  label: 'map',
                ),
                BottomNavigationBarItem(
                  icon: ImageData(IconsPath.articlesOff),
                  activeIcon: ImageData(IconsPath.articlesOn),
                  label: 'articles',
                ),
                BottomNavigationBarItem(
                  icon: ImageData(IconsPath.uploadOff),
                  label: 'upload',
                ),
                BottomNavigationBarItem(
                  icon: ImageData(IconsPath.followOff),
                  activeIcon: ImageData(IconsPath.followOn),
                  label: 'follow',
                ),
                BottomNavigationBarItem(
                  icon: ImageData(IconsPath.mypageOff),
                  activeIcon: ImageData(IconsPath.mypageOn),
                  label: 'mypage',
                ),
              ],
            ),
          ),
        ),
        onWillPop: controller.willPopAction);
  }
}
