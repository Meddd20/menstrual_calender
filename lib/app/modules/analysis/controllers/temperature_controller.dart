import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/models/daily_log_tags_model.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/log_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/log_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/pregnancy_history_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/pregnancy_log_repository.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/services/log_service.dart';
import 'package:periodnpregnancycalender/app/services/pregnancy_log_service.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';
import 'package:periodnpregnancycalender/app/utils/helpers.dart';

class TemperatureController extends GetxController {
  final ApiService apiService = ApiService();
  late final LogRepository logRepository = LogRepository(apiService);
  late DailyLogTagsData data;
  RxMap<String, dynamic> temperatures = RxMap<String, dynamic>();
  RxString selectedDataType = 'percentage30Days'.obs;
  RxMap<String, dynamic> specificTemperaturesData = RxMap<String, dynamic>();
  Rx<DateTime> selectedDate = DateTime.now().obs;
  late RxString selectedDataTags;
  late TabController tabController;
  late final LogService _logService;
  late final PregnancyLogService _pregnancyLogService;

  @override
  void onInit() {
    tabController = TabController(length: 4, vsync: MyTickerProvider());

    final databaseHelper = DatabaseHelper.instance;
    final localLogRepository = LocalLogRepository(databaseHelper);
    _logService = LogService(localLogRepository);
    final pregnancyLogRepository = PregnancyLogRepository(databaseHelper);
    final pregnancyHistoryRepository = PregnancyHistoryRepository(databaseHelper);
    _pregnancyLogService = PregnancyLogService(pregnancyLogRepository, pregnancyHistoryRepository);
    data = DailyLogTagsData(
      tags: '',
      logs: {},
      percentage30Days: null,
      percentage3Months: null,
      percentage6Months: null,
      percentage1Year: null,
    );
    temperatures = RxMap<String, dynamic>();
    selectedDataType = 'percentage30Days'.obs;
    selectedDataTags = (Get.arguments != null ? RxString(Get.arguments as String) : RxString(""));
    if (selectedDataTags == "pregnancy_temperature") {
      selectedDataType.value = "";
    }
    fetchTemperatures();
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
    specificTemperaturesData.clear();

    List<MapEntry<String, dynamic>> filteredData = temperatures.entries.where((entry) {
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
      specificTemperaturesData[entry.key] = entry.value;
    }

    return specificTemperaturesData;
  }

  Future<void> fetchTemperatures() async {
    try {
      if (selectedDataTags == "pregnancy_temperature") {
        data = await _pregnancyLogService.getPregnancyLogByTags("temperature");
      } else {
        data = await _logService.getLogsByTags("temperature");
      }

      Map<String, dynamic> logsMap = data.logs;

      logsMap.forEach((date, value) {
        if (value is String) {
          temperatures[date] = value;
        } else if (value is List<String>) {
          temperatures[date] = value.join(", ");
        }
      });
      specifiedDataByDate();
      update();
    } catch (e) {
      print("Error fetching temperatures: $e");
    }
  }
}
