
import 'package:enjoy_meal/app/base/config/font_weight_conf.dart';
import 'package:enjoy_meal/app/local/custom_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../base/widget/tap_down_zoom_out_view.dart';

// ignore_for_file: must_be_immutable
class CallWaiterCheckoutDialog extends StatelessWidget{
  Function() onConfirm;

  CallWaiterCheckoutDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center,
      children: [
        _buildContentView(),
      ],
    );
  }

  _buildContentView() {
    return SizedBox(
      width: 699.w,
      height: 516.h,
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
          padding: EdgeInsets.fromLTRB(45.w, 38.h, 45.w, 38.h),
          alignment: Alignment.center,
          child: Column(
            children: [

              SizedBox(height: 124.h,),

              Text(CustomLocalizations.text("called_assistant_tip"), style: TextStyle(color: const Color(0xFFCB0A0A),
                  fontSize: 60.sp, fontWeight: FontWeightConf.black), textAlign: TextAlign.center,),

              SizedBox(height: 35.h,),

              const Expanded(flex:1, child: SizedBox(width: 1,)),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                        child: Text(CustomLocalizations.text("confirm_no_space"), style: TextStyle(color: Colors.black, fontSize: 48.sp, fontWeight: FontWeightConf.black),),
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