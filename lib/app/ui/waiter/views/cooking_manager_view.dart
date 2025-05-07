
import 'package:auto_size_text/auto_size_text.dart';
import 'package:enjoy_meal/app/base/config/font_weight_conf.dart';
import 'package:enjoy_meal/app/base/utils/view_util.dart';
import 'package:enjoy_meal/app/base/widget/tap_down_zoom_out_view.dart';
import 'package:enjoy_meal/app/data/model/load_state.dart';
import 'package:enjoy_meal/app/ui/waiter/views/widget/order_list_widget.dart';
import 'package:enjoy_meal/app/ui/waiter/views/widget/statistics_widget.dart';
import 'package:enjoy_meal/app/ui/waiter/views/widget/store_operation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../base/widget/keep_alive_wrapper.dart';
import '../../../data/protocol/response/table_info_resp.dart';
import '../../../local/custom_localizations.dart';
import '../controllers/cooking_manager_controller.dart';
import '../model/make_info.dart';
import '../model/nav_item_id.dart';
import 'waiter_base_view.dart';

class CookingManagerView extends WaiterBaseView<CookingManagerController> {

  CookingManagerView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  bool canPop() {
    return true;
  }

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
        Container(),

        Obx(()=>Offstage(
          offstage: !(controller.currentNavItemId == NavItemId.waiteToMake
              || controller.currentNavItemId == NavItemId.allMakeInfo ),
          child: Column(
            children: [
              _buildTopActionBar(),
              Expanded(flex: 1,
                child: Container(
                color: (controller.currentNavItemId == NavItemId.allMakeInfo && controller.isOnServedMode.value)
                    ? const Color(0xFFFFDCED) : Colors.transparent,
                padding: EdgeInsets.only(top: 26.w, bottom: 90.w, left: 34.w),
                child: _buildMakeDishPanel(),
              )),
            ],
          ),
        )),

        Obx(()=>Offstage(
          offstage: controller.currentNavItemId != NavItemId.customerCall,
          child: Container(
            alignment: Alignment.center,
            child: Obx((){
              if (LoadState.loading == controller.loadCallRecordStateObs.value) {
                return ViewUtil.buildLoadingView();
              } else if (LoadState.failed == controller.loadCallRecordStateObs.value) {
                return ViewUtil.buildNetErrView((){
                  controller.reqCallRecord();
                });
              } else {
                return _buildCustomerCallListView();
              }
            }),
          ),
        )),

        Obx(()=>Offstage(
          offstage: controller.currentNavItemId != NavItemId.storeOperation,
          child: StoreOperationWidget(),
        )),

        Obx(()=>Offstage(
          offstage: controller.currentNavItemId != NavItemId.statistics,
          child: StatisticsWidget(),
        )),

        Positioned(
          left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: const Color(0xFF490202),
              height: 90.w,
              padding: EdgeInsets.symmetric(vertical: 1.w),
              child: Obx(()=>_buildBottomOperateMenuPanel()),
            )),
      ],
    );
  }

  _buildMakeDishPanel() {
    return Obx((){
      if (controller.isOnTableMode.value) {///坐席番号
        return Obx(()=>controller.isOnOrderListMode.value
            ? OrderListWidget()
            : _buildTableModeView());
      }
      return _buildMakeDishListPageView();
    });
  }

  _buildTopActionBar() {
    return Container(
      height: 65.w,
      color: const Color(0xFF0B10E7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          _buildCurrentTimeView(),

          _buildDishCategoryList(),

          Obx(()=>_buildSpecActionItem(CustomLocalizations.text("menu"), !controller.isOnTableMode.value, (){
            controller.onMenuListModeClicked();
          })),

          Obx(()=>_buildSpecActionItem(CustomLocalizations.text("seat_number"), controller.isOnTableMode.value, (){
            controller.onTableModeClicked();
          })),
        ],
      ),
    );
  }

  _buildCurrentTimeView() {
    return Container(
      width: 120.w,
      alignment: Alignment.center,
      child: Obx(()=>Text(controller.timeStringObs.value, style: TextStyle(color: Colors.white, fontSize: 28.sp, fontWeight: FontWeightConf.medium),)),
    );
  }

  _buildDishCategoryList() {
    return Container(
      width: 812.w,
      height: 63.w,
      color: Colors.white,
      margin: EdgeInsets.only(right: 9.w),
      padding: EdgeInsets.only(top: 3.w, bottom: 2.w),
      child: Obx((){
        final result = controller.updateDishCategoryList;
        return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.dishCategoryList.length,
            itemBuilder: (context, index){
              final model = controller.dishCategoryList[index];
              return TapDownZoomOutView(
                  onClicked: (){
                    controller.onDishCategoryItemClicked(model);
                  },
                  child: Container(
                    width: 116.w,
                    margin: EdgeInsets.only(right: 11.w),
                    color: controller.selectedCategoryIdMap.containsKey(model.id) ? const Color(0xFFFF7E23) : const Color(0xFFF7F0E1),
                    alignment: Alignment.center,
                    child: AutoSizeText(model.getCategoryName(), textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 22.sp, fontWeight: FontWeightConf.bold)),
                  ));
            });
      }),
    );
  }

  _buildSpecActionItem(String title, bool isSelected, Function() onClicked) {
    return TapDownZoomOutView(onClicked: onClicked, child: Container(
      height: 57.w,
      width: 152.w,
      margin: EdgeInsets.only(right: 7.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? Colors.yellow : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(title, style: TextStyle(color: Colors.black, fontSize: 25.sp, fontWeight: FontWeightConf.bold),),
    ));
  }

  _buildCustomerCallListView() {
    return Container(
      margin: EdgeInsets.only(left: 160.w, right: 160.w, top: 85.w, bottom: 90.w),
      child: ListView.builder(
        itemCount: controller.callRecordRespList.length,
        itemBuilder: (context, index){
          final model = controller.callRecordRespList[index];
        return Container(
          height: 73.w,
          margin: EdgeInsets.only(top: 3.w, bottom: 3.w),
          color: Colors.amberAccent,
          child: Row(
            children: [
              Container(
                width: 139.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDFDFD),
                  border: Border.all(
                    color: const Color(0xFF008EF3),
                    width: 2.w
                  )
                ),
                alignment: Alignment.center,
                child: Text(model.tableNumber, style: TextStyle(color: Colors.black, fontSize: 28.sp, fontWeight: FontWeightConf.bold),),
              ),

              Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xFFFDFDFD),
                        border: Border.all(
                            color: const Color(0xFF008EF3),
                            width: 2.w
                        )
                    ),
                    alignment: Alignment.center,
                    child: Text(model.getCallContent(), style: TextStyle(color: Colors.black, fontSize: 28.sp, fontWeight: FontWeightConf.bold),),
                  )),

              TapDownZoomOutView(
                onClicked: (){
                  controller.onConfirmCallClicked(model);
                },
                  child: Container(
                width: 118.w,
                decoration: BoxDecoration(
                    color: const Color(0xFFFDFDFD),
                    border: Border.all(
                        color: const Color(0xFF008EF3),
                        width: 2.w
                    )
                ),
                alignment: Alignment.center,
                child: Text(CustomLocalizations.text("confirm"), style: TextStyle(color: Colors.black, fontSize: 28.sp, fontWeight: FontWeightConf.bold),),
              )),
            ],
          ),
        );
      }),
    );
  }

  _buildTableModeView() {
    return Obx((){
      if (LoadState.loading == controller.loadTableInfoListStateObs.value) {
        return Center(
          child: ViewUtil.buildLoadingView(),
        );
      } else if (LoadState.failed == controller.loadTableInfoListStateObs.value) {
        return Center(
          child: ViewUtil.buildNetErrView((){
            controller.reqTableInfoList();
          }),
        );
      } else {
        return Container(
          padding: EdgeInsets.only(left: 35.w, right: 35.w),
          child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6, // 每行的item数量
            childAspectRatio: (195.w/75.h), // 子widget的宽高比例
            mainAxisSpacing: 35.h, // 主轴方向的间隔
            crossAxisSpacing: 8.w, // 交叉轴方向的间隔
          ), itemCount: controller.tableInfoRespList.length,
              itemBuilder: (context, index){
                final model = controller.tableInfoRespList[index];
                return TapDownZoomOutView(child: _buildTableModeItemView(model), onClicked: (){
                  controller.onTableItemClicked(model);
                });
              }),
        );
      }
    });
  }

  _buildTableModeItemView(TableInfoResp item) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: item.tableStatus == 0 ? const Color(0xFFFFFFFF)
                : (item.firstOrderTime == null ? const Color(0xFFFF0404) : const Color(0xFF797CFE)),
            border: Border.all(
              color: Colors.black,
              width: 1.w
            )
          ),
          alignment: Alignment.center,
          child: Text(item.tableNumber, style: TextStyle(color: Colors.black, fontSize: 40.sp, fontWeight: FontWeightConf.bold)),
        ),

        Positioned(
            top: 2.h,
            left: 8.w,
            child: Text(item.firstOrderTime != null ? controller.getBuffetRemainingTime(item.firstOrderTime!) : "", style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeightConf.regular)),),

        Positioned(
          bottom: 0,
          right: 6.w,
          child: Text(item.firstOrderTime == null ? "" : "${item.dinerCount}人", style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeightConf.regular)),),
      ],
    );
  }

  _buildMakeDishListPageView() {
    return Obx((){
      if (LoadState.loading == controller.loadDishMakeListStateObs.value) {
        return ViewUtil.buildLoadingView();
      } else if (LoadState.failed == controller.loadDishMakeListStateObs.value) {
        return ViewUtil.buildNetErrView((){
          controller.reqFoodMakeList();
        });
      } else {
        controller.isUpdatePageData;
        return PageView.builder(
            scrollDirection: Axis.horizontal,
            reverse: false,
            controller: controller.pageController,
            onPageChanged: (index){
              controller.onPageChanged(index);
            },
            itemCount: controller.pageDataList.length,
            itemBuilder: (BuildContext context, int index){
              return MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                child: KeepAliveWrapper(
                  keepAlive: true,
                  child: _buildPageViewContent(controller.pageDataList[index]),
                ),
                //child: _buildPageViewContent(controller.pageDataList[index]),
              );
            });
      }
    });
  }

  _buildPageViewContent(List<DishMakeDto> dataList) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dataList.length,
      itemBuilder: (context, index){
        return Container(
          width: 233.w,
          padding: EdgeInsets.symmetric(horizontal: 1.w),
          margin: EdgeInsets.symmetric(horizontal: 3.5.w),
          //color: Colors.black,
          child: _buildDishInfoList(dataList[index]),
        );
      }
    );
  }

  _buildDishInfoList(DishMakeDto item) {
    return Column(
      children: [
        _buildDishInfoListHeader(item),

        Expanded(flex:1, child: ListView.builder(
            itemCount: item.dishMakeInfoClassList.length * 2 - 1,
            itemBuilder: (context, index){
              if (index.isOdd) {///奇数
                return _buildLineDividerView();
              }

              final model = item.dishMakeInfoClassList[index~/2];
              if (model is DishMakeInfo) {
                return _buildDishInfoListCommonItem(item, model);
              } else {
                return _buildDishInfoListWrapItem(item, model);
              }
            }
        ))
      ],
    );
  }

  _buildDishInfoListHeader(DishMakeDto item) {
    if (controller.currentNavItemId == NavItemId.waiteToMake) {
      return Container(
          height: 55.w,
          margin: EdgeInsets.symmetric(vertical: 1.w),
          decoration: BoxDecoration(
            color: Colors.white,
              border: Border.all(
                  color: Colors.black,
                  width: 1.w
              )
          ),
          alignment: Alignment.center,
          child: Text(item.tableNumber, style: TextStyle(color: Colors.black, fontSize: 30.sp, fontWeight: FontWeightConf.bold)),
      );
    }
    int minute = item.getOrderWaitMinute();
    int useColorValue = 0xFF60BBFD;
    if (minute >= 10) {
      useColorValue = 0xFFFD0707;
    } else if (minute >= 5) {
      useColorValue = 0xFFFFC76A;
    }
    return Container(
        height: 55.w,
        margin: EdgeInsets.symmetric(vertical: 1.w),
        padding: EdgeInsets.only(left: 14.w),
        color: Color(useColorValue),
        alignment: Alignment.center,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(item.tableNumber, style: TextStyle(color: Colors.black, fontSize: 30.sp, fontWeight: FontWeightConf.bold)),
            ),

            Positioned(
                right: 16.w,
                bottom: 0,
                child: _buildTimeWaitView(item)),
          ],
        )
    );
  }

  _buildDishInfoListWrapItem(DishMakeDto item, List<DishMakeInfo> dataList) {
    return Container(
      height: (55.w + 1.w) * (dataList.length + 1) - 1.w + 6.w,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFF0B10E7),
          width: 3.w
        )
      ),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
          itemCount: (dataList.length + 1 ) * 2 - 1,
          itemBuilder: (context, index) {
            if (index.isOdd) {///奇数
              return _buildLineDividerView();
            }

            final useIndex = index~/2;
            if (useIndex == 0) {
              return _buildDishInfoListPackageItem(item, dataList.first);
            } else {
              return _buildDishInfoListCommonItem(item, dataList[useIndex - 1]);
            }
          }
      ),
    );
  }

  _buildDishInfoListPackageItem(DishMakeDto item, DishMakeInfo model) {
    return Container(
      height: 55.w,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: Colors.black,
              width: 1.w
          )
      ),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 14.w),
            alignment: Alignment.centerLeft,
            child: Text(model.categoryName??"", style: TextStyle(color: Colors.black, fontSize: 15.sp, fontWeight: FontWeightConf.bold)),
          ),
        ],
      ),
    );
  }

  _buildDishInfoListCommonItem(DishMakeDto item, DishMakeInfo model) {
    return TapDownZoomOutView(
        onClicked: (){
          controller.onDishMakeInfoItemClicked(item, model);
        },
        child: Container(
          height: 55.w,
          decoration: BoxDecoration(
            color: _buildDishInfoListCommonItemColor(model.status),
            border: Border.all(
              color: Colors.black,
              width: 1.w
            )
          ),
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(left: 14.w),
                alignment: Alignment.centerLeft,
                child: Text(model.dishSimpleName, style: TextStyle(color: Colors.black, fontSize: 15.sp, fontWeight: FontWeightConf.bold)),
              ),

              Positioned(
                right: 1.w,
                top: 3.w,
                bottom: 3.w,
                child: model.dishAttributes.isNotEmpty ? Container(
                    width: 45.w,
                    color: const Color(0xFFD9D9D9),
                    alignment: Alignment.center,
                    child: Text(model.dishAttributes.first.getAttributeName(), style: TextStyle(color: const Color(0xFFDD0606), fontSize: 16.sp, fontWeight: FontWeightConf.bold))
                ) : const SizedBox(),
              ),

              Positioned(
                right: model.dishAttributes.isNotEmpty ? 46.w : 1.w,
                top: 3.w,
                bottom: 3.w,
                child: model.quantity > 1 ? Container(
                  width: 45.w,
                  color: const Color(0xFFD9D9D9),
                  alignment: Alignment.center,
                  child: Text("×${model.quantity}", style: TextStyle(color: const Color(0xFFDD0606), fontSize: 16.sp, fontWeight: FontWeightConf.bold)),
                ) : const SizedBox(),
              ),
            ],
          ),
        ));
  }

  _buildLineDividerView() {
    return Container(height: 1.w, color: Colors.white,);
  }

  _buildDishInfoListCommonItemColor(int status) {
    if (controller.currentNavItemId == NavItemId.allMakeInfo) {
      if (controller.isOnServedMode.value) {
        return Colors.white;
      } else {
        if (status == DishMakeInfoConf.statusWaitToServe) {
          return const Color(0xFFEBE9E9);
        } else if (status == DishMakeInfoConf.statusServed) {
          return Colors.white;
        }
        return Colors.white;
      }
    }
    return Colors.white;
  }

  _buildTimeWaitView(DishMakeDto item) {
    return Obx((){
      int currentTime = controller.currentTimeObs.value;
      return Text(item.getOrderWaitTime(), style: TextStyle(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeightConf.regular));
    });
  }

  _buildBottomOperateMenuPanel(){
    final markerCountResp = controller.markerCountRespObs.value;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildOperateMenuItem2(CustomLocalizations.text("waite_to_make"), NavItemId.waiteToMake == controller.currentNavItemId, (){
          controller.onNavItemSelected(NavItemId.waiteToMake);
        }, markerCountResp.waitMakeDishCount == 0 ? "" : markerCountResp.waitMakeDishCount.toString()),
        _buildOperateMenuItem(CustomLocalizations.text("page_before"), false, (){
          controller.onPreBtnClicked();
        }),
        _buildOperateMenuItem(CustomLocalizations.text("page_next"), false, (){
          controller.onNextBtnClicked();
        }),
        _buildOperateMenuItem(CustomLocalizations.text("all_make_info"), NavItemId.allMakeInfo == controller.currentNavItemId, (){
          controller.onNavItemSelected(NavItemId.allMakeInfo);
        }, useColor: _allMakeInfoOperateMenuItemColor()),
        _buildOperateMenuItem(CustomLocalizations.text("back"), false, (){
          controller.onBackItemClicked();
        }),
        _buildOperateMenuItem(CustomLocalizations.text("store_operation"), NavItemId.storeOperation == controller.currentNavItemId, (){
          controller.onNavItemSelected(NavItemId.storeOperation);
        }),
        _buildOperateMenuItem(CustomLocalizations.text("statistics"), NavItemId.statistics == controller.currentNavItemId, (){
          controller.onNavItemSelected(NavItemId.statistics);
        }),
        _buildOperateMenuItem2(CustomLocalizations.text("customer_call"), NavItemId.customerCall == controller.currentNavItemId, (){
          controller.onNavItemSelected(NavItemId.customerCall);
        }, markerCountResp.callCount == 0 ? "" : markerCountResp.callCount.toString()),
      ],
    );
  }

  _allMakeInfoOperateMenuItemColor() {
    if (NavItemId.allMakeInfo == controller.currentNavItemId) {
      if (controller.isOnServedMode.value) {
        return const Color(0xFFFFF102);
      }
      return const Color(0xFFD9D9D9);
    }
    return Colors.white;
  }

  _buildOperateMenuItem(String title, bool isSelected, Function() onClicked, {Color? useColor}) {
    return TapDownZoomOutView(
        onClicked: onClicked,
        child: Container(
          width: 156.w,
          color: useColor ?? (isSelected ? const Color(0xFFD9D9D9) : Colors.white),
          alignment: Alignment.center,
          child: Text(title, style: TextStyle(color: Colors.black, fontSize: 26.sp, fontWeight: FontWeightConf.medium),),
        ));
  }

  _buildOperateMenuItem2(String title, bool isSelected, Function() onClicked, String markerCount, {Color? useColor}) {
    return TapDownZoomOutView(
        onClicked: onClicked,
        child: Container(
          width: 156.w,
          color: useColor ?? (isSelected ? const Color(0xFFD9D9D9) : Colors.white),
          child: Stack(
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(title, style: TextStyle(color: Colors.black, fontSize: 26.sp, fontWeight: FontWeightConf.medium),),
              ),

              Positioned(
                top: 0,
                  right: 3.w,
                  child: Text(markerCount, style: TextStyle(color: const Color(0xFFDD0606), fontSize: 15.sp, fontWeight: FontWeightConf.medium),),
              ),
            ],
          ),
        ));
  }

}
