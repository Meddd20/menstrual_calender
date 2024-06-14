import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_weight_gain.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/views/weight_gain_tracker_view.dart';
import 'package:periodnpregnancycalender/app/repositories/pregnancy_repository.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';

class WeightGainTrackerController extends GetxController {
  final ApiService apiService = ApiService();
  late final PregnancyRepository pregnancyRepository =
      PregnancyRepository(apiService);
  late Future<void> weightGainIndexData;
  Rx<Data?> pregnancyWeightGainData = Rx<Data>(Data());
  RxList<WeightHistory> weightGainHistory = <WeightHistory>[].obs;
  RxList<ReccomendWeightGain> reccomendWeightGain = <ReccomendWeightGain>[].obs;
  Rx<double> tinggiBadan = 0.0.obs;
  Rx<double> beratBadan = 0.0.obs;
  Rx<int> isTwin = 0.obs;
  FocusNode focusNode = FocusNode();

  Data? get getPregnancyWeightGainData => pregnancyWeightGainData.value;
  List<WeightHistory>? get getweightGainHistory => weightGainHistory.value;
  double get getTinggiBadan => tinggiBadan.value;
  double get getBeratBadan => beratBadan.value;
  int get getisTwin => isTwin.value;

  @override
  void onInit() {
    weightGainIndexData = fetchWeightGainIndex();
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

  Future<void> fetchWeightGainIndex() async {
    var result = await pregnancyRepository.getWeightGainIndex();
    pregnancyWeightGainData.value = result?.data;
    weightGainHistory.assignAll(pregnancyWeightGainData.value!.weightHistory!);
    reccomendWeightGain
        .assignAll(pregnancyWeightGainData.value!.reccomendWeightGain!);
    update();
  }

  Future<void> initializeWeightGain() async {
    await pregnancyRepository.initializeWeightGain(
        getTinggiBadan, getBeratBadan, getisTwin);
  }

  Future<void> deleteWeeklyWeightGain(int id) async {
    await pregnancyRepository.deleteWeeklyWeightGain(id);
    await fetchWeightGainIndex();
  }
}
