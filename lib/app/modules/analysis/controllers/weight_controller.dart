import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:periodnpregnancycalender/app/utils/utils.dart';
import 'package:periodnpregnancycalender/app/services/services.dart';
import 'package:periodnpregnancycalender/app/repositories/repositories.dart';
import 'package:periodnpregnancycalender/app/models/models.dart';

class WeightController extends GetxController {
  final ApiService apiService = ApiService();
  late final LogRepository logRepository = LogRepository(apiService);
  late DailyLogTagsData data;
  RxMap<String, dynamic> weight = RxMap<String, dynamic>();
  RxString selectedDataType = 'percentage30Days'.obs;
  RxMap<String, dynamic> specificWeightData = RxMap<String, dynamic>();
  Rx<DateTime> selectedDate = DateTime.now().obs;
  late RxString selectedDataTags;
  late TabController tabController;
  late final LogService _logService;
  late final PregnancyLogService _pregnancyLogService;

  @override
  void onInit() {
    tabController = TabController(length: 4, vsync: MyTickerProvider());

    _logService = LogService();
    _pregnancyLogService = PregnancyLogService();
    data = DailyLogTagsData(
      tags: '',
      logs: {},
      percentage30Days: null,
      percentage3Months: null,
      percentage6Months: null,
      percentage1Year: null,
    );
    weight = RxMap<String, dynamic>();
    selectedDataType = 'percentage30Days'.obs;
    selectedDataTags = (Get.arguments != null ? RxString(Get.arguments as String) : RxString(""));
    if (selectedDataTags == "uteri_fundus_height") {
      selectedDataType.value = "";
    }
    fetchWeight(Get.context);
    specifiedDataByDate();
    _updateSelectedDate();
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
    specificWeightData.clear();

    List<MapEntry<String, dynamic>> filteredData = weight.entries.where((entry) {
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
      specificWeightData[entry.key] = entry.value;
    }

    print(specificWeightData);

    return specificWeightData;
  }

  Future<void> fetchWeight(context) async {
    try {
      if (selectedDataTags.value == "uteri_fundus_height") {
        data = await _pregnancyLogService.getPregnancyLogByTags(context, "fundusUteriHeight");
      } else {
        data = await _logService.getLogsByTags(context, "weight");
      }

      Map<String, dynamic> logsMap = data.logs;

      logsMap.forEach((date, value) {
        if (value is String) {
          weight[date] = value;
        } else if (value is List<String>) {
          weight[date] = value.join(", ");
        }
      });
      specifiedDataByDate();
      update();
    } catch (e) {
      print("Error fetching weight: $e");
    }
  }
}
