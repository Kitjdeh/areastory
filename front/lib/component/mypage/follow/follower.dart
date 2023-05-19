import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front/api/follow/create_following.dart';
import 'package:front/api/follow/delete_follower.dart';
import 'package:front/api/follow/delete_following.dart';
import 'package:front/api/mypage/get_follower.dart';
import 'package:front/constant/home_tabs.dart';
import 'package:front/screen/mypage_screen.dart';
import 'package:flutter/cupertino.dart'; // 1. Cupertino 패키지 추가

class FollowerListScreen extends StatefulWidget {
  FollowerListScreen({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<FollowerListScreen> createState() => _FollowerListScreenState();
}

class _FollowerListScreenState extends State<FollowerListScreen> {
  List<String> filters = ['팔로워 이름순', '팔로워 최신순', '팔로워 오래된순']; // 예시 필터 목록
  String selectedFilter = '팔로워 이름순'; // 초기 선택된 필터
  int _filterIndex = 0;
  int _currentPage = 0;
  List<dynamic> _followers = [];
  bool nextPage = true; // 다음페이지를 불러올 수 있는가?
  bool _isLoading = false; // 로딩 중인지 여부
  Map<String, bool> followStatusMap = {}; //팔로워 버튼 와리가리
  Map<String, bool> followingStatusMap = {}; //팔로잉 버튼 와리가리
  final storage = new FlutterSecureStorage();
  String? myId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    printFollowers(int.parse(widget.userId), _currentPage, _filterIndex);
  }

  void setMyId() async {
    myId = await storage.read(key: "userId");
  }

  void printFollowers(userId, page, type) async {
    _followers.clear();
    myId = await storage.read(key: "userId");

    final followerData = await getUserFollowers(userId: userId, page:page, type: type);
    setState(() {
      _currentPage = 0;
      _followers.addAll(followerData.followers);
      followerData.followers.forEach((user) {
        followStatusMap[user.userId.toString()] = false;
        followingStatusMap[user.userId.toString()] = user.check;
      });
    });
  }

  void getuserfollowers(userId) async {
    if (_isLoading) return; // 이미 로딩 중인 경우 중복 요청 방지
    ++_currentPage;
    final followersData = await getUserFollowers(userId: userId,page: _currentPage,  type: _filterIndex);
    setState(() {
      _followers.addAll(followersData.followers);
      nextPage = followersData.nextPage;
      _isLoading = false; // 로딩 완료 상태로 설정
      followersData.followers.forEach((user) {
        followStatusMap[user.userId.toString()] = false;
        followingStatusMap[user.userId.toString()] = user.check;
      });
    });
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
                printFollowers(int.parse(widget.userId), 0, index);
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

  // 2. 확인 대화 상자를 표시하고 선택 결과를 처리하는 메서드
  Future<void> showDeleteConfirmationDialog(String userId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // 대화 상자 바깥을 터치하여 닫히지 않도록 설정
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('팔로워 취소'),
          content: Text('정말로 이 팔로워를 취소하시겠습니까?'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop(); // 대화 상자 닫기
              },
            ),
            CupertinoDialogAction(
              child: Text('확인'),
              onPressed: () {
                deleteFollower(followerId: int.parse(userId)); // 팔로워 취소 함수 호출
                setState(() {
                  followStatusMap[userId] = true; // 팔로워 상태 업데이트
                });
                Navigator.of(context).pop(); // 대화 상자 닫기
              },
            ),
          ],
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
    if (_followers.length == 0) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("팔로워한 사람이")],
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
              getuserfollowers(int.parse(widget.userId));
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
                  if(followStatusMap[_followers[index].userId.toString()] == true){
                    return  Container(height: 0);
                  }
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
    if(followStatusMap[userId] == true){
      return  Container(height: 0);
    }
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
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    nickname,
                                    overflow: TextOverflow.ellipsis, // 글자가 너무 길 경우 생략되도록 설정
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                ],
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



                /// 버튼은 분기처리해야함.(팔로워 해제)
                if (myId == widget.userId)
                  Container(
                    padding: EdgeInsets.only(right: 20),
                    child: IconButton(
                      onPressed: () {
                        if (followStatusMap[userId] == false) {
                          print("팔로워 취소합니다. userId: $userId");
                          // deleteFollower(followerId: int.parse(userId));
                          showDeleteConfirmationDialog(userId);
                        }
                      },
                      icon: followStatusMap[userId] == false
                          ? ImageData(IconsPath.deleteOnIcon)
                          : ImageData(IconsPath.deleteOffIcon),
                    ),
                  ),
              ],
          ),
        ),
    );
  }
}
