import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  File? _image;
  String? nickname;

  @override
  void initState() {
    super.initState();
    _getUserProfile();
  }

  Future<void> _getUserProfile() async {
    try {
      final User? user = await UserApi.instance.me();
      setState(() {
        nickname = user?.kakaoAccount?.profile?.nickname ?? "닉네임을 적어주세요.";
      });
    } catch (e) {
      print(e);
    }
  }

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

  Future<void> _signUp() async {
    try {
      final String baseUrl = dotenv.get('BASE_URL')!;
      final int? kakaoid = UserApi.instance.id.toInt();
      final String nicknameValue = nickname ?? "닉네임을 적어주세요.";
      final String provider = "kakao";
      final String providerId = kakaoid.toString();
      final FormData formData = FormData.fromMap({
        "nickname": nicknameValue,
        "provider": provider,
        "providerId": providerId,
        "profileImg": _image != null
            ? await MultipartFile.fromFile(_image!.path, filename: _image!.path.split('/').last)
            : await MultipartFile.fromBytes(
          (await rootBundle.load('assets/images/default.png')).buffer.asUint8List(),
          filename: 'default.png',
        ),
      });
      final Response response = await Dio().post(
        '$baseUrl/api/users/sign-up',
        data: formData,
      );
      if (response.statusCode == 200) {
        print("회원가입 성공");
        Navigator.of(context).pop();
      } else {
        print("회원가입 실패");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)?.settings.arguments as User?;
    int? kakaoid = user?.id?.toInt();
    String? nickname = user?.kakaoAccount?.profile?.nickname ?? "닉네임을 적어주세요.";
    String? imgUrl = user?.kakaoAccount?.profile?.profileImageUrl ?? "기본이미지 url";

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
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
            decoration: const InputDecoration(
              hintText: '변경할 닉네임을 입력하세요',
            ),
            onChanged: (value) {
              setState(() {
                nickname = value;
              });
            },
          ),
          ElevatedButton(
              onPressed: () async {
                final res = _signUp();
                // try{
                //   final res = await Dio().post(
                //       '${dotenv.get('BASE_URL')}/api/users/sign-up',
                //       options: Options(
                //           contentType: 'multipart/form-data'
                //       ),
                //       queryParameters: {
                //         "nickname": nickname,
                //         "provider": "kakao",
                //         "providerId": kakaoid,
                //         "profileImg": _image != null ?
                //         await MultipartFile.fromBytes(
                //           _image!.readAsBytesSync(),
                //           filename: _image!.path.split('/').last,
                //         ) :
                //         await MultipartFile.fromBytes(
                //             byteData!.buffer.asUint8List(),
                //             filename: 'default.png'
                //         )
                //       }
                //   );
                // }catch(e){
                //   print(e);
                // }
              },
              child: Text("회원가입"))
        ],
      ),
    );
  }
}
