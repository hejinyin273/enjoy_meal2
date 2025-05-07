
import 'package:enjoy_meal/app/data/model/restaurant_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../base/ui/base_controller.dart';
import '../../../data/model/goods_model.dart';
import '../../global_controller.dart';
import '../../main/views/widget/fly_to_pos_widget.dart';

class NumberSelectDialogController extends BaseController  {
  late GlobalController globalController;

  final isConfirmBtnEnableObs = true.obs;
  final selectedNumObs = 1.obs;

  @override
  void onInit() {
    globalController = Get.find<GlobalController>();
    super.onInit();
  }

  @override
  void onClose() {
    isConfirmBtnEnableObs.close();
    selectedNumObs.close();
    super.onClose();
  }

  void onAddBtnClicked() {
    selectedNumObs(selectedNumObs.value + 1);
    isConfirmBtnEnableObs(true);
  }

  void onSubtractClicked() {
    var num = selectedNumObs.value - 1;
    if (num < 1) {
      num = 1;
    }
    selectedNumObs(num);

    if (selectedNumObs.value == 0) {
      isConfirmBtnEnableObs(false);
    } else {
      isConfirmBtnEnableObs(true);
    }
  }

  void onCancelBtnClicked() {
    Get.back();
  }

  void onConfirmBtnClicked(int mainCategoryId, PackageInfo packageInfo) {
    if (!isConfirmBtnEnableObs.value) return;
    Get.back();

    List<DishOrderModel> dishOrderModelList = [];
    for(int i=0; i<packageInfo.dishList.length; i++) {
      final dishItem = packageInfo.dishList[i];
      dishOrderModelList.add(DishOrderModel(1, dishItem, []));
    }
    final packageOrderModel = PackageOrderModel(1, packageInfo, mainCategoryId, dishOrderModelList);
    packageOrderModel.quantity = selectedNumObs.value;
    globalController.addToShoppingCart(packageOrderModel);///集合型

    for(int i=0; i<packageInfo.dishList.length; i++) {
      final dishItem = packageInfo.dishList[i];
      if (dishItem.thumbnailUrl != null) {
        addToShoppingCartAnim(dishItem.thumbnailUrl!);
        break;
      }
    }

  }

  OverlayEntry? _overlayEntry;
  void addToShoppingCartAnim(String imgUrl) {
    _overlayEntry ??= OverlayEntry(builder: (_) {
      return FlyToPosWidget(
        startPosition: Offset((1280.w-64.w)/2, (800.h - 64.w)/2 - 40.h),
        endPosition: Offset(1200.w, 620.h),
        imgUrl: imgUrl,
      );
    });
    Overlay.of(Get.context!).insert(_overlayEntry!);
    Future.delayed(const Duration(milliseconds: 800), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }
}

