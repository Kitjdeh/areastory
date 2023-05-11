import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
      print("이미지가 안바뀌었습니다. 파일이름입니다");
      print(fileName);
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
                    : Image.network(widget.img).image,
                // backgroundImage: NetworkImage(imgUrl)),
              )),
          TextFormField(
            initialValue: widget.nickname,
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
                  print(formData);
                  final res = await Dio().patch(
                      '${dotenv.get('BASE_URL')}/api/users/${widget.userId}',
                      data: formData
                  );
                  if (res.statusCode == 200){
                    print("회원정보 수정 성공");
                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  print(e);
                }
              },
              child: Text("회원정보 수정"))
        ],
      ),
    );
  }
}
