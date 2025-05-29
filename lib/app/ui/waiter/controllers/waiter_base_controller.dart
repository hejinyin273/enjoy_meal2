
import 'dart:async';

import 'package:enjoy_meal/app/local/custom_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../base/data/protocol/response/base_resp.dart';
import '../../../base/ui/base_controller.dart';
import '../../../data/local/preference/preference_manager.dart';
import '../../../base/data/event_bus.dart';
import '../../../data/model/load_state.dart';
import '../../../data/model/restaurant_data.dart';
import '../../../data/protocol/request/modify_order_req.dart';
import '../../../data/protocol/request/update_shelf_req.dart';
import '../../../data/protocol/response/call_record_resp.dart';
import '../../../data/protocol/response/marker_count _resp.dart';
import '../../../data/protocol/response/order_detail_resp.dart';
import '../../../data/protocol/response/statistics_resp.dart';
import '../../../data/protocol/response/table_info_resp.dart';
import '../../../data/repository/data_repository.dart';
import '../../../routes/app_pages.dart';
import '../../dialog/custom_tip_confirm_dialog.dart';
import '../../dialog/pay_bill_select_dialog.dart';
import '../../dialog/store_operation_dialog.dart';
import '../../global_controller.dart';

abstract class WaiterBaseController extends BaseController{
  final DataRepository dataRepository = Get.find(tag: (DataRepository).toString());
  final PreferenceManager preferenceManager = Get.find(tag: (PreferenceManager).toString());
  final GlobalController globalController = Get.find<GlobalController>();

  StreamSubscription? _makeListUpdateSubscription;
  StreamSubscription? _callStaffSubscription;

  ///坐席番号
  final isOnTableMode = false.obs;

  final loadTableInfoListStateObs = LoadState.loading.obs;
  List<TableInfoResp> tableInfoRespList = [];
  ///坐席番号-订单列表
  final isOnOrderListMode = false.obs;
  TableInfoResp? selectedTableInfoResp;
  late OrderDetailResp orderDetailResp;
  final _loadOrderDetailStateObs = LoadState.loading.obs;
  LoadState get loadOrderDetailState => _loadOrderDetailStateObs.value;
  ScrollController listScrollController = ScrollController();

  ///库存上下架
  final storeDataUpdateObs = true.obs;
  final List<DishInfo> storeDishInfoList = [];
  final List<PackageInfo> storePackageInfoList = [];
  late TextEditingController dishIdController;
  late FocusNode dishIdNode;

  ///呼叫记录
  final loadCallRecordStateObs = LoadState.loading.obs;
  List<CallRecordResp> callRecordRespList = [];
  
  ///角标
  final markerCountRespObs = MarkerCountResp(0, 0).obs;

  ///统计
  final statisticsTabIndexObs = 0.obs;
  final loadStatisticsStateObs = LoadState.loading.obs;
  StatisticsResp? statisticsResp;

  @override
  void onInit() {
    dishIdController = TextEditingController();
    dishIdNode = FocusNode();

    _makeListUpdateSubscription = eventBus.on<PushMsgEvent>().listen((PushMsgEvent event) {
      if ("DISH_MAKE_LIST_MODIFY" == event.action) {
        onMakeListUpdateEvent();
      } else if ("CALL_STAFF" == event.action || "CALL_STAFF_CONFIRM" == event.action ) {
        reqCornerMarkersCount(quite: true);
      } else if ("DISH_STOCK_CHANGED" == event.action) {
        updateStoreDishAndPackageList();
        storeDataUpdateObs(false);
        storeDataUpdateObs(true);
      } else if ("ORDER_COMPLETE" == event.action) {
        if (isOnTableMode.value) {///坐席番号页面
          if (isOnOrderListMode.value) {///订单详情页面
            if (event.data["data"] != null) {
              final tableId = event.data["data"]["tableId"];
              if (selectedTableInfoResp != null && selectedTableInfoResp!.tableId == tableId) {
                if (Get.isDialogOpen != null && Get.isDialogOpen!) {
                  Get.back();
                }
              }
            }
            isOnOrderListMode(false);
            reqTableInfoList();
          } else {
            reqTableInfoList();
          }
        }
      } else if ("ORDER_DETAIL_CHANGED" == event.action) {
        if (isOnTableMode.value) {///坐席番号页面
          if (isOnOrderListMode.value) {///订单详情页面
            if (event.data["data"] != null) {
              final tableId = event.data["data"]["tableId"];
              if (selectedTableInfoResp != null && selectedTableInfoResp!.tableId == tableId) {
                reqOrderDetail(selectedTableInfoResp!);
              }
            }
            reqTableInfoList();
          } else {
            reqTableInfoList();
          }
        }
      }
    });
    super.onInit();
  }

  void onMakeListUpdateEvent() {}

  @override
  void onClose() {
    dishIdController.dispose();
    dishIdNode.dispose();
    storeDataUpdateObs.close();
    loadCallRecordStateObs.close();
    _makeListUpdateSubscription?.cancel();
    _makeListUpdateSubscription = null;
    _callStaffSubscription?.cancel();
    _callStaffSubscription = null;
    super.onClose();
  }

  void onConfirmCallClicked(CallRecordResp item) {
    reqConfirmCall(item.id);
  }

  ///坐席番号-订单列表
  void onSubtractClicked(dynamic model) {
    handleOrderModify(model, -1);
  }

  void onAddBtnClicked(dynamic model) {
    handleOrderModify(model, 1);
  }

  void handleOrderModify(dynamic model, int updateCount) {
    if (selectedTableInfoResp == null) return;
    final modifyOrderReq = ModifyOrderReq(selectedTableInfoResp!.tableId);
    if (model is OrderDetailDish) {
      List<DishOrderReq> dataList = [];
      dataList.add(DishOrderReq(model.orderDishId, model.dishQuantity + updateCount));
      modifyOrderReq.dishOrderReqs = dataList;
    } else if (model is OrderDetailPackage) {
      List<PackageOrderReq> dataList = [];
      dataList.add(PackageOrderReq(model.orderPackageId, model.packageQuantity + updateCount));
      modifyOrderReq.packageOrderReqs = dataList;
    }
    showLoadingDialog(null);
    dataRepository.reqModifyOrder(modifyOrderReq).then((BaseResp baseResp) async{
      if(baseResp.isSuccess()) {
        dataRepository.reqOrderDetail(selectedTableInfoResp!.tableId.toString()).then((BaseResp baseResp) async{
          hideLoadingDialog();
          if(baseResp.isSuccess()) {
            if (baseResp.data != null) {
              orderDetailResp = OrderDetailResp.fromJson(baseResp.data);
            }
            _loadOrderDetailStateObs(LoadState.loading);
            _loadOrderDetailStateObs(LoadState.success);
          } else {
            showApiErrToast(baseResp.status, baseResp.message);
          }
        }, onError:(err) {
          handleException(err);
          hideLoadingDialog();
        } );
      } else {
        hideLoadingDialog();
        showApiErrToast(baseResp.status, baseResp.message);
      }
    }, onError: (err) {
      hideLoadingDialog();
      handleException(err);
    });
  }

  ///追加料理
  void onAddMoreDishItemClicked() {
    if (LoadState.success == loadOrderDetailState) {
      Get.dialog(CustomTipConfirmDialog(tipContent: CustomLocalizations.text("need_to_add_order"), onCancel: (){
        Get.back();
      }, onConfirm: (){
        Get.back();
        globalController.handleOrderDetailUpdate(orderDetailResp);
        final tableInfo = TableInfo(selectedTableInfoResp!.tableId, selectedTableInfoResp!.tableNumber);
        globalController.waiterSelectedTableInfo = tableInfo;
        globalController.reqOrderDetail();
        Get.toNamed(Routes.mainDishPage)?.then((value){
          globalController.waiterSelectedTableInfo = null;
          reqOrderDetail(selectedTableInfoResp!);
        });
      },), barrierColor: Colors.transparent, useSafeArea: false);
    }
  }

  ///结账
  void onPayBillItemClicked() {
    if (LoadState.success == loadOrderDetailState) {
      Get.dialog(PayBillSelectDialog(onCancel: (){
        Get.back();
      }, onConfirm: (int index){
        if (index == 0) {
          Get.back();
        } else if (index == 1) {
          reqOrderComplete(selectedTableInfoResp!);
          Get.back();
        } else {
          reqOrderComplete(selectedTableInfoResp!);
          Get.back();
        }
      },), barrierColor: Colors.transparent, useSafeArea: false);
    }
  }

  void reqTableInfoList() {
    loadTableInfoListStateObs(LoadState.loading);
    dataRepository.reqTableList().then((BaseResp baseResp) async{
      if(baseResp.isSuccess()) {
        List<TableInfoResp> dataList = [];
        baseResp.data.forEach((v) {
          dataList.add(TableInfoResp.fromJson(v));
        });
        tableInfoRespList = dataList;

        loadTableInfoListStateObs(LoadState.success);
      } else {
        showApiErrToast(baseResp.status, baseResp.message);
        loadTableInfoListStateObs(LoadState.failed);
      }
    }, onError:(err) {
      handleException(err);
      loadTableInfoListStateObs(LoadState.failed);
    } );
  }

  void reqOrderComplete(TableInfoResp tableInfoResp) {
    dataRepository.reqOrderComplete(tableInfoResp.tableId.toString()).then((BaseResp baseResp) async{
      if(baseResp.isSuccess()) {
        isOnOrderListMode(false);
        reqTableInfoList();
      } else {
        showApiErrToast(baseResp.status, baseResp.message);
      }
    }, onError:(err) {
      handleException(err);
    } );
  }

  void reqOrderDetail(TableInfoResp tableInfoResp) {
    _loadOrderDetailStateObs(LoadState.loading);
    dataRepository.reqOrderDetail(tableInfoResp.tableId.toString()).then((BaseResp baseResp) async{
      if(baseResp.isSuccess()) {
        if (baseResp.data != null) {
          orderDetailResp = OrderDetailResp.fromJson(baseResp.data);
        }
        _loadOrderDetailStateObs(LoadState.success);
      } else {
        showApiErrToast(baseResp.status, baseResp.message);
        _loadOrderDetailStateObs(LoadState.failed);
      }
    }, onError:(err) {
      handleException(err);
      _loadOrderDetailStateObs(LoadState.failed);
    } );
  }

  ///呼叫记录
  void reqCallRecord() {
    loadCallRecordStateObs(LoadState.loading);
    dataRepository.reqCallRecord().then((BaseResp baseResp) async{
      if(baseResp.isSuccess()) {
        List<CallRecordResp> dataList = [];
        baseResp.data.forEach((v) {
          dataList.add(CallRecordResp.fromJson(v));
        });
        callRecordRespList = dataList;

        loadCallRecordStateObs(LoadState.success);
      } else {
        loadCallRecordStateObs(LoadState.failed);
        showApiErrToast(baseResp.status, baseResp.message);
      }
    }, onError:(err) {
      loadCallRecordStateObs(LoadState.failed);
      handleException(err);
    } );
  }

  void reqConfirmCall(int id) {
    dataRepository.reqCallConfirm(id).then((BaseResp baseResp) async{
      if(baseResp.isSuccess()) {
        for(var item in callRecordRespList) {
          if (item.id == id) {
            callRecordRespList.remove(item);
            loadCallRecordStateObs(LoadState.loading);
            loadCallRecordStateObs(LoadState.success);
            break;
          }
        }
      } else {
        showApiErrToast(baseResp.status, baseResp.message);
      }
    }, onError:(err) {
      handleException(err);
    } );
  }

  ///统计
  void reqStatistics() {
    loadStatisticsStateObs(LoadState.loading);
    dataRepository.reqStatistics().then((BaseResp baseResp) async{
      if(baseResp.isSuccess()) {
        if (baseResp.data != null) {
          statisticsResp = StatisticsResp.fromJson(baseResp.data);
        }

        loadStatisticsStateObs(LoadState.success);
      } else {
        showApiErrToast(baseResp.status, baseResp.message);
        loadStatisticsStateObs(LoadState.failed);
      }
    }, onError:(err) {
      handleException(err);
      loadStatisticsStateObs(LoadState.failed);
    } );
  }

  ///角标
  void reqCornerMarkersCount({bool quite = false}) {
    dataRepository.reqCornerMarkersCount().then((BaseResp baseResp) async{
      if(baseResp.isSuccess()) {
        if (baseResp.data != null) {
          final markerCountResp = MarkerCountResp.fromJson(baseResp.data);
          markerCountRespObs(markerCountResp);
        }
      } else {
        if (quite) {
          showApiErrToast(baseResp.status, baseResp.message);
        }
      }
    }, onError:(err) {
      if (quite) {
        handleException(err);
      }
    } );
  }

  ///上下架
  void onStoreDishIdInputChanged() {
    updateStoreDishAndPackageList();
    storeDataUpdateObs(false);
    storeDataUpdateObs(true);
  }
  
  void updateStoreDishAndPackageList() {
    storePackageInfoList.clear();
    List<DishInfo> dishInfoDataList = [];
    for(var mainItem in globalController.restaurantData.categoryInfos) {
      if (mainItem.categoryType == RestaurantConf.categoryTypeDish) {///一级分类下直接是菜品
        if (mainItem.dishList.isNotEmpty) {
          dishInfoDataList.addAll(mainItem.dishList);
        }
      } else if (mainItem.categoryType == RestaurantConf.categoryTypePackage) {///一级分类下直接是套餐--当前就一种-->拉麺セツト(昼限定)
        if (mainItem.packageInfo != null) {
          storePackageInfoList.add(mainItem.packageInfo!);
        }
      } else if (mainItem.categoryType == RestaurantConf.categoryTypeBuffet) {///自定义-自助
        continue;
      } else {
        for(var subItem in mainItem.children) {
          if (subItem.categoryType == RestaurantConf.categoryTypeDish) {///二级分类下是菜品
            if (subItem.dishList.isNotEmpty) {
              dishInfoDataList.addAll(subItem.dishList);
            }
          } else if (subItem.categoryType == RestaurantConf.categoryTypePackage){///二级分类下是套餐
            if (mainItem.packageInfo != null) {
              storePackageInfoList.add(subItem.packageInfo!);
            }
          }
        }
      }
    }
    dishInfoDataList.sort((a, b) => a.dishOwnId.compareTo(b.dishOwnId));

    storeDishInfoList.clear();
    final inputNum = dishIdController.text;
    if (inputNum.isNotEmpty) {
      for (var dishInfoItem in dishInfoDataList) {
        if (dishInfoItem.dishOwnId.toString().contains(inputNum)) {
          storeDishInfoList.add(dishInfoItem);
        }
      }
    } else {
      storeDishInfoList.addAll(dishInfoDataList);
    }

  }

  void onStoreOperationClicked(DishInfo dishInfo) {
    Get.dialog(StoreOperationDialog(dishInfo: dishInfo, onCancel: (){
      Get.back();
    }, onConfirm: (int number, bool isValid){
      Get.back();
      reqUpdateShelf(dishInfo, number, isValid);
    }), barrierColor: Colors.transparent, useSafeArea: false);
  }

  void reqUpdateShelf(DishInfo dishInfo, int number, bool isValid) {
    UpdateShelfReq updateShelfReq = UpdateShelfReq(dishInfo.dishOwnId.toString(), isValid ? 1 :0, -1, null);
    dataRepository.reqUpdateShelf(updateShelfReq).then((BaseResp baseResp) async{
      if(baseResp.isSuccess()) {

      } else {
        showApiErrToast(baseResp.status, baseResp.message);
      }
    }, onError:(err) {
      handleException(err);
    } );
  }

}