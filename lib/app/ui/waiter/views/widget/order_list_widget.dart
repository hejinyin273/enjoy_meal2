

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../base/config/font_weight_conf.dart';
import '../../../../base/utils/view_util.dart';
import '../../../../base/widget/asset_image_view.dart';
import '../../../../base/widget/tap_down_zoom_out_view.dart';
import '../../../../data/model/load_state.dart';
import '../../../../data/protocol/response/order_detail_resp.dart';
import '../../../../local/custom_localizations.dart';
import '../../controllers/cooking_manager_controller.dart';
// ignore_for_file: must_be_immutable
class OrderListWidget extends StatelessWidget{
  final controller = Get.find<CookingManagerController>();
  late String textMoneyUnit;
  late String textTaxIncluded;
  OrderListWidget({super.key}) {
    textMoneyUnit = CustomLocalizations.text("money_unit");
    textTaxIncluded = CustomLocalizations.text("tax_included");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
        ),
        Container(
          width: 1032.w,
          height: 66.h,
          margin: EdgeInsets.only(left: 60.w),
          padding: EdgeInsets.only(left: 29.w, right: 42.w),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFEFE),
            border: Border.all(
              color: Colors.black,
              width: 2.w
            )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${CustomLocalizations.text("seat")}${controller.selectedTableInfoResp!.tableNumber}", style: TextStyle(color: Colors.black, fontSize: 35.sp, fontWeight: FontWeightConf.bold),),
              Obx(()=>LoadState.success == controller.loadOrderDetailState
                  ? Text("￥${controller.orderDetailResp.totalAmount~/1}${CustomLocalizations.text("tax_included")}", style: TextStyle(color: Colors.black, fontSize: 35.sp, fontWeight: FontWeightConf.bold),)
                  : const SizedBox()),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 60.w, top: 69.h),
          child: _buildTableHeader(),
        ),
        Container(
          margin: EdgeInsets.only(left: 60.w, top: 119.h),
          child: _buildProductListPanel(),
        ),

        Positioned(
          bottom: 14.h,
            child: Obx(()=>Offstage(
              offstage: LoadState.success != controller.loadOrderDetailState,
              child: _buildBottomMenuPanel(),
            ))),

        Positioned(
            top: 61.h,
            right: 72.w,
            child: Obx(()=>Offstage(
              offstage: LoadState.success != controller.loadOrderDetailState,
              child: _buildScrollControllerPanel(),
            )),
        ),
      ],
    );
  }

  _buildScrollControllerPanel() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TapDownZoomOutView(
            onClicked: (){
              controller.listScrollController.animateTo(
                controller.listScrollController.offset - (50.0), // 假设每个item高度为50.0
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: AssetImageView(fileName: "icon_arrow_up.png", width: 61.w, height: 61.w,)),
        Container(
          height: 269.h,
          alignment: Alignment.center,
          child: TapDownZoomOutView(
              onClicked: (){
                controller.onPrinterConfigClicked();
              },
              child: AssetImageView(fileName: "ic_printer.svg", width: 61.w, height: 61.w,)),
        ),
        TapDownZoomOutView(
            onClicked: (){
              controller.listScrollController.animateTo(
                controller.listScrollController.offset + (50.0), // 假设每个item高度为50.0
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: AssetImageView(fileName: "icon_arrow_down.png", width: 61.w, height: 61.w,)),
      ],
    );
  }

  _buildBottomMenuPanel () {
    return Container(
      width: 1032.w,
      height: 75.h,
      margin: EdgeInsets.only(left: 100.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TapDownZoomOutView(
              onClicked: controller.onAddMoreDishItemClicked,
              child: Container(
                width: 210.w,
                height: 75.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                        color: const Color(0xFF008EF3),
                        width: 2.w
                    )
                ),
                child: Text(CustomLocalizations.text("add_more_dish"), style: TextStyle(color: Colors.black, fontSize: 28.sp, fontWeight: FontWeightConf.bold),),
              )),

          TapDownZoomOutView(
              onClicked: controller.onCancelOrderItemClicked,
              child: Container(
                width: 210.w,
                height: 75.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                        color: const Color(0xFF008EF3),
                        width: 2.w
                    )
                ),
                child: Text(CustomLocalizations.text("cancel_order"), style: TextStyle(color: Colors.black, fontSize: 28.sp, fontWeight: FontWeightConf.bold),),
              )),

          TapDownZoomOutView(
              onClicked: controller.onPayBillItemClicked,
              child: Container(
                height: 75.h,
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                        color: const Color(0xFF008EF3),
                        width: 2.w
                    )
                ),
                child: Text(CustomLocalizations.text("accounting_printing"), style: TextStyle(color: Colors.black, fontSize: 28.sp, fontWeight: FontWeightConf.bold),),
              )),
        ],
      ),
    );
  }

  _buildTableHeader() {
    return Container(
      width: 1032.w,
      height: 50.h,
      color: const Color(0xFF6A3906),
      child: Row(
        children: [
          Container(
            width: 312.w,
            alignment: Alignment.center,
            child: Text(CustomLocalizations.text("goods"), style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeightConf.bold)),
          ),

          Container(
            width: 229.w,
            alignment: Alignment.center,
            child: Text(CustomLocalizations.text("comment"), style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeightConf.bold)),
          ),

          Container(
            width: 82.w,
          ),

          Container(
            width: 102.w,
            alignment: Alignment.center,
            child: Text(CustomLocalizations.text("grid_tax"), style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeightConf.bold)),
          ),

          Container(
            width: 176.w,
            alignment: Alignment.center,
            child: Text(CustomLocalizations.text("quantity_unit"), style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeightConf.bold)),
          ),

          Container(
            width: 124.w,
            alignment: Alignment.center,
            child: Text(CustomLocalizations.text("amount_tax"), style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeightConf.bold)),
          ),

        ],
      ),
    );
  }

  _buildProductListPanel() {
    return SizedBox(
        height: 384.h,
        width: 1032.w,
        child: Obx((){
          if (LoadState.loading == controller.loadOrderDetailState) {
            return ViewUtil.buildLoadingView();
          } else if (LoadState.failed == controller.loadOrderDetailState) {
            return ViewUtil.buildNetErrView((){

            });
          } else {
            return CustomScrollView(
              controller: controller.listScrollController,
              slivers: _buildShoppingListView(),
            );
          }
        })
    );
  }

  List<Widget> _buildShoppingListView() {
    List<Widget> widgetList = [];
    for (int i=0; i<controller.orderDetailResp.orderDetailDishes.length; i++) {
      widgetList.add(_buildDishItemView(controller.orderDetailResp.orderDetailDishes[i], i));
    }
    for (int i=0; i<controller.orderDetailResp.orderDetailPackages.length; i++) {
      widgetList.add(_buildPackageItemView(controller.orderDetailResp.orderDetailPackages[i], i));
    }
    for (int i=0; i<controller.orderDetailResp.orderDetailBuffets.length; i++) {
      widgetList.add(_buildBuffetItemViews(controller.orderDetailResp.orderDetailBuffets[i], i));
    }
    return widgetList;
  }

  _buildBuffetItemViews(OrderDetailBuffet orderDetailBuffet, int index) {
    List<dynamic> dataList = [];
    List<OrderBuffetPriceDetail> orderBuffetDataList = orderDetailBuffet.orderBuffetPriceDetails;
    for (int i=0; i<orderBuffetDataList.length; i++) {
      dataList.add(orderBuffetDataList[i]);
      if (orderBuffetDataList[i].extraTimeCount > 0) {
        dataList.add(i);
      }
    }
    double totalHeight = 48.w;
    if (dataList.length > 1) {
      totalHeight = (25.w + 1.w) * dataList.length;
    }

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 1.5.h),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
                    color: const Color(0xFF969292),
                    width: 1.w
                ),
                top: BorderSide(
                    color: const Color(0xFF969292),
                    width: 1.w
                )
            )
        ),
        child: Row(
          children: [
            Container(
                width: 312.w,
                height: totalHeight,
                color: const Color(0xFFEBE9E9),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                alignment: Alignment.centerLeft,
                child: Text(orderDetailBuffet.getBuffetCategoryName(),
                  style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeightConf.bold),)
            ),

            Container(
                width: 311.w,
                margin: EdgeInsets.symmetric(horizontal: 1.w),
                color: const Color(0xFFEBE9E9),
                alignment: Alignment.center,
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: dataList.length * 2 - 1,
                    itemBuilder: (context, index){
                      if (dataList.length == 1) {
                        return _buildBuffetAnnotationListItem(dataList[index], 48.w);
                      } else {
                        if (index.isOdd) {///奇数
                          return _buildLineDividerView();
                        }
                        final item = dataList[index~/2];
                        if (item is OrderBuffetPriceDetail) {
                          return _buildBuffetAnnotationListItem(item, 25.w);
                        } else {
                          return _buildBuffetOvertimeListItem(orderBuffetDataList[item as int], 25.w);
                        }
                      }
                    })
            ),

            Container(
              width: 102.w,
              height: totalHeight,
              margin: EdgeInsets.only(right: 1.w),
              color: const Color(0xFFEBE9E9),
              alignment: Alignment.center,
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dataList.length * 2 - 1,
                  itemBuilder: (context, index){
                    if (dataList.length == 1) {
                      return _buildBuffetPriceListItem(dataList[index], 48.w);
                    } else {
                      if (index.isOdd) {///奇数
                        return _buildLineDividerView();
                      }
                      final item = dataList[index~/2];
                      if (item is OrderBuffetPriceDetail) {
                        return _buildBuffetPriceListItem(item, 25.w);
                      } else {
                        return _buildBuffetOvertimePriceListItem(orderBuffetDataList[item as int], 25.w);
                      }
                    }
                  }),
            ),

            Container(
              width: 176.w,
              height: totalHeight,
              margin: EdgeInsets.only(right: 1.w),
              color: const Color(0xFFEBE9E9),
              alignment: Alignment.center,
              child: Text("${orderDetailBuffet.getTotalDinerCount()}", style: TextStyle(color: Colors.black, fontSize: 24.sp, fontWeight: FontWeightConf.medium),),
            ),

            Container(
              width: 127.w,
              height: totalHeight,
              color: const Color(0xFFEBE9E9),
              alignment: Alignment.center,
              child: RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 10.sp, fontWeight: FontWeightConf.medium), // 默认文本样式
                  children: <TextSpan>[
                    TextSpan(text: textTaxIncluded),
                    TextSpan(text: "${orderDetailBuffet.getItemTotalPrice().toInt()}", style: TextStyle(color: Colors.black,
                        fontSize: 20.sp, fontWeight: FontWeightConf.bold)),
                    TextSpan(text: textMoneyUnit),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildBuffetPriceListItem(OrderBuffetPriceDetail orderBuffetPriceDetail, double height) {
    return Container(
      height: height,
      color: const Color(0xFFEBE9E9),
      alignment: Alignment.center,
      child: Text("${orderBuffetPriceDetail.unitPrice.toInt()}$textMoneyUnit",
        style: TextStyle(color: Colors.black, fontSize: 15.sp, fontWeight: FontWeightConf.medium),),
    );
  }

  _buildBuffetOvertimePriceListItem(OrderBuffetPriceDetail orderBuffetPriceDetail, double height) {
    return Container(
      height: height,
      color: const Color(0xFFEBE9E9),
      alignment: Alignment.center,
      child: Text("${orderBuffetPriceDetail.overtimeExtraFee.toInt()}$textMoneyUnit",
        style: TextStyle(color: Colors.black, fontSize: 15.sp, fontWeight: FontWeightConf.medium),),
    );
  }

  _buildBuffetAnnotationListItem(OrderBuffetPriceDetail orderBuffetPriceDetail, double height) {
    return Container(
      height: height,
      padding: EdgeInsets.only(left: 15.w, right: 45.w),
      color: const Color(0xFFEBE9E9),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(orderBuffetPriceDetail.getDinerTypeName(), style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeightConf.medium),),
          Text("${orderBuffetPriceDetail.totalDinerCount}${CustomLocalizations.text("people")}", style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeightConf.medium),),
        ],
      ),
    );
  }

  _buildBuffetOvertimeListItem(OrderBuffetPriceDetail model, double height) {
    return Container(
      height: height,
      padding: EdgeInsets.only(left: 15.w, right: 45.w),
      color: const Color(0xFFEBE9E9),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("加时", style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeightConf.medium),),
          Text("${model.extraTimeCount}小时", style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeightConf.medium),),
        ],
      ),
    );
  }

  _buildDishItemView(OrderDetailDish orderDetailDish, int index) {
    double totalHeight = 50.w;
    double dishAttributeHeight = 50.w;
    int itemCount = 1;

    if (orderDetailDish.dishAttrs.length > 1) {
      dishAttributeHeight = 25.w;
      itemCount = orderDetailDish.dishAttrs.length * 2 -1;
      totalHeight = (dishAttributeHeight + 1.w) * orderDetailDish.dishAttrs.length;
    }

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 1.5.h),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
                    color: const Color(0xFF969292),
                    width: 1.h
                ),
                top: BorderSide(
                    color: const Color(0xFF969292),
                    width: 1.h
                )
            )
        ),
        child: Row(
          children: [
            Container(
                width: 312.w,
                height: totalHeight,
                color: const Color(0xFFEBE9E9),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                alignment: Alignment.centerLeft,
                child: AutoSizeText(orderDetailDish.getDishName(), maxLines: 2,
                  style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeightConf.bold),)
            ),

            Container(
                width: 229.w,
                margin: EdgeInsets.only(left: 1.w),
                color: const Color(0xFFEBE9E9),
                alignment: Alignment.center,
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: itemCount,
                    itemBuilder: (context, index){
                      if (itemCount == 1) {
                        if (orderDetailDish.dishAttrs.isNotEmpty) {
                          return _buildDishAnnotationListItem(orderDetailDish.dishAttrs[0], dishAttributeHeight, fontSize: 16.sp);
                        } else {
                          return _buildDishAnnotationListItem(null, dishAttributeHeight);
                        }
                      } else {
                        if (index.isOdd) {///奇数
                          return _buildLineDividerView();
                        }
                        return _buildDishAnnotationListItem(orderDetailDish.dishAttrs[index~/2], dishAttributeHeight);
                      }
                    })
            ),

            Container(
              width: 82.w,
              height: totalHeight,
              margin: EdgeInsets.only(right: 1.w),
              decoration: BoxDecoration(
                  color: const Color(0xFFEBE9E9),
                  border: Border(
                    left: BorderSide(
                      color: Colors.white,
                      width: 1.w,
                    ),
                  )
              ),
              alignment: Alignment.center,
              child: Text(orderDetailDish.getStatusDesc(), style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeightConf.medium),),
            ),

            Container(
              width: 102.w,
              height: totalHeight,
              margin: EdgeInsets.only(right: 1.w),
              color: const Color(0xFFEBE9E9),
              alignment: Alignment.center,
              child: Text("${orderDetailDish.unitPrice.toInt()}$textMoneyUnit",
                style: TextStyle(color: Colors.black, fontSize: 18.sp, fontWeight: FontWeightConf.bold),),
            ),

            Container(
              width: 176.w,
              height: totalHeight,
              margin: EdgeInsets.only(right: 1.w),
              color: const Color(0xFFEBE9E9),
              child: _buildNumberView(orderDetailDish, orderDetailDish.dishQuantity),
            ),

            Container(
              width: 127.w,
              height: totalHeight,
              color: const Color(0xFFEBE9E9),
              alignment: Alignment.center,
              child: RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 10.sp, fontWeight: FontWeightConf.medium), // 默认文本样式
                  children: <TextSpan>[
                    TextSpan(text: textTaxIncluded),
                    TextSpan(text: "${orderDetailDish.getTotalPrice().toInt()}", style: TextStyle(color: Colors.black,
                        fontSize: 20.sp, fontWeight: FontWeightConf.bold)),
                    TextSpan(text: textMoneyUnit),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildDishAnnotationListItem(DishAttr? dishAttr, double height, {double? fontSize}) {
    return Container(
      height: height,
      padding: EdgeInsets.only(left: 13.w, right: 13.w),
      color: const Color(0xFFEBE9E9),
      alignment: Alignment.centerLeft,
      child: dishAttr == null ? const SizedBox() : Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(dishAttr.getAttributeName(),
            style: TextStyle(color: Colors.black, fontSize: fontSize??12.sp, fontWeight: FontWeightConf.medium),),
          Text(dishAttr.attributeUnitPrice.toInt() == 0 ? "" : "+${dishAttr.attributeUnitPrice.toInt()}",
            style: TextStyle(color: Colors.black, fontSize: fontSize??12.sp, fontWeight: FontWeightConf.medium),),
        ],
      ),
      //child: Text(dishAttr == null ? "" : dishAttr.getAttributeName(), style: TextStyle(color: Colors.black, fontSize: fontSize??12.sp, fontWeight: FontWeightConf.medium),),
    );
  }

  _buildOrderDetailDishItem(OrderDetailDish item) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Text(item.getDishName(), style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeightConf.medium),)),

        Container(
          width: 82.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(
                    color: Colors.white,
                    width: 1.w,
                  )
              )
          ),
          child: Text(item.getStatusDesc(), style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeightConf.medium),),
        )
      ],
    );
  }

  _buildPackageItemView(OrderDetailPackage orderDetailPackage, int index) {
    List<dynamic> dataList = [];
    double totalHeight = 0;
    for (var orderDetailDish in orderDetailPackage.orderDetailDishes) {
      dataList.add(orderDetailDish);
      totalHeight += 25.w;
      dataList.addAll(orderDetailDish.dishAttrs);
      totalHeight += 25.w * orderDetailDish.dishAttrs.length;
    }

    totalHeight += 1.w * (dataList.length - 1);

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 1.5.h),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
                    color: const Color(0xFF969292),
                    width: 1.w
                ),
                top: BorderSide(
                    color: const Color(0xFF969292),
                    width: 1.w
                )
            )
        ),
        child: Row(
          children: [
            Container(
              width: 312.w,
              height: totalHeight,
              color: const Color(0xFFEBE9E9),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              alignment: Alignment.centerLeft,
              child: AutoSizeText(orderDetailPackage.getPackageName(), textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeightConf.bold),
                maxLines: 2, overflow: TextOverflow.ellipsis,),
            ),

            Container(
              width: 311.w,
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              color: const Color(0xFFEBE9E9),
              alignment: Alignment.center,
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dataList.length * 2 - 1,
                  itemBuilder: (context, index){
                    if (index.isOdd) {///奇数
                      return _buildLineDividerView();
                    }
                    return _buildPackageAnnotationListItem(dataList[index~/2]);
                  }),
            ),

            Container(
              width: 102.w,
              height: totalHeight,
              margin: EdgeInsets.only(right: 1.w),
              color: const Color(0xFFEBE9E9),
              alignment: Alignment.center,
              child: Text("${orderDetailPackage.unitPrice.toInt()}$textMoneyUnit",
                style: TextStyle(color: Colors.black, fontSize: 18.sp, fontWeight: FontWeightConf.bold),),
            ),

            Container(
              width: 176.w,
              height: totalHeight,
              margin: EdgeInsets.only(right: 1.w),
              color: const Color(0xFFEBE9E9),
              alignment: Alignment.center,
              child: _buildNumberView(orderDetailPackage, orderDetailPackage.packageQuantity),
            ),

            Container(
              width: 127.w,
              height: totalHeight,
              color: const Color(0xFFEBE9E9),
              alignment: Alignment.center,
              child: RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 10.sp, fontWeight: FontWeightConf.medium), // 默认文本样式
                  children: <TextSpan>[
                    TextSpan(text: textTaxIncluded),
                    TextSpan(text: "${orderDetailPackage.getTotalPrice().toInt()}", style: TextStyle(color: Colors.black,
                        fontSize: 20.sp, fontWeight: FontWeightConf.bold)),
                    TextSpan(text: textMoneyUnit),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildPackageAnnotationListItem(dynamic annotation) {
    if (annotation is OrderDetailPackage) {
      return Container(
        height: 48.w,
        padding: EdgeInsets.only(left: 13.w),
        color: const Color(0xFFEBE9E9),
        alignment: Alignment.centerLeft,
        child: Text(annotation.getPackageName(), style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeightConf.medium),),
      );
    } else if (annotation is OrderDetailDish) {
      return Container(
        height: 25.w,
        padding: EdgeInsets.only(left: 13.w),
        color: const Color(0xFFEBE9E9),
        alignment: Alignment.centerLeft,
        child: _buildOrderDetailDishItem(annotation),
      );
    }
    final dishAttributeInfo = annotation as DishAttr;
    return Container(
      height: 25.w,
      padding: EdgeInsets.only(left: 13.w),
      color: const Color(0xFFEBE9E9),
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(dishAttributeInfo.getAttributeName(), style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeightConf.medium),),

          const Expanded(flex: 1, child: SizedBox()),

          Text(dishAttributeInfo.attributeUnitPrice.toInt() == 0 ? "" : "+${dishAttributeInfo.attributeUnitPrice.toInt()}",
            style: TextStyle(color:  Colors.black, fontSize: 12.sp, fontWeight: FontWeightConf.medium),),

          Container(
            width: 82.w,
            margin: EdgeInsets.only(left: 13.w,),
            color: Colors.white,
          ),
        ],
      ),
      //child: Text(dishAttributeInfo.getAttributeName(), style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeightConf.medium),),
    );
  }

  _buildNumberView(dynamic model, int quantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 3.w,),

        TapDownZoomOutView(child: AssetImageView(fileName: "ic_subtract.png", width: 39.w, height: 41.h,), onClicked: (){
          controller.onSubtractClicked(model);
        },),

        SizedBox(width: 8.5.w,),

        Container(
          width: 67.w,
          alignment: Alignment.center,
          child: Text("$quantity", style: TextStyle(color: Colors.black, fontSize: 30.sp, fontWeight: FontWeightConf.medium),),
        ),

        SizedBox(width: 8.5.w,),

        TapDownZoomOutView(child: AssetImageView(fileName: "ic_add.png", width: 39.w, height: 41.h,), onClicked: (){
          controller.onAddBtnClicked(model);
        },),

        SizedBox(width: 3.w,),
      ],
    );
  }

  _buildLineDividerView() {
    return Container(height: 1.w, color: Colors.white,);
  }

}