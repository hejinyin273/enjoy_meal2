
import '../../../config/constants.dart';
import '../../../data/model/language.dart';

class DishMakeDto {
  late int batchNumber;
  late String orderNumber;
  late String tableNumber;
  late String orderTime;

  List<DishMakeInfo> dishMakeInfos = [];

  DishMakeDto.fromJson(Map<String, dynamic> json) {
    batchNumber = json["batchNumber"];
    orderNumber = json["orderNumber"];
    tableNumber = json["tableNumber"];
    orderTime = json["orderTime"];

    if (json['dishMakeInfos'] != null) {
      dishMakeInfos = [];
      json['dishMakeInfos'].forEach((v) {
        dishMakeInfos.add(DishMakeInfo.fromJson(v));
      });
    }
  }
}

class DishMakeInfo {
  late int id;
  late String dishNameZh;
  late String dishNameJa;
  late String dishNameEn;
  late int status; ///状态 -1删除 0为待制作，1为待出餐，2为已出餐
  late int quantity;
  late int? orderPackageId;
  late int orderMode; ///0单点 1套餐 2自助餐 orderMode=2时为自助餐 自助餐为一组
  late String dishSimpleName;
  late String? orderTime;
  late String? orderNumber;
  late String? tableNumber;
  late int categoryId;
  late int orderDetailId;
  List<DishAttribute> dishAttributes = [];

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
    if (Language.zh == Conf.selectedLanguage) {
      return attributeNameZh;
    } else if (Language.jp == Conf.selectedLanguage) {
      return attributeNameJa;
    } else {
      return attributeNameEn;
    }
  }
}
