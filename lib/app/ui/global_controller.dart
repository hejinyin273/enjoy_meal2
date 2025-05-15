


import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:enjoy_meal/app/base/ui/base_controller.dart';
import 'package:enjoy_meal/app/data/model/goods_model.dart';
import 'package:enjoy_meal/app/data/model/language.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../base/data/protocol/response/base_resp.dart';
import '../data/model/event_bus.dart';
import '../data/model/load_state.dart';
import '../data/model/restaurant_data.dart';
import '../data/protocol/response/order_detail_resp.dart';
import '../data/repository/data_repository.dart';
import '../local/custom_localizations.dart';
import '../routes/app_pages.dart';
import 'dialog/buffet_time_tip_dialog.dart';

class GlobalController extends BaseController{
  late DataRepository dataRepository;

  late RestaurantData restaurantData;

  TableInfo? waiterSelectedTableInfo;

  String get currentTableNumber  {
    if (userType != RestaurantConf.userTypeUser) {
      return waiterSelectedTableInfo!.tableNumber??"";
    }
    return restaurantData.currentTable.tableNumber??"";
  }

  int get currentTableId {
    if (userType != RestaurantConf.userTypeUser) {
      return waiterSelectedTableInfo!.id??0;
    }
    return restaurantData.currentTable.id??0;
  }

  int get userId => restaurantData.currentTable.boundUserId??0;

  int get userType => restaurantData.currentTable.boundUserType??0;

  String get callStaffBgImage => restaurantData.restaurantBaseInfo.callStaffBgImage;

  final isOnCallingStaffObs = false.obs;

  String get buffetCategoryDesc {
    final buffetCategoryDesc = restaurantData.restaurantBaseInfo.getBuffetCategoryDesc();
    if (buffetCategoryDesc.isNotEmpty) {
      return buffetCategoryDesc;
    }
    return CustomLocalizations.text("buffet");
  }

  OrderDetailResp? orderDetailResp;
  LoadState loadOrderDetailState = LoadState.loading;

  bool isOnBuffetMode = false;
  BuffetCategoryInfo? buffetCategoryInfo;
  Timer? buffetTimer;
  final buffetTimeStringObs = "".obs;
  bool isOnReqBuffetAddTime = false;

  final shoppingCartOrderNumObs = 0.obs;
  final shoppingCartOrderTotalPriceObs = 0.0.obs;
  List<dynamic> shoppingCartList = [];

  void initData(RestaurantData restaurantData) {
    dataRepository = Get.find(tag: (DataRepository).toString());

    this.restaurantData = restaurantData;

    for(var mainItem in restaurantData.categoryInfos) {
      if (mainItem.categoryType == RestaurantConf.categoryTypeDish) {///一级分类下直接是菜品
        for (int i = 0; i < mainItem.dishList.length; i++) {
          mainItem.dishList[i].mainCategoryId = mainItem.id;
        }
      } else if (mainItem.categoryType == RestaurantConf.categoryTypePackage) {///一级分类下直接是套餐--当前就一种-->拉麺セツト(昼限定)
        if (mainItem.packageInfo != null) {
          for (var dishItem in mainItem.packageInfo!.dishList) {
            dishItem.mainCategoryId = mainItem.id;
            dishItem.packageId = mainItem.packageInfo!.id;
          }

          for (var packageCategoryInfoItem in mainItem.packageInfo!.packageCategoryInfos) {
            for (var dishItem in packageCategoryInfoItem.dishList) {
              dishItem.mainCategoryId = mainItem.id;
              dishItem.packageId = mainItem.packageInfo!.id;
              dishItem.packageCategoryId = packageCategoryInfoItem.id;
            }
          }
        }
      } else {
        for(var subItem in mainItem.children) {
          if (subItem.categoryType == RestaurantConf.categoryTypeDish) {///二级分类下是菜品
            for (int i = 0; i < subItem.dishList.length; i++) {
              subItem.dishList[i].mainCategoryId = mainItem.id;
            }
          } else if (subItem.categoryType == RestaurantConf.categoryTypePackage){///二级分类下是套餐
            if (subItem.packageInfo != null) {
              for (var dishItem in subItem.packageInfo!.dishList) {
                dishItem.mainCategoryId = mainItem.id;
                dishItem.packageId = subItem.packageInfo!.id;
              }

              for (var packageCategoryInfoItem in subItem.packageInfo!.packageCategoryInfos) {
                for (var dishItem in packageCategoryInfoItem.dishList) {
                  dishItem.mainCategoryId = mainItem.id;
                  dishItem.packageId = subItem.packageInfo!.id;
                  dishItem.packageCategoryId = packageCategoryInfoItem.id;
                }
              }
            }
          }
        }
      }

      if (mainItem.validStartTime != null && mainItem.validEndTime != null) {
        final startTimeList = mainItem.validStartTime!.split(":");
        if (startTimeList.length == 2) {
          mainItem.startHour = int.tryParse(startTimeList[0]);
          mainItem.startMinute = int.tryParse(startTimeList[1]);
        }

        final endTimeList = mainItem.validEndTime!.split(":");
        if (endTimeList.length == 2) {
          mainItem.endHour = int.tryParse(endTimeList[0]);
          mainItem.endMinute = int.tryParse(endTimeList[1]);
        }
      } else {
        mainItem.startHour = null;
        mainItem.startMinute = null;
        mainItem.endHour = null;
        mainItem.endMinute = null;
      }
    }

    if (restaurantData.restaurantBaseInfo.hasBuffet == 1) {
      final buffetCategory = CategoryInfo(RestaurantConf.categoryBuffetId, CustomLocalizations.assignText(Language.zh, "buffet"),
          CustomLocalizations.assignText(Language.jp, "buffet"), CustomLocalizations.assignText(Language.en, "buffet"), RestaurantConf.categoryTypeBuffet, 0);
      buffetCategory.bgImage = restaurantData.restaurantBaseInfo.buffetModeBgImage;
      restaurantData.categoryInfos.add(buffetCategory);
    }
  }

  @override
  void onClose() {
    isOnCallingStaffObs.close();
    buffetTimeStringObs.close();
    shoppingCartOrderNumObs.close();
    shoppingCartOrderTotalPriceObs.close();
    super.onClose();
  }

  void addToShoppingCart(dynamic item) {
    if (item is DishOrderModel) {
      for (var shoppingItem in shoppingCartList) {
        if (shoppingItem is DishOrderModel) {
          if (shoppingItem.dishInfo.id == item.dishInfo.id) {
            if (shoppingItem.dishAttributeInfoList.isEmpty && item.dishAttributeInfoList.isEmpty) {/// is same
              shoppingItem.quantity += 1;
              updateShoppingCartOrderInfo();
              return;
            } else {
              if (shoppingItem.dishAttributeInfoList.length == item.dishAttributeInfoList.length) {
                bool isAllSame = true;
                for(var orgItemAttr in shoppingItem.dishAttributeInfoList) {
                  bool isSame = false;
                  for(var addItemAttr in item.dishAttributeInfoList) {
                    if (orgItemAttr.id == addItemAttr.id) {
                      isSame = true;
                      break;
                    }
                  }
                  if (!isSame) {
                    isAllSame = false;
                    break;
                  }
                }
                if (isAllSame) {
                  shoppingItem.quantity += 1;
                  updateShoppingCartOrderInfo();
                  return;
                }
              }
            }
          }
        }
      }
      shoppingCartList.add(item);
    } else if (item is PackageOrderModel) {
      for (var shoppingItem in shoppingCartList) {
        if (shoppingItem is PackageOrderModel) {
          if (shoppingItem.packageInfo.id == item.packageInfo.id) {
            if (item.packageInfo.packageType == 1) {
              shoppingItem.quantity +=1;
              updateShoppingCartOrderInfo();
              return;
            } else {

            }
          }
        }
      }

      shoppingCartList.add(item);
    }

    updateShoppingCartOrderInfo();
  }

  void clearShoppingCart() {
    shoppingCartList.clear();
    updateShoppingCartOrderInfo();
  }

  void updateShoppingCartOrderInfo() {
    int totalQuantity = 0;
    double totalPrice = 0;
    for (var listItem in shoppingCartList) {
      if (listItem is DishOrderModel) {
        if (listItem.dishInfo.available) {
          totalQuantity += listItem.quantity;
          totalPrice += listItem.getTotalPrice();
        }
      } else if (listItem is PackageOrderModel) {
        if (listItem.packageInfo.available) {
          totalQuantity += listItem.quantity;
          totalPrice += listItem.getTotalPrice();
        }
      }
    }

    shoppingCartOrderNumObs(totalQuantity);
    shoppingCartOrderTotalPriceObs(totalPrice);
  }

  List<dynamic> getShoppingCartShowingList() {
    return shoppingCartList;
  }

  String getMainCategoryNameById(int id) {
    for(var mainItem in restaurantData.categoryInfos) {
      if (mainItem.id == id) {
        return mainItem.getCategoryName();
      }
    }
    return "";
  }

  List<BuffetCategoryInfo> get buffetCategoryInfoList {
    if (restaurantData.buffetInfo == null) return [];
    return restaurantData.buffetInfo!.buffetCategoryInfos;
  }

  bool isBuffetSupportCategoryId(int id) {
    for(int i=0; i<buffetCategoryInfo!.availableCategoryIds.length; i++) {
      if (id == buffetCategoryInfo!.availableCategoryIds[i]) {
        return true;
      }
    }
    return false;
  }

  double getBuffetOvertimeFee() {
    if (buffetCategoryInfo != null) {
      for (var item in buffetCategoryInfo!.buffetPriceInfos) {
        if (item.overtimeExtraFee > 0) {
          return item.overtimeExtraFee;
        }
      }
    }
    return 0;
  }

  void showBuffetTimeTipDialog() {
    Get.dialog(BuffetTimeTipDialog(overTimeFee: getBuffetOvertimeFee(),
      onCancel: (){
        Get.back();
      }, onConfirm: (){
        reqBuffetAddTime();
      },), barrierColor: Colors.transparent, useSafeArea: false);
  }

  bool isBuffetSupportDishId(int id) {
    for(int i=0; i<buffetCategoryInfo!.availableDishIds.length; i++) {
      if (id == buffetCategoryInfo!.availableDishIds[i]) {
        return true;
      }
    }
    return false;
  }

  void reqBuffetAddTime() async{
    if (isOnReqBuffetAddTime) return;
    isOnReqBuffetAddTime = true;
    dataRepository.reqBuffetAddTime(currentTableId).then((BaseResp baseResp) async{
      if(baseResp.isSuccess()) {
        isOnReqBuffetAddTime = false;
        if (Get.isDialogOpen != null && Get.isDialogOpen!) {
          Get.back();
        }
      } else {
        isOnReqBuffetAddTime = false;
      }
    }, onError:(err) {
      isOnReqBuffetAddTime = false;
    } );
  }

  void startBuffetTimer(DateTime startDateTime, DateTime endDateTime) {
    buffetTimer?.cancel();
    buffetTimer = null;

    int rel = (endDateTime.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch);
    buffetTimeStringObs(formatDate(DateTime.fromMillisecondsSinceEpoch(rel, isUtc: true), [HH, ":", nn]));

    buffetTimer = Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      int rel = (endDateTime.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch);

      logger.i("startBuffetTimer() startDateTime=$startDateTime, endDateTime=$endDateTime, rel=$rel");
      buffetTimeStringObs(formatDate(DateTime.fromMillisecondsSinceEpoch(rel, isUtc: true), [HH, ":", nn]));

      if (rel <= 60 * 1000 * 10 && rel > 60 * 1000 * 9) {
        logger.i("startBuffetTimer() showBuffetTimeTipDialog() rel=$rel");
        showBuffetTimeTipDialog();
      }

      if (rel < 0) {
        isOnBuffetMode = false;
        buffetCategoryInfo = null;
        buffetTimer?.cancel();
        buffetTimer = null;
        buffetTimeStringObs("");
        eventBus.fire(ExitBuffetEvent());
      }
    });
  }

  bool checkDishCanDoNext(DishInfo dishInfo, {bool isShowToast = true, int wantCount = 1}) {
    if (!dishInfo.available) {
      if (isShowToast) {
        showToast(CustomLocalizations.text("sold_out"));
      }
      return false;
    }

    if (0 == dishInfo.inventoryQuantity) {
      if (isShowToast) {
        showToast(CustomLocalizations.text("sold_out"));
      }
      return false;
    }

    if (isOnBuffetMode) {
      if (getBuffetMaxQuantity(dishInfo) <= 0) {
        showToast("已达到上限了，已经选${dishInfo.buffetMaxQuantity}个了");
        return false;
      }
    }

    return true;
  }

  int getBuffetMaxQuantity(DishInfo dishInfo) {
    int usedCount = 0;
    if (orderDetailResp != null && orderDetailResp!.buffetOrderDetailDishes.isNotEmpty) {
      for (var orderDetailDish in orderDetailResp!.buffetOrderDetailDishes) {
        if (orderDetailDish.orderMode == 2 && orderDetailDish.id == dishInfo.id) {///自助餐模式
          usedCount += orderDetailDish.dishQuantity;
        }
      }
    }

    for (var item in shoppingCartList) {
      if (item is DishOrderModel) {
        if (item.dishInfo.id == dishInfo.id) {
          usedCount += item.quantity;
        }
      }
    }

    return dishInfo.buffetMaxQuantity! - usedCount;
  }

  void handleOrderDetailUpdate(OrderDetailResp? orderDetailResp) {
    this.orderDetailResp = orderDetailResp;
    if (orderDetailResp != null && orderDetailResp.orderDetailBuffets.isNotEmpty) {///已有订单 && 是自助订单
      if (orderDetailResp.firstOrderTime != null && orderDetailResp.buffetEndTime != null) {
        DateTime? startDateTime = DateTime.tryParse("${orderDetailResp.firstOrderTime}:00");
        DateTime? endDateTime = DateTime.tryParse("${orderDetailResp.buffetEndTime}:00");
        if (startDateTime != null && endDateTime != null && endDateTime.isAfter(DateTime.now())) {
          isOnBuffetMode = true;
          for(var item in restaurantData.buffetInfo!.buffetCategoryInfos) {///查找所选的自助套餐
            if (item.id == orderDetailResp.orderDetailBuffets.first.buffetCategoryId) {
              buffetCategoryInfo = item;
              break;
            }
          }
          startBuffetTimer(startDateTime, endDateTime);
          return;
        }
      }
    }

    if(isOnBuffetMode) {
      isOnBuffetMode = false;
      buffetCategoryInfo = null;
      buffetTimer?.cancel();
      buffetTimer = null;
      buffetTimeStringObs("");
      eventBus.fire(ExitBuffetEvent());
    } else {
      isOnBuffetMode = false;
      buffetCategoryInfo = null;
      buffetTimer?.cancel();
      buffetTimer = null;
      buffetTimeStringObs("");
    }
  }

  void reqOrderDetail() async{
    loadOrderDetailState = LoadState.loading;
    dataRepository.reqOrderDetail(currentTableId.toString()).then((BaseResp baseResp) async{
      if(baseResp.isSuccess()) {
        if (baseResp.data != null) {///已有订单
          final orderDetailResp = OrderDetailResp.fromJson(baseResp.data);
          handleOrderDetailUpdate(orderDetailResp);
        } else {
          handleOrderDetailUpdate(null);
        }
        loadOrderDetailState = LoadState.success;
      } else {
        loadOrderDetailState = LoadState.failed;
        Future.delayed(const Duration(microseconds: 1000), (){
          reqOrderDetail();
        });
      }
    }, onError:(err) {
      loadOrderDetailState = LoadState.failed;
      Future.delayed(const Duration(microseconds: 1000), (){
        reqOrderDetail();
      });
    } );
  }

  void handleOrderCompleteMsg(int tableId) {
    if (currentTableId == tableId) {
      reqOrderDetail();
      Get.offAllNamed(Routes.mainPage);
    }
  }

  List<int> refreshDataEventList = [];
  LoadState loadRestaurantInfoState = LoadState.success;
  void reqRestaurantInfo() {
    dataRepository.reqRestaurantInfo().then((BaseResp baseResp) async{
      if(baseResp.isSuccessWithData()) {
        final restaurantData = RestaurantData.fromJson(baseResp.data);
        initData(restaurantData);
        eventBus.fire(RefreshDataEvent());
        updateShoppingCartOrderInfo();
      } else {

      }
    }, onError:(err) {
    } );
  }

  void updateRestaurantInfoDishStock(Map<String, dynamic>? dataMap) {
    ///"data":{"isAvailable":1,"dishId":20,"dishStock":48}
    if (dataMap != null && dataMap["dishId"] != null && dataMap["isAvailable"] != null) {
      int updateDishId = dataMap["dishId"];
      int isUpdateAvailable = dataMap["isAvailable"];
      int? updateDishStock = dataMap["dishStock"];

      for(var mainItem in restaurantData.categoryInfos) {
        if (mainItem.categoryType == RestaurantConf.categoryTypeDish) {///一级分类下直接是菜品
          for (var dishItem in mainItem.dishList) {
            if (dishItem.id == updateDishId) {
              dishItem.isAvailable = isUpdateAvailable;
              dishItem.inventoryQuantity = updateDishStock;
            }
          }
        } else if (mainItem.categoryType == RestaurantConf.categoryTypePackage) {///一级分类下直接是套餐--当前就一种-->拉麺セツト(昼限定)
          if (mainItem.packageInfo != null) {
            for (var packageCategoryInfo in mainItem.packageInfo!.packageCategoryInfos) {
              for (var dishItem in packageCategoryInfo.dishList) {
                if (dishItem.id == updateDishId) {
                  dishItem.isAvailable = isUpdateAvailable;
                  dishItem.inventoryQuantity = updateDishStock;
                }
              }
            }
          }
        } else if (mainItem.categoryType == RestaurantConf.categoryTypeBuffet) {///自定义-自助
          continue;
        } else {
          for(var subItem in mainItem.children) {
            if (subItem.categoryType == RestaurantConf.categoryTypeDish) {///二级分类下是菜品
              for (var dishItem in subItem.dishList) {
                if (dishItem.id == updateDishId) {
                  dishItem.isAvailable = isUpdateAvailable;
                  dishItem.inventoryQuantity = updateDishStock;
                }
              }
            } else if (subItem.categoryType == RestaurantConf.categoryTypePackage){///二级分类下是套餐
              if (subItem.packageInfo != null) {
                for (var packageCategoryInfo in subItem.packageInfo!.packageCategoryInfos) {
                  for (var dishItem in packageCategoryInfo.dishList) {
                    if (dishItem.id == updateDishId) {
                      dishItem.isAvailable = isUpdateAvailable;
                      dishItem.inventoryQuantity = updateDishStock;
                    }
                  }
                }
              }
            }
          }
        }
      }
      eventBus.fire(RefreshDataEvent(type: 1));
      updateShoppingCartOrderInfo();
    }
  }
}