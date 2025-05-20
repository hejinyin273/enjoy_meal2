

import 'package:enjoy_meal/app/base/utils/view_util.dart';
import 'package:enjoy_meal/app/data/model/language.dart';
import 'package:enjoy_meal/app/data/model/load_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gif_view/gif_view.dart';
import '../../../base/config/font_weight_conf.dart';
import '../../../base/widget/asset_image_view.dart';
import '../../../base/widget/tap_down_zoom_out_view.dart';
import '../../../data/model/restaurant_data.dart';
import '../controllers/main_controller.dart';
import 'custom_base_view.dart';

class MainView extends CustomBaseView<MainController> {

  MainView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  bool canPop() {
    return false;
  }

  @override
  Widget pageContent(BuildContext context) {
    return body(context);
  }

  @override
  Widget body(BuildContext context) {
    return Stack(
      children: [
        Obx((){
          if (LoadState.success == controller.loadInitState) {
            return _buildInitDoneView();
          } else if (LoadState.loading == controller.loadInitState) {
            return Center(
              child: _buildLoadingView(),
            );
          } else {
            return Center(
              child: ViewUtil.buildNetErrView(() {
                controller.onNetErrRetryClicked();
              }),
            );
          }
        }),

        Obx(()=>Offstage(
          offstage: !controller.isOnAppUpgradeMode.value,
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: _buildAppUpgradeView(),
          ),
        )),
      ],
    );
  }

  _buildLoadingView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GifView.asset(
          'images/gif_loading.gif',
          height: 80.w,
          width: 80.w,
          frameRate: 30, // default is 15 FPS
        ),
        SizedBox(height: 18.h,),
        Obx(()=>Text(controller.loadingTipObs.value, style: TextStyle(color: const Color(0xFF333333), fontSize: 14.sp, fontWeight: FontWeightConf.medium),))
      ],
    );
  }

  _buildAppUpgradeView(){
    return GestureDetector(
      onTap: (){
        controller.onCheckAppUpgradeBtnClick();
      },
      child: Stack(
        children: [
          Container(
            height: 78.w,
            width: 192.w,
            color: Colors.white,
            margin: EdgeInsets.all(5.w),
            child: Stack(
              children: [
                Container(),
                Positioned(
                  top: 14.8.w,
                  left: 18.5.w,
                  child: SizedBox(
                    height: 50.w,
                    width: 156.w,
                    child: Stack(
                      children: [
                        Obx(()=>Container(
                          width: 156.w * controller.progress/100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.w),
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFFD5FF7B),
                                Color(0xFF00DBC1),
                              ],
                            ),
                          ),
                        )),
                        Center(child: Obx(()=>Text("${controller.btnTipMessageObs}",
                          style: TextStyle(color: const Color(0xFF000000), fontSize: 16.sp, fontWeight: FontWeightConf.medium),)))
                      ],
                    ),
                  ),),
                Obx(()=>(controller.progress == 100)? const Positioned.fill(child: AssetImageView(fileName: "img_progress_mask.png", fit: BoxFit.fill,),)
                    : const Positioned.fill(child: AssetImageView(fileName: "img_progress_mask_line.png", fit: BoxFit.fill),)),
              ],
            ),
          ),

          Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 10.w,
                color: Colors.white,
              )),

          Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 10.w,
                color: Colors.white,
              )),
        ],
      ),
    );
  }

  _buildInitDoneView() {
    return Stack(
      children: [
        Positioned.fill(
            child: controller.bgImgUrl != null ? ViewUtil.cachedImage(
              controller.bgImgUrl!,
              fit: BoxFit.fill,
            ) : Container()
        ),

        Container(
          padding: EdgeInsets.only(top: 285.h),
          alignment: Alignment.center,
          child: Obx(()=>_buildCenterPanel()),
        ),

        /*Positioned(
            top: 107.h,
            left: 261.w,
            child: Text("ここにお店の名前やキャッチコピーを書く",
              style: TextStyle(color: Colors.white, fontSize: 48.sp, fontWeight: FontWeightConf.black),)),*/

        Positioned(
            top: 0,
            right: 0,
            child: Obx(()=> (controller.loadInitState == LoadState.success && controller.globalController.userType == RestaurantConf.userTypeUser)
                ? buildWaiterCallView()
                : const SizedBox(width: 0, height: 0,)),
        ),

        /*Positioned(
            top: 0,
            right: 0,
            child: buildCallingStaffRingView()),*/

        Positioned(
            bottom: 0,
            left: 0,
            child: Obx(()=> (controller.loadInitState == LoadState.success && controller.globalController.userType == RestaurantConf.userTypeUser)
                ? buildTableNumberView()
                : const SizedBox(width: 0, height: 0,))),

        Positioned(
            bottom: 64.5.h,
            right: 67.5.w,
            child: _buildLanguageSelectPanel()),


      ],
    );
  }

  Widget buildCallingStaffRingView() {
    return Obx(()=>Offstage(
      offstage: controller.globalController.isOnCallingStaffObs.value,
      child: Container(
        width: 120.w,
        height: 75.h,
        alignment: Alignment.center,
        child: const Icon(Icons.add),
      ),
    ));
  }

  _buildCenterPanel() {
    controller.selectedLanguage;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /*Text("いらっしゃいませ、（店名）へようこそ", style: TextStyle(fontSize: 40.sp,
            color: Colors.black,
            fontWeight: FontWeightConf.black),),*/

        Container(
          width: 665.w,
          height: 80.h,
          //color: const Color(0xFFE5E5E5),
          child: Html(data: controller.globalController.restaurantData.restaurantBaseInfo.getRestaurantWelcomeMsg()),
        ),

        SizedBox(height: 21.h,),
        _buildStartBtn(),

        Container(
          width: 665.w,
          height: 106.h,
          margin: EdgeInsets.only(top: 28.h, bottom: 28.h),
          color: const Color(0xFFE5E5E5),
          alignment: Alignment.center,
          child: Html(data: controller.globalController.restaurantData.restaurantBaseInfo.getRestaurantTips(),),
          /*child: Text("従業員によるオーダーをご希望の方は、\n店員呼出ボタンを押してください", style: TextStyle(fontSize: 25.sp,
              color: Colors.black,
              fontWeight: FontWeightConf.bold),),*/
        ),

        Container(
          width: 665.w,
          height: 90.h,
          //color: const Color(0xFFE5E5E5),
          child: Html(data: controller.globalController.restaurantData.restaurantBaseInfo.getRestaurantBusinessTime()),
        ),

       /* Text("営業時間ランチ；11：00～15：00　デイナー17：00～23：00（LO22：30）", style: TextStyle(fontSize: 20.sp,
            color: Colors.black,
            fontWeight: FontWeightConf.bold),),*/

      ],
    );
  }

  _buildStartBtn() {
    return TapDownZoomOutView(
        child: Container(
          width: 665.w,
          height: 105.h,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/img_main_start_btn.png'),
              fit: BoxFit.fill,
            ),
          ),
          alignment: Alignment.center,
          child: Text(controller.globalController.userType == RestaurantConf.userTypeUser ? "注文を開始する" : "開始", style: TextStyle(fontSize: 42.sp,
              color: const Color(0xFF010101),
              fontWeight: FontWeightConf.black),),
        ), onClicked: (){
      controller.onStartBtnClicked();
    });
  }

  _buildLanguageSelectPanel() {
    return Obx((){
      return SizedBox(
        width: 344.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLanguageItem("日本語", Language.jp == controller.selectedLanguage, (){
              controller.updateSelectedLanguage(Language.jp);
            }),
            _buildLanguageItem("中国語", Language.zh == controller.selectedLanguage, (){
              controller.updateSelectedLanguage(Language.zh);
            }),
            _buildLanguageItem("英語", Language.en == controller.selectedLanguage, (){
              controller.updateSelectedLanguage(Language.en);
            }),
          ],
        ),
      );
    });
  }

  _buildLanguageItem(String name, bool isSelected, Function() clicked) {
    return TapDownZoomOutView(onClicked: clicked,child: Container(
      height: 40.h,
      width: 100.w,
      decoration: isSelected ? BoxDecoration(
          borderRadius: BorderRadius.circular(5.w),
          color: const Color(0xFFD9D9D9)
      ) : BoxDecoration(
        borderRadius: BorderRadius.circular(5.w),
          color: const Color(0xFFFFFAFA)
      ),
      alignment: Alignment.center,
      child: Text(name, style: TextStyle(fontSize: 20.sp,
          color: Colors.black,
          fontWeight: FontWeightConf.black),),
    ),);
  }
}
