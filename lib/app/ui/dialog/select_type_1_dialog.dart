
import 'package:auto_size_text/auto_size_text.dart';
import 'package:enjoy_meal/app/base/config/font_weight_conf.dart';
import 'package:enjoy_meal/app/data/model/restaurant_data.dart';
import 'package:enjoy_meal/app/local/custom_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../base/widget/tap_down_zoom_out_view.dart';
import 'controller/dish_detail_dialog_controller.dart';

// ignore_for_file: must_be_immutable
class SelectType1Dialog extends StatelessWidget{

  late DishInfo dishInfo;
  late int selectedDishAttrCategoryIndex;
  late DishAttributeCategoryInfo selectedDishAttributeCategoryInfo;

  Function() onCancel;

  final controller = Get.put(DishDetailDialogController());

  SelectType1Dialog({super.key, required this.dishInfo, required this.selectedDishAttrCategoryIndex, required this.onCancel}){
    controller.selectedNumObs(1);
    selectedDishAttributeCategoryInfo = dishInfo.dishAttributeCategoryInfos[selectedDishAttrCategoryIndex];
    if (selectedDishAttrCategoryIndex == 0) {
      controller.selectedAttributeInfoMap.clear();
    } else {
      controller.selectedAttributeInfoMap.remove(selectedDishAttributeCategoryInfo.id);
    }
  }

  ///maxSelection	最多可选择的数量，1表示单选，大于1表示可多选的具体数量
  ///isRequired	是否必选，0为非必选，1为必选

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center,
      children: [
        _buildContentView(context),
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

              Obx(()=>controller.selectedAttributeUpdateObs.value ? _buildBtnPanel() : _buildBtnPanel()),
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
      child: Column(
        children: [

          const SizedBox(height: 8,),

          _buildTypePanelTitle(selectedDishAttributeCategoryInfo.getAttributeCategoryName()),

          SizedBox(
            width: 594.w,
            height: 276.w,
            child: Obx((){
              final isUpdate = controller.selectedAttributeUpdateObs.value;
              return _buildGridPanel(selectedDishAttributeCategoryInfo.dishAttributeInfos,
                  (selectedDishAttributeCategoryInfo.isRequired == RestaurantConf.requireTypeOptional));
            }),
          ),
        ],
      ),
    );
  }

  _buildTypePanelTitle(String title) {
    /*if (price != null) {
      return RichText(
        textAlign: TextAlign.end,
        text: TextSpan(
          style: TextStyle(color: const Color(0xFF000000), fontSize: 35.sp, fontWeight: FontWeightConf.bold), // 默认文本样式
          children: <TextSpan>[
            const TextSpan(text: '+'),
            TextSpan(text: '${price.toInt()}', style: TextStyle(color: const Color(0xFFFF0303),
                fontSize: 35.sp, fontWeight: FontWeightConf.bold)),
            TextSpan(text: '${CustomLocalizations.text("money_unit")}  '),
            TextSpan(text: title),
          ],
        ),
      );
    }*/
    return Text(title, style: TextStyle(color: const Color(0xFF000000), fontSize: 35.sp, fontWeight: FontWeightConf.bold),);
  }

  _buildGridPanel(List<DishAttributeInfo> dishAttributeInfos, bool shouldShowPrice) {
    int itemCount = 12;
    if (dishAttributeInfos.length <= 3) {
      itemCount = 4;
    }
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: itemCount == 4 ? 2 : 4, // 每行的item数量
          childAspectRatio: itemCount == 4 ? (304/125) : (130/83), // 子widget的宽高比例
          mainAxisSpacing: itemCount == 4 ? 18.w : 13.w, // 主轴方向的间隔
          crossAxisSpacing: itemCount == 4 ? 29.w : 25.w, // 交叉轴方向的间隔
        ),
        itemCount: itemCount,
        itemBuilder: (context, index){
          if (index <= dishAttributeInfos.length -1) {
            final model = dishAttributeInfos[index];
            return TapDownZoomOutView(child: _buildGridItem(model, shouldShowPrice, itemCount == 4 ? 24.sp : 22.sp), onClicked: (){
              controller.onDishAttributeItemClicked(selectedDishAttributeCategoryInfo, model);
            });
          } else {
            return _buildGridNullItem();
          }
        }
    );
  }

  _buildGridItem(DishAttributeInfo item, bool shouldShowPrice, double? fontSize) {
    return Container(
      decoration: BoxDecoration(
          color: controller.isAttributeIdSelected(selectedDishAttributeCategoryInfo.id, item.id) ? const Color(0xFF01ABFC) : const Color(0xFFF39800),
          borderRadius: BorderRadius.circular(10.r)
      ),
      alignment: Alignment.center,
      child: shouldShowPrice
          ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(color: const Color(0xFF000000),
                      fontSize: fontSize??24.sp, fontWeight: FontWeightConf.bold), // 默认文本样式
                  children: <TextSpan>[
                    const TextSpan(text: '＋'),
                    TextSpan(text: '${item.priceAdjustment.toInt()}', style: TextStyle(color: const Color(0xFFFF0303),
                        fontSize: fontSize??24.sp, fontWeight: FontWeightConf.bold)),
                    TextSpan(text: CustomLocalizations.text("money_unit")),
                  ],
                ),
              ),
              Container(
                width: 304.w,
                height: 50.w,
                alignment: Alignment.center,
                child: AutoSizeText(item.getAttributeName(), textAlign: TextAlign.center,
                  style: TextStyle(color: const Color(0xFF000000), fontSize: fontSize??24.sp,
                      fontWeight: FontWeightConf.medium),),
              )
            ],
          )
          : AutoSizeText(item.getAttributeName(), textAlign: TextAlign.center,
        style: TextStyle(color: const Color(0xFF000000), fontSize: fontSize??26.sp,
            fontWeight: FontWeightConf.medium),),
    );
  }

  _buildGridNullItem() {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFF39800),
          borderRadius: BorderRadius.circular(10.r)
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

          TapDownZoomOutView(child: Opacity(opacity: isEmpty ? 1.0 : 0.4, child: Container(
            width: 222.w,
            height: 77.w,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/img_orange_btn_bg.png'),
                fit: BoxFit.fill,
              ),
            ),
            alignment: Alignment.center,
            child: Text(selectedDishAttrCategoryIndex == dishInfo.dishAttributeCategoryInfos.length -1
                ? CustomLocalizations.text("change_def_next_2")
                : CustomLocalizations.text("change_def_next_1") , style: TextStyle(color: const Color(0xFF000000),
                fontSize: 22.sp, fontWeight: FontWeightConf.black), textAlign: TextAlign.center,),
          ),), onClicked: (){
            if (controller.isExistCategoryDishAttribute(selectedDishAttributeCategoryInfo.id)) {
              return;
            }
            _handleConfirmClicked();
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
    return TapDownZoomOutView(child: Opacity(opacity: opacity, child: Container(
      width: 160.w,
      height: 77.w,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/img_orange_btn_bg.png'),
          fit: BoxFit.fill,
        ),
      ),
      alignment: Alignment.center,
      child: Text(selectedDishAttrCategoryIndex == dishInfo.dishAttributeCategoryInfos.length -1
          ? CustomLocalizations.text("order_next")
          : CustomLocalizations.text("keep_forward"), style: TextStyle(color: const Color(0xFF000000), fontSize: 22.sp, fontWeight: FontWeightConf.black),),
    ),), onClicked: (){
      if (!controller.isExistCategoryDishAttribute(selectedDishAttributeCategoryInfo.id)) {
        return;
      }
      _handleConfirmClicked();
    },);
  }

  void _handleConfirmClicked() {
    if (selectedDishAttrCategoryIndex == dishInfo.dishAttributeCategoryInfos.length -1) {///all done
      controller.onConfirmBtnClicked(dishInfo);
      Get.until((route) => !(Get.isDialogOpen??false));
    } else {
      int nextIndex = selectedDishAttrCategoryIndex + 1;
      _showSelectType1Dialog(dishInfo, nextIndex);
    }
  }

  void _showSelectType1Dialog(DishInfo dishInfo, int selectedIndex) {
    Get.dialog(SelectType1Dialog(dishInfo:dishInfo, selectedDishAttrCategoryIndex: selectedIndex, onCancel: (){
      Get.back();
    },), barrierColor: Colors.transparent, useSafeArea: false);
  }
}