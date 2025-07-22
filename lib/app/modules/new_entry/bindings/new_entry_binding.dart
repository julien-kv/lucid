import 'package:get/get.dart';

import '../controllers/new_entry_controller.dart';

class NewEntryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewEntryController>(() => NewEntryController());
  }
}
