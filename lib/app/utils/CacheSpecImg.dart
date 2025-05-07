

import 'package:flutter/material.dart';

class CacheSpecImg{

  static AssetImage? assetImage;

  static Future<AssetImage> loadPrecacheImage(String imagePath, BuildContext context) async {
    // 预加载图片
    await precacheImage(AssetImage(imagePath), context);
    assetImage = AssetImage(imagePath);
    return assetImage!;
  }
}