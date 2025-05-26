
import 'package:enjoy_meal/app/local/custom_localizations.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gif_view/gif_view.dart';

import 'default_cache_manager.dart';
import '../config/font_weight_conf.dart';
import '../config/text_styles_conf.dart';
import '../widget/asset_image_view.dart';

class ViewUtil{
  static Widget cachedImage(String url, {double? width, double? height, double radius = 0, BoxFit fit = BoxFit.fill, bool isAvatar = false, Widget? placeholder}) {
    Widget errorImage = const Icon(Icons.error);
    width ??= double.infinity;
    height ??= double.infinity;
    if (isAvatar) {
      errorImage = Image.asset(
        "avatar.png",
        width: width,
        height: height,
        fit: BoxFit.fitWidth,
      );
    }
    return CachedNetworkImage(
        height: height,
        width: width,
        fit: fit,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            image: DecorationImage(
              image: imageProvider,
              fit: fit,
            ),
          ),
        ),
        placeholder: (
            BuildContext context,
            String url,
            ) => placeholder ?? Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: Colors.grey[200],
          ),
        ),
        errorWidget: (
            BuildContext context,
            String url,
            dynamic error,
            ) => errorImage,
        cacheManager: DefaultCacheManager(),
        imageUrl: url);
  }

  static Text buildMainTitleTextWidget(String text){
    return Text(text, style: mainTitleStyle);
  }
  
  static Widget buildLoadingView({String? tip}){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GifView.asset(
          'images/gif_loading.gif',
          height: 120.w,
          width: 160.w,
          frameRate: 30, // default is 15 FPS
        ),
        SizedBox(height: 18.h,),
        Text(tip ?? CustomLocalizations.text("loading_tip"), style: TextStyle(color: const Color(0xFF333333), fontSize: 14.sp, fontWeight: FontWeightConf.medium),)
      ],
    );
  }

  static Widget buildNetErrView(Function() onTap){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AssetImageView(fileName: "img_net_err.png", width: 171.w, height: 128.h,),
        SizedBox(height: 9.h,),
        Text(CustomLocalizations.text("net_err_retry"), style: TextStyle(color: const Color(0xFF999999), fontSize: 14.sp, fontWeight: FontWeightConf.regular),),
        InkWell(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.only(top: 16.h),
            height: 50.h,
            width: 128.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.w),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFFA2FF92),
                  Color(0xFF20F2C2),
                ],
              ),
            ),
            child: Text(CustomLocalizations.text("refresh"), style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeightConf.medium),),
          ),
        )
      ],
    );
  }

  static Widget buildNoDataView({String? tip}){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AssetImageView(fileName: "img_no_data.png", width: 158.w, height: 136.h,),
        Text(tip??CustomLocalizations.text("no_data"), style: TextStyle(color: const Color(0xFF999999), fontSize: 14.sp, fontWeight: FontWeightConf.regular),),
      ],
    );
  }

  static Widget buildNoDataHView({String? tip}){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AssetImageView(fileName: "img_no_data_h.png", width: 80.w, height: 80.h,),
        Text(tip??CustomLocalizations.text("no_data"), style: TextStyle(color: const Color(0xFF999999), fontSize: 12.sp, fontWeight: FontWeightConf.regular),),
      ],
    );
  }
}