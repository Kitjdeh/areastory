import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:front/api/login/kakao/kakao_login.dart';
import 'package:front/api/login/kakao/login_view_model.dart';
import 'package:front/api/login/login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final dio = Dio();
  final viewModel = LoginViewModel(KakaoLogin());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                await viewModel.login();
                setState(() {

                });
                /// 로그인시 카카오가 던져주는 키값
                // print(viewModel.user?.id);
                // print(viewModel.user?.kakaoAccount?.profile?.nickname);
                // print(viewModel.user?.kakaoAccount?.profile?.profileImageUrl);
                try{
                  final res = await getLogin(viewModel.user?.id);
                  print(res);
                  if(res.msg == '신규 회원입니다.'){
                    Navigator.pushNamed(
                      context,
                      '/signup',
                      arguments: viewModel.user,
                    );
                  }else{
                    print("로그인 SSE 시작합니다");
                    /// 로그인 성공시 페이지 이동.
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => MyApp()),
                    // );
                  }
                }catch(e){
                  print(e);
                  print("에러다다다다다다");
                }
              },
              child: Text("로그인"),
            ),
            ElevatedButton(
              onPressed: () async {
                await viewModel.logout();
                setState(() {

                });
              },
              child: Text("로그아웃"),
            )

          ],
        ),
      ),
    );
  }
}
