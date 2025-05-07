


import 'package:enjoy_meal/app/data/model/restaurant_data.dart';
import 'package:enjoy_meal/app/local/custom_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../base/config/font_weight_conf.dart';
import '../../../../base/widget/tap_down_zoom_out_view.dart';
import '../../controllers/cooking_manager_controller.dart';

class StoreOperationWidget extends StatelessWidget{
  final controller = Get.find<CookingManagerController>();
  final String infinite = CustomLocalizations.text("infinite");
  final String upShelf = CustomLocalizations.text("up_shelf");
  final String downShelf = CustomLocalizations.text("down_shelf");
  final String operation = CustomLocalizations.text("operation");

  StoreOperationWidget({super.key}) {
    controller.updateStoreDishAndPackageList();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildContentView(),
        _buildNumberInputPanel(),
      ],
    );
  }

  _buildContentView() {
    return Obx(()=>controller.storeDataUpdateObs.value ? _buildStoreOperationView() : SizedBox());
  }

  _buildStoreOperationView() {
    return Container(
      width: 765.w,
      margin: EdgeInsets.only(left: 55.w, right: 55.w, top: 31.w, bottom: 90.w),
      child: ListView.builder(
          itemCount: controller.storeDishInfoList.length + 1,
          itemBuilder: (context, index){
            if (index == 0) {
              return _buildTableItemHeader();
            }
            final model = controller.storeDishInfoList[index - 1];
            return _buildDishItem(model);
          }),
    );
  }

  _buildTableItemHeader() {
    return Container(
      height: 65.w,
      child: Row(
        children: [
          Container(
            width: 127.w,
            decoration: BoxDecoration(
                color: const Color(0xFFFDFDFD),
                border: Border.all(
                    color: const Color(0xFF008EF3),
                    width: 1.w
                )
            ),
            alignment: Alignment.center,
            child: Text(CustomLocalizations.text("menu_id"), style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeightConf.bold),),
          ),

          Container(
            width: 301.w,
            padding: EdgeInsets.only(left: 10.w),
            decoration: BoxDecoration(
                color: const Color(0xFFFDFDFD),
                border: Border.all(
                    color: const Color(0xFF008EF3),
                    width: 1.w
                )
            ),
            alignment: Alignment.centerLeft,
            child: Text(CustomLocalizations.text("menu"),
              style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeightConf.bold),),
          ),

          Container(
            width: 112.w,
            decoration: BoxDecoration(
                color: const Color(0xFFFDFDFD),
                border: Border.all(
                    color: const Color(0xFF008EF3),
                    width: 1.w
                )
            ),
            alignment: Alignment.center,
            child: Text(CustomLocalizations.text("quantity_in_stock"), style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeightConf.bold),),
          ),

          Container(
            width: 112.w,
            decoration: BoxDecoration(
                color: const Color(0xFFFDFDFD),
                border: Border.all(
                    color: const Color(0xFF008EF3),
                    width: 1.w
                )
            ),
            alignment: Alignment.center,
            child: Text(CustomLocalizations.text("status"), style: TextStyle(color: Colors.black, fontSize: 18.sp, fontWeight: FontWeightConf.bold),),
          ),

          Container(
            width: 113.w,
            decoration: BoxDecoration(
                color: const Color(0xFFFDFDFD),
                border: Border.all(
                    color: const Color(0xFF008EF3),
                    width: 1.w
                )
            ),
          ),
        ],
      ),
    );
  }

  _buildDishItem(DishInfo model) {
    return Container(
      height: 65.w,
      child: Row(
        children: [
          Container(
            width: 127.w,
            decoration: BoxDecoration(
                color: const Color(0xFFFDFDFD),
                border: Border.all(
                    color: const Color(0xFF008EF3),
                    width: 1.w
                )
            ),
            alignment: Alignment.center,
            child: Text("${model.dishOwnId}", style: TextStyle(color: Colors.black, fontSize: 28.sp, fontWeight: FontWeightConf.bold),),
          ),

          Container(
            width: 301.w,
            padding: EdgeInsets.only(left: 10.w),
            decoration: BoxDecoration(
                color: const Color(0xFFFDFDFD),
                border: Border.all(
                    color: const Color(0xFF008EF3),
                    width: 1.w
                )
            ),
            alignment: Alignment.centerLeft,
            child: Text(model.getDishName(),
              style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeightConf.bold),),
          ),

          Container(
            width: 112.w,
            decoration: BoxDecoration(
                color: const Color(0xFFFDFDFD),
                border: Border.all(
                    color: const Color(0xFF008EF3),
                    width: 1.w
                )
            ),
            alignment: Alignment.center,
            child: Text("${model.inventoryQuantity??infinite}", style: TextStyle(color: Colors.black, fontSize: 28.sp, fontWeight: FontWeightConf.bold),),
          ),

          Container(
            width: 112.w,
            decoration: BoxDecoration(
                color: const Color(0xFFFDFDFD),
                border: Border.all(
                    color: const Color(0xFF008EF3),
                    width: 1.w
                )
            ),
            alignment: Alignment.center,
            child: Text(model.available ? upShelf : downShelf, style: TextStyle(color: Colors.black, fontSize: 28.sp, fontWeight: FontWeightConf.bold),),
          ),

          Container(
            width: 113.w,
            decoration: BoxDecoration(
                color: const Color(0xFFFDFDFD),
                border: Border.all(
                    color: const Color(0xFF008EF3),
                    width: 1.w
                )
            ),
            alignment: Alignment.center,
            child: TapDownZoomOutView(
                onClicked: (){
                  controller.onStoreOperationClicked(model);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                  decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      border: Border.all(
                          color: const Color(0xFF000000),
                          width: 1.w
                      )
                  ),
                  alignment: Alignment.center,
                  child: Text(operation, style: TextStyle(color: Colors.black, fontSize: 22.sp, fontWeight: FontWeightConf.bold),),
                )),
          ),
        ],
      ),
    );
  }

  _buildPackageItem(PackageInfo model) {
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
            child: Text("${model.id}", style: TextStyle(color: Colors.black, fontSize: 28.sp, fontWeight: FontWeightConf.bold),),
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
                child: Text(model.getPackageName(), style: TextStyle(color: Colors.black, fontSize: 28.sp, fontWeight: FontWeightConf.bold),),
              )),

          TapDownZoomOutView(
              onClicked: (){

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
  }

  _buildNumberInputPanel() {
    return Container(
      width: 380.w,
      margin: EdgeInsets.only(top: 38.h),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 256.w,
              height: 70.h,
              decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  border: Border.all(
                      color: const Color(0xFF000000),
                      width: 1.w
                  )
              ),
              alignment: Alignment.center,
              child: Text(CustomLocalizations.text("menu_id"), style: TextStyle(color: Colors.black, fontSize: 28.sp, fontWeight: FontWeightConf.bold),),
            ),

            Container(
              width: 380.w,
              height: 580.h,
              margin: EdgeInsets.only(top: 11.h),
              decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  border: Border.all(
                      color: const Color(0xFF000000),
                      width: 1.w
                  )
              ),
              child: Stack(
                children: [
                  _buildGridNumberPanel(),

                  Container(
                    width: 330.w,
                    height: 77.h,
                    margin: EdgeInsets.only(top: 17.h, left: 26.w),
                    decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        border: Border.all(
                            color: const Color(0xFF000000),
                            width: 1.w
                        )
                    ),
                    child: _buildInputNumber(),
                  ),

                  Container(
                    width: 330.w,
                    height: 77.h,
                    margin: EdgeInsets.only(top: 17.h, left: 26.w, ),
                    alignment: Alignment.centerRight,
                    child: TapDownZoomOutView(
                        onClicked: (){
                          controller.dishIdController.text = "";
                          controller.onStoreDishIdInputChanged();
                        },
                        child: SizedBox(
                          width: 60.w,
                          height: 60.h,
                          child: const Icon(Icons.clear, color: Colors.grey,),
                        )),
                  ),

                  Positioned(
                    bottom: 14.w,
                    right: 46.w,
                    child: TapDownZoomOutView(
                      onClicked: (){
                        controller.onStoreDishIdInputChanged();
                      },
                        child: Container(
                      width: 170.w,
                      height: 84.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: const Color(0xFFEBE9E9),
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(
                              color: const Color(0xFF000000),
                              width: 1.w
                          )
                      ),
                      child: Text(CustomLocalizations.text("confirm_no_space"), style: TextStyle(color: Colors.black, fontSize: 32.sp, fontWeight: FontWeightConf.bold),),
                    )),),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildInputNumber() {
    return TextField(
      autofocus: false,
      focusNode: controller.dishIdNode,
      controller: controller.dishIdController,
      textAlign: TextAlign.center,
      enabled: false,
      showCursor: false,
      maxLines: 1,
      inputFormatters: [
        LengthLimitingTextInputFormatter(5),
        FilteringTextInputFormatter.digitsOnly,
      ],
      style: TextStyle(
          fontWeight: FontWeightConf.regular,
          fontSize: 44.sp,
          color: const Color(0xFF333333)
      ),
      decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          counterText: '',
          hintText: "0",
          hintStyle: TextStyle(
              fontWeight: FontWeightConf.regular,
              fontSize: 44.sp,
              color: const Color(0xFF999999)
          ),
          contentPadding: const EdgeInsets.all(0)
      ),
      keyboardType: TextInputType.number,
    );
  }

  _buildGridNumberPanel() {
    return Container(
      width: 380.w,
      height: 580.h,
      padding: EdgeInsets.only(left: 9.w, right: 9.w, top: 116.h),
      child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 每行的item数量
        childAspectRatio: (100.w/100.h), // 子widget的宽高比例 101/186 186=162 + 12 + 12
        mainAxisSpacing: 14.h, // 主轴方向的间隔
        crossAxisSpacing: 27.w, // 交叉轴方向的间隔
      ), itemCount: 10,
          itemBuilder: (context, index){
            int useNum = 0;
            if (index < 9) {
              useNum = index + 1;
            }
            return TapDownZoomOutView(child: _buildGridNumberItem(useNum), onClicked: (){
              final text = controller.dishIdController.text;
              if (text.length <= 4) {
                controller.dishIdController.text = "$text$useNum";
                controller.onStoreDishIdInputChanged();
              }
            });
          }),
    );
  }

  _buildGridNumberItem(int index) {
    return Container(
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xFFFDFDFD),
            borderRadius: BorderRadius.circular(50.w),
            border: Border.all(
                color: const Color(0xFF008EF3),
                width: 1.w
            )
        ),
        width: 100.w,
        height: 100.w,
        alignment: Alignment.center,
        child: Text(index.toString(), style: TextStyle(color: Colors.black, fontSize: 42.sp, fontWeight: FontWeightConf.medium),),
      ),
    );
  }

}