class OperateCompleteReq {
  String tableNumber;
  int batchNumber;
  int dishId;

  OperateCompleteReq(this.tableNumber, this.batchNumber, this.dishId);

  Map<String, dynamic> toMap() => {
    "tableNumber": tableNumber,
    "batchNumber": batchNumber,
    "dishId": dishId
  };
}