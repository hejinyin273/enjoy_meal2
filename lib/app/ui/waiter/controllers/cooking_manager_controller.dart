
import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/data/protocol/response/base_resp.dart';
import '../../../data/model/load_state.dart';
import '../../../data/model/restaurant_data.dart';
import '../../../data/protocol/request/operate_complete_req.dart';
import '../../../data/protocol/response/order_detail_resp.dart';
import '../../../data/protocol/response/table_info_resp.dart';
import '../../../routes/app_pages.dart';
import '../../dialog/custom_tip_confirm_dialog.dart';
import '../model/make_info.dart';
import '../model/nav_item_id.dart';
import 'waiter_base_controller.dart';

class CookingManagerController extends WaiterBaseController  {
  final _currentNavItemIdObs = NavItemId.allMakeInfo.obs;
  NavItemId get currentNavItemId => _currentNavItemIdObs.value;
  onNavItemSelected(NavItemId navItemId) async {
    if (NavItemId.customerCall == navItemId) {
      reqCallRecord();
      _currentNavItemIdObs(navItemId);
    } else if (NavItemId.statistics == navItemId) {
      reqStatistics();
      _currentNavItemIdObs(navItemId);
    } else if (NavItemId.allMakeInfo == navItemId) {
      if (isOnTableMode.value) {
        isOnTableMode(false);
        _currentNavItemIdObs(navItemId);
        updatePageDataList();
        return;
      }
      if (currentNavItemId == NavItemId.allMakeInfo) {
        isOnServedMode(!isOnServedMode.value);
      }
      _currentNavItemIdObs(navItemId);
      updatePageDataList();
    } else if (NavItemId.waiteToMake == navItemId) {
      if (isOnTableMode.value) {
        isOnTableMode(false);
      }
      _currentNavItemIdObs(navItemId);
      updatePageDataList();
    } else {
      _currentNavItemIdObs(navItemId);
    }
  }

  late PageController pageController;
  int _currentPageIndex = 0;
  int get currentPageIndex => _currentPageIndex;
  updateCurrentPageIndex(int index) => _currentPageIndex = index;

  List<CategoryInfo> dishCategoryList = [];
  Map<int, int> selectedCategoryIdMap = {};

  final loadDishMakeListStateObs = LoadState.loading.obs;
  List<DishMakeDto> dishMakeDtoList = [];
  List<List<DishMakeDto>> pageDataList = [];

  final isOnServedMode = false.obs;

  Timer? timer;
  final dateStringObs = "".obs;
  final timeStringObs = "".obs;
  final currentTimeObs = 0.obs;

  final _updateDishCategoryListObs = true.obs;
  bool get updateDishCategoryList => _updateDishCategoryListObs.value;
  updateDishCategoryListData() {
    _updateDishCategoryListObs(false);
    _updateDishCategoryListObs(true);
  }

  final _isUpdatePageDataObs = true.obs;
  bool get isUpdatePageData => _isUpdatePageDataObs.value;
  updatePageData() {
    _isUpdatePageDataObs(false);
    _isUpdatePageDataObs(true);
  }

  void handleClassPackageUpdate(Map<int, List<DishMakeInfo>> dishMakeInfoClassMap, int classId, DishMakeInfo dishMakeInfoItem) {
    if (NavItemId.allMakeInfo == currentNavItemId) {///调理配膳
      if (isOnServedMode.value) {///已出餐模式
        if (dishMakeInfoItem.status == DishMakeInfoConf.statusWaitToServe) {///待出餐
          if (dishMakeInfoClassMap[classId] != null) {
            dishMakeInfoClassMap[classId]!.add(dishMakeInfoItem);
          } else {
            if (classId == RestaurantConf.categoryBuffetId) {

              dishMakeInfoItem.categoryName = globalController.restaurantData.restaurantBaseInfo.buffetSimpleName ?? "自助";
            } else {
              dishMakeInfoItem.categoryName = globalController.getMainCategoryNameById(dishMakeInfoItem.categoryId);
            }
            dishMakeInfoClassMap[classId] = [dishMakeInfoItem];
          }
        }
      } else {
        if (dishMakeInfoItem.status == DishMakeInfoConf.statusWaitToMake || dishMakeInfoItem.status == DishMakeInfoConf.statusWaitToServe) {///待制作
          if (dishMakeInfoClassMap[classId] != null) {
            dishMakeInfoClassMap[classId]!.add(dishMakeInfoItem);
          } else {
            if (classId == RestaurantConf.categoryBuffetId) {
              dishMakeInfoItem.categoryName = globalController.restaurantData.restaurantBaseInfo.buffetSimpleName ?? "自助";
            } else {
              dishMakeInfoItem.categoryName = globalController.getMainCategoryNameById(dishMakeInfoItem.categoryId);
            }
            dishMakeInfoClassMap[classId] = [dishMakeInfoItem];
          }
        }
      }
    } else {///调理件数
      if (dishMakeInfoItem.status == DishMakeInfoConf.statusWaitToMake) {///待制作
        if (dishMakeInfoClassMap[classId] != null) {
          dishMakeInfoClassMap[classId]!.add(dishMakeInfoItem);
        } else {
          if (classId == RestaurantConf.categoryBuffetId) {
            dishMakeInfoItem.categoryName = globalController.restaurantData.restaurantBaseInfo.buffetSimpleName ?? "自助";
          } else {
            dishMakeInfoItem.categoryName = globalController.getMainCategoryNameById(dishMakeInfoItem.categoryId);
          }
          dishMakeInfoClassMap[classId] = [dishMakeInfoItem];
        }
      }
    }
  }

  void updatePageDataList() {
    Map<int, List<DishMakeInfo>> dishMakeInfoClassMap = {};
    pageDataList.clear();

    for (var mainItem in dishMakeDtoList) {
      dishMakeInfoClassMap.clear();
      mainItem.dishMakeInfoClassList.clear();
      mainItem.orderDateTime??= DateTime.tryParse("${mainItem.orderTime}:00");

      for (var dishMakeInfoItem in mainItem.dishMakeInfos) {
        if (dishMakeInfoItem.orderMode == 1) {///套餐
          if (selectedCategoryIdMap.isNotEmpty) {
            if (selectedCategoryIdMap.containsKey(dishMakeInfoItem.categoryId)) {
              handleClassPackageUpdate(dishMakeInfoClassMap, dishMakeInfoItem.orderPackageId!, dishMakeInfoItem);
            }
          } else {
            handleClassPackageUpdate(dishMakeInfoClassMap, dishMakeInfoItem.orderPackageId!, dishMakeInfoItem);
          }
        } else if (dishMakeInfoItem.orderMode == 2) {///自助
          if (selectedCategoryIdMap.isNotEmpty) {
            if (selectedCategoryIdMap.containsKey(dishMakeInfoItem.categoryId)) {
              handleClassPackageUpdate(dishMakeInfoClassMap, RestaurantConf.categoryBuffetId, dishMakeInfoItem);
            }
          } else {
            handleClassPackageUpdate(dishMakeInfoClassMap, RestaurantConf.categoryBuffetId, dishMakeInfoItem);
          }
        } else {
          if (selectedCategoryIdMap.isNotEmpty) {
            if (selectedCategoryIdMap.containsKey(dishMakeInfoItem.categoryId)) {
              if (NavItemId.allMakeInfo == currentNavItemId) {///调理配膳
                if (isOnServedMode.value) {///已出餐模式
                  if (dishMakeInfoItem.status == DishMakeInfoConf.statusWaitToServe) {///待出餐
                    mainItem.dishMakeInfoClassList.add(dishMakeInfoItem);
                  }
                } else {
                  if (dishMakeInfoItem.status == DishMakeInfoConf.statusWaitToMake || dishMakeInfoItem.status == DishMakeInfoConf.statusWaitToServe) {
                    mainItem.dishMakeInfoClassList.add(dishMakeInfoItem);
                  }
                }
              } else {///调理件数
                if (dishMakeInfoItem.status == DishMakeInfoConf.statusWaitToMake) {///待制作
                  mainItem.dishMakeInfoClassList.add(dishMakeInfoItem);
                }
              }
            }
          } else {
            if (NavItemId.allMakeInfo == currentNavItemId) {///调理配膳
              if (isOnServedMode.value) {///已出餐模式
                if (dishMakeInfoItem.status == DishMakeInfoConf.statusWaitToServe) {///待出餐
                  mainItem.dishMakeInfoClassList.add(dishMakeInfoItem);
                }
              } else {
                if (dishMakeInfoItem.status == DishMakeInfoConf.statusWaitToMake || dishMakeInfoItem.status == DishMakeInfoConf.statusWaitToServe) {
                  mainItem.dishMakeInfoClassList.add(dishMakeInfoItem);
                }
              }
            } else {///调理件数
              if (dishMakeInfoItem.status == DishMakeInfoConf.statusWaitToMake) {///待制作
                mainItem.dishMakeInfoClassList.add(dishMakeInfoItem);
              }
            }
          }
        }
      }

      mainItem.dishMakeInfoClassList.addAll(dishMakeInfoClassMap.values.toList());
    }

    List<DishMakeDto> dataList = [];

    for (var mainItem in dishMakeDtoList) {
      if (mainItem.dishMakeInfoClassList.isNotEmpty) {
        bool isAllServed = true;///是否是全部已出餐
        for(var dishMakeInfoClass in mainItem.dishMakeInfoClassList) {
          if (dishMakeInfoClass is DishMakeInfo) {
            if (dishMakeInfoClass.status != DishMakeInfoConf.statusServed) {
              isAllServed = false;
              break;
            }
          } else if (dishMakeInfoClass is List<DishMakeInfo>) {
            for(var dishMakeInfoItem in dishMakeInfoClass) {
              if (dishMakeInfoItem.status != DishMakeInfoConf.statusServed) {
                isAllServed = false;
                break;
              }
            }
          }
        }
        if (!isAllServed) {
          dataList.add(mainItem);
        }
      }
    }

    int subItemCount = 5;
    for (int i = 0; i < dataList.length; i += subItemCount) {
      final subList = dataList.sublist(i, i + subItemCount < dataList.length ? i + subItemCount : dataList.length);
      pageDataList.add(subList);
    }
  }

  @override
  void onInit() {
    pageController = PageController(initialPage: currentPageIndex, keepPage: true, /*viewportFraction: 0.8*/);
    dateStringObs(formatDate(DateTime.now(), [yyyy, ".", mm, ".", dd]));
    timeStringObs(formatDate(DateTime.now(), [HH, ":", nn]));

    currentTimeObs(DateTime.now().millisecondsSinceEpoch);

    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      dateStringObs(formatDate(DateTime.now(), [yyyy, ".", mm, ".", dd]));
      timeStringObs(formatDate(DateTime.now(), [HH, ":", nn]));

      //currentTimeObs(DateTime.now().millisecondsSinceEpoch);
    });

    dishCategoryList = globalController.restaurantData.categoryInfos;
    for(var item in dishCategoryList) {
      selectedCategoryIdMap[item.id] = item.id;
    }

    super.onInit();

    reqFoodMakeList();
    reqCornerMarkersCount();
  }

  @override
  void onMakeListUpdateEvent() {
    reqFoodMakeListQuite();
  }

  @override
  void onClose() {
    pageController.dispose();
    timer?.cancel();
    super.onClose();
  }

  void onPageChanged(int index) {
    updateCurrentPageIndex(index);
  }

  void onPreBtnClicked() {
    if (currentNavItemId == NavItemId.waiteToMake || currentNavItemId == NavItemId.allMakeInfo) {
      if (!isOnTableMode.value) {
        pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,);
      }
    }
  }

  void onNextBtnClicked() {
    if (currentNavItemId == NavItemId.waiteToMake || currentNavItemId == NavItemId.allMakeInfo) {
      if (!isOnTableMode.value) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,);
      }
    }
  }

  onBackItemClicked() {
    if (isOnTableMode.value) {
      if (isOnOrderListMode.value) {
        isOnOrderListMode(false);
        return;
      } else {
        isOnTableMode(false);
        return;
      }
    }

    if (currentNavItemId == NavItemId.customerCall
        || currentNavItemId == NavItemId.statistics
        || currentNavItemId == NavItemId.storeOperation
        || currentNavItemId == NavItemId.waiteToMake
    ) {
      onNavItemSelected(NavItemId.allMakeInfo);
      return;
    }

    if (currentNavItemId == NavItemId.allMakeInfo) {
      reqRollbackOperate();
    }
  }

  void onDishCategoryItemClicked(CategoryInfo categoryInfo) {
    if (selectedCategoryIdMap.containsKey(categoryInfo.id)) {
      selectedCategoryIdMap.remove(categoryInfo.id);
    } else {
      selectedCategoryIdMap[categoryInfo.id] = categoryInfo.id;
    }

    updateDishCategoryListData();
    updatePageDataList();
    updatePageData();
  }

  void onDishMakeInfoItemClicked(DishMakeDto item, DishMakeInfo model) {
    if (NavItemId.waiteToMake == currentNavItemId) {
      return;
    }

    if (!isOnServedMode.value) {
      reqFoodMade(OperateCompleteReq(item.tableNumber, item.batchNumber, model.orderDetailId), model);
    } else if (DishMakeInfoConf.statusWaitToServe == model.status && isOnServedMode.value) {
      reqFoodServed(OperateCompleteReq(item.tableNumber, item.batchNumber, model.orderDetailId), model);
    }

  }

  void reqFoodMakeList() {
    loadDishMakeListStateObs(LoadState.loading);
    dataRepository.reqFoodMakeList().then((BaseResp baseResp) async{
      if(baseResp.isSuccess()) {
        List<DishMakeDto> dataList = [];
        baseResp.data.forEach((v) {
          dataList.add(DishMakeDto.fromJson(v));
        });
        dishMakeDtoList = dataList;
        updatePageDataList();
        loadDishMakeListStateObs(LoadState.success);
      } else {
        showApiErrToast(baseResp.status, baseResp.message);
        loadDishMakeListStateObs(LoadState.failed);
      }
    }, onError:(err) {
      handleException(err);
      loadDishMakeListStateObs(LoadState.failed);
    } );
  }

  void reqFoodMakeListQuite() {
    dataRepository.reqFoodMakeList().then((BaseResp baseResp) async{
      if(baseResp.isSuccess()) {
        List<DishMakeDto> dataList = [];
        baseResp.data.forEach((v) {
          dataList.add(DishMakeDto.fromJson(v));
        });
        dishMakeDtoList = dataList;
        updatePageDataList();
        updatePageData();

        reqCornerMarkersCount(quite: true);
      } else {
        //showApiErrToast(baseResp.message);
      }
    }, onError:(err) {
      //handleException(err);
    } );
  }

  ///上菜完成
  void reqFoodServed(OperateCompleteReq req, DishMakeInfo model) {
    dataRepository.reqFoodServed(req).then((BaseResp baseResp) async{
      if(baseResp.isSuccess()) {
        model.status = DishMakeInfoConf.statusServed;
        updatePageDataList();
        updatePageData();
      } else {
        showApiErrToast(baseResp.status, baseResp.message);
        reqFoodMakeListQuite();
      }
    }, onError:(err) {
      handleException(err);
    } );
  }

  ///制作完成
  void reqFoodMade(OperateCompleteReq req, DishMakeInfo model) {
    dataRepository.reqFoodMade(req).then((BaseResp baseResp) async{
      if(baseResp.isSuccess()) {
        if (DishMakeInfoConf.statusWaitToMake == model.status) {
          model.status = DishMakeInfoConf.statusWaitToServe;
        } else if (DishMakeInfoConf.statusWaitToServe == model.status) {
          model.status = DishMakeInfoConf.statusWaitToMake;
        }
        updatePageData();
      } else {
        showApiErrToast(baseResp.status, baseResp.message);
        reqFoodMakeListQuite();
      }
    }, onError:(err) {
      handleException(err);
    } );
  }

  ///操作回退
  void reqRollbackOperate() {
    dataRepository.reqRollbackOperate().then((BaseResp baseResp) async{
      if(baseResp.isSuccess()) {
        reqFoodMakeListQuite();
      } else {
        showApiErrToast(baseResp.status, baseResp.message);
      }
    }, onError:(err) {
      handleException(err);
    } );
  }

  void onTableItemClicked(TableInfoResp tableInfoResp) {
    if (tableInfoResp.tableStatus == 0) {///空桌
      Get.dialog(CustomTipConfirmDialog(tipContent: "${tableInfoResp.tableNumber}卓で注文開始でよろしいですか？", onCancel: (){
        Get.back();
      }, onConfirm: (){
        Get.back();
        onHelperCustomerShopping(tableInfoResp);
      },), barrierColor: Colors.transparent, useSafeArea: false);
    } else {
      selectedTableInfoResp = tableInfoResp;
      isOnOrderListMode(true);
      reqOrderDetail(tableInfoResp);
    }
  }

  void onHelperCustomerShopping(TableInfoResp tableInfoResp) {
    dataRepository.reqOrderDetail(tableInfoResp.tableId.toString()).then((BaseResp baseResp) async{
      if(baseResp.isSuccess()) {
        if (baseResp.data != null) {///已有订单
          final orderDetailResp = OrderDetailResp.fromJson(baseResp.data);
          globalController.handleOrderDetailUpdate(orderDetailResp);

          final tableInfo = TableInfo(tableInfoResp.tableId, tableInfoResp.tableNumber);
          globalController.waiterSelectedTableInfo = tableInfo;

          Get.toNamed(Routes.mainDishPage)?.then((value){
            globalController.waiterSelectedTableInfo = null;
            reqTableInfoList();
          });
        } else {
          globalController.handleOrderDetailUpdate(null);

          final tableInfo = TableInfo(tableInfoResp.tableId, tableInfoResp.tableNumber);
          globalController.waiterSelectedTableInfo = tableInfo;
          Get.toNamed(Routes.selectDinersPage)?.then((value){
            //globalController.waiterSelectedTableInfo = null;
            reqTableInfoList();
          });
        }
      } else {
        showApiErrToast(baseResp.status, baseResp.message);
      }
    }, onError:(err) {
      handleException(err);
    } );
  }

  void onMenuListModeClicked() {
    if (isOnTableMode.value) {
      isOnTableMode(false);
    }
  }

  void onTableModeClicked() {
    if (!isOnTableMode.value) {
      isOnOrderListMode(false);
      isOnTableMode(true);
      reqTableInfoList();
    } else {
      if (isOnOrderListMode.value) {
        isOnOrderListMode(false);
      }
    }
  }

  String getBuffetRemainingTime(String startOrderTime) {
    DateTime? startDateTime = DateTime.tryParse("$startOrderTime:00");
    if (startDateTime != null) {
      startDateTime = startDateTime.add(Duration(minutes: globalController.restaurantData.restaurantBaseInfo.buffetDiningTime));
      int rel = (startDateTime.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch);
      return formatDate(DateTime.fromMillisecondsSinceEpoch(rel, isUtc: true), [HH, ":", nn, ":", ss]);
    }

    return "";
  }

}

