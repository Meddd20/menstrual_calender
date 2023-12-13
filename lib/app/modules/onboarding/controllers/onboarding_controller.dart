import 'package:get/get.dart';

class OnboardingController extends GetxController {
  var selectedDate = DateTime.now().obs;
  var menstruationCycle = 0.obs;
  var periodLast = 0.obs;
  var periodHistory = <DateTime>[].obs;
  var lastPeriodDate = DateTime.now().obs;
  var pregnantWeek = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
