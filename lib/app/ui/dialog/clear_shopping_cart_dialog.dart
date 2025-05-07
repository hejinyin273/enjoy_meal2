

import 'package:enjoy_meal/app/base/config/font_weight_conf.dart';
import 'package:enjoy_meal/app/base/widget/tap_down_zoom_out_view.dart';
import 'package:enjoy_meal/app/local/custom_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore_for_file: must_be_immutable
class ClearShoppingCartDialog extends StatelessWidget{
  Function() onCancel;
  Function() onConfirm;

  ClearShoppingCartDialog({super.key, required this.onCancel, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        alignment: Alignment.center,
        child: Container(
          width: 699.w,
          height: 516.h,
          decoration: BoxDecoration(
            color: const Color(0xFFF7F0E1 ),
            borderRadius: BorderRadius.circular(25.r),
            border: Border.all(
                color: const Color(0xFF008EF3),
                width: 1.w
            ),
          ),
          padding: EdgeInsets.all(35.h),
          child: Column(
            children: [
              SizedBox(height: 65.h,),
              Text(CustomLocalizations.text("clear_shopping_cart_tip"), style: TextStyle(color: const Color(0xFFCB0A0A ),
                  fontSize: 38.sp, fontWeight: FontWeightConf.medium), textAlign: TextAlign.center,),
              const Expanded(child: SizedBox()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TapDownZoomOutView(onClicked: onCancel,
                      child: Container(
                        width: 160.w,
                        height: 77.h,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0x6600A0E9),
                              width: 2.w
                          ),
                          borderRadius: BorderRadius.circular(13.r),
                          color: const Color(0xFFFF9600),
                        ),
                        alignment: Alignment.center,
                        child: Text(CustomLocalizations.text("back"), style: TextStyle(color: Colors.black, fontSize: 30.sp, fontWeight: FontWeightConf.black),),
                      )),

                  SizedBox(width: 106.w,),

                  TapDownZoomOutView(
                      onClicked: onConfirm,
                      child: Container(
                        width: 160.w,
                        height: 77.h,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0x6600A0E9),
                              width: 2.w
                          ),
                          borderRadius: BorderRadius.circular(13.r),
                          color: const Color(0xFFFF9600),
                        ),
                        alignment: Alignment.center,
                        child: Text(CustomLocalizations.text("clear"), style: TextStyle(color: Colors.black, fontSize: 30.sp, fontWeight: FontWeightConf.black),),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}