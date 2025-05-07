
import 'package:get/get.dart';
import '../controllers/select_diners_controller.dart';

class SelectDinersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectDinersController>(
          () => SelectDinersController(),
      fenix: false,
    );
  }
}