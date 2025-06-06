

import 'package:flutter/services.dart';

import '../data/event_bus.dart';

class AndroidHelper {
  static const MethodChannel _helperChannel = MethodChannel("com.kinjos.meal.enjoy_meal/helper");
  static const EventChannel _eventChannel = EventChannel("com.kinjos.meal.enjoy_meal/eventMsg");

  static void initAndroid(){
    _helperChannel.setMethodCallHandler((call) {
      return Future.value();
    });

    _eventChannel.receiveBroadcastStream().listen((event) async {
      print("receiveBroadcastStream() $event");
      handleReceiveStream(event.toString());
    });
  }

  static void handleReceiveStream(String event) {
    if (event == "HelperInstalled") {
      eventBus.fire(InstallHelperStatus(status: 0));
    } else if (event == "HelperInstallFailed") {
      eventBus.fire(InstallHelperStatus(status: 1));
    } else if (event.startsWith("PrinterConnected")) {
      eventBus.fire(event);
    }
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