import 'dart:convert';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:front/api/map/mapdata.dart';
import 'package:front/component/alarm/alarm_screen.dart';
import 'package:front/component/alarm/toast.dart';
import 'package:front/component/map/customoverlay.dart';
import 'package:front/component/sns/article/article_detail.dart';
import 'package:front/const/colors.dart';
import 'package:front/constant/home_tabs.dart';
import 'package:front/controllers/map_test_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geojson/geojson.dart';
import 'package:image_editor/image_editor.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async' show Future, Timer;
import 'dart:ui' as ui;
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg_provider;
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:permission_handler/permission_handler.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:get/get.dart';
import '../api/alarm/get_alarm.dart';

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
  MapScreen(
      {Key? key,
      required this.bigareaData,
      required this.middleareaData,
      required this.smallareaData})
      : super(key: key);
  final List<Mapdata> bigareaData;
  final List<Mapdata> middleareaData;
  final List<Mapdata> smallareaData;
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // latitud - 위도 , longitude - 경도
  static final LatLng companyLatLng = LatLng(37.5013, 127.0397);
  LatLng _imageLatLng = LatLng(37.5013, 127.0397);
  // cameraposition 우주에서 바라보는 카메라 포지션
  static final double distance = 1000;
  List<Mapdata> bigareaData = [];
  List<Mapdata> middleareaData = [];
  List<Mapdata> smallareaData = [];
  final MapTempController _mapTempController = Get.find<MapTempController>();

  @override
  void initState() {
    super.initState();
    // setState(() {
    //   bigareaData = widget.bigareaData;
    //   middleareaData = widget.middleareaData;
    //   smallareaData = widget.smallareaData;
    // });
  }

  void _getData() {}
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
                  children: [
                    Expanded(child: GetBuilder<MapTempController>(
                      builder: (controller) {
                        return Column(
                          children: [
                            _CustomMap(
                              bigareaData: _mapTempController.bigareaData,
                              middleareaData: _mapTempController.middleareaData,
                              smallareaData: _mapTempController.smallareaData,
                            ),
                          ],
                        );
                      },
                    ))
                    // Expanded(
                    //   child: _CustomMap(
                    //     bigareaData: bigareaData,
                    //     middleareaData: middleareaData,
                    //     smallareaData: smallareaData,
                    //   ),
                    // ),
                  ],
                  // children: [_ChoolCheckButton()],
                );
              }
              return Center(child: Text('위치권한이 없습니다.${snapshot.data}'));
            }));
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
  _CustomMap(
      {Key? key,
      required this.bigareaData,
      required this.middleareaData,
      required this.smallareaData})
      : super(key: key);
  final List<Mapdata> bigareaData;
  final List<Mapdata> middleareaData;
  final List<Mapdata> smallareaData;

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
  // 도,시 단위 데이터 입력 리스트
  // List<Mapdata> bigareaData = widget.bigareaData;
  // 시,군, 구 단위 데이터 입력 리스트
  // List<Mapdata> middleareaData = [];
  // // 읍, 면, 동 단위 데이터 입력 리스트
  // List<Mapdata> smallareaData = [];

  // 지도에 렌더 할 지역 데이터
  List<Mapdata> nowareadata = [];

  // small, miidle, big 중 가져다 쓸 틀
  List<Mapdata> nowallareadata = [];

  Map<String, Mapdata> BigAreaData = {};
  Map<String, String> areamap = {};
  Mapdata? localareadata;
  Position? mypoisition;
  LatLng? mylatlng;
  String? Strlocation;
  double _zoom = 11.0;
  int? userId;
  final storage = new FlutterSecureStorage();
  final LatLng companyLatLng = LatLng(37.5013, 127.0397);
  // Positionchange 후 작동하게 하여야함
  final updatepostionchange = Debouncer(Duration(seconds: 1),
      // onChanged: optimizepostion(),
      initialValue: null);
  final Duration debounceDuration = const Duration(seconds: 1);
  Timer? _debounce;

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

  void mycenter() async {
    mypoisition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    mylatlng = await LatLng(mypoisition!.latitude, mypoisition!.longitude);
    await mapController.move(mylatlng ?? companyLatLng, _zoom);
    print(_zoom);
    await Future.forEach(widget.smallareaData, (mapdata) {
      if (ifpolygoninside(mylatlng!, mapdata.polygons!)) {
        String result = mapdata.mapinfo!.values.join(' ');
        toast(context, "내위치: ${result}");
        Strlocation = result;
        storage.write(key: "userlocation", value: Strlocation);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // _loadMapadata();
    // print("지도에서 이닛스테이트가 돌아가요");
  }

  //initstate에 비동기 작업을 위해서 지도 작업 3개를 합친 future함수 생성
  Future<void> _loadMapadata() async {
    // await _loadGeoJson('asset/map/ctp_korea.geojson');
    // await _loadGeoJson('asset/map/sigungookorea.json');
    // await _loadGeoJson('asset/map/minimal.json');
  }
  //
  // Future<void> loadexcel() async {
  //   ByteData data = await rootBundle.load('asset/map/areacode.xlsx');
  //   var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  //   var excel = Excel.decodeBytes(bytes);
  //   // var row = excel.tables.values.first.rows.first;
  //   // var row = excel.tables.values.first.rows[2];
  //   for (var table in excel.tables.keys) {
  //     for (var row in excel.tables[table]!.rows) {
  //       String num = row[0]!.value.toString();
  //       String area = row[1]!.value.toString();
  //       areadata[num] = area;
  //     }
  //   }
  // }

  bool ifpolygoninside(LatLng points, List<LatLng> polygons) {
    int intersectCount = 0;
    for (int j = 0; j < polygons.length - 1; j++) {
      if (rayCastIntersect(points, polygons[j], polygons[j + 1])) {
        intersectCount++;
      }
    }
    return ((intersectCount % 2) == 1); // odd = inside, even = outside;
  }

  bool rayCastIntersect(LatLng tap, LatLng vertA, LatLng vertB) {
    double aY = vertA.latitude;
    double bY = vertB.latitude;
    double aX = vertA.longitude;
    double bX = vertB.longitude;
    double pY = tap.latitude;
    double pX = tap.longitude;

    if ((aY > pY && bY > pY) || (aY < pY && bY < pY) || (aX < pX && bX < pX)) {
      return false; // a and b can't both be above or below pt.y, and a or
      // b must be east of pt.x
    }

    double m = (aY - bY) / (aX - bX);
    double bee = (-aX) * m + aY;
    double x = (pY - bee) / m;
    return x > pX;
  }

  // void optimizepostion() async {
  //   print("mapController.zoom${mapController.zoom}");
  //   // await _zoom > 13.0
  //   //     ? nowallareadata = widget.smallareaData
  //   //     : _zoom > 9.0
  //   //         ? nowallareadata = widget.middleareaData
  //   //         : nowallareadata = widget.bigareaData;
  //   // setState(() {
  //   //   _zoom > 13.0
  //   //       ? nowallareadata = widget.smallareaData
  //   //       : _zoom > 9.0
  //   //           ? nowallareadata = widget.middleareaData
  //   //           : nowallareadata = widget.bigareaData;
  //   // });
  //
  //   print('posistionchanged 작동함');
  //   List<Map<String, String>> requestlist = [];
  //   // print('nowallareadata${nowallareadata.length}');
  //   // 현재 보이는 화면의 경계를 계산
  //   final bounds = mapController.bounds!;
  //   final sw = bounds.southWest;
  //   final ne = bounds.northEast;
  //   // 화면 내에 있는 폴리곤만 필터링
  //   final visibleMapdata = nowallareadata.where((p) {
  //     return p.polygons!.any((point) {
  //       return point.latitude >= sw!.latitude &&
  //           point.latitude <= ne!.latitude &&
  //           point.longitude >= sw.longitude &&
  //           point.longitude <= ne!.longitude;
  //     });
  //   }).toList();
  //   nowareadata = visibleMapdata;
  //   setState(() {
  //     nowareadata = visibleMapdata;
  //   });
  //   await Future.forEach(visibleMapdata, (e) {
  //     requestlist.add(e.mapinfo!);
  //   });
  //   var A = visibleMapdata.map((e) => e.mapinfo).toList();
  // }

  // Future<void> loadmapdata(String link) async {
  //   int cnt = 0;
  //   Set<String> arealastletter = {};
  //   List<Mapdata> allareaData = [];
  //   _polygon = [];
  //
  //   // geojson을 정의한다.
  //   final geojson = GeoJson();
  //   // 준비된 geojson 파일을 불러온다.
  //   final data = await rootBundle.loadString(link);
  //   // geojson에 data를 집어 넣는다. (용량이 크니 비동기 처리)
  //   await geojson.parse(data);
  //   // 각 폴리곤 값의 pk로 사용할 데이터 로 cnt 사용(계속 증가시켜서 동일값 안나오게)
  //   int num = 0;
  //   List<String> namelist = [];
  //   //features에 있는 list 값을 for문 순회
  //   for (final feature in geojson.features) {
  //     String areaname = '';
  //     String areanum;
  //     String dosi = "";
  //     String sigungu = "";
  //     String dongeupmyeon = "";
  //     String NM;
  //     Map<String, String> mapinfo = {};
  //     String keyname = '';
  //
  //     if (link == 'asset/map/ctp_korea.geojson') {
  //       num += 1;
  //       dosi = feature.properties!['CTP_KOR_NM'];
  //       NM = feature.properties!['CTPRVN_CD'];
  //       areamap[NM] = dosi;
  //       mapinfo["dosi"] = dosi;
  //       areaname = dosi;
  //       keyname = dosi;
  //     } else if (link == 'asset/map/sigungookorea.json') {
  //       num += 1;
  //       NM = feature.properties!['SIG_CD'];
  //       String dosinm = NM.substring(0, 2);
  //       dosi = areamap[dosinm] ?? "";
  //       mapinfo["dosi"] = dosi;
  //       sigungu = feature.properties!['SIG_KOR_NM'];
  //       mapinfo["sigungu"] = sigungu;
  //       areamap[NM] = sigungu;
  //       areaname = '${dosi} ${sigungu}';
  //       keyname = sigungu;
  //       // num < 15 ? namelist.add(sigungu) : null;
  //       // print(areaname);
  //     } else {
  //       num += 1;
  //       NM = feature.properties!['EMD_CD'];
  //       String dosinm = NM.substring(0, 2);
  //       String sigungunm = NM.substring(0, 5);
  //       dosi = areamap[dosinm] ?? "";
  //       sigungu = areamap[sigungunm] ?? "";
  //       mapinfo["dosi"] = dosi;
  //       mapinfo["sigungu"] = sigungu;
  //       dongeupmyeon = feature.properties!['EMD_KOR_NM'];
  //       mapinfo["dongeupmyeon"] = dongeupmyeon;
  //       areamap[NM] = dongeupmyeon;
  //       areaname = '${dosi} ${sigungu} ${dongeupmyeon}';
  //       keyname = dongeupmyeon;
  //       num < 15 ? namelist.add(dongeupmyeon) : null;
  //     }
  //     // null 값을 대비하여 runtimetype 확인
  //     if (feature.geometry.runtimeType == GeoJsonMultiPolygon &&
  //         feature.properties != null) {
  //       final polygones = feature.geometry as GeoJsonMultiPolygon;
  //       // geometry(종로구)를 구성하는 polygon 호출 (=geojsonpolygon)
  //       for (final polygone in polygones.polygons) {
  //         // geojsonpolygon 의 geoSerie 추출 ( = GeoSeire)
  //         for (final point in polygone.geoSeries) {
  //           // 이제 GeoSeire에 있는 point 값들을 모으면 하나의 구의 area가 완성된다.
  //           List<LatLng> _polygonLatLong = [];
  //           for (final geoPoint in point.geoPoints) {
  //             _polygonLatLong
  //                 .add(LatLng(geoPoint.latitude, geoPoint.longitude));
  //             // points.add(LatLng(geoPoint.latitude, geoPoint.longitude));
  //           }
  //
  //           _polygon.add(_polygonLatLong);
  //
  //           urls.add(sangjunurl);
  //           // String areakey = areanum.toString().padRight(10, '0');
  //           localareadata = Mapdata(
  //               mapinfo: mapinfo,
  //               keyname: keyname,
  //               fullname: areaname,
  //               polygons: _polygonLatLong,
  //               urls: randomurl[cnt % 5]);
  //           // urls: '');
  //           localareadata != null ? allareaData.add(localareadata!) : null;
  //           cnt = cnt + 1;
  //         }
  //       }
  //     }
  //     ;
  //     if (feature.geometry.runtimeType == GeoJsonPolygon &&
  //         feature.properties != null) {
  //       final polygones = feature.geometry as GeoJsonPolygon;
  //       // geometry(종로구)를 구성하는 polygon 호출 (=geojsonpolygon)
  //       // geojsonpolygon 의 geoSerie 추출 ( = GeoSeire)
  //       for (final point in polygones.geoSeries) {
  //         // 이제 GeoSeire에 있는 point 값들을 모으면 하나의 구의 area가 완성된다.
  //         List<LatLng> _polygonLatLong = [];
  //         for (final geoPoint in point.geoPoints) {
  //           _polygonLatLong.add(LatLng(geoPoint.latitude, geoPoint.longitude));
  //         }
  //         _polygon.add(
  //           _polygonLatLong,
  //         );
  //         localareadata = Mapdata(
  //             mapinfo: mapinfo,
  //             keyname: keyname,
  //             fullname: areaname,
  //             polygons: _polygonLatLong,
  //             urls: randomurl[cnt % 5]);
  //         // urls: '');
  //         localareadata != null ? allareaData.add(localareadata!) : null;
  //         cnt = cnt + 1;
  //       }
  //     }
  //     ;
  //   }
  //   if (link == 'asset/map/ctp_korea.geojson') {
  //     widget.bigareaData = allareaData;
  //     print(widget.bigareaData);
  //
  //     print('빅데이터 들어감${num}');
  //   } else if (link == 'asset/map/sigungookorea.json') {
  //     middleareaData = allareaData;
  //     print(middleareaData.length);
  //     print('미들데이터 들어감${num}');
  //   } else {
  //     smallareaData = allareaData;
  //     print(smallareaData.length);
  //     // print(namelist);
  //     print('최소단위 들어감${num}');
  //   }
  //   setState(() {});
  // }

  Widget build(BuildContext context) {
    List<Widget> customPolygonLayers = [];
    for (var mapdata in nowareadata) {
      // print(mapdata.fullname);
      customPolygonLayers.add(
        CustomPolygonLayer(
          entitle: true,
          userId: mapdata.articleId ?? 0,
          urls: [mapdata.urls ?? ''],
          area: mapdata.fullname ?? '',
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
      flex: 1,
      child: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              maxZoom: 18,
              minZoom: 6,
              center: mylatlng ?? LatLng(37.60732175555233, 127.0710794642477),
              zoom: _zoom,
              interactiveFlags: InteractiveFlag.drag |
                  InteractiveFlag.doubleTapZoom |
                  InteractiveFlag.pinchZoom,
              onMapReady: () async {
                final strUser = await storage.read(key: "userId");
                // await loadmapdata('asset/map/ctp_korea.geojson');
                // await loadmapdata('asset/map/sigungookorea.json');
                // await loadmapdata('asset/map/minimal.json');
                userId = int.parse(strUser!);
                // print('유저아이디!!!${userId}');
                mypoisition = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high);
                mylatlng =
                    await LatLng(mypoisition!.latitude, mypoisition!.longitude);
                List<Map<String, String>> requestlist = [];
                nowallareadata = widget.middleareaData;
                // Strlocation;
                // print('위치좌표mylatlng${mylatlng}');
                await Future.forEach(widget.smallareaData, (mapdata) {
                  if (ifpolygoninside(mylatlng!, mapdata.polygons!)) {
                    String result = mapdata.mapinfo!.values.join(' ');
                    Strlocation = result;
                    // toast(context, "내위치: ${result}");
                    // print('strloaction ${Strlocation}');
                  }
                  // print("현위치: ${mapdata.mapinfo!.values.join(' ')}");
                });
                await storage.write(key: "userlocation", value: Strlocation);
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
                setState(() {
                  nowareadata = visibleMapdata;
                });
                // visibleMapdata.map((e) => requestlist.add(e.mapinfo!));
                await Future.forEach(visibleMapdata, (e) {
                  requestlist.add(e.mapinfo!);
                });

                // Future<Map<String, AreaData>>result =
                // await postAreaData(requestlist);

                //--------post-----------
                Map<String, AreaData> result = await postAreaData(requestlist);
                List<Mapdata> newvisibleMapdata = [];
                // print('응답${result}');
                await Future.forEach(visibleMapdata, (e) {
                  final areakey = e.keyname;
                  final url =
                      result[areakey] == null ? e.urls : result[areakey]!.image;
                  final ariticleid = result[areakey]!.articleId ?? 0;
                  final mapinfo = e.mapinfo;
                  final fullname = e.fullname;
                  final keyname = e.keyname;
                  final polygons = e.polygons;
                  final newdata = Mapdata(
                      mapinfo: mapinfo,
                      fullname: fullname,
                      keyname: keyname,
                      polygons: polygons,
                      urls: url,
                      articleId: ariticleid);
                  newvisibleMapdata.add(newdata);
                });
                setState(() {
                  nowareadata = newvisibleMapdata;
                });

                //-----post----------
              },
              onPositionChanged: (pos, hasGesture) {
                if (_debounce?.isActive ?? false) {
                  _debounce!.cancel();
                } else {
                  _debounce = Timer(debounceDuration, () async {
                    // print(
                    //     "mapController.zoom${mapController.zoom} ${nowallareadata.length}");
                    // // nowallareadata = widget.smallareaData;
                    setState(() {
                      mapController.zoom > 13.0
                          ? nowallareadata = widget.smallareaData
                          : mapController.zoom > 9.0
                              ? nowallareadata = widget.middleareaData
                              : nowallareadata = widget.bigareaData;
                      print('setstatenowallareadata${nowallareadata.length}');
                    });
                    print('posistionchanged 작동함${nowallareadata.length}');
                    List<Map<String, String>> requestlist = [];
                    // print('nowallareadata${nowallareadata.length}');
                    // 현재 보이는 화면의 경계를 계산
                    final bounds = mapController.bounds!;
                    final ne = bounds.northEast;
                    final sw = bounds.southWest;
                    // 화면 내에 있는 폴리곤만 필터링
                    final visibleMapdata = nowallareadata.where((p) {
                      return p.polygons!.any((point) {
                        return point.latitude >= sw!.latitude &&
                            point.latitude <= ne!.latitude &&
                            point.longitude >= sw.longitude &&
                            point.longitude <= ne!.longitude;
                      });
                    }).toList();
                    nowareadata = visibleMapdata;

                    setState(() {
                      nowareadata = visibleMapdata;
                    });
                    await Future.forEach(visibleMapdata, (e) {
                      requestlist.add(e.mapinfo!);
                    });
                    // var A = visibleMapdata.map((e) => e.mapinfo).toList();

                    //----------------------------------post-----
                    Map<String, AreaData> result =
                        await postAreaData(requestlist);
                    List<Mapdata> newvisibleMapdata = [];
                    // print('result${result}');
                    await Future.forEach(visibleMapdata, (e) {
                      final areakey = e.keyname;
                      // print(
                      //     'resultareakey${result[areakey]!.image} e ${e} areakey${areakey}');
                      final url = result[areakey] == null
                          ? e.urls
                          : result[areakey]!.image;

                      final ariticleid = result[areakey]!.articleId ?? 0;
                      final mapinfo = e.mapinfo;
                      final fullname = e.fullname;
                      final keyname = e.keyname;
                      final polygons = e.polygons;
                      final newdata = Mapdata(
                          mapinfo: mapinfo,
                          fullname: fullname,
                          keyname: keyname,
                          polygons: polygons,
                          urls: url,
                          articleId: ariticleid);
                      newvisibleMapdata.add(newdata);
                    });
                    nowareadata = newvisibleMapdata;
                    setState(() {
                      nowareadata = newvisibleMapdata;
                    });
                    //--------------------post-------------
                  });
                }
              },
            ),
            children: [
              for (var mapdata in nowareadata)
                Opacity(
                  opacity: 0.8,
                  child: CustomPolygonLayer(
                    entitle: true,
                    userId: userId ?? 0,
                    articleId: mapdata.articleId ?? 0,
                    // articleId: [mapdata.articleId ?? 0 ],
                    urls: [mapdata.urls ?? ''],
                    area: mapdata.fullname ?? '',
                    polygons: [
                      Polygon(
                        isFilled: false,
                        color: PAINTNG,
                        borderColor: MAPBORDER,
                        points: mapdata.polygons!,
                        borderStrokeWidth: 3.0,
                      ),
                    ],
                  ),
                ),
              _zoom > 12
                  ? IgnorePointer(
                      child: PolylineLayer(
                          polylines: widget.middleareaData
                              .map((e) => Polyline(
                                    borderStrokeWidth: 5.0,
                                    points: e.polygons!,
                                    borderColor: BIGBORDER,
                                  ))
                              .toList()),
                    )
                  : IgnorePointer(
                      child: PolylineLayer(
                          polylines: widget.bigareaData
                              .map((e) => Polyline(
                                  borderStrokeWidth: 5.0,
                                  points: e.polygons!,
                                  borderColor: BIGBORDER,
                                  color: BIGBORDER))
                              .toList()),
                    ),
              IgnorePointer(
                child: CircleLayer(
                  circles: [
                    CircleMarker(
                        point: mylatlng ?? companyLatLng,
                        radius: 5.0,
                        color: Colors.red)
                  ],
                ),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          mycenter();
                        },
                        child: ImageData(
                          IconsPath.nowlocation,
                          width: 200,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          pluszoom();
                        },
                        child: ImageData(
                          IconsPath.zoomIn,
                          width: 150,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          minuszoom();
                        },
                        child: ImageData(
                          IconsPath.zoomOut,
                          width: 150,
                        ),
                      ),
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
