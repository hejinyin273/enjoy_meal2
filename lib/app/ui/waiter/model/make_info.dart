
import 'package:enjoy_meal/app/base/utils/common_util.dart';

import '../../../config/constants.dart';
import '../../../data/model/language.dart';

class DishMakeDto {
  late int batchNumber;
  late String orderNumber;
  late String tableNumber;
  late String orderTime;
  int? buffetDinerCount;

  List<DishMakeInfo> dishMakeInfos = [];

  ///custom for new combination data
  List<dynamic> dishMakeInfoClassList = [];
  DateTime? orderDateTime;

  DishMakeDto.fromJson(Map<String, dynamic> json) {
    batchNumber = json["batchNumber"];
    orderNumber = json["orderNumber"];
    tableNumber = json["tableNumber"];
    orderTime = json["orderTime"];
    buffetDinerCount = json["buffetDinerCount"];

    if (json['dishMakeInfos'] != null) {
      dishMakeInfos = [];
      json['dishMakeInfos'].forEach((v) {
        dishMakeInfos.add(DishMakeInfo.fromJson(v));
      });
    }
  }

  String getOrderWaitTime() {
    if (orderDateTime != null) {
      final dateTime = DateTime.now();
      final duration = dateTime.difference(orderDateTime!);
      if (duration.inHours > 0) {
        return CommonUntil.formatDuration(duration);
      } else {
        int totalSeconds = duration.inSeconds;
        int minutes = totalSeconds ~/ 60;
        //int seconds = totalSeconds % 60;
        String formattedTime = '$minutes\'';
        return formattedTime;
      }
    }
    return "";
  }

  int getOrderWaitMinute() {
    if (orderDateTime != null) {
      final dateTime = DateTime.now();
      final duration = dateTime.difference(orderDateTime!);
      return duration.inMinutes;
    }
    return 0;
  }
}

class DishMakeInfo {
  late int id;
  late String dishNameZh;
  late String dishNameJa;
  late String dishNameEn;
  late int status; ///状态 -1删除 0为待制作，1为待出餐，2为已出餐
  late int quantity;
  late int? orderPackageId;///套餐订单id 套餐id相同的为一组   orderMode为0或2时为空
  late int orderMode; ///0单点 1套餐 2自助餐 orderMode=2时为自助餐 自助餐为一组
  late String dishSimpleName;
  late String? orderTime;
  late String? orderNumber;
  late String? tableNumber;
  late int categoryId;
  late int orderDetailId;
  List<DishAttribute> dishAttributes = [];

  ///custom for package category name
  String? categoryName;

  DishMakeInfo.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    dishNameZh = json["dishNameZh"];
    dishNameJa = json["dishNameJa"];
    dishNameEn = json["dishNameEn"];
    status = json["status"];
    quantity = json["quantity"];
    orderPackageId = json["orderPackageId"];
    orderMode = json["orderMode"];
    dishSimpleName = json["dishSimpleName"];

    orderTime = json["orderTime"];
    orderNumber = json["orderNumber"];
    tableNumber = json["tableNumber"];
    categoryId = json["categoryId"];
    orderDetailId = json["orderDetailId"];

    if (json['dishAttributes'] != null) {
      dishAttributes = [];
      json['dishAttributes'].forEach((v) {
        dishAttributes.add(DishAttribute.fromJson(v));
      });
    }
  }

  String getDishName() {
    if (Language.zh == Conf.selectedLanguage) {
      return dishNameZh;
    } else if (Language.jp == Conf.selectedLanguage) {
      return dishNameJa;
    } else {
      return dishNameEn;
    }
  }
}

class DishAttribute {
  int id;
  String attributeNameZh;
  String attributeNameJa;
  String attributeNameEn;
  String attributeSimpleName;

  DishAttribute.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        attributeNameZh = json["attributeNameZh"],
        attributeNameJa = json["attributeNameJa"],
        attributeNameEn = json["attributeNameEn"],
        attributeSimpleName = json["attributeSimpleName"];

  String getAttributeName() {
    if (attributeSimpleName.isNotEmpty) {
      return attributeSimpleName;
    }
    if (Language.zh == Conf.selectedLanguage) {
      return attributeNameZh;
    } else if (Language.jp == Conf.selectedLanguage) {
      return attributeNameJa;
    } else {
      return attributeNameEn;
    }
  }
}

class DishMakeInfoConf {
  ///int status; ///状态 -1删除 0为待制作，1为待出餐，2为已出餐
  static const int statusDel = -1;
  static const int statusWaitToMake = 0;
  static const int statusWaitToServe = 1;
  static const int statusServed = 2;
}
