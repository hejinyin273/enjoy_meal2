

import 'package:auto_size_text/auto_size_text.dart';
import 'package:enjoy_meal/app/base/config/font_weight_conf.dart';
import 'package:enjoy_meal/app/base/widget/tap_down_zoom_out_view.dart';
import 'package:enjoy_meal/app/local/custom_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../base/utils/view_util.dart';
import '../../../data/model/restaurant_data.dart';
import '../controllers/main_dish_controller.dart';
import 'custom_base_view.dart';

class MainDishView extends CustomBaseView<MainDishController> {

  MainDishView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  bool canPop() {
    return false;
  }

  @override
  Widget pageContent(BuildContext context) {
    return Obx(()=>controller.refreshDataTimeObs.value > 0 ? body(context) : const SizedBox());
  }

  @override
  Widget body(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: const Color(0xFFF7F0E1),
        ),

        _buildTopLayout(),

        Positioned(
          top: 79.h,
          right: 0,
          child: Container(
            height: 57.h,
            width: 235.w,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/top_menu_bg.png'),
                fit: BoxFit.fill,
              ),
            ),
            alignment: Alignment.center,
            child: Text(CustomLocalizations.text("best_ranking"), style: TextStyle(color: Colors.black, fontSize: 28.sp, fontWeight: FontWeightConf.black),),
          ),),

        Positioned(
          top: 143.h,
          right: 0,
          bottom: 0,
          child: SizedBox(
            width: 235.w,
            child: _buildRankingPanel(),
          ),),

        Positioned(
            top: 0,
            right: 0,
            child: buildWaiterCallView()),

        Positioned(
            bottom: 0,
            left: 0,
            child: buildTableNumberView()),

        Positioned(
            bottom: 5.h,
            left: 200.w,
            child: controller.globalController.userType == RestaurantConf.userTypeUser
                ? const SizedBox()
                : buildWaiterBackBtn()),
      ],
    );
  }

  _buildTopLayout() {///0为6宮格，1为9宮格，2为12宮格
    if (controller.topLayoutMode == RestaurantConf.topLayoutMode_6) {
      return Container(
        margin: EdgeInsets.only(right: 251.w),
        child: _buildGridPanel_6(),
      );
    } else if (controller.topLayoutMode == RestaurantConf.topLayoutMode_9) {
      return Container(
        margin: EdgeInsets.only(right: 265.w),
        child: _buildGridPanel_9(),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(right: 251.w),
        child: _buildGridPanel_12(),
      );
    }
  }

  _buildGridPanel_6() {
    return Column(
      children: [
        SizedBox(
          height: 380.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildGridItem_6(0, 428.w, 380.h),

              _buildGridItem_6(1, 275.w, 380.h),

              _buildGridItem_6(2, 310.w, 380.h),
            ],
          ),
        ),
        SizedBox(height: 11.h,),
        SizedBox(
          height: 264.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildGridItem_6(3, 440.w, 264.h),

              _buildGridItem_6(4, 290.w, 264.h),

              _buildGridItem_6(5, 285.w, 264.h),
            ],
          ),
        ),
      ],
    );
  }

  _buildGridItem_6(int index, double width, double height) {
    if (index <= controller.topLayoutInfoList.length -1) {
      final item = controller.topLayoutInfoList[index];
      return TapDownZoomOutView(
          onClicked: (){
            controller.onCategoryItemClicked(item);
          },
          child: SizedBox(
            width: width,
            height: height,
            child: item.imageUrl != null ? ViewUtil.cachedImage(
              item.imageUrl!,
              fit: BoxFit.cover,
              radius: 8.w,
            ) : const SizedBox(),
          ));
    }

    return const SizedBox();
  }

  _buildGridPanel_9() {
    return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3, // 每行的item数量
      childAspectRatio: (337.w/224.h), // 子widget的宽高比例 101/186 186=162 + 12 + 12
      mainAxisSpacing: 7.h, // 主轴方向的间隔
      crossAxisSpacing: 9.w, // 交叉轴方向的间隔
    ), itemCount: controller.topLayoutInfoList.length,
        itemBuilder: (context, index){
      final model = controller.topLayoutInfoList[index];
          return TapDownZoomOutView(child: _buildGridItem_9(model), onClicked: (){
            controller.onCategoryItemClicked(model);
          });
        });
  }

  _buildGridItem_9(RestaurantTopLayoutInfo item) {
    String categoryName = item.getCategoryName();
    if (item.isBuffetButton == 1) {
      if (item.getCategoryName().isEmpty) {
        categoryName = controller.globalController.buffetCategoryDesc;
      }
    }
    return Container(
      height: 224.h,
      width: 337.w,
      color: Colors.green,
      alignment: Alignment.bottomCenter,
      child: Stack(
        children: [
          Container(
            child: item.imageUrl != null ? ViewUtil.cachedImage(
              item.imageUrl!,
              fit: BoxFit.cover,
              radius: 8.w,
            ) : const SizedBox(),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60.h,
                color: Colors.white,
                alignment: Alignment.center,
                child: AutoSizeText(categoryName, maxLines: 2,
                  style: TextStyle(color: Colors.black, fontSize: 28.sp, fontWeight: FontWeightConf.bold),),
              )),
        ],
      ),
    );
  }

  _buildGridPanel_12() {
    return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4, // 每行的item数量
      childAspectRatio: (252.w/221.h), // 子widget的宽高比例 101/186 186=162 + 12 + 12
      mainAxisSpacing: 14.h, // 主轴方向的间隔
      crossAxisSpacing: 7.w, // 交叉轴方向的间隔
    ), itemCount: 12,
        itemBuilder: (context, index){
          final model = controller.topLayoutInfoList[index];
          return TapDownZoomOutView(child: _buildGridItem_12(model), onClicked: (){
            controller.onCategoryItemClicked(model);
          });
        });
  }

  _buildGridItem_12(RestaurantTopLayoutInfo item) {
    String categoryName = item.getCategoryName();
    if (item.isBuffetButton == 1) {
      if (item.getCategoryName().isEmpty) {
        categoryName = controller.globalController.buffetCategoryDesc;
      }
    }
    return Container(
      height: 221.h,
      width: 252.w,
      child: Stack(
        children: [
          Container(
            child: item.imageUrl != null ? ViewUtil.cachedImage(
              item.imageUrl!,
              fit: BoxFit.cover,
            ) : const SizedBox(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60.h,
              color: Colors.white,
              alignment: Alignment.center,
              child: AutoSizeText(categoryName, maxLines: 2,
                style: TextStyle(color: Colors.black, fontSize: 28.sp, fontWeight: FontWeightConf.bold),),
            ),)
        ],
      ),
    );
  }

  _buildRankingPanel() {
    return Obx(()=>ListView.builder(
      itemCount: controller.hotDishList.length,
      itemBuilder: (context, index){
        final model = controller.hotDishList[index];
        return TapDownZoomOutView(
            onClicked: (){
              controller.onRankingItemClicked(model);
            },
            child: Container(
              height: 57.h,
              margin: EdgeInsets.only(bottom: 6.h),
              padding: EdgeInsets.only(left: 11.w),
              color: Colors.white,
              alignment: Alignment.centerLeft,
              child: Text(model.getDishName(), style: TextStyle(color: Colors.black, fontSize: 28.sp, fontWeight: FontWeightConf.bold),),
            ));
      },));
  }
}
