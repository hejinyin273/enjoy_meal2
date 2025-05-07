

import 'package:enjoy_meal/app/base/config/font_weight_conf.dart';
import 'package:enjoy_meal/app/base/widget/tap_down_zoom_out_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../local/custom_localizations.dart';

// ignore_for_file: must_be_immutable
class CustomTipConfirmDialog extends StatelessWidget{
  String tipContent;
  Function() onCancel;
  Function() onConfirm;

  CustomTipConfirmDialog({super.key, required this.tipContent, required this.onCancel, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center,
      children: [
        SizedBox(
          width: 800.w,
          height: 375.w,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: _buildContentPanel(),
          ),
        ),
      ],
    );
  }

  _buildContentPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13.r),
        border: Border.all(
            color: const Color(0xFF008EF3),
            width: 1.w
        ),
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          SizedBox(height: 93.w,),
          Text(tipContent, style: TextStyle(color: Colors.black, fontSize: 36.sp, fontWeight: FontWeightConf.medium),),
          const Expanded(child: SizedBox()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TapDownZoomOutView(onClicked: onCancel,
                  child: Container(
                    width: 121.w,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color(0xFF008EF3),
                          width: 2.w
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                      color: const Color(0xFF0B10E7),
                    ),
                    alignment: Alignment.center,
                    child: Text(CustomLocalizations.text("back"), style: TextStyle(color: Colors.white, fontSize: 35.sp, fontWeight: FontWeightConf.medium),),
                  )),

              SizedBox(width: 106.w,),

              TapDownZoomOutView(
                  onClicked: onConfirm,
                  child: Container(
                    width: 121.w,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color(0xFF008EF3),
                          width: 2.w
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                      color: const Color(0xFFFF7E23),
                    ),
                    alignment: Alignment.center,
                    child: Text(CustomLocalizations.text("yes"), style: TextStyle(color: Colors.white, fontSize: 35.sp, fontWeight: FontWeightConf.medium),),
                  )),
            ],
          ),
        ],
      ),
    );
  }

}