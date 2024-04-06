import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/widgets.dart';
import 'package:periodnpregnancycalender/app/models/daily_log_tags_model.dart';
import 'package:periodnpregnancycalender/app/repositories/log_repository.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';

class NotesController extends GetxController {
  late Data data;
  late TabController tabController;
  final ApiService apiService = ApiService();
  late final LogRepository logRepository = LogRepository(apiService);
  RxMap<String, dynamic> notes = RxMap<String, dynamic>();
  RxString selectedDataType = 'percentage30Days'.obs;
  RxMap<String, dynamic> specificNotesData = RxMap<String, dynamic>();

  @override
  void onInit() {
    tabController = TabController(length: 4, vsync: MyTickerProvider());
    fetchNotes();
    data = Data(
      tags: '',
      logs: {},
      percentage30Days: null,
      percentage3Months: null,
      percentage6Months: null,
      percentage1Year: null,
    );
    notes = RxMap<String, dynamic>();
    selectedDataType = 'percentage30Days'.obs;
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
      switch (selectedDataType.value) {
        case 'percentage30Days':
          return entryDate.isAfter(now.subtract(Duration(days: 31))) &&
              entryDate.isBefore(now);
        case 'percentage3Months':
          return entryDate.isAfter(now.subtract(Duration(days: 91))) &&
              entryDate.isBefore(now);
        case 'percentage6Months':
          return entryDate.isAfter(now.subtract(Duration(days: 181))) &&
              entryDate.isBefore(now);
        case 'percentage1Year':
          return entryDate.isAfter(now.subtract(Duration(days: 366))) &&
              entryDate.isBefore(now);
        default:
          return false;
      }
    }).toList();

    for (var entry in filteredData) {
      specificNotesData[entry.key] = entry.value;
    }

    return specificNotesData;
  }

  Future<void> fetchNotes() async {
    try {
      DailyLogTags? result = await logRepository.getLogsByTags("notes");

      if (result != null && result.data != null) {
        data = result.data!;

        notes.value = data.logs;
      } else {
        print("Error: Unable to fetch others");
      }
      specifiedDataByDate();

      update();
    } catch (error) {
      print("Error: $error");
    }
  }
}
