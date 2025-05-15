

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/data/protocol/response/base_resp.dart';
import '../../../data/model/restaurant_data.dart';
import '../../../data/protocol/request/submit_order_req.dart';
import '../../../routes/app_pages.dart';
import '../../dialog/order_send_tip_dialog.dart';
import 'custom_base_controller.dart';

class BuffetConfirmController extends CustomBaseController  {
  late List<BuffetPriceInfo> buffetPriceInfoList;
  late List<TextEditingController> numberControllerList;
  late List<FocusNode> numberNodeList;
  final isConfirmBtnEnableObs = false.obs;

  late BuffetCategoryInfo selectedBuffetCategoryInfo;

  @override
  void onInit() {
    var dataModel = Get.arguments;
    if (dataModel is BuffetCategoryInfo) {
      selectedBuffetCategoryInfo = dataModel;
    } else {
      Get.back();
    }

    buffetPriceInfoList = selectedBuffetCategoryInfo.buffetPriceInfos;

    numberControllerList = [];
    numberNodeList = [];
    for(int i=0; i<buffetPriceInfoList.length; i++) {
      final numberController = TextEditingController();
      numberController.text = "0";
      numberControllerList.add(numberController);

      numberNodeList.add(FocusNode());
    }
    super.onInit();
  }

  @override
  void onClose() {
    for(int i=0; i<buffetPriceInfoList.length; i++) {
      numberControllerList[i].dispose();
      numberNodeList[i].dispose();
    }
    isConfirmBtnEnableObs.close();
    super.onClose();
  }

  void onNumberTextChange(String text, int index){
    final numberController = numberControllerList[index];
    String numString = numberController.text;
    if (numString.isEmpty) {
      numString = "0";
    }
    var number = int.tryParse(numString);
    if (number != null) {
      if (number < 0) {
        numberController.text = "0";
      }
    } else {
      numberController.text = "0";
    }

    checkBtnEnableState();
  }

  void onAddBtnClicked(int index) {
    final numberController = numberControllerList[index];
    String numString = numberController.text;
    if (numString.isEmpty) {
      numString = "0";
    }
    var number = int.tryParse(numString);
    if (number != null) {
      numberController.text = (number + 1).toString();
    } else {
      numberController.text = "1";
    }

    checkBtnEnableState();
  }

  void onSubtractClicked(int index) {
    final numberController = numberControllerList[index];
    String numString = numberController.text;
    if (numString.isEmpty) {
      numString = "0";
    }
    var number = int.tryParse(numString);
    if (number != null) {
      if (number - 1 <= 0) {
        numberController.text = "0";
      } else {
        numberController.text = (number - 1).toString();
      }
    } else {
      numberController.text = "0";
    }

    checkBtnEnableState();
  }

  void checkBtnEnableState() {
    bool isAllOk = true;
    for (int i=0; i<buffetPriceInfoList.length; i++) {
      final numberController = numberControllerList[i];
      final number = int.tryParse(numberController.text)??0;
      if (number < buffetPriceInfoList[i].minDinerCount) {
        isAllOk = false;
        break;
      }
    }

    if (globalController.orderDetailResp != null && globalController.orderDetailResp!.isOrderExist()) {
      isConfirmBtnEnableObs(false);
      return;
    }

    isConfirmBtnEnableObs(isAllOk);
  }

  void onConfirmBtnClicked() {
    if (!isCanLoadingPage()) return;

    if (isConfirmBtnEnableObs.value) {
      for(int i=0; i<numberNodeList.length; i++) {
        numberNodeList[i].unfocus();
      }
      /*Get.toNamed(Routes.selectSetMenuPage)?.then((value){
        for(int i=0; i<numberNodeList.length; i++) {
          numberNodeList[i].unfocus();
        }
      });*/

      reqSubmitOrder();
    }
  }

  void reqSubmitOrder() {
    final submitOrderReq = SubmitOrderReq(globalController.currentTableId);
    submitOrderReq.dishOrderRequests = [];
    submitOrderReq.packageOrderRequests = [];

    List<BuffetOrderReq> buffetOrderReqList = [];

    for (int i=0; i<buffetPriceInfoList.length; i++) {
      final numberController = numberControllerList[i];
      final number = int.tryParse(numberController.text)??0;
      if (number > 0) {
        buffetOrderReqList.add(BuffetOrderReq(buffetPriceInfoList[i].id, number));
      }
    }
    submitOrderReq.buffetOrderRequests = buffetOrderReqList;

    dataRepository.reqSubmitOrder(submitOrderReq).then((BaseResp baseResp) async{
      if(baseResp.isSuccess()) {
        globalController.clearShoppingCart();
        Get.back(result: true);
      } else {
        showApiErrToast(baseResp.status, baseResp.message);
      }
    }, onError:(err) {
      handleException(err);
    } );
  }

}


