
import 'dart:async';

import 'package:enjoy_meal/app/data/model/restaurant_data.dart';
import 'package:enjoy_meal/app/ui/dialog/number_select_dialog.dart';
import 'package:enjoy_meal/app/ui/dialog/select_type_1_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../base/data/protocol/response/base_resp.dart';
import '../../../base/ui/base_controller.dart';
import '../../../data/local/preference/preference_manager.dart';
import '../../../data/model/event_bus.dart';
import '../../../data/protocol/response/order_detail_resp.dart';
import '../../../data/repository/data_repository.dart';
import '../../../routes/app_pages.dart';
import '../../dialog/dish_detail_dialog.dart';
import '../../dialog/select_type_2_dialog.dart';
import '../../global_controller.dart';

abstract class CustomBaseController extends BaseController{
  final DataRepository dataRepository = Get.find(tag: (DataRepository).toString());
  final PreferenceManager preferenceManager = Get.find(tag: (PreferenceManager).toString());
  final GlobalController globalController = Get.find<GlobalController>();
  bool isOrderListMenuSelected = false;
  bool isShoppingCartMenuSelected = false;

  bool _isOnLoadingPage = false;
  bool isCanLoadingPage() {
    if (_isOnLoadingPage) return false;
    _isOnLoadingPage = true;
    Future.delayed(const Duration(milliseconds: 1000), (){
      _isOnLoadingPage = false;
    });
    return true;
  }

  bool _isOnLoadingDialog = false;
  bool isCanLoadingDialog() {
    if (_isOnLoadingDialog) return false;
    _isOnLoadingDialog = true;
    Future.delayed(const Duration(milliseconds: 1000), (){
      _isOnLoadingDialog = false;
    });
    return true;
  }

  final refreshDataTimeObs = 1.obs;
  StreamSubscription? _refreshDataSubscription;

  @override
  void onInit() {
    _refreshDataSubscription = eventBus.on<RefreshDataEvent>().listen((RefreshDataEvent event) {
      onRestaurantDataUpdate(event);
    });
    super.onInit();
  }

  void onRestaurantDataUpdate(RefreshDataEvent event) {}

  @override
  void onClose() {
    refreshDataTimeObs.close();
    _refreshDataSubscription?.cancel();
    _refreshDataSubscription = null;
    super.onClose();
  }


  void onWaiterCallClicked() async{
    if (!isCanLoadingPage()) return;
    if (globalController.userType == RestaurantConf.userTypeUser) {
      Get.toNamed(Routes.callAssistantPage);
    }
  }

  void onTopMenuClicked() {
    if (!isCanLoadingPage()) return;
    if (globalController.userType == RestaurantConf.userTypeUser) {
      if (globalController.isOnBuffetMode) return;
      Get.until((route) => route.settings.name == Routes.mainDishPage);
    } else {
      Get.until((route) => route.settings.name == Routes.mainDishPage);
    }
  }

  void onPackMenuClicked() {
    /*if (!isCanLoadingPage()) return;
    Get.offAndToNamed(Routes.cookingManagerPage);*/
  }

  void onOrderListMenuClicked() {
    if (!isCanLoadingPage()) return;

    final currentPage = Get.currentRoute;
    dataRepository.reqOrderDetail(globalController.currentTableId.toString()).then((BaseResp baseResp) async{
      if(baseResp.isSuccess()) {
        if (baseResp.data != null) {
          final orderDetailResp = OrderDetailResp.fromJson(baseResp.data);
          globalController.handleOrderDetailUpdate(orderDetailResp);
          if (orderDetailResp.isOrderExist()) {
            if (Get.currentRoute == currentPage) {
              if (Get.currentRoute.startsWith(Routes.shoppingCartPage)) {
                Get.offAndToNamed(Routes.orderListPage, arguments: orderDetailResp);
              } else {
                Get.toNamed(Routes.orderListPage, arguments: orderDetailResp);
              }
            }
          }
        } else {
          globalController.handleOrderDetailUpdate(null);
        }
      } else {
        showApiErrToast(baseResp.message);
      }
    }, onError:(err) {
      handleException(err);
    } );
  }

  void onShoppingCartMenuClicked() {
    if (!isCanLoadingPage()) return;

    if (Get.currentRoute.startsWith(Routes.orderListPage)) {
      Get.offAndToNamed(Routes.shoppingCartPage);
    } else {
      Get.toNamed(Routes.shoppingCartPage);
    }
  }

  void showPackageNumberSelectDialog(int mainCategoryId, PackageInfo item) {
    Get.dialog(NumberSelectDialog(mainId: mainCategoryId, packageInfo: item, onCancel: (){
      Get.back();
    }, onConfirm: (){

    },), barrierColor: Colors.transparent, useSafeArea: false);
  }

  void onDishInfoItemClicked(int mainCategoryId, DishInfo dishInfo, {bool flyToCartAnim = true}) {
    if (!globalController.checkDishCanDoNext(dishInfo)) {
      return;
    }

    if (!isCanLoadingDialog()) return;
    dishInfo.mainCategoryId = mainCategoryId;
    if (dishInfo.dishAttributeCategoryInfos.length <= 1) {
      dishInfo.flyToCartAnim = flyToCartAnim;
      showDishDetailDialog(dishInfo);
    } else if (dishInfo.dishAttributeCategoryInfos.length == 2) {
      _showSelectType1Dialog(dishInfo);
    }
  }

  void showDishDetailDialog(DishInfo dishInfo) {
    Get.dialog(DishDetailDialog(dishInfo:dishInfo, onCancel: (){
      Get.back();
    }), barrierColor: Colors.transparent, useSafeArea: false).then((value) async{
      await Future.delayed(const Duration(milliseconds: 800));
    });
  }

  void _showSelectType1Dialog(DishInfo dishInfo) {
    Get.dialog(SelectType1Dialog(dishInfo:dishInfo, onCancel: (){
      Get.back();
    },), barrierColor: Colors.transparent, useSafeArea: false);
  }

  /*void showSelectType2Dialog(DishInfo dishInfo) {
    Get.dialog(SelectType2Dialog(dishInfo:dishInfo, onCancel: (){
      Get.back(result: 0);
    }, onConfirm: (){
      Get.back(result: 1);
    },), barrierColor: Colors.transparent, useSafeArea: false).then((value){
      if (1 == value) {
        Get.back();
      }
    });
  }*/
}
