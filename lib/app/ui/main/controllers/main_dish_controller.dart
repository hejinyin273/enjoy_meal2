

import 'package:cached_network_image/cached_network_image.dart';
import 'package:enjoy_meal/app/data/model/restaurant_data.dart';
import 'package:enjoy_meal/app/local/custom_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/data/protocol/response/base_resp.dart';
import '../../../base/utils/default_cache_manager.dart';
import '../../../base/data/event_bus.dart';
import '../../../routes/app_pages.dart';
import 'custom_base_controller.dart';

class MainDishController extends CustomBaseController  {

  final _hotDishListObs = <DishInfo>[].obs;
  List<DishInfo> get hotDishList => _hotDishListObs.toList();
  updateDishInfoList(List<DishInfo> dataList) => _hotDishListObs(dataList);

  late int topLayoutMode;
  late List<RestaurantTopLayoutInfo> topLayoutInfoList;

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  void initData() {
    topLayoutMode = globalController.restaurantData.restaurantBaseInfo.topLayoutMode;
    topLayoutInfoList = globalController.restaurantData.restaurantTopLayoutInfos;
  }

  @override
  void onRestaurantDataUpdate(RefreshDataEvent event) {
    if (event.type == 1) {
      return;
    }
    initData();
    refreshDataTimeObs(DateTime.now().millisecondsSinceEpoch);
    reqHotDishList();
  }

  @override
  void onReady() {
    reqHotDishList();
    super.onReady();
  }

  @override
  void onClose() {
    _hotDishListObs.close();
    super.onClose();
  }

  void onCategoryItemClicked(RestaurantTopLayoutInfo item) {
    if (item.bgImage != null) {
      precacheImage(CachedNetworkImageProvider(item.bgImage!, cacheManager: DefaultCacheManager()), Get.context!);
    }

    Get.toNamed(Routes.subDishPage, arguments: item);
  }

  void onRankingItemClicked(DishInfo item) {
    if (globalController.isOnBuffetMode) {
      return;
    }
    if (!globalController.checkDishCanDoNext(item)) {
      return;
    }

    final currentDateTime = DateTime.now();

    for(var mainItem in globalController.restaurantData.categoryInfos) {
      if (mainItem.id == item.mainCategoryId!) {
        if (mainItem.startHour !=null && mainItem.startMinute !=null && mainItem.endHour != null && mainItem.endMinute != null) {

          final startDateTime = DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day, mainItem.startHour!, mainItem.startMinute!);
          final endDateTime = DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day, mainItem.endHour!, mainItem.endMinute!);

          if (currentDateTime.isAfter(startDateTime) && currentDateTime.isBefore(endDateTime)) {
            onDishInfoItemClicked(item.mainCategoryId!, item, flyToCartAnim: false);
          } else {
            showToast(CustomLocalizations.text("no_dish_on_this_time"));
          }
        } else {
          onDishInfoItemClicked(item.mainCategoryId!, item, flyToCartAnim: false);
        }
        break;
      }
    }
  }

  void reqHotDishList() {
    dataRepository.reqHotDishList().then((BaseResp baseResp){
      if(baseResp.isSuccessWithData()) {

        List<HotDish> hotDishList = [];
        baseResp.data.forEach((v) {
          hotDishList.add(HotDish.fromJson(v));
        });

        List<DishInfo> dataList = [];
        for(int i=0; i<hotDishList.length; i++) {
          final hotDish = hotDishList[i];
          for(int j=0; j<hotDish.dishInfos.length; j++) {
            final dishInfo = hotDish.dishInfos[j];
            dataList.add(dishInfo);
            dataList.last.mainCategoryId = hotDish.primaryCategoryId;
          }
        }
        updateDishInfoList(dataList);
      } else {
        showApiErrToast(baseResp.status, baseResp.message);
      }
    }, onError:(err) {
      handleException(err);
    } );
  }

}

