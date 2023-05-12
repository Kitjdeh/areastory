import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/api/sns/create_article.dart';
import 'package:front/controllers/bottom_nav_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final picker = ImagePicker();
  bool _isSwitched = true;
  ScrollController? _scrollController;
  TextEditingController contentController = TextEditingController();
  late final userId = int.parse(widget.userId);

  File? _image;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  void createArticle(image, content) async {
    print(_isSwitched);
    print(content.text);
    print(image);
    await postArticle(
      publicYn: _isSwitched,
      content: content.text,
      image: image,
      // 시,구,군 다 null 이면 안됨!
      dosi: '서울특별시',
      sigungu: '서초구',
      dongeupmyeon: '역삼동',
    );

    /// 라우터 이동. 현재는 이전 라우터로 이동한다.
    Get.back();
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    super.dispose();
  }

  // 비동기 처리를 통해 카메라와 갤러리에서 이미지를 가져온다.
  Future getImage(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);

    setState(() {
      _image = File(image!.path); // 가져온 이미지를 _image에 저장
    });
  }

  // 이미지를 보여주는 위젯
  Widget showImage() {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width / 1.3,
      child: Center(
        child: _image == null
            ? GestureDetector(
                child: Icon(Icons.add_a_photo, color: Colors.blue, size: 100),
                onTap: () {
                  getImage(ImageSource.camera);
                },
              )
            : GestureDetector(
                child: Image.file(File(_image!.path)),
                onTap: () {
                  getImage(ImageSource.camera);
                },
              ),
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
          appBar: AppBar(
            title: Text(
              "게시글 등록",
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
                Get.back();
              },
            ),
          ),
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
            decoration: InputDecoration(labelText: '장소'),
            enabled: false,
            initialValue:
                '서울특별시 서초구 역삼동',
            onTap: () {
              //120만큼 500milSec 동안 뷰를 올려줌
              _scrollController!.animateTo(120.0,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
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
            maxLines: 2,
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
              createArticle(_image, contentController);
            },
            child: Text('등록'),
          ),
        ],
      ),
    );
  }
}
