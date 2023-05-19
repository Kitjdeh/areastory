import 'package:flutter/material.dart';
import 'package:front/controllers/bottom_nav_controller.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<int> numbers = List.generate(100, (index) => index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          /// 뒤로가기버튼설정
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          color: Colors.black,
          onPressed: () {
            Get.find<BottomNavController>().willPopAction();
          },
        ),
        titleSpacing: 0,
        title: Container(
          margin: const EdgeInsets.only(right: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: const Color(0xffefefef),
          ),
          child: const TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "검색",
              contentPadding: EdgeInsets.only(left: 15, top: 7, bottom: 7),
              isDense: true,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: renderSeparated(),
      ),
    );
  }

  Widget renderSeparated() {
    return ListView.separated(
      itemCount: 100,
      itemBuilder: (context, index) {
        return renderContainer();
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 10,
        );
      },
    );
  }

  Widget renderContainer({
    double? height,
  }) {
    return Container(
        height: height ?? 70,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// 프로필 사진
              /// 컨테이너는 넓이, 높이 설정안하면 -> 자동으로 최대크기
              /// sizedbox는 하나라도 설정안하면 -> 자동으로 child의 최대크기
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                width: 70,
                height: 70,

                /// ClipRRect: R이 2개다. 그리고 강제로 차일드의 모양을 강제로 잡아주는 용도.
                child: ClipRRect(
                  /// 가장 완벽한 원을 만드는 방법은 상위가 되었든 뭐든, 높이길이의 50%(높이=넓이)
                  borderRadius: BorderRadius.circular(35),
                  child: Image.asset(
                    'asset/img/test01.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Text(
                    "유저 닉네임",
                    overflow: TextOverflow.ellipsis, // 글자가 너무 길 경우 생략되도록 설정
                  ),
                ),
              ),

              /// 버튼은 분기처리해야함.(팔로워 해제)
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: IconButton(
                    onPressed: () {}, icon: Icon(Icons.restore_from_trash)),
              )

              /// 팔로워 신청
              // IconButton(onPressed: (){}, icon: Icon(Icons.restore_from_trash))
            ],
          ),
        ));
  }
}
