import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../main.dart';
import '../config/constants.dart';
import '../data/model/event_bus.dart';
import '../data/model/restaurant_data.dart';
import 'global_controller.dart';

class LifecycleService extends GetxService with WidgetsBindingObserver {
  late GlobalController globalController;
  Future<LifecycleService> init() async {
    WidgetsBinding.instance.addObserver(this); // 添加生命周期观察者
    globalController = Get.put(GlobalController());

    initFirebaseMessaging();
    return this;
  }

  initFirebaseMessaging() async{
    FirebaseMessaging.instance.getInitialMessage().then((value){
      print("getInitialMessage()==>> $value ${value?.data.toString()}");
      },
    );

    FirebaseMessaging.instance.getToken().then((fcmToken){
      print("getToken()==>> fcmToken $fcmToken");
      if (fcmToken != null) {
        Conf.fcmToken = fcmToken;
      }
    });

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      print("onTokenRefresh()==>> fcmToken $fcmToken");
      Conf.fcmToken = fcmToken;
    }).onError((err) {
      print("onTokenRefresh() err $err");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp() message=$message');
      /*Navigator.pushNamed(
        context,
        '/message',
        arguments: MessageArguments(message, true),
      );*/
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message){
      print('onMessage() message=$message');
      RemoteNotification? notification = message.notification;
      print('onMessage() title=${notification?.title}, body=${notification?.body}, data=${message.data}');
      ///message.data {data: {"data":"","topics":["6_KITCHEN","6_WAITER"],"messageId":"3a89f9e0cfd48427218c2b5e869c333d","action":"DISH_MAKE_LIST_MODIFY","timestamp":1744161996617}}
      final messageDataContent = message.data["data"];
      if (messageDataContent  is String) {
        Map<String, dynamic> jsonMap = json.decode(messageDataContent);
        if ("REFRESH_DATA" == jsonMap["action"]) {
          globalController.reqRestaurantInfo();
        } else if ("DISH_STOCK_CHANGED" == jsonMap["action"]) {
          globalController.updateRestaurantInfoDishStock(jsonMap["data"]);
          eventBus.fire(PushMsgEvent(jsonMap));
        } else if ("ORDER_COMPLETE" == jsonMap["action"]) {
          if (jsonMap["data"] != null) {
            final tableId = jsonMap["data"]["tableId"];
            if (tableId is int) {
              globalController.handleOrderCompleteMsg(tableId);
            }
          }
          if (globalController.userType != RestaurantConf.userTypeUser) {
            eventBus.fire(PushMsgEvent(jsonMap));
          }
        } else {
          eventBus.fire(PushMsgEvent(jsonMap));
        }
      }

      //showFlutterNotification(message);
    });
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this); // 移除生命周期观察者
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      print("======>>>>>App is in background");
    } else if (state == AppLifecycleState.resumed) {
      print("======>>>>>App is in foreground");
    } else if (state == AppLifecycleState.inactive) {
      print("======>>>>>App is inactive");
    }
  }
}