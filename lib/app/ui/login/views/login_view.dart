

import 'package:enjoy_meal/app/base/widget/asset_image_view.dart';
import 'package:enjoy_meal/app/base/widget/tap_down_zoom_out_view.dart';
import 'package:enjoy_meal/app/local/custom_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../base/config/font_weight_conf.dart';
import '../../../base/config/text_styles_conf.dart';
import '../../../base/ui/base_view.dart';
import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends BaseView<LoginController>{
  LoginView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Widget body(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/login_bg.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
        
        Positioned(
          top: 36.h,
            left: 71.w,
            child: Text(CustomLocalizations.text("login_in_welcome_tip"),
          style: TextStyle(color: Colors.white, fontSize: 48.sp, fontWeight: FontWeightConf.bold),)),

        SingleChildScrollView(
            child: GestureDetector(
              onTap: (){
                controller.accountNode.unfocus();
                controller.pwdNode.unfocus();
              },
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.only(
                  top: 294.5.h,
                  left: 297.5.w,
                  right: 297.5.w,
                ),
                child: _buildInputPanel(),
              ),
            ),
        ),
      ],
    );
  }

  Widget _buildInputPanel() {
    return Container(
      height: 400.h,
      width: 685.w,
      decoration: BoxDecoration(
        color: const Color(0xFFF5EFEF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 52.h),
            width: 370.w,
            height: 48.h,
            child: Stack(
              children: [
                Container(
                  width: 60.w,
                  padding: EdgeInsets.only(right: 8.w),
                  alignment: Alignment.centerRight,
                  child: AssetImageView(fileName: "icon_login_account.png", width: 20.w, height: 20.h, fit: BoxFit.fill,),
                ),
                _buildInputAccount(),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(height: 1, color: Colors.grey,),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 57.h, bottom: 47.h),
            width: 370.w,
            height: 48.h,
            child: Stack(
              children: [
                Container(
                  width: 60.w,
                  //color: Colors.blueAccent,
                  padding: EdgeInsets.only(right: 8.w),
                  alignment: Alignment.centerRight,
                  child: AssetImageView(fileName: "icon_login_pwd.png", width: 20.w, height: 20.h, fit: BoxFit.fill,),
                ),
                _buildInputPassword(),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(height: 1, color: Colors.grey,),
                )
              ],
            ),
          ),
          _buildLoginBtn(),

          SizedBox(height: 21.h,),

          Text(CustomLocalizations.text("login_and_click"), style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeightConf.bold),),
          Text(CustomLocalizations.text("agreed_protocol_policy"), style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeightConf.bold),),
        ],
      ),
    );
  }

  _buildInputAccount() {
    return TextField(
      autofocus: false,
      focusNode: controller.accountNode,
      controller: controller.accountController,
      onChanged: controller.onAccountChanged,
      maxLines: 1,
      inputFormatters: [
        LengthLimitingTextInputFormatter(64),
      ],
      style: TextStyle(
          fontWeight: FontWeightConf.regular,
          fontSize: 16.sp,
          color: const Color(0xFF333333)
      ),
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          //borderSide: BorderSide(color: Color(0xFF666666)),
          borderSide: BorderSide.none,
        ),
        counterText: '',
        hintText: CustomLocalizations.text("input_account"),
        hintStyle: subTitleStyle,
        contentPadding: EdgeInsets.only(left: 66.w)
      ),
      keyboardType: TextInputType.text,
    );
  }

  _buildInputPassword() {
    return TextField(
      autofocus: false,
      focusNode: controller.pwdNode,
      controller: controller.pwdController,
      onChanged: controller.onPwdChanged,
      maxLines: 1,
      inputFormatters: [
        LengthLimitingTextInputFormatter(64),
      ],
      style: TextStyle(
          fontWeight: FontWeightConf.regular,
          fontSize: 16.sp,
          color: const Color(0xFF333333)
      ),
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          //borderSide: BorderSide(color: Color(0xFF666666)),
          borderSide: BorderSide.none,
        ),
        counterText: '',
        hintText: CustomLocalizations.text("input_password"),
        hintStyle: subTitleStyle,
        contentPadding: EdgeInsets.only(left: 66.w),
      ),
      keyboardType: TextInputType.text,
    );
  }

  _buildLoginBtn() {
    return Obx(()=> controller.isLoginEnableObs.value ? TapDownZoomOutView(child: Container(
      height: 57.5.h,
      width: 410.w,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/login_btn.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Center(
          child: Text(CustomLocalizations.text("login"), style: TextStyle(color: Colors.black, fontSize: 18.sp, fontWeight: FontWeightConf.medium),)),
    ), onClicked: (){
      controller.onLoginBtnClick();
    },) : Container(
      height: 57.5.h,
      width: 410.w,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/login_btn_dis.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Center(
          child: Text(CustomLocalizations.text("login"), style: TextStyle(color: const Color(0x80000000), fontSize: 18.sp, fontWeight: FontWeightConf.medium),)),
    ));
  }

}