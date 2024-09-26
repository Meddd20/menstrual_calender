import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/models/master_pregnancy_model.dart';
import 'package:periodnpregnancycalender/app/services/master_kehamilan_service.dart';
import 'package:periodnpregnancycalender/app/utils/helpers.dart';

class BabyWeightHeigthTrackerController extends GetxController {
  RxList<MasterPregnancy> pregnancyData = <MasterPregnancy>[].obs;
  RxInt currentPregnancyWeekIndex = 0.obs;
  late final MasterKehamilanService _masterKehamilanService;

  late TabController tabController;
  RxString selectedDataType = 'Weight'.obs;
  int? get getPregnancyIndex => currentPregnancyWeekIndex.value;

  RxList<Map<String, dynamic>> babyWeightData = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> babyHeightData = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    _masterKehamilanService = MasterKehamilanService();

    fetchPregnancyData();
    tabController = TabController(length: 2, vsync: MyTickerProvider());

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

  void updateTabBar(int index) {
    selectedDataType.value = _getDataTypeByIndex(index);
  }

  String _getDataTypeByIndex(int index) {
    return index == 0 ? 'Weight' : 'Height';
  }

  Future<void> fetchPregnancyData() async {
    List<MasterPregnancy> weekPregnancyData = await _masterKehamilanService.getAllPregnancyData();
    pregnancyData.assignAll(weekPregnancyData);
    extractBabyData();
    update();
  }

  void extractBabyData() {
    babyWeightData.clear();
    babyHeightData.clear();

    for (var weekly in pregnancyData) {
      babyWeightData.add({'week': weekly.mingguKehamilan ?? 0, 'weight': weekly.beratJanin ?? 0.0});
      babyHeightData.add({'week': weekly.mingguKehamilan ?? 0, 'height': weekly.tinggiBadanJanin ?? 0.0});
    }
  }
}
