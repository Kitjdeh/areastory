import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front/main.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key, required this.fcmToken}) : super(key: key);
  final fcmToken;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  File? _image;

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
      return MultipartFile.fromFile(
          file.path,
          filename: fileName
      );
    } else {
      throw Exception('Failed to get file from URL');
    }
  }

  @override
  Widget build(BuildContext context) {
    final storage = new FlutterSecureStorage(); /// flutter sercure storage에 연결.
    final user = ModalRoute.of(context)?.settings.arguments as User?;
    int? kakaoid = user?.id?.toInt();
    String nickname = user?.kakaoAccount?.profile?.nickname ?? "닉네임을 적어주세요.";
    String? imgUrl =
        user?.kakaoAccount?.profile?.profileImageUrl ?? "기본이미지 url";
    String? _nickname;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: () {
                _getImageFromGallery();
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _image != null
                    ? Image.file(_image!).image
                    : Image.network(imgUrl).image,
                // backgroundImage: NetworkImage(imgUrl)),
              )),
          TextFormField(
            initialValue: nickname,
            maxLength: 10,
            decoration: const InputDecoration(
              hintText: '변경할 닉네임을 입력하세요',
            ),
            onChanged: (value) {
              setState(() {
                _nickname = value;
              });
            },
          ),
          ElevatedButton(
              onPressed: () async {
                final userReq = {
                  'nickname': _nickname == null ? nickname : _nickname,
                  'provider': 'kakao',
                  'providerId': kakaoid,
                  'registrationToken': this.widget.fcmToken
                };
                print(userReq['nickname']);
                final formData = FormData.fromMap({
                  'userReq': MultipartFile.fromString(
                      json.encode(userReq),
                      contentType: MediaType.parse('application/json')
                  ),
                  'profile': _image != null
                      ? await MultipartFile.fromFile(
                    _image!.path,
                    filename: _image!.path.split('/').last,
                  )
                      :await getFileFromUrl(imgUrl),
                });

                try {
                  print(formData);
                  final res = await Dio().post(
                      '${dotenv.get('BASE_URL')}/api/users/sign-up',
                      data: formData
                  );
                  if (res.statusCode == 200){
                    print("회원가입성공. SSE 시작합니다");
                    /// 회원가입 성공시 storage에 저장
                    // print(res.data['data']['userId']);
                    await storage.write(key: "userId", value: res.data['data']['userId'].toString());
                    /// 회원가입 성공시 페이지 이동.
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()),
                    );
                  }
                } catch (e) {
                  print(e);
                }
              },
              child: Text("회원가입"))
        ],
      ),
    );
  }
}