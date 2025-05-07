
import 'package:get/get.dart';
import '../../global_controller.dart';
import '../controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    /*Get.lazyPut<GlobalController>(
          () => GlobalController(),
      fenix: true,
    );*/

    Get.lazyPut<MainController>(
          () => MainController(),
      fenix: true,
    );
  }
}