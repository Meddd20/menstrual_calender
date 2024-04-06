import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/modules/onboarding/views/onboarding2_view.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class OnboardingController extends GetxController {
  late List<Map<String, dynamic>> periods;
  var purposes = 0.obs;
  Rx<DateTime?> birthday = Rx<DateTime?>(null);
  var menstruationCycle = 28.obs;
  var periodLast = 7.obs;
  var lastPeriodDate = DateTime.now().obs;
  var pregnantWeek = 0.obs;
  var datePickerController = DateRangePickerController().obs;

  @override
  void onInit() {
    purposes = 0.obs;
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
          if (periods.isNotEmpty) {
            var lastSelectedStartDate =
                DateTime.parse(periods.last['first_period']!);
            var minAllowedStartDate =
                lastSelectedStartDate.add(Duration(days: 20));

            if (start.isBefore(minAllowedStartDate)) {
              // Clear the selection using the datePickerController
              Get.snackbar(
                'Error',
                'Selected start date must be at least 20 days after the last selected start date',
                snackPosition: SnackPosition.TOP,
                duration: Duration(seconds: 3),
              );
              datePickerController.value.selectedRanges = <PickerDateRange>[];
              return;
            }
          }

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

          // Add the period to the list
          periods.add({
            'first_period': "$formattedStartDate",
            'last_period': "$formattedEndDate",
          });
        }
      }
    }

    // Sort the list of periods based on the 'first_period' field in ascending order
    periods.sort((a, b) => a['first_period']!.compareTo(b['first_period']!));

    // Print the sorted list of periods and the number of selected date ranges
    print(periods);
    print('Number of selected date ranges: ${periods.length}');
  }

  void validateBirthday() {
    DateTime today = DateTime.now();
    DateTime? birthDate = birthday.value;

    if (birthDate != null) {
      int age = today.year - birthDate.year;

      if (birthDate.month > today.month ||
          (birthDate.month == today.month && birthDate.day > today.day)) {
        age--;
      }

      if (age < 18) {
        print("Error: Age must be at least 18 years old.");
      } else {
        Get.to(() => Onboarding2View());
      }
    } else {
      print("Error: Birthday is null.");
    }
  }

  void validateLastPeriod() {
    if (periods.isEmpty) {
      print("Error: Please select at least one period range.");
    } else {
      Get.toNamed(Routes.REGISTER);
    }
  }
}
