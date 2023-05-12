import "package:flutter/material.dart";
import "package:front/api/follow/get_followings_search.dart";
import "package:front/api/follow/get_followings_sort.dart";
import "package:front/component/sns/avatar_widget.dart";
import "package:front/component/sns/post_widget.dart";
import "package:front/constant/home_tabs.dart";
import "package:front/controllers/bottom_nav_controller.dart";
import "package:front/livechat/chat_screen.dart";
import 'package:front/api/sns/get_articles.dart';
import 'package:front/component/sns/article/article.dart';
import 'package:front/const/auto_search_test.dart';
import "package:get/get.dart";

const List<String> list = <String>['인기순', '최신순'];

class SnsScreen extends StatefulWidget {
  const SnsScreen({
    Key? key,
    this.location,
    required this.userId,
  }) : super(key: key);
  final String userId;
  final String? location;

  @override
  State<SnsScreen> createState() => _SnsScreenState();
}

Widget _myStory() {
  return Stack(
    children: [
      AvatarWidget(
        type: AvatarType.TYPE2,
        thumbPath:
            'https://areastory-user.s3.ap-northeast-2.amazonaws.com/profile/8373fb5d-78e7-4613-afc9-5269c247f36a.1683607649926',
        size: 70,
      ),
    ],
  );
}

Widget _storyBoardList(
// { required List followings,}
    ) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        _myStory(),
        const SizedBox(
          width: 5,
        ),
        ...List.generate(
          // followings.length,
          100,
          (index) => AvatarWidget(
            type: AvatarType.TYPE1,
            // thumbPath: followings[index].profile,
            thumbPath:
                'https://areastory-user.s3.ap-northeast-2.amazonaws.com/profile/8373fb5d-78e7-4613-afc9-5269c247f36a.1683607649926',
            size: 70,
          ),
        ),
      ],
    ),
  );
}

class _SnsScreenState extends State<SnsScreen> {
  int _currentPage = 1;
  bool _hasNextPage = false;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  List _articles = [];
  // List _followings = [];
  String dropdownValue = list.first;
  String seletedLocationDosi = '';
  String seletedLocationSigungu = '';
  String seletedLocationDongeupmyeon = '';

  late final userId = int.parse(widget.userId);
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    printArticles();
    _controller.addListener(_loadMoreData);
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMoreData);
    super.dispose();
  }

  void printArticles() async {
    print('print');
    setState(() {
      _isFirstLoadRunning = true;
    });
    if (widget.location != null) {
      List<String> locationParts = widget.location!.split(' ');
      if (locationParts.length == 1) {
        seletedLocationDosi = locationParts[0];
      } else if (locationParts.length == 2) {
        seletedLocationDosi = locationParts[0];
        seletedLocationSigungu = locationParts[1];
      } else if (locationParts.length == 3) {
        if (locationParts[2][locationParts[2].length - 1] == "구") {
          seletedLocationDosi = locationParts[0];
          seletedLocationSigungu = locationParts[1] + locationParts[2];
        } else {
          seletedLocationDosi = locationParts[0];
          seletedLocationSigungu = locationParts[1];
          seletedLocationDongeupmyeon = locationParts[2];
        }
      } else {
        seletedLocationDosi = locationParts[0];
        seletedLocationSigungu = locationParts[1] + locationParts[2];
        seletedLocationDongeupmyeon = locationParts[3];
      }
    }
    _currentPage = 1;
    _articles.clear();
    // _followings.clear();
    final articleData = await getArticles(
      sort: dropdownValue == '인기순' ? 'likeCount' : 'articleId',
      page: _currentPage,
      dosi: seletedLocationDosi,
      sigungu: seletedLocationSigungu,
      dongeupmyeon: seletedLocationDongeupmyeon,
    );
    // final followData = await getFollowingsSearch(page: 0, search: '');
    // _followings.addAll(followData);
    _articles.addAll(articleData.articles);
    _hasNextPage = articleData.nextPage;

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _loadMoreData() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 3000) {
      print('more');
      setState(() {
        _isLoadMoreRunning = true;
      });
      _currentPage += 1;
      final newArticles = await getArticles(
        sort: dropdownValue == '인기순' ? 'likeCount' : 'articleId',
        page: _currentPage,
        dosi: seletedLocationDosi,
        sigungu: seletedLocationSigungu,
        dongeupmyeon: seletedLocationDongeupmyeon,
      );
      _articles.addAll(newArticles.articles);
      _hasNextPage = newArticles.nextPage;

      setState(() {
        print('성공');
        _isLoadMoreRunning = false;
      });
    }
  }

  void onDelete(int articleId) {
    setState(() {});
  }

  void handleLocationSelected(String selectedLocation) {
    List<String> locationParts = selectedLocation.split(' ');
    print(locationParts);

    if (locationParts.length == 3) {
      seletedLocationDosi = locationParts[0];
      seletedLocationSigungu = locationParts[1];
      seletedLocationDongeupmyeon = locationParts[2];
    } else {
      seletedLocationDosi = locationParts[0];
      seletedLocationSigungu = locationParts[1] + ' ' + locationParts[2];
      seletedLocationDongeupmyeon = locationParts[3];
    }

    print(seletedLocationDosi);
    print(seletedLocationSigungu);
    print(seletedLocationDongeupmyeon);

    setState(() {
      printArticles();
    });
  }

  void onChangeSort(String dropdownValue) {
    print(_controller.position.extentAfter);
    setState(() {
      printArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: widget.location != null
            ? Text(
                widget.location!,
                style: TextStyle(color: Colors.black, fontSize: 16),
              )
            : ImageData(
                IconsPath.logo,
                width: 270,
              ),
        centerTitle: widget.location != null ? true : false,
        leading: widget.location != null
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios_new_outlined),
                color: Colors.black,
                onPressed: () {
                  Get.find<BottomNavController>().willPopAction();
                },
              )
            : null,
        actions: [
          widget.location != null
              ? SizedBox(
                  width: 0,
                )
              : LocationSearch(
                  onLocationSelected: handleLocationSelected,
                ),
          const SizedBox(
            width: 20,
          ),
          DropdownButton<String>(
            value: dropdownValue,
            style: const TextStyle(color: Colors.black),
            underline: null,
            autofocus: true,
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            onChanged: (String? value) {
              dropdownValue = value!;
              onChangeSort(value!);
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          )
        ],
      ),
      body: _isFirstLoadRunning
          ? const Center(
              child: const CircularProgressIndicator(),
            )
          : ListView(
              controller: _controller,
              children: [
                if (widget.location == null)
                  _storyBoardList(
                      // followings: _followings,
                      ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List.generate(
                    _articles.length,
                    (index) => ArticleComponent(
                      userId: userId,
                      onDelete: onDelete,
                      articleId: _articles[index].articleId,
                      followingId: _articles[index].userId,
                      height: 300,
                    ),
                  ),
                ),
                if (_isLoadMoreRunning)
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 40),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                if (!_isLoadMoreRunning && !_hasNextPage)
                  Container(
                    padding: const EdgeInsets.only(top: 30, bottom: 40),
                    color: Colors.white,
                    child: const Center(
                      child: Text('더이상 게시글이 없습니다'),
                    ),
                  ),
              ],
            ),
    );
  }
}
