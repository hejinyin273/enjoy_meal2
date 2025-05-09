
import 'package:enjoy_meal/app/base/config/font_weight_conf.dart';
import 'package:enjoy_meal/app/data/model/restaurant_data.dart';
import 'package:enjoy_meal/app/local/custom_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../base/widget/tap_down_zoom_out_view.dart';
import 'controller/dish_detail_dialog_controller.dart';

// ignore_for_file: must_be_immutable
class SelectType2Dialog extends StatelessWidget{

  late DishInfo dishInfo;
  late int selectedDishAttrCategoryIndex;
  late DishAttributeCategoryInfo selectedDishAttributeCategoryInfo;

  Function() onCancel;
  Function() onConfirm;
  final controller = Get.put(DishDetailDialogController());

  SelectType2Dialog({super.key, required this.dishInfo, required this.selectedDishAttrCategoryIndex, required this.onCancel, required this.onConfirm}){
    controller.selectedNumObs(1);
    selectedDishAttributeCategoryInfo = dishInfo.dishAttributeCategoryInfos[selectedDishAttrCategoryIndex];
    if (selectedDishAttrCategoryIndex == 0) {
      controller.selectedAttributeInfoMap.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center,
      children: [

        Obx(()=>controller.selectedAttributeUpdateObs.value ? _buildContentView(context) : _buildContentView(context)),
      ],
    );
  }

  _buildContentView(BuildContext context) {
    return SizedBox(
      width: 699.w,
      height: 516.w,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7E7),
            borderRadius: BorderRadius.circular(25.r),
            border: Border.all(
                color: const Color(0xFF008EF3),
                width: 1.w
            ),
          ),
          padding: EdgeInsets.only(top:21.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              _buildSelectTypePanel(),

              _buildBtnPanel(),
            ],
          ),
        ),
      ),
    );
  }

  _buildSelectTypePanel() {
    return Container(
      width: 647.w,
      height: 348.w,
      color: const Color(0xFFEDDA8E),
      padding: EdgeInsets.only(left: 11.w, right: 11.w, top: 31.w),
      child: _buildGridPanel(),
    );
  }

  _buildGridPanel() {
    return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, // 每行的item数量
      childAspectRatio: (304/125), // 子widget的宽高比例
      mainAxisSpacing: 18.w, // 主轴方向的间隔
      crossAxisSpacing: 29.w, // 交叉轴方向的间隔
    ), itemCount: 4,
        itemBuilder: (context, index){
          if (index <= selectedDishAttributeCategoryInfo.dishAttributeInfos.length -1) {
            final model = selectedDishAttributeCategoryInfo.dishAttributeInfos[index];
            return TapDownZoomOutView(child: _buildGridItem(model), onClicked: (){
              controller.onDishAttributeItemClicked(selectedDishAttributeCategoryInfo, model);
            });
          } else {
            return _buildGridNullItem();
          }
        });
  }

  _buildGridItem(DishAttributeInfo item) {
    return Container(
      decoration: BoxDecoration(
        color: controller.isAttributeIdSelected(selectedDishAttributeCategoryInfo.id, item.id) ? const Color(0xFF01ABFC) : const Color(0xFFF19149),
        borderRadius: BorderRadius.circular(10.w),
        border: Border.all(
          color: const Color(0xFF01ABFC),
          width: 2.w,
        )
      ),
      alignment: Alignment.center,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(color: const Color(0xFF000000),
              fontSize: 30.sp, fontWeight: FontWeightConf.bold), // 默认文本样式
          children: <TextSpan>[
            const TextSpan(text: '＋'),
            TextSpan(text: '${item.priceAdjustment.toInt()}', style: TextStyle(color: const Color(0xFFFF0303),
                fontSize: 30.sp, fontWeight: FontWeightConf.bold)),
            TextSpan(text: CustomLocalizations.text("money_unit")),
            TextSpan(text: '\n${item.getAttributeName()}'),
          ],
        ),
      ),
    );
  }

  _buildGridNullItem() {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFF19149),
          borderRadius: BorderRadius.circular(10.w),
          border: Border.all(
            color: const Color(0xFF01ABFC),
            width: 2.w,
          )
      ),
    );
  }

  _buildCancelBtn() {
    return TapDownZoomOutView(child: Container(
      width: 160.w,
      height: 77.w,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/img_orange_btn_bg.png'),
          fit: BoxFit.fill,
        ),
      ),
      alignment: Alignment.center,
      child: Text(CustomLocalizations.text("back"), style: TextStyle(color: const Color(0xFF000000), fontSize: 30.sp, fontWeight: FontWeightConf.black),),
    ), onClicked: (){
      controller.selectedAttributeInfoMap.remove(selectedDishAttributeCategoryInfo.id);
      onCancel();
    },);
  }

  _buildBtnPanel() {
    if (selectedDishAttributeCategoryInfo.isRequired == RestaurantConf.requireTypeMust) {
      return _buildBtnRequirePanel();
    }

    final isEmpty = !controller.isExistCategoryDishAttribute(selectedDishAttributeCategoryInfo.id);
    return Container(
      margin: EdgeInsets.only(bottom: 17.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCancelBtn(),

          SizedBox(width: 33.w,),

          TapDownZoomOutView(child: Opacity(
            opacity: isEmpty ? 1.0 : 0.4,
            child: Container(
              width: 222.w,
              height: 77.w,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/img_orange_btn_bg.png'),
                  fit: BoxFit.fill,
                ),
              ),
              alignment: Alignment.center,
              child: Text(CustomLocalizations.text("change_def_next_2"), style: TextStyle(color: const Color(0xFF000000),
                  fontSize: 22.sp, fontWeight: FontWeightConf.black), textAlign: TextAlign.center,),
            ),
          ), onClicked: (){
              onConfirm();
          },),

          SizedBox(width: 33.w,),

          _buildNextBtn(isEmpty ? 0.4 : 1.0),
        ],
      ),
    );
  }

  _buildBtnRequirePanel() {
    return Container(
      margin: EdgeInsets.only(bottom: 17.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCancelBtn(),

          SizedBox(width: 33.w,),

          SizedBox(width: 222.w,),

          SizedBox(width: 33.w,),

          _buildNextBtn(1.0),
        ],
      ),
    );
  }

  _buildNextBtn(double opacity) {
    return TapDownZoomOutView(child: Opacity(
      opacity: opacity,
      child: Container(
        width: 160.w,
        height: 77.w,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/img_orange_btn_bg.png'),
            fit: BoxFit.fill,
          ),
        ),
        alignment: Alignment.center,
        child: Text(CustomLocalizations.text("order_next"), style: TextStyle(color: const Color(0xFF000000), fontSize: 22.sp, fontWeight: FontWeightConf.black),),
      ),
    ), onClicked: (){
      onConfirm();
    },);
  }

}