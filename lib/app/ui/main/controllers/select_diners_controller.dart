
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../base/data/protocol/response/base_resp.dart';
import '../../../data/protocol/request/prepare_order_req.dart';
import '../../../routes/app_pages.dart';
import 'custom_base_controller.dart';

class SelectDinersController extends CustomBaseController  {

  late TextEditingController numberController;
  late FocusNode numberNode;
  final isConfirmBtnEnableObs = false.obs;

  final _loadingPrepareOrderObs = false.obs;
  bool get loadingPrepareOrder => _loadingPrepareOrderObs.value;

  late String bgImgUrl;
  late String restaurantName;

  @override
  void onInit() {
    numberController = TextEditingController();
    numberController.text = "0";
    numberNode = FocusNode();

    restaurantName = globalController.restaurantData.restaurantBaseInfo.getRestaurantName();
    bgImgUrl = globalController.restaurantData.restaurantBaseInfo.selectionBgImage;

    super.onInit();
  }

  @override
  void onClose() {
    numberController.dispose();
    numberNode.dispose();
    isConfirmBtnEnableObs.close();
    _loadingPrepareOrderObs.close();
    super.onClose();
  }

  void onNumberTextChange(String text){
    String numString = numberController.text;
    if (numString.isEmpty) {
      numString = "0";
    }
    var number = int.tryParse(numString);
    if (number != null) {
      if (number > 0) {
        isConfirmBtnEnableObs(true);
      } else {
        isConfirmBtnEnableObs(false);
      }
    } else {
      numberController.text = "0";
      isConfirmBtnEnableObs(false);
    }
  }

  void onAddBtnClicked() {
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

    isConfirmBtnEnableObs(true);
  }

  void onSubtractClicked() {
    String numString = numberController.text;
    if (numString.isEmpty) {
      numString = "0";
    }
    var number = int.tryParse(numString);
    if (number != null) {
      if (number - 1 <= 0) {
        numberController.text = "0";
        isConfirmBtnEnableObs(false);
      } else {
        numberController.text = (number - 1).toString();
      }
    } else {
      numberController.text = "0";
      isConfirmBtnEnableObs(false);
    }
  }

  void onConfirmBtnClicked() {
    reqPrepareOrder();
    //Get.toNamed(Routes.mainDishPage);
  }

  void reqPrepareOrder() {
    String numString = numberController.text;
    if (numString.isEmpty) {
      return;
    }
    var number = int.tryParse(numString);
    if (number == null || number < 1) {
      return;
    }

    if (loadingPrepareOrder) return;
    _loadingPrepareOrderObs(true);

    var prepareOrderReq = PrepareOrderReq(globalController.currentTableId,
        globalController.userId, number, 0);
    dataRepository.reqPrepareOrder(prepareOrderReq).then((BaseResp baseResp){
      if(baseResp.isSuccessWithData()) {
        Get.offAndToNamed(Routes.mainDishPage);
        _loadingPrepareOrderObs(false);
      } else {
        showApiErrToast(baseResp.status, baseResp.message);
        _loadingPrepareOrderObs(false);
      }
    }, onError:(err) {
      handleException(err);
      _loadingPrepareOrderObs(false);
    } );
  }

}

