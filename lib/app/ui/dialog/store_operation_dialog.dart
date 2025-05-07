

import 'package:enjoy_meal/app/base/config/font_weight_conf.dart';
import 'package:enjoy_meal/app/base/widget/tap_down_zoom_out_view.dart';
import 'package:enjoy_meal/app/local/custom_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../base/widget/asset_image_view.dart';
import '../../data/model/restaurant_data.dart';
import 'controller/store_operation_dialog_controller.dart';

// ignore_for_file: must_be_immutable
class StoreOperationDialog extends StatelessWidget{
  Function() onCancel;
  Function(int number, bool isValid) onConfirm;
  late DishInfo dishInfo;

  late StoreOperationDialogController controller;

  StoreOperationDialog({super.key, required this.dishInfo, required this.onCancel, required this.onConfirm}){
    controller = Get.put(StoreOperationDialogController());
    controller.isValidObs(dishInfo.available);
    if (dishInfo.inventoryQuantity == null) {
      controller.selectedNumObs(1);
      controller.numberController.text = "1";
    } else {
      controller.selectedNumObs(dishInfo.inventoryQuantity);
      controller.numberController.text = dishInfo.inventoryQuantity.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center,
      children: [
        Center(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: _buildContentPanel(),
            ),
          ),
        ),
      ],
    );
  }

  _buildContentPanel() {
    return Container(
      width: 800.w,
      height: 415.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13.r),
        border: Border.all(
            color: const Color(0xFF008EF3),
            width: 1.w
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 28.w),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 33.h,
            ),

            Text(dishInfo.getDishName(), style: TextStyle(color: Colors.black, fontSize: 40.sp, fontWeight: FontWeightConf.bold),),

            SizedBox(height: 34.h,),

            //_buildNumberItem(),

            SizedBox(height: 44.h,),

            Obx(()=>_buildStatusItem()),

            SizedBox(height: 66.h,),

            _buildConfirmBtnItem()

          ],
        ),
      ),
    );
  }

  _buildNumberItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(CustomLocalizations.text("store_number"), style: TextStyle(color: Colors.black, fontSize: 35.sp, fontWeight: FontWeightConf.bold),),

        SizedBox(width: 70.w,),

        _buildAddSubView(),
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

          Container(
            width: 189.w,
            height: 58.w,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/img_input_num_bg.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: _buildInputNumber(),
          ),

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
      //onChanged: controller.onNumberTextChange,
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

  _buildStatusItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(CustomLocalizations.text("sell_status"), style: TextStyle(color: Colors.black, fontSize: 40.sp, fontWeight: FontWeightConf.medium),),

        SizedBox(width: 68.w,),

        TapDownZoomOutView(
          onClicked: (){
            controller.isValidObs(true);
          },
            child: Row(
          children: [
            Container(
              width: 55.w,
              height: 55.w,
              margin: EdgeInsets.only(right: 20.w),
              decoration: BoxDecoration(
                  color: controller.isValidObs.value ? const Color(0xFFD9D9D9) : Colors.white,
                  borderRadius: BorderRadius.circular(28.r),
                  border: Border.all(
                      color: Colors.black,
                      width: 1.w
                  )
              ),

            ),
            Text(CustomLocalizations.text("up_shelf"), style: TextStyle(color: Colors.black, fontSize: 35.sp, fontWeight: FontWeightConf.bold),),
          ],
        )),

        SizedBox(width: 43.w,),

        TapDownZoomOutView(
          onClicked: (){
            controller.isValidObs(false);
          },
            child: Row(
          children: [
            Container(
              width: 55.w,
              height: 55.w,
              margin: EdgeInsets.only(right: 20.w),
              decoration: BoxDecoration(
                  color: controller.isValidObs.value ? Colors.white : const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(28.r),
                  border: Border.all(
                      color: Colors.black,
                      width: 1.w
                  )
              ),

            ),
            Text(CustomLocalizations.text("down_shelf"), style: TextStyle(color: Colors.black, fontSize: 35.sp, fontWeight: FontWeightConf.bold),),
          ],
        )),
      ],
    );
  }

  _buildConfirmBtnItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        TapDownZoomOutView(
            onClicked: (){
              onCancel();
            },
            child: Container(
              width: 121.w,
              height: 57.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                      color: Colors.black,
                      width: 2.w
                  )
              ),
              alignment: Alignment.center,
              child: Text(CustomLocalizations.text("cancel"), style: TextStyle(color: Colors.black, fontSize: 32.sp, fontWeight: FontWeightConf.medium),),
            )),

        SizedBox(width: 80.w,),

        TapDownZoomOutView(
          onClicked: (){
            onConfirm(controller.selectedNumObs.value, controller.isValidObs.value);
          },
            child: Container(
          width: 121.w,
          height: 57.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                  color: Colors.black,
                  width: 2.w
              )
          ),
          alignment: Alignment.center,
          child: Text(CustomLocalizations.text("confirm_no_space"), style: TextStyle(color: Colors.black, fontSize: 32.sp, fontWeight: FontWeightConf.medium),),
        )),
      ],
    );
  }
}