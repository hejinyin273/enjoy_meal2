

import 'package:enjoy_meal/app/base/config/font_weight_conf.dart';
import 'package:enjoy_meal/app/local/custom_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../base/widget/asset_image_view.dart';
import '../../../base/widget/tap_down_zoom_out_view.dart';
import '../controllers/buffet_confirm_controller.dart';
import 'custom_base_view.dart';

class BuffetConfirmView extends CustomBaseView<BuffetConfirmController> {

  BuffetConfirmView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Widget pageContent(BuildContext context) {
    return Container(
      child: body(context),
    );
  }

  @override
  Widget body(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: const Color(0xFFF7F0E1),
        ),
        Container(
          //margin: EdgeInsets.only(right: 251.w),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: _buildCenterContentView(),
          ),
          //child: _buildCenterContentView(),
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
          top: 78.h,
          right: 0,
          child: buildMenuToolPanel(),),
      ],
    );
  }

  _buildCenterContentView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(CustomLocalizations.text("buffet_add"), style: TextStyle(color: const Color(0xFFCD0F0F), fontSize: 64.sp, fontWeight: FontWeightConf.medium),),

        SizedBox(height: 50.h,),

        SizedBox(
          width: 917.w,
          child: Text(controller.selectedBuffetCategoryInfo.getPriceDescription(),
            style: TextStyle(color: Colors.black, fontSize: 25.sp, fontWeight: FontWeightConf.bold),),
        ),

        SizedBox(height: 5.h,),

        SizedBox(
          height: 244.h,
          width: 737.w,
          child: _buildListView(),
        ),

        SizedBox(height: 37.h,),

        SizedBox(
          width: 378.w,
          child: _buildCancelConfirmView(),
        ),

      ],
    );
  }

  _buildListView() {
    return ListView.builder(
      itemCount: controller.buffetPriceInfoList.length,
        itemBuilder: (context, index){
        final model = controller.buffetPriceInfoList[index];
      return Container(
        height: 61.h,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(
            color: const Color(0xFF5ACBFF),
            width: 3.h,
          ))
        ),
        child: Row(
          children: [
            Text(model.getDinerTypeName(), style: TextStyle(color: Colors.black, fontSize: 28.sp, fontWeight: FontWeightConf.medium),),
            const Expanded(flex:1, child: SizedBox()),
            Text(CustomLocalizations.text("taxation"), style: TextStyle(color: Colors.black, fontSize: 23.sp, fontWeight: FontWeightConf.medium),),
            Text("${model.price.toInt()}/${CustomLocalizations.text("people")}", style: TextStyle(color: Colors.black, fontSize: 28.sp, fontWeight: FontWeightConf.medium),),
            const Expanded(flex:1, child: SizedBox()),
            _buildAddSubView(index),
          ],
        ),
      );
    });
  }

  _buildAddSubView(int index) {
    return SizedBox(
      width: 180.w,
      height: 45.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TapDownZoomOutView(child: AssetImageView(fileName: "ic_subtract.png", width: 45.w, height: 45.w,), onClicked: (){
            controller.onSubtractClicked(index);
          },),
          
          Container(
            width: 75.w,
            height: 45.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: const Color(0xFF008EF3),
                width: 2.w
              ),
            ),
            child: _buildInputNumber(index),
          ),
          
          TapDownZoomOutView(child: AssetImageView(fileName: "ic_add.png", width: 45.w, height: 45.w,), onClicked: (){
            controller.onAddBtnClicked(index);
          },),
        ],
      ),
    );
  }

  _buildInputNumber(int index) {
    return TextField(
      autofocus: false,
      focusNode: controller.numberNodeList[index],
      controller: controller.numberControllerList[index],
      textAlign: TextAlign.center,
      showCursor: false,
      maxLines: 1,
      onChanged: (String text){
        controller.onNumberTextChange(text, index);
      },
      inputFormatters: [
        LengthLimitingTextInputFormatter(4),
        FilteringTextInputFormatter.digitsOnly,
      ],
      style: TextStyle(
          fontWeight: FontWeightConf.regular,
          fontSize: 30.sp,
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
              fontSize: 30.sp,
              color: const Color(0xFF333333)
          ),
          contentPadding: const EdgeInsets.all(0)
      ),
      keyboardType: TextInputType.number,
    );
  }

  _buildCancelConfirmView() {
    return Row(
      children: [
        TapDownZoomOutView(child: Container(
          width: 135.w,
          height: 60.w,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/btn_gradient_border_bg.png'),
              fit: BoxFit.fill,
            ),
          ),
          alignment: Alignment.center,
          child: Text(CustomLocalizations.text("back"), style: TextStyle(color: const Color(0xFF000000), fontSize: 28.sp, fontWeight: FontWeightConf.regular),),
        ), onClicked: (){
          Get.back();
        },),

        SizedBox(width: 105.w,),

        TapDownZoomOutView(child: Obx(()=>Opacity(opacity: controller.isConfirmBtnEnableObs.value ? 1 : 0.3,
          child: Container(
            width: 135.w,
            height: 60.w,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/btn_gradient_border_bg.png'),
                fit: BoxFit.fill,
              ),
            ),
            alignment: Alignment.center,
            child: Text(CustomLocalizations.text("sure"), style: TextStyle(color: const Color(0xFF000000), fontSize: 28.sp, fontWeight: FontWeightConf.regular),),
          ),)), onClicked: (){
          controller.onConfirmBtnClicked();
        },),

      ],
    );
  }
}
