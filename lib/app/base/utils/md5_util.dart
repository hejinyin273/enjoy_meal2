
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

class Md5Util{
  static String generateMd5(String data) {
    var content = const Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return digest.toString();
  }

  static Future<String> getFileMD5(String filePath) async {
    final file = File(filePath);
    final digest = await md5.bind(file.openRead()).first;
    return digest.toString();
  }
}