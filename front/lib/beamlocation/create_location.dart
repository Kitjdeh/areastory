import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:front/screen/camera_screen.dart';
import 'package:front/screen/sns_screen.dart';

class CreateLocation extends BeamLocation<BeamState> {
  CreateLocation(super.routeInformation);
  @override
  List<String> get pathPatterns => ['/create', '/create/sns'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      const BeamPage(
        key: ValueKey('create'),
        // title: 'Tab A',
        type: BeamPageType.noTransition,
        child: CameraScreen(),
        // child: MapScreen(label: 'A', detailsPath: '/a/details'),
      ),
      // if (state.uri.pathSegments.length == 2 &&
      //     state.uri.pathSegments[1] == 'sns')
      //   const BeamPage(
      //     key: ValueKey('create/sns'),
      //     child: SnsScreen(),
      //   ),
    ];
  }
}
