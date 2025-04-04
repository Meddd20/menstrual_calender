import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/models/daily_log_tags_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:periodnpregnancycalender/app/utils/utils.dart';
import 'package:periodnpregnancycalender/app/services/services.dart';
import 'package:periodnpregnancycalender/app/models/models.dart';

class LogsController extends GetxController {
  late DailyLogTagsData data;
  RxMap<String, dynamic> logs = RxMap<String, dynamic>();
  Rx<dynamic> percentage30Days = Rx<dynamic>(null);
  Rx<dynamic> percentage3Months = Rx<dynamic>(null);
  Rx<dynamic> percentage6Months = Rx<dynamic>(null);
  Rx<dynamic> percentage1Year = Rx<dynamic>(null);
  RxString selectedDataType = 'percentage30Days'.obs;
  RxMap<String, dynamic> specificLogsData = RxMap<String, dynamic>();
  Rx<DateTime> selectedDate = DateTime.now().obs;
  late TabController tabController;
  late RxString selectedDataTags;
  late final LogService _logService;
  late final PregnancyLogService _pregnancyLogService;

  @override
  void onInit() {
    _logService = LogService();
    _pregnancyLogService = PregnancyLogService();

    tabController = TabController(length: 4, vsync: MyTickerProvider());
    data = DailyLogTagsData(
      tags: '',
      logs: {},
      percentage30Days: null,
      percentage3Months: null,
      percentage6Months: null,
      percentage1Year: null,
    );
    logs = RxMap<String, dynamic>();
    percentage30Days = Rx<dynamic>(null);
    percentage3Months = Rx<dynamic>(null);
    percentage6Months = Rx<dynamic>(null);
    percentage1Year = Rx<dynamic>(null);
    selectedDataTags = RxString(Get.arguments as String);
    if (selectedDataTags == "pregnancy_symptoms") {
      selectedDataType.value = "";
    }
    _updateSelectedDate();
    specifiedDataByDate();

    fetchLogs(Get.context);
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

  String get getSelectedDataType => selectedDataType.value;

  set setSelectedDataType(String value) => selectedDataType.value = value;

  List<MapEntry<String, dynamic>> getSelectedDataSource() {
    List<MapEntry<String, dynamic>> selectedData = [];

    switch (selectedDataType.value) {
      case 'percentage30Days':
        if (percentage30Days.value is Map<String, dynamic>) {
          selectedData = (percentage30Days.value as Map<String, dynamic>).entries.toList();
        }
        break;
      case 'percentage3Months':
        if (percentage3Months.value is Map<String, dynamic>) {
          selectedData = (percentage3Months.value as Map<String, dynamic>).entries.toList();
        }
        break;
      case 'percentage6Months':
        if (percentage6Months.value is Map<String, dynamic>) {
          selectedData = (percentage6Months.value as Map<String, dynamic>).entries.toList();
        }
        break;
      case 'percentage1Year':
        if (percentage1Year.value is Map<String, dynamic>) {
          selectedData = (percentage1Year.value as Map<String, dynamic>).entries.toList();
        }
        break;
      default:
        if (percentage30Days.value is Map<String, dynamic>) {
          selectedData = (percentage30Days.value as Map<String, dynamic>).entries.toList();
        }
        break;
    }

    // Sort the data by values in descending order
    selectedData.sort((a, b) => b.value.compareTo(a.value));

    // Take up to 5 elements
    final top5 = selectedData.take(5).toList();

    // Create an "Others" entry with the sum of remaining values if there are more than 5 elements
    final othersData = selectedData.length > 5 ? [MapEntry('Others', selectedData.skip(5).fold<int>(0, (sum, entry) => sum + (entry.value as int)))] : [];

    return [...top5, ...othersData];
  }

  void updateTabBar(int index) {
    selectedDataType.value = _getDataTypeByIndex(index);
    _updateSelectedDate();
    specifiedDataByDate();
  }

  String _getDataTypeByIndex(int index) {
    switch (index) {
      case 0:
        return 'percentage30Days';
      case 1:
        return 'percentage3Months';
      case 2:
        return 'percentage6Months';
      case 3:
        return 'percentage1Year';
      default:
        return 'percentage30Days';
    }
  }

  void _updateSelectedDate() {
    DateTime now = DateTime.now();
    switch (selectedDataType.value) {
      case 'percentage30Days':
        selectedDate.value = now.subtract(Duration(days: 30));
        break;
      case 'percentage3Months':
        selectedDate.value = now.subtract(Duration(days: 90));
        break;
      case 'percentage6Months':
        selectedDate.value = now.subtract(Duration(days: 180));
        break;
      case 'percentage1Year':
        selectedDate.value = now.subtract(Duration(days: 365));
        break;
      default:
        selectedDate.value = now.subtract(Duration(days: 30));
        break;
    }
  }

  Map<String, dynamic> specifiedDataByDate() {
    DateTime now = DateTime.now();
    specificLogsData.clear();

    List<MapEntry<String, dynamic>> filteredData = logs.entries.where((entry) {
      DateTime entryDate = DateTime.parse(entry.key);
      switch (selectedDataType.value) {
        case 'percentage30Days':
          return entryDate.isAfter(now.subtract(Duration(days: 31))) && entryDate.isBefore(now);
        case 'percentage3Months':
          return entryDate.isAfter(now.subtract(Duration(days: 91))) && entryDate.isBefore(now);
        case 'percentage6Months':
          return entryDate.isAfter(now.subtract(Duration(days: 181))) && entryDate.isBefore(now);
        case 'percentage1Year':
          return entryDate.isAfter(now.subtract(Duration(days: 366))) && entryDate.isBefore(now);
        default:
          return true;
      }
    }).toList();

    for (var entry in filteredData) {
      specificLogsData[entry.key] = entry.value;
    }

    return specificLogsData;
  }

  String pageTags(context) {
    if (selectedDataTags == "bleeding_flow") {
      return AppLocalizations.of(context)!.bleedingFlow;
    } else if (selectedDataTags == "sex_activity") {
      return AppLocalizations.of(context)!.sexActivity;
    } else if (selectedDataTags == "symptoms") {
      return AppLocalizations.of(context)!.symptoms;
    } else if (selectedDataTags == "vaginal_discharge") {
      return AppLocalizations.of(context)!.vaginalDischarge;
    } else if (selectedDataTags == "moods") {
      return AppLocalizations.of(context)!.moods;
    } else if (selectedDataTags == "others") {
      return AppLocalizations.of(context)!.others;
    } else if (selectedDataTags == "physical_activity") {
      return AppLocalizations.of(context)!.physicalActivity;
    } else {
      return AppLocalizations.of(context)!.bleedingFlow;
    }
  }

  Future<void> fetchLogs(context) async {
    try {
      DailyLogTagsData? result;
      if (selectedDataTags == "pregnancy_symptoms") {
        result = await _pregnancyLogService.getPregnancyLogByTags(context, "pregnancySymptoms");
      } else {
        result = await _logService.getLogsByTags(context, selectedDataTags.value);
      }

      logs.value = result.logs;
      percentage30Days.value = result.percentage30Days ?? {};
      percentage3Months.value = result.percentage3Months ?? {};
      percentage6Months.value = result.percentage6Months ?? {};
      percentage1Year.value = result.percentage1Year ?? {};
      specifiedDataByDate();
      update();
    } catch (error) {
      print("Error: $error");
    }
  }
}
