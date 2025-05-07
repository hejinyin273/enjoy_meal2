
import 'package:enjoy_meal/app/data/model/restaurant_data.dart';
import 'package:enjoy_meal/app/local/custom_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../data/model/goods_model.dart';
import '../../dialog/dish_detail_dialog.dart';
import '../model/page_dish_list.dart';
import '../views/widget/fly_to_pos_widget.dart';
import 'custom_base_controller.dart';

class SelectSetMenuController extends CustomBaseController {
  final _currentTabIndexObs = 0.obs;
  int get currentTabIndex => _currentTabIndexObs.value;
  updateCurrentTabIndex(int index) => _currentTabIndexObs(index);

  late PageController pageController;
  int currentPageIndex = 0;
  late PackageInfo selectedPackageInfo;
  late int mainCategoryId;
  List<PageDishList> pageDishDataList = [];

  final _selectedDishInfoListObs = <DishInfo>[].obs;
  List<DishInfo> get selectedDishInfoList => _selectedDishInfoListObs.toList();
  updateSelectedDishInfoList(List<DishInfo> dataList) => _selectedDishInfoListObs(dataList);

  void updatePageDishDataList(int index) {
    int subItemCount = 8;
    final mainItem = selectedPackageInfo.packageCategoryInfos[index];
    pageDishDataList.clear();
    if (mainItem.showImageFlag == 0) {
      subItemCount = 15;
    }
    if (mainItem.dishList.isNotEmpty) {
      for (int i = 0; i < mainItem.dishList.length; i += subItemCount) {
        final subDishList = mainItem.dishList.sublist(i, i + subItemCount < mainItem.dishList.length ? i + subItemCount : mainItem.dishList.length);
        pageDishDataList.add(PageDishList(mainItem.id, mainItem.id, 1, subDishList));
        pageDishDataList.last.isShowImg = (mainItem.showImageFlag != 0);
      }
    } else {
      pageDishDataList.add(PageDishList(mainItem.id, mainItem.id, 1, []));
      pageDishDataList.last.isShowImg = (mainItem.showImageFlag != 0);
    }
  }

  ///key DishInfo id
  final List<List<DishAttributeInfo>> selectedAttributeInfoListSet = [];
  //final Map<int, List<DishAttributeInfo>> selectedAttributeInfoListMap = {};

  String? bgImgUrl;

  @override
  void onInit() {
    pageController = PageController(initialPage: currentPageIndex, keepPage: true, /*viewportFraction: 0.8*/);
    var dataModel = Get.arguments;
    if (dataModel is PackageInfo) {
      selectedPackageInfo = dataModel;
      final mainCategoryIdStr = Get.parameters["mainCategoryId"];
      mainCategoryId = int.tryParse(mainCategoryIdStr!)!;
    } else {
      Get.back();
    }

    final mainList = globalController.restaurantData.categoryInfos;
    for (var item in mainList) {
      if (item.id == mainCategoryId) {
        bgImgUrl = item.bgImage;
      }
    }

    updatePageDishDataList(currentTabIndex);
    super.onInit();
  }

  @override
  void onClose() {
    _currentTabIndexObs.close();
    pageController.dispose();
    super.onClose();
  }

  void onTabChanged(int index) {
    updateCurrentTabIndex(index);
  }

  void onPageChanged(int index) {

  }

  void onPreBtnClicked() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,);
  }

  void onNextBtnClicked() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,);
  }

  ///点击了当前Tab里的菜单项
  void onSetMenuDishItemClicked(DishInfo dishInfo) {
    String? confirmText;
    if (currentTabIndex < selectedPackageInfo.packageCategoryInfos.length - 1) {
      confirmText = CustomLocalizations.text("keep_forward");
    } else {
      final packageCategoryInfo = selectedPackageInfo.packageCategoryInfos[currentTabIndex];
      int includedNum = 0;///该套餐类别下已包含的菜品数量
      for (int i=0; i<selectedDishInfoList.length; i++) {
        if (packageCategoryInfo.id == selectedDishInfoList[i].packageCategoryId) {
          includedNum ++;
        }
      }

      if (includedNum < packageCategoryInfo.maxSelection -1) {
        confirmText = CustomLocalizations.text("keep_forward");
      }
    }
    if (dishInfo.dishAttributeCategoryInfos.length <= 1) {
      Get.dialog(DishDetailDialog(dishInfo:dishInfo, onCancel: (){
        Get.back();
      }, confirmText: confirmText, onConfirm: (List<DishAttributeInfo> attributeList){
        Get.back();
        handleOnConfirmDish(dishInfo, attributeList);
        checkShouldGotoNext();
      }, isShowNumSelect: false,), barrierColor: Colors.transparent, useSafeArea: false);
    } else if (dishInfo.dishAttributeCategoryInfos.length == 2) {
      //showSelectType1Dialog(dishInfo);
      showToast("step package not support multi attrs");
    }
  }

  void handleOnConfirmDish(DishInfo dishInfo, List<DishAttributeInfo> attributeList) {
    /*final packageCategoryInfo = selectedPackageInfo.packageCategoryInfos[currentTabIndex];
    dishInfo.packageCategoryId = packageCategoryInfo.id;*/

    List<DishInfo> dataList = [];
    dataList.addAll(selectedDishInfoList);
    dataList.add(dishInfo);///添加菜品与对应属性同步
    selectedAttributeInfoListSet.add(attributeList);///添加菜品与对应属性同步
    updateSelectedDishInfoList(dataList);
  }

  void checkShouldGotoNext() {
    final packageCategoryInfo = selectedPackageInfo.packageCategoryInfos[currentTabIndex];
    int includedNum = 0;///该套餐类别下已包含的菜品数量
    for (int i=0; i<selectedDishInfoList.length; i++) {
      if (packageCategoryInfo.id == selectedDishInfoList[i].packageCategoryId) {
        print("----${selectedDishInfoList[i].packageCategoryId}-----${selectedDishInfoList[i]}--");
        includedNum ++;
      }
    }

    print("----${packageCategoryInfo.maxSelection}----$includedNum-----");

    if (packageCategoryInfo.maxSelection == includedNum) {///must go to next
      if (currentTabIndex < selectedPackageInfo.packageCategoryInfos.length - 1) {///还有tab
        int nextIndex = currentTabIndex + 1;
        updatePageDishDataList(nextIndex);
        updateCurrentTabIndex(nextIndex);
      } else {///all done, add to shopping cart
        List<DishOrderModel> dishOrderModelList = [];
        for(int i=0; i<selectedDishInfoList.length; i++) {
          final dishItem = selectedDishInfoList[i];
          final attributeInfoList = selectedAttributeInfoListSet[i];
          dishOrderModelList.add(DishOrderModel(1, dishItem, attributeInfoList ?? []));
        }
        final packageOrderModel = PackageOrderModel(1, selectedPackageInfo, mainCategoryId, dishOrderModelList);
        globalController.addToShoppingCart(packageOrderModel);///步骤型

        for(int i=0; i<selectedDishInfoList.length; i++) {
          final dishItem = selectedDishInfoList[i];
          if (dishItem.thumbnailUrl != null) {
            addToShoppingCartAnim(dishItem.thumbnailUrl!);
            break;
          }
        }

        Get.back();
      }
    }
  }

  OverlayEntry? _overlayEntry;
  void addToShoppingCartAnim(String imgUrl) {
    _overlayEntry ??= OverlayEntry(builder: (_) {
      return FlyToPosWidget(
        startPosition: Offset(80.w, (800.h - 64.w)/2 ),
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

  void onRevokeBackClicked() {
    if (selectedDishInfoList.isEmpty) {
      Get.back();
    } else {
      List<DishInfo> dataList = selectedDishInfoList;
      /*if (dataList.last.packageId! != selectedPackageInfo.packageCategoryInfos[currentTabIndex].packageId) {
        int useIndex = currentTabIndex - 1;
        updatePageDishDataList(useIndex);
        updateCurrentTabIndex(useIndex);
        return;
      }*/
      final removedItem = dataList.removeLast();///删除了哪个packageCategory就应该在哪个packageCategory里选
      selectedAttributeInfoListSet.removeLast();

      if (dataList.isNotEmpty) {
        for(int i=0; i<selectedPackageInfo.packageCategoryInfos.length; i++) {
          if (removedItem.packageCategoryId == selectedPackageInfo.packageCategoryInfos[i].id) {
            updatePageDishDataList(i);
            updateCurrentTabIndex(i);
          }
        }
        /*int lastPackageId = dataList.last.packageId!;
        if (removedItem.packageId != lastPackageId) {
          for(int i=0; i<selectedPackageInfo.packageCategoryInfos.length; i++) {
            if (lastPackageId == selectedPackageInfo.packageCategoryInfos[i].id) {
              updatePageDishDataList(i);
              updateCurrentTabIndex(i);
            }
          }
        }*/
      } else {
        updatePageDishDataList(0);
        updateCurrentTabIndex(0);
      }
      updateSelectedDishInfoList(dataList);
    }
  }

}

