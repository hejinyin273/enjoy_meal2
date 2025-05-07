

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../base/config/font_weight_conf.dart';
import '../../../base/utils/view_util.dart';
import '../../../base/widget/asset_image_view.dart';
import '../../../base/widget/tap_down_zoom_out_view.dart';
import '../controllers/dish_detail_controller.dart';
import 'custom_base_view.dart';

class DishDetailView extends CustomBaseView<DishDetailController> {

  DishDetailView({super.key});

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
          margin: EdgeInsets.only(left: 70.w),
          child: _buildDishPanel(),
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
          child: _buildMenuToolPanel(),)
      ],
    );
  }

  _buildDishPanel() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          //color: Colors.amberAccent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 50.h,
                width: 825.w,
                margin: EdgeInsets.only(top: 66.h, bottom: 10.h),
                padding: EdgeInsets.only(left: 44.w),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/img_dish_detail_title_bar.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                alignment: Alignment.centerLeft,
                child: Text("数量・お好み選択", style: TextStyle(color: const Color(0xFF000000), fontSize: 28.sp, fontWeight: FontWeightConf.medium),),
              ),

              Container(
                height: 460.h,
                width: 825.w,
                margin: EdgeInsets.only(bottom: 23.h),
                /*decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/img_dish_detail.png'),
                    fit: BoxFit.fill,
                  ),
                ),*/
                //alignment: Alignment.bottomCenter,
                child: Stack(
                  children: [
                    Container(
                      color: Colors.redAccent,
                      //alignment: Alignment.center,
                      child: controller.selectedDishInfo.detailImageUrl != null ? ViewUtil.cachedImage(
                        controller.selectedDishInfo.detailImageUrl!,
                        fit: BoxFit.contain,
                      ) : const AssetImageView(fileName: "img_dish_detail.png")
                    ),

                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 69.h,
                        color: Colors.white,
                        padding: EdgeInsets.only(left: 33.w, right: 33.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(controller.selectedDishInfo.getDishName(),
                              style: TextStyle(color: const Color(0xFF000000), fontSize: 32.sp, fontWeight: FontWeightConf.medium),),
                            Text("税込850円", style: TextStyle(color: const Color(0xFF000000), fontSize: 32.sp, fontWeight: FontWeightConf.medium),),
                          ],
                        ),
                      )),
                  ],
                ),
              ),

              _buildAddSubView(),
            ],
          ),
        ),

        Container(
          width: 200.w,
          margin: EdgeInsets.only(left: 33.w, top: 126.h),
          padding: EdgeInsets.only(top: 2.h, bottom: 2.5.h, left: 3.w, right: 3.w),
          color: Colors.white,
          child: _buildSpecItem(),
        ),
      ],
    );
  }

  _buildSpecItem() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: controller.selectedDishInfo.dishAttributeCategoryInfos.length,
      itemBuilder: (context, index){
        final item = controller.selectedDishInfo.dishAttributeCategoryInfos[index];
        return Container(
          width: 195.w,
          height: 60.h,
          margin: EdgeInsets.only(top: 2.5.h, bottom: 2.5.h,),
          padding: EdgeInsets.only(left: 10.w, right: 10.w),
          color: const Color(0xFFFFF4C6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.getAttributeCategoryName(), style: TextStyle(color: Colors.black, fontSize: 17.sp, fontWeight: FontWeightConf.regular),),
              Text("+100円", style: TextStyle(color: Colors.black, fontSize: 17.sp, fontWeight: FontWeightConf.regular),),
            ],
          ),
        );
      },
    );
  }

  _buildAddSubView() {
    return SizedBox(
      height: 57.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TapDownZoomOutView(child: Container(
            width: 121.w,
            height: 57.w,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/btn_gradient_border_bg.png'),
                fit: BoxFit.fill,
              ),
            ),
            alignment: Alignment.center,
            child: Text("戻る", style: TextStyle(color: const Color(0xFF000000), fontSize: 28.sp, fontWeight: FontWeightConf.regular),),
          ), onClicked: (){
            controller.onCancelBtnClicked();
          },),

          SizedBox(width: 65.w,),

          TapDownZoomOutView(child: AssetImageView(fileName: "ic_subtract.png", width: 57.w, height: 57.w,), onClicked: (){
            controller.onSubtractClicked();
          },),

          SizedBox(width: 34.w,),

          Obx((){
            return Container(
              width: 121.w,
              height: 57.w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(controller.isConfirmBtnEnableObs.value ? "images/edit_gradient_border_bg.png" : 'images/edit_gradient_border_bg.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: _buildInputNumber(),
            );
          }),

          SizedBox(width: 34.w,),

          TapDownZoomOutView(child: AssetImageView(fileName: "ic_add.png", width: 57.w, height: 57.w,), onClicked: (){
            controller.onAddBtnClicked();
          },),

          SizedBox(width: 65.w,),

          TapDownZoomOutView(child: Container(
            width: 121.w,
            height: 57.w,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/btn_gradient_border_bg.png'),
                fit: BoxFit.fill,
              ),
            ),
            alignment: Alignment.center,
            child: Text("确定", style: TextStyle(color: const Color(0xFF000000), fontSize: 28.sp, fontWeight: FontWeightConf.regular),),
          ), onClicked: (){
            controller.onConfirmBtnClicked();
          },),
        ],
      ),
    );
  }

  _buildInputNumber() {
    return TextField(
      autofocus: false,
      focusNode: controller.numberNode,
      controller: controller.numberController,
      textAlign: TextAlign.center,
      showCursor: false,
      maxLines: 1,
      onChanged: controller.onNumberTextChange,
      inputFormatters: [
        LengthLimitingTextInputFormatter(4),
        FilteringTextInputFormatter.digitsOnly,
      ],
      style: TextStyle(
          fontWeight: FontWeightConf.regular,
          fontSize: 37.sp,
          color: const Color(0xFF333333)
      ),
      decoration: InputDecoration(
          border: const OutlineInputBorder(
            //borderSide: BorderSide(color: Color(0xFF666666)),
            borderSide: BorderSide.none,
          ),
          counterText: '',
          hintText: "0",
          hintStyle: TextStyle(
              fontWeight: FontWeightConf.regular,
              fontSize: 37.sp,
              color: const Color(0xFF333333)
          ),
          contentPadding: const EdgeInsets.all(0)
      ),
      keyboardType: TextInputType.number,
    );
  }


  _buildMenuToolPanel() {
    return Container(
      width: 120.w,
      child: Column(
        children: [

          _buildMenuToolItem(75.h, "TOP", (){

          }),

          _buildMenuToolItem(124.h, "打包", (){

          }),

          _buildMenuToolItem(210.h, "注文履歷\n会計", (){

          }),

          _buildMenuToolItem(210.h, "购物车", (){

          }),

        ],
      ),
    );
  }

  _buildMenuToolItem(double height, String title, Function() onClicked) {
    return TapDownZoomOutView(
      onClicked: onClicked,
      child: Container(
        height: height,
        margin: EdgeInsets.only(top: 4.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(12.w), bottomLeft: Radius.circular(12.w)),
        ),
        alignment: Alignment.center,
        child: Text(title, style: TextStyle(color: Colors.black, fontSize: 25.sp, fontWeight: FontWeightConf.bold), textAlign: TextAlign.center,),
      ),);
  }

}
