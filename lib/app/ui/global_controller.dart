


import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:enjoy_meal/app/base/ui/base_controller.dart';
import 'package:enjoy_meal/app/data/model/goods_model.dart';
import 'package:enjoy_meal/app/data/model/language.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../base/data/protocol/response/base_resp.dart';
import '../base/data/event_bus.dart';
import '../base/utils/android_helper.dart';
import '../data/model/load_state.dart';
import '../data/model/restaurant_data.dart';
import '../data/protocol/response/order_detail_resp.dart';
import '../data/repository/data_repository.dart';
import '../local/custom_localizations.dart';
import '../routes/app_pages.dart';
import 'dialog/buffet_time_tip_dialog.dart';
import 'dialog/tip_confirm_dialog.dart';

class GlobalController extends BaseController{
  late DataRepository dataRepository;

  late RestaurantData restaurantData;

  TableInfo? waiterSelectedTableInfo;

  String get currentTableNumber  {
    if (userType != RestaurantConf.userTypeUser) {
      if (waiterSelectedTableInfo != null) {
        return waiterSelectedTableInfo!.tableNumber ?? "";
      }
      return "";
    }
    return restaurantData.currentTable.tableNumber??"";
  }

  int get currentTableId {
    if (userType != RestaurantConf.userTypeUser) {
      if (waiterSelectedTableInfo != null) {
        return waiterSelectedTableInfo!.id??0;
      }
      return 0;
    }
    return restaurantData.currentTable.id??0;
  }

  int get userId => restaurantData.currentTable.boundUserId??-1;

  int get userType => restaurantData.currentTable.boundUserType??0;///0表示服务员，1表示厨房，2表示餐桌

  String get callStaffBgImage => restaurantData.restaurantBaseInfo.callStaffBgImage;

  final isOnCallingStaffObs = false.obs;

  String? get buffetCategoryDesc {
    final buffetCategoryDesc = restaurantData.restaurantBaseInfo.getBuffetCategoryDesc();
    if (buffetCategoryDesc.isNotEmpty) {
      return buffetCategoryDesc;
    }
    return null;
  }

  OrderDetailResp? orderDetailResp;
  LoadState loadOrderDetailState = LoadState.loading;

  bool isOnBuffetMode = false;
  BuffetCategoryInfo? buffetCategoryInfo;
  Timer? buffetTimer;
  final buffetTimeStringObs = "".obs;
  bool isOnReqBuffetAddTime = false;
  final isShowDisableCoverObs = false.obs;

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
              shoppingItem.quantity += item.quantity;
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
                  shoppingItem.quantity += item.quantity;
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
              shoppingItem.quantity += item.quantity;
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
        reqOrderDetail();
      } else {
        isOnReqBuffetAddTime = false;
        showApiErrToast(baseResp.status, baseResp.message);
      }
    }, onError:(err) {
      isOnReqBuffetAddTime = false;
      handleException(err);
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

      final reminderTimeMin = restaurantData.restaurantBaseInfo.buffetLastReminderTime??0;


      if (rel <= 60 * 1000 * reminderTimeMin && rel > 60 * 1000 * (reminderTimeMin -1)) {
        logger.i("startBuffetTimer() showBuffetTimeTipDialog() rel=$rel");
        if (userType == RestaurantConf.userTypeUser) {
          showBuffetTimeTipDialog();
        }
      } else if ((rel <= 60 * 1000 * 5 && rel > 60 * 1000 * 4) || (rel <= 60 * 1000 * 2 && rel > 60 * 1000 * 1)) {
        reqOrderDetail();
      } else {
        logger.i("startBuffetTimer() rel=$rel, start=${60 * 1000 * (reminderTimeMin -1)}, endEqual=${60 * 1000 * reminderTimeMin}");
      }

      if (rel < 0) {
        isOnBuffetMode = false;
        buffetCategoryInfo = null;
        buffetTimer?.cancel();
        buffetTimer = null;
        buffetTimeStringObs("");
        eventBus.fire(ExitBuffetEvent());
        if (Get.isDialogOpen != null && Get.isDialogOpen!) {///showBuffetTimeTipDialog may be open
          Get.back();
        }
        if (userType == RestaurantConf.userTypeUser) {
          showBuffetOverTimeDialog();
          isShowDisableCoverObs(true);
        }
        reqOrderDetail();
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
      if (dishInfo.buffetMaxQuantity != null && getBuffetRemainingQuantity(dishInfo) <= 0) {
        showToast("已达到上限了，已经选${dishInfo.buffetMaxQuantity}个了");
        return false;
      }
    } else {
      if (dishInfo.inventoryQuantity != null && dishInfo.inventoryQuantity! > 0) {
        if (dishInfo.inventoryQuantity! - wantCount < 0) {
          showToast("库存不够了！剩余${dishInfo.inventoryQuantity}份！");
          return false;
        }
      }
    }

    return true;
  }

  int getBuffetRemainingQuantity(DishInfo dishInfo) {
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
        if (startDateTime != null && endDateTime != null) {
          if (endDateTime.isAfter(DateTime.now())) {
            isOnBuffetMode = true;
            for(var item in restaurantData.buffetInfo!.buffetCategoryInfos) {///查找所选的自助套餐
              if (item.id == orderDetailResp.orderDetailBuffets.first.buffetCategoryId) {
                buffetCategoryInfo = item;
                break;
              }
            }
            startBuffetTimer(startDateTime, endDateTime);
            return;
          } else {
            if (userType == RestaurantConf.userTypeUser) {
              isShowDisableCoverObs(true);
            }
          }
        }
      }
    }

    if(isOnBuffetMode) {
      isOnBuffetMode = false;
      buffetCategoryInfo = null;
      buffetTimer?.cancel();
      buffetTimer = null;
      buffetTimeStringObs("");
      if (orderDetailResp == null) {
        Get.until((route) => Get.currentRoute.startsWith(Routes.mainPage));
      }
      if (userType == RestaurantConf.userTypeUser) {
        isShowDisableCoverObs(false);
      }
    } else {
      isOnBuffetMode = false;
      buffetCategoryInfo = null;
      buffetTimer?.cancel();
      buffetTimer = null;
      buffetTimeStringObs("");
      if (userType == RestaurantConf.userTypeUser) {
        isShowDisableCoverObs(false);
      }
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
      if (userType == RestaurantConf.userTypeUser) {
        Get.until((route) => Get.currentRoute.startsWith(Routes.mainPage));
      }
    }
  }

  void showBuffetOverTimeDialog() {
    Get.dialog(TipConfirmDialog(tipContent: "注文終了しました",
      onConfirm: () async{
        Get.back();
      },), barrierColor: Colors.transparent, useSafeArea: false, barrierDismissible: false);
  }

  void showCommonTipDialog(String tipContent) {
    Get.dialog(TipConfirmDialog(tipContent: tipContent,
      onConfirm: () async{
        Get.back();
      },), barrierColor: Colors.transparent, useSafeArea: false, barrierDismissible: false);
  }

  void handleNewVersionMsg() {
    Get.dialog(TipConfirmDialog(tipContent: "APPバージョンの更新",
      onConfirm: () async{
        Get.until((route) => Get.currentRoute.startsWith(Routes.mainPage));
        await Future.delayed(const Duration(milliseconds: 500));
        eventBus.fire(MainInitEvent());
      },), barrierColor: Colors.transparent, useSafeArea: false, barrierDismissible: false);
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



  ///printer
  String? printerConnInfo;
  Timer? printerEscTimer;
  Timer? printerConnTimer;
  List<String> printContentList = [];

  void autoConnectPrinter() async{
    if (printerConnInfo == null || printerConnInfo!.isEmpty) return;

    try {
      printerConnTimer?.cancel();
      printerConnTimer = null;
      if (userType != RestaurantConf.userTypeUser) {
        printerConnTimer = Timer.periodic(const Duration(seconds: 15), (Timer timer) async{
          if (printerConnInfo != null && printerConnInfo!.isNotEmpty) {
            var connInfos = printerConnInfo!.split("_");
            if (connInfos.length >= 3) {
              if (connInfos[1] == "BLUETOOTH") {
                final isPrinterConnected = await AndroidHelper.isPrinterConnected();
                if (!isPrinterConnected) {
                  final isOnPrinterSearching = await AndroidHelper.isOnPrinterSearching();
                  if (isOnPrinterSearching) {
                    await AndroidHelper.stopSearchPrinters();
                    await Future.delayed(const Duration(seconds: 2));
                  }
                  logger.i("autoConnectPrinter() startSearchPrinters $printerConnInfo");
                  AndroidHelper.startSearchPrinters(connInfos[1], connInfos[2]);
                }
              }
            }
          }
        });
      }
    } catch (e) {
      logger.e("autoConnectPrinter() err=$e");
    }
  }

  void startPrinterEscTimer() {
    printerEscTimer?.cancel();
    printerEscTimer = null;

    if (RestaurantConf.userTypeUser != userType) {
      printerEscTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) async{
        logger.i("PrinterEscTimer() printContentList size=${printContentList.length}");
        if (printContentList.isNotEmpty) {
          final isPrinterConnected = await AndroidHelper.isPrinterConnected();
          if (!isPrinterConnected) {
            if (printerConnInfo != null && printerConnInfo!.isNotEmpty) {
              var connInfos = printerConnInfo!.split("_");
              if (connInfos.length >= 3) {
                if (connInfos[1] == "WIFI") {
                  AndroidHelper.startWifiPrinterConnect(connInfos[3], int.tryParse(connInfos[4])??9100);
                }
              }
            }
          } else {
            final status = await AndroidHelper.checkPrinterStatus();
            logger.i("checkPrinterStatus() status=$status");
            if (status == 18) {
              final success = await AndroidHelper.printEscDot(printContentList.first);
              logger.i("printEscDot() result=$success");
              if (success) {
                printContentList.removeAt(0);
              }
            }
          }
        }
      });
    }
  }
}