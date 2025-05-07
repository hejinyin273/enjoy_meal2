
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'android_helper.dart';

class CommonUntil{

  static String checkMobilePhone(String phoneNumber) {
    if (phoneNumber.trim().isEmpty) return "手机号不能为空";
    if (phoneNumber.length < 11) return "手机号位数错误";
    if (!isChinaPhoneLegal(phoneNumber)) return "请输入正确的手机号";
    return "";
  }

  /// 是否中国大陆的手机号
  static bool isChinaPhoneLegal(String str) {
    return RegExp(
        '^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$')
        .hasMatch(str);
  }

  /// 数字字母下划线
  static bool isAccountLegal(String str) {
    return RegExp(
        r'^[a-zA-Z0-9\_]+$')
        .hasMatch(str);
  }

  /// 大写字母、小写字母、数字、特殊字符，两种及以上，且8-20位
  static bool isPwdLegal(String str) {
    return RegExp(
        r'^(?![A-Z]+$)(?![a-z]+$)(?!\d+$)(?![\W_]+$)\S{8,20}$')
        .hasMatch(str);
  }

  static bool isInt(String? s) {
    if (s == null || s.isEmpty || int.tryParse(s[0]) == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  static Future<String> getAppVersion() async{
    return AndroidHelper.getVersionName();
  }

  static List<int> hexStringToBytes(String hexString) {
    final length = hexString.length ~/ 2;
    final bytes = List<int>.filled(length, 0);
    for (int i = 0; i < length; i++) {
      final byteString = hexString.substring(i * 2, i * 2 + 2);
      bytes[i] = int.parse(byteString, radix: 16);
    }
    return bytes;
  }

  static String base64ToHexString(String base64) {
    var bytes = base64Decode(base64);
    StringBuffer hexString = StringBuffer();
    for (int i = 0; i < bytes.lengthInBytes; i++) {
      String hex = bytes[i].toRadixString(16).padLeft(2, '0');
      hexString.write(hex);
    }
    return hexString.toString();
  }

  static Future<String?> capturePng(GlobalKey paintKey, double compressionRatio, String dirPath) async {
    try {
      RenderRepaintBoundary? boundary = paintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      var image = await boundary?.toImage(pixelRatio: compressionRatio);
      ByteData? byteData = await image?.toByteData(format: ImageByteFormat.png);
      var imgFile = await File('$dirPath/${DateTime.now().millisecondsSinceEpoch}.png').create();
      Uint8List? pngBytes = byteData?.buffer.asUint8List();
      await imgFile.writeAsBytes(pngBytes!);
      return imgFile.path;
    } catch (e) {
      print(e);
    }
    return null;
  }

  static bool isSupportPhotoFormat(String fileName) {
    if (fileName.toLowerCase().endsWith("png") || fileName.toLowerCase().endsWith("jpg") ||  fileName.toLowerCase().endsWith("jpeg")) {
      return true;
    }
    return false;
  }

  static Future<String?> readJsonFile(String filePath) async {
    try {
      File file = File(filePath);
      return await file.readAsString();
    } catch (e) {
      return null;
    }
  }

  static Future<File> writeJsonFile(String filePath, String data) async {
    File file = File(filePath);
    return file.writeAsString(data);
  }

  static String formatDuration(Duration duration) {
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60)); // 获取分钟，保留两位数
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60)); // 获取秒，保留两位数
    String hours = twoDigits(duration.inHours); // 获取小时，保留两位数
    return '$hours:$twoDigitMinutes'; // 返回格式化的字符串
  }

  static String twoDigits(int n) {
    return n.toString().padLeft(2, '0'); // 使用padLeft确保至少有两个数字
  }

  static double measureTextLength(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: text,
        style: style,
      ),
    );
    textPainter.layout();
    return textPainter.width;
  }
}