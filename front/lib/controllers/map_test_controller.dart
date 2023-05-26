import 'package:flutter/services.dart';
import 'package:front/screen/map_screen.dart';
import 'package:geojson/geojson.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapTempController extends GetxController {
  List<Mapdata> bigareaData = [];
  // 시,군, 구 단위 데이터 입력 리스트
  List<Mapdata> middleareaData = [];
  // 읍, 면, 동 단위 데이터 입력 리스트
  List<Mapdata> smallareaData = [];
  Map<String, String> areamap = {};

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
    await loadmapdata('asset/map/ctp_korea.geojson');
    await loadmapdata('asset/map/sigungookorea.json');
    await loadmapdata('asset/map/minimal.json');
    // Change to API call
    await Future.delayed(Duration(milliseconds: 100), () {
      data = true;
    });
    update();
    return data;
  }

}