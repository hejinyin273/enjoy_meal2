
import 'package:enjoy_meal/app/data/model/goods_model.dart';
import 'package:enjoy_meal/app/data/model/restaurant_data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../base/ui/base_controller.dart';
import '../../global_controller.dart';
import '../../main/views/widget/fly_to_pos_widget.dart';

class StoreOperationDialogController extends BaseController  {
  late GlobalController globalController;

  final isConfirmBtnEnableObs = true.obs;
  final selectedNumObs = 1.obs;
  late TextEditingController numberController;
  late FocusNode numberNode;
  final isValidObs = true.obs;

  @override
  void onInit() {
    globalController = Get.find<GlobalController>();

    numberController = TextEditingController();
    numberNode = FocusNode();

    super.onInit();
  }

  @override
  void onClose() {
    isConfirmBtnEnableObs.close();
    selectedNumObs.close();
    isValidObs.close();

    numberController.dispose();
    numberNode.dispose();
    super.onClose();
  }

  void onAddBtnClicked() {
    selectedNumObs(selectedNumObs.value + 1);
    numberController.text = selectedNumObs.toString();
    isConfirmBtnEnableObs(true);
  }

  void onSubtractClicked() {
    var num = selectedNumObs.value - 1;
    if (num < 1) {
      num = 1;
    }
    selectedNumObs(num);
    numberController.text = selectedNumObs.toString();
    if (selectedNumObs.value == 0) {
      isConfirmBtnEnableObs(false);
    } else {
      isConfirmBtnEnableObs(true);
    }
  }


  void onConfirmBtnClicked(DishInfo dishInfo) async{
    if (!isCanLoading()) {
      return;
    }

    if (!isConfirmBtnEnableObs.value) return;

    Get.back();
  }

  bool _isOnLoading = false;
  bool isCanLoading() {
    if (_isOnLoading) return false;
    _isOnLoading = true;
    Future.delayed(const Duration(milliseconds: 1000), (){
      _isOnLoading = false;
    });
    return true;
  }

}

