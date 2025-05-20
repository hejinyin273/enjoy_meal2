
import 'package:enjoy_meal/app/base/config/font_weight_conf.dart';
import 'package:enjoy_meal/app/data/model/restaurant_data.dart';
import 'package:enjoy_meal/app/local/custom_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../base/utils/view_util.dart';
import '../../base/widget/asset_image_view.dart';
import '../../base/widget/tap_down_zoom_out_view.dart';
import 'controller/number_select_dialog_controller.dart';

// ignore_for_file: must_be_immutable
///没有属性类别或者只有一个属性类别并且该属性类别只有一个属性
class NumberSelectDialog extends StatelessWidget{

  int mainId;
  PackageInfo packageInfo;
  Function() onCancel;
  Function() onConfirm;
  final controller = Get.put(NumberSelectDialogController());

  NumberSelectDialog({super.key, required this.mainId, required this.packageInfo, required this.onCancel, required this.onConfirm,}){
    controller.selectedNumObs(packageInfo.minSalesQuantity!);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center,
      children: [
        _buildContentView(context),
      ],
    );
  }

  _buildContentView(BuildContext context) {
    return SizedBox(
      width: 699.w,
      height: 516.w,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7E7),
            borderRadius: BorderRadius.circular(25.r),
            border: Border.all(
                color: const Color(0xFF008EF3),
                width: 1.w
            ),
          ),
          padding: EdgeInsets.only(top:19.w, left: 46.w, right: 10.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 37.w,
                width: 389.w,
                padding: EdgeInsets.only(left: 26.w),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/img_dish_detail_title_bar.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                alignment: Alignment.centerLeft,
                child: Text(CustomLocalizations.text("choice"), style: TextStyle(color: const Color(0xFF000000), fontSize: 25.sp, fontWeight: FontWeightConf.medium),),
              ),

              Row(
                children: [
                  Container(
                    height: 269.w,
                    width: 389.w,
                    margin: EdgeInsets.only(top:8.w, bottom: 4.w),
                    child:  (packageInfo.bgImage != null && packageInfo.bgImage!.isNotEmpty) ?ViewUtil.cachedImage(
                      packageInfo.bgImage!,
                      fit: BoxFit.cover,
                    ) : Container(
                      color: const Color(0xFFF6E7BD),
                    ),
                  ),

                  SizedBox(width: 27.w,),

                ],
              ),

              _buildDishNamePricePanel(),

              _buildBtnPanel(),
            ],
          ),
        ),
      ),
    );
  }


  _buildDishNamePricePanel() {
    return Container(
      height: 75.w,
      width: 643.w,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: const BoxDecoration(
          color: Color(0xFFD9D9D9)
      ),
      child: Row(
        children: [
          Expanded(flex: 1, child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(packageInfo.getPackageName(),
                style: TextStyle(color: const Color(0xFF000000),
                    fontSize: 25.sp, fontWeight: FontWeightConf.bold), textAlign: TextAlign.start,),

              Offstage(
                offstage: false,
                child: RichText(
                  textAlign: TextAlign.end,
                  text: TextSpan(
                    style: TextStyle(color: const Color(0xFF000000),
                        fontSize: 20.sp, fontWeight: FontWeightConf.bold), // 默认文本样式
                    children: <TextSpan>[
                      TextSpan(text: CustomLocalizations.text("tax_included")),
                      TextSpan(text: '${packageInfo.price.toInt()}', style: TextStyle(color: const Color(0xFFFF0303),
                          fontSize: 20.sp, fontWeight: FontWeightConf.bold)),
                      TextSpan(text: CustomLocalizations.text("money_unit")),
                    ],
                  ),
                ),
              ),
            ],
          )),

          Offstage(
            offstage: false,
            child: _buildAddSubView(),
          ),
        ],
      ),
    );
  }

  _buildAddSubView() {
    return SizedBox(
      height: 57.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 30.w,),

          Obx(()=>controller.selectedNumObs.value <= packageInfo.minSalesQuantity!
              ? SizedBox(width: 57.w, height: 57.w,)
              : TapDownZoomOutView(child: AssetImageView(fileName: "ic_subtract.png", width: 57.w, height: 57.w,), onClicked: (){
            controller.onSubtractClicked();
          },)),

          Container(
            width: 75.w,
            height: 57.w,
            margin: EdgeInsets.symmetric(horizontal: 15.w),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/edit_gradient_border_bg.png"),
                fit: BoxFit.fill,
              ),
            ),
            alignment: Alignment.center,
            child: Obx(()=>Text("${controller.selectedNumObs.value}", style: TextStyle(color: Colors.black, fontSize: 36.sp, fontWeight: FontWeightConf.medium),)),
          ),

          TapDownZoomOutView(child: AssetImageView(fileName: "ic_add.png", width: 57.w, height: 57.w,), onClicked: (){
            controller.onAddBtnClicked();
          },),
        ],
      ),
    );
  }

  _buildBtnPanel() {
    return Container(
      margin: EdgeInsets.only(right: 44.w, top: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TapDownZoomOutView(child: Container(
            width: 160.w,
            height: 77.w,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/img_orange_btn_bg.png'),
                fit: BoxFit.fill,
              ),
            ),
            alignment: Alignment.center,
            child: Text(CustomLocalizations.text("back"), style: TextStyle(color: const Color(0xFF000000), fontSize: 30.sp, fontWeight: FontWeightConf.black),),
          ), onClicked: (){
            controller.onCancelBtnClicked();
          },),

          TapDownZoomOutView(child: Container(
            width: 160.w,
            height: 77.w,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/img_orange_btn_bg.png'),
                fit: BoxFit.fill,
              ),
            ),
            alignment: Alignment.center,
            child: Text(CustomLocalizations.text("order_next"), style: TextStyle(color: const Color(0xFF000000), fontSize: 22.sp, fontWeight: FontWeightConf.black),),
          ), onClicked: (){
            controller.onConfirmBtnClicked(mainId, packageInfo);
          },),
        ],
      ),
    );
  }

}