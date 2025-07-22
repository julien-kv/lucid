import 'package:get/get.dart';

import '../controllers/microjournal_controller.dart';

class MicrojournalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MicrojournalController>(() => MicrojournalController());
  }
}
