// import 'package:flutter/material.dart';
// import 'package:beamer/beamer.dart';
// import 'package:front/component/signup/login.dart';
//
// class LoginLocation extends BeamLocation<BeamState> {
//   LoginLocation(super.routeInformation);
//   @override
//   List<String> get pathPatterns => ['/login'];
//
//   @override
//   List<BeamPage> buildPages(BuildContext context, BeamState state) => [
//     const BeamPage(
//       key: ValueKey('login'),
//       // title: 'Tab A',
//       // type: BeamPageType.noTransition,
//       child: LoginScreen(),
//       // child: MapScreen(label: 'A', detailsPath: '/a/details'),
//     ),
//     // if (state.uri.pathSegments.length == 2)
//     //   const BeamPage(
//     //     key: ValueKey('a/details'),
//     //     title: 'Details A',
//     //     child: DetailsScreen(label: 'A'),
//     //   ),
//   ];
// }