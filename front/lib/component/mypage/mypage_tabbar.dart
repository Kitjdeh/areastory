import 'package:flutter/material.dart';
import 'package:front/component/mypage/myalbum.dart';
import 'package:front/component/mypage/mymap.dart';
import 'package:front/constant/home_tabs.dart';
import 'package:front/constant/mypage_tabs.dart';
import 'package:front/controllers/map_test_controller.dart';
import 'package:front/screen/map_screen.dart';
import 'package:get/get.dart';

class MypageTabbar extends StatefulWidget {
  MypageTabbar({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<MypageTabbar> createState() => _MypageTabbarState();
}

class _MypageTabbarState extends State<MypageTabbar>
    with TickerProviderStateMixin {
  late TabController mypagecontroller;
  int _currentIndex = 0;
  final MapTempController _mapTempController = Get.find<MapTempController>();
  List<Mapdata> bigareaData = [];
  List<Mapdata> middleareaData = [];
  List<Mapdata> smallareaData = [];

  @override
  void initState() {
    super.initState();

    mypagecontroller = TabController(length: 2, vsync: this);
    bigareaData = _mapTempController.bigareaData;
    middleareaData = _mapTempController.middleareaData;
    smallareaData = _mapTempController.smallareaData;
    // 이건 나중에 데이터 작업할때
    mypagecontroller.addListener(() {
      setState(() {
        _currentIndex = mypagecontroller.index;
      });
    });

    setState(() {
      bigareaData = _mapTempController.bigareaData;
      middleareaData = _mapTempController.middleareaData;
      smallareaData = _mapTempController.smallareaData;
    });
  }

  @override
  void dispose() {
    mypagecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Column(
          children: [
            TabBar(
                controller: mypagecontroller,
                indicatorColor: Colors.black,
                indicatorWeight: 1,
                tabs: [
                  Tab(
                    icon: _currentIndex == 0
                        ? ImageData(IconsPath.albumOn)
                        : ImageData(IconsPath.albumOff),
                  ),
                  Tab(
                    icon: _currentIndex == 1
                        ? ImageData(IconsPath.mapOn)
                        : ImageData(IconsPath.mapOff),
                  ),
                ]),
            Expanded(
              child: TabBarView(
                  controller: mypagecontroller,
                  physics: NeverScrollableScrollPhysics(), // 슬라이드 이동 비활성화
                  children: [
                    MyAlbum(userId: widget.userId),
                    bigareaData.length > 0
                        ? Column(
                          children:[ MyMap(
                            userId:widget.userId,
                            bigareaData: bigareaData,
                            middleareaData: middleareaData,
                            smallareaData: smallareaData,
                          ),]
                        )
                        : CircularProgressIndicator()
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
