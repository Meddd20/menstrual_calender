import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_model.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/pregnancy_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/master_kehamilan_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/period_history_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/pregnancy_history_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/profile_repository.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/services/pregnancy_history_service.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';
import 'package:periodnpregnancycalender/app/utils/helpers.dart';

class BabyWeightHeigthTrackerController extends GetxController {
  final ApiService apiService = ApiService();
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;
  late final PregnancyRepository pregnancyRepository = PregnancyRepository(apiService);
  late Future<void> pregnancyData;
  Rx<CurrentlyPregnant> currentlyPregnantData = Rx<CurrentlyPregnant>(CurrentlyPregnant());
  RxList<WeeklyData> weeklyData = <WeeklyData>[].obs;
  RxInt currentPregnancyWeekIndex = 0.obs;
  late final PregnancyHistoryService _pregnancyHistoryService;

  late TabController tabController;
  RxString selectedDataType = 'Weight'.obs;
  int? get getPregnancyIndex => currentPregnancyWeekIndex.value;

  RxList<Map<String, dynamic>> babyWeightData = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> babyHeightData = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    final DatabaseHelper databaseHelper = DatabaseHelper.instance;
    final LocalProfileRepository localProfileRepository = LocalProfileRepository(databaseHelper);
    final PregnancyHistoryRepository pregnancyHistoryRepository = PregnancyHistoryRepository(databaseHelper);
    final MasterDataKehamilanRepository masterKehamilanRepository = MasterDataKehamilanRepository(databaseHelper);
    final PeriodHistoryRepository periodHistoryRepository = PeriodHistoryRepository(databaseHelper);
    _pregnancyHistoryService = PregnancyHistoryService(
      pregnancyHistoryRepository,
      masterKehamilanRepository,
      periodHistoryRepository,
      localProfileRepository,
    );

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
    var result = await _pregnancyHistoryService.getCurrentPregnancyData("id");
    currentlyPregnantData.value = result!;
    weeklyData.assignAll(currentlyPregnantData.value.weeklyData!);
    currentPregnancyWeekIndex.value = (currentlyPregnantData.value.usiaKehamilan ?? 0) - 1;
    extractBabyData();
    update();
  }

  void extractBabyData() {
    babyWeightData.clear();
    babyHeightData.clear();

    for (var weekly in weeklyData) {
      babyWeightData.add({'week': weekly.mingguKehamilan ?? 0, 'date': weekly.tanggalAwalMinggu ?? '', 'weight': weekly.beratJanin ?? 0.0});
      babyHeightData.add({'week': weekly.mingguKehamilan ?? 0, 'date': weekly.tanggalAwalMinggu ?? '', 'height': weekly.tinggiBadanJanin ?? 0.0});
    }
  }
}
