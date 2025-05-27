
import 'package:enjoy_meal/app/data/model/goods_model.dart';
import 'package:enjoy_meal/app/data/model/restaurant_data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../base/ui/base_controller.dart';
import '../../global_controller.dart';
import '../../main/views/widget/fly_to_pos_widget.dart';

class DishDetailDialogController extends BaseController  {
  late GlobalController globalController;

  final isConfirmBtnEnableObs = true.obs;
  final selectedNumObs = 1.obs;

  final selectedAttributeUpdateObs = false.obs;
  void updateSelectedAttribute() {
    selectedAttributeUpdateObs(false);
    selectedAttributeUpdateObs(true);
  }
  ///key DishAttributeCategoryInfo id
  final Map<int, Map<int, DishAttributeInfo>> selectedAttributeInfoMap = {};

  bool isAttributeIdSelected(int attributeCategoryId, int id) {
    if (selectedAttributeInfoMap.containsKey(attributeCategoryId)) {
      return selectedAttributeInfoMap[attributeCategoryId]!.containsKey(id);
    }
    return false;
  }

  bool isExistCategoryDishAttribute(int attributeCategoryId) {
    final dishAttributeInfoMap = selectedAttributeInfoMap[attributeCategoryId];
    if (dishAttributeInfoMap != null && dishAttributeInfoMap.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  void onInit() {
    globalController = Get.find<GlobalController>();
    super.onInit();
  }

  @override
  void onClose() {
    isConfirmBtnEnableObs.close();
    selectedNumObs.close();
    selectedAttributeUpdateObs.close();
    super.onClose();
  }

  void onAddBtnClicked(DishInfo dishInfo) {
    if (!globalController.checkDishCanDoNext(dishInfo)) {
      return;
    }
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

  void onDishAttributeItemClicked(DishAttributeCategoryInfo dishAttributeCategoryInfo, DishAttributeInfo dishAttributeInfo) {
    if (selectedAttributeInfoMap.containsKey(dishAttributeCategoryInfo.id) && selectedAttributeInfoMap[dishAttributeCategoryInfo.id]!.isNotEmpty) {

      final dishAttributeInfoMap = selectedAttributeInfoMap[dishAttributeCategoryInfo.id];
      if (dishAttributeInfoMap!.containsKey(dishAttributeInfo.id)) {///该类别已包含该属性
        dishAttributeInfoMap.remove(dishAttributeInfo.id);
      } else {///该类别未包含该属性
        if (dishAttributeCategoryInfo.maxSelection == 1) {///单选
          dishAttributeInfoMap.clear();
          dishAttributeInfoMap[dishAttributeInfo.id] = dishAttributeInfo;
        } else {///多选
          dishAttributeInfoMap[dishAttributeInfo.id] = dishAttributeInfo;
        }
      }
    } else {///未包含该类别的任何属性，直接添加
      Map<int, DishAttributeInfo> dishAttributeInfoMap = {};
      dishAttributeInfoMap[dishAttributeInfo.id] = dishAttributeInfo;
      selectedAttributeInfoMap[dishAttributeCategoryInfo.id] = dishAttributeInfoMap;
    }

    updateSelectedAttribute();
  }

  void onCancelBtnClicked() {
    if (!isCanLoading()) return;
    Get.back();
  }

  void onConfirmBtnClicked(DishInfo dishInfo) async{
    if (!isCanLoading()) {
      return;
    }

    if (!globalController.checkDishCanDoNext(dishInfo)) {
      return;
    }

    if (!isConfirmBtnEnableObs.value) return;
    List<DishAttributeInfo> dishAttributeInfoList = [];
    for (var item in selectedAttributeInfoMap.values) {
      dishAttributeInfoList.addAll(item.values.toList());
    }
    globalController.addToShoppingCart(DishOrderModel(selectedNumObs.value, dishInfo,
        dishAttributeInfoList, mainCategoryId: dishInfo.mainCategoryId));

    if (dishInfo.flyToCartAnim) {
      if (dishInfo.thumbnailUrl != null) {
        addToShoppingCartAnim(dishInfo.thumbnailUrl!);
      } else {
        addToShoppingCartAnim("");
      }
    }
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

  OverlayEntry? _overlayEntry;
  void addToShoppingCartAnim(String imgUrl) {
    _overlayEntry ??= OverlayEntry(builder: (_) {
      return FlyToPosWidget(
        startPosition: Offset((1280.w-64.w)/2, (800.h - 64.w)/2 - 40.h),
        endPosition: Offset(1200.w, 460.h),
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

