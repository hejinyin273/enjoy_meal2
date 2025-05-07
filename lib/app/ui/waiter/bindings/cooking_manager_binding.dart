
import 'package:get/get.dart';
import '../controllers/cooking_manager_controller.dart';

class CookingManagerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CookingManagerController>(
          () => CookingManagerController(),
      fenix: false,
    );
  }
}