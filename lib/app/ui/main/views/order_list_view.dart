

import 'package:auto_size_text/auto_size_text.dart';
import 'package:enjoy_meal/app/base/config/font_weight_conf.dart';
import 'package:enjoy_meal/app/base/utils/view_util.dart';
import 'package:enjoy_meal/app/base/widget/asset_image_view.dart';
import 'package:enjoy_meal/app/data/model/load_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../base/widget/tap_down_zoom_out_view.dart';
import '../../../data/protocol/response/order_detail_resp.dart';
import '../../../local/custom_localizations.dart';
import '../controllers/order_list_controller.dart';
import 'custom_base_view.dart';
// ignore_for_file: must_be_immutable
class OrderListView extends CustomBaseView<OrderListController> {
  late String textMoneyUnit;
  late String textTaxIncluded;
  OrderListView({super.key}){
    textMoneyUnit = CustomLocalizations.text("money_unit");
    textTaxIncluded = CustomLocalizations.text("tax_included");
  }

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
        Container(
          margin: EdgeInsets.fromLTRB(68.w, 45.h, 263.w, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: 80.h,
                margin: EdgeInsets.only(bottom: 14.h),
                child: _buildTopOperateMenuPanel(),),

              _buildTableHeader(),

              _buildProductListPanel(),

              _buildBottomOperateMenuPanel(),
            ],
          ),
        ),

        Positioned(
            top: 166.h,
            right: 166.w,
            child: Column(
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
                SizedBox(height: 269.h,),
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
            )
        ),

        Positioned(
            top: 0,
            right: 0,
            child: buildWaiterCallView()),

        Positioned(
            left: 0,
            bottom: 0,
            child: buildTableNumberView()),

        Positioned(
          top: 78.h,
          right: 0,
          child: buildMenuToolPanel(),)
      ],
    );
  }

  _buildAddSubView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        TapDownZoomOutView(child: AssetImageView(fileName: "ic_subtract.png", width: 39.w, height: 41.w,), onClicked: (){
          controller.onSubtractClicked();
        },),

        Container(
          width: 67.w,
          height: 41.w,
          margin: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/edit_gradient_border_bg.png"),
              fit: BoxFit.fill,
            ),
          ),
          alignment: Alignment.center,
          child: Obx(()=>Text("${controller.selectedNumObs.value}", style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeightConf.medium),)),
        ),

        TapDownZoomOutView(child: AssetImageView(fileName: "ic_add.png", width: 39.w, height: 41.w,), onClicked: (){
          controller.onAddBtnClicked();
        },),
      ],
    );
  }

  _buildTopOperateMenuPanel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TapDownZoomOutView(
            onClicked: controller.onBackToMenuClicked,
            child: Container(
              height: 60.h,
              width: 220.w,
              margin: EdgeInsets.only(right: 54.w),
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color(0xFF008EF3),
                    width: 2.w
                ),
                borderRadius: BorderRadius.circular(10.r),
                color: Colors.white,
              ),
              alignment: Alignment.center,
              child: Text(CustomLocalizations.text("back_to_menu"),
                  style: TextStyle(color: Colors.black, fontSize: 24.sp, fontWeight: FontWeightConf.regular)),
            )),
      ],
    );
  }

  _buildTableHeader() {
    return Container(
      width: 949.w,
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
            width: 88.w,
          ),

          Container(
            width: 102.w,
            alignment: Alignment.center,
            child: Text(CustomLocalizations.text("grid_tax"), style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeightConf.bold)),
          ),

          Container(
            width: 82.w,
            alignment: Alignment.center,
            child: Text(CustomLocalizations.text("quantity_unit"), style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeightConf.bold)),
          ),

          Container(
            width: 131.w,
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
      width: 949.w,
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
                alignment: Alignment.center,
                child: Text(orderDetailBuffet.getBuffetCategoryName(),
                  style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeightConf.bold),)
            ),

            Container(
                width: 318.w,
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
              width: 82.w,
              height: totalHeight,
              margin: EdgeInsets.only(right: 1.w),
              color: const Color(0xFFEBE9E9),
              alignment: Alignment.center,
              child: Text("${orderDetailBuffet.getTotalDinerCount()}", style: TextStyle(color: Colors.black, fontSize: 24.sp, fontWeight: FontWeightConf.medium),),
            ),

            Container(
              width: 131.w,
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

  _buildBuffetAnnotationListItem(OrderBuffetPriceDetail model, double height) {
    return Container(
      height: height,
      padding: EdgeInsets.only(left: 15.w, right: 45.w),
      color: const Color(0xFFEBE9E9),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(model.getDinerTypeName(), style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeightConf.medium),),
          Text("${model.totalDinerCount}${CustomLocalizations.text("people")}", style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeightConf.medium),),
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
                child: AutoSizeText(orderDetailDish.getDishName(), maxLines: 2,
                  style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeightConf.bold),)
            ),

            Container(
              width: 229.w,
              margin: EdgeInsets.symmetric(horizontal: 1.w),
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
              width: 88.w,
              height: totalHeight,
              margin: EdgeInsets.only(right: 1.w),
              decoration: const BoxDecoration(
                  color: Color(0xFFEBE9E9),
                  /*border: Border(
                    left: BorderSide(
                      color: Colors.white,
                      width: 1.w,
                    ),
                  )*/
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
              width: 82.w,
              height: totalHeight,
              margin: EdgeInsets.only(right: 1.w),
              color: const Color(0xFFEBE9E9),
              child: _buildNumberView(orderDetailDish.dishQuantity),
            ),

            Container(
              width: 131.w,
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
    );
  }

  _buildOrderDetailDishItem(OrderDetailDish item) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Text(item.getDishName(), style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeightConf.medium),)),

        Container(
          width: 89.w,
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
              width: 318.w,
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
              width: 82.w,
              height: totalHeight,
              color: const Color(0xFFEBE9E9),
              alignment: Alignment.center,
              child: _buildNumberView(orderDetailPackage.packageQuantity),
            ),

            Container(
              width: 131.w,
              height: totalHeight,
              margin: EdgeInsets.only(right: 1.w),
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
            width: 89.w,
            margin: EdgeInsets.only(left: 13.w,),
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  _buildNumberView(int quantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 67.w,
          alignment: Alignment.center,
          child: Text("$quantity", style: TextStyle(color: Colors.black, fontSize: 28.sp, fontWeight: FontWeightConf.medium),),
        ),
      ],
    );
  }

  _buildLineDividerView() {
    return Container(height: 1.w, color: Colors.white,);
  }

  _buildBottomOperateMenuPanel() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text("￥${controller.orderDetailResp.totalAmount.toInt()}${CustomLocalizations.text("tax_included")}", style: TextStyle(color: Colors.black,
                  fontSize: 35.sp, fontWeight: FontWeightConf.bold), textAlign: TextAlign.left,),

              Row(
                children: [
                  Container(
                    width: 108.w,
                    height: 63.w,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: Colors.black,
                            width: 1.w
                        )
                    ),
                    alignment: Alignment.center,
                    child: Text(CustomLocalizations.text("split"), style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeightConf.bold)),
                  ),
                  Container(
                    width: 194.w,
                    height: 63.w,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: Colors.black,
                            width: 1.w
                        )
                    ),
                    alignment: Alignment.center,
                    child: _buildAddSubView(),
                  ),
                  Container(
                    width: 108.w,
                    height: 63.w,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: Colors.black,
                            width: 1.w
                        )
                    ),
                    alignment: Alignment.center,
                    child: Obx(()=>Text("￥${controller.orderDetailResp.totalAmount~/controller.selectedNumObs.value}", style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeightConf.bold))),
                  ),
                ],
              ),
            ],
          ),

          TapDownZoomOutView(
            onClicked: controller.onCallWaiterClicked,
              child: Container(
            width: 408.w,
            height: 100.w,
            decoration: BoxDecoration(
                color: const Color(0xFFF39800),
                borderRadius: BorderRadius.circular(13.r)
            ),
            alignment: Alignment.center,
            child: Text(CustomLocalizations.text("employee_call"), style: TextStyle(color: Colors.black,
                fontSize: 32.sp, fontWeight: FontWeightConf.bold), textAlign: TextAlign.left,),
          )),
        ],
      ),
    );
  }


}
