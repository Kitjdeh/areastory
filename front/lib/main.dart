import 'package:beamer/beamer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front/component/signup/login.dart';
import 'package:front/component/signup/sign_up.dart';
import 'package:front/firebase_options.dart';
import 'package:front/screen/home_screen.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

/// 앱이 백그라운드 상태일때 메시지 수신. 항상 main.dart의 최상위.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  await dotenv.load(fileName: "local.env");
  // HttpOverrides.global =
  //     NoCheckCertificateHttpOverrides(); // 생성된 HttpOverrides 객체 등록
  WidgetsFlutterBinding.ensureInitialized();

  // KakaoSdk.init(nativeAppKey: dotenv.get('KAKAO_KEY'));
  // final storage = new FlutterSecureStorage();

  /// flutter sercure storage에 연결.

  /// 카카오 세팅
  KakaoSdk.init(nativeAppKey: dotenv.get('KAKAO_KEY'));

  /// 로그인 체크
  final storage = new FlutterSecureStorage();

  /// flutter sercure storage에 연결.
  String? userId = await storage.read(key: 'userId');

  /// firebase 플랫폼별 초기화 실행.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  var fcmToken = await FirebaseMessaging.instance.getToken(vapidKey: "${dotenv.get('FIREBASE_KEY')}");

  FirebaseMessaging.instance.onTokenRefresh
      .listen((fcmToken) {
    // TODO: If necessary send token to application server.
    /// 만약 토큰이 바뀐다면 처리할 구간
    /// 예를 들면 백엔드 user정보의 토큰을 바꿔준다.

  });

  /// 기존 FCM 토큰을 삭제.
  //FirebaseMessaging.instance.deleteToken();

  /// 안드로이드는 채널설정이 필수.
  var channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // name
    description: 'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true, // 알림 소리 여부
    enableVibration: true, // 진동 여부
    enableLights: true, // 알림 조명 여부
  );

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

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
