

import 'package:auto_size_text/auto_size_text.dart';
import 'package:enjoy_meal/app/base/config/font_weight_conf.dart';
import 'package:enjoy_meal/app/base/widget/tap_down_zoom_out_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../base/ui/base_view.dart';
import '../../../base/utils/view_util.dart';
import '../../../local/custom_localizations.dart';
import '../../global_controller.dart';
import '../controllers/call_assistant_controller.dart';

class CallAssistantView extends BaseView<CallAssistantController>{
  CallAssistantView({super.key}){
    controller.globalController = Get.find<GlobalController>();
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Widget body(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: ViewUtil.cachedImage(
          controller.globalController.callStaffBgImage,
          fit: BoxFit.fill,
        )),

        Container(
          padding: EdgeInsets.only(top: 50.h, left: 47.w, right: 47.w, bottom: 117.h),
          child: _buildServicePanel(),
        ),

        Positioned(
            bottom: 0,
            left: 0,
            child: buildTableNumberView()),

        Positioned(
            bottom: 21.h,
            right: 179.w,
            child: _buildCloseBtn()),
      ],
    );
  }

  _buildServicePanel() {
    return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, // 每行的item数量
      childAspectRatio: (575.w/123.h), // 子widget的宽高比例 101/186 186=162 + 12 + 12
      mainAxisSpacing: 34.h, // 主轴方向的间隔
      crossAxisSpacing: 37.w, // 交叉轴方向的间隔
    ), itemCount: controller.globalController.restaurantData.callStaffInfos.length,
        itemBuilder: (context, index){
          final model = controller.globalController.restaurantData.callStaffInfos[index];
          String title = model.getCallContent();
          return _buildCommonItem(title, model.id == controller.selectedCallServiceId, (){
            controller.onCallStaffItemClicked(model);
          });
        });
  }

  List<Widget> getServiceItemList() {
    List<Widget> widgetList = [];
    for (var item in controller.globalController.restaurantData.callStaffInfos) {
      String title = item.getCallContent();
      widgetList.add(_buildCommonItem(title, item.id == controller.selectedCallServiceId, (){
        controller.onCallStaffItemClicked(item);
      }));
    }
    return widgetList;
  }

  _buildCommonItem(String title, bool isSelected, Function() onclick) {
    return TapDownZoomOutView(onClicked: onclick, child: Container(
      width: 575.w,
      height: 123.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/img_call_btn_bg.png'),
          fit: BoxFit.fill,
        ),
      ),
      alignment: Alignment.center,
      child: AutoSizeText(title, maxLines:2, style: TextStyle(color: Colors.black, fontSize: 40.sp, fontWeight: FontWeightConf.black),),
    ),);
  }

  _buildCloseBtn() {
    return TapDownZoomOutView(
        onClicked: (){
          Get.back();
        },
        child: Container(
          width: 227.w,
          height: 96.h,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/img_call_close_bg.png'),
              fit: BoxFit.fill,
            ),
          ),
          alignment: Alignment.center,
          child: Text(CustomLocalizations.text("close"), style: TextStyle(color: Colors.white, fontSize: 43.sp, fontWeight: FontWeightConf.black),),
        ));
  }


  Widget buildTableNumberView() {
    return TapDownZoomOutView(
      onClicked: (){},
      child: Container(
        height: 80.h,
        padding: EdgeInsets.symmetric(horizontal: 9.w),
        decoration: const BoxDecoration(
          color: Color(0xFF8A291F),
        ),
        child: Row(
          children: [
            Text(CustomLocalizations.text("seat"), style: TextStyle(color: const Color(0xFFF6E7BD), fontSize: 20.sp, fontWeight: FontWeightConf.bold),),
            SizedBox(width: 9.w,),
            Text(controller.globalController.currentTableNumber, style: TextStyle(color: const Color(0xFFF6E7BD), fontSize: 50.sp, fontWeight: FontWeightConf.black),),
          ],
        ),
      ),
    );
  }
}