import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front/api/follow/create_following.dart';
import 'package:front/api/follow/delete_following.dart';
import 'package:front/api/mypage/get_following.dart';
import 'package:front/constant/home_tabs.dart';
import 'package:front/screen/mypage_screen.dart';

class FollowingListScreen extends StatefulWidget {
  FollowingListScreen({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<FollowingListScreen> createState() => _FollowingListScreenState();
}

class _FollowingListScreenState extends State<FollowingListScreen> {
  // final List<int> numbers = List.generate(100, (index) => index);
  // List<String> filters = ['팔로잉 최신순', '팔로잉 오래된순', '팔로잉 이름순']; // 예시 필터 목록
  List<String> filters = ['팔로잉 이름순', '팔로잉 최신순', '팔로잉 오래된순']; // 예시 필터 목록
  String selectedFilter = '팔로잉 이름순'; // 초기 선택된 필터
  int _filterIndex = 0;
  int _currentPage = 0;
  List<dynamic> _followings = [];
  bool nextPage = true; // 다음페이지를 불러올 수 있는가?
  bool _isLoading = false; // 로딩 중인지 여부
  Map<String, bool> followStatusMap = {}; //팔로잉 버튼 와리가리
  final storage = new FlutterSecureStorage();
  String? myId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    printFollowings(int.parse(widget.userId), _currentPage, _filterIndex);
  }

  void setMyId() async {
    myId = await storage.read(key: "userId");
  }

  void printFollowings(userId, page, type) async {
    _followings.clear();
    myId = await storage.read(key: "userId");

    final followingData = await getUserFollowings(userId: userId, page:page, type: type);
    setState(() {
      _currentPage = 0;
      _followings.addAll(followingData.followings);
      followingData.followings.forEach((user) {
        followStatusMap[user.userId.toString()] = false;
      });
    });
    print("최초의 팔로잉목록 요청했습니다.");
  }

  void getuserfollowings(userId) async {
    if (_isLoading) return; // 이미 로딩 중인 경우 중복 요청 방지
    ++_currentPage;
    final followingData = await getUserFollowings(userId: userId,page: _currentPage,  type: _filterIndex);
    setState(() {
      _followings.addAll(followingData.followings);
      nextPage = followingData.nextPage;
      _isLoading = false; // 로딩 완료 상태로 설정
      followingData.followings.forEach((user) {
        followStatusMap[user.userId.toString()] = false;
      });
    });
    print("팔로잉 목록 요청했습니다");
  }


  void showFilterList() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.separated(
          shrinkWrap: true, // 내용에 맞게 크기 조절
          physics: NeverScrollableScrollPhysics(), // 스크롤 비활성화
          itemCount: filters.length,
          itemBuilder: (context, index) {
            final filter = filters[index];
            return RadioListTile(
              title: Text(filter),
              value: filter,
              groupValue: selectedFilter,
              onChanged: (value) {
                setState(() {
                  selectedFilter = value.toString(); // 선택한 필터 업데이트
                  _filterIndex = index;
                });
                /// 선택한 필터를 사용하여 데이터 요청하는 메서드 호출
                // printFollowings(); 를 실행한다.
                printFollowings(int.parse(widget.userId), 0, index);
                Navigator.pop(context); // 필터 목록 닫기

              },
              controlAffinity: ListTileControlAffinity.trailing, // 라디오 버튼을 오른쪽에 배치
            );
          },
          separatorBuilder: (context, index) => SizedBox.shrink(), // 빈 SizedBox로 설정하여 구분선 제거
        );
      },
    );
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white, //앱 바의 배경색을 흰색으로 설정
        title: Text(
            "정렬 기준 : $selectedFilter",
          style: TextStyle(color: Colors.black, fontSize: 15), // 글자색을 검정으로 설정
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: showFilterList,
            color: Colors.black, // 아이콘 색상을 검정으로 설정
          ),
        ],
      ),
      body: renderSeparated(),
    );
  }

  Widget renderSeparated() {
    /// 받아온 목록이 없다면 없다고 표시할것.
    if (_followings.length == 0) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("팔로잉한 사람이")],
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
            getuserfollowings(int.parse(widget.userId));
          }
        }
        return false;
      },
      child: Stack(

    // return Stack(
      children: [
        ListView.separated(
          itemCount: _followings.length,
        itemBuilder: (context, index) {
          return renderContainer(
            userId: _followings[index].userId.toString(),
            image: _followings[index].profile.toString(),
            nickname: _followings[index].nickname,
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
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: IconButton(
                  onPressed: () {
                    print("팔로잉 상태 변경합니다.");
                    if (followStatusMap[userId] == false) {
                      print("팔로잉 취소합니다. userId: $userId");
                      deleteFollowing(followingId: int.parse(userId));
                    } else {
                      print("팔로잉 신청합니다. userId: $userId");
                      postFollowing(followingId: int.parse(userId));
                    }
                    setState(() {
                      if (followStatusMap[userId] == false) {
                        followStatusMap[userId] = true;
                      } else {
                        followStatusMap[userId] = false;
                      }
                    });
                  },
                  icon: followStatusMap[userId] == false
                      ? Icon(Icons.group_remove)
                      : Icon(Icons.group_add)
                ),
              ),
          ],
        ),
      ),
    );
  }
}
