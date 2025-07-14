

import 'package:enjoy_meal/app/base/config/font_weight_conf.dart';
import 'package:enjoy_meal/app/base/widget/tap_down_zoom_out_view.dart';
import 'package:enjoy_meal/app/local/custom_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore_for_file: must_be_immutable
class BatchPrintSelectDialog extends StatelessWidget{
  Function() onCancel;
  Function(int index) onConfirm;

  BatchPrintSelectDialog({super.key, required this.onCancel, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center,
      children: [
        SizedBox(
          width: 800.w,
          height: 321.w,
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
      padding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TapDownZoomOutView(
              onClicked: (){
                onConfirm(0);
              },
              child: _buildSelectionItem(CustomLocalizations.text("just_print"))),

          TapDownZoomOutView(
              onClicked: (){
                onConfirm(1);
              },
              child: _buildSelectionItem(CustomLocalizations.text("just_not_print"))),

          /*TapDownZoomOutView(
              onClicked: (){
                onCancel();
              },
              child: _buildSelectionItem(CustomLocalizations.text("back")),),*/

        ],
      ),
    );
  }

  _buildSelectionItem(String title) {
    return Container(
      width: 744.w,
      height: 76.w,
      margin: EdgeInsets.only(top: 8.w, bottom: 8.w),
      decoration: BoxDecoration(
          color: const Color(0xFFFFEDB2),
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
                color: const Color(0x2F000000),
                offset: Offset(0, 2.h),
                blurRadius: 2.w
            ),
          ]
      ),
      alignment: Alignment.center,
      child: Text(title, style: TextStyle(color: Colors.black, fontSize: 40.sp, fontWeight: FontWeightConf.medium),),
    );
  }

}