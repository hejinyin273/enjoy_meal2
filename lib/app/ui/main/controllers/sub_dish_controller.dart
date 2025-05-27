

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:enjoy_meal/app/base/utils/default_cache_manager.dart';
import 'package:enjoy_meal/app/ui/main/model/page_dish_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../base/data/event_bus.dart';
import '../../../data/model/goods_model.dart';
import '../../../data/model/restaurant_data.dart';
import '../../../local/custom_localizations.dart';
import '../../../routes/app_pages.dart';
import '../views/widget/fly_to_pos_widget.dart';
import 'custom_base_controller.dart';

class SubDishController extends CustomBaseController  {
  int currentPageIndex = 0;
  late PageController pageController;

  late ScrollController mainListScrollController;

  final _isUpdatePageDataObs = true.obs;
  bool get isUpdatePageData => _isUpdatePageDataObs.value;
  updatePageData() {
    _isUpdatePageDataObs(false);
    _isUpdatePageDataObs(true);
  }

  List<CategoryInfo> mainCategoryInfoList = [];
  final _selectedMainCategoryIdObs = 0.obs;
  int get selectedMainCategoryId => _selectedMainCategoryIdObs.value;
  updateSelectedMainCategoryId(int id) {
    _selectedMainCategoryIdObs(id);
    for (int i=0; i<mainCategoryInfoList.length; i++) {
      if (mainCategoryInfoList[i].id == id) {
        updateMainListScroll(i);
        break;
      }
    }
  }

  String? getMainCategoryDesc(int id) {
    for (int i=0; i<mainCategoryInfoList.length; i++) {
      if (mainCategoryInfoList[i].id == id) {
        return mainCategoryInfoList[i].getCategoryDesc();
      }
    }
    return null;
  }

  String getMainCategoryName(int id) {
    for (int i=0; i<mainCategoryInfoList.length; i++) {
      if (mainCategoryInfoList[i].id == id) {
        return mainCategoryInfoList[i].getCategoryName();
      }
    }
    return "";
  }

  List<CategoryInfo> subCategoryInfoList = [];
  final _selectedSubCategoryIdObs = 0.obs;
  int get selectedSubCategoryId => _selectedSubCategoryIdObs.value;
  updateSelectedSubCategoryId(int id) => _selectedSubCategoryIdObs(id);

  final List<PageDishList> _basePageDishDataList = [];
  List<PageDishList> pageDishDataList = [];

  final isShowPreBtnObs = true.obs;
  final isShowNextBtnObs = true.obs;

  void _initBasePageDishDataList() {
    final isOnBuffetMode = globalController.isOnBuffetMode;
    for(var mainItem in mainCategoryInfoList) {
      if (isOnBuffetMode) {
        if (!globalController.isBuffetSupportCategoryId(mainItem.id)) {
          continue;
        }
      }
      if (mainItem.categoryType == RestaurantConf.categoryTypeDish) {///一级分类下直接是菜品
        final subItemCount = mainItem.displayMode == RestaurantConf.displayMode_4 ? 4 : 6;
        if (mainItem.dishList.isNotEmpty) {
          if (globalController.isOnBuffetMode) {
            List<DishInfo> dataList = [];
            for (int i = 0; i < mainItem.dishList.length; i ++) {
              if (globalController.isBuffetSupportDishId(mainItem.dishList[i].id)) {
                dataList.add(mainItem.dishList[i]);
              }
              if (dataList.length == subItemCount || i == mainItem.dishList.length -1) {
                final pageDishList = PageDishList(mainItem.id, mainItem.id, mainItem.displayMode, dataList);
                pageDishList.bgUrl = mainItem.bgImage;
                _basePageDishDataList.add(pageDishList);
                dataList = [];
              }
            }
          } else {
            for (int i = 0; i < mainItem.dishList.length; i += subItemCount) {
              final subDishList = mainItem.dishList.sublist(i, i + subItemCount < mainItem.dishList.length ? i + subItemCount : mainItem.dishList.length);
              final pageDishList = PageDishList(mainItem.id, mainItem.id, mainItem.displayMode, subDishList);
              pageDishList.bgUrl = mainItem.bgImage;
              _basePageDishDataList.add(pageDishList);
            }
          }
        } else {
          final pageDishList = PageDishList(mainItem.id, mainItem.id, mainItem.displayMode, []);
          pageDishList.bgUrl = mainItem.bgImage;
          _basePageDishDataList.add(pageDishList);
        }
      } else if (mainItem.categoryType == RestaurantConf.categoryTypePackage) {///一级分类下直接是套餐--当前就一种-->拉麺セツト(昼限定)
        final pageDishList = PageDishList(mainItem.id, mainItem.id, mainItem.displayMode, [], packageInfo: mainItem.packageInfo);
        if (mainItem.packageInfo!.bgImage != null && mainItem.packageInfo!.bgImage!.isNotEmpty) {
          pageDishList.bgUrl = mainItem.packageInfo!.bgImage;
        } else {
          pageDishList.bgUrl = mainItem.bgImage;
        }
        _basePageDishDataList.add(pageDishList);
      } else if (mainItem.categoryType == RestaurantConf.categoryTypeBuffet) {///自定义-自助
        final pageDishList = PageDishList(mainItem.id, mainItem.id, mainItem.displayMode, [], packageInfo: mainItem.packageInfo);
        pageDishList.bgUrl = mainItem.bgImage;
        _basePageDishDataList.add(pageDishList);
      } else {
        for(var subItem in mainItem.children) {
          final subItemCount = subItem.displayMode == RestaurantConf.displayMode_4 ? 4 : 6;
          if (subItem.categoryType == RestaurantConf.categoryTypeDish) {///二级分类下是菜品
            if (isOnBuffetMode) {
              if (!globalController.isBuffetSupportCategoryId(subItem.id)) {
                continue;
              }
            }
            if (subItem.dishList.isNotEmpty) {
              if (isOnBuffetMode) {
                List<DishInfo> dataList = [];
                for (int i = 0; i < subItem.dishList.length; i++) {
                  if (globalController.isBuffetSupportDishId(subItem.dishList[i].id)) {
                    dataList.add(subItem.dishList[i]);
                  }
                  if (dataList.length == subItemCount || i == subItem.dishList.length -1) {
                    final pageDishList = PageDishList(mainItem.id, subItem.id, subItem.displayMode, dataList);
                    if (subItem.bgImage != null && subItem.bgImage!.isNotEmpty) {
                      pageDishList.bgUrl = subItem.bgImage;
                    } else {
                      pageDishList.bgUrl = mainItem.bgImage;
                    }
                    _basePageDishDataList.add(pageDishList);
                    dataList = [];
                  }
                }
              } else {
                for (int i = 0; i < subItem.dishList.length; i += subItemCount) {
                  final subDishList = subItem.dishList.sublist(i, i + subItemCount < subItem.dishList.length ? i + subItemCount : subItem.dishList.length);
                  final pageDishList = PageDishList(mainItem.id, subItem.id, subItem.displayMode, subDishList);
                  if (subItem.bgImage != null && subItem.bgImage!.isNotEmpty){
                    pageDishList.bgUrl = subItem.bgImage;
                  } else {
                    pageDishList.bgUrl = mainItem.bgImage;
                  }
                  _basePageDishDataList.add(pageDishList);
                }
              }
            } else {
              final pageDishList = PageDishList(mainItem.id, subItem.id, subItem.displayMode, []);
              if (subItem.bgImage != null && subItem.bgImage!.isNotEmpty){
                pageDishList.bgUrl = subItem.bgImage;
              } else {
                pageDishList.bgUrl = mainItem.bgImage;
              }
              _basePageDishDataList.add(pageDishList);
            }
          } else if (subItem.categoryType == RestaurantConf.categoryTypePackage){///二级分类下是套餐
            if (isOnBuffetMode) {
              if (!globalController.isBuffetSupportCategoryId(subItem.id)) {
                continue;
              }
            }
            final pageDishList = PageDishList(mainItem.id, subItem.id, subItem.displayMode, [], packageInfo: subItem.packageInfo);
            if (subItem.packageInfo !=null && subItem.packageInfo!.bgImage != null && subItem.packageInfo!.bgImage!.isNotEmpty) {
              pageDishList.bgUrl = subItem.packageInfo!.bgImage;
            } else if (subItem.bgImage != null && subItem.bgImage!.isNotEmpty){
              pageDishList.bgUrl = subItem.bgImage;
            } else {
              pageDishList.bgUrl = mainItem.bgImage;
            }
            _basePageDishDataList.add(pageDishList);
          }
        }
      }
    }
  }

  void updateMainListScroll(int index) {
    final maxScroll = mainListScrollController.position.maxScrollExtent;
    final currentOffset = mainListScrollController.offset;
    var expectOffset = index * 115.w - (1280.w - 135.w - 115.w)/2;

    if (currentOffset == 0 && expectOffset < 0) {
      return;
    }
    if (currentOffset == maxScroll && expectOffset > maxScroll) {
      return;
    }
    if (currentOffset < maxScroll && expectOffset > maxScroll)  {
      expectOffset = maxScroll;
    }
    if (currentOffset > 0 && expectOffset < 0) {
      expectOffset = 0;
    }
    mainListScrollController.animateTo(
      expectOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Timer? timer;
  Map<int, int> invalidCategoryMap = {};

  bool isValidCategoryId(int id) {
    return !invalidCategoryMap.containsKey(id);
  }

  StreamSubscription? _exitBuffetSubscription;

  @override
  void onInit() {
    mainCategoryInfoList = globalController.restaurantData.categoryInfos;
    if (globalController.isOnBuffetMode) {
      mainCategoryInfoList = [];
      for (int i=0; i<globalController.restaurantData.categoryInfos.length; i++) {
        final item = globalController.restaurantData.categoryInfos[i];
        if (globalController.isBuffetSupportCategoryId(item.id)) {
          mainCategoryInfoList.add(globalController.restaurantData.categoryInfos[i]);
        }
      }
    }

    _initBasePageDishDataList();

    _exitBuffetSubscription = eventBus.on<ExitBuffetEvent>().listen((ExitBuffetEvent event) {
      updatePageData();
    });

    super.onInit();

    pageController = PageController(initialPage: currentPageIndex, keepPage: true);
    mainListScrollController = ScrollController();

    timer = Timer.periodic(const Duration(seconds: 30), (Timer timer) {
      if (handleTimerCheckShouldUpdate()) {
        handlePageDishDataListUpdate(selectedMainCategoryId);
      }
    });

    handleTimerCheckShouldUpdate();
    List<PageDishList> dataList = [];
    for (var item in _basePageDishDataList) {
      if (invalidCategoryMap.containsKey(item.mainCategoryId)) {///不在服务时间内
        continue;
      }
      if (globalController.isOnBuffetMode) {
        if (globalController.isBuffetSupportCategoryId(item.mainCategoryId)) {
          if (globalController.isBuffetSupportCategoryId(item.subCategoryId)) {
            dataList.add(item);
          }
        }
      } else {
        dataList.add(item);
      }
    }
    pageDishDataList = dataList;

    for(int i=0; i<_basePageDishDataList.length; i++) {
      final pageDishList = _basePageDishDataList[i];
      if (pageDishList.bgUrl != null) {
        precacheImage(CachedNetworkImageProvider(pageDishList.bgUrl!, cacheManager: DefaultCacheManager()), Get.context!);
      }
    }
  }

  @override
  void onRestaurantDataUpdate(RefreshDataEvent event) {
    if (event.type == 1) {///库存上下架
      updatePageData();
      return;
    }
    mainCategoryInfoList = globalController.restaurantData.categoryInfos;
    if (globalController.isOnBuffetMode) {
      mainCategoryInfoList = [];
      for (int i=0; i<globalController.restaurantData.categoryInfos.length; i++) {
        final item = globalController.restaurantData.categoryInfos[i];
        if (globalController.isBuffetSupportCategoryId(item.id)) {
          mainCategoryInfoList.add(globalController.restaurantData.categoryInfos[i]);
        }
      }
    }

    _basePageDishDataList.clear();
    invalidCategoryMap.clear();
    _initBasePageDishDataList();

    handleTimerCheckShouldUpdate();
    List<PageDishList> dataList = [];
    for (var item in _basePageDishDataList) {
      if (invalidCategoryMap.containsKey(item.mainCategoryId)) {///不在服务时间内
        continue;
      }
      if (globalController.isOnBuffetMode) {
        if (globalController.isBuffetSupportCategoryId(item.mainCategoryId)) {
          if (globalController.isBuffetSupportCategoryId(item.subCategoryId)) {
            dataList.add(item);
          }
        }
      } else {
        dataList.add(item);
      }
    }
    pageDishDataList = dataList;

    refreshDataTimeObs(DateTime.now().millisecondsSinceEpoch);

    updatePageData();
  }

  @override
  void onReady() {
    handleDataOnReady();
    super.onReady();
  }

  void handleDataOnReady () {
    CategoryInfo? foundCategoryInfo;

    RestaurantTopLayoutInfo? restaurantTopLayoutInfo;
    var dataModel = Get.arguments;
    if (dataModel is RestaurantTopLayoutInfo) {
      restaurantTopLayoutInfo = dataModel;
    }

    if (restaurantTopLayoutInfo != null) {
      if (globalController.isOnBuffetMode) {
        for (var item in mainCategoryInfoList) {
          if (globalController.isBuffetSupportCategoryId(item.id) && !invalidCategoryMap.containsKey(item.id)) {///自助
            foundCategoryInfo = item;
            break;
          }
        }
      } else {
        for (var item in mainCategoryInfoList) {
          if (item.id == restaurantTopLayoutInfo.categoryId
              || (restaurantTopLayoutInfo.isBuffetButton == 1 && item.id == RestaurantConf.categoryBuffetId)) {///自助
            foundCategoryInfo = item;
            break;
          }
        }
      }
    } else if (globalController.isOnBuffetMode) {
      for (var item in mainCategoryInfoList) {
        if (globalController.isBuffetSupportCategoryId(item.id) && !invalidCategoryMap.containsKey(item.id)) {///自助
          foundCategoryInfo = item;
          break;
        }
      }
    }

    foundCategoryInfo ??= mainCategoryInfoList.first;

    if (invalidCategoryMap.containsKey(foundCategoryInfo.id)) {
      for (var item in mainCategoryInfoList) {
        if (!invalidCategoryMap.containsKey(item.id)) {
          foundCategoryInfo = item;
          break;
        }
      }
    }

    updateSelectedMainCategoryId(foundCategoryInfo!.id);
    if (foundCategoryInfo.categoryType == RestaurantConf.categoryTypeCategory) {
      if (globalController.isOnBuffetMode) {
        subCategoryInfoList = [];
        for(int i=0; i<foundCategoryInfo.children.length; i++) {
          if (globalController.isBuffetSupportCategoryId(foundCategoryInfo.children[i].id)) {
            subCategoryInfoList.add(foundCategoryInfo.children[i]);
          }
        }
      } else {
        subCategoryInfoList = foundCategoryInfo.children;
      }
      updateSelectedSubCategoryId(subCategoryInfoList.first.id);
    } else {
      subCategoryInfoList = [];
      updateSelectedSubCategoryId(foundCategoryInfo.id);
    }

    for(int i=0; i<pageDishDataList.length; i++) {
      final pageDishList = pageDishDataList[i];
      if (pageDishList.mainCategoryId == foundCategoryInfo.id && pageDishList.subCategoryId == selectedSubCategoryId) {
        currentPageIndex = i;
        break;
      }
    }

    pageController.jumpToPage(currentPageIndex);
    checkShouldShowPreNextBtn();
  }

  @override
  void onClose() {
    pageController.dispose();
    mainListScrollController.dispose();
    _isUpdatePageDataObs.close();
    _selectedMainCategoryIdObs.close();
    _selectedSubCategoryIdObs.close();
    isShowPreBtnObs.close();
    isShowNextBtnObs.close();
    timer?.cancel();

    _exitBuffetSubscription?.cancel();
    _exitBuffetSubscription = null;

    super.onClose();
  }

  void onMainTabClicked(CategoryInfo categoryInfo) {
    updateSelectedMainCategoryId(categoryInfo.id);
    for(var item in mainCategoryInfoList) {
      if (item.id == categoryInfo.id) {
        if (item.categoryType == RestaurantConf.categoryTypeCategory) {///有二级分类
          subCategoryInfoList = item.children;
          if (globalController.isOnBuffetMode) {///如果是套餐模式，需要找到有效的二级分类
            subCategoryInfoList = [];
            for(int i=0; i<item.children.length; i++) {
              if (globalController.isBuffetSupportCategoryId(item.children[i].id)) {
                subCategoryInfoList.add(item.children[i]);
              }
            }
            for(var subItem in subCategoryInfoList) {
              if (globalController.isBuffetSupportCategoryId(subItem.id)) {
                updateSelectedSubCategoryId(subItem.id);
                break;
              }
            }
          } else {
            updateSelectedSubCategoryId(subCategoryInfoList.first.id);
          }
        } else {
          subCategoryInfoList = [];
          updateSelectedSubCategoryId(item.id);
        }
      }
    }

    for(int i=0; i<pageDishDataList.length; i++) {
      final pageDishList = pageDishDataList[i];
      if (pageDishList.mainCategoryId == categoryInfo.id && pageDishList.subCategoryId == selectedSubCategoryId) {
        if ((i-currentPageIndex).abs() <= 1) {
          currentPageIndex = i;
          pageController.animateToPage(i,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,);
        } else {
          currentPageIndex = i;
          pageController.jumpToPage(currentPageIndex);
        }
        break;
      }
    }

    checkShouldShowPreNextBtn();
  }

  void onSubTabClicked(CategoryInfo categoryInfo) {
    updateSelectedSubCategoryId(categoryInfo.id);

    for(int i=0; i<pageDishDataList.length; i++) {
      final pageDishList = pageDishDataList[i];
      if (pageDishList.mainCategoryId == selectedMainCategoryId && pageDishList.subCategoryId == categoryInfo.id) {
         if ((i-currentPageIndex).abs() <= 1) {
           currentPageIndex = i;
           pageController.animateToPage(i,
             duration: const Duration(milliseconds: 300),
             curve: Curves.easeIn,);
         } else {
           currentPageIndex = i;
           pageController.jumpToPage(currentPageIndex);
         }
         break;
      }
    }

    checkShouldShowPreNextBtn();
  }

  void onPageChanged(int index) {
    if (currentPageIndex == index) return;
    final pageDishList = pageDishDataList[index];
    final lastPageDishList = pageDishDataList[currentPageIndex];

    if (pageDishList.mainCategoryId == lastPageDishList.mainCategoryId) {
      if (pageDishList.subCategoryId != lastPageDishList.subCategoryId) {
        updateSelectedSubCategoryId(pageDishList.subCategoryId);
      }
    } else {
      for(var mainItem in mainCategoryInfoList) {
        if (mainItem.id == pageDishList.mainCategoryId) {
          if (globalController.isOnBuffetMode) {
            subCategoryInfoList = [];
            for(int i=0; i<mainItem.children.length; i++) {
              if (globalController.isBuffetSupportCategoryId(mainItem.children[i].id)) {
                subCategoryInfoList.add(mainItem.children[i]);
              }
            }
          } else {
            subCategoryInfoList = mainItem.children;
          }

          updateSelectedMainCategoryId(pageDishList.mainCategoryId);
          updateSelectedSubCategoryId(pageDishList.subCategoryId);
        }
      }
    }
    currentPageIndex = index;

    checkShouldShowPreNextBtn();
  }

  void checkShouldShowPreNextBtn() {
    if (currentPageIndex == 0) {///已是第一页了
      isShowPreBtnObs(false);
      isShowNextBtnObs(true);
      if (pageDishDataList.length <= 1) {
        isShowNextBtnObs(false);
      }
    } else if(currentPageIndex == pageDishDataList.length -1) {///已是最后页了
      isShowPreBtnObs(true);
      isShowNextBtnObs(false);
    } else {
      isShowPreBtnObs(true);
      isShowNextBtnObs(true);
    }
  }

  void onPreBtnClicked() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,);
  }

  void onNextBtnClicked() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,);
  }

  ///步骤型套餐被点击了
  void onPackageItemClicked(int mainCategoryId, PackageInfo item) {
    if (!isCanLoadingPage()) return;
    if (!item.available) {
      showToast(CustomLocalizations.text("sold_out"));
      return;
    }

    Get.toNamed(Routes.selectSetMenuPage, arguments: item, parameters: {
      "mainCategoryId" : mainCategoryId.toString()
    });
  }

  ///集合型套餐被点击了
  void onCollectivePackageItemClicked(int mainCategoryId, PackageInfo packageInfo) {
    if (!isCanLoadingDialog()) return;
    if (!packageInfo.available) {
      showToast(CustomLocalizations.text("sold_out"));
      return;
    }

    if (packageInfo.minSalesQuantity != null) {///套餐最小销售数量，null表示没有限制-非空时用于区分数量选择
      showPackageNumberSelectDialog(mainCategoryId, packageInfo);
    } else {
      List<DishOrderModel> dishOrderModelList = [];
      for(int i=0; i<packageInfo.dishList.length; i++) {
        final dishItem = packageInfo.dishList[i];
        dishOrderModelList.add(DishOrderModel(1, dishItem, []));
      }
      final packageOrderModel = PackageOrderModel(1, packageInfo, mainCategoryId, dishOrderModelList);
      globalController.addToShoppingCart(packageOrderModel);///集合型

      for(int i=0; i<packageInfo.dishList.length; i++) {
        final dishItem = packageInfo.dishList[i];
        if (dishItem.thumbnailUrl != null) {
          addToShoppingCartAnim(dishItem.thumbnailUrl!);
          break;
        }
      }
    }
  }

  OverlayEntry? _overlayEntry;
  void addToShoppingCartAnim(String imgUrl) {
    _overlayEntry ??= OverlayEntry(builder: (_) {
      return FlyToPosWidget(
        startPosition: Offset((1280.w-64.w)/2, (800.h - 64.w)/2 - 40.h),
        endPosition: Offset(1200.w, 460.h),
        imgUrl: imgUrl,
      );
    });
    Overlay.of(Get.context!).insert(_overlayEntry!);
    Future.delayed(const Duration(milliseconds: 800), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  void onBuffetItemClicked(BuffetCategoryInfo item) {
    if (!isCanLoadingPage()) return;
    Get.toNamed(Routes.buffetConfirmPage, arguments: item)?.then((value){
      if (value == true) {
        globalController.isOnBuffetMode = true;
        globalController.buffetCategoryInfo = item;
        globalController.reqOrderDetail();

        if (globalController.isOnBuffetMode) {
          mainCategoryInfoList = [];
          for (int i=0; i<globalController.restaurantData.categoryInfos.length; i++) {
            final item = globalController.restaurantData.categoryInfos[i];
            if (globalController.isBuffetSupportCategoryId(item.id)) {
              mainCategoryInfoList.add(globalController.restaurantData.categoryInfos[i]);
            }
          }
        }

        _basePageDishDataList.clear();
        invalidCategoryMap.clear();
        _initBasePageDishDataList();

        handleTimerCheckShouldUpdate();

        handlePageDishDataListUpdate(null);
      }
    });
  }

  ///仅在invalidCategoryMap变更或者进入自助模式时使用
  ///会改变selectedMainCategoryId和selectedSubCategoryId
  void handlePageDishDataListUpdate(int? useMainCategoryId) {
    List<PageDishList> dataList = [];
    for (var item in _basePageDishDataList) {
      if (invalidCategoryMap.containsKey(item.mainCategoryId)) {///不在服务时间内
        continue;
      }
      if (globalController.isOnBuffetMode) {
        if (globalController.isBuffetSupportCategoryId(item.mainCategoryId)) {
          if (globalController.isBuffetSupportCategoryId(item.subCategoryId)) {
            dataList.add(item);
          }
        }
      } else {
        dataList.add(item);
      }
    }
    pageDishDataList = dataList;

    var mainCategorySelectedItemId = pageDishDataList.first.mainCategoryId;
    if (useMainCategoryId != null && invalidCategoryMap[useMainCategoryId] == null) {///check is fit
      mainCategorySelectedItemId = useMainCategoryId;
    }

    updateSelectedMainCategoryId(mainCategorySelectedItemId);

    for(var item in mainCategoryInfoList) {
      if (item.id == mainCategorySelectedItemId) {
        if (item.categoryType == RestaurantConf.categoryTypeCategory) {///是分类-才有子项children-即二级分类表
          subCategoryInfoList = item.children;
          if (globalController.isOnBuffetMode) {
            subCategoryInfoList = [];
            for(int i=0; i<item.children.length; i++) {
              if (globalController.isBuffetSupportCategoryId(item.children[i].id)) {
                subCategoryInfoList.add(item.children[i]);
              }
            }

            for(var subItem in subCategoryInfoList) {
              if (globalController.isBuffetSupportCategoryId(subItem.id)) {
                updateSelectedSubCategoryId(subItem.id);
                break;
              }
            }
          } else {
            updateSelectedSubCategoryId(subCategoryInfoList.first.id);
          }
        } else {
          subCategoryInfoList = [];
          updateSelectedSubCategoryId(item.id);
        }
        break;
      }
    }

    for(int i=0; i<pageDishDataList.length; i++) {
      final pageDishList = pageDishDataList[i];
      if (pageDishList.mainCategoryId == mainCategorySelectedItemId && pageDishList.subCategoryId == selectedSubCategoryId) {
        if ((i-currentPageIndex).abs() <= 1) {
          currentPageIndex = i;
          pageController.animateToPage(i,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,);
        } else {
          currentPageIndex = i;
          pageController.jumpToPage(currentPageIndex);
        }
        break;
      }
    }

    checkShouldShowPreNextBtn();

    updatePageData();
  }

  ///更新一级分类是否在服务时间内，并返回invalidCategoryMap是否存在变更
  bool handleTimerCheckShouldUpdate() {
    final currentDateTime = DateTime.now();
    bool isInvalidCategoryMapUpdate = false;
    for(var mainItem in mainCategoryInfoList) {
      if (mainItem.startHour !=null && mainItem.startMinute !=null && mainItem.endHour != null && mainItem.endMinute != null) {

        final startDateTime = DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day, mainItem.startHour!, mainItem.startMinute!);
        final endDateTime = DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day, mainItem.endHour!, mainItem.endMinute!);

        if (currentDateTime.isAfter(startDateTime) && currentDateTime.isBefore(endDateTime)) {
          if (invalidCategoryMap[mainItem.id] != null) {
            invalidCategoryMap.remove(mainItem.id);
            isInvalidCategoryMapUpdate = true;
          }
        } else {
          if (invalidCategoryMap[mainItem.id] == null) {
            invalidCategoryMap[mainItem.id] = mainItem.id;
            isInvalidCategoryMapUpdate = true;
          }
        }
      }
    }

    return isInvalidCategoryMapUpdate;
  }

}

