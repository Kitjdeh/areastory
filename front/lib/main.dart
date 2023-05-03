import 'package:beamer/beamer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front/component/signup/login.dart';
import 'package:front/component/signup/sign_up.dart';
import 'package:front/screen/home_screen.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  await dotenv.load(fileName: "local.env");
  // HttpOverrides.global =
  //     NoCheckCertificateHttpOverrides(); // 생성된 HttpOverrides 객체 등록
  WidgetsFlutterBinding.ensureInitialized();

  /// 카카오 세팅
  KakaoSdk.init(nativeAppKey: dotenv.get('KAKAO_KEY'));

  /// 로그인 체크
  final storage = new FlutterSecureStorage(); /// flutter sercure storage에 연결.
  String? userId = await storage.read(key: 'userId');

  /// FCM
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  var initialzationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  var initializationSettings = InitializationSettings(
      android: initialzationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // runApp(MyApp());
  runApp(
    MaterialApp(
      routes: {
        '/signup': (context) => SignUpScreen(),
        '/login' : (context) => LoginScreen(),
      },
      home: userId != null ? MyApp() : LoginScreen(),
      // home: LoginScreen(),
    )
  );
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
  void initState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      var androidNotiDetails = AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
      );
      var details =
      NotificationDetails(android: androidNotiDetails);
      if (notification != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          details,
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(message);
    });
    super.initState();
  }

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
