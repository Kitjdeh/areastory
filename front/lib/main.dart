import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front/component/signup/login.dart';
import 'package:front/component/signup/sign_up.dart';
import 'package:front/screen/home_screen.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

void main() async {
  await dotenv.load(fileName: "local.env");
  // HttpOverrides.global =
  //     NoCheckCertificateHttpOverrides(); // 생성된 HttpOverrides 객체 등록
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(nativeAppKey: dotenv.get('KAKAO_KEY'));
  final storage = new FlutterSecureStorage();

  /// flutter sercure storage에 연결.

  String? userId = await storage.read(key: 'userId');

  // runApp(MyApp());

  runApp(MaterialApp(
    routes: {
      '/signup': (context) => SignUpScreen(),
      '/login': (context) => LoginScreen(),
    },
    home: userId != null ? MyApp() : LoginScreen(),
    // home: LoginScreen(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final routerDelegate = BeamerDelegate(
    initialPath: '/map',
    locationBuilder: RoutesLocationBuilder(
      routes: {
        '*': (context, state, data) => const HomeScreen(),
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      routerDelegate: routerDelegate,
      routeInformationParser: BeamerParser(),
      backButtonDispatcher: BeamerBackButtonDispatcher(
        delegate: routerDelegate,
      ),
    );
  }
}

// class NoCheckCertificateHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }
