
import 'package:enjoy_meal/app/local/custom_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../base/config/font_weight_conf.dart';
import '../../../base/ui/base_view.dart';
import '../../../base/widget/tap_down_zoom_out_view.dart';
import '../controllers/custom_base_controller.dart';

abstract class CustomBaseView<BaseController extends CustomBaseController> extends BaseView<BaseController> {

  CustomBaseView({super.key});

  Widget buildWaiterCallView() {
    return TapDownZoomOutView(
      onClicked: controller.onWaiterCallClicked,
      child: Container(
        width: 120.w,
        height: 75.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF39800),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12.r)),
        ),
        alignment: Alignment.center,
        child: Text(CustomLocalizations.text("assistant_called_out"), style: TextStyle(color: Colors.black, fontSize: 25.sp, fontWeight: FontWeightConf.bold),),
      ),
    );
  }

  Widget buildTableNumberView() {
    return Container(
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
    );
  }

  Widget buildWaiterBackBtn() {
    return TapDownZoomOutView(
        onClicked: (){
          Get.back();
        },
        child: Container(
          width: 137.w,
          height: 75.h,
          decoration: BoxDecoration(
              color: const Color(0xFFF2FAFF),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: const Color(0xFF008EF3),
                width: 2.w,
              )
          ),
          alignment: Alignment.center,
          child: Text(CustomLocalizations.text("back"), style: TextStyle(color: Colors.black, fontSize: 32.sp, fontWeight: FontWeightConf.medium),),
        ));
  }

 Widget buildMenuToolPanel() {
    return SizedBox(
      width: 120.w,
      child: Column(
        children: [

          _buildMenuToolItem(75.h, "TOP", controller.onTopMenuClicked),

          _buildMenuToolItem(124.h, CustomLocalizations.text("pack"), controller.onPackMenuClicked),

          _buildMenuToolItem(210.h, CustomLocalizations.text("order_history_accounting"), controller.onOrderListMenuClicked,
              isSelected: controller.isOrderListMenuSelected),

          _buildShoppingCartItem(210.h, CustomLocalizations.text("shopping_cart"), controller.onShoppingCartMenuClicked,
              isSelected: controller.isShoppingCartMenuSelected),

        ],
      ),
    );
  }

  _buildMenuToolItem(double height, String title, Function() onClicked, {bool isSelected = false}) {
    return TapDownZoomOutView(
      onClicked: onClicked,
      child: Container(
        height: height,
        margin: EdgeInsets.only(top: 4.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFC76A) : Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(12.w), bottomLeft: Radius.circular(12.w)),
        ),
        alignment: Alignment.center,
        child: Text(title, style: TextStyle(color: Colors.black, fontSize: 25.sp, fontWeight: FontWeightConf.bold), textAlign: TextAlign.center,),
      ),);
  }

  _buildShoppingCartItem(double height, String title, Function() onClicked, {bool isSelected = false}) {
    return TapDownZoomOutView(
      onClicked: onClicked,
      child: Container(
        height: height,
        margin: EdgeInsets.only(top: 4.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFC76A) : Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(12.w), bottomLeft: Radius.circular(12.w)),
        ),
        alignment: Alignment.center,
        child: Obx(()=>Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(color: Colors.black, fontSize: 25.sp, fontWeight: FontWeightConf.bold), textAlign: TextAlign.center,),
            Offstage(
              offstage: controller.globalController.shoppingCartOrderNumObs.value <= 0,
              child: Container(
                width: 32.w,
                height: 32.w,
                alignment: Alignment.center,
                child: ClipOval(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.w), // 内边距
                    color: const Color(0xFFFF0303),
                    alignment: Alignment.center,
                    child: Center(
                      child: Text("${controller.globalController.shoppingCartOrderNumObs.value}", style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeightConf.bold), textAlign: TextAlign.center,),
                    ),
                  ),
                ),
              ),
              //child: ,
            ),
            Offstage(
              offstage: (controller.globalController.shoppingCartOrderNumObs.value <= 0 || controller.globalController.isOnBuffetMode),
              child: Text("${controller.globalController.shoppingCartOrderTotalPriceObs.value.toInt()}${CustomLocalizations.text("money_unit")}", style: TextStyle(color: const Color(0xFFFF0303), fontSize: 25.sp, fontWeight: FontWeightConf.bold), textAlign: TextAlign.center,),
            ),
          ],
        )),
      ),);
  }
}