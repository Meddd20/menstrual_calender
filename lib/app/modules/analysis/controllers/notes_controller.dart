import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:periodnpregnancycalender/app/utils/utils.dart';
import 'package:periodnpregnancycalender/app/services/services.dart';
import 'package:periodnpregnancycalender/app/repositories/repositories.dart';
import 'package:periodnpregnancycalender/app/models/models.dart';

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

    notes = RxMap<String, dynamic>();
    selectedDataTags = (Get.arguments != null ? RxString(Get.arguments as String) : RxString(""));
    print(selectedDataTags);
    if (selectedDataTags == "pregnancy_notes" || selectedDataTags == "fetal_heartrate" || selectedDataTags == "pregnancy_usg") {
      selectedDataType.value = "";
    }
    fetchNotes(Get.context);
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
      if (selectedDataTags == "fetal_heartrate") {
        List<String> values = entry.value.split(',');
        String formattedData = "";
        if (values.isNotEmpty) {
          formattedData += "Denyut Jantung Janin\t\t\t\t\t\t\t\t${values[0].trim()} bpm\n";
        }
        if (values.length > 1) {
          formattedData += "Metode Pemeriksaan\t\t\t\t\t\t\t\t${values[1].trim()}";
        }

        specificNotesData[entry.key] = formattedData;
      } else if (selectedDataTags == "pregnancy_usg") {
        List<String> values = entry.value.split(',');
        String formattedData = "";
        if (values.isNotEmpty) {
          String fetalPosition = values[0].trim();
          String fetalPositionDescription = getFetalPositionDescription(fetalPosition);
          formattedData += "Posisi Janin\n$fetalPosition\n$fetalPositionDescription\n";
        }
        if (values.length > 1) {
          String placentaCondition = values[1].trim();
          print(placentaCondition);
          String placentaConditionDescription = getPlacentaConditionDescription(placentaCondition);
          formattedData += "\nKondisi Plasenta\n$placentaCondition\n$placentaConditionDescription\n";
        }
        if (values.length == 3) {
          formattedData += "\nBerat Janin\n${values[2].trim()} gram";
        }

        specificNotesData[entry.key] = formattedData;
      } else {
        specificNotesData[entry.key] = entry.value;
      }
    }

    return specificNotesData;
  }

  Future<void> fetchNotes(context) async {
    try {
      DailyLogTagsData? result;
      if (selectedDataTags == "pregnancy_notes") {
        result = await _pregnancyLogService.getPregnancyLogByTags(context, "notes");
      } else if (selectedDataTags == "fetal_heartrate") {
        result = await _pregnancyLogService.getPregnancyLogByTags(context, "fetalHeartRate");
      } else if (selectedDataTags == "pregnancy_usg") {
        result = await _pregnancyLogService.getPregnancyLogByTags(context, "pregnancyUSG");
      } else {
        result = await _logService.getLogsByTags(context, "notes");
      }

      notes.value = result.logs;
      specifiedDataByDate();
      update();
    } catch (error) {
      print("Error: $error");
    }
  }

  String getFetalPositionDescription(String position) {
    switch (position.toLowerCase()) {
      case "cephalic":
        return "Kepala janin berada di bawah, posisi ini ideal untuk persalinan normal.";
      case "breech":
        return "Bokong atau kaki janin berada di bawah, bisa memerlukan intervensi medis.";
      case "transverse":
        return "Janin melintang di dalam rahim, biasanya memerlukan tindakan medis.";
      default:
        return "Informasi posisi janin tidak tersedia atau tidak dikenali.";
    }
  }

  String getPlacentaConditionDescription(String condition) {
    switch (condition.toLowerCase()) {
      case "normal":
        return "Plasenta dalam kondisi sehat tanpa komplikasi.";
      case "previa":
        return "Plasenta menutupi serviks, dapat menyebabkan masalah saat persalinan.";
      case "acretia":
        print("object");
        return "Plasenta tumbuh terlalu dalam ke dinding rahim, berisiko mengganggu proses pelepasan plasenta.";
      case "abruptio":
        return "Plasenta terlepas dari dinding rahim sebelum melahirkan.";
      case "insufficiency":
        return "Plasenta tidak cukup memberi oksigen dan nutrisi untuk janin.";
      default:
        return "Kondisi yang kurang umum atau tidak disebutkan.";
    }
  }
}
