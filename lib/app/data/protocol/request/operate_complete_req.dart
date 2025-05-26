class OperateCompleteReq {
  String tableNumber;
  int batchNumber;
  int orderDetailId;

  OperateCompleteReq(this.tableNumber, this.batchNumber, this.orderDetailId);

  Map<String, dynamic> toMap() => {
    "tableNumber": tableNumber,
    "batchNumber": batchNumber,
    "orderDetailId": orderDetailId
  };
}