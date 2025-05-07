

import 'package:enjoy_meal/app/base/config/font_weight_conf.dart';
import 'package:enjoy_meal/app/base/widget/tap_down_zoom_out_view.dart';
import 'package:enjoy_meal/app/local/custom_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceHelpDialog extends StatelessWidget{
  Function() onCancel;
  Function() onConfirm;

  ServiceHelpDialog({super.key, required this.onCancel, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Container(
        width: 800.w,
        height: 375.w,
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
            TapDownZoomOutView(onClicked: onCancel,
                child: Container(
                  width: 121.w,
                  height: 57.w,
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

          ],
        ),
      ),
    );
  }

}