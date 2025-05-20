

import 'package:flutter/services.dart';

class AndroidHelper {
  static const MethodChannel _helperChannel = MethodChannel("com.kinjos.meal.enjoy_meal/helper");

  static void initAndroid(){
    _helperChannel.setMethodCallHandler((call) {
      return Future.value();
    });
  }

  static Future<bool> installApk(String filePath) async {
    try {
      final bool success = await _helperChannel.invokeMethod('installApk', filePath);
      return Future.value(success);
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return Future.value(false);
  }

  static Future<String> getVersionName() async {
    try {
      final String result = await _helperChannel.invokeMethod('getVersionName');
      return Future.value(result);
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return Future.value("0.0.0");
  }

  static Future<bool> execRuntimeCommand(String command) async {
    try {
      final bool success = await _helperChannel.invokeMethod('execRuntimeCommand', command);
      return Future.value(success);
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return Future.value(false);
  }

  static Future<bool> handleHostInstall(String filePath) async {
    try {
      final bool success = await _helperChannel.invokeMethod('handleHostInstall', filePath);
      return Future.value(success);
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return Future.value(false);
  }

  static Future<bool> checkAndInstallHelper() async {
    try {
      final bool success = await _helperChannel.invokeMethod('checkAndInstallHelper');
      return Future.value(success);
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return Future.value(false);
  }

  static Future<void> startPrinterMainActivity() async {
    try {
      await _helperChannel.invokeMethod('startPrinterMainActivity');
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  static Future<void> startSearchPrinterActivity() async {
    try {
      await _helperChannel.invokeMethod('startSearchPrinterActivity');
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  static Future<bool> isPrinterConnected() async {
    try {
      final bool success = await _helperChannel.invokeMethod('isPrinterConnected');
      return Future.value(success);
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return Future.value(false);
  }
}