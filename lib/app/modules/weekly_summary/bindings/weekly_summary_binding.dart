import 'package:get/get.dart';

import '../controllers/weekly_summary_controller.dart';

class WeeklySummaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WeeklySummaryController>(() => WeeklySummaryController());
  }
}
