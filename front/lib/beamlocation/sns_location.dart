import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:front/component/sns/comment_screen.dart';
import 'package:front/component/sns/like_screen.dart';
import 'package:front/screen/sns_screen.dart';

class SnsLocation extends BeamLocation<BeamState> {
  SnsLocation(super.routeInformation);
  @override
  List<String> get pathPatterns => [
        ''
            '/*'
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('sns'),
          // title: 'Tab A',
          type: BeamPageType.noTransition,
          child: SnsScreen(),
          // child: MapScreen(label: 'A', detailsPath: '/a/details'),
        ),
        if (state.uri.pathSegments.length == 2 &&
            state.uri.pathSegments[1] == 'comment')
          const BeamPage(
            key: ValueKey('sns/comment'),
            child: SnsCommentScreen(),
          ),
        if (state.uri.pathSegments.length == 2 &&
            state.uri.pathSegments[1] == 'like')
          const BeamPage(
            key: ValueKey('sns/like'),
            child: SnsLikeScreen(),
          ),
      ];
}
