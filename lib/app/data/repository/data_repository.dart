

import 'package:dio/dio.dart';

import '../../base/data/model/download_listener.dart';
import '../../base/data/protocol/response/base_resp.dart';
import '../protocol/request/login_req.dart';
import '../protocol/request/operate_complete_req.dart';
import '../protocol/request/prepare_order_req.dart';
import '../protocol/request/submit_order_req.dart';
import '../protocol/request/update_shelf_req.dart';

abstract class DataRepository {

  Future<BaseResp> reqLogin(LoginReq loginReq);

  ///呼叫员工  call_staff记录的id
  Future<BaseResp> reqCallStaff(int id);

  ///呼叫服务员结算
  Future<BaseResp> reqCallStaffCheckout();

  ///呼叫确认 呼叫记录的id
  Future<BaseResp> reqCallConfirm(int id);

  ///呼叫记录
  Future<BaseResp> reqCallRecord();

  ///人气排行
  Future<BaseResp> reqHotDishList();

  ///请求餐厅详情
  Future<BaseResp> reqRestaurantInfo();

  ///订单完成
  Future<BaseResp> reqOrderComplete(String tableId);

  ///查询订单详情
  Future<BaseResp> reqOrderDetail(String tableId);

  ///选人数后下单-预占餐桌,选完人数后调用此接口生成订单
  Future<BaseResp> reqPrepareOrder(PrepareOrderReq prepareOrderReq);

  ///查询餐桌是否存在订单
  Future<BaseResp> reqCheckOrder(String tableId);

  ///上下架及库存修改
  Future<BaseResp> reqUpdateShelf(UpdateShelfReq updateShelfReq);

  ///提交订单(注文)
  Future<BaseResp> reqSubmitOrder(SubmitOrderReq submitOrderReq);

  ///餐桌列表
  Future<BaseResp> reqTableList();

  ///自助餐加时 返回加时分钟数
  Future<BaseResp> reqBuffetAddTime(int tableId);

  ///收到推送后的回调
  Future<BaseResp> reqNotifyAck(String messageId);


  ///上菜完成
  Future<BaseResp> reqFoodServed(OperateCompleteReq operateCompleteReq);

  ///上制作完成
  Future<BaseResp> reqFoodMade(OperateCompleteReq operateCompleteReq);

  ///制作列表
  Future<BaseResp> reqFoodMakeList();

  ///操作回退
  Future<BaseResp> reqRollbackOperate();

  ///角标统计
  Future<BaseResp> reqCornerMarkersCount();

  ///服务员修改订单
  Future<BaseResp> reqModifyOrder();

  ///统计
  Future<BaseResp> reqStatistics();

  ///操作回退
  Future<BaseResp> reqLatestVersion();

  Future<void> doDownload(String url, String savePath, {required String fileId, required CancelToken cancelToken, DownloadListener? downloadListener});
}
