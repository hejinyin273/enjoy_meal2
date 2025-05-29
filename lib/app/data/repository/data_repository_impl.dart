

import 'package:dio/dio.dart';
import 'package:enjoy_meal/app/base/data/model/download_listener.dart';
import 'package:enjoy_meal/app/base/data/protocol/response/base_resp.dart';
import 'package:enjoy_meal/app/data/protocol/request/login_req.dart';
import 'package:enjoy_meal/app/data/protocol/request/operate_complete_req.dart';
import 'package:enjoy_meal/app/data/protocol/request/prepare_order_req.dart';
import 'package:enjoy_meal/app/data/protocol/request/submit_order_req.dart';
import 'package:enjoy_meal/app/data/protocol/request/update_shelf_req.dart';

import '../../base/data/net/net_client.dart';
import '../protocol/request/modify_order_req.dart';
import 'data_repository.dart';

class DataRepositoryImpl implements DataRepository {

  @override
  Future<BaseResp> reqLogin(LoginReq loginReq) {
    return NetClient().requestBase(Method.post, "/api/v1/restaurant/login", data: loginReq.toMap());
  }

  @override
  Future<BaseResp> reqBuffetAddTime(int tableId) {
    return NetClient().requestBase(Method.post, "/api/v1/restaurant/addTime", data: {"tableId" : tableId});
  }

  @override
  Future<BaseResp> reqCallConfirm(int id) {
    return NetClient().requestBase(Method.post, "/api/v1/waiter/confirmCall/$id");
  }

  @override
  Future<BaseResp> reqCallRecord() {
    return NetClient().requestBase(Method.get, "/api/v1/waiter/callRecord");
  }

  @override
  Future<BaseResp> reqCallStaff(int id) {
    return NetClient().requestBase(Method.post, "/api/v1/restaurant/callStaff/$id");
  }

  @override
  Future<BaseResp> reqCallStaffCheckout() {
    return NetClient().requestBase(Method.post, "/api/v1/restaurant/callWaiterForCheckout");
  }

  @override
  Future<BaseResp> reqHotDishList() {
    return NetClient().requestBase(Method.get, "/api/v1/restaurant/hotDishes");
  }

  @override
  Future<BaseResp> reqNotifyAck(String messageId) {
    return NetClient().requestBase(Method.post, "/api/v1/restaurant/ack/$messageId");
  }

  @override
  Future<BaseResp> reqOrderComplete(String tableId) {
    return NetClient().requestBase(Method.post, "/api/v1/waiter/orderComplete/$tableId");
  }

  @override
  Future<BaseResp> reqOrderDetail(String tableId) {
    return NetClient().requestBase(Method.get, "/api/v1/restaurant/orderDetail/$tableId");
  }

  @override
  Future<BaseResp> reqPrepareOrder(PrepareOrderReq prepareOrderReq) {
    return NetClient().requestBase(Method.post, "/api/v1/restaurant/prepareOrder", data: prepareOrderReq.toMap());
  }

  @override
  Future<BaseResp> reqCheckOrder(String tableId) {
    return NetClient().requestBase(Method.get, "/api/v1/restaurant/checkOrder/$tableId");
  }

  @override
  Future<BaseResp> reqRestaurantInfo() {
    return NetClient().requestBase(Method.get, "/api/v1/restaurant/info");
  }

  @override
  Future<BaseResp> reqSubmitOrder(SubmitOrderReq submitOrderReq) {
    return NetClient().requestBase(Method.post, "/api/v1/restaurant/submitOrder", data: submitOrderReq.toMap());
  }

  @override
  Future<BaseResp> reqTableList() {
    return NetClient().requestBase(Method.get, "/api/v1/waiter/tableList");
  }

  @override
  Future<BaseResp> reqUpdateShelf(UpdateShelfReq updateShelfReq) {
    return NetClient().requestBase(Method.post, "/api/v1/waiter/shelf", data: updateShelfReq.toMap());
  }

  @override
  Future<BaseResp> reqFoodMade(OperateCompleteReq operateCompleteReq) {
    return NetClient().requestBase(Method.post, "/api/v1/make/made", data: operateCompleteReq.toMap());
  }

  @override
  Future<BaseResp> reqFoodMakeList() {
    return NetClient().requestBase(Method.get, "/api/v1/make/list");
  }

  @override
  Future<BaseResp> reqFoodServed(OperateCompleteReq operateCompleteReq) {
    return NetClient().requestBase(Method.post, "/api/v1/make/foodServed", data: operateCompleteReq.toMap());
  }

  @override
  Future<BaseResp> reqRollbackOperate() {
    return NetClient().requestBase(Method.post, "/api/v1/make/rollback");
  }

  @override
  Future<BaseResp> reqCornerMarkersCount() {
    return NetClient().requestBase(Method.get, "/api/v1/waiter/cornerMarkersCount");
  }

  @override
  Future<BaseResp> reqModifyOrder(ModifyOrderReq modifyOrderReq) {
    return NetClient().requestBase(Method.post, "/api/v1/waiter/modifyOrder", data: modifyOrderReq.toMap());
  }

  @override
  Future<BaseResp> reqStatistics() {
    return NetClient().requestBase(Method.get, "/api/v1/waiter/statistics");
  }

  @override
  Future<BaseResp> reqLatestVersion() {
    return NetClient().requestBase(Method.get, "/api/v1/app/currentVersion");
  }

  @override
  Future<void> doDownload(String url, String savePath, {required String fileId, required CancelToken cancelToken, DownloadListener? downloadListener}) {
    return NetClient().doDownload(url, savePath, fileId: fileId, cancelToken: cancelToken, downloadListener: downloadListener);
  }

}