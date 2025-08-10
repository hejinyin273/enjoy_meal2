
import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:enjoy_meal/app/base/data/model/download_listener.dart';
import 'package:enjoy_meal/app/base/utils/android_helper.dart';
import 'package:enjoy_meal/app/local/custom_localizations.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart' as pkg;
import 'package:path_provider/path_provider.dart';
import '../../../base/config/base_conf.dart';
import '../../../base/data/event_bus.dart';
import '../../../base/data/protocol/response/base_resp.dart';
import '../../../base/utils/default_cache_manager.dart';
import '../../../base/utils/md5_util.dart';
import '../../../data/local/preference/preference_manager.dart';
import '../../../data/model/language.dart';
import '../../../data/model/load_state.dart';
import '../../../data/model/restaurant_data.dart';
import '../../../data/protocol/response/app_version_resp.dart';
import '../../../data/protocol/response/order_detail_resp.dart';
import '../../../routes/app_pages.dart';
import 'custom_base_controller.dart';
import 'package:enjoy_meal/app/config/constants.dart';

class MainController extends CustomBaseController  {

  final _languageObs = Language.jp.obs;
  Language get selectedLanguage => _languageObs.value;
  updateSelectedLanguage(Language language) {
    Conf.selectedLanguage = language;
    _languageObs(language);
  }

  final loadingTipObs = "".obs;
  final _loadInitStateObs = LoadState.loading.obs;
  LoadState get loadInitState => _loadInitStateObs.value;
  final isOnAppUpgradeMode = false.obs;

  LoadState? _loadUpgradeVersionState;
  LoadState? _loadRestaurantInfoState;
  LoadState? _loadOrderDetailState;

  bool _isOnLoadingOrderDetail = false;

  late String? bgImgUrl;

  CancelToken? downloadCancelToken;
  AppVersionResp? newAppVersionResp;
  DownloadListener? _downloadListener;
  final btnTipMessageObs = "".obs;
  final _progressController = 100.obs;
  int get progress => _progressController.value;
  updateProgress(int value) => _progressController(value);

  OrderDetailResp? orderDetailResp;

  StreamSubscription? _helperInstallSubscription;
  int? _helperInstallStatus;

  StreamSubscription? _printerEventSubscription;

  StreamSubscription? _appUpgradeSubscription;

  @override
  Future<void> onInit() async {
    super.onInit();
    AndroidHelper.checkAndInstallHelper();

    loadingTipObs(CustomLocalizations.text("loading_please_wait"));
    btnTipMessageObs(CustomLocalizations.text("check_update"));

    _downloadListener = DownloadListener(
      onProgress: _onProgress,
      onSuccess: _onSuccess,
      onFailed: _onFailed,
      onPaused: _onPaused,
      onUpdate: _onUpdate, );

    _helperInstallStatus = null;
    _helperInstallSubscription = eventBus.on<InstallHelperStatus>().listen((InstallHelperStatus event) async{
      logger.i("InstallHelperStatus() status=${event.status}");
      _helperInstallStatus = event.status;
      reqUpgradeVersionInfo();
      _helperInstallSubscription?.cancel();
      _helperInstallSubscription = null;
    });

    _appUpgradeSubscription = eventBus.on<MainInitEvent>().listen((MainInitEvent event) async{
      logger.i("--MainInitEvent---${Get.currentRoute}");
      if (Get.currentRoute.startsWith(Routes.mainPage) && downloadCancelToken == null) {
        loadingTipObs(CustomLocalizations.text("loading_please_wait"));
        btnTipMessageObs(CustomLocalizations.text("check_update"));
        updateProgress(0);
        reqUpgradeVersionInfo();
      }
    });

    _printerEventSubscription = eventBus.on<String>().listen((String event) async{
      logger.i("PrinterEventSub() event=$event");
      if (event.startsWith("PrinterConnected")) {
        var events = event.split("_");
        if (events.length >= 3) {
          preferenceManager.setString(PreferenceManager.printerConnInfo, event);
          globalController.printerConnInfo = event;

          AndroidHelper.isOnPrinterSearching().then((value) {
            if (value) {
              AndroidHelper.stopSearchPrinters();
            }
          });
        }
      }
    });

    preferenceManager.getString(PreferenceManager.printerConnInfo, defaultValue: "").then((value) {
      globalController.printerConnInfo = value;
    });

  }

  @override
  void onRestaurantDataUpdate(RefreshDataEvent event) {
    _loadInitStateObs(LoadState.loading);
    _loadInitStateObs(LoadState.success);
  }

  @override
  void onClose() {
    _languageObs.close();
    loadingTipObs.close();
    isOnAppUpgradeMode.close();
    _loadInitStateObs.close();
    btnTipMessageObs.close();
    _progressController.close();

    _printerEventSubscription?.cancel();
    _printerEventSubscription = null;

    _helperInstallSubscription?.cancel();
    _helperInstallSubscription = null;
    _appUpgradeSubscription?.cancel();
    _appUpgradeSubscription = null;
    super.onClose();
  }

  void onStartBtnClicked() {
    if (LoadState.success == loadInitState) {
      if (globalController.userType != RestaurantConf.userTypeUser) {
        Get.toNamed(Routes.cookingManagerPage);
      } else {
        //Get.toNamed(Routes.selectDinersPage);
        reqOrderDetailDirect();
      }
    }
  }

  void onNetErrRetryClicked() {
    if (LoadState.success != _loadUpgradeVersionState) {
      reqUpgradeVersionInfo();
    } else if (LoadState.success != _loadRestaurantInfoState) {
      reqRestaurantInfo();
    } else if (LoadState.success != _loadOrderDetailState) {
      reqOrderDetail();
    }
  }

  void handleResCache(RestaurantData restaurantData) async{
    try {
      String loadingTip = CustomLocalizations.text("on_loading_bg_img");
      for(int i=0; i<restaurantData.resourceUrls.length; i++) {
        final url = restaurantData.resourceUrls[i].toString();
        if (url.startsWith("http")) {
          //var file = await DefaultCacheManager().getSingleFile(url);
          loadingTipObs("$loadingTip(${i+1}/${restaurantData.resourceUrls.length})");
          var fileInfo = await DefaultCacheManager().downloadFile(url);
          logger.i("handleResCache() file.path=${fileInfo.file.path}");
        }
      }
    } catch (err) {
      logger.e("handleResCache() err=$err");
    } finally {
      onResCacheDone(restaurantData);
    }
  }

  void onResCacheDone(RestaurantData restaurantData) async{
    bgImgUrl = restaurantData.restaurantBaseInfo.homeBgImage;
    _loadInitStateObs(LoadState.success);

    if (globalController.userType == RestaurantConf.userTypeUser) {
      if (orderDetailResp != null) {///已有订单
        globalController.handleOrderDetailUpdate(orderDetailResp);
        if (globalController.isOnBuffetMode) {///是自助订单
          Get.toNamed(Routes.subDishPage);
        } else {
          Get.toNamed(Routes.mainDishPage);
        }
      }
    }

  }

  void reqRestaurantInfo() {
    _loadInitStateObs(LoadState.loading);
    dataRepository.reqRestaurantInfo().then((BaseResp baseResp) async{
      if(baseResp.isSuccessWithData()) {
        final restaurantData = RestaurantData.fromJson(baseResp.data);
        globalController.initData(restaurantData);
        BaseConf.isInitDone = true;
        _loadRestaurantInfoState = LoadState.success;
        if (globalController.userType == RestaurantConf.userTypeUser) {
          reqOrderDetail();
        } else {
          handleResCache(globalController.restaurantData);
        }
        globalController.autoConnectPrinter();
        globalController.startPrinterEscTimer();
      } else {
        showApiErrToast(baseResp.status, baseResp.message);
        _loadInitStateObs(LoadState.failed);
      }
    }, onError:(err) {
      handleException(err);
      _loadInitStateObs(LoadState.failed);
    } );
  }

  /*
    订单详细接口
    没下单返回null
    座位订单 orderItems.isEmpty()==true
    自助餐orderItems.filter(o->o.primaryCategoryId==-1).anymatch==true
    orderItems.isNotEmpty()==true 就是有菜品/自助餐订单
   */
  void reqOrderDetail() {
    _loadInitStateObs(LoadState.loading);
    dataRepository.reqOrderDetail(globalController.currentTableId.toString()).then((BaseResp baseResp) async{
      if(baseResp.isSuccess()) {
        if (baseResp.data != null) {///已有订单
          orderDetailResp = OrderDetailResp.fromJson(baseResp.data);
        }
        handleResCache(globalController.restaurantData);
        _loadOrderDetailState = LoadState.success;
      } else {
        showApiErrToast(baseResp.status, baseResp.message);
        _loadInitStateObs(LoadState.failed);
      }
    }, onError:(err) {
      handleException(err);
      _loadInitStateObs(LoadState.failed);
    } );
  }

  void reqOrderDetailDirect() {
    if (_isOnLoadingOrderDetail) return;
    _isOnLoadingOrderDetail = true;
    dataRepository.reqOrderDetail(globalController.currentTableId.toString()).then((BaseResp baseResp) async{
      if(baseResp.isSuccess()) {
        if (baseResp.data != null) {///已有订单
          orderDetailResp = OrderDetailResp.fromJson(baseResp.data);
          globalController.handleOrderDetailUpdate(orderDetailResp);

          if (globalController.isOnBuffetMode) {///是自助订单
            Get.toNamed(Routes.subDishPage);
          } else {
            Get.toNamed(Routes.mainDishPage);
          }
        } else {
          orderDetailResp = null;
          globalController.handleOrderDetailUpdate(null);
          Get.toNamed(Routes.selectDinersPage);
        }
        _isOnLoadingOrderDetail = false;
      } else {
        showApiErrToast(baseResp.status, baseResp.message);
        _isOnLoadingOrderDetail = false;
      }
    }, onError:(err) {
      handleException(err);
      _isOnLoadingOrderDetail = false;
    } );
  }

  _onProgress(String fileId, int count, int total) async{
    int progress = count * 100 ~/total;
    logger.i("onProgress()----->>>>> fileId=$fileId, count=$count, total=$total, progress=$progress");
    updateProgress(progress);
    btnTipMessageObs(CustomLocalizations.text("updating"));
  }

  _onSuccess(String fileId, String filePath) async{
    logger.i("onSuccess() fileId=$fileId");
    btnTipMessageObs(CustomLocalizations.text("experience_now"));
    downloadCancelToken = null;
    final fileMD5 = await Md5Util.getFileMD5(filePath);
    await preferenceManager.setString(PreferenceManager.appFileMd5, fileMD5);
    if (0 == _helperInstallStatus) {
      AndroidHelper.handleHostInstall(filePath);
    } else {
      AndroidHelper.installApk(filePath);
    }
  }

  _onFailed(String fileId, String msg) async{
    logger.i("onFailed() fileId=$fileId *** msg=$msg");
    downloadCancelToken = null;
    showToast(CustomLocalizations.text("download_failed"));
    btnTipMessageObs(CustomLocalizations.text("continue"));
  }

  _onPaused(String fileId) async{
    logger.i("onPaused() fileId=$fileId");
    downloadCancelToken = null;
    btnTipMessageObs(CustomLocalizations.text("continue"));
  }

  _onUpdate(String fileId) async{

  }

  bool _isOnLoadingCheck = false;
  void onCheckAppUpgradeBtnClick() {
    if (_isOnLoadingCheck) return;
    _isOnLoadingCheck = true;
    Future.delayed(const Duration(milliseconds: 1200), (){
      _isOnLoadingCheck = false;
    });

    if (downloadCancelToken != null) {
      downloadCancelToken!.cancel();
      downloadCancelToken = null;
    } else {
      _handleAppVersionUpgrade(newAppVersionResp!);
    }
  }

  void _handleAppVersionUpgrade(AppVersionResp appVersionResp) async{
    if (isOnAppUpgrade) return;
    isOnAppUpgrade = true;
    final dir = await getDownloadsDirectory();

    final fileUrlMD5 = Md5Util.generateMd5(appVersionResp.downloadUrl);
    final filePath = "${dir!.path}/${fileUrlMD5}_${appVersionResp.appVersion}.apk";

    final appFile = File(filePath);
    if (appFile.existsSync()) {
      final appFileMd5 = await preferenceManager.getString(PreferenceManager.appFileMd5, defaultValue: "");
      if (appFileMd5.isNotEmpty) {
        final fileMD5 = await Md5Util.getFileMD5(filePath);
        if (appFileMd5 == fileMD5) {///已存在
          isOnAppUpgrade = false;
          btnTipMessageObs(CustomLocalizations.text("experience_now"));
          if (0 == _helperInstallStatus) {
            AndroidHelper.handleHostInstall(filePath);
          } else {
            AndroidHelper.installApk(filePath);
          }
          return;
        }
      }
    }

    await Future.delayed(const Duration(microseconds: 1000), (){
      isOnAppUpgrade = false;
    });

    if (downloadCancelToken != null) {
      downloadCancelToken!.cancel();
      await Future.delayed(const Duration(microseconds: 1500));
      downloadCancelToken = null;
      await Future.delayed(const Duration(microseconds: 1000));
    }

    downloadCancelToken = CancelToken();
    dataRepository.doDownload(appVersionResp.downloadUrl, filePath, fileId: "fileId",
        cancelToken: downloadCancelToken!, downloadListener: _downloadListener);

  }

  bool isOnAppUpgrade = false;
  void reqUpgradeVersionInfo() async {
    if (isOnAppUpgrade) return;
    isOnAppUpgrade = true;
    pkg.PackageInfo packageInfo = await pkg.PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;
    _loadInitStateObs(LoadState.loading);
    dataRepository.reqLatestVersion().then((BaseResp baseResp) async{
      if (baseResp.isSuccess()) {
        if (baseResp.data != null && baseResp.data["appVersion"] != null) {
          var appVersionResp = AppVersionResp.fromJson(baseResp.data);
          if (currentVersion != appVersionResp.appVersion) {///new version
            newAppVersionResp = appVersionResp;
            _loadUpgradeVersionState = LoadState.success;
            isOnAppUpgradeMode(true);
            isOnAppUpgrade = false;
            _handleAppVersionUpgrade(appVersionResp);
            return;
          }
        }

        isOnAppUpgrade = false;
        ///is already new version
        _loadUpgradeVersionState = LoadState.success;
        reqRestaurantInfo();

      } else {
        showApiErrToast(baseResp.status, baseResp.message);
        _loadInitStateObs(LoadState.failed);
        isOnAppUpgrade = false;
      }
    }, onError:(err) {
      handleException(err);
      _loadInitStateObs(LoadState.failed);
      isOnAppUpgrade = false;
    } );
  }
}

