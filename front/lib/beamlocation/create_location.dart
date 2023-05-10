// import 'package:flutter/material.dart';
// import 'package:beamer/beamer.dart';
// import 'package:front/screen/camera_screen.dart';
// import 'package:front/screen/sns_screen.dart';
//
// class CreateLocation extends BeamLocation<BeamState> {
//   CreateLocation(super.routeInformation);
//   @override
//   List<String> get pathPatterns => ['/create/:userId', '/create/sns/:userId'];
//
//   @override
//   List<BeamPage> buildPages(BuildContext context, BeamState state) {
//     final userId = state.pathParameters['userId'].toString();
//
//     return [
//       BeamPage(
//         key: ValueKey('create/:userID'),
//         // title: 'Tab A',
//         type: BeamPageType.noTransition,
//         child: CameraScreen(userId: userId),
//         // child: MapScreen(label: 'A', detailsPath: '/a/details'),
//       ),
//       if (state.uri.pathSegments.length == 3 &&
//           state.uri.pathSegments[1] == 'sns')
//         BeamPage(
//           key: ValueKey('create/sns/$userId'),
//           child: SnsScreen(userId: userId),
//         ),
//     ];
//   }
// }
