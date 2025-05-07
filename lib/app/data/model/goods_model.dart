

import 'package:enjoy_meal/app/data/model/restaurant_data.dart';

import '../protocol/request/submit_order_req.dart';

class DishOrderModel{
  int quantity;
  DishInfo dishInfo;
  int? mainCategoryId;
  List<DishAttributeInfo> dishAttributeInfoList = [];

  DishOrderModel(this.quantity, this.dishInfo, this.dishAttributeInfoList, {this.mainCategoryId});

  String getAttributeDesc() {
    if (dishAttributeInfoList.isNotEmpty) {
      return dishAttributeInfoList.first.getAttributeName();
    }
    return "";
  }

  double getTotalPrice() {
    double totalPrice = 0;
    if (dishInfo.available) {
      totalPrice += (dishInfo.price * quantity);
      for (int j = 0; j < dishAttributeInfoList.length; j++) {
        final attrInfo = dishAttributeInfoList[j];
        if (attrInfo.priceAdjustment != null) {
          totalPrice += ((attrInfo.priceAdjustment as double) * quantity);
        }
      }
    }

    return totalPrice;
  }

  DishOrderReq getDishOrderReq() {
    List<int> dishAttributeIds = [];
    for (var item in dishAttributeInfoList) {
      dishAttributeIds.add(item.id);
    }
    final orderReq = DishOrderReq(dishInfo.id, quantity, dishAttributeIds);
    return orderReq;
  }
}

class PackageOrderModel{
  int quantity;
  PackageInfo packageInfo;
  List<DishOrderModel> dishOrderModelList;
  int mainCategoryId;

  PackageOrderModel(this.quantity, this.packageInfo, this.mainCategoryId, this.dishOrderModelList);

  int getTotalItemCount() {
    int attributeCount = 0;
    for(int i=0; i<dishOrderModelList.length; i++) {
      attributeCount += dishOrderModelList[i].dishAttributeInfoList.length;
    }
    return dishOrderModelList.length + attributeCount + 1;
  }

  List<dynamic> getAnnotationList() {
    List<dynamic> annotationList = [];
    for(int i=0; i<dishOrderModelList.length; i++) {
      final item = dishOrderModelList[i];
      annotationList.add(item.dishInfo);
      for(int j=0; j<item.dishAttributeInfoList.length; j++) {
        annotationList.add(item.dishAttributeInfoList[j]);
      }
    }
    return annotationList;
  }

  double getTotalPrice() {
    double totalPrice = 0;

    if (packageInfo.available) {
      totalPrice += (packageInfo.price * quantity);

      for(int k=0; k<dishOrderModelList.length; k++) {
        final dishInfo = dishOrderModelList[k];
        for (int j=0; j<dishInfo.dishAttributeInfoList.length; j++) {
          final attrInfo = dishInfo.dishAttributeInfoList[j];
          if (attrInfo.priceAdjustment != null ) {
            totalPrice += ((attrInfo.priceAdjustment as double) * quantity);
          }
        }
      }
    }
    return totalPrice;
  }

  PackageOrderReq getPackageOrderReq() {
    List<DishOrderReq> dishOrderReqList = [];
    for (var item in dishOrderModelList) {
      dishOrderReqList.add(item.getDishOrderReq());
    }
    final orderReq = PackageOrderReq(packageInfo.id, quantity, dishOrderReqList);
    return orderReq;
  }
}
