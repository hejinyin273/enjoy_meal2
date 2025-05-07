

class PrepareOrderReq{
  int tableId;
  int userId;
  int dinerCount;
  ///订单类型，0为堂食，1为外带
  int orderType;

  PrepareOrderReq(this.tableId, this.userId, this.dinerCount, this.orderType);

  Map<String, dynamic> toMap() => {
    "tableId": tableId,
    "userId": userId,
    "dinerCount": dinerCount,
    "orderType": orderType
  };
}