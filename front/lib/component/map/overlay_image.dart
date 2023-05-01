import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/src/map/flutter_map_state.dart';
import 'package:flutter_map/src/core/bounds.dart';
import 'package:latlong2/latlong.dart';
import 'package:polygon/polygon.dart' as newpolygon;

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
  @override
  final ImageProvider imageProvider;
  @override
  final double opacity;
  @override
  final bool gaplessPlayback;

  OverlayImage(
      {required this.bounds,
      required this.url,
      required this.polygon,
      required this.offset,
      required this.imageProvider,
      this.opacity = 1.0,
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
    // print('polLat${polLat}');
    // print('polLat${1/polLat}');
    // print('polLng${polLng}');
    // print('ttttt${bounds.topRight.x.toDouble() - bounds.topLeft.x.toDouble()}');
    // print(
    //     'ttttt${bounds.bottomLeft.y.toDouble() - bounds.topLeft.y.toDouble()}');
    // print('absX${width*polLat.abs()}');
    // print('absY${height*polLng.abs()}');
    // final xrepair = width*polLat.abs();
    // final yrepair = height*polLng.abs();
    // print('maxLat${maxLat}minLat${minLat}');
    // print('maxLng${maxLng}minLng${minLng}');
    // print('width ${bound.south} bound.nort ${bound.north}');
    // print('bound.east  ${bound.east } bound.west ${bound.west}');
    // print(c);
    // print(this.polygon);
    // // final listbounds = this.polygon.map((e)=>Bounds<num>(a, b)).toList();
    // print(this.polygon.first);
    // print('1');
    // print(map.project(a!) - map.pixelOrigin);
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
    // listoffset.add(Offset(-1,1));
    // final List<Offset> listoffset = this
    //     .polygon
    //     .map((e) => Offset(
    //         (e.longitude - minLng) * height, (e.latitude - minLat) * -width))
    //     .toList();
    // print(listoffset);
    // print(this.polygon.first);
    // print(listoffset.first.dx);
    // print(bounds);

    // print('listoffset${listoffset}');
    // print('offset${offset}');
    //
    // print('aasdfasdf${bounds.topLeft.x.toDouble()}');
    // print('sgsdsdf${listoffset.first.dx}');
    // print('${bounds.topLeft.x.toDouble() - listoffset.first.dx}');
    // print('ttttt${bounds.topLeft.x.toDouble() -bounds.topRight.x.toDouble()}');
    // print('aasdfasdf${listoffset.first.dx}');
    final polygon = newpolygon.Polygon(listoffset);
    // final polygon = newpolygon.Polygon(offset);
    // print(polygon.vertices);
    return Positioned(
        left: bounds.topLeft.x.toDouble(),
        top: bounds.topLeft.y.toDouble(),
        width: bounds.size.x.toDouble(),
        height: bounds.size.y.toDouble(),
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: Colors.blue,
            image: DecorationImage(
                image:
                    // AssetImage(url)
                    NetworkImage(url)
                // AssetImage('asset/img/doji.jpg')
                ,
                fit: BoxFit.cover),
            shape: newpolygon.PolygonBorder(
              polygon: polygon,
              // polygon: polygon,
            ),
          ),
        ));
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
