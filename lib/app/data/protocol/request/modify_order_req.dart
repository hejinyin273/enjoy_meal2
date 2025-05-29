

class ModifyOrderReq{
  int tableId;

  List<PackageOrderReq>? packageOrderReqs;
  List<DishOrderReq>? dishOrderReqs;
  List<BuffetOrderReq>? buffetOrderReqs;

  ModifyOrderReq(this.tableId);

  Map<String, dynamic> toMap()  {
    Map<String, dynamic> baseMap = {
      "tableId": tableId
    };

    if (packageOrderReqs != null && packageOrderReqs!.isNotEmpty) {
      List<Map<String, dynamic>> dataList = [];
      for (var item in packageOrderReqs!) {
        dataList.add(item.toMap());
      }
      baseMap["packageOrderReqs"] = dataList;
    }

    if (dishOrderReqs != null && dishOrderReqs!.isNotEmpty) {
      List<Map<String, dynamic>> dataList = [];
      for (var item in dishOrderReqs!) {
        dataList.add(item.toMap());
      }
      baseMap["dishOrderReqs"] = dataList;
    }

    if (buffetOrderReqs != null && buffetOrderReqs!.isNotEmpty) {
      List<Map<String, dynamic>> dataList = [];
      for (var item in buffetOrderReqs!) {
        dataList.add(item.toMap());
      }
      baseMap["buffetOrderReqs"] = dataList;
    }

    return baseMap;
  }
}

class PackageOrderReq {
  int orderPackageId;
  int packageQuantity;

  PackageOrderReq(this.orderPackageId, this.packageQuantity);

  Map<String, dynamic> toMap() => {
    "orderPackageId": orderPackageId,
    "packageQuantity": packageQuantity
  };
}

class DishOrderReq {
  int orderDishId;
  int quantity;

  DishOrderReq(this.orderDishId, this.quantity);

  Map<String, dynamic> toMap() => {
    "orderDishId": orderDishId,
    "quantity": quantity
  };

}

class BuffetOrderReq {
  int orderBuffetId;
  int totalDinerCount;

  BuffetOrderReq(this.orderBuffetId, this.totalDinerCount);

  Map<String, dynamic> toMap() => {
    "orderBuffetId": orderBuffetId,
    "totalDinerCount": totalDinerCount
  };

}

