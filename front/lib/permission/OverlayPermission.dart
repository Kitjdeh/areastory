import 'dart:io';
import 'package:flutter/services.dart';

class OverlayPermission {
  static Future<bool> canDrawOverlays() async {
    if (Platform.isAndroid) {
      final result = await MethodChannel("channel:canDrawOverlays")
          .invokeMethod('canDrawOverlays');
      return result;
    } else {
      return false;
    }
  }

  static Future<void> requestOverlayPermission() async {
    if (Platform.isAndroid) {
      await MethodChannel("channel:requestOverlayPermission")
          .invokeMethod('requestOverlayPermission');
    }
  }
}