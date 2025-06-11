
import 'package:auto_size_text/auto_size_text.dart';
import 'package:enjoy_meal/app/base/config/font_weight_conf.dart';
import 'package:enjoy_meal/app/base/widget/asset_image_view.dart';
import 'package:enjoy_meal/app/ui/main/model/page_dish_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../base/utils/view_util.dart';
import '../../../base/widget/tap_down_zoom_out_view.dart';
import '../../../data/model/restaurant_data.dart';
import '../../../local/custom_localizations.dart';
import '../controllers/sub_dish_controller.dart';
import 'custom_base_view.dart';

class SubDishView extends CustomBaseView<SubDishController> {
  final previousPage = CustomLocalizations.text("previous_page");
  final nextPage = CustomLocalizations.text("next_page");
  final noPicture = CustomLocalizations.text("no_picture");
  final soldOut = CustomLocalizations.text("sold_out");
  final taxIncluded = CustomLocalizations.text("tax_included");
  final moneyUnit = CustomLocalizations.text("money_unit");
  final sure = CustomLocalizations.text("sure");
  final remainingTime = CustomLocalizations.text("remaining_time");
  SubDishView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Color pageBackgroundColor() {
    return const Color(0xFFF7F0E1);
  }

  @override
  Widget pageContent(BuildContext context) {
    return Obx(()=>controller.isUpdatePageData ? body(context) : body(context));
  }

  @override
  bool canPop() {
    return false;
  }

  @override
  Widget body(BuildContext context) {
    return Stack(
      children: [
        Container(
        ),

        Obx((){
          int mId = controller.selectedMainCategoryId;
          int subId = controller.selectedSubCategoryId;
          if (controller.currentPageIndex <= controller.pageDishDataList.length -1) {
            final bgUrl = controller.pageDishDataList[controller.currentPageIndex].bgUrl;
            if (bgUrl != null) {
              return Positioned.fill(child: ViewUtil.cachedImage(
                bgUrl,
                fit: BoxFit.fill,
              ));
            }
          }
          return const SizedBox();
        }),

        Container(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.only(top: 83.h),
          child: Obx((){
            String? categoryDesc = controller.getSubCategoryDesc(controller.selectedSubCategoryId);
            if (categoryDesc == null || categoryDesc.isEmpty) {
              categoryDesc = controller.getMainCategoryDesc(controller.selectedMainCategoryId);
            }
            if (categoryDesc == null || categoryDesc.isEmpty) {
              return const SizedBox();
            }
            return SizedBox(
              width: 833.w,
              height: 300.h,
              child: Html(data: categoryDesc,),
            );
          }),
        ),

        /*Obx((){
          final mainCategoryName = controller.getMainCategoryName(controller.selectedMainCategoryId);
          double marginTop = controller.subCategoryInfoList.isNotEmpty ? 113.h : 83.h;
          return Container(
            margin: EdgeInsets.only(top: marginTop),
            padding: EdgeInsets.only(top:50.h, left: 24.w),
            width: 163.w,
            child: Text(mainCategoryName, maxLines: 6, overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 48.sp, fontWeight: FontWeightConf.bold)),
          );
        }),*/

        Container(
          color: Colors.transparent,
          child: Column(
            children: [
              Container(
                color: const Color(0xFFF39800),
                margin: EdgeInsets.only(right: 135.w),
                padding: EdgeInsets.only(bottom: 3.h),
                height: 83.h,
                child: _buildMainTabView(),
              ),

              Obx((){
                int mId = controller.selectedMainCategoryId;
                return Container(
                  color: controller.subCategoryInfoList.isNotEmpty ? const Color(0xFFF39800) : Colors.transparent,
                  margin: EdgeInsets.only(right: 135.w),
                  padding: EdgeInsets.only(bottom: 3.h),
                  height: 63.h,
                  child: _buildSubTabView(),
                );
              }),

              SizedBox(height: 32.h,),
              SizedBox(
                height: 534.h,
                width: 953.w,
                child: _buildCenterMenuPanel(),),
            ],
          ),
        ),

        Positioned(
            top: 0,
            right: 0,
            child: buildWaiterCallView()),

        Positioned(
            bottom: 0,
            left: 0,
            child: buildTableNumberView()),

        Positioned(
          top: 78.h,
          right: 0,
          child: buildMenuToolPanel(),),

        Positioned(
          bottom: 14.5.h,
          left: 447.w, child: _buildBuffetRemainingTimeView()),
      ],
    );
  }

  _buildMainTabView() {
    return Obx((){
      final selectedId = controller.selectedMainCategoryId;
      return ListView.builder(
          scrollDirection: Axis.horizontal,
          controller: controller.mainListScrollController,
          itemCount: controller.mainCategoryInfoList.length,
          itemBuilder: (context, index){
            final item = controller.mainCategoryInfoList[index];
            bool isSelected = selectedId == item.id;
            return Container(
              height: 80.h,
              width: 115.w,
              color: const Color(0xFF490202),
              padding: EdgeInsets.only(right: 2.w),
              child: _buildMainTabViewItem(index, item, isSelected),
            );
          }
      );
    });
  }

  _buildMainTabViewItem(int index, CategoryInfo item, bool isSelected) {
    bool isEnable = true;
    if (controller.globalController.isOnBuffetMode) {
      isEnable = controller.globalController.isBuffetSupportCategoryId(item.id);
    }
    if (isEnable) {
      isEnable = controller.isValidCategoryId(item.id);
    }

    return TapDownZoomOutView(
        onClicked: (){
          if (isEnable) {
            controller.onMainTabClicked(item);
          }
        },
        child: Container(
          alignment: Alignment.center,
          color: isEnable ? (isSelected ? const Color(0xFFF39800) : const Color(0xFFF7F0E1)) : const Color(0xFF969292),
          child: AutoSizeText(item.getCategoryName(),
            style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeightConf.medium),
            textAlign: TextAlign.center,),
        ));
  }

  _buildSubTabView() {
    return Obx((){
      final selectedId = controller.selectedSubCategoryId;
      return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.subCategoryInfoList.length,
          itemBuilder: (context, index){
            final item = controller.subCategoryInfoList[index];
            bool isSelected = selectedId == item.id;
            return Container(
              height: 60.h,
              width: 115.w,
              padding: EdgeInsets.only(right: 2.w),
              color: const Color(0xFFF39800),
              child: TapDownZoomOutView(
                  onClicked: (){
                    if (controller.globalController.isOnBuffetMode) {
                      if (controller.globalController.isBuffetSupportCategoryId(item.id)) {
                        controller.onSubTabClicked(item);
                      }
                    } else {
                      controller.onSubTabClicked(item);
                    }
                  },
                  child: _buildSubTabViewItem(index, item, isSelected)),
            );
          }
      );
    });
  }

  _buildSubTabViewItem(int index, CategoryInfo item, bool isSelected) {
    if (isSelected) {
      return Stack(
        children: [
          Container(
            alignment: Alignment.center,
            color: const Color(0xFFFFFFFF),
            padding: EdgeInsets.only(bottom: 3.h),
            child: AutoSizeText(item.getCategoryName(),
              style: TextStyle(color: Colors.black, fontSize: 20.sp,
                  fontWeight: FontWeightConf.medium), textAlign: TextAlign.center, maxLines: 2,),
          ),

          Positioned(
              bottom: 2.h,
              child: Container(
                height: 4.h,
                width: 85.w,
                margin: EdgeInsets.symmetric(horizontal: 14.w),
                color: const Color(0xFFFF0303),)),
        ],
      );
    }

    bool isEnable = true;
    if (controller.globalController.isOnBuffetMode) {
      isEnable = controller.globalController.isBuffetSupportCategoryId(item.id);
    }

    return Container(
      alignment: Alignment.center,
      color: isEnable ? const Color(0xFFFFFFFF) : const Color(0xFFD9D9D9),
      child: AutoSizeText(item.getCategoryName(), style: TextStyle(color: Colors.black, fontSize: 20.sp,
          fontWeight: FontWeightConf.medium), textAlign: TextAlign.center, maxLines: 2,),
    );
  }

  _buildCenterMenuPanel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(()=>controller.isShowPreBtnObs.value
            ? TapDownZoomOutView(child: Container(
          width: 50.w,
          height: 350.h,
          padding: EdgeInsets.only(top: 55.h),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/img_menu_pre_bg.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AssetImageView(fileName: "ic_menu_pre_arrow.png", width: 42.w, height: 42.h,),
              SizedBox(height: 35.h,),
              Text(previousPage, style: TextStyle(color: Colors.black, fontSize: 22.sp, fontWeight: FontWeightConf.bold), textAlign: TextAlign.center,),
            ],
          ),
        ), onClicked: (){
          controller.onPreBtnClicked();
        },) : SizedBox(width: 50.w, height: 350.h,)),

        SizedBox(
          width: 833.w,
          height: 537.h,
          child: _buildPageView(),
        ),

        Obx(()=>controller.isShowNextBtnObs.value
            ? TapDownZoomOutView(child: Container(
          width: 50.w,
          height: 350.h,
          padding: EdgeInsets.only(top: 55.h),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/img_menu_pre_bg.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AssetImageView(fileName: "ic_menu_next_arrow.png", width: 42.w, height: 41.h,),
              SizedBox(height: 35.h,),
              Text(nextPage, style: TextStyle(color: Colors.black, fontSize: 22.sp, fontWeight: FontWeightConf.bold), textAlign: TextAlign.center,),
            ],
          ),
        ), onClicked: (){
          controller.onNextBtnClicked();
        },) : SizedBox(width: 50.w, height: 350.h,)),
      ],
    );
  }

  _buildPageView() {
    return PageView.builder(
        scrollDirection: Axis.horizontal,
        reverse: false,
        controller: controller.pageController,
        onPageChanged: controller.onPageChanged,
        itemCount: controller.pageDishDataList.length, //controller.tabList.length,
        itemBuilder: (BuildContext context, int index){
          return MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: _buildPageViewItem(controller.pageDishDataList[index]),
            //child: _buildPageViewBase(context, index),
          );
        });
  }

  _buildPageViewItem(PageDishList model) {
    if (model.mainCategoryId == RestaurantConf.categoryBuffetId) {
      return _buildBuffetPanel(model);
    } else if (model.packageInfo != null) {
      return _buildPackagePanel(model);
    } else {
      return model.displayMode == RestaurantConf.displayMode_4 ? _buildGrid4Panel(model) : _buildGrid6Panel(model);
    }
  }

  _buildGrid4Panel(PageDishList pageDishList) {
    return Container(
      padding: EdgeInsets.only(left: 9.w, right: 9.w),
      child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 每行的item数量
        childAspectRatio: (310.w/175.h), // 子widget的宽高比例 101/186 186=162 + 12 + 12
        mainAxisSpacing: 60.h, // 主轴方向的间隔
        crossAxisSpacing: 67.w, // 交叉轴方向的间隔
      ), itemCount: pageDishList.dishList.length,
          itemBuilder: (context, index){
            final item = pageDishList.dishList[index];
            return TapDownZoomOutView(child: _buildGridItem(item), onClicked: (){
              if (controller.globalController.isOnBuffetMode) {
                if (controller.globalController.isBuffetSupportDishId(item.id)) {
                  controller.onDishInfoItemClicked(pageDishList.mainCategoryId, item);
                }
              } else {
                controller.onDishInfoItemClicked(pageDishList.mainCategoryId, item);
              }
            });
          }),
    );
  }

  _buildGrid6Panel(PageDishList pageDishList) {
    return Container(
      padding: EdgeInsets.only(left: 9.w, right: 9.w),
      child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 每行的item数量
        childAspectRatio: (270.w/260.h), // 子widget的宽高比例 101/186 186=162 + 12 + 12
        mainAxisSpacing: 16.h, // 主轴方向的间隔
        crossAxisSpacing: 12.w, // 交叉轴方向的间隔
      ), itemCount: pageDishList.dishList.length,
          itemBuilder: (context, index){
            final item = pageDishList.dishList[index];
            return TapDownZoomOutView(child: _buildGridItem(item), onClicked: (){
              if (controller.globalController.isOnBuffetMode) {
                if (controller.globalController.isBuffetSupportDishId(item.id)) {
                  controller.onDishInfoItemClicked(pageDishList.mainCategoryId, item);
                }
              } else {
                controller.onDishInfoItemClicked(pageDishList.mainCategoryId, item);
              }
            });
          }),
    );
  }

  _buildGridItem(DishInfo item) {
    bool isEnable = true;
    if (controller.globalController.isOnBuffetMode) {
      isEnable = controller.globalController.isBuffetSupportDishId(item.id);
    }
    return Container(
      child: Stack(
        children: [
          Container(),
          Positioned.fill(
              child: item.hasThumbnailUrl ? ViewUtil.cachedImage(
                item.thumbnailUrl!,
                fit: BoxFit.fill,
                width: 270.w,
                height: 260.h
              ) : Container(
                color: Colors.grey,
                alignment: Alignment.center,
                child: Text(noPicture, style: TextStyle(color: const Color(0xFF555555), fontSize: 22.sp, fontWeight: FontWeightConf.medium),),
              ),
          ),

          Positioned(
            top: 0,
              right: 0,
              child: item.available ? const SizedBox() : Container(
                width: 135.w,
                height: 44.w,
                decoration: BoxDecoration(
                    color: const Color(0x99333333),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25.w),
                  )
                ),
                alignment: Alignment.center,
                child: Text(soldOut, style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeightConf.bold),),
              )
          ),

          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 55.h,
                color: isEnable ? Colors.white : const Color(0xFFD9D9D9),
                alignment: Alignment.center,
                child: isEnable ? Stack(
                  children: [
                    Positioned(
                      left: 6.w,
                      top: 2.h,
                      right: 44.w,
                      child: SizedBox(
                        height: 51.h,
                        width: 220.w,
                        child: AutoSizeText(item.getDishName(), maxLines: 2,
                          style: TextStyle(color: Colors.black, fontSize: 18.sp, fontWeight: FontWeightConf.bold),)),
                      ),

                    Positioned(
                        right: 4.w,
                        bottom: 2.h,
                        child: Offstage(
                          offstage: controller.globalController.isOnBuffetMode,
                          child: RichText(
                            textAlign: TextAlign.end,
                            text: TextSpan(
                              style: TextStyle(color: const Color(0xFF000000),
                                  fontSize: 16.sp, fontWeight: FontWeightConf.bold),
                              children: <TextSpan>[
                                TextSpan(text: taxIncluded),
                                TextSpan(text: '${item.price.toInt()}', style: TextStyle(color: const Color(0xFFFF0303),
                                    fontSize: 24.sp, fontWeight: FontWeightConf.bold)),
                                TextSpan(text: moneyUnit),
                              ],
                            ),
                          ),
                        ),
                    ),
                  ],
                ) : AutoSizeText(item.getDishName(), maxLines: 2,
                  style: TextStyle(color: Colors.black, fontSize: 18.sp, fontWeight: FontWeightConf.bold),)),
              ),
        ],
      ),
    );
  }

  _buildPackagePanel(PageDishList model) {
    if (RestaurantConf.packageTypeStepSelect == model.packageInfo!.packageType) {
      return _buildPackageStepSelectPanel(model);
    } else {
      return _buildPackageCollectivePanel(model);
    }
  }
  ///步骤型套餐面板 packageCategoryInfo >= 2
  _buildPackageStepSelectPanel(PageDishList pageDishList) {
    final dataList = pageDishList.packageInfo!.packageCategoryInfos;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          dataList.length == 2 ? _buildPackageStepSelectPanel2Item(pageDishList.packageInfo!.packageCategoryInfos, pageDishList.packageInfo!.available)
              : dataList.length == 3 ? _buildPackageStepSelectPanel3Item(pageDishList.packageInfo!.packageCategoryInfos, pageDishList.packageInfo!.available)
              : Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPackageStepSelectPanel4Item(pageDishList.packageInfo!.packageCategoryInfos, 0),
                  SizedBox(height: 38.h,),
                  _buildPackageStepSelectPanel4Item(pageDishList.packageInfo!.packageCategoryInfos, 2),
                ],
              ),

              _buildPackageAvailable(pageDishList.packageInfo!.available),
            ],
          ),

          SizedBox(height: 43.h,),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              TapDownZoomOutView(
                  onClicked: (){
                    controller.onPackageItemClicked(pageDishList.mainCategoryId, pageDishList.packageInfo!);
                  },
                  child: Container(
                    width: 275.w,
                    height: 114.h,
                    margin: EdgeInsets.only(right: 86.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF39800),
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF0303),
                          offset: Offset(0, 2.h),
                          blurRadius: 2.r, // 阴影的模糊半径
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(sure, style: TextStyle(color: Colors.black, fontSize: 62.sp, fontWeight: FontWeightConf.medium), textAlign: TextAlign.center,),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  _buildPackageAvailable(bool isAvailable) {
    if (isAvailable) return const SizedBox();
    return Container(
      alignment: Alignment.center,
      child: Container(
        width: 180.w,
        height: 180.w,
        decoration: BoxDecoration(
          color: const Color(0x99333333),
          borderRadius: BorderRadius.circular(90.w),
        ),
        alignment: Alignment.center,
        child: Text(soldOut, style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeightConf.bold),),
      ),
    );
  }


  
  _buildPackageStepSelectPanel2Item(List<PackageCategoryInfo> dataList, bool isAvailable) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPackageStepSelectPanelItem(dataList[0], width: 283.w, height: 269.h,),

            SizedBox(
              width: 145.w,
              child: AssetImageView(fileName: "img_red_add.png", width: 99.w, height: 83.h,),
            ),

            _buildPackageStepSelectPanelItem(dataList[1], width: 283.w, height: 269.h,),
          ],
        ),

        _buildPackageAvailable(isAvailable),
      ],
    );
  }

  _buildPackageStepSelectPanel3Item(List<PackageCategoryInfo> dataList, bool isAvailable) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPackageStepSelectPanelItem(dataList[0], width: 203.w, height: 195.h,),

            SizedBox(
              width: 99.w,
              child: AssetImageView(fileName: "img_red_add.png", width: 99.w, height: 83.h,),
            ),

            _buildPackageStepSelectPanelItem(dataList[1], width: 203.w, height: 195.h,),

            SizedBox(
              width: 99.w,
              child: AssetImageView(fileName: "img_red_add.png", width: 99.w, height: 83.h,),
            ),

            _buildPackageStepSelectPanelItem(dataList[2], width: 203.w, height: 195.h,),
          ],
        ),

        _buildPackageAvailable(isAvailable),
      ],
    );
  }

  _buildPackageStepSelectPanel4Item(List<PackageCategoryInfo> dataList, int startIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPackageStepSelectPanelItem(dataList[startIndex], width: 260.w, height: 115.h,),

        SizedBox(
          width: 168.w,
          child: AssetImageView(fileName: "img_red_add.png", width: 99.w, height: 83.h,),
        ),

        _buildPackageStepSelectPanelItem(dataList[startIndex + 1], width: 260.w, height: 115.h,),
      ],
    );
  }

  _buildPackageStepSelectPanelItem(PackageCategoryInfo item, {required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: const Color(0xFFD3AD78),
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(
              color: Colors.white,
              width: 3.w
          )
      ),
      alignment: Alignment.center,
      child: Text(item.getCategoryName(), style: TextStyle(color: Colors.black, fontSize: 45.sp, fontWeight: FontWeightConf.black), textAlign: TextAlign.center,),
    );
  }

  ///集合型套餐面板
  _buildPackageCollectivePanel(PageDishList item) {
    final dishList = item.packageInfo!.dishList;
    final isNumSelect = item.packageInfo!.minSalesQuantity != null;
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(left: 60.w, right: 60.w, top: 50.h),
          child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 每行的item数量
            childAspectRatio: (335.w/60.h), // 子widget的宽高比例 101/186 186=162 + 12 + 12
            mainAxisSpacing: 8.h, // 主轴方向的间隔
            crossAxisSpacing: 45.w, // 交叉轴方向的间隔
          ), itemCount: dishList.length,
              itemBuilder: (context, index){
                final model = dishList[index];
                return Container(
                  color: const Color(0xFFFBF6E2),
                  alignment: Alignment.center,
                  child: Text(model.getDishName(), style: TextStyle(color: Colors.black, fontSize: 25.sp, fontWeight: FontWeightConf.bold),),
                );
              }),
        ),

        _buildPackageAvailable(item.packageInfo!.available),

        Positioned(
            right: 384.w,
            bottom: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AssetImageView(fileName: "ic_hand_point_right.png", width: 90.w, height: 54.h,),

                Text(CustomLocalizations.text("press_right_button"), style: TextStyle(color: const Color(0xFFF6E7BD), fontSize: 28.sp, fontWeight: FontWeightConf.medium),),
              ],
            )),
        
        Positioned(
            right: 60.w,
            bottom: 32.h,
            child: Column(
              children: [
                Offstage(
                  offstage: !isNumSelect,
                  child: RichText(
                    textAlign: TextAlign.end,
                    text: TextSpan(
                      style: TextStyle(color: const Color(0xFFFFFDFD), fontSize: 30.sp, fontWeight: FontWeightConf.bold), // 默认文本样式
                      children: <TextSpan>[
                        TextSpan(text: taxIncluded),
                        TextSpan(text: '${item.packageInfo!.price.toInt()}', style: TextStyle(color: const Color(0xFFFFFDFD),
                            fontSize: 40.sp, fontWeight: FontWeightConf.bold)),
                        TextSpan(text: "$moneyUnit${CustomLocalizations.text("per_person")}"),
                      ],
                    ),
                  ),
                ),

                TapDownZoomOutView(
                    onClicked: (){
                      controller.onCollectivePackageItemClicked(item.mainCategoryId, item.packageInfo!);
                    },
                    child: Container(
                      width: 317.w,
                      height: 67.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF19149),
                        borderRadius: BorderRadius.circular(13.r),
                        border: Border.all(
                            color: const Color(0xFF00A0E9),
                            width: 2.w
                        ),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(3.w, 3.h),
                              color: const Color(0xFFD9D9D9),
                              blurRadius: 2.r
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(isNumSelect ? CustomLocalizations.text("choice_of_numbers") : CustomLocalizations.text("to_be_order"),
                        style: TextStyle(color: Colors.black, fontSize: 32.sp, fontWeight: FontWeightConf.black),),
                    )),
              ],
            ))
      ],
    );
  }

  _buildBuffetPanel(PageDishList item) {
    final dataList = controller.globalController.buffetCategoryInfoList;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dataList.length,
        itemBuilder: (context, index){
        final model = dataList[index];
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          padding: EdgeInsets.all(5.w),
          color: Colors.white,
          width: 265.w,
          height: 518.h,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 4.h),
                height: 216.h,
                child: ViewUtil.cachedImage(
                  model.imageUrl,
                  fit: BoxFit.fill,
                  radius: 10.r,
                ),
              ),

              SizedBox(height: 10.h,),

              Text(model.getBuffetCategoryName(), style: TextStyle(color: Colors.black,
                  fontSize: 24.sp, fontWeight: FontWeightConf.medium), maxLines: 1,),

              Container(
                margin: EdgeInsets.only(top: 10.h, bottom: 8.h),
                height: 125.h,
                child: SingleChildScrollView(
                  child: Text(model.getBuffetCategoryDescription(), style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeightConf.bold),),
                )),

              Text("${model.showPrice.toInt()}${CustomLocalizations.text("money_unit_taxation")}", style: TextStyle(color: const Color(0xFFFF0303), fontSize: 26.sp, fontWeight: FontWeightConf.bold),),

              TapDownZoomOutView(
                  onClicked: (){
                    controller.onBuffetItemClicked(model);
                  },
                  child: Container(
                    width: 135.w,
                    height: 52.h,
                    margin: EdgeInsets.only(top: 5.h,),
                    decoration: BoxDecoration(
                        color: const Color(0xFF008EF3),
                        borderRadius: BorderRadius.circular(10.r)
                    ),
                    alignment: Alignment.center,
                    child: Text(sure, style: TextStyle(color: Colors.black, fontSize: 28.sp, fontWeight: FontWeightConf.medium),),
                  )),
            ],
          ),
        );
        });
  }

  _buildBuffetRemainingTimeView() {
    return Obx(()=>controller.globalController.buffetTimeStringObs.isNotEmpty ? Container(
      width: 226.w,
      height: 39.h,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(remainingTime, style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeightConf.regular),),
          Container(
            width: 116.w,
            height: 29.h,
            decoration: BoxDecoration(
              color: const Color(0xFF5ACBFF),
              borderRadius: BorderRadius.circular(4.r),
            ),
            alignment: Alignment.center,
            child: Text(controller.globalController.buffetTimeStringObs.value),
          ),
        ],
      ),
      ) : const SizedBox());
  }
}
