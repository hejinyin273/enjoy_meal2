

class UpdateShelfReq{
  ///菜品ID
  String dishOwnId;
  ///上架状态 0下架 1上架
  int shelfStatus;
  ///库存数量 -1无上限
  int inventoryQuantity;
  ///针对某桌修改库存时传入
  int? tableId;

  UpdateShelfReq(this.dishOwnId, this.shelfStatus, this.inventoryQuantity, this.tableId);

  Map<String, dynamic> toMap() => {
    "dishOwnId": dishOwnId,
    "shelfStatus": shelfStatus,
    "inventoryQuantity": inventoryQuantity,
    "tableId": tableId
  };
}