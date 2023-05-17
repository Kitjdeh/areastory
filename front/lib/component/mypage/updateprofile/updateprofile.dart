import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:front/screen/mypage_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen(
      {Key? key,
      required this.userId,
      required this.img,
      required this.nickname})
      : super(key: key);
  final String userId;
  final String img;
  final String nickname;

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  File? _image;
  String? _nickname;

  /// 앨범에서 이미지 가져온다.
  Future<void> _getImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final file = File(pickedFile.path);
      final savedImage = await file.copy('${appDir.path}/$fileName');
      setState(() {
        _image = savedImage;
      });
      print("이미지바뀜 ${_image}");
    }
  }

  Future<MultipartFile> getFileFromUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final fileName = url.split('/').last;
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(bytes);
      return MultipartFile.fromFile(file.path, filename: fileName);
    } else {
      throw Exception('Failed to get file from URL');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          /// 뒤로가기버튼설정
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        titleSpacing: 0,
        title: Text(
          "프로필 변경",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text("프로필설정", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              Container(
                height: 300,
                child: Stack(
                  children: [
                    Image.asset(
                      'asset/img/login/bgimg.png',
                      width: 400,
                      // height: 300,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 60,
                      left: MediaQuery.of(context).size.width / 2 - 85,
                      child: GestureDetector(
                          onTap: () {
                            _getImageFromGallery();
                          },
                          child: CircleAvatar(
                            radius: 80,
                            backgroundImage: _image != null
                                ? Image.file(_image!).image
                                : Image.network(widget.img).image,
                            // backgroundImage: NetworkImage(imgUrl)),
                          )),
                    ),
                  ],
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextFormField(
                    initialValue: widget.nickname,
                    maxLength: 10,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: '변경할 닉네임을 입력하세요',
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                          RegExp(r"\s")), // 띄어쓰기를 거부합니다.
                    ],
                    onChanged: (value) {
                      setState(() {
                        _nickname = value;
                      });
                    },
                  ),
                ),
              ]),
              ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(Size(150, 40)),
                    backgroundColor: MaterialStateProperty.all(Colors.grey),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50), // 모서리 반경 조절
                      ),
                    ),
                  ),
                  onPressed: () async {
                    final userInfoReq = {
                      'nickname': _nickname == null ? widget.nickname : _nickname,
                    };
                    final formData = FormData.fromMap({
                      'userInfoReq': MultipartFile.fromString(
                          json.encode(userInfoReq),
                          contentType: MediaType.parse('application/json')),
                      'profile': _image != null
                          ? await MultipartFile.fromFile(
                        _image!.path,
                        filename: _image!.path.split('/').last,
                      )
                          : await getFileFromUrl(widget.img),
                    });
                    print("_image: ${_image}");
                    try {
                      final res = await Dio().patch(
                          '${dotenv.get('BASE_URL')}/api/users/${widget.userId}',
                          data: formData
                      );
                      if (res.statusCode == 200){
                        print("회원정보 수정 성공");
                        // Navigator.of(context).pop();
                        Navigator.pop(context, true); // 수정이 성공했음을 나타내는 true 값을 결과로 전달합니다

                        // 이전 페이지의 build() 메서드에서 상태 업데이트
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => MyPageScreen(
                        //       userId: widget.userId,
                        //     ),
                        //   ),
                        // );
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text("수정하기"))
            ],
          ),
        ),
      ),
    );
  }
}
