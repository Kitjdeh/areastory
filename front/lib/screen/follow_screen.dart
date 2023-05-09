import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front/api/login/kakao/kakao_login.dart';
import 'package:front/api/login/kakao/login_view_model.dart';
import 'package:front/component/mypage/follow/follow.dart';
import 'package:front/controllers/bottom_nav_controller.dart';
import 'package:get/get.dart';

class FollowScreen extends StatefulWidget {
  const FollowScreen({Key? key, required}) : super(key: key);

  @override
  State<FollowScreen> createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen> {
  final storage = new FlutterSecureStorage();
  final viewModel = LoginViewModel(KakaoLogin());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text("팔로우 아티클스 페이지!"),
              TextButton.icon(
                onPressed: () async {
                  await viewModel.logout();
                  setState(() {});

                  /// 로그아웃시
                  await storage.delete(key: "userId");
                  Navigator.of(context).pop();
                  print("로그아웃");
                  SystemNavigator.pop();
                },
                icon: Icon(Icons.logout),
                label: Text("로그아웃"),
              ),
              TextButton.icon(
                onPressed: () async {
                  final bottomNavController = Get.find<BottomNavController>();
                  bottomNavController.changeBottomNav(1);
                },
                icon: Icon(Icons.logout),
                label: Text("페이지이동테스트"),
              ),
              TextButton.icon(
                onPressed: () async {
                  // Get.to(MypageFollowScreen(index: '0'));
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MypageFollowScreen(index: '0')));
                },
                icon: Icon(Icons.logout),
                label: Text("중첩라우팅"),
              ),
            ],
          )
        ],
      ),
    );
  }
}