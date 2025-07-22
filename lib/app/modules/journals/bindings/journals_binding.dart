import 'package:get/get.dart';

import '../controllers/journals_controller.dart';

class JournalsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JournalsController>(() => JournalsController());
  }
}
