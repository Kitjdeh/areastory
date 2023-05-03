import 'dart:convert';

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
String seoul2url = 'https://source.unsplash.com/random/?cat';
String sugyeongurl = 'https://source.unsplash.com/random/?programming';
String a302url = 'https://source.unsplash.com/random/?dog';
String suminurl = 'https://source.unsplash.com/random/?food';
List<String> randomurl = [
  sangjunurl,
  seoul2url,
  sugyeongurl,
  a302url,
  suminurl
];

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
  MapController mapController = MapController();
  List<LatLng> points = [];
  List<String> arealist = [];
  Map<int, String> areadata = {};
  List<List<LatLng>> _polygon = [];
  List<List<LatLng>> layoutpolygon = [];
  List<List<LatLng>> bigpolygon = [];
  List<List<LatLng>> middlepolygon = [];
  List<List<LatLng>> smallpolygon = [];
  List<String> urls = [];
  List<Mapdata> allareaData = [];
  List<Mapdata> bigareaData = [];
  List<Mapdata> middleareaData = [];
  List<Mapdata> smallareaData = [];
  List<Mapdata> nowareadata = [];
  Mapdata? localareadata;
  double _zoom = 9.0;
  var currentcenter = LatLng(37.60732175555233, 127.0710794642477);
  void minuszoom() {
    _zoom = mapController.zoom - 1;
    this.currentcenter = mapController.center;
    mapController.move(currentcenter, _zoom);
    print(_zoom);
    setState(() {
      _zoom > 12.0
          ? nowareadata = smallareaData
          : _zoom > 9.0
              ? nowareadata = middleareaData
              : nowareadata = bigareaData;
    });
  }

  void pluszoom() {
    _zoom = mapController.zoom + 1;
    this.currentcenter = mapController.center;
    mapController.move(currentcenter, _zoom);
    print(_zoom);

    setState(() {
      _zoom > 12.0
          ? nowareadata = smallareaData
          : _zoom > 9.0
              ? nowareadata = middleareaData
              : nowareadata = bigareaData;
    });
  }

  @override
  void initState() {
    super.initState();
    // _loadGeoJson('asset/map/minimal.json');
    // _loadGeoJson('asset/map/sigungookorea.json');
    // _loadGeoJson('asset/map/ctp_korea.geojson');
    // nowareadata = bigareaData;
    // mapController.zoom > 12.0
    //     ? nowareadata = smallareaData
    //     : mapController.zoom > 9.0
    //     ? nowareadata = middleareaData
    //     : nowareadata = bigareaData;
  }

  Future<void> _loadGeoJson(String link) async {
    List<Mapdata> allareaData = [];
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
    //features에 있는 list 값을 for문 순회
    for (final feature in geojson.features) {
      // null 값을 대비하여 runtimetype 확인
      if (feature.geometry.runtimeType == GeoJsonMultiPolygon &&
          feature.properties != null) {
        String areaname;
        link == 'asset/map/minimal.json'
            ? areaname = feature.properties!['EMD_KOR_NM']
            : link == 'asset/map/ctp_korea.geojson'
                ? areaname = feature.properties!['CTP_KOR_NM']
                : areaname = feature.properties!['SIG_KOR_NM'];
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
            urls.add(sangjunurl);
            areadata[cnt] = areaname;
            localareadata = Mapdata(
                areaname: areaname,
                polygons: _polygonLatLong,
                urls: randomurl[cnt % 5]);
            localareadata != null ? allareaData.add(localareadata!) : null;
            cnt = cnt + 1;
          }
        }
      }
      ;
      if (feature.geometry.runtimeType == GeoJsonPolygon &&
          feature.properties != null) {
        final String areaname;
        link == 'asset/map/minimal.json'
            ? areaname = feature.properties!['EMD_KOR_NM']
            : link == 'asset/map/ctp_korea.geojson'
                ? areaname = feature.properties!['CTP_KOR_NM']
                : areaname = feature.properties!['SIG_KOR_NM'];
        // String A = feature.properties!['SIG_KOR_NM'];
        // final B = feature.properties;
        // 해당 geometry를 polygones로 정의(ex 종로구의 geometry추출(=GeoJsonMultiPolygon)
        final polygones = feature.geometry as GeoJsonPolygon;
        // geometry(종로구)를 구성하는 polygon 호출 (=geojsonpolygon)
        // geojsonpolygon 의 geoSerie 추출 ( = GeoSeire)
        for (final point in polygones.geoSeries) {
          // 이제 GeoSeire에 있는 point 값들을 모으면 하나의 구의 area가 완성된다.
          List<LatLng> _polygonLatLong = [];
          for (final geoPoint in point.geoPoints) {
            _polygonLatLong.add(LatLng(geoPoint.latitude, geoPoint.longitude));
          }
          cnt == 16 ? points = _polygonLatLong : null;
          _polygon.add(
            _polygonLatLong,
          );
          localareadata = Mapdata(
              areaname: areaname,
              polygons: _polygonLatLong,
              urls: randomurl[cnt % 5]);
          localareadata != null ? allareaData.add(localareadata!) : null;
          cnt = cnt + 1;
        }
      }
      ;
    }
    if (link == 'asset/map/ctp_korea.geojson') {
      bigareaData = allareaData;
      print('빅데이터 들어감');
    } else if (link == 'asset/map/sigungookorea.json') {
      middleareaData = allareaData;
      print('미들데이터 들어감');
    } else {
      smallareaData = allareaData;
      print('최소단위 들어감');
    }
    setState(() {});
    print('end${link}');
  }

  Widget build(BuildContext context) {
    // print(mapController.zoom);
    // mapController.zoom > 12.0
    //     ? nowareadata = smallareaData
    //     : mapController.zoom > 9.0
    //     ? nowareadata = middleareaData
    //     : nowareadata = bigareaData;
    List<Widget> customPolygonLayers = [];
    for (var mapdata in nowareadata) {
      customPolygonLayers.add(
        CustomPolygonLayer(
          index: 1,
          urls: [mapdata.urls ?? ''],
          area: mapdata.areaname ?? '',
          polygons: [
            Polygon(
              isFilled: false,
              borderColor: Colors.white30,
              points: mapdata.polygons!,
              borderStrokeWidth: 3.0,
            ),
          ],
        ),
      );
    }
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
              onMapReady: () async {
                print("1nowareadata.length${nowareadata.length}");
                await _loadGeoJson('asset/map/minimal.json');
                await _loadGeoJson('asset/map/sigungookorea.json');
                await _loadGeoJson('asset/map/ctp_korea.geojson');
                nowareadata = middleareaData;
                print("2nowareadata.length${nowareadata.length}");
                final bounds = mapController.bounds;
                final sw = bounds!.southWest;
                final ne = bounds!.northEast;
                // 화면 내에 있는 폴리곤만 필터링
                final visibleMapdata = nowareadata.where((p) {
                  return p.polygons!.any((point) {
                    return point.latitude >= sw!.latitude &&
                        point.latitude <= ne!.latitude &&
                        point.longitude >= sw.longitude &&
                        point.longitude <= ne!.longitude;
                  });
                }).toList();
                nowareadata = visibleMapdata;
                print("3nowareadata.length${nowareadata.length}");
              },
              onPositionChanged: (pos, hasGesture) {
                // print('before${nowareadata.length}');
                // 현재 보이는 화면의 경계를 계산
                final bounds = mapController.bounds!;
                final sw = bounds.southWest;
                final ne = bounds.northEast;
                // 화면 내에 있는 폴리곤만 필터링
                final visibleMapdata = nowareadata.where((p) {
                  return p.polygons!.any((point) {
                    return point.latitude >= sw!.latitude &&
                        point.latitude <= ne!.latitude &&
                        point.longitude >= sw.longitude &&
                        point.longitude <= ne!.longitude;
                  });
                }).toList();
                // print('after${nowareadata.length} ${visibleMapdata.length}');
                nowareadata = visibleMapdata;
              },
            ),
            children: [
              // PolygonLayer(
              //   polygons: bigareaData
              //       .map((e) => Polygon(
              //     // image: AssetImage('asset/img/sangjun.PNG'),
              //     isFilled: false,
              //     points: e.polygons!,
              //     // color: Colors.red,
              //     borderColor: Colors.red,
              //     borderStrokeWidth: 10.0,
              //   ))
              //       .toList(),
              //   // polygonCulling: ,
              // ),
              // PolylineLayer(
              //   polylines: bigareaData
              //       .map((e) => Polyline(
              //     points: e.polygons!,
              //     color: Colors.red,
              //   ))
              //       .toList(),
              // ),
              for (var mapdata in nowareadata)
                CustomPolygonLayer(
                  index: 1,
                  urls: [mapdata.urls ?? ''],
                  area: mapdata.areaname ?? '',
                  polygons: [
                    Polygon(
                      isFilled: false,
                      borderColor: Colors.white30,
                      points: mapdata.polygons!,
                      borderStrokeWidth: 2.0,
                    ),
                  ],
                ),
            ],
            // children: nowareadata.map((mapdata) {
            //   return CustomPolygonLayer(
            //       index: 1,
            //       urls: [mapdata.urls ?? ''],
            //       area: mapdata.areaname ?? '',
            //       polygons: [
            //         Polygon(
            //           isFilled: false,
            //           borderColor: Colors.white30,
            //           points: mapdata.polygons!,
            //           borderStrokeWidth: 3.0,
            //         )
            //       ]);
            // }).toList()
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

class Mapdata {
  final String? areaname;
  final List<LatLng>? polygons;
  final String? urls;

  Mapdata({
    this.areaname,
    this.polygons,
    this.urls,
  });
}
