

import 'package:enjoy_meal/app/base/widget/asset_image_view.dart';
import 'package:enjoy_meal/app/base/widget/tap_down_zoom_out_view.dart';
import 'package:enjoy_meal/app/ui/main/controllers/select_diners_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../base/config/font_weight_conf.dart';
import '../../../base/utils/view_util.dart';
import '../../../data/model/restaurant_data.dart';
import '../../../local/custom_localizations.dart';
import 'custom_base_view.dart';


class SelectDinersView extends CustomBaseView<SelectDinersController> {

  SelectDinersView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Widget pageContent(BuildContext context) {
    return body(context);
  }

  @override
  Widget body(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: ViewUtil.cachedImage(
          controller.bgImgUrl,
          fit: BoxFit.fill,
        )),

        Container(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.only(top: 119.h),
          child: SingleChildScrollView(
            child: SizedBox(
              height: 507.h,
              width: 800.w,
              child: _buildCenterPanel(),
            ),
          ),
        ),

        Positioned(
            top: 0,
            right: 0,
            child: buildWaiterCallView()),

        Positioned(
            bottom: 0,
            left: 0,
            child: buildTableNumberView()),

        Positioned(
            bottom: 5.h,
            left: 200.w,
            child: controller.globalController.userType == RestaurantConf.userTypeUser
                ? const SizedBox()
                : buildWaiterBackBtn()),
      ],
    );
  }

  _buildCenterPanel() {
    return Stack(
      children: [
        Container(
          width: 800.w,
          margin: EdgeInsets.only(top: 56.5.h),
          decoration: BoxDecoration(
            color: const Color(0xC6FFF6F6),
            borderRadius: BorderRadius.all(Radius.circular(24.r)),
          ),
          alignment: Alignment.center,
          child: _buildAddSubView(),
        ),

        Positioned(
            top: 150.h,
            left: 0,
            right: 0,
            child: Text(CustomLocalizations.text("how_many_user"), textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 35.sp, fontWeight: FontWeightConf.bold),)),

        Positioned(
          bottom: 38.h,
          left: 242.w,
          right: 242.w,
          child: _buildConfirmBtn(),),

        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 113.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 113.h,
                  padding: EdgeInsets.only(left: 43.w, right: 43.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFACD89),
                    borderRadius: BorderRadius.all(Radius.circular(66.5.h)),
                  ),
                  alignment: Alignment.center,
                  child: Text(controller.restaurantName, style: TextStyle(fontSize: 48.sp,
                      color: Colors.black,
                      fontWeight: FontWeightConf.medium),),
                ),
              ],
            ),
          ),),
      ],
    );
  }

  _buildAddSubView() {
    return SizedBox(
      width: 362.5.w,
      height: 65.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TapDownZoomOutView(child: AssetImageView(fileName: "ic_subtract.png", width: 65.w, height: 65.w,), onClicked: (){
            controller.onSubtractClicked();
          },),
          Obx((){
            return Container(
              width: 189.w,
              height: 58.w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(controller.isConfirmBtnEnableObs.value ? "images/img_input_num_bg.png" : 'images/img_input_num_bg_dis.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: _buildInputNumber(),
            );
          }),
          TapDownZoomOutView(child: AssetImageView(fileName: "ic_add.png", width: 65.w, height: 65.w,), onClicked: (){
            controller.onAddBtnClicked();
          },),
        ],
      ),
    );
  }

  _buildInputNumber() {
    return TextField(
      autofocus: false,
      focusNode: controller.numberNode,
      controller: controller.numberController,
      textAlign: TextAlign.center,
      showCursor: false,
      maxLines: 1,
      onChanged: controller.onNumberTextChange,
      inputFormatters: [
        LengthLimitingTextInputFormatter(4),
        FilteringTextInputFormatter.digitsOnly,
      ],
      style: TextStyle(
          fontWeight: FontWeightConf.regular,
          fontSize: 37.sp,
          color: const Color(0xFF333333)
      ),
      decoration: InputDecoration(
          border: const OutlineInputBorder(
            //borderSide: BorderSide(color: Color(0xFF666666)),
            borderSide: BorderSide.none,
          ),
          counterText: '',
          hintText: "0",
          hintStyle: TextStyle(
              fontWeight: FontWeightConf.regular,
              fontSize: 37.sp,
              color: const Color(0xFF333333)
          ),
          contentPadding: const EdgeInsets.all(0)
      ),
      keyboardType: TextInputType.number,
    );
  }

  _buildConfirmBtn() {
    return TapDownZoomOutView(
        child: Obx((){
          return Container(
            width: 315.w,
            height: 70.h,
            decoration: BoxDecoration(
              color: Color(controller.isConfirmBtnEnableObs.value ? 0xFFFBB245 : 0xFFF4DFBC),
              borderRadius: BorderRadius.all(Radius.circular(14.5.w)),
              border: Border.all(
                color: const Color(0xFFFA2626),
                width: 2.w
              )
            ),
            alignment: Alignment.center,
            child: Text(CustomLocalizations.text("open_menu"), style: TextStyle(fontSize: 37.5.sp,
                color: controller.isConfirmBtnEnableObs.value ? const Color(0xFF000000) : const Color(0xFF9C9393),
                fontWeight: FontWeightConf.regular),),
          );
        }), onClicked: (){
      controller.onConfirmBtnClicked();
    });
  }

}
