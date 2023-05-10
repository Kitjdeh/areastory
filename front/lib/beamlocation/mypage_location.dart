import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:front/component/mypage/follow/follow.dart';
import 'package:front/screen/mypage_screen.dart';

class MypageLocation extends BeamLocation<BeamState> {
  MypageLocation(super.routeInformation);

  @override
  List<String> get pathPatterns => ['/mypage/:userId', '/mypage/followList/:index'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final index = state.pathParameters['index'].toString() ?? '0';
    final userId = state.pathParameters['userId'].toString();

    return [
      if (state.uri.pathSegments.length == 2)
        BeamPage(
          key: ValueKey('mypage/$userId'),
          type: BeamPageType.noTransition,
          child: MyPageScreen(userId: userId),
        ),
      // if (state.uri.pathSegments.length == 3)
      //   BeamPage(
      //     key: ValueKey('mypage/followList/$index'),
      //     child: MypageFollowScreen(index: index),
      //   ),
    ];
  }
}