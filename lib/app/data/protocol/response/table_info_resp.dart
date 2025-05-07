
class TableInfoResp {
  late int tableId;
  late int tableStatus;///餐桌状态 0空闲 1有人
  late String tableNumber;
  late int dinerCount;
  late String? firstOrderTime;
  late String? buffetEndTime;

  TableInfoResp.fromJson(Map<String, dynamic> json)
      : tableId = json["tableId"],
        tableStatus = json["tableStatus"],
        tableNumber = json["tableNumber"],
        dinerCount = json["dinerCount"],
        firstOrderTime = json["firstOrderTime"],
        buffetEndTime = json["buffetEndTime"];

}