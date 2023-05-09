import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/api/sns/get_article.dart';
import 'package:front/api/sns/update_article.dart';
import 'package:front/controllers/bottom_nav_controller.dart';
import 'package:get/get.dart';

class SnsUpdateScreen extends StatefulWidget {
  const SnsUpdateScreen({Key? key, required this.articleId}) : super(key: key);
  final int articleId;

  @override
  _SnsUpdateScreenState createState() => _SnsUpdateScreenState();
}

class _SnsUpdateScreenState extends State<SnsUpdateScreen> {
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  bool _isSwitched = true;
  ScrollController? _scrollController;
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  void updateArticle(publicYn) async {
    await patchArticle(
      publicYn: _isSwitched,
      content: contentController.text,
      articleId: widget.articleId,
    );
    Get.find<BottomNavController>().willPopAction();
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
            contentController.text = snapshot.data!.content;
            return SafeArea(
              child: GestureDetector(
                onTap: () {
                  // 화면 클릭 이벤트 처리
                  if (_focusNode1.hasFocus) {
                    // 첫번째 TextFormField에 포커스가 있는 경우
                    _focusNode1.unfocus();
                  }
                  if (_focusNode2.hasFocus) {
                    // 두번째 TextFormField에 포커스가 있는 경우
                    _focusNode2.unfocus();
                  }
                },
                child: Scaffold(
                  backgroundColor: const Color(0xFFECF9FF),
                  appBar: AppBar(
                    title: Text(
                      "게시글 수정",
                      style: TextStyle(color: Colors.black),
                    ),
                    centerTitle: true,
                    backgroundColor: Colors.white,
                    elevation: 0,

                    /// 앱바 그림자효과 제거
                    leading: IconButton(
                      /// 뒤로가기버튼설정
                      icon: Icon(Icons.arrow_back_ios_new_outlined),
                      color: Colors.black,
                      onPressed: () {
                        Get.find<BottomNavController>().willPopAction();
                      },
                    ),
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width / 1.3,
                          child: Center(
                            child: Image.network(snapshot.data!.image),
                          ),
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // 장소 입력 폼
                              TextFormField(
                                focusNode: _focusNode1,
                                decoration: InputDecoration(
                                  labelText: '장소',
                                ),
                                enabled: false,
                                initialValue:
                                    '${snapshot.data!.dosi} ${snapshot.data!.sigungu} ${snapshot.data!.dongeupmyeon}',
                              ),
                              TextFormField(
                                controller: contentController,
                                focusNode: _focusNode2,
                                decoration: InputDecoration(labelText: '내용'),
                                onTap: () {
                                  //120만큼 500milSec 동안 뷰를 올려줌
                                  _scrollController!.animateTo(120.0,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.ease);
                                },
                                maxLines: 3,
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
                              ),
                              // 등록 버튼
                              ElevatedButton(
                                onPressed: () {
                                  updateArticle(_isSwitched);
                                },
                                child: Text('등록'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        )
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
