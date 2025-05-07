


import 'package:enjoy_meal/app/ui/dialog/just_tip_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/data/protocol/response/base_resp.dart';
import '../../../base/ui/base_controller.dart';
import '../../../data/model/restaurant_data.dart';
import '../../../data/repository/data_repository.dart';
import '../../global_controller.dart';

class CallAssistantController extends BaseController{
    final DataRepository dataRepository = Get.find(tag: (DataRepository).toString());
    late GlobalController globalController;

    final _selectedCallServiceIdObs = 0.obs;
    int get selectedCallServiceId => _selectedCallServiceIdObs.value;
    updateSelectedCallServiceId(int id) => _selectedCallServiceIdObs(id);

    late String bgImgUrl;

    void onCallStaffItemClicked(CallStaffInfo item) {
        reqCallStaff(item.id);
    }

    void reqCallStaff(int id) {
        dataRepository.reqCallStaff(id).then((BaseResp baseResp) async{
            if(baseResp.isSuccess()) {
                updateSelectedCallServiceId(id);
                showJustTipDialog();
                Future.delayed(const Duration(seconds: 2), (){
                    autoCloseJustTipDialog();
                });
            } else {
                showApiErrToast(baseResp.message);
            }
        }, onError:(err) {
            handleException(err);
        } );
    }

    void showJustTipDialog() {
        Get.dialog(JustTipDialog(), barrierColor: Colors.transparent, useSafeArea: false);
    }

    void autoCloseJustTipDialog(){
        if (Get.isDialogOpen != null && Get.isDialogOpen!) {
            Get.back();
        }
    }
}