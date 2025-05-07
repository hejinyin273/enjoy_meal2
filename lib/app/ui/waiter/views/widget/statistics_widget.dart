

import 'package:enjoy_meal/app/base/config/font_weight_conf.dart';
import 'package:enjoy_meal/app/base/widget/tap_down_zoom_out_view.dart';
import 'package:enjoy_meal/app/local/custom_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../base/utils/view_util.dart';
import '../../../../data/model/load_state.dart';
import '../../../../data/protocol/response/statistics_resp.dart';
import '../../controllers/cooking_manager_controller.dart';

class StatisticsWidget extends StatelessWidget{
  final controller = Get.find<CookingManagerController>();
  final String tower = CustomLocalizations.text("tower");
  final String lunch = CustomLocalizations.text("lunch");
  final String eveningFood = CustomLocalizations.text("evening_food");
  final String amountTo = CustomLocalizations.text("amount_to");

  StatisticsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx((){
      if (LoadState.loading == controller.loadStatisticsStateObs.value) {
        return Center(
          child: ViewUtil.buildLoadingView(),
        );
      } else if (LoadState.failed == controller.loadStatisticsStateObs.value) {
        return Center(
          child: ViewUtil.buildNetErrView((){
            controller.reqStatistics();
          }),
        );
      } else {
        return _buildContentView();
      }
    });
  }

  _buildContentView() {
    return Column(
      children: [
        SizedBox(height: 36.h,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTabItem(lunch, controller.statisticsTabIndexObs.value == 0, (){
              controller.statisticsTabIndexObs(0);
            }),

            SizedBox(width: 58.w,),

            _buildTabItem(eveningFood, controller.statisticsTabIndexObs.value == 1, (){
              controller.statisticsTabIndexObs(1);
            }),

            SizedBox(width: 58.w,),

            _buildTabItem(amountTo, controller.statisticsTabIndexObs.value == 2, (){
              controller.statisticsTabIndexObs(2);
            }),
          ],
        ),

        SizedBox(height: 36.h,),

        _buildSummarizePanel(),

        Expanded(
            flex: 1,
            child: controller.statisticsTabIndexObs.value == 2 ? const SizedBox() : _buildStatisticsOrderPanel()
        ),
      ],
    );
  }

  _buildSummarizePanel() {
    if (controller.statisticsTabIndexObs.value == 0) {
      return _buildDinnerSummarizePanel();
    } else if (controller.statisticsTabIndexObs.value == 1) {
      return _buildBreakfastSummarizePanel();
    } else {
      return SizedBox(
        height: 250.h,
        child: Column(
          children: [
            _buildDinnerSummarizePanel(),
            SizedBox(height: 12.h),
            _buildBreakfastSummarizePanel(),
            SizedBox(height: 12.h),
            _buildTotalSummarizePanel(),
          ],
        ),
      );
    }
  }

  _buildDinnerSummarizePanel() {
    String summarizeTables = "0$tower";
    double totalAmount = 0;
    if (controller.statisticsResp != null && controller.statisticsResp!.dinnerCount != null) {
      if (controller.statisticsResp!.dinnerCount != null) {
        summarizeTables = "${controller.statisticsResp!.dinnerCount!.count}$tower";
        totalAmount = controller.statisticsResp!.dinnerCount!.totalAmount;
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSummarizeItem(175.w, lunch),

        SizedBox(width: 2.w,),

        _buildSummarizeItem(335.w, summarizeTables),

        SizedBox(width: 2.w,),

        _buildSummarizeItem(429.w, "$amountTo：${totalAmount.toInt()}"),
      ],
    );
  }

  _buildBreakfastSummarizePanel() {
    String summarizeTables = "0$tower";
    double totalAmount = 0;
    if (controller.statisticsResp != null && controller.statisticsResp!.breakfastCount != null) {
      if (controller.statisticsResp!.breakfastCount != null) {
        summarizeTables = "${controller.statisticsResp!.breakfastCount!.count}$tower";
        totalAmount = controller.statisticsResp!.breakfastCount!.totalAmount;
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSummarizeItem(175.w, eveningFood),

        SizedBox(width: 2.w,),

        _buildSummarizeItem(335.w, summarizeTables),

        SizedBox(width: 2.w,),

        _buildSummarizeItem(429.w, "$amountTo：${totalAmount.toInt()}"),
      ],
    );
  }

  _buildTotalSummarizePanel() {
    String summarizeTables = "0$tower";
    double totalAmount = 0;
    if (controller.statisticsResp != null && controller.statisticsResp!.orderCount != null) {
      if (controller.statisticsResp!.orderCount != null) {
        summarizeTables = "${controller.statisticsResp!.orderCount!.count}$tower";
        totalAmount = controller.statisticsResp!.orderCount!.totalAmount;
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSummarizeItem(175.w, CustomLocalizations.text("total_of_2_meals")),

        SizedBox(width: 2.w,),

        _buildSummarizeItem(335.w, summarizeTables),

        SizedBox(width: 2.w,),

        _buildSummarizeItem(429.w, "$amountTo：${totalAmount.toInt()}"),
      ],
    );
  }

  _buildTabItem(String title, bool isSelected, Function() onClicked) {
    return TapDownZoomOutView(
      onClicked: onClicked,
      child: Container(
        width: 210.w,
        height: 75.h,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF7E23) : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: const Color(0xFF008EF3)
          )
        ),
        alignment: Alignment.center,
        child: Text(title, style: TextStyle(color: Colors.black, fontSize: 36.sp, fontWeight: FontWeightConf.bold),),
      )
    );
  }

  _buildSummarizeItem(double width, String content) {
    return Container(
      width: width,
      height: 65.h,
      color: const Color(0xFFD9D9D9),
      alignment: Alignment.center,
      child: Text(content, style: TextStyle(color: Colors.black, fontSize: 36.sp, fontWeight: FontWeightConf.bold),),
    );
  }

  _buildStatisticsOrderPanel() {
    if (controller.statisticsResp == null) {
      return const SizedBox();
    }
    final dataList = controller.statisticsTabIndexObs.value == 0
        ? controller.statisticsResp!.dinnerOrders
        : controller.statisticsResp!.breakfastOrders;
    return Container(
      padding: EdgeInsets.only(left: 146.w, right: 146.w, top: 13.h),
      child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5, // 每行的item数量
        childAspectRatio: (183.w/153.w), // 子widget的宽高比例
        mainAxisSpacing: 12.h, // 主轴方向的间隔
        crossAxisSpacing: 18.w, // 交叉轴方向的间隔
      ), itemCount: dataList.length,
          itemBuilder: (context, index){
            final model = dataList[index];
            return _buildStatisticsOrderItem(model);
          }),
    );
  }

  _buildStatisticsOrderItem(StatisticsOrder item) {
    return Container(
      width: 183.w,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black,
          width: 1.w
        )
      ),
      child: Column(
        children: [
          Container(
            height: 50.w,
            alignment: Alignment.center,
            child: Text("${CustomLocalizations.text("seat")}${item.tableNumber}"),
          ),
          Container(
            height: 50.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.symmetric(horizontal: BorderSide(
                    color: Colors.black,
                    width: 1.w
                ),
                )
            ),
            child: Text("${CustomLocalizations.text("start_time")}：${item.orderTime}"),
          ),
          Container(
            height: 50.w,
            alignment: Alignment.center,
            child: Text("${CustomLocalizations.text("amount_to_space")}：${item.totalAmount.toInt()}"),
          ),
        ],
      ),
    );
  }
}