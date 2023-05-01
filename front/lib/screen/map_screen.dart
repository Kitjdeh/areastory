import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:front/component/map/customoverlay.dart';
import 'package:front/component/sns/article/article_detail.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geojson/geojson.dart';
import 'package:image_editor/image_editor.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async' show Future;
import 'dart:ui' as ui;
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg_provider;

String sangjunurl = 'https://source.unsplash.com/random/?party';
//     String seoul2url =
//     'C:\Users\SSAFY\Desktop\SeongDo\flutter\chool_check\asset\img\seoul2.jpg';
// String sugyeongurl =
//     'C:\Users\SSAFY\Desktop\SeongDo\flutter\chool_check\asset\img\sugyeong.jpg';
// String a302url =
//     'C:\Users\SSAFY\Desktop\SeongDo\flutter\chool_check\asset\img\a302.jpg';
// String suminurl =
//     'C:\Users\SSAFY\Desktop\SeongDo\flutter\chool_check\asset\img\sumin.jpg';
String seoul2url = 'https://source.unsplash.com/random/?cat';
String sugyeongurl = 'https://source.unsplash.com/random/?programming';
String a302url = 'https://source.unsplash.com/random/?dog';
String suminurl = 'https://source.unsplash.com/random/?food';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // latitud - 위도 , longitude - 경도
  static final LatLng companyLatLng = LatLng(37.5013, 127.0397);
  LatLng _imageLatLng = LatLng(37.5013, 127.0397);

  // cameraposition 우주에서 바라보는 카메라 포지션

  static final double distance = 1000;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: renderAppbar(),
        body: FutureBuilder(
            future: checkPermission(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.data == '위치 권한이 허가되었습니다.') {
                return Column(
                  children: [_CustomMap(), _ChoolCheckButton()],
                );
              }
              return Center(child: Text(snapshot.data));
            }));
  }

  AppBar renderAppbar() {
    return AppBar(
      title: Text(
        'AreaStory',
        style: TextStyle(color: Colors.blue[200], fontWeight: FontWeight.w700),
      ),
      backgroundColor: Colors.white,
    );
  }

  Future<String> checkPermission() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      return '위치 서비스를 활성화 해주세요';
    }
    LocationPermission checkedPermission = await Geolocator.checkPermission();

    if (checkedPermission == LocationPermission.denied) {
      checkedPermission = await Geolocator.requestPermission();

      if (checkedPermission == LocationPermission.denied) {
        return '위치 권한을 허가해주세요.';
      }
      if (checkedPermission == LocationPermission.deniedForever) {
        return '앱의 위치 권한을 세팅에서 허가해주세요';
      }
    }
    return '위치 권한이 허가되었습니다.';
  }
}

class _CustomMap extends StatefulWidget {
  _CustomMap({Key? key}) : super(key: key);

  @override
  State<_CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<_CustomMap> {
  // final Completer<GoogleMapController> _controller = Completer();
// Set<Polygon> _polygon = HashSet<Polygon>();
  MapController mapController = MapController();
  List<LatLng> points = [];
  List<LatLng> pointss = [];
  List<LatLng> pointsss = [];
  List<String> areaname = [];

  List<List<LatLng>> _polygon = [];
  List<List<LatLng>> layoutpolygon = [];
  List<String> urls = [];
  double _zoom = 6.0;
  var currentcenter = LatLng(37.60732175555233, 127.0710794642477);
  void minuszoom() {
    _zoom = mapController.zoom - 1;
    this.currentcenter = mapController.center;
    mapController.move(currentcenter, _zoom);
    print(_zoom);
    _zoom > 12.0
        ? _loadGeoJson('asset/map/minimal.json')
        : _zoom > 9.0
            ? _loadGeoJson('asset/map/sigungookorea.json')
            : _loadGeoJson('asset/map/ctp_korea.geojson');
  }

  void pluszoom() {
    _zoom = mapController.zoom + 1;
    this.currentcenter = mapController.center;
    mapController.move(currentcenter, _zoom);
    print(_zoom);
    _zoom > 12.0
        ? _loadGeoJson('asset/map/minimal.json')
        : _zoom > 9.0
            ? _loadGeoJson('asset/map/sigungookorea.json')
            : _loadGeoJson('asset/map/ctp_korea.geojson');
  }

  @override
  void initState() {
    super.initState();
    // _loadGeoJson('asset/map/korea.geojson');
    // _loadGeoJson('asset/map/seoul.geojson');
    _loadGeoJson('asset/map/ctp_korea.geojson');
  }

  Future<void> _loadGeoJson(String link) async {
    _polygon = [];
    layoutpolygon = [];
    // geojson을 정의한다.
    final geojson = GeoJson();
    // 준비된 geojson 파일을 불러온다.
    final data = await rootBundle.loadString(link);
    // geojson에 data를 집어 넣는다. (용량이 크니 비동기 처리)
    await geojson.parse(data);
    // 각 폴리곤 값의 pk로 사용할 데이터 로 cnt 사용(계속 증가시켜서 동일값 안나오게)
    int cnt = 0;
    // print('1111${geojson.features}');
    //features에 있는 list 값을 for문 순회
    for (final feature in geojson.features) {
      // feature.geometry.runtimeType !=GeoJsonMultiPolygon ? print(feature.geometry.runtimeType) : null ;
      // null 값을 대비하여 runtimetype 확인
      if (feature.geometry.runtimeType == GeoJsonMultiPolygon &&
          feature.properties != null) {
        // String A = feature.properties!['SIG_KOR_NM'];
        // final B = feature.properties;
        // 해당 geometry를 polygones로 정의(ex 종로구의 geometry추출(=GeoJsonMultiPolygon)
        final polygones = feature.geometry as GeoJsonMultiPolygon;
        // geometry(종로구)를 구성하는 polygon 호출 (=geojsonpolygon)
        for (final polygone in polygones.polygons) {
          // geojsonpolygon 의 geoSerie 추출 ( = GeoSeire)
          for (final point in polygone.geoSeries) {
            // 이제 GeoSeire에 있는 point 값들을 모으면 하나의 구의 area가 완성된다.
            List<LatLng> _polygonLatLong = [];
            for (final geoPoint in point.geoPoints) {
              _polygonLatLong
                  .add(LatLng(geoPoint.latitude, geoPoint.longitude));
              // points.add(LatLng(geoPoint.latitude, geoPoint.longitude));
            }
            _polygon.add(
              _polygonLatLong,
            );
            String urlStr = '';
            cnt % 5 == 0
                ? urlStr = sangjunurl
                : cnt % 5 == 1
                    ? urlStr = seoul2url
                    : cnt % 5 == 2
                        ? urlStr = sugyeongurl
                        : cnt % 5 == 3
                            ? urlStr = suminurl
                            : urlStr = a302url;
            urls.add(urlStr);
            cnt = cnt + 1;
          }
        }
      }
      ;
      if (feature.geometry.runtimeType == GeoJsonPolygon &&
          feature.properties != null) {
        // String A = feature.properties!['SIG_KOR_NM'];
        // final B = feature.properties;
        // 해당 geometry를 polygones로 정의(ex 종로구의 geometry추출(=GeoJsonMultiPolygon)
        final polygones = feature.geometry as GeoJsonPolygon;
        // geometry(종로구)를 구성하는 polygon 호출 (=geojsonpolygon)
        // for (final polygone in polygones.) {
        // geojsonpolygon 의 geoSerie 추출 ( = GeoSeire)
        for (final point in polygones.geoSeries) {
          // 이제 GeoSeire에 있는 point 값들을 모으면 하나의 구의 area가 완성된다.
          List<LatLng> _polygonLatLong = [];
          for (final geoPoint in point.geoPoints) {
            _polygonLatLong.add(LatLng(geoPoint.latitude, geoPoint.longitude));
            // points.add(LatLng(geoPoint.latitude, geoPoint.longitude));
          }

          cnt == 16 ? points = _polygonLatLong : null;
          _polygon.add(
            _polygonLatLong,
          );
          String urlStr = '';
          cnt % 5 == 0
              ? urlStr = sangjunurl
              : cnt % 5 == 1
                  ? urlStr = seoul2url
                  : cnt % 5 == 2
                      ? urlStr = sugyeongurl
                      : cnt % 5 == 3
                          ? urlStr = suminurl
                          : urlStr = a302url;
          urls.add(urlStr);
          cnt = cnt + 1;
        }
        // }
      }
      ;
    }
    layoutpolygon = _polygon;
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              maxZoom: 20,
              minZoom: 6,
              center: LatLng(37.60732175555233, 127.0710794642477),
              zoom: _zoom,
              interactiveFlags: InteractiveFlag.drag |
                  InteractiveFlag.doubleTapZoom |
                  InteractiveFlag.pinchZoom,
              onPositionChanged: (pos, hasGesture) {
                // 현재 보이는 화면의 경계를 계산
                final bounds = mapController.bounds!;
                final sw = bounds.southWest;
                final ne = bounds.northEast;
                // 화면 내에 있는 폴리곤만 필터링
                final visiblePolygons = _polygon.where((p) {
                  return p.any((point) {
                    return point.latitude >= sw!.latitude &&
                        point.latitude <= ne!.latitude &&
                        point.longitude >= sw.longitude &&
                        point.longitude <= ne!.longitude;
                  });
                }).toList();
                layoutpolygon = visiblePolygons;
              },
            ),

            // TileLayer(
            //   urlTemplate:
            //   "https://api.mapbox.com/styles/v1/kitjdeh/clgooh3g6003601q5bh4jc1u6/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoia2l0amRlaCIsImEiOiJjbGduZjRybTIwYTIxM3Bta2ZyNTFscXFoIn0.tq4mI6als9na84abG7RP5w",
            //   additionalOptions: {
            //     "access_token":
            //     "pk.eyJ1Ijoia2l0amRlaCIsImEiOiJjbGduZjRybTIwYTIxM3Bta2ZyNTFscXFoIn0.tq4mI6als9na84abG7RP5w",
            //     'id': 'mapbox.mapbox-traffic-v1'
            //   },
            //   // userAgentPackageName: 'com.example.app',
            // ),
            // children: [
            //   PolygonLayer(
            //       polygons: _polygon
            //           .map((e) => Polygon(
            //
            //         // image: AssetImage('asset/img/sangjun.PNG'),
            //         isFilled: false,
            //         points: e,
            //         // color: Colors.red,
            //         borderColor: Colors.red,
            //         borderStrokeWidth: 2.0,
            //       ))
            //           .toList(),
            //       // polygonCulling: ,
            //     ),
            // ],
            //
            children: _polygon.map((points) {
              final index = _polygon.indexOf(points);
              // final lastindex = _polygon.indexOf(_polygon.last);
              // LatLng(latitude:33.967342, longitude:126.284978)
              print(index);
              return GestureDetector(
                onTap: () {
                  print(index);
                },
                child: CustomPolygonLayer(
                  index: 1,
                  urls: [urls[index]],
                  polygons: [
                    Polygon(
                      isFilled: false,
                      borderColor: index % 2 == 0 ? Colors.black : Colors.blue,
                      points: points,
                      borderStrokeWidth: 3.0,
                    )
                  ],
                ),
              );
            }).toList(),
            // children: [
            //   CustomPolygonLayer(
            //       urls: urls,
            //       polygons: _polygon
            //           .map((e) => Polygon(
            //                 isFilled: false,
            //                 borderColor: Colors.black,
            //                 points: e,
            //                 // color: Colors.red,
            //                 borderStrokeWidth: 3.0,
            //               ))
            //           .toList()),
            // ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      FloatingActionButton(
                          onPressed: () {
                            pluszoom();
                          },
                          child: Text('+')),
                      FloatingActionButton(
                          onPressed: () {
                            minuszoom();
                          },
                          child: Text('-')),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChoolCheckButton extends StatelessWidget {
  const _ChoolCheckButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(child: Text('123')));
  }
}

// class MessageClipper extends CustomClipper<Path> {
//   final List<LatLng> polygons;
//   MessageClipper({required this.polygons});
//   @override
//   Path getClip(Size size) {
//     var path = Path();
//     polygons.map((e) => path.add(e));
//     // path.addAll(polygons);
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper oldClipper) {
//     return false;
//   }
// }
// Future<void> _drawPolygonWithImage() async {
//   final Uint8List imageBytes = await rootBundle.load('asset/img/sangjun.PNG');
//   final ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
//   final ui.Image image = (await codec.getNextFrame()).image;
//
//   final pictureRecorder = ui.PictureRecorder();
//   final canvas = Canvas(pictureRecorder);
//   drawPolygonWithImage(polygonCoordinates, image, canvas);
//   final picture = pictureRecorder.endRecording();
//   final img = await picture.toImage(image.width, image.height);
//   final bytes = await img.toByteData(format: ui.ImageByteFormat.png);
//   setState(() {
//     _polygonImage = bytes.buffer.asUint8List();
//   });
// }
