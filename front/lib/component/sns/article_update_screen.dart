import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/api/sns/get_article.dart';
import 'package:front/api/sns/update_article.dart';
import 'package:front/controllers/bottom_nav_controller.dart';
import 'package:front/controllers/follow_screen_controller.dart';
import 'package:get/get.dart';

class SnsUpdateScreen extends StatefulWidget {
  const SnsUpdateScreen({Key? key, required this.articleId}) : super(key: key);
  final int articleId;

  @override
  _SnsUpdateScreenState createState() => _SnsUpdateScreenState();
}

class _SnsUpdateScreenState extends State<SnsUpdateScreen> {
  final FollowController _followController = Get.find<FollowController>();
  final FocusNode _focusNode2 = FocusNode();
  bool _isSwitched = true;
  ScrollController? _scrollController;
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    getArticle(articleId: widget.articleId).then((articleData) {
      contentController.text = articleData.content;
    });
  }

  void updateArticle(publicYn) async {
    await patchArticle(
      publicYn: _isSwitched,
      content: contentController.text,
      articleId: widget.articleId,
    );
    _followController.printArticles();
    // Get.find<BottomNavController>().willPopAction();
    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 화면 세로 고정
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return FutureBuilder<ArticleData>(
        future: getArticle(articleId: widget.articleId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            contentController.selection = TextSelection.fromPosition(
              TextPosition(offset: contentController.text.length),
            );
            return SafeArea(
              child: GestureDetector(
                onTap: () {
                  if (_focusNode2.hasFocus) {
                    // 두번째 TextFormField에 포커스가 있는 경우
                    _focusNode2.unfocus();
                  }
                },
                child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    title: Text(
                      "게시글 수정",
                      style: TextStyle(color: Colors.black),
                    ),
                    centerTitle: true,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new_outlined),
                      color: Colors.black,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.05),
                          child: Container(
                            color: Colors.black12,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.42,
                            child: Center(
                              child: Image.network(snapshot.data!.image),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  '장소: ${snapshot.data!.dosi} ${snapshot.data!.sigungu} ${snapshot.data!.dongeupmyeon}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '내용',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: TextFormField(
                                    controller: contentController,
                                    focusNode: _focusNode2,
                                    decoration: InputDecoration(
                                      border: InputBorder
                                          .none, // Remove default border
                                      contentPadding: EdgeInsets.all(16.0),
                                    ),
                                    onTap: () {
                                      //120만큼 500milSec 동안 뷰를 올려줌
                                      _scrollController!.animateTo(120.0,
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.ease);
                                    },
                                    maxLines: 2,
                                  ),
                                ),
                                // 비공개 여부 체크박스
                                SwitchListTile(
                                  title: Text('공개'),
                                  value: _isSwitched,
                                  onChanged: (value) {
                                    setState(() {
                                      _isSwitched = value;
                                    });
                                  },
                                  activeColor: Colors
                                      .black, // Set the active color to black
                                  inactiveTrackColor: Colors.black12,
                                ),
                                // 등록 버튼
                                ElevatedButton(
                                  onPressed: () {
                                    updateArticle(_isSwitched);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.black,
                                    elevation: 3,
                                  ),
                                  child: Text('등록'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Container(
              height: 0,
            );
          } else {
            return Container(
              height: 0,
            );
          }
        });
  }
}
