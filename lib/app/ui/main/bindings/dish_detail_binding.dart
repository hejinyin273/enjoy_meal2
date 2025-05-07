
import 'package:enjoy_meal/app/ui/main/controllers/dish_detail_controller.dart';
import 'package:get/get.dart';

class DishDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DishDetailController>(
          () => DishDetailController(),
      fenix: false,
    );
  }
}