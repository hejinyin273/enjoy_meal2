
import 'package:get/get.dart';
import '../controllers/buffet_confirm_controller.dart';

class BuffetConfirmBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuffetConfirmController>(
          () => BuffetConfirmController(),
      fenix: false,
    );
  }
}