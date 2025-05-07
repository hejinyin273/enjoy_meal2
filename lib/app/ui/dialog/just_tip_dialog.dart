
import 'package:enjoy_meal/app/base/config/font_weight_conf.dart';
import 'package:enjoy_meal/app/local/custom_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore_for_file: must_be_immutable
class JustTipDialog extends StatelessWidget{

  const JustTipDialog({super.key});

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
          alignment: Alignment.center,
          child: Text(CustomLocalizations.text("waiter_call_was_sent"), style: TextStyle(color: const Color(0xFFFF0303),
              fontSize: 48.sp, fontWeight: FontWeightConf.black), textAlign: TextAlign.center,),
          ),
        ),
    );
  }

}