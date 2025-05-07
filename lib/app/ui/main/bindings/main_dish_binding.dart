
import 'package:get/get.dart';
import '../controllers/main_dish_controller.dart';

class MainDishBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainDishController>(
          () => MainDishController(),
      fenix: false,
    );
  }
}