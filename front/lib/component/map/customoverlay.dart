import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:front/component/map/overlay_image.dart' as CustomOverlay;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map/src/layer/label.dart';
import 'package:flutter_map/src/map/flutter_map_state.dart';
import 'package:front/component/sns/article/article_alert.dart';
import 'package:front/component/sns/article/article_detail.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:widget_mask/widget_mask.dart'; // conflict with Path from UI

enum PolygonLabelPlacement {
  centroid,
  polylabel,
}

class CustomPolygonLayer extends StatelessWidget {
  final List<Polygon> polygons;
  final List<String> urls;
  final int userId;
  final String area;
  final int articleId;
  final bool entitle;

  /// screen space culling of polygons based on bounding box
  final bool polygonCulling;

  CustomPolygonLayer(
      {super.key,
      required this.entitle,
      this.polygons = const [],
      this.area = '',
      this.polygonCulling = false,
      this.urls = const [],
      this.userId = 0,
      this.articleId = 0}) {
    if (polygonCulling) {
      for (final polygon in polygons) {
        polygon.boundingBox = LatLngBounds.fromPoints(polygon.points);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints bc) {
        final map = FlutterMapState.maybeOf(context)!;
        final size = Size(bc.maxWidth, bc.maxHeight);
        final polygonsWidget = <Widget>[];
        var cnt = 0;
        for (final polygon in polygons) {
          polygon.offsets.clear();

          if (null != polygon.holeOffsetsList) {
            for (final offsets in polygon.holeOffsetsList!) {
              offsets.clear();
            }
          }
          if (polygonCulling &&
              !polygon.boundingBox.isOverlapping(map.bounds)) {
            // skip this polygon as it's offscreen
            continue;
          }
          _fillOffsets(polygon.offsets, polygon.points, map);
          if (null != polygon.holePointsList) {
            final len = polygon.holePointsList!.length;
            for (var i = 0; i < len; ++i) {
              _fillOffsets(
                  polygon.holeOffsetsList![i], polygon.holePointsList![i], map);
            }
          }
          ImageProvider<Object> buildWhiteForOverlay() {
            return
                // FadeInImage(
                //   placeholder: placeholder,
                //   image: NetworkImage('asset/img/sangjun.PNG'));
                NetworkImage('asset/img/sangjun.PNG');
            // AssetImage('asset/img/sangjun.PNG');
            // return NetworkImage('https://www.newsinside.kr/news/photo/202110/1119485_797392_2214.jpg');
          }

          //
          // final overlayImages = <BaseOverlayImage>[
          //   OverlayImage(
          //     bounds: LatLngBounds.fromPoints(polygon.points),
          //     opacity: 1.0,
          //     imageProvider: buildWhiteForOverlay(),
          //   ),
          // ];
          final customoverlayImages = <CustomOverlay.CustomOverlayImage>[
            CustomOverlay.OverlayImage(
              entitle: entitle,
              area: area,
              url: urls[cnt],
              offset: polygon.offsets,
              polygon: polygon.points,
              bounds: LatLngBounds.fromPoints(polygon.points),
              opacity: 0.5,
              imageProvider: buildWhiteForOverlay(),
            ),
          ];
          // print('sdkfnklskdnfglskg${polygon.offsets}');
          polygonsWidget.add(
            CustomPaint(
              key: polygon.key,
              child: GestureDetector(
                onTap: () {
                  articleId == 0
                      ? showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertModal(
                              message: '게시글이 없는 지역입니다',
                            );
                          },
                        )
                      : showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: GestureDetector(
                                onTap: () {},
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  child: Center(
                                    child: ArticleDetailComponent(
                                      articleId: articleId,
                                      userId: userId,
                                      // 지금 로그인한 유저Id
                                      height: 500,
                                      location: area, // 길이가 1단어~4단어 아무렇게나
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                },
                child: CustomOverlay.OverlayImageLayer(
                    overlayImages: customoverlayImages),
              ),
              foregroundPainter: PolygonPainter(
                polygon,
                map.rotationRad,
              ),
              // painter: PolygonPainter(polygon, map.rotationRad),
              size: size,
            ),
          );
          cnt += 1;
        }

        return Stack(
          children: polygonsWidget,
        );
      },
    );
  }

  void _fillOffsets(final List<Offset> offsets, final List<LatLng> points,
      FlutterMapState map) {
    final len = points.length;
    for (var i = 0; i < len; ++i) {
      final point = points[i];
      final offset = map.getOffsetFromOrigin(point);
      offsets.add(offset);
    }
  }
}

class PolygonPainter extends CustomPainter {
  final Polygon polygonOpt;
  final double rotationRad;

  PolygonPainter(this.polygonOpt, this.rotationRad);

  @override
  void paint(Canvas canvas, Size size) {
    if (polygonOpt.offsets.isEmpty) {
      return;
    }
    final rect = Offset.zero & size;
    _paintPolygon(canvas, rect);
  }

  void _paintBorder(Canvas canvas) {
    if (polygonOpt.borderStrokeWidth > 0.0) {
      final borderPaint = Paint()
        ..color = polygonOpt.borderColor
        ..strokeWidth = polygonOpt.borderStrokeWidth;

      if (polygonOpt.isDotted) {
        final borderRadius = (polygonOpt.borderStrokeWidth / 2);

        final spacing = polygonOpt.borderStrokeWidth * 1.5;
        _paintDottedLine(
            canvas, polygonOpt.offsets, borderRadius, spacing, borderPaint);

        if (!polygonOpt.disableHolesBorder &&
            null != polygonOpt.holeOffsetsList) {
          for (final offsets in polygonOpt.holeOffsetsList!) {
            _paintDottedLine(
                canvas, offsets, borderRadius, spacing, borderPaint);
          }
        }
      } else {
        borderPaint
          ..style = PaintingStyle.stroke
          ..strokeCap = polygonOpt.strokeCap
          ..strokeJoin = polygonOpt.strokeJoin;

        _paintLine(canvas, polygonOpt.offsets, borderPaint);

        if (!polygonOpt.disableHolesBorder &&
            null != polygonOpt.holeOffsetsList) {
          for (final offsets in polygonOpt.holeOffsetsList!) {
            _paintLine(canvas, offsets, borderPaint);
          }
        }
      }
    }
  }

  void _paintDottedLine(Canvas canvas, List<Offset> offsets, double radius,
      double stepLength, Paint paint) {
    var startDistance = 0.0;
    for (var i = 0; i < offsets.length; i++) {
      final o0 = offsets[i % offsets.length];
      final o1 = offsets[(i + 1) % offsets.length];
      final totalDistance = _dist(o0, o1);
      var distance = startDistance;
      while (distance < totalDistance) {
        final f1 = distance / totalDistance;
        final f0 = 1.0 - f1;
        final offset = Offset(o0.dx * f0 + o1.dx * f1, o0.dy * f0 + o1.dy * f1);
        canvas.drawCircle(offset, radius, paint);
        distance += stepLength;
      }
      startDistance = distance < totalDistance
          ? stepLength - (totalDistance - distance)
          : distance - totalDistance;
    }
    canvas.drawCircle(offsets.last, radius, paint);
  }

  void _paintLine(Canvas canvas, List<Offset> offsets, Paint paint) {
    if (offsets.isEmpty) {
      return;
    }
    final path = Path()..addPolygon(offsets, true);
    // print('페인트오프셋${offsets}');
    canvas.drawPath(path, paint);
  }

  void _paintPolygon(Canvas canvas, Rect rect) {
    final paint = Paint();

    if (null != polygonOpt.holeOffsetsList) {
      canvas.saveLayer(rect, paint);
      paint.style = PaintingStyle.fill;

      for (final offsets in polygonOpt.holeOffsetsList!) {
        final path = Path();
        path.addPolygon(offsets, true);
        canvas.drawPath(path, paint);
      }

      paint
        ..color = polygonOpt.color
        ..blendMode = BlendMode.dst;

      final path = Path();
      path.addPolygon(polygonOpt.offsets, true);
      canvas.drawPath(path, paint);

      _paintBorder(canvas);

      canvas.restore();
    } else {
      canvas.clipRect(rect);
      paint
        ..style =
            polygonOpt.isFilled ? PaintingStyle.fill : PaintingStyle.stroke
        ..color = polygonOpt.color;

      final path = Path();
      path.addPolygon(polygonOpt.offsets, true);

      canvas.drawPath(path, paint);
      _paintBorder(canvas);

      if (polygonOpt.label != null) {
        Label.paintText(
          canvas,
          polygonOpt.offsets,
          polygonOpt.label,
          polygonOpt.labelStyle,
          rotationRad,
          rotate: polygonOpt.rotateLabel,
          labelPlacement: polygonOpt.labelPlacement,
        );
      }
    }
  }

  @override
  bool shouldRepaint(PolygonPainter oldDelegate) => false;

  double _dist(Offset v, Offset w) {
    return sqrt(_dist2(v, w));
  }

  double _dist2(Offset v, Offset w) {
    return _sqr(v.dx - w.dx) + _sqr(v.dy - w.dy);
  }

  double _sqr(double x) {
    return x * x;
  }
}
