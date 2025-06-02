

import 'package:auto_size_text/auto_size_text.dart';
import 'package:enjoy_meal/app/base/config/font_weight_conf.dart';
import 'package:enjoy_meal/app/base/widget/asset_image_view.dart';
import 'package:enjoy_meal/app/data/model/restaurant_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../base/widget/tap_down_zoom_out_view.dart';
import '../../../data/model/goods_model.dart';
import '../../../local/custom_localizations.dart';
import '../controllers/shopping_cart_controller.dart';
import 'custom_base_view.dart';
// ignore_for_file: must_be_immutable
class ShoppingCartView extends CustomBaseView<ShoppingCartController> {
  late String textMoneyUnit;
  late String textTaxIncluded;
  late String soldOut;
  ShoppingCartView({super.key}) {
    textMoneyUnit = CustomLocalizations.text("money_unit");
    textTaxIncluded = CustomLocalizations.text("tax_included");
    soldOut = CustomLocalizations.text("sold_out");
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

              Container(
                margin: EdgeInsets.only(top: 8.h, bottom: 17.h),
                //child: Text("22時以降の注文で、深夜料金を10%加算します。", style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeightConf.bold)),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AssetImageView(fileName: "ic_hand_point_right.png", width: 90.w, height: 54.h,),

                      Text(CustomLocalizations.text("press_right_button"), style: TextStyle(color: Colors.black, fontSize: 28.sp, fontWeight: FontWeightConf.medium),),
                    ],
                  ),

                  _buildOrderConfirmBtn(),
                ],
              )
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
                        controller.listScrollController.offset - (50.0),
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: AssetImageView(fileName: "icon_arrow_up.png", width: 61.w, height: 61.w,)),
                SizedBox(height: 269.h,),
                TapDownZoomOutView(
                    onClicked: (){
                      controller.listScrollController.animateTo(
                        controller.listScrollController.offset + (50.0),
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

  _buildTopOperateMenuPanel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
        
        Text(CustomLocalizations.text("shopping_cart_tip_order"),
          style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeightConf.regular), textAlign: TextAlign.center,),

        TapDownZoomOutView(
            onClicked: controller.onClearCartClicked,
            child: Container(
              height: 60.h,
              width: 220.w,
              margin: EdgeInsets.only(left: 54.w),
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color(0xFF008EF3),
                    width: 2.w
                ),
                borderRadius: BorderRadius.circular(10.r),
                color: Colors.white,
              ),
              alignment: Alignment.center,
              child: Text(CustomLocalizations.text("empty_orders"),
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
            width: 102.w,
            alignment: Alignment.center,
            child: Text(CustomLocalizations.text("grid_tax"),style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeightConf.bold)),
          ),

          Container(
            width: 176.w,
            alignment: Alignment.center,
            child: Text(CustomLocalizations.text("quantity_unit"),style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeightConf.bold)),
          ),

          Container(
            width: 124.w,
            alignment: Alignment.center,
            child: AutoSizeText(CustomLocalizations.text("amount_tax"),style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeightConf.bold)),
          ),
        ],
      ),
    );
  }

  _buildProductListPanel() {
    return SizedBox(
      height: 384.h,
      width: 949.w,
      child: Obx(()=> controller.shoppingCartListUpdate ? CustomScrollView(
        controller: controller.listScrollController,
        slivers: _buildShoppingListView(),
      ): Container()),
    );
  }

  List<Widget> _buildShoppingListView() {
    List<Widget> widgetList = [];
    final dataList =  controller.globalController.getShoppingCartShowingList();
    for (int i=0; i<dataList.length; i++) {
      final item = dataList[i];///DishOrderModel or PackageOrderModel
      if (item is DishOrderModel) {
        widgetList.add(_buildDishItemView(item, i));
      } else if (item is PackageOrderModel) {
        widgetList.add(_buildPackageItemView(item, i));
      }
    }

    return widgetList;
  }

  ///DishOrderModel
  _buildDishItemView(DishOrderModel dishOrderModel, int index) {
    double totalHeight = 50.w;
    double dishAttributeHeight = 50.w;
    int itemCount = 1;

    if (dishOrderModel.dishAttributeInfoList.length > 1) {
      dishAttributeHeight = 25.w;
      itemCount = dishOrderModel.dishAttributeInfoList.length * 2 -1;
      totalHeight = (dishAttributeHeight + 1.w) * dishOrderModel.dishAttributeInfoList.length;
    }

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 1.5.h),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: const Color(0xFF969292),
                width: 1.w
            )
        ),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    width: 312.w,
                    height: totalHeight,
                    color: const Color(0xFFEBE9E9),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    alignment: Alignment.centerLeft,
                    child: AutoSizeText(dishOrderModel.dishInfo.getDishName(), maxLines: 2, textAlign: TextAlign.start,
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
                            if (dishOrderModel.dishAttributeInfoList.isNotEmpty) {
                              return _buildDishAnnotationListItem(dishOrderModel.dishAttributeInfoList[0], dishAttributeHeight, fontSize: 16.sp);
                            } else {
                              return _buildDishAnnotationListItem(null, dishAttributeHeight);
                            }
                          } else {
                            if (index.isOdd) {///奇数
                              return _buildLineDividerView();
                            }
                            return _buildDishAnnotationListItem(dishOrderModel.dishAttributeInfoList[index~/2], dishAttributeHeight);
                          }
                        })
                ),

                Container(
                  width: 102.w,
                  height: totalHeight,
                  margin: EdgeInsets.only(right: 1.w),
                  color: const Color(0xFFEBE9E9),
                  alignment: Alignment.center,

                  child: Text("${controller.globalController.isOnBuffetMode ? 0 : dishOrderModel.dishInfo.price.toInt()}$textMoneyUnit",
                    style: TextStyle(color: Colors.black, fontSize: 18.sp, fontWeight: FontWeightConf.medium),),
                ),

                Container(
                  width: 176.w,
                  height: totalHeight,
                  margin: EdgeInsets.only(right: 1.w),
                  color: const Color(0xFFEBE9E9),
                  alignment: Alignment.center,
                  child: dishOrderModel.dishInfo.available
                      ? _buildAddSubView(dishOrderModel, dishOrderModel.quantity, 0)
                      : AutoSizeText(soldOut, maxLines: 1,
                    style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeightConf.bold),),
                ),

                Container(
                  width: 124.w,
                  height: totalHeight,
                  color: const Color(0xFFEBE9E9),
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 10.sp, fontWeight: FontWeightConf.medium), // 默认文本样式
                      children: <TextSpan>[
                        TextSpan(text: textTaxIncluded),
                        TextSpan(text: "${controller.globalController.isOnBuffetMode ? 0 : dishOrderModel.getTotalPrice().toInt()}", style: TextStyle(color: Colors.black,
                            fontSize: 20.sp, fontWeight: FontWeightConf.bold)),
                        TextSpan(text: textMoneyUnit),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            IgnorePointer(
              child: Container(
                height: totalHeight,
                color: dishOrderModel.dishInfo.available ? Colors.transparent : const Color(0x99333333),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildDishAnnotationListItem(DishAttributeInfo? dishAttributeInfo, double height, {double? fontSize}) {
    return Container(
      height: height,
      padding: EdgeInsets.only(left: 13.w, right: 13.w),
      color: const Color(0xFFEBE9E9),
      alignment: Alignment.centerLeft,
      child: dishAttributeInfo == null ? const SizedBox() : Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(dishAttributeInfo.getAttributeName(),
            style: TextStyle(color: Colors.black, fontSize: fontSize??12.sp, fontWeight: FontWeightConf.medium),),
          Text(dishAttributeInfo.priceAdjustment.toInt() == 0 ? "" : "+${dishAttributeInfo.priceAdjustment.toInt()}",
            style: TextStyle(color: Colors.black, fontSize: fontSize??12.sp, fontWeight: FontWeightConf.medium),),
        ],
      ),
    );
  }


  ///PackageOrderModel
  _buildPackageItemView(PackageOrderModel packageOrderModel, int index) {
    List<dynamic> dataList = [];
    double totalHeight = 0;

    if (packageOrderModel.packageInfo.packageType == RestaurantConf.packageTypeStepSelect) {
      for (var dishOrderModel in packageOrderModel.dishOrderModelList) {
        dataList.add(dishOrderModel.dishInfo);
        totalHeight += 25.w;
        dataList.addAll(dishOrderModel.dishAttributeInfoList);
        totalHeight += 25.w * dishOrderModel.dishAttributeInfoList.length;
      }
    } else if (packageOrderModel.packageInfo.packageType == RestaurantConf.packageTypeCollective){
      for (var dishInfo in packageOrderModel.packageInfo.dishList) {
        dataList.add(dishInfo);
        totalHeight += 25.w;
      }
    }

    totalHeight += 1.w * (dataList.length - 1);

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 1.5.h),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: const Color(0xFF969292),
                width: 1.w
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
              child: AutoSizeText(packageOrderModel.packageInfo.getPackageName(), textAlign: TextAlign.start,
                style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeightConf.bold),
                maxLines: 2, overflow: TextOverflow.ellipsis,),
            ),

            Container(
              width: 229.w,
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
              child: Text("${controller.globalController.isOnBuffetMode ? 0 : packageOrderModel.packageInfo.price.toInt()}$textMoneyUnit",
                style: TextStyle(color: Colors.black, fontSize: 18.sp, fontWeight: FontWeightConf.medium),)
            ),

            Container(
              width: 176.w,
              height: totalHeight,
              margin: EdgeInsets.only(right: 1.w),
              color: const Color(0xFFEBE9E9),
              alignment: Alignment.center,
              child: packageOrderModel.packageInfo.available
                  ? _buildAddSubView(packageOrderModel, packageOrderModel.quantity, 0)
                  : AutoSizeText(soldOut, maxLines: 1,
                style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeightConf.bold),)
            ),

            Container(
                width: 124.w,
                height: totalHeight,
                color: const Color(0xFFEBE9E9),
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 10.sp, fontWeight: FontWeightConf.medium), // 默认文本样式
                    children: <TextSpan>[
                      TextSpan(text: textTaxIncluded),
                      TextSpan(text: "${controller.globalController.isOnBuffetMode ? 0 : packageOrderModel.getTotalPrice().toInt()}$textMoneyUnit", style: TextStyle(color: Colors.black,
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
    if (annotation is PackageInfo) {
      return Container(
        height: 48.w,
        padding: EdgeInsets.only(left: 13.w),
        color: const Color(0xFFEBE9E9),
        alignment: Alignment.centerLeft,
        child: Text(annotation.getPackageName(), style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeightConf.medium),),
      );
    } else if (annotation is DishInfo) {
      return Container(
        height: 25.w,
        padding: EdgeInsets.only(left: 13.w),
        color: const Color(0xFFEBE9E9),
        alignment: Alignment.centerLeft,
        child: Text(annotation.getDishName(), style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeightConf.medium),),
      );
    }
    final dishAttributeInfo = annotation as DishAttributeInfo;
    return Container(
      height: 25.w,
      padding: EdgeInsets.only(left: 13.w, right: 13.w),
      color: const Color(0xFFEBE9E9),
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(dishAttributeInfo.getAttributeName(), style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeightConf.medium),),

          Text(dishAttributeInfo.priceAdjustment.toInt() == 0 ? "" : "+${dishAttributeInfo.priceAdjustment.toInt()}",
            style: TextStyle(color:  Colors.black, fontSize: 12.sp, fontWeight: FontWeightConf.medium),),
        ],
      ),
    );
  }

  _buildLineDividerView() {
    return Container(height: 1.w, color: Colors.white,);
  }

  _buildAddSubView(dynamic model, int quantity, int index) {
    bool isShowSubBtn = true;
    if (model is PackageOrderModel) {
      if (model.packageInfo.minSalesQuantity != null) {
        if (quantity <= model.packageInfo.minSalesQuantity!) {
          isShowSubBtn = false;
        }
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        isShowSubBtn ?
        TapDownZoomOutView(child: AssetImageView(fileName: "ic_subtract.png", width: 39.w, height: 41.h,), onClicked: (){
          controller.onSubtractClicked(model, index);
        },) : SizedBox(width: 39.w, height: 41.h,),

        SizedBox(width: 11.5.w,),

        Container(
          width: 67.w,
          height: 41.h,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/edit_gradient_border_bg.png"),
              fit: BoxFit.fill,
            ),
          ),
          alignment: Alignment.center,
          child: Text("$quantity", style: TextStyle(color: Colors.black, fontSize: 28.sp, fontWeight: FontWeightConf.medium),),
        ),

        SizedBox(width: 11.5.w,),

        TapDownZoomOutView(child: AssetImageView(fileName: "ic_add.png", width: 39.w, height: 41.h,), onClicked: (){
          controller.onAddBtnClicked(model, index);
        },),
      ],
    );
  }

  _buildOrderConfirmBtn() {
    return TapDownZoomOutView(
        onClicked: controller.onOrderConfirmClicked,
        child: Container(
          width: 408.w,
          height: 100.w,
          padding: EdgeInsets.symmetric(horizontal: 21.w),
          decoration: BoxDecoration(
              color: const Color(0xFFF39800),
              borderRadius: BorderRadius.circular(13.r)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Obx((){
                final update = controller.shoppingCartListUpdate;
                return Text("￥${controller.globalController.isOnBuffetMode ? 0 : controller.getTotalPrice()}(${CustomLocalizations.text("included_tax")}）", style: TextStyle(color: Colors.black, fontSize: 28.sp, fontWeight: FontWeightConf.bold), textAlign: TextAlign.left,);
              }),
              Text(CustomLocalizations.text("make_order"), style: TextStyle(color: Colors.black, fontSize: 28.sp, fontWeight: FontWeightConf.bold), textAlign: TextAlign.right,),
            ],
          ),
        ));
  }
}
