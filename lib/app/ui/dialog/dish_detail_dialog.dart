
import 'package:auto_size_text/auto_size_text.dart';
import 'package:enjoy_meal/app/base/config/font_weight_conf.dart';
import 'package:enjoy_meal/app/data/model/restaurant_data.dart';
import 'package:enjoy_meal/app/local/custom_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../base/utils/view_util.dart';
import '../../base/widget/asset_image_view.dart';
import '../../base/widget/tap_down_zoom_out_view.dart';
import 'controller/dish_detail_dialog_controller.dart';

// ignore_for_file: must_be_immutable
///没有属性类别或者只有一个属性类别并且该属性类别只有一个属性
class DishDetailDialog extends StatelessWidget{

  DishInfo dishInfo;
  Function() onCancel;
  String? confirmText;
  Function(List<DishAttributeInfo> attributeList)? onConfirm;
  bool isShowNumSelect = true;
  final controller = Get.put(DishDetailDialogController());
  DishAttributeCategoryInfo? selectedDishAttributeCategoryInfo;

  DishDetailDialog({super.key, required this.dishInfo, required this.onCancel, this.confirmText, this.onConfirm, this.isShowNumSelect=true}){
    controller.selectedNumObs(1);
    controller.selectedAttributeInfoMap.clear();
    if (dishInfo.dishAttributeCategoryInfos.isNotEmpty) {
      selectedDishAttributeCategoryInfo = dishInfo.dishAttributeCategoryInfos.first;
    }
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
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

                      Container(
                        height: 269.w,
                        width: 389.w,
                        margin: EdgeInsets.only(top:8.w, bottom: 4.w),
                        child:  ViewUtil.cachedImage(
                          dishInfo.detailImageUrl!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),

                  _buildDishAttributeCategory(),
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

  _buildDishAttributeCategory() {
    if (selectedDishAttributeCategoryInfo == null) {
      return const SizedBox(width: 0, height: 0,);
    }

    return Container(
      margin: EdgeInsets.only(left: 30.w, top: 45.w),///37.w + 8.w
      height: 269.w,
      width: 220.w,
      child: ListView.builder(
        itemCount: selectedDishAttributeCategoryInfo!.dishAttributeInfos.length + 1,
        itemBuilder: (context, index) {
          if (index == selectedDishAttributeCategoryInfo!.dishAttributeInfos.length) {
            return Container(
              height: 53.h,
              width: 220.w,
              padding: EdgeInsets.only(left: 10.w, top: 5.h, right: 3.w),
              child: Stack(
                children: [
                  Positioned(
                    right: 0, width: 33.w, height: 53.h,
                    child: const AssetImageView(fileName: "ic_hand_location_top.png"),),
                  Positioned(
                      left:0,
                      bottom:0,
                      child: Text(CustomLocalizations.text("press_this_button"), style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeightConf.bold),)),
                ],
              ),
            );
          } else {
            final dishAttributeInfo = selectedDishAttributeCategoryInfo!.dishAttributeInfos[index];
            return _buildDishAttributeItem(dishAttributeInfo);
          }
        },

      ),
    );
  }

  _buildDishAttributeItem(DishAttributeInfo dishAttributeInfo) {
    return Obx((){
      bool isUpdate = controller.selectedAttributeUpdateObs.value;
      if (isUpdate) {

      }
      return TapDownZoomOutView(
        onClicked: (){
          controller.onDishAttributeItemClicked(selectedDishAttributeCategoryInfo!, dishAttributeInfo);
        },
        child: Container(
        height: 62.h,
        width: 218.w,
        margin: EdgeInsets.symmetric(vertical: 3.w),
        decoration: BoxDecoration(
            color: controller.isAttributeIdSelected(selectedDishAttributeCategoryInfo!.id, dishAttributeInfo.id) ? const Color(0xFF01ABFC) : const Color(0xFFF39800),
            borderRadius: BorderRadius.circular(10.r)
        ),
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(dishAttributeInfo.getAttributeName(), style: TextStyle(color: const Color(0xFF000000),
                fontSize: 25.sp, fontWeight: FontWeightConf.bold),),

            RichText(
              textAlign: TextAlign.end,
              text: TextSpan(
                style: TextStyle(color: const Color(0xFF000000),
                    fontSize: 20.sp, fontWeight: FontWeightConf.bold), // 默认文本样式
                children: <TextSpan>[
                  const TextSpan(text: '+'),
                  TextSpan(text: controller.globalController.isOnBuffetMode
                      ? '0'
                      : '${dishAttributeInfo.priceAdjustment.toInt()}', style: TextStyle(color: const Color(0xFFFF0303),
                      fontSize: 25.sp, fontWeight: FontWeightConf.bold)),
                  TextSpan(text: CustomLocalizations.text("money_unit")),
                ],
              ),
            ),
          ],
        ),
      ));
    });
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
          Expanded(flex: 1, child: Stack(
            children: [
              SizedBox(
                height: 75.w,
                child: AutoSizeText(dishInfo.getDishName(),
                  style: TextStyle(color: const Color(0xFF000000),
                      fontSize: 25.sp, fontWeight: FontWeightConf.bold), textAlign: TextAlign.start,),
              ),

              Positioned(
                right: 0,
                  bottom: 3.h,
                  child: Offstage(
                offstage: (!isShowNumSelect || controller.globalController.isOnBuffetMode),
                child: RichText(
                  textAlign: TextAlign.end,
                  text: TextSpan(
                    style: TextStyle(color: const Color(0xFF000000),
                        fontSize: 20.sp, fontWeight: FontWeightConf.bold), // 默认文本样式
                    children: <TextSpan>[
                      TextSpan(text: CustomLocalizations.text("tax_included")),
                      TextSpan(text: '${dishInfo.price.toInt()}', style: TextStyle(color: const Color(0xFFFF0303),
                          fontSize: 20.sp, fontWeight: FontWeightConf.bold)),
                      TextSpan(text: CustomLocalizations.text("money_unit")),
                    ],
                  ),
                ),
              )),
            ],
          )),

          Offstage(
            offstage: !isShowNumSelect,
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

          TapDownZoomOutView(child: AssetImageView(fileName: "ic_subtract.png", width: 57.w, height: 57.w,), onClicked: (){
            controller.onSubtractClicked();
          },),

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
            controller.onAddBtnClicked(dishInfo);
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
            child: Text(confirmText??CustomLocalizations.text("order_next"), style: TextStyle(color: const Color(0xFF000000), fontSize: 22.sp, fontWeight: FontWeightConf.black),),
          ), onClicked: (){
            if (onConfirm == null) {
              controller.onConfirmBtnClicked(dishInfo);
            } else {
              List<DishAttributeInfo> dishAttributeInfoList = [];
              for (var item in controller.selectedAttributeInfoMap.values) {
                dishAttributeInfoList.addAll(item.values.toList());
              }
              onConfirm!(dishAttributeInfoList);
            }
          },),
        ],
      ),
    );
  }

}