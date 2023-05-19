import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/src/map/flutter_map_state.dart';
import 'package:flutter_map/src/core/bounds.dart';
import 'package:latlong2/latlong.dart';
import 'package:polygon/polygon.dart' as newpolygon;

import '../../const/colors.dart';

/// Base class for all overlay images.
abstract class CustomOverlayImage {
  ImageProvider get imageProvider;

  double get opacity;

  bool get gaplessPlayback;

  Positioned buildPositionedForOverlay(FlutterMapState map);

  Image buildImageForOverlay() {
    return Image(
      image: imageProvider,
      fit: BoxFit.fill,
      color: Color.fromRGBO(255, 255, 255, 100),
      colorBlendMode: BlendMode.dstIn,
      gaplessPlayback: true,
    );
  }
}

/// Unrotated overlay image that spans between a given bounding box.
///
/// The shortest side of the image will be placed along the shortest side of the
/// bounding box to minimize distortion.
class OverlayImage extends CustomOverlayImage {
  final LatLngBounds bounds;
  final List<LatLng> polygon;
  final List<Offset> offset;
  final String url;
  final String? area;
  final bool entitle;
  @override
  final ImageProvider imageProvider;
  @override
  final double opacity;
  @override
  final bool gaplessPlayback;
  OverlayImage(
      {required this.bounds,
      required this.entitle,
      required this.url,
      required this.polygon,
      required this.offset,
      required this.imageProvider,
      this.area,
      this.opacity = 0.2,
      this.gaplessPlayback = false});

  @override
  Positioned buildPositionedForOverlay(FlutterMapState map) {
    // northWest is not necessarily upperLeft depending on projection
    final bounds = Bounds<num>(
      map.project(this.bounds.northWest) - map.pixelOrigin,
      map.project(this.bounds.southEast) - map.pixelOrigin,
    );
    // print(map.pixelOrigin);
    final bound = LatLngBounds.fromPoints(this.polygon);
    final minLng = bound.west;
    final maxLng = bound.east;
    final maxLat = bound.north;
    final minLat = bound.south;
    final midLat = (maxLat + minLat) / 2;
    final midLng = (maxLng + minLng) / 2;

    // final polLng = bound.south - bound.north;
    // final polLat = bound.east - bound.west;
    // final width = bounds.size.x.toDouble();
    // final height = bounds.size.y.toDouble();
    // print('absX${width*polLat.abs()}');
    // print('absY${height*polLng.abs()}');
    // final xrepair = width*polLat.abs();
    // final yrepair = height*polLng.abs();
    // // final listbounds = this.polygon.map((e)=>Bounds<num>(a, b)).toList();
    // // print()
    // final List<CustomPoint> listpoint =
    //     this.polygon.map((e) => (map.project(e!) - map.pixelOrigin)).toList();
    // // print(listpoint);
    // final List<Offset> listoffset =
    //     listpoint.map((e) => Offset(e.x.toDouble(), e.y.toDouble())).toList();
    // print(listoffset);
    // final List<Offset> listoffset = this
    //     .polygon
    //     .map((e) => Offset(
    //         // (e.longitude -  bounds.size.x.toDouble()) / polLng,(e.latitude -bounds.size.y.toDouble()) / polLat))
    //         (e.longitude - minLng) / polLng,
    //         (e.latitude - minLat) / polLat))
    //     .toList();

    // final List<Offset> listoffset = this
    //     .polygon
    //     .map((e) => Offset(
    //         // (e.longitude -  bounds.size.x.toDouble()) / polLng,(e.latitude -bounds.size.y.toDouble()) / polLat))
    //         (e.longitude - minLng) / polLng,
    //         (e.latitude - minLat) / polLat))
    //     .toList();

    // final List<Offset> listoffset = this
    //     .polygon
    //     .map((e) => Offset(
    //         // (e.longitude -  bounds.size.x.toDouble()) / polLng,(e.latitude -bounds.size.y.toDouble()) / polLat))
    //         (e.longitude - midLng),
    //         (e.latitude - midLat)))
    //     .toList();
    //
    final List<Offset> listoffset = this
        .polygon
        .map((e) => Offset(
            // (e.longitude -  bounds.size.x.toDouble()) / polLng,(e.latitude -bounds.size.y.toDouble()) / polLat))
            (e.longitude - midLng) / (maxLng - midLng),
            (e.latitude - midLat) / (midLat - maxLat)))
        .toList();
    final polygon = newpolygon.Polygon(listoffset);
    List<String> areaname = ['몰?루'];
    area != null ? areaname = area!.split(' ') : null;
    String? localname = areaname.last;
    return Positioned(
      left: bounds.topLeft.x.toDouble(),
      top: bounds.topLeft.y.toDouble(),

      width: bounds.size.x.toDouble(),
      height: bounds.size.y.toDouble(),
      child: DecoratedBox(
        child: Center(
          child: Opacity(
            opacity: 0.8,
            child: Text(
              '${localname}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: Colors.black),
            ),
          ),
        ),
        decoration: ShapeDecoration(
          color: PAINTNG,
          image: url == '' || url == null
              ? entitle == true
                  ? DecorationImage(
                      image: AssetImage('asset/img/color/진한회색.png'),
                      fit: BoxFit.fill)
                  : DecorationImage(
                      image: AssetImage('asset/img/color/마이배경.png'),
                      fit: BoxFit.fill)
              : DecorationImage(image: NetworkImage(url), fit: BoxFit.fill),
          shape: newpolygon.PolygonBorder(
            polygon: polygon,
            // polygon: polygon,
          ),
        ),
      ),
    );
  }
}

class OverlayImageLayer extends StatelessWidget {
  final List<CustomOverlayImage> overlayImages;
  const OverlayImageLayer({super.key, this.overlayImages = const []});
  @override
  Widget build(BuildContext context) {
    final map = FlutterMapState.maybeOf(context)!;
    return ClipRect(
      child: Stack(
        children: <Widget>[
          for (var overlayImage in overlayImages)
            overlayImage.buildPositionedForOverlay(map),
        ],
      ),
    );
  }
}
