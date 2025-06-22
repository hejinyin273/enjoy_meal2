

import '../../../config/constants.dart';
import '../../model/language.dart';

class OrderDetailResp{
  late String orderNumber;
  late dynamic totalAmount;
  String? firstOrderTime;
  String? buffetEndTime;
  late String tableNumber;
  late int dinerCount;
  String? firstDishTime;	///首次上菜时间	string(date-time)
  late String firstFoodOrderTime;	///第一次点菜的时间
  late String restaurantNameZh;
  late String restaurantNameJa;
  late String restaurantNameEn;

  List<OrderDetailPackage> orderDetailPackages = [];
  List<OrderDetailBuffet> orderDetailBuffets = [];
  List<OrderDetailDish> orderDetailDishes = [];
  List<OrderDetailDish> buffetOrderDetailDishes = [];

  OrderDetailResp.fromJson(Map<String, dynamic> json) {
    orderNumber = json["orderNumber"];
    totalAmount = json["totalAmount"];
    firstOrderTime = json["firstOrderTime"];
    buffetEndTime = json["buffetEndTime"];
    tableNumber = json["tableNumber"];
    dinerCount = json["dinerCount"];
    firstDishTime = json["firstDishTime"]??"";
    firstFoodOrderTime = json["firstFoodOrderTime"];
    restaurantNameZh = json["restaurantNameZh"];
    restaurantNameJa = json["restaurantNameJa"];
    restaurantNameEn = json["restaurantNameEn"];

    if (json['orderDetailPackages'] != null) {
      orderDetailPackages = [];
      json['orderDetailPackages'].forEach((v) {
        orderDetailPackages.add(OrderDetailPackage.fromJson(v));
      });
    }

    if (json['orderDetailBuffets'] != null) {
      orderDetailBuffets = [];
      json['orderDetailBuffets'].forEach((v) {
        orderDetailBuffets.add(OrderDetailBuffet.fromJson(v));
      });
    }

    if (json['orderDetailDishes'] != null) {
      orderDetailDishes = [];
      json['orderDetailDishes'].forEach((v) {
        orderDetailDishes.add(OrderDetailDish.fromJson(v));
      });
    }

    if (json['buffetOrderDetailDishes'] != null) {
      buffetOrderDetailDishes = [];
      json['buffetOrderDetailDishes'].forEach((v) {
        buffetOrderDetailDishes.add(OrderDetailDish.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> baseJson = {
      "orderNumber": orderNumber,
      "totalAmount": totalAmount,
      "firstOrderTime": firstOrderTime,
      "buffetEndTime": buffetEndTime,
      "tableNumber": tableNumber,
      "dinerCount": dinerCount,
      "firstDishTime": firstDishTime,
      "firstFoodOrderTime": firstFoodOrderTime,
      "restaurantNameZh": restaurantNameZh,
      "restaurantNameJa": restaurantNameJa,
      "restaurantNameEn": restaurantNameEn,
    };

    if (orderDetailPackages.isNotEmpty) {
      List<Map<String, dynamic>> dataList = [];
      for (var item in orderDetailPackages) {
        dataList.add(item.toJson());
      }
      baseJson["orderDetailPackages"] = dataList;
    } else {
      baseJson["orderDetailPackages"] = [];
    }

    if (orderDetailBuffets.isNotEmpty) {
      List<Map<String, dynamic>> dataList = [];
      for (var item in orderDetailBuffets) {
        dataList.add(item.toJson());
      }
      baseJson["orderDetailBuffets"] = dataList;
    } else {
      baseJson["orderDetailBuffets"] = [];
    }

    if (orderDetailDishes.isNotEmpty) {
      List<Map<String, dynamic>> dataList = [];
      for (var item in orderDetailDishes) {
        dataList.add(item.toJson());
      }
      baseJson["orderDetailDishes"] = dataList;
    } else {
      baseJson["orderDetailDishes"] = [];
    }

    if (buffetOrderDetailDishes.isNotEmpty) {
      List<Map<String, dynamic>> dataList = [];
      for (var item in buffetOrderDetailDishes) {
        dataList.add(item.toJson());
      }
      baseJson["buffetOrderDetailDishes"] = dataList;
    } else {
      baseJson["buffetOrderDetailDishes"] = [];
    }

    return baseJson;
  }

  bool isOrderExist() {
    if (orderDetailPackages.isNotEmpty || orderDetailBuffets.isNotEmpty || orderDetailDishes.isNotEmpty) {
      return true;
    }
    return false;
  }

  bool isCommonOrder() {
    if (orderDetailPackages.isNotEmpty || orderDetailDishes.isNotEmpty) {
      return true;
    }
    return false;
  }

  bool isBuffetOrderExist() {
    if (orderDetailBuffets.isNotEmpty) {
      return true;
    }
    return false;
  }

  bool isInBuffetTime() {
    if (orderDetailBuffets.isNotEmpty) {///是自助订单
      if (firstOrderTime != null && buffetEndTime != null) {
        DateTime? startDateTime = DateTime.tryParse("$firstOrderTime:00");
        DateTime? endDateTime = DateTime.tryParse("$buffetEndTime:00");
        if (startDateTime != null && endDateTime != null && endDateTime.isAfter(DateTime.now())) {
          return true;
        }
      }
    }

    return false;
  }

}

class OrderDetailPackage{///套餐订单详情
  late int packageId;
  late int orderPackageId;
  late String packageNameZh;
  late String packageNameJa;
  late String packageNameEn;
  late int packageQuantity;
  late double unitPrice;
  List<OrderDetailDish> orderDetailDishes = [];

  OrderDetailPackage.fromJson(Map<String, dynamic> json) {
    packageId = json["packageId"];
    orderPackageId = json["orderPackageId"];
    packageNameZh = json["packageNameZh"];
    packageNameJa = json["packageNameJa"];
    packageNameEn = json["packageNameEn"];
    packageQuantity = json["packageQuantity"];
    unitPrice = json["unitPrice"];

    if (json['orderDetailDishes'] != null) {
      orderDetailDishes = [];
      json['orderDetailDishes'].forEach((v) {
        orderDetailDishes.add(OrderDetailDish.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> baseJson = {
      "packageId": packageId,
      "orderPackageId": orderPackageId,
      "packageNameZh": packageNameZh,
      "packageNameJa": packageNameJa,
      "packageNameEn": packageNameEn,
      "packageQuantity": packageQuantity,
      "unitPrice": unitPrice
    };

    if (orderDetailDishes.isNotEmpty) {
      List<Map<String, dynamic>> dataList = [];
      for (var item in orderDetailDishes) {
        dataList.add(item.toJson());
      }
      baseJson["orderDetailDishes"] = dataList;
    } else {
      baseJson["orderDetailDishes"] = [];
    }

    return baseJson;
  }

  String getPackageName() {
    if (Language.zh == Conf.selectedLanguage) {
      return packageNameZh;
    } else if (Language.jp == Conf.selectedLanguage) {
      return packageNameJa;
    } else {
      return packageNameEn;
    }
  }

  double getTotalPrice() {
    double totalPrice = 0;

    totalPrice += (unitPrice * packageQuantity);

    for(int k=0; k<orderDetailDishes.length; k++) {
      final dishInfo = orderDetailDishes[k];
      for (int j=0; j<dishInfo.dishAttrs.length; j++) {
        final attrInfo = dishInfo.dishAttrs[j];
        totalPrice += ((attrInfo.attributeUnitPrice) * packageQuantity);
      }
    }

    return totalPrice;
  }

}

class OrderDetailBuffet{///自助餐订单详情
  late int buffetCategoryId;
  late String buffetCategoryNameZh;
  late String buffetCategoryNameJa;
  late String buffetCategoryNameEn;
  List<OrderBuffetPriceDetail> orderBuffetPriceDetails = [];


  OrderDetailBuffet.fromJson(Map<String, dynamic> json) {
    buffetCategoryId = json["buffetCategoryId"];
    buffetCategoryNameZh = json["buffetCategoryNameZh"];
    buffetCategoryNameJa = json["buffetCategoryNameJa"];
    buffetCategoryNameEn = json["buffetCategoryNameEn"];

    if (json['orderBuffetPriceDetails'] != null) {
      orderBuffetPriceDetails = [];
      json['orderBuffetPriceDetails'].forEach((v) {
        orderBuffetPriceDetails.add(OrderBuffetPriceDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() => {
    "buffetCategoryId": buffetCategoryId,
    "buffetCategoryNameZh": buffetCategoryNameZh,
    "buffetCategoryNameJa": buffetCategoryNameJa,
    "buffetCategoryNameEn": buffetCategoryNameEn
  };

  double getItemTotalPrice() {
    double unitPrice = 0;
    for (var item in orderBuffetPriceDetails) {
      unitPrice += item.totalDinerCount * item.unitPrice;

      if (item.extraTimeCount > 0) {
        unitPrice += item.totalDinerCount * item.extraTimeCount * item.overtimeExtraFee;
      }
    }
    return unitPrice;
  }

  int getTotalDinerCount() {
    int totalCount = 0;
    for (var item in orderBuffetPriceDetails) {
      totalCount += item.totalDinerCount;
    }
    return totalCount;
  }

  String getBuffetCategoryName() {
    if (Language.zh == Conf.selectedLanguage) {
      return buffetCategoryNameZh;
    } else if (Language.jp == Conf.selectedLanguage) {
      return buffetCategoryNameJa;
    } else {
      return buffetCategoryNameEn;
    }
  }
}


class OrderBuffetPriceDetail{
  int buffetPriceId;
  int orderBuffetId;
  String dinerTypeNameZh;
  String dinerTypeNameJa;
  String dinerTypeNameEn;
  double unitPrice;///自助餐单价
  int totalDinerCount;///用餐人数
  int extraTimeCount;///加时次数
  double overtimeExtraFee;///加时单价

  OrderBuffetPriceDetail.fromJson(Map<String, dynamic> json)
      : buffetPriceId = json["buffetPriceId"],
        orderBuffetId = json["orderBuffetId"],
        dinerTypeNameZh = json["dinerTypeNameZh"],
        dinerTypeNameJa = json["dinerTypeNameJa"],
        dinerTypeNameEn = json["dinerTypeNameEn"],
        unitPrice = json["unitPrice"],
        totalDinerCount = json["totalDinerCount"],
        extraTimeCount = json["extraTimeCount"],
        overtimeExtraFee = json["overtimeExtraFee"];

  String getDinerTypeName() {
    if (Language.zh == Conf.selectedLanguage) {
      return dinerTypeNameZh;
    } else if (Language.jp == Conf.selectedLanguage) {
      return dinerTypeNameJa;
    } else {
      return dinerTypeNameEn;
    }
  }
}


class OrderDetailDish{
  late int orderDishId;
  late int id;
  late String dishNameZh;
  late String dishNameJa;
  late String dishNameEn;
  late String simpleName;
  late int dishQuantity;
  late double unitPrice;
  late int orderMode; ///订单模式 0单点 1套餐 2自助餐
  late int status; ///状态 0为待制作，1为待出餐，2为已出餐
  List<DishAttr> dishAttrs = [];

  OrderDetailDish.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    orderDishId = json["orderDishId"];
    dishNameZh = json["dishNameZh"];
    dishNameJa = json["dishNameJa"];
    dishNameEn = json["dishNameEn"];
    simpleName = json["simpleName"];
    dishQuantity = json["dishQuantity"];
    unitPrice = json["unitPrice"];
    orderMode = json["orderMode"];
    status = json["status"];

    if (json['dishAttrs'] != null) {
      dishAttrs = [];
      json['dishAttrs'].forEach((v) {
        dishAttrs.add(DishAttr.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> baseJson = {
      "orderDishId": orderDishId,
      "id": id,
      "dishNameZh": dishNameZh,
      "dishNameJa": dishNameJa,
      "dishNameEn": dishNameEn,
      "simpleName": simpleName,
      "dishQuantity": dishQuantity,
      "unitPrice": unitPrice,
      "orderMode": orderMode,
      "status": status
    };

    if (dishAttrs.isNotEmpty) {
      List<Map<String, dynamic>> dataList = [];
      for (var item in dishAttrs) {
        dataList.add(item.toJson());
      }
      baseJson["dishAttrs"] = dataList;
    } else {
      baseJson["dishAttrs"] = [];
    }

    return baseJson;
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

  String getStatusDesc() {
    if (status == 0) {
      return "待制作";
    } else if (status == 1) {
      return "待出餐";
    } else {
      return "已出餐";
    }
  }

  double getTotalPrice() {
    double totalPrice = 0;

    totalPrice += (unitPrice * dishQuantity);
    for (int j = 0; j < dishAttrs.length; j++) {
      final attrInfo = dishAttrs[j];
      totalPrice += ((attrInfo.attributeUnitPrice) * dishQuantity);
    }

    return totalPrice;
  }
}

class DishAttr{
  int id;
  String attributeNameZh;
  String attributeNameJa;
  String attributeNameEn;
  String simpleName;
  double attributeUnitPrice;

  DishAttr.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        attributeNameZh = json["attributeNameZh"],
        attributeNameJa = json["attributeNameJa"],
        attributeNameEn = json["attributeNameEn"],
        simpleName = json["simpleName"],
        attributeUnitPrice = json["attributeUnitPrice"];

  Map<String, dynamic> toJson() => {
    "id": id,
    "attributeNameZh": attributeNameZh,
    "attributeNameJa": attributeNameJa,
    "attributeNameEn": attributeNameEn,
    "simpleName": simpleName,
    "attributeUnitPrice": attributeUnitPrice
  };

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