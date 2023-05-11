import "package:flutter/material.dart";
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

Widget _postList({
  required int userId,
  required void Function(int articleId) onDelete,
  required int height,
  required List articles,
  required int currentPage,
  required int lastPage,
  required void Function() loadMoreData,
}) {
  return Column(
    children: List.generate(
      articles.length + 1,
      (index) {
        if (index < articles.length) {
          print(index);
          return ArticleComponent(
            userId: userId,
            onDelete: onDelete,
            articleId: articles[index].articleId,
            followingId: articles[index].userId,
            height: 350,
          );
        } else if (currentPage < lastPage!) {
          loadMoreData();
          return Container(
            height: 50,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        }
        return SizedBox
            .shrink(); // Return an empty widget if the condition is not met
      },
    ),
  );
}

Widget _storyBoardList() {
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
          100,
          (index) => AvatarWidget(
            type: AvatarType.TYPE1,
            thumbPath: 'https://img.ridicdn.net/cover/1250058267/large',
            size: 70,
          ),
        ),
      ],
    ),
  );
}

class _SnsScreenState extends State<SnsScreen> {
  int _currentPage = 1;
  int _lastPage = 0;
  List _articles = [];
  String dropdownValue = list.first;
  String seletedLocationDosi = '';
  String seletedLocationSigungu = '';
  String seletedLocationDongeupmyeon = '';

  late final userId = int.parse(widget.userId);

  @override
  void initState() {
    super.initState();
    printArticles();
  }

  void printArticles() async {
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
    final articleData = await getArticles(
      sort: dropdownValue == '인기순' ? 'likeCount' : 'articleId',
      page: _currentPage,
      dosi: seletedLocationDosi,
      sigungu: seletedLocationSigungu,
      dongeupmyeon: seletedLocationDongeupmyeon,
    );
    _articles.addAll(articleData.articles);
    _lastPage = articleData.totalPageNumber;
    setState(() {});
  }

  void _loadMoreData() async {
    _currentPage++;
    final newArticles = await getArticles(
      sort: dropdownValue == '인기순' ? 'likeCount' : 'articleId',
      page: _currentPage,
      dosi: seletedLocationDosi,
      sigungu: seletedLocationSigungu,
      dongeupmyeon: seletedLocationDongeupmyeon,
    );
    _articles.addAll(newArticles.articles);
    _lastPage = newArticles.totalPageNumber;

    setState(() {
      // scrollToIndex(5);
    });
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
      body: ListView(
        children: [
          widget.location != null
              ? SizedBox(
                  height: 0,
                )
              : _storyBoardList(),
          _postList(
            userId: userId,
            onDelete: onDelete,
            height: 350,
            articles: _articles,
            loadMoreData: _loadMoreData,
            currentPage: _currentPage,
            lastPage: _lastPage,
          ),
        ],
      ),
    );
  }
}
