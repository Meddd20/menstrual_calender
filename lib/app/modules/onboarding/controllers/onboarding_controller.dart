import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/modules/onboarding/views/onboarding2_view.dart';
import 'package:periodnpregnancycalender/app/modules/register/views/register_view.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:periodnpregnancycalender/app/utils/utils.dart';
import 'package:periodnpregnancycalender/app/common/common.dart';

class OnboardingController extends GetxController {
  final StorageService storageService = StorageService();
  List<Map<String, dynamic>> periods = [];
  var purposes = 0.obs;
  Rx<DateTime?> birthday = Rx<DateTime?>(null);
  var menstruationCycle = 28.obs;
  var periodLast = 7.obs;
  var datePickerController = DateRangePickerController().obs;
  Rx<DateTime?> lastPeriodDate = Rx<DateTime?>(null);
  Rx<int?> selectedLanguage = Rx<int>(0);

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

  void setLanguage() {
    if (selectedLanguage.value == 0) {
      storageService.setLanguage("en");
      Get.updateLocale(Locale("en"));
    } else {
      storageService.setLanguage("id");
      Get.updateLocale(Locale("id"));
    }
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
            DateTime endDatePrediction = start.add(Duration(days: periodLast.value));
            formattedEndDate = "${endDatePrediction.year}-${endDatePrediction.month.toString().padLeft(2, '0')}-${endDatePrediction.day.toString().padLeft(2, '0')}";
          } else {
            formattedEndDate = "${end.year}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}";
          }

          var formattedStartDate = "${start.year}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}";

          periods.add({
            'first_period': "$formattedStartDate",
            'last_period': "$formattedEndDate",
          });
        }
      }
    }

    periods.sort((a, b) => a['first_period']!.compareTo(b['first_period']!));
  }

  void validateBirthday(context) {
    DateTime? birthDate = birthday.value;

    if (birthDate != null) {
      Get.to(() => Onboarding2View());
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.dateOfBirthSelection));
    }
  }

  void validateLastPeriod(context) {
    if (periods.isEmpty) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.periodRangeSelectionRequired));
    } else if (periods.length > 3) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.periodRangeLimit));
    } else {
      Get.to(() => BackupDataView());
    }
  }

  void validateFirstDayLastPeriod(context) {
    if (lastPeriodDate.value == null) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.lastPeriodFirstDaySelection));
    } else {
      Get.to(() => BackupDataView());
    }
  }
}
