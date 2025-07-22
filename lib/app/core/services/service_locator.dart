import 'package:get/get.dart';

import '../../data/services/auth_service.dart';
import '../../data/services/challenge_service.dart';
import '../../data/services/journal_service.dart';
import '../../data/services/prompt_service.dart';

class ServiceLocator {
  static Future<void> init() async {
    // Register services with GetX
    Get.lazyPut<AuthService>(() => AuthService(), fenix: true);
    Get.lazyPut<JournalService>(() => JournalService(), fenix: true);
    Get.lazyPut<PromptService>(() => PromptService(), fenix: true);
    Get.lazyPut<ChallengeService>(() => ChallengeService(), fenix: true);

    // Initialize critical services
    await Get.find<AuthService>().onInit();
  }

  static void registerServices() {
    Get.put<AuthService>(AuthService());
    Get.put<JournalService>(JournalService());
    Get.put<PromptService>(PromptService());
    Get.put<ChallengeService>(ChallengeService());
  }
}
