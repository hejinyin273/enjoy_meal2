
import 'package:enjoy_meal/app/data/model/goods_model.dart';
import 'package:enjoy_meal/app/data/model/restaurant_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'custom_base_controller.dart';

class DishDetailController extends CustomBaseController  {
  late TextEditingController numberController;
  late FocusNode numberNode;
  final isConfirmBtnEnableObs = false.obs;
  late DishInfo selectedDishInfo;

  @override
  void onInit() {
    numberController = TextEditingController();
    numberController.text = "0";
    numberNode = FocusNode();
    var dataModel = Get.arguments;
    if (dataModel is DishInfo) {
      selectedDishInfo = dataModel;
    } else {
      Get.back();
    }
    super.onInit();
  }

  @override
  void onClose() {
    numberController.dispose();
    numberNode.dispose();
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

  void onCancelBtnClicked() {
    Get.back();
  }

  void onConfirmBtnClicked() {
    /*if (!isConfirmBtnEnableObs.value) return;
    var number = int.tryParse(numberController.text);
    if (number == null || 0 == number) {
      return;
    }

    globalController.shoppingCartList.add(DishOrderModel(number, 0, selectedDishInfo));*/
  }
}

