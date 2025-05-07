

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../base/ui/base_view.dart';
import '../../../routes/app_pages.dart';
import '../controllers/splash_controller.dart';

class SplashView extends BaseView<SplashController>{
  SplashView({super.key}) {
    controller.checkUserLoginAndDoNext();
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Widget pageContent(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        child: body(context),
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return Center(
      /*child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: (){
            Get.toNamed(Routes.buffetConfirmPage);
          }, child: const Text("mainPage")),
          ElevatedButton(onPressed: (){
            Get.offNamed(Routes.loginPage);
          }, child: const Text("loginPage")),
        ],
      ),*/
    );
  }

}