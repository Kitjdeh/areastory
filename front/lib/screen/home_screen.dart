import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/constant/home_tabs.dart';
import 'package:front/controllers/bottom_nav_controller.dart';
import 'package:front/controllers/follow_screen_controller.dart';
import 'package:front/controllers/map_test_controller.dart';
import 'package:front/controllers/mypage_screen_controller.dart';
import 'package:front/screen/camera_screen.dart';
import 'package:front/screen/follow_screen.dart';
import 'package:front/screen/map_screen.dart';
import 'package:front/screen/mypage_screen.dart';
import 'package:front/screen/sns_screen.dart';
import 'package:geojson/geojson.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class HomeScreen extends GetView<BottomNavController> {
  HomeScreen({Key? key, required this.userId}) : super(key: key);
  final String userId;
  List<Mapdata> bigareaData = [];
  // 시,군, 구 단위 데이터 입력 리스트
  List<Mapdata> middleareaData = [];
  // 읍, 면, 동 단위 데이터 입력 리스트
  List<Mapdata> smallareaData = [];
  Map<String, String> areamap = {};
  final MapTempController _mapTempController = Get.put(MapTempController());
  final FollowController _followController = Get.put(FollowController());
  final MyPageController _mypageController = Get.put(MyPageController());

  Future<void> loadmapdata(String link) async {
    List<List<LatLng>> _polygon = [];
    // Map<String, String> areamap = {};
    int cnt = 0;
    Set<String> arealastletter = {};
    List<Mapdata> allareaData = [];
    _polygon = [];
    List<String> urls = [];
    Mapdata? localareadata;
    // geojson을 정의한다.
    final geojson = GeoJson();
    // 준비된 geojson 파일을 불러온다.
    final data = await rootBundle.loadString(link);
    // geojson에 data를 집어 넣는다. (용량이 크니 비동기 처리)
    await geojson.parse(data);
    // 각 폴리곤 값의 pk로 사용할 데이터 로 cnt 사용(계속 증가시켜서 동일값 안나오게)
    int num = 0;
    List<String> namelist = [];
    //features에 있는 list 값을 for문 순회
    for (final feature in geojson.features) {
      String areaname = '';
      String areanum;
      String dosi = "";
      String sigungu = "";
      String dongeupmyeon = "";
      String NM;
      Map<String, String> mapinfo = {};
      String keyname = '';
      if (link == 'asset/map/ctp_korea.geojson') {
        num += 1;
        dosi = feature.properties!['CTP_KOR_NM'];
        NM = feature.properties!['CTPRVN_CD'];
        areamap[NM] = dosi;
        print('areamap[${NM} ${areamap[NM]}]');
        mapinfo["dosi"] = dosi;
        areaname = dosi;
        keyname = dosi;
      } else if (link == 'asset/map/sigungookorea.json') {
        num += 1;
        NM = feature.properties!['SIG_CD'];
        String dosinm = NM.substring(0, 2);
        dosi = areamap[dosinm] ?? "";
        mapinfo["dosi"] = dosi;
        sigungu = feature.properties!['SIG_KOR_NM'];
        mapinfo["sigungu"] = sigungu;
        areamap[NM] = sigungu;
        print('areamap[${NM} ${areamap[NM]}]');
        areaname = '${dosi} ${sigungu}';
        keyname = sigungu;
        // num < 15 ? namelist.add(sigungu) : null;
        // print(areaname);
      } else {
        num += 1;
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
        print('areamap[${NM} ${areamap[NM]}]');
        areaname = '${dosi} ${sigungu} ${dongeupmyeon}';
        keyname = dongeupmyeon;
        num < 15 ? namelist.add(dongeupmyeon) : null;
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

            _polygon.add(_polygonLatLong);

            urls.add(sangjunurl);
            // String areakey = areanum.toString().padRight(10, '0');
            localareadata = Mapdata(
                mapinfo: mapinfo,
                keyname: keyname,
                fullname: areaname,
                polygons: _polygonLatLong,
                // urls: randomurl[cnt % 5]);
                urls: '');
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
          _polygon.add(
            _polygonLatLong,
          );
          localareadata = Mapdata(
              mapinfo: mapinfo,
              keyname: keyname,
              fullname: areaname,
              polygons: _polygonLatLong,
              // urls: randomurl[cnt % 5]);
              urls: '');
          localareadata != null ? allareaData.add(localareadata!) : null;
          cnt = cnt + 1;
        }
      }
      ;
    }

    if (link == 'asset/map/ctp_korea.geojson') {
      bigareaData = allareaData;
      print(bigareaData.length);
      print('빅데이터 들어감${num}');
    } else if (link == 'asset/map/sigungookorea.json') {
      middleareaData = allareaData;
      print(middleareaData.length);
      print('미들데이터 들어감${num}');
      // storage.write(key: "middleareaData", value: middleareaData);
    } else {
      smallareaData = allareaData;
      print(smallareaData.length);
      // print(namelist);
      print('최소단위 들어감${num}');
    }
  }

  Future<bool> fetchData() async {
    bool data = false;
    // await loadmapdata('asset/map/ctp_korea.geojson');
    // await loadmapdata('asset/map/sigungookorea.json');
    // await loadmapdata('asset/map/minimal.json');
    // Change to API call
    await _mapTempController.fetchData();
    await Future.delayed(Duration(milliseconds: 100), () {
      data = true;
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    /// willPopScore: 뒤로가기 이벤트 처리할때 사용한다.
    return FutureBuilder<Object>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return WillPopScope(
                child: Obx(
                  () => Scaffold(
                    body: SafeArea(
                      child: IndexedStack(
                        index: controller.pageIndex.value,
                        children: [
                          MapScreen(
                            bigareaData: bigareaData,
                            middleareaData: middleareaData,
                            smallareaData: smallareaData,
                          ),
                          Navigator(
                            key: controller.snsPageNavigationKey,
                            onGenerateRoute: (routeSetting) {
                              return MaterialPageRoute(
                                builder: (context) => SnsScreen(userId: userId),
                              );
                            },
                          ),
                          CameraScreen(userId: userId),
                          Navigator(
                            key: controller.followPageNavigationKey,
                            onGenerateRoute: (routeSetting) {
                              return MaterialPageRoute(
                                builder: (context) =>
                                    FollowScreen(userId: userId),
                              );
                            },
                          ),
                          Navigator(
                            key: controller.myPageNavigationKey,
                            onGenerateRoute: (routeSetting) {
                              return MaterialPageRoute(
                                builder: (context) =>
                                    MyPageScreen(userId: userId),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    bottomNavigationBar: BottomNavigationBar(
                      /// 바텀 내브바 css효과들 건드릴때 쓰십쇼
                      type: BottomNavigationBarType.fixed,
                      showUnselectedLabels: false,
                      showSelectedLabels: false,
                      elevation: 0,

                      /// 앞으로 어디선가 컨트롤러값을 변경시킬때는 쓰세요.
                      currentIndex: controller.pageIndex.value,
                      onTap: controller.changeBottomNav,
                      items: [
                        BottomNavigationBarItem(
                          icon: ImageData(IconsPath.mapOff),
                          activeIcon: ImageData(IconsPath.mapOn),
                          label: 'map',
                        ),
                        BottomNavigationBarItem(
                          icon: ImageData(IconsPath.articlesOff),
                          activeIcon: ImageData(IconsPath.articlesOn),
                          label: 'articles',
                        ),
                        BottomNavigationBarItem(
                          icon: ImageData(IconsPath.uploadOff),
                          label: 'upload',
                        ),
                        BottomNavigationBarItem(
                          icon: ImageData(IconsPath.followOff),
                          activeIcon: ImageData(IconsPath.followOn),
                          label: 'follow',
                        ),
                        BottomNavigationBarItem(
                          icon: ImageData(IconsPath.mypageOff),
                          activeIcon: ImageData(IconsPath.mypageOn),
                          label: 'mypage',
                        ),
                      ],
                    ),
                  ),
                ),
                onWillPop: controller.willPopAction);
          } else {
            return Center(
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('asset/img/login_logo.png'),
                        fit: BoxFit.cover),
                  ),
                  child: Scaffold(
                    body: Center(
                        child:
                            Image.asset('asset/img/splash/loadingphoto.gif')),
                    backgroundColor: Colors.white,
                  )),
            );
          }
        });
  }
}
