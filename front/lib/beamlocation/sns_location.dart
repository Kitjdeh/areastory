import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:front/component/sns/comment_screen.dart';
import 'package:front/component/sns/like_screen.dart';
import 'package:front/screen/sns_screen.dart';
import 'package:front/socket/socket_test.dart';

class SnsLocation extends BeamLocation<BeamState> {
  SnsLocation(super.routeInformation);
  @override
  List<String> get pathPatterns =>
      ['/sns', '/sns/like/:index', '/sns/comment/:index', '/sns/chat'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final index = state.pathParameters['index'].toString() ?? '0';

    return [
      const BeamPage(
        key: ValueKey('sns'),
        // title: 'Tab A',
        type: BeamPageType.noTransition,
        child: SnsScreen(),
        // child: MapScreen(label: 'A', detailsPath: '/a/details'),
      ),
      if (state.uri.pathSegments.length == 3 &&
          state.uri.pathSegments[1] == 'comment')
        BeamPage(
          key: ValueKey('sns/comment/$index'),
          child: SnsCommentScreen(index: index),
        ),
      if (state.uri.pathSegments.length == 3 &&
          state.uri.pathSegments[1] == 'like')
        BeamPage(
          key: ValueKey('sns/like/$index'),
          child: SnsLikeScreen(index: index),
        ),
      if (state.uri.pathSegments.length == 2 &&
          state.uri.pathSegments[1] == 'chat')
        const BeamPage(
          key: ValueKey('sns/chat'),
          child: LiveChatTest(),
        ),
    ];
  }
}
