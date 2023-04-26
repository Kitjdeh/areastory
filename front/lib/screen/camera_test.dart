import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class CameraExample extends StatefulWidget {
  const CameraExample({Key? key}) : super(key: key);

  @override
  _CameraExampleState createState() => _CameraExampleState();
}

class _CameraExampleState extends State<CameraExample> {
  File? _image;
  final picker = ImagePicker();

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
        height: MediaQuery.of(context).size.width,
        child: Center(
            child: _image == null
                ? Text('No image selected.')
                : Image.file(File(_image!.path))));
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

    return Scaffold(
      backgroundColor: const Color(0xFFECF9FF),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 25.0),
          showImage(),
          SizedBox(
            height: 50.0,
          ),
          // 이미지 선택 버튼
          _image != null
              ? Text('2') // 이미지가 선택되면 보여주지 않음
              : FloatingActionButton(
                  child: Icon(Icons.add_a_photo),
                  tooltip: 'pick Image',
                  onPressed: () {
                    getImage(ImageSource.camera);
                  },
                ),
        ],
      ),
    );
  }

  // 게시글 작성 폼
  Widget createPostForm() {
    return Column(
      children: [
        // 장소 입력 폼
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(labelText: '장소'),
          ),
        ),
        // 제목 입력 폼
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(labelText: '제목'),
          ),
        ),
        // 내용 입력 폼
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(labelText: '내용'),
            maxLines: 10,
          ),
        ),
        // 비공개 여부 체크박스
        Expanded(
          child: CheckboxListTile(
            title: Text('비공개'),
            value: false,
            onChanged: (value) {},
          ),
        ),
        // 등록 버튼
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            child: Text('등록'),
          ),
        ),
      ],
    );
  }
}
