
import 'package:enjoy_meal/app/config/constants.dart';

import 'language.dart';

class RestaurantResp{
  int status;
  String message;
  dynamic data;

  RestaurantResp.fromJson(Map<String, dynamic> json)
    : status = json["status"],
    message = json["message"],
    data = json["data"];
}

class RestaurantData {
  List<dynamic> resourceUrls = [];
  late RestaurantBaseInfo restaurantBaseInfo;
  List<CategoryInfo> categoryInfos = [];
  BuffetInfo? buffetInfo;
  List<CallStaffInfo> callStaffInfos = [];
  List<TableInfo> tableInfos = [];
  late TableInfo currentTable;
  List<RestaurantTopLayoutInfo> restaurantTopLayoutInfos = [];

  RestaurantData.fromJson(Map<String, dynamic> json) {
    resourceUrls = json["resourceUrls"];
    restaurantBaseInfo = RestaurantBaseInfo.fromJson(json["restaurantBaseInfo"]);
    currentTable = TableInfo.fromJson(json["currentTable"]);

    if (json['categoryInfos'] != null) {
      categoryInfos = [];
      json['categoryInfos'].forEach((v) {
        categoryInfos.add(CategoryInfo.fromJson(v));
      });
    }

    if (json["buffetInfo"] != null) {
      buffetInfo = BuffetInfo.fromJson(json["buffetInfo"]);
    }

    if (json['callStaffInfos'] != null) {
      callStaffInfos = [];
      json['callStaffInfos'].forEach((v) {
        callStaffInfos.add(CallStaffInfo.fromJson(v));
      });
    }

    if (json['tableInfos'] != null) {
      tableInfos = [];
      json['tableInfos'].forEach((v) {
        tableInfos.add(TableInfo.fromJson(v));
      });
    }

    if (json['restaurantTopLayoutInfos'] != null) {
      restaurantTopLayoutInfos = [];
      json['restaurantTopLayoutInfos'].forEach((v) {
        restaurantTopLayoutInfos.add(RestaurantTopLayoutInfo.fromJson(v));
      });
    }
  }

  int? getTableId(String tableNumber) {
    for (var tableInfo in tableInfos) {
      if (tableInfo.tableNumber == tableNumber) {
        return tableInfo.id;
      }
    }
    return null;
  }

}

class RestaurantConf{
  ///custom -999自助
  static const int categoryBuffetId = -999;///-999自助

  ///0为6宮格，1为9宮格，2为12宮格
  static const int topLayoutMode_6 = 0;
  static const int topLayoutMode_9 = 1;
  static const int topLayoutMode_12 = 2;

  ///分类类型 0下面是分类 1下面是套餐 2下面是菜品
  static const int categoryTypeCategory = 0;
  static const int categoryTypePackage = 1;
  static const int categoryTypeDish = 2;
  static const int categoryTypeBuffet = -999;///-999自助

  ///显示模式，0表示4宫格，1表示6宫格
  static const int displayMode_4 = 0;
  static const int displayMode_6 = 1;

  ///套餐类型，0表示步骤选择型套餐，1表示集合型套餐
  static const int packageTypeStepSelect = 0;
  static const int packageTypeCollective = 1;

  static const int requireTypeOptional = 0;
  static const int requireTypeMust = 1;

  static const int userTypeWaiter = 0;
  static const int userTypeCooker = 1;
  static const int userTypeUser = 2;
}

class RestaurantBaseInfo{
  int id;
  String restaurantNameZh;
  String restaurantNameJa;
  String restaurantNameEn;
  String? restaurantWelcomeMsgZh;
  String? restaurantWelcomeMsgJa;
  String? restaurantWelcomeMsgEn;
  String? restaurantTipsZh;
  String? restaurantTipsJa;
  String? restaurantTipsEn;
  String? restaurantBusinessTimeZh;
  String? restaurantBusinessTimeJa;
  String? restaurantBusinessTimeEn;

  String addressZh;
  String addressJa;
  String addressEn;
  String contactName;
  String contactPhone;
  int topLayoutMode; ///0为6宮格，1为9宮格，2为12宮格
  String? homeBgImage;

  String selectionBgImage;
  String callStaffBgImage;

  String packageSelectionBgImage;
  String buffetModeBgImage;
  String buffetDinerCountBgImage;
  String shoppingCartBgImage;
  String orderBgImage;
  int hasBuffet;
  int appVersionId;
  int buffetDiningTime; ///自助餐默认用餐时间（分钟），默认120分钟）
  int? buffetLastReminderTime;
  String? buffetCategoryDescriptionJa;
  String? buffetCategoryDescriptionZh;
  String? buffetCategoryDescriptionEn;
  String? buffetSimpleName;

  RestaurantBaseInfo.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        restaurantNameZh = json["restaurantNameZh"],
        restaurantNameJa = json["restaurantNameJa"],
        restaurantNameEn = json["restaurantNameEn"],
        restaurantWelcomeMsgZh = json["restaurantWelcomeMsgZh"],
        restaurantWelcomeMsgJa = json["restaurantWelcomeMsgJa"],
        restaurantWelcomeMsgEn = json["restaurantWelcomeMsgEn"],
        restaurantTipsZh = json["restaurantTipsZh"],
        restaurantTipsJa = json["restaurantTipsJa"],
        restaurantTipsEn = json["restaurantTipsEn"],
        restaurantBusinessTimeZh = json["restaurantBusinessTimeZh"],
        restaurantBusinessTimeJa = json["restaurantBusinessTimeJa"],
        restaurantBusinessTimeEn = json["restaurantBusinessTimeEn"],
        addressZh = json["addressZh"],
        addressJa = json["addressJa"],
        addressEn = json["addressEn"],
        contactName = json["contactName"],
        contactPhone = json["contactPhone"],
        homeBgImage = json["homeBgImage"],
        topLayoutMode = json["topLayoutMode"],
        selectionBgImage = json["selectionBgImage"],
        callStaffBgImage = json["callStaffBgImage"],

        packageSelectionBgImage = json["packageSelectionBgImage"],
        buffetModeBgImage = json["buffetModeBgImage"],
        buffetDinerCountBgImage = json["buffetDinerCountBgImage"],
        shoppingCartBgImage = json["shoppingCartBgImage"],
        orderBgImage = json["orderBgImage"],
        hasBuffet = json["hasBuffet"],
        appVersionId = json["appVersionId"],
        buffetDiningTime = json["buffetDiningTime"],
        buffetLastReminderTime = json["buffetLastReminderTime"],
        buffetCategoryDescriptionJa = json["buffetCategoryDescriptionJa"],
        buffetCategoryDescriptionZh = json["buffetCategoryDescriptionZh"],
        buffetCategoryDescriptionEn = json["buffetCategoryDescriptionEn"],
        buffetSimpleName = json["buffetSimpleName"];

  String getRestaurantName() {
    if (Language.zh == Conf.selectedLanguage) {
      return restaurantNameZh;
    } else if (Language.jp == Conf.selectedLanguage) {
      return restaurantNameJa;
    } else {
      return restaurantNameEn;
    }
  }

  String getRestaurantWelcomeMsg() {
    if (Language.zh == Conf.selectedLanguage) {
      return restaurantWelcomeMsgZh??"";
    } else if (Language.jp == Conf.selectedLanguage) {
      return restaurantWelcomeMsgJa??"";
    } else {
      return restaurantWelcomeMsgEn??"";
    }
  }

  String getRestaurantTips() {
    if (Language.zh == Conf.selectedLanguage) {
      return restaurantTipsZh??"";
    } else if (Language.jp == Conf.selectedLanguage) {
      return restaurantTipsJa??"";
    } else {
      return restaurantTipsEn??"";
    }
  }

  String getRestaurantBusinessTime() {
    if (Language.zh == Conf.selectedLanguage) {
      return restaurantBusinessTimeZh??"";
    } else if (Language.jp == Conf.selectedLanguage) {
      return restaurantBusinessTimeJa??"";
    } else {
      return restaurantBusinessTimeEn??"";
    }
  }

  String getBuffetCategoryDesc() {
    if (Language.zh == Conf.selectedLanguage) {
      return buffetCategoryDescriptionZh??"";
    } else if (Language.jp == Conf.selectedLanguage) {
      return buffetCategoryDescriptionJa??"";
    } else {
      return buffetCategoryDescriptionEn??"";
    }
  }
}

class CategoryInfo {
  late int id;
  late String categoryNameZh;
  late String categoryNameJa;
  late String categoryNameEn;
  String? descriptionZh;
  String? descriptionJa;
  String? descriptionEn;
  late String? bgImage;
  late int categoryType;///分类类型 0下面是分类 1下面是套餐 2下面是菜品，-999自助
  late int? parentId;
  late int displayMode;///显示模式，0表示4宫格，1表示6宫格
  String? validStartTime;///分类有效的时间段 默认为空
  String? validEndTime;///分类有效的时间段 默认为空
  int? startHour;
  int? startMinute;
  int? endHour;
  int? endMinute;

  List<CategoryInfo> children = [];
  List<DishInfo> dishList = [];
  PackageInfo? packageInfo;


  CategoryInfo(this.id, this.categoryNameZh, this.categoryNameJa,
      this.categoryNameEn, this.categoryType, this.displayMode);

  CategoryInfo.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    categoryNameZh = json["categoryNameZh"];
    categoryNameJa = json["categoryNameJa"];
    categoryNameEn = json["categoryNameEn"];
    descriptionZh = json["descriptionZh"];
    descriptionJa = json["descriptionJa"];
    descriptionEn = json["descriptionEn"];
    bgImage = json["bgImage"];
    categoryType = json["categoryType"];
    parentId = json["parentId"];
    displayMode = json["displayMode"];
    validStartTime = json["validStartTime"];
    validEndTime = json["validEndTime"];

    if (json['children'] != null) {
      children = [];
      json['children'].forEach((v) {
        children.add(CategoryInfo.fromJson(v));
      });
    }

    if (json['dishList'] != null) {
      dishList = [];
      json['dishList'].forEach((v) {
        dishList.add(DishInfo.fromJson(v));
      });
    }

    packageInfo = json["packageInfo"] != null ? PackageInfo.fromJson(json["packageInfo"]) : null;
  }

  String getCategoryName() {
    if (Language.zh == Conf.selectedLanguage) {
      return categoryNameZh;
    } else if (Language.jp == Conf.selectedLanguage) {
      return categoryNameJa;
    } else {
      return categoryNameEn;
    }
  }

  String? getCategoryDesc() {
    if (Language.zh == Conf.selectedLanguage) {
      return descriptionZh;
    } else if (Language.jp == Conf.selectedLanguage) {
      return descriptionJa;
    } else {
      return descriptionEn;
    }
  }

}

class PackageInfo {
  late int id;
  late String packageNameZh;
  late String packageNameJa;
  late String packageNameEn;
  late String? simpleName;
  late int? categoryId;
  late double price;
  late int? packageType;///套餐类型，0表示步骤选择型套餐，1表示集合型套餐
  late String? bgImage;
  late int? minSalesQuantity;///套餐最小销售数量，null表示没有限制-非空时用于区分数量选择
  late int isAvailable; ///上架状态 1上架 0下加
  bool get available => isAvailable == 1;

  List<DishInfo> dishList = [];
  List<PackageCategoryInfo> packageCategoryInfos = [];

  PackageInfo.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    packageNameZh = json["packageNameZh"];
    packageNameJa = json["packageNameJa"];
    packageNameEn = json["packageNameEn"];
    simpleName = json["simpleName"];
    categoryId = json["categoryId"];
    price = json["price"];
    packageType = json["packageType"];
    bgImage = json["bgImage"];
    minSalesQuantity = json["minSalesQuantity"];
    isAvailable = json["isAvailable"];

    if (json['dishList'] != null) {
      dishList = [];
      json['dishList'].forEach((v) {
        dishList.add(DishInfo.fromJson(v));
      });
    }

    if (json['packageCategoryInfos'] != null) {
      packageCategoryInfos = [];
      json['packageCategoryInfos'].forEach((v) {
        packageCategoryInfos.add(PackageCategoryInfo.fromJson(v));
      });
    }
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
}

class PackageCategoryInfo {
  late int id;
  late String categoryNameZh;
  late String categoryNameJa;
  late String categoryNameEn;
  late int packageId;
  late int maxSelection;///选择菜品的上限
  late int showImageFlag;///是否显示图片的标志 0 不显示
  List<DishInfo> dishList = [];

  PackageCategoryInfo.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    categoryNameZh = json["categoryNameZh"];
    categoryNameJa = json["categoryNameJa"];
    categoryNameEn = json["categoryNameEn"];
    packageId = json["packageId"];
    maxSelection = json["maxSelection"];
    showImageFlag = json["showImageFlag"];

    if (json['dishList'] != null) {
      dishList = [];
      json['dishList'].forEach((v) {
        dishList.add(DishInfo.fromJson(v));
      });
    }
  }

  String getCategoryName() {
    if (Language.zh == Conf.selectedLanguage) {
      return categoryNameZh;
    } else if (Language.jp == Conf.selectedLanguage) {
      return categoryNameJa;
    } else {
      return categoryNameEn;
    }
  }
}

class DishInfo {
  late int id;
  late String dishNameZh;
  late String dishNameJa;
  late String dishNameEn;
  late String simpleName;///菜品简易名称
  late double price; ///菜品价格
  late String? thumbnailUrl;
  late String? detailImageUrl;
  late int sales; ///销量
  late int dishOwnId;
  late int? inventoryQuantity; ///库存数量 null为无上限
  late int? buffetMaxQuantity;///自助餐模式下最大下单数量 null为无上限
  late int isAvailable; ///上架状态 1上架 0下加
  List<DishAttributeCategoryInfo> dishAttributeCategoryInfos = [];
  ///for custom packageCategoryInfo.id
  int? packageId;
  int? packageCategoryId;
  int? mainCategoryId;
  bool flyToCartAnim = true;
  bool get available => isAvailable == 1;

  bool get hasThumbnailUrl => (thumbnailUrl != null && thumbnailUrl!.isNotEmpty);

  DishInfo.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    dishNameZh = json["dishNameZh"];
    dishNameJa = json["dishNameJa"];
    dishNameEn = json["dishNameEn"];
    simpleName = json["simpleName"];
    price = json["price"];
    thumbnailUrl = json["thumbnailUrl"];
    detailImageUrl = json["detailImageUrl"];
    sales = json["sales"];
    dishOwnId = json["dishOwnId"];
    inventoryQuantity = json["inventoryQuantity"];
    buffetMaxQuantity = json["buffetMaxQuantity"];
    isAvailable = json["isAvailable"];

    if (json['dishAttributeCategoryInfos'] != null) {
      dishAttributeCategoryInfos = [];
      json['dishAttributeCategoryInfos'].forEach((v) {
        dishAttributeCategoryInfos.add(DishAttributeCategoryInfo.fromJson(v));
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

class DishAttributeCategoryInfo{
  late int id;
  late String attributeCategoryNameZh;
  late String attributeCategoryNameJa;
  late String attributeCategoryNameEn;
  late int maxSelection;///最多可选择的数量，1表示单选，大于1表示可多选的具体数量
  late int isRequired;///是否必选，0为非必选，1为必选

  List<DishAttributeInfo> dishAttributeInfos = [];

  DishAttributeCategoryInfo.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    attributeCategoryNameZh = json["attributeCategoryNameZh"];
    attributeCategoryNameJa = json["attributeCategoryNameJa"];
    attributeCategoryNameEn = json["attributeCategoryNameEn"];
    maxSelection = json["maxSelection"];
    isRequired = json["isRequired"];

    if (json['dishAttributeInfos'] != null) {
      dishAttributeInfos = [];
      json['dishAttributeInfos'].forEach((v) {
        dishAttributeInfos.add(DishAttributeInfo.fromJson(v));
      });
    }
  }

  String getAttributeCategoryName() {
    if (Language.zh == Conf.selectedLanguage) {
      return attributeCategoryNameZh;
    } else if (Language.jp == Conf.selectedLanguage) {
      return attributeCategoryNameJa;
    } else {
      return attributeCategoryNameEn;
    }
  }

  bool isSamePrice() {
    double price = dishAttributeInfos.first.priceAdjustment;
    for (int i=1; i<dishAttributeInfos.length; i++) {
      if (price != dishAttributeInfos[i].priceAdjustment) {
        return false;
      }
    }
    return true;
  }

  @override
  String toString() {
    return 'DishAttributeCategoryInfo{id: $id, attributeCategoryNameZh: $attributeCategoryNameZh, attributeCategoryNameJa: $attributeCategoryNameJa, attributeCategoryNameEn: $attributeCategoryNameEn, dishAttributeInfos: $dishAttributeInfos}';
  }
}

class DishAttributeInfo{
  int id;
  String attributeNameZh;
  String attributeNameJa;
  String attributeNameEn;
  dynamic priceAdjustment;///价格調整値

  DishAttributeInfo.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        attributeNameZh = json["attributeNameZh"],
        attributeNameJa = json["attributeNameJa"],
        attributeNameEn = json["attributeNameEn"],
        priceAdjustment = json["priceAdjustment"]??0;

  String getAttributeName() {
    if (Language.zh == Conf.selectedLanguage) {
      return attributeNameZh;
    } else if (Language.jp == Conf.selectedLanguage) {
      return attributeNameJa;
    } else {
      return attributeNameEn;
    }
  }

  @override
  String toString() {
    return 'DishAttributeInfo{id: $id, attributeNameZh: $attributeNameZh, attributeNameJa: $attributeNameJa, attributeNameEn: $attributeNameEn, priceAdjustment: $priceAdjustment}';
  }
}

class BuffetInfo {
  List<BuffetCategoryInfo> buffetCategoryInfos = [];

  BuffetInfo.fromJson(Map<String, dynamic> json) {
    if (json['buffetCategoryInfos'] != null) {
      buffetCategoryInfos = [];
      json['buffetCategoryInfos'].forEach((v) {
        buffetCategoryInfos.add(BuffetCategoryInfo.fromJson(v));
      });
    }
  }
}

class BuffetCategoryInfo {
  late int id;
  late String buffetCategoryNameZh;
  late String buffetCategoryNameJa;
  late String buffetCategoryNameEn;
  late String priceDescriptionZh;
  late String priceDescriptionJa;
  late String priceDescriptionEn;
  late String buffetCategoryDescriptionZh;
  late String buffetCategoryDescriptionJa;
  late String buffetCategoryDescriptionEn;
  late String imageUrl;
  late double showPrice;

  List<BuffetPriceInfo> buffetPriceInfos = [];
  List<dynamic> availableCategoryIds = [];
  List<dynamic> availableDishIds = [];

  BuffetCategoryInfo.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    buffetCategoryNameZh = json["buffetCategoryNameZh"];
    buffetCategoryNameJa = json["buffetCategoryNameJa"];
    buffetCategoryNameEn = json["buffetCategoryNameEn"];
    priceDescriptionZh = json["priceDescriptionZh"];
    priceDescriptionJa = json["priceDescriptionJa"];
    priceDescriptionEn = json["priceDescriptionEn"];
    buffetCategoryDescriptionZh = json["buffetCategoryDescriptionZh"];
    buffetCategoryDescriptionJa = json["buffetCategoryDescriptionJa"];
    buffetCategoryDescriptionEn = json["buffetCategoryDescriptionEn"];
    imageUrl = json["imageUrl"];
    showPrice = json["showPrice"];
    availableCategoryIds = json["availableCategoryIds"];
    availableDishIds = json["availableDishIds"];

    if (json['buffetPriceInfos'] != null) {
      buffetPriceInfos = [];
      json['buffetPriceInfos'].forEach((v) {
        buffetPriceInfos.add(BuffetPriceInfo.fromJson(v));
      });
    }
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

  String getBuffetCategoryDescription() {
    if (Language.zh == Conf.selectedLanguage) {
      return buffetCategoryDescriptionZh;
    } else if (Language.jp == Conf.selectedLanguage) {
      return buffetCategoryDescriptionJa;
    } else {
      return buffetCategoryDescriptionEn;
    }
  }

  String getPriceDescription() {
    if (Language.zh == Conf.selectedLanguage) {
      return priceDescriptionZh;
    } else if (Language.jp == Conf.selectedLanguage) {
      return priceDescriptionJa;
    } else {
      return priceDescriptionEn;
    }
  }
}

class BuffetPriceInfo {
  int id;
  String dinerTypeNameZh;
  String dinerTypeNameJa;
  String dinerTypeNameEn;
  double price;
  double overtimeExtraFee;
  int minDinerCount;

  BuffetPriceInfo.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        dinerTypeNameZh = json["dinerTypeNameZh"],
        dinerTypeNameJa = json["dinerTypeNameJa"],
        dinerTypeNameEn = json["dinerTypeNameEn"],
        price = json["price"],
        overtimeExtraFee = json["overtimeExtraFee"],
        minDinerCount = json["minDinerCount"]??0;

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

class CallStaffInfo {
  int id;
  int restaurantId;
  String? callContentZh;
  String? callContentJa;
  String? callContentEn;
  int sortNo;

  CallStaffInfo.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        restaurantId = json["restaurantId"],
        callContentZh = json["callContentZh"],
        callContentJa = json["callContentJa"],
        callContentEn = json["callContentEn"],
        sortNo = json["sortNo"];

  String getCallContent() {
    if (Language.zh == Conf.selectedLanguage) {
      return callContentZh??"";
    } else if (Language.jp == Conf.selectedLanguage) {
      return callContentJa??"";
    } else {
      return callContentEn??"";
    }
  }
}

class TableInfo {
  int? id;
  String? tableNumber;
  int? seatCount;
  int? orderId;
  int? boundUserId;
  String? boundUsername;
  int? boundUserType;///当前餐桌绑定的用户角色类型，0表示服务员，1表示厨房，2表示餐桌

  TableInfo(this.id, this.tableNumber);

  TableInfo.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        tableNumber = json["tableNumber"],
        seatCount = json["seatCount"],
        orderId = json["orderId"],
        boundUserId = json["boundUserId"],
        boundUsername = json["boundUsername"],
        boundUserType = json["boundUserType"];
}

class RestaurantTopLayoutInfo{
  int id;
  String? imageUrl;
  int? categoryId;
  int isBuffetButton;
  int position;
  String? categoryNameZh;
  String? categoryNameJa;
  String? categoryNameEn;
  String? bgImage;

  RestaurantTopLayoutInfo.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        imageUrl = json["imageUrl"],
        categoryId = json["categoryId"],
        isBuffetButton = json["isBuffetButton"],
        position = json["position"],
        categoryNameZh = json["categoryNameZh"],
        categoryNameJa = json["categoryNameJa"],
        categoryNameEn = json["categoryNameEn"],
        bgImage = json["bgImage"];

  String getCategoryName() {
    if (Language.zh == Conf.selectedLanguage) {
      return categoryNameZh??"";
    } else if (Language.jp == Conf.selectedLanguage) {
      return categoryNameJa??"";
    } else {
      return categoryNameEn??"";
    }
  }
}

class HotDish{
  late int primaryCategoryId;
  late String categoryNameZh;
  late String categoryNameJa;
  late String categoryNameEn;
  List<DishInfo> dishInfos = [];

  HotDish.fromJson(Map<String, dynamic> json) {
    primaryCategoryId = json["primaryCategoryId"];
    categoryNameZh = json["categoryNameZh"];
    categoryNameJa = json["categoryNameJa"];
    categoryNameEn = json["categoryNameEn"];

    if (json['dishInfos'] != null) {
      dishInfos = [];
      json['dishInfos'].forEach((v) {
        dishInfos.add(DishInfo.fromJson(v));
      });
    }
  }

  String getCategoryName() {
    if (Language.zh == Conf.selectedLanguage) {
      return categoryNameZh;
    } else if (Language.jp == Conf.selectedLanguage) {
      return categoryNameJa;
    } else {
      return categoryNameEn;
    }
  }
}