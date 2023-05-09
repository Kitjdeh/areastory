import 'dart:io';
import 'package:flutter/material.dart';
import 'package:front/component/system/message_popup.dart';
import 'package:front/screen/camera_screen.dart';
import 'package:get/get.dart';

enum PageName { MAP, ARTICLES, UPLOAD, FOLLOW, MYPAGE }

class BottomNavController extends GetxController {
  static BottomNavController get to => Get.find();
  RxInt pageIndex = 0.obs;
  GlobalKey<NavigatorState> myPageNavigationKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> snsPageNavigationKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> followPageNavigationKey = GlobalKey<NavigatorState>();


  /// 뒤로가기 기록을 위한 list
  List<int> bottomHistory = [0];

  void changeBottomNav(int value, {bool hasGesture = true}) {
    var page = PageName.values[value];
    switch (page) {
      case PageName.UPLOAD:
        Get.to(() => CameraScreen());
        break;
      case PageName.MAP:
      case PageName.ARTICLES:
      case PageName.FOLLOW:
      case PageName.MYPAGE:
        _changePage(value, hasGesture: hasGesture);
        break;
    }
  }

  void goToPage(int value) {
    _changePage(value, hasGesture: false);
  }

  /// UPLOAD페이지는 바텀 내브를 없앨꺼다.
  void _changePage(int value, {bool hasGesture = true}) {
    pageIndex(value);
    if (!hasGesture) return;
    if (bottomHistory.last != value) {
      bottomHistory.add(value);
      print(bottomHistory);
    }
    // if(bottomHistory.contains(value)) {
    //   bottomHistory.remove(value);
    // }
    //   bottomHistory.add(value);
    // print(bottomHistory);
  }

  Future<bool> willPopAction() async {
    if (bottomHistory.length == 1) {
      print("길이가 1입니다");
      print(bottomHistory);
      showDialog(
          context: Get.context!,
          builder: (context) => MessagePopup(
                title: '시스템',
                message: '종료하시겠습니까?',
                okCallback: () {
                  exit(0);
                },
                cancelCallback: Get.back,
              ));
      return false;
    } else {
      /// stack에서 빼갈게 있다면, 그거 먼저 빼주세요.
      var page =PageName.values[bottomHistory.last];
      if(page == PageName.MYPAGE){
        var value = await myPageNavigationKey.currentState!.maybePop();
        if(value) return false;
      }
      if(page == PageName.ARTICLES){
        var value = await snsPageNavigationKey.currentState!.maybePop();
        if(value) return false;
      }
      if(page == PageName.FOLLOW){
        var value = await followPageNavigationKey.currentState!.maybePop();
        if(value) return false;
      }


      bottomHistory.removeLast();
      var index = bottomHistory.last;
      changeBottomNav(index, hasGesture: false);
      print(bottomHistory);
      return true;
    }
  }
}
