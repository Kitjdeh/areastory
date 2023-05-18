import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front/api/login/kakao/kakao_login.dart';
import 'package:front/api/login/kakao/login_view_model.dart';
import 'package:front/api/login/login.dart';
import 'package:front/component/alarm/toast.dart';
import 'package:front/constant/home_tabs.dart';
import 'package:front/main.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.fcmToken}) : super(key: key);
  final fcmToken;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final storage = new FlutterSecureStorage();

  /// flutter sercure storage에 연결.
  // final dio = Dio();
  final viewModel = LoginViewModel(KakaoLogin());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage("asset/img/login_logo.png"),
                width: MediaQuery.of(context).size.width * 0.8,
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () async {
                  final HASH = await KakaoSdk.origin;
                  // print('HASH${HASH}');
                  final flag = await viewModel.login();
                  viewModel.printError();
                  setState(() {});
                  // print("카카오로그인 진행상황 테스트: ${flag}");
                  /// 로그인시 카카오가 던져주는 키값
                  if (await viewModel.isLogined) {
                    // toast(context, '로그인은 뜸');
                    print("카카오 통신성공! 카카오 유저 정보 가져옵니다.");
                    try {
                      final res = await getLogin(
                          viewModel.user?.id, this.widget.fcmToken);
                      if (res.msg == '신규 회원입니다.') {
                        print("회원가입 페이지로 이동합니다.");
                        Navigator.pushNamed(
                          context,
                          '/signup',
                          arguments: viewModel.user,
                        );
                      } else {
                        print("로그인 성공했습니다.");

                        /// 로그인 성공시 storage에 저장
                        await storage.write(
                            key: "userId",
                            value: res.data['userId'].toString());
                        /// 로그인 성공시 페이지 이동.
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyApp(userId: res.data['userId'].toString())),
                        );
                      }
                    } catch (e) {
                      print("로그인 에러발생: 아래는 에러코드입니다.");
                      // toast(context, '로그인 에러발생${e}');
                    }
                  } else {
                    print("카카오 서비스 가입 중도 취소");
                    // toast(context, '로그인 실패');
                  }
                },
                child: Image(
                  image: AssetImage(
                      "asset/img/login/kakao_login_medium_narrow.png"),
                ),
              ),
              // ElevatedButton(
              //   onPressed: () async {
              //     await viewModel.logout();
              //     setState(() {});
              //
              //     /// 로그아웃시
              //     await storage.delete(key: "userId");
              //   },
              //   child: Text("로그아웃"),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
