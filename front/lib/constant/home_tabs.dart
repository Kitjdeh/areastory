import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageData extends StatelessWidget {
  String icon;
  final double? width;
  ImageData(
    this.icon, {
    Key? key,
    this.width = 55,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(icon, width: width! / Get.mediaQuery.devicePixelRatio);
  }
}

class IconsPath {
  static String get mapOff =>
      'asset/img/bottom_nav/bottom_nav_map_off_icon.png';
  static String get mapOn => 'asset/img/bottom_nav/bottom_nav_map_on_icon.png';
  static String get articlesOff =>
      'asset/img/bottom_nav/bottom_nav_articles_off_icon.png';
  static String get articlesOn =>
      'asset/img/bottom_nav/bottom_nav_articles_on_icon.png';
  static String get uploadOff =>
      'asset/img/bottom_nav/bottom_nav_upload_off_icon.png';
  static String get followOff =>
      'asset/img/bottom_nav/bottom_nav_follow_off_icon.png';
  static String get followOn =>
      'asset/img/bottom_nav/bottom_nav_follow_on_icon.png';
  static String get mypageOff =>
      'asset/img/bottom_nav/bottom_nav_mypage_off_icon.png';
  static String get mypageOn =>
      'asset/img/bottom_nav/bottom_nav_mypage_on_icon.png';
  static String get menunIcon => 'asset/img/options/menu_icon.jpg';
  static String get albumOn => 'asset/img/options/grid_view_on_icon.jpg';
  static String get albumOff => 'asset/img/options/grid_view_off_icon.jpg';
  static String get logo => 'asset/img/logo.png';
  static String get likeOffIcon => 'asset/img/options/like_off_icon.jpg';
  static String get likeOnIcon => 'asset/img/options/like_on_icon.jpg';
  static String get replyIcon => 'asset/img/options/reply_icon.jpg';
  static String get backIcon => 'asset/img/options/back_icon.jpg';
  static String get loginLogo => 'asset/img/login_logo.png';
  static String get postMoreIcon => 'asset/img/options/more_icon.jpg';
  static String get directMessage => 'asset/img/options/direct_msg_icon.jpg';
  static String get bookMarkOffIcon => 'asset/img/options/direct_msg_icon.jpg';
  static String get deleteOnIcon => 'asset/img/options/delete_on_icon.png';
  static String get deleteOffIcon => 'asset/img/options/delete_off_icon.png';
  static String get delete => 'asset/img/delete.png';
  static String get follow => 'asset/img/follow.png';
  static String get following => 'asset/img/following.png';
  static String get gosns => 'asset/img/gosns.png';
  static String get livechat => 'asset/img/livechat.png';
  static String get update => 'asset/img/update.png';
  static String get recently => 'asset/img/recently.png';
  static String get hot => 'asset/img/hot.png';
  static String get findlocation => 'asset/img/findlocation.png';
  static String get mylocation => 'asset/img/mylocation.png';
  static String get camera => 'asset/img/camera.png';
  static String get nowlocation => 'asset/img/nowlocation.png';
  static String get zoomIn => 'asset/img/zoomIn.png';
  static String get zoomOut => 'asset/img/zoomOut.png';
  static String get like => 'asset/img/like.png';
  static String get nolike => 'asset/img/nolike.png';
  static String get comment => 'asset/img/comment.png';
  static String get go => 'asset/img/go.png';
  static String get stop => 'asset/img/stop.png';

}
