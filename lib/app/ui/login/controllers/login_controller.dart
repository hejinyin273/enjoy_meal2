

import 'package:enjoy_meal/app/base/data/protocol/response/base_resp.dart';
import 'package:enjoy_meal/app/config/constants.dart';
import 'package:enjoy_meal/app/data/protocol/request/login_req.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/config/base_conf.dart';
import '../../../base/ui/base_controller.dart';
import '../../../data/local/preference/preference_manager.dart';
import '../../../data/repository/data_repository.dart';
import '../../../routes/app_pages.dart';

class LoginController extends BaseController{
  final DataRepository dataRepository = Get.find(tag: (DataRepository).toString());
  final PreferenceManager preferenceManager = Get.find(tag: (PreferenceManager).toString());

  late TextEditingController accountController;
  late TextEditingController pwdController;

  late FocusNode accountNode;
  late FocusNode pwdNode;

  final isLoginEnableObs = false.obs;


  @override
  void onInit() {
    BaseConf.token = "";
    preferenceManager.logoutClear();

    accountController = TextEditingController();
    pwdController = TextEditingController();

    accountNode = FocusNode();
    pwdNode = FocusNode();
    super.onInit();
  }

  @override
  void onReady() {
    ///=====todo for test=====
    accountController.text = "flfwy02";
    //accountController.text = "fl02";
    pwdController.text = "Aa123456";
    isLoginEnableObs(true);
    ///=====todo for test=====
    super.onReady();
  }

  @override
  void onClose() {
    accountController.dispose();
    pwdController.dispose();

    accountNode.dispose();
    pwdNode.dispose();
    super.onClose();
  }

  onAccountChanged(String value) {
    checkLoginBtnStatus();
  }

  onPwdChanged(String value) {
    checkLoginBtnStatus();
  }

  void checkLoginBtnStatus() {
    if (accountController.text.trim().isNotEmpty && pwdController.text.trim().isNotEmpty) {
      isLoginEnableObs(true);
    } else {
      isLoginEnableObs(false);
    }
  }
  
  void onLoginBtnClick() async{
    if (!isLoginEnableObs.value) {
      return;
    }

    String? fcmToken = await FirebaseMessaging.instance.getToken();

    dataRepository.reqLogin(LoginReq(accountController.text.trim(), pwdController.text.trim(), fcmToken??Conf.fcmToken))
        .then((BaseResp baseResp){
      if(baseResp.isSuccessWithData()) {
        String token = "Bearer ${baseResp.data}";
        preferenceManager.setString(PreferenceManager.userToken, token).then((isSuccess){
          if (isSuccess) {
            BaseConf.token = token;
            Get.offNamed(Routes.mainPage);
          }
        });
      } else {
        showApiErrToast(baseResp.status, baseResp.message);
      }
    }, onError:(err) {
          handleException(err);
    } );
  }

}