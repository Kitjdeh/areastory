// import 'dart:io';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:front/screen/home_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  // HttpOverrides.global =
  //     NoCheckCertificateHttpOverrides(); // 생성된 HttpOverrides 객체 등록
  /// 이게 뭐지?
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
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
