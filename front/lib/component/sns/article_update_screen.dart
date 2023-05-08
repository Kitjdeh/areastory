import 'dart:io';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/api/sns/create_article.dart';
import 'package:front/api/sns/get_article.dart';
import 'package:front/api/sns/update_article.dart';
import 'package:image_picker/image_picker.dart';

class SnsUpdateScreen extends StatefulWidget {
  const SnsUpdateScreen({Key? key, required this.index}) : super(key: key);
  final String index;

  @override
  _SnsUpdateScreenState createState() => _SnsUpdateScreenState();
}

class _SnsUpdateScreenState extends State<SnsUpdateScreen> {
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  bool _isSwitched = true;
  ScrollController? _scrollController;
  TextEditingController contentController = TextEditingController();

  late final articleId = int.parse(widget.index);
  late String image;
  late String dosi;
  late String sigungu;
  late String dongeupmyeon;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    printArticle();
  }

  void printArticle() async {
    final articleData = await getArticle(articleId: articleId);
    setState(() {
      image = articleData.image!;
      dosi = articleData.dosi!;
      sigungu = articleData.sigungu!;
      dongeupmyeon = articleData.dongeupmyeon!;
      contentController.text = articleData.content;
    });
  }

  void updateArticle(publicYn) async {
    await patchArticle(
      publicYn: _isSwitched,
      content: contentController.text,
      articleId: articleId,
    );
    Beamer.of(context).beamBack();
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    super.dispose();
  }

  // 이미지를 보여주는 위젯
  Widget showImage() {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width / 1.3,
      child: Center(
        child: Image.network(image),
      ),
    );
  }

  // 실행과 동시에 카메라 실행시켜라(최원준)
  // @override
  // void initState() {
  //   super.initState();
  //   getImage(ImageSource.camera);
  // }

  @override
  Widget build(BuildContext context) {
    // 화면 세로 고정
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

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
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                showImage(),
                SizedBox(
                  height: 50.0,
                ),
                createPostForm(),
                SizedBox(
                  height: 15.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 게시글 작성 폼
  Widget createPostForm() {
    return Padding(
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
            initialValue: '$dosi $sigungu $dongeupmyeon',
          ),
          TextFormField(
            controller: contentController,
            focusNode: _focusNode2,
            decoration: InputDecoration(labelText: '내용'),
            onTap: () {
              //120만큼 500milSec 동안 뷰를 올려줌
              _scrollController!.animateTo(120.0,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
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
    );
  }
}
