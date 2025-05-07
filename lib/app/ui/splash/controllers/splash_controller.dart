

import 'package:get/get.dart';
import '../../../base/config/base_conf.dart';
import '../../../base/ui/base_controller.dart';
import '../../../data/local/preference/preference_manager.dart';
import '../../../data/repository/data_repository.dart';
import '../../../routes/app_pages.dart';


class SplashController extends BaseController{
  final DataRepository _dataRepository = Get.find(tag: (DataRepository).toString());
  final PreferenceManager _preferenceManager = Get.find(tag: (PreferenceManager).toString());

  void checkUserLoginAndDoNext() async{
    if (await isUserLogin()) {
      Get.offNamed(Routes.mainPage);
    } else {
      Get.offNamed(Routes.loginPage);
    }
  }


  Future<bool> isUserLogin() async{
    final String accessToken = await _preferenceManager.getString(PreferenceManager.userToken);
    if (accessToken.isNotEmpty) {
      BaseConf.token = accessToken;
      return true;
    }
    return false;
  }

}