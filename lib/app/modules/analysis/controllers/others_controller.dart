import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/widgets.dart';
import 'package:periodnpregnancycalender/app/models/daily_log_tags_model.dart';
import 'package:periodnpregnancycalender/app/repositories/log_repository.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';

class OthersController extends GetxController {
  final ApiService apiService = ApiService();
  late final LogRepository logRepository = LogRepository(apiService);
  late Data data;
  RxMap<String, dynamic> others = RxMap<String, dynamic>();
  Rx<dynamic> percentage30Days = Rx<dynamic>(null);
  Rx<dynamic> percentage3Months = Rx<dynamic>(null);
  Rx<dynamic> percentage6Months = Rx<dynamic>(null);
  Rx<dynamic> percentage1Year = Rx<dynamic>(null);
  RxString selectedDataType = 'percentage30Days'.obs;
  RxMap<String, dynamic> specificOthersData = RxMap<String, dynamic>();
  late TabController tabController;

  @override
  void onInit() {
    tabController = TabController(length: 4, vsync: MyTickerProvider());
    fetchOthers();
    data = Data(
      tags: '',
      logs: {},
      percentage30Days: null,
      percentage3Months: null,
      percentage6Months: null,
      percentage1Year: null,
    );
    others = RxMap<String, dynamic>();
    percentage30Days = Rx<dynamic>(null);
    percentage3Months = Rx<dynamic>(null);
    percentage6Months = Rx<dynamic>(null);
    percentage1Year = Rx<dynamic>(null);
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

  List<MapEntry<String, dynamic>> getSelectedDataSource() {
    List<MapEntry<String, dynamic>> selectedData;

    switch (selectedDataType.value) {
      case 'percentage30Days':
        selectedData = percentage30Days.value?.entries.toList() ?? [];
        break;
      case 'percentage3Months':
        selectedData = percentage3Months.value?.entries.toList() ?? [];
        break;
      case 'percentage6Months':
        selectedData = percentage6Months.value?.entries.toList() ?? [];
        break;
      case 'percentage1Year':
        selectedData = percentage1Year.value?.entries.toList() ?? [];
        break;
      default:
        selectedData = percentage30Days.value?.entries.toList() ?? [];
        break;
    }

    // Sort the data by values in descending order
    selectedData.sort((a, b) => b.value.compareTo(a.value));

    return [...selectedData];
  }

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
    specificOthersData.clear();

    List<MapEntry<String, dynamic>> filteredData =
        others.entries.where((entry) {
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
      specificOthersData[entry.key] = entry.value;
    }

    return specificOthersData;
  }

  Future<void> fetchOthers() async {
    try {
      DailyLogTags? result = await logRepository.getLogsByTags("others");

      if (result != null && result.data != null) {
        data = result.data!;

        others.value = data.logs;
        percentage30Days.value = data.percentage30Days;
        percentage3Months.value = data.percentage3Months;
        percentage6Months.value = data.percentage6Months;
        percentage1Year.value = data.percentage1Year;
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
