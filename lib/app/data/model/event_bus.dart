

import 'package:event_bus/event_bus.dart';

/// 创建EventBus
EventBus eventBus = EventBus();


class PushMsgEvent {
  Map<String, dynamic> data;

  PushMsgEvent(this.data);

  String? get action => data["action"];
}

class RefreshDataEvent{
  int type = 0;///0-RestaurantData更新， 1-库存上下架

  RefreshDataEvent({this.type = 0});
}

class ExitBuffetEvent{

}
