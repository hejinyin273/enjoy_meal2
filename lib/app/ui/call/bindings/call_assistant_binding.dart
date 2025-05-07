import 'package:get/get.dart';

import '../controllers/call_assistant_controller.dart';

class CallAssistantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CallAssistantController>(
          () => CallAssistantController(),
      fenix: false,
    );
  }
}