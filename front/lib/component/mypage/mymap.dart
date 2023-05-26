import 'dart:async';

import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front/api/map/mapdata.dart';
import 'package:front/component/map/customoverlay.dart';
import 'package:front/const/colors.dart';
import 'package:front/const/colors.dart';
import 'package:front/constant/home_tabs.dart';
import 'package:front/screen/map_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MyMap extends StatefulWidget {
  MyMap(
      {Key? key,
        required this.userId,
      required this.bigareaData,
      required this.middleareaData,
      required this.smallareaData})
      : super(key: key);
  final List<Mapdata> bigareaData;
  final List<Mapdata> middleareaData;
  final List<Mapdata> smallareaData;
  final String userId;
  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  MapController mymapController = MapController();
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
  double _zoom = 10.0;
  int? intuserId;
  String? strUser;
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
    _zoom = mymapController.zoom - 1;
    this.currentcenter = mymapController.center;
    mymapController.move(currentcenter, _zoom);
    print(_zoom);
  }

  void pluszoom() {
    _zoom = mymapController.zoom + 1;
    this.currentcenter = mymapController.center;
    mymapController.move(currentcenter, _zoom);
    print(_zoom);
  }

  void mycenter() async {
    mypoisition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    mylatlng = await LatLng(mypoisition!.latitude, mypoisition!.longitude);
    await mymapController.move(mylatlng ?? companyLatLng, _zoom);
    print(_zoom);
    // await Future.forEach(widget.smallareaData, (mapdata) {
    //   if (ifpolygoninsdie(mylatlng!, mapdata.polygons!)) {
    //     String result = mapdata.mapinfo!.values.join(' ');
    //     Strlocation = result;
    //   }
    // });
  }

  @override
  void initState() {
    super.initState();
    _loadUseradata();
  }

  void _loadUseradata() async {
    strUser = await storage.read(key: "userId");

    setState(() {
      // strUser = strUser;
      intuserId = int.parse(widget.userId);
    });
  }

  bool ifpolygoninsdie(LatLng points, List<LatLng> polygons) {
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
  //   await mapController.zoom > 13.0
  //       ? nowallareadata = widget.smallareaData
  //       : mapController.zoom > 9.0
  //           ? nowallareadata = widget.middleareaData
  //           : nowallareadata = widget.bigareaData;
  //   setState(() {
  //     mapController.zoom > 13.0
  //         ? nowallareadata = widget.smallareaData
  //         : mapController.zoom > 9.0
  //             ? nowallareadata = widget.middleareaData
  //             : nowallareadata = widget.bigareaData;
  //   });
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
  //   // var A = visibleMapdata.map((e) => e.mapinfo).toList();
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
              isFilled: true,
              color: MYPAINTNG,
              borderColor: MYMAPBORDER,
              points: mapdata.polygons!,
              borderStrokeWidth: 3.0,
            ),
          ],
        ),
      );
    }
    // print('widget.bigareaData.length${widget.bigareaData.length}');
    return Expanded(
      flex: 1,
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: FlutterMap(
                  mapController: mymapController,
                  options: MapOptions(
                    maxZoom: 18,
                    minZoom: 6,
                    center: mylatlng ??
                        LatLng(37.60732175555233, 127.0710794642477),
                    zoom: _zoom,
                    interactiveFlags: InteractiveFlag.drag |
                        InteractiveFlag.doubleTapZoom |
                        InteractiveFlag.pinchZoom,
                    onMapReady: () async {
                      // await loadmapdata('asset/map/ctp_korea.geojson');
                      // await loadmapdata('asset/map/sigungookorea.json');
                      // await loadmapdata('asset/map/minimal.json');
                      // print('유저아이디!!!${userId}');
                      mypoisition = await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high);
                      mylatlng = await LatLng(
                          mypoisition!.latitude, mypoisition!.longitude);
                      List<Map<String, String>> requestlist = [];
                      nowallareadata = widget.middleareaData;
                      // Strlocation;
                      // await Future.forEach(widget.smallareaData, (mapdata) {
                      //   if (ifpolygoninsdie(mylatlng!, mapdata.polygons!)) {
                      //     String result = mapdata.mapinfo!.values.join(' ');
                      //     // toast(context, "내위치: ${result}");
                      //     Strlocation = result;
                      //   }
                      // });
                      // await storage.write(key: "userlocation", value: Strlocation);
                      final bounds = mymapController.bounds;
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
                      Map<String, AreaData> result =
                          await postmyAreaData(requestlist, strUser ?? '');
                      print('strUser${strUser}');
                      List<Mapdata> newvisibleMapdata = [];
                      // print('응답${result}');
                      await Future.forEach(visibleMapdata, (e) {
                        final areakey = e.keyname;
                        final url = result[areakey] == null
                            ? ''
                            : result[areakey]!.image;
                        final ariticleid = result[areakey] == null
                            ? 0
                            : result[areakey]!.articleId;
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
                      nowareadata = newvisibleMapdata;

                      //-----post----------
                    },
                    onPositionChanged: (pos, hasGesture) {
                      // setState(() {
                      //
                      // });
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      _debounce = Timer(debounceDuration, () async {
                        // _zoom = mapController.zoom;
                        // print("mapController.zoom${mapController.zoom}");
                        // nowallareadata = widget.smallareaData;
                        setState(() {
                          mymapController.zoom > 13.0
                              ? nowallareadata = widget.smallareaData
                              : mymapController.zoom > 9.0
                                  ? nowallareadata = widget.middleareaData
                                  : nowallareadata = widget.bigareaData;
                          // print('setstatenowallareadata${nowallareadata.length}');
                        });

                        print('posistionchanged 작동함${mymapController.zoom}');

                        List<Map<String, String>> requestlist = [];
                        // 현재 보이는 화면의 경계를 계산
                        final bounds = mymapController.bounds!;
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
                        //----------------------------------post-----
                        Map<String, AreaData> result =
                            await postmyAreaData(requestlist, strUser ?? '');

                        List<Mapdata> newvisibleMapdata = [];
                        // print('result${result}');
                        await Future.forEach(visibleMapdata, (e) {
                          final areakey = e.keyname;
                          // print(
                          //     'resultareakey${result[areakey]!.image} e ${e} areakey${areakey}');
                          final url = result[areakey] == null
                              ? ''
                              : result[areakey]!.image;
                          final ariticleid = result[areakey] == null
                              ? 0
                              : result[areakey]!.articleId;
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
                        nowareadata = newvisibleMapdata;
                        //--------------------post-------------
                      });
                    },
                  ),
                  children: [
                    for (var mapdata in nowareadata)
                      Opacity(
                        opacity: 0.8,
                        child: CustomPolygonLayer(
                          entitle: false,
                          userId: intuserId ?? 0,
                          articleId: mapdata.articleId ?? 0,
                          // articleId: [mapdata.articleId ?? 0 ],
                          urls: [mapdata.urls ?? ''],
                          area: mapdata.fullname ?? '',
                          polygons: [
                            Polygon(
                              isFilled: false,
                              color: MYMAPBORDER,
                              borderColor: MYMAPBORDER,
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
                                        borderColor: MYBIGBORDER,
                                        color: MYBIGBORDER))
                                    .toList()),
                          )
                        : IgnorePointer(
                            child: PolylineLayer(
                                polylines: widget.bigareaData
                                    .map((e) => Polyline(
                                        borderStrokeWidth: 5.0,
                                        points: e.polygons!,
                                        borderColor: MYBIGBORDER,
                                        color: MYBIGBORDER))
                                    .toList()),
                          ),
                    // IgnorePointer(
                    //   child: CircleLayer(
                    //     circles: [
                    //       CircleMarker(
                    //           point: mylatlng ?? companyLatLng,
                    //           radius: 5.0,
                    //           color: Colors.blueAccent)
                    //     ],
                    //   ),
                    // )
                  ],
                ),
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
