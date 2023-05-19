import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front/api/follow/create_following.dart';
import 'package:front/api/follow/delete_following.dart';
import 'package:front/api/mypage/get_search.dart';
import 'package:front/constant/home_tabs.dart';
import 'package:front/controllers/bottom_nav_controller.dart';
import 'package:front/screen/mypage_screen.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _currentPage = 0;
  List<dynamic> _followers = [];
  bool nextPage = true; // 다음페이지를 불러올 수 있는가?
  bool _isLoading = false; // 로딩 중인지 여부
  final storage = new FlutterSecureStorage();
  String? myId;
  String? _word;
  Map<String, bool> followingStatusMap = {}; //팔로잉 버튼 와리가리


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // printSearching(int.parse(widget.userId), _currentPage, _word);
  }

  void setMyId() async {
    myId = await storage.read(key: "userId");
  }

  void printSearching() async {
    _followers.clear();
    myId = await storage.read(key: "userId");
    print("검색단어: $_word");
    final followerData = await getSearchUsers(userId: int.parse(myId!), page:0, search: _word);
    setState(() {
      _currentPage = 0;
      _followers.addAll(followerData.followers);
      followerData.followers.forEach((user) {
        followingStatusMap[user.userId.toString()] = user.check;
      });
    });
    print("최초의 유저검색 요청했습니다.");
  }

  void getsearchusers() async {
    if (_isLoading) return; // 이미 로딩 중인 경우 중복 요청 방지
    ++_currentPage;
    final followerData = await getSearchUsers(userId: int.parse(myId!), page:_currentPage, search: _word);
    setState(() {
      _followers.addAll(followerData.followers);
      nextPage = followerData.nextPage;
      _isLoading = false; // 로딩 완료 상태로 설정
      followerData.followers.forEach((user) {
        followingStatusMap[user.userId.toString()] = user.check;
      });
    });
    print("유저검색 목록 요청했습니다");
  }

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
            // Get.find<BottomNavController>().willPopAction();
            Navigator.pop(context, true);
          },
        ),
        titleSpacing: 0,
        title: Container(
          margin: const EdgeInsets.only(right: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: const Color(0xffefefef),
          ),
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "검색",
              contentPadding: EdgeInsets.only(left: 15, top: 7, bottom: 7),
              isDense: true,
            ),
            onChanged: (value){
              setState(() {
                _word = value;
              });
            },
            onSubmitted: (value) => printSearching()
          ),
        ),
      ),
      body: renderSeparated(),
    );
  }

  Widget renderSeparated() {
    /// 받아온 목록이 없다면 없다고 표시할것.
    if (_followers.length == 0) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("검색결과가")],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("없습니다")],
            ),
          ],
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification is ScrollEndNotification) {
            final double scrollPosition = notification.metrics.pixels;
            final double maxScrollExtent = notification.metrics.maxScrollExtent;
            final double triggerThreshold = 400.0; // 일정 높이

            if (scrollPosition > maxScrollExtent - triggerThreshold && nextPage && !_isLoading) {
              getsearchusers();
            }
          }
          return false;
        },
        child: Stack(
          // return Stack(
            children: [
              ListView.separated(
                itemCount: _followers.length,
                itemBuilder: (context, index) {
                  return renderContainer(
                    userId: _followers[index].userId.toString(),
                    image: _followers[index].profile.toString(),
                    nickname: _followers[index].nickname,
                    check: _followers[index].check,
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 30,
                  );
                },
              ),
              ///요청 때릴때 로딩
              if (_isLoading)
                Center(
                  child: CircularProgressIndicator(),
                )
            ]
        ));
  }

  Widget renderContainer({
    double? height,
    required String userId,
    required String image,
    required String nickname,
    required bool check,
  }) {
    return Container(
        height: MediaQuery.of(context).size.width*0.14,
        child: Container(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// 프로필 사진
                /// 컨테이너는 넓이, 높이 설정안하면 -> 자동으로 최대크기
                /// sizedbox는 하나라도 설정안하면 -> 자동으로 child의 최대크기
                Expanded(
                  flex: 7,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyPageScreen(userId: userId)));
                    },
                    child: Row(
                        children: [Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          width: MediaQuery.of(context).size.width*0.14,
                          height: MediaQuery.of(context).size.width*0.14,

                          /// ClipRRect: R이 2개다. 그리고 강제로 차일드의 모양을 강제로 잡아주는 용도.
                          child: ClipRRect(
                            /// 가장 완벽한 원을 만드는 방법은 상위가 되었든 뭐든, 높이길이의 50%(높이=넓이)
                            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.1),
                            // child: Image.asset(
                            //   'asset/img/test01.jpg',
                            //   fit: BoxFit.cover,
                            // ),
                            child: Image.network(
                              image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                          Expanded(
                            child: Container(
                              child: Text(
                                nickname,
                                overflow: TextOverflow.ellipsis, // 글자가 너무 길 경우 생략되도록 설정
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ]
                    ),
                  ),
                ),



                /// 버튼은 분기처리해야함.(팔로잉 해제)
                if (myId == widget.userId)
                  Container(
                    // padding: EdgeInsets.symmetric(horizontal: 20),
                    child: IconButton(
                        onPressed: () {
                          print("팔로워 상태 변경합니다.");
                          if (followingStatusMap[userId] == true) {
                            print("팔로잉 취소합니다. userId: $userId");
                            deleteFollowing(followingId: int.parse(userId));
                          }else{
                            print("팔로잉 신청합니다. userId: $userId");
                            postFollowing(followingId: int.parse(userId));
                          }
                          setState(() {
                            followingStatusMap[userId] = !followingStatusMap[userId]!;
                          });
                        },
                        icon: followingStatusMap[userId] == false
                            ? Icon(Icons.group_add)
                            : Icon(Icons.group_remove)
                    ),
                  ),
              ]),
        ));
  }
}
