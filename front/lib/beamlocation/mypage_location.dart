import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:front/component/mypage/follow/follow.dart';
import 'package:front/screen/mypage_screen.dart';

class MypageLocation extends BeamLocation<BeamState> {
  MypageLocation(super.routeInformation);
  @override
  List<String> get pathPatterns => ['/*'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
    const BeamPage(
      key: ValueKey('mypage'),
      // title: 'Tab A',
      type: BeamPageType.noTransition,
      child: MyPageScreen(),
      // child: MapScreen(label: 'A', detailsPath: '/a/details'),
    ),
    if (state.uri.pathSegments.length == 2)
      const BeamPage(
        key: ValueKey('mypage/follow'),
        child: MypageFollowScreen(),
      ),
  ];
}