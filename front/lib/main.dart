import 'package:flutter/material.dart';
import 'package:front/screen/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      // debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    ),
  );
}
