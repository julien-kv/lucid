import 'package:get/get.dart';

import '../modules/challenges/bindings/challenges_binding.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/journal_detail/bindings/journal_detail_binding.dart';
import '../modules/journal_detail/views/journal_detail_view.dart';
import '../modules/journals/bindings/journals_binding.dart';
import '../modules/launch/bindings/launch_binding.dart';
import '../modules/launch/views/launch_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/microjournal/bindings/microjournal_binding.dart';
import '../modules/microjournal/views/microjournal_view.dart';
import '../modules/new_entry/bindings/new_entry_binding.dart';
import '../modules/new_entry/views/new_entry_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/signin/bindings/signin_binding.dart';
import '../modules/signin/views/signin_view.dart';
import '../modules/weekly_summary/bindings/weekly_summary_binding.dart';
import '../modules/weekly_summary/views/weekly_summary_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LAUNCH;

  static final routes = [
    GetPage(
      name: _Paths.LAUNCH,
      page: () => const LaunchView(),
      binding: LaunchBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.SIGNIN,
      page: () => const SigninView(),
      binding: SigninBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.MAIN,
      page: () => const MainView(),
      bindings: [
        MainBinding(),
        HomeBinding(),
        JournalsBinding(),
        ChallengesBinding(),
        ProfileBinding(),
      ],
    ),
    GetPage(
      name: _Paths.NEW_ENTRY,
      page: () => const NewEntryView(),
      binding: NewEntryBinding(),
    ),
    GetPage(
      name: _Paths.JOURNAL_DETAIL,
      page: () => const JournalDetailView(),
      binding: JournalDetailBinding(),
    ),
    GetPage(
      name: _Paths.WEEKLY_SUMMARY,
      page: () => const WeeklySummaryView(),
      binding: WeeklySummaryBinding(),
    ),
    GetPage(
      name: _Paths.MICROJOURNAL,
      page: () => const MicrojournalView(),
      binding: MicrojournalBinding(),
    ),
  ];
}
