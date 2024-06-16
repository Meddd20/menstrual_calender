import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/widgets.dart';
import 'package:periodnpregnancycalender/app/modules/onboarding/views/onboarding2_view.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class OnboardingController extends GetxController {
  List<Map<String, dynamic>> periods = [];
  var purposes = 0.obs;
  Rx<DateTime?> birthday = Rx<DateTime?>(null);
  var menstruationCycle = 28.obs;
  var periodLast = 7.obs;
  var lastPeriodDate = DateTime.now().obs;
  var pregnantWeek = 0.obs;
  var datePickerController = DateRangePickerController().obs;

  @override
  void onInit() {
    // purposes = 0.obs;
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

  void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    periods = [];

    for (var selectedRange in args.value) {
      if (selectedRange is PickerDateRange) {
        var start = selectedRange.startDate;
        var end = selectedRange.endDate;
        String formattedEndDate = "";

        if (start != null) {
          if (end == null) {
            DateTime endDatePrediction =
                start.add(Duration(days: periodLast.value));
            formattedEndDate =
                "${endDatePrediction.year}-${endDatePrediction.month.toString().padLeft(2, '0')}-${endDatePrediction.day.toString().padLeft(2, '0')}";
          } else {
            formattedEndDate =
                "${end.year}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}";
          }

          var formattedStartDate =
              "${start.year}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}";

          periods.add({
            'first_period': "$formattedStartDate",
            'last_period': "$formattedEndDate",
          });
        }
      }
    }

    periods.sort((a, b) => a['first_period']!.compareTo(b['first_period']!));

    print(periods);
    print('Number of selected date ranges: ${periods.length}');
  }

  void validateBirthday() {
    DateTime today = DateTime.now();
    DateTime? birthDate = birthday.value;

    if (birthDate != null) {
      Get.to(() => Onboarding2View());
    } else {
      Get.showSnackbar(
          Ui.ErrorSnackBar(message: "Please select your date of birth."));
      print("Error: Birthday is null.");
    }
  }

  void validateLastPeriod() {
    if (periods.isEmpty) {
      Get.showSnackbar(Ui.ErrorSnackBar(
          message: "Please select at least one period range."));
      print("Error: Please select at least one period range.");
    } else {
      Get.toNamed(Routes.REGISTER);
    }
  }
}
