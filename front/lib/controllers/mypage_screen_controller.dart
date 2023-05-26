import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front/api/follow/create_following.dart';
import 'package:front/api/follow/delete_following.dart';
import 'package:front/api/login/delete_user.dart';
import 'package:front/api/login/kakao/kakao_login.dart';
import 'package:front/api/login/kakao/login_view_model.dart';
import 'package:front/api/user/get_user.dart';
import 'package:front/component/alarm/toast.dart';
import 'package:front/component/mypage/follow/follow.dart';
import 'package:front/component/mypage/mypage_tabbar.dart';
import 'package:front/component/mypage/report.dart';
import 'package:front/component/mypage/updateprofile/updateprofile.dart';
import 'package:front/constant/home_tabs.dart';
import 'package:front/controllers/mypage_screen_controller.dart';
import 'package:get/get.dart';

class MyPageController extends GetxController {
  final storage = new FlutterSecureStorage();
  final viewModel = LoginViewModel(KakaoLogin());
  String? myId;
  late TabController tabController;
  int? cntArticles;
  late String? selectedReportType = "불건전한 닉네임";
  late bool followYn = false;
  late String userId;

  void setMyId() async {
    myId = await storage.read(key: "userId");
    final userData = await getUser(userId: int.parse(userId));
    followYn = userData.followYn;
    update();
  }

  void chgtoggle(){
      followYn = !followYn;
      update();
  }

  void init(userId){
    /// 안먹히면 init에서 tabcontroller값을 내려줍시다.
    // tabController = TabController(length: 2, vsync: this);
    this.userId = userId;
    setMyId();
    update();
  }

}