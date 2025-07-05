

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/data/protocol/response/base_resp.dart';
import '../../../base/data/event_bus.dart';
import '../../../data/model/goods_model.dart';
import '../../../data/protocol/request/submit_order_req.dart';
import '../../../local/custom_localizations.dart';
import '../../../routes/app_pages.dart';
import '../../dialog/clear_shopping_cart_dialog.dart';
import '../../dialog/order_send_tip_dialog.dart';
import 'custom_base_controller.dart';

class ShoppingCartController extends CustomBaseController  {

  final _shoppingCartListUpdateObs = true.obs;
  bool get shoppingCartListUpdate => _shoppingCartListUpdateObs.value;
  updateShoppingCartListUpdate() {
    _shoppingCartListUpdateObs(false);
    _shoppingCartListUpdateObs(true);
  }

  final loadingSubmitOrderObs = false.obs;

  ScrollController listScrollController = ScrollController();

  @override
  void onInit() {
    isShoppingCartMenuSelected = true;
    super.onInit();
  }

  @override
  void onRestaurantDataUpdate(RefreshDataEvent event) {
    updateShoppingCartListUpdate();
  }

  @override
  void onClose() {
    _shoppingCartListUpdateObs.close();
    listScrollController.dispose();
    super.onClose();
  }

  void onAddBtnClicked(dynamic model, int index) {
    if (model is DishOrderModel) {
      if (!globalController.checkDishCanDoNext(model.dishInfo)) {
        return;
      }
      model.quantity++;
      updateShoppingCartListUpdate();
    } else if (model is PackageOrderModel) {
      model.quantity++;
      updateShoppingCartListUpdate();
    }
    globalController.updateShoppingCartOrderInfo();
  }

  void onSubtractClicked(dynamic model, int index) {
    if (model is DishOrderModel) {
      model.quantity--;
      if (model.quantity <= 0) {
        globalController.shoppingCartList.remove(model);
      }
    } else if (model is PackageOrderModel) {
      model.quantity--;
      if (model.quantity <= 0) {
        globalController.shoppingCartList.remove(model);
      }
    }
    globalController.updateShoppingCartOrderInfo();
    updateShoppingCartListUpdate();
  }

  void onBackToMenuClicked() {
    Get.back();
  }

  void onClearCartClicked() {
    Get.dialog(ClearShoppingCartDialog(onCancel: (){
      Get.back();
    }, onConfirm: (){
      Get.back();
      globalController.clearShoppingCart();
      updateShoppingCartListUpdate();
    },), barrierColor: Colors.transparent, useSafeArea: false);
  }

  void onOrderConfirmClicked() {
    if (!isCanLoadingPage()) return;

    if (globalController.orderDetailResp != null && globalController.orderDetailResp!.isBuffetOrderExist()) {
      if (!globalController.orderDetailResp!.isInBuffetTime()) {
        globalController.showCommonTipDialog(CustomLocalizations.text("buffet_over_time_tip"));
        return;
      }
    }

    if (globalController.shoppingCartList.isNotEmpty) {
      reqSubmitOrder();
    }
  }

  double getTotalPrice() {
    double totalPrice = 0;
    for (var dataItem in globalController.shoppingCartList) {
      if (dataItem is DishOrderModel) {
        totalPrice += dataItem.getTotalPrice();
      } else if (dataItem is PackageOrderModel) {
        totalPrice += dataItem.getTotalPrice();
      }
    }
    return totalPrice;
  }

  void reqSubmitOrder() {

    if (loadingSubmitOrderObs.value) return;
    loadingSubmitOrderObs(true);

    final submitOrderReq = SubmitOrderReq(globalController.currentTableId);

    List<DishOrderReq> dishOrderReqList = [];
    List<PackageOrderReq> packageOrderReqList = [];

    for (var dataItem in globalController.shoppingCartList) {
      if (dataItem is DishOrderModel) {
        if (dataItem.dishInfo.available) {
          dishOrderReqList.add(dataItem.getDishOrderReq());
        }
      } else if (dataItem is PackageOrderModel) {
        if (dataItem.packageInfo.available) {
          packageOrderReqList.add(dataItem.getPackageOrderReq());
        }
      }
    }

    submitOrderReq.dishOrderRequests = dishOrderReqList;
    submitOrderReq.packageOrderRequests = packageOrderReqList;

    dataRepository.reqSubmitOrder(submitOrderReq).then((BaseResp baseResp) async{
      if(baseResp.isSuccess()) {
        globalController.reqOrderDetail();
        Get.dialog(OrderSendTipDialog(onConfirm: (){
          Get.back();
        },), barrierColor: Colors.transparent, useSafeArea: false, barrierDismissible: false).then((onValue){
          globalController.clearShoppingCart();
          updateShoppingCartListUpdate();
          if (globalController.isOnBuffetMode) {///订单类型是自助的
            Get.until((route) => route.settings.name == Routes.subDishPage);
          } else {
            Get.until((route) => route.settings.name == Routes.mainDishPage);
          }
        });
        loadingSubmitOrderObs(false);
      } else {
        if ("buffet.time.overdue" == baseResp.message) {

        }
        showApiErrToast(baseResp.status, baseResp.message);
        loadingSubmitOrderObs(false);
      }
    }, onError:(err) {
      loadingSubmitOrderObs(false);
      handleException(err);
    } );
  }
}

