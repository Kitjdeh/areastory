import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:front/screen/sns.dart';

class SnsLocation extends BeamLocation<BeamState> {
  SnsLocation(super.routeInformation);
  @override
  List<String> get pathPatterns => ['/*'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
    const BeamPage(
      key: ValueKey('sns'),
      // title: 'Tab A',
      type: BeamPageType.noTransition,
      child: SnsScreen(),
      // child: MapScreen(label: 'A', detailsPath: '/a/details'),
    ),
    // if (state.uri.pathSegments.length == 2)
    //   const BeamPage(
    //     key: ValueKey('a/details'),
    //     title: 'Details A',
    //     child: DetailsScreen(label: 'A'),
    //   ),
  ];
}