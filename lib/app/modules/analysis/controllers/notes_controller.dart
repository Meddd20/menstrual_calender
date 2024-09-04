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

class NotesController extends GetxController {
  late DailyLogTagsData data;
  late TabController tabController;
  final ApiService apiService = ApiService();
  late final LogRepository logRepository = LogRepository(apiService);
  RxMap<String, dynamic> notes = RxMap<String, dynamic>();
  RxString selectedDataType = 'percentage30Days'.obs;
  RxMap<String, dynamic> specificNotesData = RxMap<String, dynamic>();
  late final LogService _logService;
  late RxString selectedDataTags;
  late final PregnancyLogService _pregnancyLogService;

  @override
  void onInit() {
    tabController = TabController(length: 4, vsync: MyTickerProvider());
    final databaseHelper = DatabaseHelper.instance;
    final localLogRepository = LocalLogRepository(databaseHelper);
    final pregnancyLogRepository = PregnancyLogRepository(databaseHelper);
    final pregnancyHistoryRepository = PregnancyHistoryRepository(databaseHelper);
    _logService = LogService(localLogRepository);
    _pregnancyLogService = PregnancyLogService(pregnancyLogRepository, pregnancyHistoryRepository);
    data = DailyLogTagsData(
      tags: '',
      logs: {},
      percentage30Days: null,
      percentage3Months: null,
      percentage6Months: null,
      percentage1Year: null,
    );

    notes = RxMap<String, dynamic>();
    selectedDataTags = (Get.arguments != null ? RxString(Get.arguments as String) : RxString(""));
    if (selectedDataTags == "pregnancy_notes") {
      selectedDataType.value = "";
    }
    fetchNotes();
    specifiedDataByDate();
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

  Map<String, dynamic> specifiedDataByDate() {
    DateTime now = DateTime.now();
    specificNotesData.clear();

    List<MapEntry<String, dynamic>> filteredData = notes.entries.where((entry) {
      DateTime entryDate = DateTime.parse(entry.key);

      bool dateInRange;
      switch (selectedDataType.value) {
        case 'percentage30Days':
          dateInRange = entryDate.isAfter(now.subtract(Duration(days: 31))) && entryDate.isBefore(now);
          break;
        case 'percentage3Months':
          dateInRange = entryDate.isAfter(now.subtract(Duration(days: 91))) && entryDate.isBefore(now);
          break;
        case 'percentage6Months':
          dateInRange = entryDate.isAfter(now.subtract(Duration(days: 181))) && entryDate.isBefore(now);
          break;
        case 'percentage1Year':
          dateInRange = entryDate.isAfter(now.subtract(Duration(days: 366))) && entryDate.isBefore(now);
          break;
        default:
          dateInRange = true;
      }

      bool hasData = entry.value.isNotEmpty;

      return dateInRange && hasData;
    }).toList();

    for (var entry in filteredData) {
      specificNotesData[entry.key] = entry.value;
    }

    return specificNotesData;
  }

  Future<void> fetchNotes() async {
    try {
      DailyLogTagsData? result;
      if (selectedDataTags == "pregnancy_notes") {
        result = await _pregnancyLogService.getPregnancyLogByTags("notes");
      } else {
        result = await _logService.getLogsByTags("notes");
      }

      notes.value = result.logs;
      specifiedDataByDate();
      update();
    } catch (error) {
      print("Error: $error");
    }
  }
}
