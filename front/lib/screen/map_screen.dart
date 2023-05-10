import 'dart:convert';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:front/api/map/mapdata.dart';
import 'package:front/component/map/customoverlay.dart';
import 'package:front/component/sns/article/article_detail.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geojson/geojson.dart';
import 'package:image_editor/image_editor.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async' show Future;
import 'dart:ui' as ui;
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg_provider;
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:permission_handler/permission_handler.dart';

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
                  // children: [_ChoolCheckButton()],
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
    await Permission.notification.request();
    PermissionStatus alarmstatus = await Permission.notification.status;
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
    if (alarmstatus != PermissionStatus.granted) {
    } else {}

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
  Map<String, String> areadata = {};
  List<List<LatLng>> _polygon = [];
  List<String> urls = [];

  List<Mapdata> allareaData = [];
  List<Mapdata> bigareaData = [];
  List<Mapdata> middleareaData = [];
  List<Mapdata> smallareaData = [];
  List<Mapdata> nowareadata = [];
  List<Mapdata> nowallareadata = [];
  Map<String, Mapdata> BigAreaData = {};
  Map<String, String> areamap = {};

  Mapdata? localareadata;
  double _zoom = 12.0;
  var currentcenter = LatLng(37.60732175555233, 127.0710794642477);
  void minuszoom() {
    _zoom = mapController.zoom - 1;
    this.currentcenter = mapController.center;
    mapController.move(currentcenter, _zoom);
    print(_zoom);
  }

  void pluszoom() {
    _zoom = mapController.zoom + 1;
    this.currentcenter = mapController.center;
    mapController.move(currentcenter, _zoom);
    print(_zoom);
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> loadexcel() async {
    ByteData data = await rootBundle.load('asset/map/areacode.xlsx');
    // print(data.buffer);
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
    // var row = excel.tables.values.first.rows.first;
    // var row = excel.tables.values.first.rows[2];
    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]!.rows) {
        String num = row[0]!.value.toString();
        String area = row[1]!.value.toString();
        areadata[num] = area;
      }
    }
  }

  Future<void> _loadGeoJson(String link) async {
    Set<String> arealastletter = {};
    List<Mapdata> allareaData = [];
    _polygon = [];
    // print(areadata.length);
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
      String areaname = '';
      String areanum;
      String dosi = "";
      String sigungu = "";
      String dongeupmyeon = "";
      String NM;
      List<String> fullname = [];
      Map<String, String> mapinfo = {};
      String keyname = '';
      if (link == 'asset/map/ctp_korea.geojson') {
        dosi = feature.properties!['CTP_KOR_NM'];
        NM = feature.properties!['CTPRVN_CD'];
        areamap[NM] = dosi;
        mapinfo["dosi"] = dosi;
        areaname = dosi;
        keyname = dosi;
      } else if (link == 'asset/map/sigungookorea.json') {
        NM = feature.properties!['SIG_CD'];
        String dosinm = NM.substring(0, 2);
        dosi = areamap[dosinm] ?? "";
        // print("dosinm${dosinm} dosi${dosi}");
        mapinfo["dosi"] = dosi;
        sigungu = feature.properties!['SIG_KOR_NM'];
        mapinfo["sigungu"] = sigungu;
        areamap[NM] = sigungu;
        areaname = dosi + sigungu;
        keyname = sigungu;
      } else {
        NM = feature.properties!['EMD_CD'];
        String dosinm = NM.substring(0, 2);
        String sigungunm = NM.substring(0, 5);
        dosi = areamap[dosinm] ?? "";
        sigungu = areamap[sigungunm] ?? "";
        mapinfo["dosi"] = dosi;
        mapinfo["sigungu"] = sigungu;
        dongeupmyeon = feature.properties!['EMD_KOR_NM'];
        mapinfo["dongeupmyeon"] = dongeupmyeon;
        areamap[NM] = dongeupmyeon;
        areaname = dosi + sigungu + dongeupmyeon;
        keyname = dongeupmyeon;
      }
      // null 값을 대비하여 runtimetype 확인
      if (feature.geometry.runtimeType == GeoJsonMultiPolygon &&
          feature.properties != null) {
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
            // String areakey = areanum.toString().padRight(10, '0');
            localareadata = Mapdata(
                mapinfo: mapinfo,
                keyname: keyname,
                fullname: areaname,
                polygons: _polygonLatLong,
                // urls: '');
                urls: randomurl[cnt % 5]);
            localareadata != null ? allareaData.add(localareadata!) : null;
            cnt = cnt + 1;
          }
        }
      }
      ;
      if (feature.geometry.runtimeType == GeoJsonPolygon &&
          feature.properties != null) {
        final polygones = feature.geometry as GeoJsonPolygon;
        // geometry(종로구)를 구성하는 polygon 호출 (=geojsonpolygon)
        // geojsonpolygon 의 geoSerie 추출 ( = GeoSeire)
        for (final point in polygones.geoSeries) {
          // 이제 GeoSeire에 있는 point 값들을 모으면 하나의 구의 area가 완성된다.
          List<LatLng> _polygonLatLong = [];
          for (final geoPoint in point.geoPoints) {
            _polygonLatLong.add(LatLng(geoPoint.latitude, geoPoint.longitude));
          }
          // cnt == 16 ? points = _polygonLatLong : null;
          _polygon.add(
            _polygonLatLong,
          );
          localareadata = Mapdata(
              mapinfo: mapinfo,
              keyname: keyname,
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
      print(bigareaData.first.mapinfo);
      // print("areamap${areamap}");
      print('빅데이터 들어감');
    } else if (link == 'asset/map/sigungookorea.json') {
      middleareaData = allareaData;
      print(middleareaData.first.mapinfo);
      print('미들데이터 들어감');
    } else {
      smallareaData = allareaData;
      print(smallareaData.first.mapinfo);
      print('최소단위 들어감');
    }
    setState(() {});
  }

  Widget build(BuildContext context) {
    List<Widget> customPolygonLayers = [];
    for (var mapdata in nowareadata) {
      customPolygonLayers.add(
        CustomPolygonLayer(
          index: 1,
          urls: [mapdata.urls ?? ''],
          area: mapdata.keyname ?? '',
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
              maxZoom: 18,
              minZoom: 6,
              center: LatLng(37.60732175555233, 127.0710794642477),
              zoom: _zoom,
              interactiveFlags: InteractiveFlag.drag |
                  InteractiveFlag.doubleTapZoom |
                  InteractiveFlag.pinchZoom,
              onMapReady: () async {
                // Map<String, AreaData> result;
                List<Map<String, String>> requestlist = [];
                // await loadexcel();
                await _loadGeoJson('asset/map/ctp_korea.geojson');
                await _loadGeoJson('asset/map/sigungookorea.json');
                await _loadGeoJson('asset/map/minimal.json');
                nowallareadata = middleareaData;
                print("2nowareadata.length${nowallareadata.length}");
                final bounds = mapController.bounds;
                final sw = bounds!.southWest;
                final ne = bounds!.northEast;
                // 화면 내에 있는 폴리곤만 필터링
                final visibleMapdata = nowallareadata.where((p) {
                  return p.polygons!.any((point) {
                    return point.latitude >= sw!.latitude &&
                        point.latitude <= ne!.latitude &&
                        point.longitude >= sw.longitude &&
                        point.longitude <= ne!.longitude;
                  });
                }).toList();
                // visibleMapdata.map((e) => requestlist.add(e.mapinfo!));
                await Future.forEach(visibleMapdata, (e) {
                  requestlist.add(e.mapinfo!);
                });
                print(requestlist);
                print(
                    "3nowareadata ${nowareadata.length} visibleMapdata${visibleMapdata.length}");
                print("requestlist${requestlist.length}");
                // Future<Map<String, AreaData>>result =
                //     await postAreaData(requestlist);
                Map<String, AreaData> result = await postAreaData(requestlist);
                await Future.forEach(visibleMapdata, (e) {
                  final areakey = e.keyname;
                  final url = result[areakey]!.image;
                  final userid = result[areakey]!.articleId;
                  e.urls = url;
                  e.articleId = userid ?? 0;
                });
                setState(() {
                  nowareadata = visibleMapdata;
                });
                visibleMapdata.map((e) => print("mapdata ${e.keyname}"));
              },
              onPositionChanged: (pos, hasGesture) async {
                print("mapController.zoom${mapController.zoom}");
                await _zoom > 13.0
                    ? nowallareadata = smallareaData
                    : _zoom > 9.0
                        ? nowallareadata = middleareaData
                        : nowallareadata = bigareaData;
                setState(() {
                  _zoom > 13.0
                      ? nowallareadata = smallareaData
                      : _zoom > 9.0
                          ? nowallareadata = middleareaData
                          : nowallareadata = bigareaData;
                });
                print('posistionchanged 작동함');
                List<Map<String, String>> requestlist = [];
                // print('nowallareadata${nowallareadata.length}');
                // 현재 보이는 화면의 경계를 계산
                final bounds = mapController.bounds!;
                final sw = bounds.southWest;
                final ne = bounds.northEast;
                // 화면 내에 있는 폴리곤만 필터링
                final visibleMapdata = nowallareadata.where((p) {
                  return p.polygons!.any((point) {
                    return point.latitude >= sw!.latitude &&
                        point.latitude <= ne!.latitude &&
                        point.longitude >= sw.longitude &&
                        point.longitude <= ne!.longitude;
                  });
                }).toList();
                // await visibleMapdata.map((e) => requestlist.add(e.mapinfo!));

                nowareadata = visibleMapdata;
                setState(() {
                  nowareadata = visibleMapdata;
                });
                await Future.forEach(visibleMapdata, (e) {
                  requestlist.add(e.mapinfo!);
                });
                var A = visibleMapdata.map((e) => e.mapinfo).toList();
                print(
                    "3nowareadata.length${nowareadata.length} visibleMapdata${visibleMapdata.length}");
              },
            ),
            children: [
              for (var mapdata in nowareadata)
                Opacity(
                  opacity: 0.8,
                  child: CustomPolygonLayer(
                    index: 1,
                    urls: [mapdata.urls ?? ''],
                    area: mapdata.keyname ?? '',
                    polygons: [
                      Polygon(
                        isFilled: false,
                        color: Colors.green,
                        borderColor: Colors.green,
                        points: mapdata.polygons!,
                        borderStrokeWidth: 3.0,
                      ),
                    ],
                  ),
                ),
              _zoom > 12
                  ? IgnorePointer(
                      child: PolylineLayer(
                          polylines: middleareaData
                              .map((e) => Polyline(
                                    borderStrokeWidth: 4.0,
                                    points: e.polygons!,
                                    borderColor: Colors.blue,
                                  ))
                              .toList()),
                    )
                  : IgnorePointer(
                      child: PolylineLayer(
                          polylines: bigareaData
                              .map((e) => Polyline(
                                    borderStrokeWidth: 4.0,
                                    points: e.polygons!,
                                    borderColor: Colors.red,
                                  ))
                              .toList()),
                    ),
            ],
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
  final String? keyname;
  final List<LatLng>? polygons;
  final String? urls;
  set urls(String? value) {
    _urls = value;
  }

  final Map<String, String>? mapinfo;
  final int? articleId;
  set articleId(int? value) {
    _articleId = value;
  }

  final String? fullname;
  // };
  Mapdata(
      {this.keyname,
      this.polygons,
      this.urls,
      this.mapinfo,
      this.articleId,
      this.fullname});
}

String? _urls;

int? _articleId;