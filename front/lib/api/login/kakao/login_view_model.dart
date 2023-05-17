import 'package:front/api/login/kakao/social_login.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class LoginViewModel {
  final SocialLogin _socialLogin;
  bool isLogined = false; // 최초에는 로그아웃상태
  User? user;

  LoginViewModel(this._socialLogin);

  Future login() async {
    // 로그인 요청
    isLogined = await _socialLogin.login();
    // 카카오 로그인 성공시,
    if(isLogined) {
      // 유저 정보 받아와라
      user = await UserApi.instance.me();
      return true;
    }else{
      return false;
    }
  }

  Future logout() async {
    await _socialLogin.logout();

    isLogined = false;
    user = null;
  }
}