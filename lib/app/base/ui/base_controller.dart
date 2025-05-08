
import 'dart:io';

import 'package:enjoy_meal/app/local/custom_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../routes/app_pages.dart';
import '../config/base_conf.dart';
import '../config/font_weight_conf.dart';
import '../data/net/exceptions/base_exception.dart';
import '../data/net/exceptions/custom_status_code_exception.dart';
import '../data/net/exceptions/unauthorize_exception.dart';
import '../utils/log_util.dart';
import '../widget/progress_dialog.dart';


abstract class BaseController extends GetxController {
  final Logger logger = LogUtil().logger;
  final _messageController = ''.obs;
  String get message => _messageController.value;
  showMessage(String msg) => _messageController(msg);

  FToast? _fToast;

  void showToast(String message) {
    if (_fToast == null) {
      _fToast = FToast();
      _fToast?.init(Get.context!);
    }
    _showToastImpl(message);
  }

  void _showToastImpl(String message) {
    Widget toast = Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
      margin: EdgeInsets.only(bottom: 120.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: const Color(0xFFFFFFFF),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFFBDCADC), // 阴影颜色
              offset: Offset(0.0, 2.h), // 阴影的偏移量
              blurRadius: 8.r, // 阴影的模糊半径
              blurStyle: BlurStyle.normal
          ),
        ],
      ),
      child: Text(message, style: TextStyle(color: const Color(0xFF333333), fontSize: 14.sp, fontWeight: FontWeightConf.medium),),
    );


    _fToast?.removeCustomToast();
    _fToast?.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(milliseconds: 1200),
    );
  }

  void showApiErrToast(int status, String? message) {
    if (message != null && message.isNotEmpty) {
      showToast(message);
    } else {
      showToast(CustomLocalizations.text("api_err"));
    }
    if (status == 401) {
      BaseConf.token = "";
      Get.offAllNamed(Routes.loginPage);
    }
  }

  void handleException(Exception exception) {
    if (exception is UnauthorizedException) {
      BaseConf.token = "";
      Get.offAllNamed(Routes.loginPage);
    } else if(exception is BaseException) {
      showToast(exception.message);
      //showToast(CustomLocalizations.text("net_err"));
    }
  }

  void showLoadingDialog(String? msg, {EdgeInsetsGeometry? loadingMargin}){
    Get.dialog(ProgressDialog(loading: true, msg: msg, loadingMargin: loadingMargin), barrierColor: Colors.transparent, useSafeArea: false);
  }

  void hideLoadingDialog(){
    if (Get.isDialogOpen != null && Get.isDialogOpen!) {
      Get.back();
    }
  }

  @override
  void onClose() {
    _messageController.close();
    Future.delayed(const Duration(seconds: 1), (){
      _fToast?.removeCustomToast();
      _fToast?.removeQueuedCustomToasts();
      _fToast = null;
    });
    super.onClose();
  }

  void onPopInvokedWithResult(bool pop, Object? data){

  }

  void handleLogout() async{
    logger.i("handleLogout()");
    BaseConf.token = "";
    //Get.offAllNamed(Routes.loginPage);
  }

}