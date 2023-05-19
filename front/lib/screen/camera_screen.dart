import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front/api/sns/create_article.dart';
import 'package:front/constant/home_tabs.dart';
import 'package:front/controllers/follow_screen_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final FollowController _followController = Get.find<FollowController>();
  // String? storedLocation;
  String storedLocation = '사진을 찍어주세요';
  final FocusNode _focusNode2 = FocusNode();
  final picker = ImagePicker();
  bool _isSwitched = true;
  ScrollController? _scrollController;
  TextEditingController contentController = TextEditingController();
  late final userId = int.parse(widget.userId);
  String seletedLocationDosi = '';
  String seletedLocationSigungu = '';
  String seletedLocationDongeupmyeon = '';
  bool? createYn = true;

  File? _image;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  void createArticle(image, content) async {
    List<String> locationParts = storedLocation!.split(' ');
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
    await postArticle(
      publicYn: _isSwitched,
      content: content.text,
      image: image,
      // 시,구,군 다 null 이면 안됨!
      dosi: seletedLocationDosi,
      sigungu: seletedLocationSigungu,
      dongeupmyeon: seletedLocationDongeupmyeon,
    );

    // FollowScreen 컨트롤러의 printArticles 함수 실행
    // Get.find<FollowController>().printArticles();
    _followController.printArticles();

    /// 라우터 이동. 현재는 이전 라우터로 이동한다.
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => FollowScreen(
    //               userId: userId.toString(),
    //               signal: '1',
    //             )));
    Get.back();
    createYn = true;
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    super.dispose();
  }

  Future getImage(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);
    final storage = new FlutterSecureStorage();
    storedLocation = (await storage.read(key: "userlocation"))!;
    // storedLocation = '서울특별시 영등포구 여의도동';
    setState(() {
      _image = File(image!.path);
    });
  }

  void showCreateConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // 대화 상자 바깥을 터치하여 닫히지 않도록 설정
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('죄송합니다'),
          content: Text('사진과 내용을 채워주세요'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(); // 대화 상자 닫기
                createYn = true;
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 화면 세로 고정
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

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
                createPostForm(
                  storedLocation: storedLocation,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 이미지를 보여주는 위젯
  Widget showImage() {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
      child: Container(
        color: Colors.black12,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Center(
          child: _image == null
              ? GestureDetector(
                  child: ImageData(
                    IconsPath.camera,
                    width: MediaQuery.of(context).size.width,
                  ),
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
      ),
    );
  }

  // 게시글 작성 폼
  Widget createPostForm({String? storedLocation}) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 장소 입력 폼
            Text(
              '장소: ${storedLocation}',
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
                  hintText: contentController.text.isEmpty ? '내용을 입력해 주세요' : '',
                  border: InputBorder.none, // Remove default border
                  contentPadding: EdgeInsets.all(16.0), // Adjust padding
                ),
                onTap: () {
                  // 120만큼 500 milliseconds 동안 뷰를 올려줌
                  _scrollController!.animateTo(
                    120.0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
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
              activeColor: Colors.black, // Set the active color to black
              inactiveTrackColor: Colors
                  .black12, // Set the inactive track color to a dark shade of gray
            ),
            // 등록 버튼
            Material(
              child: ElevatedButton(
                onPressed: () {
                  if (createYn == true) {
                    createYn = false;
                    _image != null && !contentController.text.isEmpty
                        ? createArticle(_image, contentController)
                        : showCreateConfirmationDialog();
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  elevation: 3,
                ),
                child: Text('등록'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
