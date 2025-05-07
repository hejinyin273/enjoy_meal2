

class SubmitOrderReq{
  ///餐桌id
  int tableId;
  ///套餐订单
  List<PackageOrderReq>? packageOrderRequests;
  ///菜品订单
  List<DishOrderReq>? dishOrderRequests;
  ///自助餐订单
  List<BuffetOrderReq>? buffetOrderRequests;

  SubmitOrderReq(this.tableId);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> baseMap = {
      "tableId": tableId
    };

    if (packageOrderRequests != null && packageOrderRequests!.isNotEmpty) {
      List<Map<String, dynamic>> dataList = [];
      for (var item in packageOrderRequests!) {
        dataList.add(item.toMap());
      }
      baseMap["packageOrderRequests"] = dataList;
    }

    if (dishOrderRequests != null && dishOrderRequests!.isNotEmpty) {
      List<Map<String, dynamic>> dataList = [];
      for (var item in dishOrderRequests!) {
        dataList.add(item.toMap());
      }
      baseMap["dishOrderRequests"] = dataList;
    }

    if (buffetOrderRequests != null && buffetOrderRequests!.isNotEmpty) {
      List<Map<String, dynamic>> dataList = [];
      for (var item in buffetOrderRequests!) {
        dataList.add(item.toMap());
      }
      baseMap["buffetOrderRequests"] = dataList;
    }

    return baseMap;
  }

  @override
  String toString() {
    return 'SubmitOrderReq{tableId: $tableId, packageOrderRequests: $packageOrderRequests, dishOrderRequests: $dishOrderRequests, buffetOrderRequests: $buffetOrderRequests}';
  }
}

///套餐订单
class PackageOrderReq{
  int packageId;  ///套餐ID
  int packageQuantity;  ///套餐数量
  List<DishOrderReq> dishOrderRequests; ///套餐菜品ID

  PackageOrderReq(this.packageId, this.packageQuantity, this.dishOrderRequests);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> baseMap ={
      "packageId": packageId,
      "packageQuantity": packageQuantity
    };

    if (dishOrderRequests.isNotEmpty) {
      List<Map<String, dynamic>> dataList = [];
      for (var item in dishOrderRequests) {
        dataList.add(item.toMap());
      }
      baseMap["dishOrderRequests"] = dataList;
    }

    return baseMap;
  }

  @override
  String toString() {
    return 'PackageOrderReq{packageId: $packageId, packageQuantity: $packageQuantity, dishOrderRequests: $dishOrderRequests}';
  }
}

///菜品订单
class DishOrderReq{
  int dishId; ///菜品ID
  int quantity; ///菜品数量
  List<int> dishAttributeIds;

  DishOrderReq(this.dishId, this.quantity, this.dishAttributeIds);

  Map<String, dynamic> toMap() => {
    "dishId": dishId,
    "quantity": quantity,
    "dishAttributeIds": dishAttributeIds,
  };

  @override
  String toString() {
    return 'DishOrderReq{dishId: $dishId, quantity: $quantity, dishAttributeIds: $dishAttributeIds}';
  }
}

///自助餐订单
class BuffetOrderReq{
  int buffetPriceId;  ///自助餐价格ID
  int totalDinerCount;  ///自助餐人数
  //List<DishOrderReq> dishOrderReqs;

  BuffetOrderReq(this.buffetPriceId, this.totalDinerCount/*, this.dishOrderReqs*/);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> baseMap ={
      "buffetPriceId": buffetPriceId,
      "totalDinerCount": totalDinerCount
    };

    /*if (dishOrderReqs.isNotEmpty) {
      List<Map<String, dynamic>> dataList = [];
      for (var item in dishOrderReqs) {
        dataList.add(item.toMap());
      }
      baseMap["dishOrderReqs"] = dataList;
    }*/

    return baseMap;
  }

  @override
  String toString() {
    return 'BuffetOrderReq{buffetPriceId: $buffetPriceId, totalDinerCount: $totalDinerCount}';
  }
}