

import 'dart:async';

import 'package:enjoy_meal/app/data/protocol/response/order_detail_resp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/data/protocol/response/base_resp.dart';
import '../../../base/data/event_bus.dart';
import '../../../data/model/load_state.dart';
import '../../dialog/call_waiter_checkout_dialog.dart';
import '../../dialog/custom_tip_confirm_dialog.dart';
import 'custom_base_controller.dart';

class OrderListController extends CustomBaseController  {

  late OrderDetailResp orderDetailResp;
  final selectedNumObs = 1.obs;
  final _loadOrderDetailStateObs = LoadState.loading.obs;
  LoadState get loadOrderDetailState => _loadOrderDetailStateObs.value;
  ScrollController listScrollController = ScrollController();

  StreamSubscription? _orderChangeSubscription;

  @override
  void onInit() {
    isOrderListMenuSelected = true;
    //listScrollController = ScrollController();

    _orderChangeSubscription = eventBus.on<PushMsgEvent>().listen((PushMsgEvent event) {
      if ("ORDER_DETAIL_CHANGED" == event.action) {
        if (event.data["data"] != null) {
          final tableId = event.data["data"]["tableId"];
          if (globalController.currentTableId == tableId) {
            reqOrderDetail();
          }
        }
      }
    });

    super.onInit();

    var dataModel = Get.arguments;
    if (dataModel is OrderDetailResp) {
      orderDetailResp = dataModel;
      _loadOrderDetailStateObs(LoadState.success);
    } else {
      reqOrderDetail();
    }
  }

  @override
  void onClose() {
    _orderChangeSubscription?.cancel();
    _orderChangeSubscription = null;
    selectedNumObs.close();
    _loadOrderDetailStateObs.close();
    listScrollController.dispose();
    super.onClose();
  }

  void onAddBtnClicked() {
    selectedNumObs(selectedNumObs.value + 1);
  }

  void onSubtractClicked() {
    var num = selectedNumObs.value - 1;
    if (num < 1) {
      num = 1;
    }
    selectedNumObs(num);
  }

  void onBackToMenuClicked() {
    Get.back();
  }

  void onCallWaiterClicked() {
    if (!isCanLoadingPage()) return;

    final currentPage = Get.currentRoute;
    dataRepository.reqCallStaffCheckout().then((BaseResp baseResp) async{
      if(baseResp.isSuccess()) {
        if (Get.currentRoute == currentPage) {
          Get.dialog(CallWaiterCheckoutDialog(onConfirm: (){
            Get.back();
          },));
        }
      } else {
        showApiErrToast(baseResp.status, baseResp.message);
      }
    }, onError:(err) {
      handleException(err);
    } );
  }

  void reqOrderDetail() {
    _loadOrderDetailStateObs(LoadState.loading);
    dataRepository.reqOrderDetail(globalController.currentTableId.toString()).then((BaseResp baseResp) async{
      if(baseResp.isSuccess()) {
        if (baseResp.data != null) {
          orderDetailResp = OrderDetailResp.fromJson(baseResp.data);
        }
        _loadOrderDetailStateObs(LoadState.success);
      } else {
        showApiErrToast(baseResp.status, baseResp.message);
        _loadOrderDetailStateObs(LoadState.failed);
      }
    }, onError:(err) {
      handleException(err);
      _loadOrderDetailStateObs(LoadState.failed);
    } );
  }
}

