
// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/font_weight_conf.dart';


class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final int maxLength;
  final bool showPassword;
  final bool autofocus;

  Widget? suffixIcon;
  Widget? prefixIcon;
  TextAlign textAlign;
  FocusNode? focusNode;
  TextInputType? keyboardType;
  Function(String)? onChange;

  CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.maxLength,
    this.onChange,
    this.suffixIcon,
    this.prefixIcon,
    this.showPassword = false,
    this.focusNode,
    this.keyboardType,
    this.autofocus = false,
    this.textAlign = TextAlign.start
  });

  @override
  Widget build(BuildContext context) {
    focusNode ??= FocusNode();
    keyboardType ??= TextInputType.visiblePassword;
    List<TextInputFormatter>? listFormat;
    if (keyboardType == TextInputType.visiblePassword) {
      listFormat = [
        FilteringTextInputFormatter.deny(RegExp(r'[\u0080-\uFFFF]')),
        FilteringTextInputFormatter.deny(RegExp(r'\s+'))
      ];
    } else if (keyboardType == TextInputType.phone || keyboardType == TextInputType.number) {
      listFormat = [
        FilteringTextInputFormatter.digitsOnly,
      ];
    }
    return TextField(
      autofocus: autofocus,
      focusNode: focusNode,
      controller: controller,
      obscureText: showPassword,
      maxLength: maxLength,
      textAlign: textAlign,
      onChanged: onChange,
      style: TextStyle(
          fontWeight: FontWeightConf.regular,
          fontSize: 14.sp,
          color: const Color(0xFF333333)
      ),
      inputFormatters: listFormat,
      decoration: InputDecoration(
        filled: true, // 设置为填充样式
        fillColor: const Color(0xFFEDF2F6), // 设置背景色为浅蓝色
        constraints: BoxConstraints(
          maxHeight: 44.h,
        ),
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(22.w))
        ),
        hintText: labelText,
        hintStyle: TextStyle(
            color: const Color(0xFF999999),
          fontSize: 14.sp,
          fontWeight: FontWeightConf.medium
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        counterText: '',
        isDense: true,
        contentPadding: EdgeInsets.only(left: 18.w),
      ),
      keyboardType: keyboardType,
    );
  }
}

class SuffixIconHelper {
  /// 清除输入数据
  static Widget placeholderView() {
    return SizedBox(
      width: 44.w,
      height: 44.h,
    );
  }

  static Widget clearInputButton(Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        //color: Colors.greenAccent,
        child: Image.asset(
          "images/icon_clear.png",
          width: 16.w,
          height: 16.h,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  /// 显示与不显示密码
  static Widget showPasswordButton(bool showPassword, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15.w),
        //color: Colors.greenAccent,
        child: showPassword ? Image.asset(
          "images/icon_open_eyes.png",
          height: 14.w,
          width: 14.w,
          fit: BoxFit.fitWidth,
        ) : Image.asset(
          "images/icon_close_eyes.png",
          height: 14.w,
          width: 14.w,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  /// 获取短信验证码按钮
  static Widget smsCodeButton(bool isLoading, bool enable, String showText, Function() onTap) {
    return Container(
      alignment: Alignment.centerRight,
      width: 140.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 1.w,
            height: 16.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1.w),
              color: const Color(0xFF999999),
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: InkWell(
              onTap: enable ? onTap: (){},
              child: Container(
                alignment: Alignment.center,
                child: isLoading ? SizedBox(
                  width: 28.w,
                  height: 28.w,
                  child: const CircularProgressIndicator(color: Color(0xFF00BAA4), strokeWidth: 2,),
                ) : Text(
                  showText,
                  style: TextStyle(
                    color: const Color(0xFF00BAA4),
                    //color: enable ? const Color(0xFF305AED) : const Color(0xFF9A9A9A),
                    fontWeight: FontWeightConf.medium,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}