

import 'package:enjoy_meal/app/base/config/font_weight_conf.dart';
import 'package:enjoy_meal/app/base/widget/asset_image_view.dart';
import 'package:enjoy_meal/app/data/model/restaurant_data.dart';
import 'package:enjoy_meal/app/ui/main/controllers/select_set_menu_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../base/utils/view_util.dart';
import '../../../base/widget/tap_down_zoom_out_view.dart';
import '../../../local/custom_localizations.dart';
import '../model/page_dish_list.dart';
import 'custom_base_view.dart';

class SelectSetMenuView extends CustomBaseView<SelectSetMenuController> {

  SelectSetMenuView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Color pageBackgroundColor() {
    return const Color(0xFFF7F0E1);
  }

  @override
  Widget pageContent(BuildContext context) {
    return Container(
      child: body(context),
    );
  }

  @override
  Widget body(BuildContext context) {
    return Stack(
      children: [
        Container(
        ),

        Positioned.fill(
            child: controller.bgImgUrl != null ? ViewUtil.cachedImage(
              controller.bgImgUrl!,
              fit: BoxFit.fill,
            ) : const SizedBox(),
        ),


        Container(
          padding: EdgeInsets.fromLTRB(45.w, 84.h, 45.w, 0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(flex: 1,
                      child: SizedBox(
                        height: 80.h,
                        child: _buildMainTabView(),
                      )),

                  SizedBox(width: 10.w,),

                  TapDownZoomOutView(
                      onClicked: (){
                        Get.back();
                      },
                      child: Container(
                        width: 145.w,
                        height: 65.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE1D530),
                          borderRadius: BorderRadius.circular(13.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFF2E85E),
                              offset: Offset(2.w, 3.h),
                              blurRadius: 2.r, // 阴影的模糊半径
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(CustomLocalizations.text("cancel"), style: TextStyle(color: Colors.black, fontSize: 25.sp, fontWeight: FontWeightConf.black),),
                      )),
                ],
              ),
              Container(
                height: 480.h,
                margin: EdgeInsets.only(top: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E8),
                  border: Border.all(
                    color: const Color(0xFF01ABFC),
                    width: 3.w
                  ),
                ),
                child: Obx((){
                  int currentIndex = controller.currentTabIndex;
                  return _buildCenterMenuPanel();
                }),
              ),

              SizedBox(height: 20.h,),

              _buildOperateMenuPanel(),
            ],
          ),
        ),
      ],
    );
  }

  _buildMainTabView() {
    return Obx((){
      int currentIndex = controller.currentTabIndex;
      return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.selectedPackageInfo.packageCategoryInfos.length,
          itemBuilder: (context, index){
            final model = controller.selectedPackageInfo.packageCategoryInfos[index];
            return Container(
              height: 60.h,
              width: 289.w,
              margin: EdgeInsets.only(right: 10.w),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(currentIndex >= index ? 'images/select_step_done.png' : 'images/select_step.png'),
                  fit: BoxFit.fill,
                ),
              ),
              alignment: Alignment.center,
              child: Text(model.getCategoryName(), style: TextStyle(color: Colors.black, fontSize: 23.sp, fontWeight: FontWeightConf.bold),),
            );
          }
      );
    });
  }

  _buildCenterMenuPanel() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 218.w,
          margin: EdgeInsets.only(left: 6.w, right: 6.w),
          child: _buildSelectedDishListView(),
        ),

        TapDownZoomOutView(child: Container(
          width: 50.w,
          height: 350.h,
          padding: EdgeInsets.only(top: 64.h),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/img_menu_pre_bg.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              AssetImageView(fileName: "ic_menu_pre_arrow.png", width: 42.w, height: 41.h,),
              SizedBox(height: 30.h,),
              Text(CustomLocalizations.text("previous_page"), style: TextStyle(color: Colors.black, fontSize: 22.sp, fontWeight: FontWeightConf.bold)),
            ],
          ),
        ), onClicked: (){
          controller.onPreBtnClicked();
        },),

        Container(
          width: 816.w,
          height: 439.h,
          child: _buildPageView(),
        ),

        TapDownZoomOutView(child: Container(
          width: 50.w,
          height: 350.h,
          padding: EdgeInsets.only(top: 64.h),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/img_menu_pre_bg.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              AssetImageView(fileName: "ic_menu_next_arrow.png", width: 42.w, height: 41.h,),
              SizedBox(height: 30.h,),
              Text(CustomLocalizations.text("next_page"), style: TextStyle(color: Colors.black, fontSize: 22.sp, fontWeight: FontWeightConf.bold)),
            ],
          ),
        ), onClicked: (){
          controller.onNextBtnClicked();
        },),
      ],
    );
  }

  _buildSelectedDishListView() {
    return Obx(()=>ListView.builder(
        itemCount: controller.selectedDishInfoList.length + 1,
        itemBuilder: (context, index){
          if (index == controller.selectedDishInfoList.length) {
            return Container(
              height: 110.h,
              width: 218.w,
              margin: EdgeInsets.only(top: 2.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFBF3C5),
                border: Border.all(
                    color: const Color(0xFF99D3CF),
                    width: 1.w
                ),
              ),
            );
          }
          final model = controller.selectedDishInfoList[index];
          return Container(
            height: 110.h,
            width: 218.w,
            margin: EdgeInsets.only(top: 2.w),
            padding: EdgeInsets.only(left: 14.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFBF3C5),
              border: Border.all(
                  color: const Color(0xFF99D3CF),
                  width: 1.w
              ),
            ),
            alignment: Alignment.centerLeft,
            child: Text("${index+1}. \n${model.getDishName()}", style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeightConf.black),),
          );
        }));
  }

  _buildPageView() {
    return PageView.builder(
        scrollDirection: Axis.horizontal,
        controller: controller.pageController,
        onPageChanged: controller.onPageChanged,
        itemCount: controller.pageDishDataList.length,
        itemBuilder: (BuildContext context, int index){
          final item = controller.pageDishDataList[index];
          return MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: item.isShowImg ? _buildDishGridView(item) : _buildWineGridView(item),
          );
        });
  }

  _buildWineGridView(PageDishList item) {
    return Container(
      padding: EdgeInsets.only(left: 23.w, right: 23.w, top: 32.h, bottom: 32.h),
      child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 每行的item数量
        childAspectRatio: (249.w/55.h), // 子widget的宽高比例
        mainAxisSpacing: 26.h, // 主轴方向的间隔
        crossAxisSpacing: 23.w, // 交叉轴方向的间隔
      ), itemCount: item.dishList.length,
          itemBuilder: (context, index){
            final model = item.dishList[index];
            return TapDownZoomOutView(child: _buildWineGridItem(model), onClicked: (){
              controller.onSetMenuDishItemClicked(model);
            });
          }),
    );
  }

  _buildWineGridItem(DishInfo item) {
    return Container(
      height: 55.h,
      width: 249.w,
      decoration: BoxDecoration(
        color: const Color(0xFFFAFCDB ),
        border: Border.all(
            color: const Color(0xFF00A0E9),
            width: 1.w
        ),
      ),
      alignment: Alignment.center,
      child: Text(item.getDishName(), style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeightConf.bold),),

    );
  }

  _buildDishGridView(PageDishList item) {
    return Container(
      padding: EdgeInsets.only(left: 12.w, right: 12.w),
      child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // 每行的item数量
        childAspectRatio: (195.w/212.h),
        mainAxisSpacing: 16.h, // 主轴方向的间隔
        crossAxisSpacing: 12.w, // 交叉轴方向的间隔
      ), itemCount: item.dishList.length,
          itemBuilder: (context, index){
          final model = item.dishList[index];
            return TapDownZoomOutView(child: _buildDishGridItem(model), onClicked: (){
              controller.onSetMenuDishItemClicked(model);
            });
          }),
    );
  }

  _buildDishGridItem(DishInfo item) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          child: item.hasThumbnailUrl ? ViewUtil.cachedImage(
            item.thumbnailUrl!,
            fit: BoxFit.cover,
          ) : Container(
            color: Colors.grey,
            alignment: Alignment.center,
            child: Text(CustomLocalizations.text("no_picture"), style: TextStyle(color: const Color(0xFF555555), fontSize: 22.sp, fontWeight: FontWeightConf.medium),),
          ),
        ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 55.h,
              color: Colors.white,
              alignment: Alignment.center,
              child: Text(item.getDishName()),
            )),
      ],
    );
  }

  _buildOperateMenuPanel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TapDownZoomOutView(
            onClicked: controller.onRevokeBackClicked,
            child: Container(
              width: 185.w,
              height: 75.h,
              margin: EdgeInsets.only(right: 68.w),
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color(0xFF00A0E9),
                    width: 2.w
                ),
                borderRadius: BorderRadius.circular(13.r),
                color: const Color(0xFFF19149),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD9D9D9),
                    offset: Offset(3.w, 3.h),
                    blurRadius: 2.r, // 阴影的模糊半径
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(CustomLocalizations.text("back"), style: TextStyle(color: Colors.black, fontSize: 30.sp, fontWeight: FontWeightConf.black),),
            )),

        Expanded(flex: 1,
            child: Text("${controller.selectedPackageInfo.getPackageName()}   ${controller.selectedPackageInfo.price.toInt()}${CustomLocalizations.text("money_unit_tax_included")}",
            style: TextStyle(color: Colors.white, fontSize: 42.sp, fontWeight: FontWeightConf.bold),
            overflow: TextOverflow.ellipsis
        )),
      ],
    );
  }

}
