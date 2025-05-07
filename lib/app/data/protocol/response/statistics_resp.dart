
class StatisticsResp {
  StatisticsCount? breakfastCount;
  StatisticsCount? dinnerCount;
  StatisticsCount? orderCount;
  List<StatisticsOrder> breakfastOrders = [];
  List<StatisticsOrder> dinnerOrders = [];

  StatisticsResp.fromJson(Map<String, dynamic> json){
    if (json['breakfastCount'] != null) {
      breakfastCount = StatisticsCount.fromJson(json['breakfastCount']);
    }

    if (json['dinnerCount'] != null) {
      dinnerCount = StatisticsCount.fromJson(json['dinnerCount']);
    }

    if (json['orderCount'] != null) {
      orderCount = StatisticsCount.fromJson(json['orderCount']);
    }

    if (json['breakfastOrders'] != null) {
      breakfastOrders = [];
      json['breakfastOrders'].forEach((v) {
        breakfastOrders.add(StatisticsOrder.fromJson(v));
      });
    }

    if (json['dinnerOrders'] != null) {
      dinnerOrders = [];
      json['dinnerOrders'].forEach((v) {
        dinnerOrders.add(StatisticsOrder.fromJson(v));
      });
    }
  }

}

class StatisticsCount {
  late int count;
  late double totalAmount;

  StatisticsCount.fromJson(Map<String, dynamic> json)
      : count = json["count"],
        totalAmount = json["totalAmount"].toDouble();
}

class StatisticsOrder {
  late String tableNumber;
  late String orderTime;
  late double totalAmount;

  StatisticsOrder.fromJson(Map<String, dynamic> json)
      : tableNumber = json["tableNumber"],
        orderTime = json["orderTime"],
        totalAmount = json["totalAmount"];
}