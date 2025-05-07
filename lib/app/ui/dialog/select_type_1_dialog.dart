
import 'package:enjoy_meal/app/base/config/font_weight_conf.dart';
import 'package:enjoy_meal/app/data/model/restaurant_data.dart';
import 'package:enjoy_meal/app/local/custom_localizations.dart';
import 'package:enjoy_meal/app/ui/dialog/select_type_2_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../base/widget/tap_down_zoom_out_view.dart';
import 'controller/dish_detail_dialog_controller.dart';

// ignore_for_file: must_be_immutable
class SelectType1Dialog extends StatelessWidget{

  DishInfo dishInfo;
  Function() onCancel;
  Function(List<DishAttributeInfo> attributeList)? onConfirm;
  final controller = Get.put(DishDetailDialogController());
  late DishAttributeCategoryInfo selectedDishAttributeCategoryInfo;

  SelectType1Dialog({super.key, required this.dishInfo, required this.onCancel, this.onConfirm}){
    controller.selectedNumObs(1);
    controller.selectedAttributeInfoMap.clear();
    selectedDishAttributeCategoryInfo = dishInfo.dishAttributeCategoryInfos.first;
  }

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

    double? samePrice;
    if (selectedDishAttributeCategoryInfo.isRequired == RestaurantConf.requireTypeOptional) {
      if (selectedDishAttributeCategoryInfo.isSamePrice()) {
        samePrice = selectedDishAttributeCategoryInfo.dishAttributeInfos.first.priceAdjustment;
      }
    }

    return Container(
      width: 647.w,
      height: 348.w,
      color: const Color(0xFFEDDA8E),
      child: Column(
        children: [

          const SizedBox(height: 8,),

          _buildTypePanelTitle(samePrice, selectedDishAttributeCategoryInfo.getAttributeCategoryName()),

          SizedBox(
            width: 594.w,
            height: 276.w,
            child: Obx((){
              final isUpdate = controller.selectedAttributeUpdateObs.value;
              return _buildGridPanel(selectedDishAttributeCategoryInfo.dishAttributeInfos,
                  (selectedDishAttributeCategoryInfo.isRequired == RestaurantConf.requireTypeOptional && samePrice == null));
            }),
          ),
        ],
      ),
    );
  }

  _buildTypePanelTitle(double? price, String title) {
    if (price != null) {
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
    }
    return Text(title, style: TextStyle(color: const Color(0xFF000000), fontSize: 35.sp, fontWeight: FontWeightConf.bold),);
  }

  _buildGridPanel(List<DishAttributeInfo> dishAttributeInfos, bool shouldShowPrice) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // 每行的item数量
          childAspectRatio: (130/83), // 子widget的宽高比例
          mainAxisSpacing: 13.w, // 主轴方向的间隔
          crossAxisSpacing: 25.w, // 交叉轴方向的间隔
        ),
        itemCount: 12,
        itemBuilder: (context, index){
          if (index <= dishAttributeInfos.length -1) {
            final model = dishAttributeInfos[index];
            return TapDownZoomOutView(child: _buildGridItem(model), onClicked: (){
              controller.onDishAttributeItemClicked(selectedDishAttributeCategoryInfo, model);
            });
          } else {
            return _buildGridNullItem();
          }
        }
    );
  }

  _buildGridItem(DishAttributeInfo item) {
    return Container(
      decoration: BoxDecoration(
          color: controller.isAttributeIdSelected(selectedDishAttributeCategoryInfo.id, item.id) ? const Color(0xFF01ABFC) : const Color(0xFFF39800),
          borderRadius: BorderRadius.circular(10.r)
      ),
      alignment: Alignment.center,
      child: Text(item.getAttributeName(), style: TextStyle(color: const Color(0xFF000000), fontSize: 26.sp, fontWeight: FontWeightConf.medium),),
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
            child: Text(CustomLocalizations.text("change_def_next_1"), style: TextStyle(color: const Color(0xFF000000),
                fontSize: 22.sp, fontWeight: FontWeightConf.black), textAlign: TextAlign.center,),
          ),), onClicked: (){
            if (controller.isExistCategoryDishAttribute(selectedDishAttributeCategoryInfo.id)) {
              return;
            }
            if (onConfirm == null) {
              if (dishInfo.dishAttributeCategoryInfos.length == 2) {
                showSelectType2Dialog(dishInfo);
              } else {
                controller.onConfirmBtnClicked(dishInfo);
              }
            } else {
              List<DishAttributeInfo> dishAttributeInfoList = [];
              for (var item in controller.selectedAttributeInfoMap.values) {
                dishAttributeInfoList.addAll(item.values.toList());
              }
              onConfirm!(dishAttributeInfoList);
            }
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
      child: Text(CustomLocalizations.text("keep_forward"), style: TextStyle(color: const Color(0xFF000000), fontSize: 22.sp, fontWeight: FontWeightConf.black),),
    ),), onClicked: (){
      if (!controller.isExistCategoryDishAttribute(selectedDishAttributeCategoryInfo.id)) {
        return;
      }
      if (onConfirm == null) {
        if (dishInfo.dishAttributeCategoryInfos.length == 2) {
          showSelectType2Dialog(dishInfo);
        } else {
          controller.onConfirmBtnClicked(dishInfo);
        }
      } else {
        List<DishAttributeInfo> dishAttributeInfoList = [];
        for (var item in controller.selectedAttributeInfoMap.values) {
          dishAttributeInfoList.addAll(item.values.toList());
        }
        onConfirm!(dishAttributeInfoList);
      }
    },);
  }

  void showSelectType2Dialog(DishInfo dishInfo) {
    Get.dialog(SelectType2Dialog(dishInfo: dishInfo,
      onCancel: (){
        Get.back();
      }, onConfirm: (){
        Get.back();
        controller.onConfirmBtnClicked(dishInfo);
      },), barrierColor: Colors.transparent, useSafeArea: false);
  }
}