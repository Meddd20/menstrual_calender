import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/repositories/log_repository.dart';

class DailyLogController extends GetxController {
  final ApiService apiService = ApiService();
  late final LogRepository logRepository = LogRepository(apiService);
  final Rx<DateTime> _selectedDate = Rx<DateTime>(DateTime.now());

  TextEditingController dailyNotes = TextEditingController();
  RxBool isChanged = RxBool(false);
  RxBool isMenstruation = RxBool(false);

  var weights = RxString("");
  var temperature = RxString("");
  RxString notes = RxString("");
  RxString selectedSexActivity = "".obs;
  RxString selectedBleedingFlow = "".obs;
  RxString selectedVaginalDischarge = "".obs;
  RxList<String> selectedSymptoms = RxList<String>();
  RxList<String> selectedMoods = RxList<String>();
  RxList<String> selectedOthers = RxList<String>();
  RxList<String> selectedPhysicalActivity = RxList<String>();

  late var wholeNumberWeight;
  late var decimalNumberWeight;

  @override
  void onInit() async {
    await fetchLog(DateTime.now().toString());
    wholeNumberWeight = 70.obs;
    decimalNumberWeight = 0.obs;
    isChanged.value = false;
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

  List<String> sexActivity = [
    "Didn't have sex",
    "Unprotected sex",
    "Protected sex"
  ];

  List<String> vaginalDischarge = [
    "No discharge",
    "Creamy",
    "Spotting",
    "Eggwhite",
    "Sticky",
    "Watery",
    "Unusual"
  ];

  List<String> bleedingFlow = ["Light", "Medium", "Heavy"];

  List<String> symptoms = [
    "Abdominal cramps",
    "Acne",
    "Backache",
    "Bloating",
    "Body aches",
    "Chills",
    "Constipation",
    "Cramps",
    "Cravings",
    "Diarrhea",
    "Dizziness",
    "Fatigue",
    "Feel good",
    "Gas",
    "Headache",
    "Hot flashes",
    "Insomnia",
    "Low back pain",
    "Nausea",
    "Nipple changes",
    "PMS",
    "Spotting",
    "Swelling",
    "Tender breasts"
  ];

  List<String> moods = [
    "Angry",
    "Anxious",
    "Apathetic",
    "Calm",
    "Confused",
    "Cranky",
    "Depressed",
    "Emotional",
    "Energetic",
    "Excited",
    "Feeling guilty",
    "Frisky",
    "Frustrated",
    "Happy",
    "Irritated",
    "Low energy",
    "Mood swings",
    "Obsessive thoughts",
    "Sad",
    "Sensitive",
    "Sleepy",
    "Tired",
    "Unfocused",
    "Very self-critical"
  ];

  List<String> others = ["Travel", "Stress", "Disease or Injury", "Alcohol"];

  List<String> physicalActivity = [
    "Didn't exercise",
    "Yoga",
    "Gym",
    "Aerobics & Dancing",
    "Swimming",
    "Team sports",
    "Running",
    "Cycling",
    "Walking"
  ];

  DateTime get selectedDate => _selectedDate.value;
  void setSelectedDate(DateTime selectedDate) {
    _selectedDate.value = selectedDate;
    isChanged.value = false;
    update();
  }

  String getNotes() => notes.value;
  void updateNotes(String text) {
    isChanged.value = true;
    notes.value = text;
    update();
  }

  var wholeNumberTemperature = 36.obs;
  var decimalNumberTemperature = 0.obs;

  void onWholeNumberTemperatureChanged(int value) {
    wholeNumberTemperature.value = value;
    isChanged.value = true;
    updateTemperature();
  }

  void onDecimalNumberTemperatureChanged(int value) {
    decimalNumberTemperature.value = value;
    isChanged.value = true;
    updateTemperature();
  }

  String getTemperature() => temperature.value;
  void updateTemperature() {
    temperature.value =
        "${wholeNumberTemperature.value}.${decimalNumberTemperature.value}";
    update();
  }

  void onWholeNumberWeightChanged(int value) {
    wholeNumberWeight.value = value;
    isChanged.value = true;
    updateWeight();
  }

  void onDecimalNumberWeightChanged(int value) {
    decimalNumberWeight.value = value;
    isChanged.value = true;
    updateWeight();
  }

  String getWeight() => weights.value;
  void updateWeight() {
    weights.value = "${wholeNumberWeight.value}.${decimalNumberWeight.value}";
    update();
  }

  String getSelectedSexActivity() => selectedSexActivity.value;
  void setSelectedSexActivity(String value) {
    selectedSexActivity.value = value;
    isChanged.value = true;
    update();
  }

  String getSelectedBleedingFlow() => selectedBleedingFlow.value;
  void setSelectedBleedingFlow(String value) {
    selectedBleedingFlow.value = value;
    isChanged.value = true;
    update();
  }

  String getSelectedVaginalDischarge() => selectedVaginalDischarge.value;
  void setSelectedVaginalDischarge(String value) {
    selectedVaginalDischarge.value = value;
    isChanged.value = true;
    update();
  }

  RxList<String> getSelectedSymptoms() => selectedSymptoms;
  void setSelectedSymptoms(List<String> list) {
    selectedSymptoms.value = list;
    isChanged.value = true;
    print(isChanged.value);
    update();
    print(getSelectedSymptoms());
  }

  RxList<String> getSelectedMoods() => selectedMoods;
  setSelectedMoods(List<String> list) {
    selectedMoods.value = list;
    isChanged.value = true;
    update();
  }

  RxList<String> getSelectedOthers() => selectedOthers;
  setSelectedOthers(List<String> list) {
    selectedOthers.value = list;
    isChanged.value = true;
    update();
  }

  RxList<String> getSelectedPhysicalActivity() => selectedPhysicalActivity;
  setSelectedPhysicalActivity(List<String> list) {
    selectedPhysicalActivity.value = list;
    isChanged.value = true;
    update();
  }

  Future<void> fetchLog(String logDate) async {
    try {
      var dailyLog = await logRepository.getLogsByDate(logDate);

      if (dailyLog?.data != null) {
        selectedSexActivity.value = dailyLog!.data!.sexActivity ?? "";
        selectedBleedingFlow.value = dailyLog.data!.bleedingFlow ?? "";
        selectedVaginalDischarge.value = dailyLog.data!.vaginalDischarge ?? "";
        temperature.value = dailyLog.data!.temperature ?? "";
        weights.value = dailyLog.data!.weight ?? "";
        notes.value = dailyLog.data!.notes ?? "";

        selectedSymptoms.assignAll(
          dailyLog.data!.symptoms
                  ?.toJson()
                  .entries
                  .where((entry) => entry.value)
                  .map((entry) => entry.key)
                  .toList() ??
              [],
        );

        selectedMoods.assignAll(
          dailyLog.data!.moods
                  ?.toJson()
                  .entries
                  .where((entry) => entry.value == true)
                  .map((entry) => entry.key)
                  .toList() ??
              [],
        );

        selectedOthers.assignAll(
          dailyLog.data!.others
                  ?.toJson()
                  .entries
                  .where((entry) => entry.value == true)
                  .map((entry) => entry.key)
                  .toList() ??
              [],
        );

        selectedPhysicalActivity.assignAll(
          dailyLog.data!.physicalActivity
                  ?.toJson()
                  .entries
                  .where((entry) => entry.value == true)
                  .map((entry) => entry.key)
                  .toList() ??
              [],
        );

        update();
      }
    } catch (e) {
      print("Error fetching articles: $e");
    }
  }

  Map<String, bool> getUpdatedSymptoms() {
    Map<String, bool> symptomsData = {};

    symptoms.forEach((symptom) {
      symptomsData[symptom] = getSelectedSymptoms().contains(symptom);
    });

    return symptomsData;
  }

  Map<String, bool> getUpdatedMoods() {
    Map<String, bool> moodsData = {};

    moods.forEach((mood) {
      moodsData[mood] = getSelectedMoods().contains(mood);
    });

    return moodsData;
  }

  Map<String, bool> getUpdatedOthers() {
    Map<String, bool> othersData = {};

    others.forEach((other) {
      othersData[other] = getSelectedOthers().contains(other);
    });

    return othersData;
  }

  Map<String, bool> getUpdatedPhysicalActivity() {
    Map<String, bool> physicalActivityData = {};

    physicalActivity.forEach((physicalActivity) {
      physicalActivityData[physicalActivity] =
          getSelectedPhysicalActivity().contains(physicalActivity);
    });

    return physicalActivityData;
  }

  Future<void> saveLog() async {
    try {
      var dailyLog = await logRepository.storeLog(
        selectedDate.toString(),
        getSelectedSexActivity(),
        getSelectedBleedingFlow(),
        getUpdatedSymptoms(),
        getSelectedVaginalDischarge(),
        getUpdatedMoods(),
        getUpdatedOthers(),
        getUpdatedPhysicalActivity(),
        getTemperature(),
        getWeight(),
        getNotes(),
      );

      isChanged.value = false;
      fetchLog(selectedDate.toString());
      update();
    } catch (e) {
      print("Error fetching articles: $e");
    }
  }

  Future<void> resetLog() async {
    try {
      isChanged.value = false;
      setSelectedSexActivity("");
      setSelectedBleedingFlow("");
      setSelectedSymptoms([]);
      setSelectedVaginalDischarge("");
      setSelectedMoods([]);
      setSelectedOthers([]);
      setSelectedPhysicalActivity([]);
      isChanged.value = false;

      var dailyLog = await logRepository.storeLog(
        selectedDate.toString(),
        getSelectedSexActivity(),
        getSelectedBleedingFlow(),
        getUpdatedSymptoms(),
        getSelectedVaginalDischarge(),
        getUpdatedMoods(),
        getUpdatedOthers(),
        getUpdatedPhysicalActivity(),
        "",
        "",
        "",
      );

      isChanged.value = false;
      fetchLog(selectedDate.toString());
      update();
    } catch (e) {
      print("Error fetching articles: $e");
    }
  }
}
