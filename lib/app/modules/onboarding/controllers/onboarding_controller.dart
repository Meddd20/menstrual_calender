import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class OnboardingController extends GetxController {
  late List<Map<String, dynamic>> periods;

  var birthday = DateTime.now().obs;
  var selectedDate = DateTime.now().obs;
  var menstruationCycle = 28.obs;
  var periodLast = 7.obs;
  var lastPeriodDate = DateTime.now().obs;
  var pregnantWeek = 0.obs;
  var datePickerController = DateRangePickerController().obs;

  void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    periods = [];

    for (var selectedRange in args.value) {
      if (selectedRange is PickerDateRange) {
        var start = selectedRange.startDate;
        var end = selectedRange.endDate;

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

          var formattedStartDate =
              "${start.year}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}";

          var formattedEndDate = end != null
              ? "${end.year}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}"
              : '';

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
