import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/modules/home/views/home_view.dart';
import 'package:periodnpregnancycalender/app/modules/insight/views/insight_view.dart';
import 'package:periodnpregnancycalender/app/modules/profile/views/profile_view.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/views/analysis_view.dart';

class NavigationMenuController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [HomeView(), AnalysisView(), InsightView(), ProfileView()];
}
