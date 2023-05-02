import 'package:front/api/login/kakao/social_login.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoLogin implements SocialLogin {
  @override
  Future<bool> login() async {
    try{
      // 카카오톡 설치 되어있는지 확인
      bool isInstalled = await isKakaoTalkInstalled();
      if (isInstalled) {  // 카카오톡 설치
        try {
          await UserApi.instance.loginWithKakaoTalk(); // 카카오톡으로 로그인
          return true;
        } catch (e) {
          return false;
        }
      }else{              // 카카오톡 미설치
        try {
          await UserApi.instance.loginWithKakaoAccount(); // 카카오톡 웹에서 로그인
          return true;
        } catch(e){
          return false;
        }
      }
    }catch(error){
      return false;
    }
  }

  @override
  Future<bool> logout() async {
    try{
      await UserApi.instance.unlink();
      return true;
    }catch(error){
      return false;
    }
  }
}
