
import 'package:get/get.dart';
import '../controllers/sub_dish_controller.dart';

class SubDishBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubDishController>(
          () => SubDishController(),
      fenix: false,
    );
  }
}