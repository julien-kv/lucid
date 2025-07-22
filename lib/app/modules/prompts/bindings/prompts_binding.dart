import 'package:get/get.dart';

import '../controllers/prompts_controller.dart';

class PromptsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PromptsController>(
      () => PromptsController(),
    );
  }
}
