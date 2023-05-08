import 'dart:io';
import 'package:beamer/beamer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/api/comment/create_comment.dart';
import 'package:front/api/comment/delete_comment.dart';
import 'package:front/api/comment/get_comments.dart';
import 'package:front/api/comment/update_comment.dart';
import 'package:front/api/follow/create_following.dart';
import 'package:front/api/follow/delete_follower.dart';
import 'package:front/api/follow/delete_following.dart';
import 'package:front/api/follow/get_followers.dart';
import 'package:front/api/follow/get_followings_search.dart';
import 'package:front/api/follow/get_followings_sort.dart';
import 'package:front/api/like/create_article_like.dart';
import 'package:front/api/like/create_comment_like.dart';
import 'package:front/api/like/delete_article_like.dart';
import 'package:front/api/like/delete_comment_like.dart';
import 'package:front/api/like/get_article_likes.dart';
import 'package:front/api/like/get_comment_likes.dart';
import 'package:front/api/sns/create_article.dart';
import 'package:front/api/sns/get_article.dart';
import 'package:front/api/sns/get_mylike_article.dart';
import 'package:front/api/sns/update_article.dart';
import 'package:front/api/sns/delete_article.dart';
import 'package:front/screen/home_screen.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

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

  File? _image;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  void createArticle(image, content) async {
    await postArticle(
      publicYn: _isSwitched,
      content: content.text,
      image: image,
      // 시,구,군 다 null 이면 안됨!
      dosi: '성도',
      sigungu: '성도시',
      dongeupmyeon: '성동',
    );
    // Beamer.of(context).beamToNamed('/sns');
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
              createArticle(_image, contentController);
            },
            child: Text('등록'),
          ),
        ],
      ),
    );
  }
}
