import 'package:get/get.dart';

import '../modules/analysis/bindings/analysis_binding.dart';
import '../modules/analysis/views/analysis_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/daily_log_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/insight/bindings/insight_binding.dart';
import '../modules/insight/views/insight_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/navigation_menu/bindings/navigation_menu_binding.dart';
import '../modules/navigation_menu/views/navigation_menu_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/pin/bindings/pin_binding.dart';
import '../modules/pin/views/pin_view.dart';
import '../modules/pregnancy_tools/bindings/pregnancy_tools_binding.dart';
import '../modules/pregnancy_tools/views/pregnancy_tools_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static get INITIAL => Routes.NAVIGATION_MENU;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: "/daily-log",
      page: () => DailyLogView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.NAVIGATION_MENU,
      page: () => NavigationMenuView(),
      binding: NavigationMenuBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.INSIGHT,
      page: () => const InsightView(),
      binding: InsightBinding(),
    ),
    GetPage(
      name: _Paths.ANALYSIS,
      page: () => const AnalysisView(),
      binding: AnalysisBinding(),
    ),
    GetPage(
      name: _Paths.PREGNANCY_TOOLS,
      page: () => const PregnancyToolsView(),
      binding: PregnancyToolsBinding(),
    ),
    GetPage(
      name: _Paths.PIN,
      page: () => PinView(mode: null),
      binding: PinBinding(),
    ),
  ];
}
