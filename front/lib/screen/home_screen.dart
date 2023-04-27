import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:front/beamlocation/create_location.dart';
import 'package:front/beamlocation/follow_location.dart';
import 'package:front/beamlocation/map_location.dart';
import 'package:front/beamlocation/mypage_location.dart';
import 'package:front/beamlocation/sns_location.dart';
import 'package:front/constant/home_tabs.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;

  /// 바텀내브바에 들어가는 최초의 path들
  final _routerDelegates = [
    BeamerDelegate(
      initialPath: '/map',
      locationBuilder: (routeInformation, _) {
        if (routeInformation.location!.contains('/map')) {
          return MapLocation(routeInformation);
        }
        return NotFound(path: routeInformation.location!);
      },
    ),
    BeamerDelegate(
      initialPath: '/sns',
      locationBuilder: (routeInformation, _) {
        if (routeInformation.location!.contains('/sns')) {
          return SnsLocation(routeInformation);
        }
        return NotFound(path: routeInformation.location!);
      },
    ),
    BeamerDelegate(
      initialPath: '/create',
      locationBuilder: (routeInformation, _) {
        if (routeInformation.location!.contains('/create')) {
          return CreateLocation(routeInformation);
        }
        return NotFound(path: routeInformation.location!);
      },
    ),
    BeamerDelegate(
      initialPath: '/follow',
      locationBuilder: (routeInformation, _) {
        if (routeInformation.location!.contains('/follow')) {
          return FollowLocation(routeInformation);
        }
        return NotFound(path: routeInformation.location!);
      },
    ),
    BeamerDelegate(
      initialPath: '/mypage',
      locationBuilder: (routeInformation, _) {
        if (routeInformation.location!.contains('/mypage')) {
          return MypageLocation(routeInformation);
        }
        return NotFound(path: routeInformation.location!);
      },
    ),
  ];

  /// 선택된 탭을 표시할때 사용.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final uriString = Beamer.of(context).configuration.location!;
    _currentIndex = uriString.contains('/map') ? 0 : 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 인덱스 스택으로 각 루트페이지 최초 내부인덱스(0)으로 잡음
      body: IndexedStack(
        index: _currentIndex,
        children: [
          Beamer(
            routerDelegate: _routerDelegates[0],
          ),
          Beamer(
            routerDelegate: _routerDelegates[1],
          ),
          Beamer(
            routerDelegate: _routerDelegates[2],
          ),
          Beamer(
            routerDelegate: _routerDelegates[3],
          ),
          Beamer(
            routerDelegate: _routerDelegates[4],
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        /// 선택 유무 Icon 색깔 선정
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,

        /// bottomNavigationBar은 label이 필수다. 그래서 show를 안하겠다는 설정을 해야한다.
        showSelectedLabels: false,
        showUnselectedLabels: false,


        /// 전환시, 현재 인덱스가 아니라면 빌드하지 말아라 -> 데이터 날리지마라.
        onTap: (index) {
          if (index != _currentIndex) {
            print("인덱스가 서로 다르다.");
            setState(() => _currentIndex = index);
            _routerDelegates[_currentIndex].update(rebuild: false);
          }
          // else{
          //   print("인덱스가 서로 같다!");
          //   setState(() => _currentIndex = index);
          //   _routerDelegates[_currentIndex].update();
          // }
        },

        /// 바텀에 실제 표시되는 아이콘들.
        items: MAINTABS
            .map(
              (e) => BottomNavigationBarItem(
            icon: Icon(
              e.icon,
            ),
            label: e.label,
          ),
        )
            .toList(),
      ),
    );
  }
}