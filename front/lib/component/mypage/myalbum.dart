import 'package:flutter/material.dart';
import 'package:front/const/colors.dart';

class MyAlbum extends StatelessWidget {
  // 한번에 최대 몇개를 불러올 것인가? -> 끝에 도달시 계속 늘리는 방식?
  List<int> numbers = List.generate(10, (index) => index);

  MyAlbum({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: renderMaxExtent(),
    );
  }

  // 3
  // 최대 사이즈
  Widget renderMaxExtent() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        // 가로 크기 150으로 설정시 3개가 나온다.
        maxCrossAxisExtent: 150,
      ),
      // 아이템 빌더시 현재는 컬러랑 인덱스를 출력하는데 나중에는 이미지 리스트를 받아와야한다.
      itemBuilder: (context, index) {
        return renderContainer(
          color: rainbowColors[index % rainbowColors.length],
          index: index,
        );
      },
      // 내꺼 아이템의 총 개수.
      itemCount: 100,
    );
  }

  // 가로세로를 강제로 설정하는 방법을 모르겠습니다..?
  Widget renderContainer({
    required Color color,
    required int index,
    // double? height,
  }) {
    print(index);
    return Container(
      // height: height ?? 300,
      // width: 300,
      // height: 100,
      color: color,
      child: Center(
        child: Text(
          index.toString(),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 30.0,
          ),
        ),
      ),
    );
  }
}