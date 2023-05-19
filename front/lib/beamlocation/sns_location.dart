// import 'package:flutter/material.dart';
// import 'package:beamer/beamer.dart';
// import 'package:front/component/sns/article_update_screen.dart';
// import 'package:front/component/sns/comment_screen.dart';
// import 'package:front/component/sns/like_screen.dart';
// import 'package:front/screen/sns_screen.dart';
// import 'package:front/livechat/chat_screen.dart';
//
// class SnsLocation extends BeamLocation<BeamState> {
//   SnsLocation(super.routeInformation);
//   @override
//   List<String> get pathPatterns => [
//         '/sns/:userId',
//         '/sns/chat'
//       ];
//
//   @override
//   List<BeamPage> buildPages(BuildContext context, BeamState state) {
//     final index = state.pathParameters['index'].toString() ?? '0';
//     final userId = state.pathParameters['userId'].toString();
//
//     return [
//       if (state.uri.pathSegments.length == 2)
//         BeamPage(
//           key: ValueKey('sns/$userId'),
//           // title: 'Tab A',
//           type: BeamPageType.noTransition,
//           child: SnsScreen(userId: userId),
//           // child: MapScreen(label: 'A', detailsPath: '/a/details'),
//         ),
//       if (state.uri.pathSegments.length == 3 &&
//           state.uri.pathSegments[1] == 'chat')
//         const BeamPage(
//           key: ValueKey('sns/chat/go'),
//           child: LiveChatTest(),
//         ),
//     ];
//   }
// }
