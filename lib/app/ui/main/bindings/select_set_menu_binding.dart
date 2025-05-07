
import 'package:get/get.dart';
import '../controllers/select_set_menu_controller.dart';

class SelectSetMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectSetMenuController>(
          () => SelectSetMenuController(),
      fenix: false,
    );
  }
}