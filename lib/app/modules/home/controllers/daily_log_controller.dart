import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_snackbar.dart';
import 'package:periodnpregnancycalender/app/models/daily_log_date_model.dart';
import 'package:periodnpregnancycalender/app/models/sync_log_model.dart';
import 'package:periodnpregnancycalender/app/repositories/local/sync_data_repository.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/log_repository.dart';
import 'package:periodnpregnancycalender/app/services/log_service.dart';
import 'package:periodnpregnancycalender/app/utils/conectivity.dart';
import 'package:periodnpregnancycalender/app/utils/helpers.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:table_calendar/table_calendar.dart';

class DailyLogController extends GetxController {
  final apiService = ApiService();
  final storageService = StorageService();
  late final LogRepository logRepository = LogRepository(apiService);
  late final LogService _logService;
  late final SyncDataRepository _syncDataRepository;

  final Rx<DateTime> _selectedDate = Rx<DateTime>(DateTime.now());

  TextEditingController dailyNotes = TextEditingController();
  RxBool isChanged = RxBool(false);
  RxBool isMenstruation = RxBool(false);

  RxString notes = RxString("");
  RxString selectedSexActivity = "".obs;
  RxString selectedBleedingFlow = "".obs;
  RxString selectedVaginalDischarge = "".obs;
  RxList<String> selectedSymptoms = RxList<String>();
  RxList<String> selectedMoods = RxList<String>();
  RxList<String> selectedOthers = RxList<String>();
  RxList<String> selectedPhysicalActivity = RxList<String>();

  final Rx<DateTime> _focusedDate = Rx<DateTime>(DateTime.now());
  DateTime get getFocusedDate => _focusedDate.value;
  void setFocusedDate(DateTime selectedDate) {
    _focusedDate.value = selectedDate;
    update();
  }

  late Future<DataHarian?> futureDataHarian;
  var dailyLogRequested = DataHarian().obs;
  var isLoading = true.obs;

  @override
  void onInit() async {
    super.onInit();
    _logService = LogService();
    _syncDataRepository = SyncDataRepository();

    futureDataHarian = fetchLog(DateTime.now());
    isChanged.value = false;
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
    "Protected sex",
  ];
  List<String> vaginalDischarge = [
    "No discharge",
    "Creamy",
    "Spotting",
    "Eggwhite",
    "Sticky",
    "Watery",
    "Unusual",
  ];
  List<String> bleedingFlow = [
    "Light",
    "Medium",
    "Heavy",
  ];
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
    "Tender breasts",
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
    "Very self-critical",
  ];
  List<String> others = [
    "Travel",
    "Stress",
    "Disease or Injury",
    "Alcohol",
  ];
  List<String> physicalActivity = [
    "Didn't exercise",
    "Yoga",
    "Gym",
    "Aerobics & Dancing",
    "Swimming",
    "Team sports",
    "Running",
    "Cycling",
    "Walking",
  ];

  Map<String, String> sexActivityTranslations(context) {
    return {
      "Didn't have sex": AppLocalizations.of(context)!.didntHaveSex,
      "Unprotected sex": AppLocalizations.of(context)!.unprotectedSex,
      "Protected sex": AppLocalizations.of(context)!.protectedSex,
    };
  }

  Map<String, String> vaginalDischargeTranslations(context) {
    return {
      "No discharge": AppLocalizations.of(context)!.noDischarge,
      "Creamy": AppLocalizations.of(context)!.creamyDischarge,
      "Spotting": AppLocalizations.of(context)!.spottingDischarge,
      "Eggwhite": AppLocalizations.of(context)!.eggwhiteDischarge,
      "Sticky": AppLocalizations.of(context)!.stickyDischarge,
      "Watery": AppLocalizations.of(context)!.wateryDischarge,
      "Unusual": AppLocalizations.of(context)!.unusualDischarge,
    };
  }

  Map<String, String> bleedingFlowTranslations(context) {
    return {
      "Light": AppLocalizations.of(context)!.lightBleedingFlow,
      "Medium": AppLocalizations.of(context)!.mediumBleedingFlow,
      "Heavy": AppLocalizations.of(context)!.heavyBleedingFlow,
    };
  }

  Map<String, String> symptomsTranslations(context) {
    return {
      "Abdominal cramps": AppLocalizations.of(context)!.abdominalCramps,
      "Acne": AppLocalizations.of(context)!.acne,
      "Backache": AppLocalizations.of(context)!.backache,
      "Bloating": AppLocalizations.of(context)!.bloating,
      "Body aches": AppLocalizations.of(context)!.bodyAches,
      "Chills": AppLocalizations.of(context)!.chills,
      "Constipation": AppLocalizations.of(context)!.constipation,
      "Cramps": AppLocalizations.of(context)!.cramps,
      "Cravings": AppLocalizations.of(context)!.cravings,
      "Diarrhea": AppLocalizations.of(context)!.diarrhea,
      "Dizziness": AppLocalizations.of(context)!.dizziness,
      "Fatigue": AppLocalizations.of(context)!.fatigue,
      "Feel good": AppLocalizations.of(context)!.feelGood,
      "Gas": AppLocalizations.of(context)!.gas,
      "Headache": AppLocalizations.of(context)!.headache,
      "Hot flashes": AppLocalizations.of(context)!.hotFlashes,
      "Insomnia": AppLocalizations.of(context)!.insomnia,
      "Low back pain": AppLocalizations.of(context)!.lowBackPain,
      "Nausea": AppLocalizations.of(context)!.nausea,
      "Nipple changes": AppLocalizations.of(context)!.nippleChanges,
      "PMS": AppLocalizations.of(context)!.pms,
      "Spotting": AppLocalizations.of(context)!.spotting,
      "Swelling": AppLocalizations.of(context)!.swelling,
      "Tender breasts": AppLocalizations.of(context)!.tenderBreasts,
    };
  }

  Map<String, String> moodsTranslations(context) {
    return {
      "Angry": AppLocalizations.of(context)!.angry,
      "Anxious": AppLocalizations.of(context)!.anxious,
      "Apathetic": AppLocalizations.of(context)!.apathetic,
      "Calm": AppLocalizations.of(context)!.calm,
      "Confused": AppLocalizations.of(context)!.confused,
      "Cranky": AppLocalizations.of(context)!.cranky,
      "Depressed": AppLocalizations.of(context)!.depressed,
      "Emotional": AppLocalizations.of(context)!.emotional,
      "Energetic": AppLocalizations.of(context)!.energetic,
      "Excited": AppLocalizations.of(context)!.excited,
      "Feeling guilty": AppLocalizations.of(context)!.feelingGuilty,
      "Frisky": AppLocalizations.of(context)!.frisky,
      "Frustrated": AppLocalizations.of(context)!.frustrated,
      "Happy": AppLocalizations.of(context)!.happy,
      "Irritated": AppLocalizations.of(context)!.irritated,
      "Low energy": AppLocalizations.of(context)!.lowEnergy,
      "Mood swings": AppLocalizations.of(context)!.moodSwings,
      "Obsessive thoughts": AppLocalizations.of(context)!.obsessiveThoughts,
      "Sad": AppLocalizations.of(context)!.sad,
      "Sensitive": AppLocalizations.of(context)!.sensitive,
      "Sleepy": AppLocalizations.of(context)!.sleepy,
      "Tired": AppLocalizations.of(context)!.tired,
      "Unfocused": AppLocalizations.of(context)!.unfocused,
      "Very self-critical": AppLocalizations.of(context)!.verySelfCritical,
    };
  }

  Map<String, String> othersTranslations(context) {
    return {
      "Travel": AppLocalizations.of(context)!.travel,
      "Stress": AppLocalizations.of(context)!.stress,
      "Disease or Injury": AppLocalizations.of(context)!.diseaseOrInjury,
      "Alcohol": AppLocalizations.of(context)!.alcohol,
    };
  }

  Map<String, String> physicalActivityTranslations(context) {
    return {
      "Didn't exercise": AppLocalizations.of(context)!.didntExercise,
      "Yoga": AppLocalizations.of(context)!.yoga,
      "Gym": AppLocalizations.of(context)!.gym,
      "Aerobics & Dancing": AppLocalizations.of(context)!.aerobicsAndDancing,
      "Swimming": AppLocalizations.of(context)!.swimming,
      "Team sports": AppLocalizations.of(context)!.teamSports,
      "Running": AppLocalizations.of(context)!.running,
      "Cycling": AppLocalizations.of(context)!.cycling,
      "Walking": AppLocalizations.of(context)!.walking,
    };
  }

  Rx<CalendarFormat> format = Rx<CalendarFormat>(CalendarFormat.week);
  CalendarFormat get getFormat => format.value;
  void setFormat(CalendarFormat newFormat) {
    format.value = newFormat;
  }

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

  Rx<int?> _temperatureWholeNumber = Rx<int?>(36);

  int? get selectedTemperatureWholeNumber => _temperatureWholeNumber.value;

  void setTemperatureWholeNumber(int temperatureWholeNumber) {
    _temperatureWholeNumber.value = temperatureWholeNumber;
    update();
  }

  Rx<int?> _temperatureDecimalNumber = Rx<int?>(0);

  int? get selectedTemperatureDecimalNumber => _temperatureDecimalNumber.value;

  void setTemperatureDecimalNumber(int temperatureDecimalNumber) {
    _temperatureDecimalNumber.value = temperatureDecimalNumber;
    update();
  }

  var temperature = Rx<double>(0.0);
  var originalTemperature = Rx<double>(0.0);

  double getTemperature() => temperature.value;

  void updateTemperature() {
    temperature.value = double.parse("${selectedTemperatureWholeNumber ?? 36}.${selectedTemperatureDecimalNumber ?? 0}");
    originalTemperature.value = temperature.value;
    isChanged.value = true;
    update();
  }

  void resetTemperature() {
    if (originalTemperature == 0.0) {
      temperature.value = 0.0;
      setTemperatureWholeNumber(36);
      setTemperatureDecimalNumber(0);
    } else {
      int wholeNumber = originalTemperature.value.floor();
      int decimalNumber = ((originalTemperature.value - wholeNumber) * 10).round();
      setTemperatureWholeNumber(wholeNumber);
      setTemperatureDecimalNumber(decimalNumber);
    }
  }

  Rx<int?> _weightWholeNumber = Rx<int?>(70);

  int? get selectedWeightWholeNumber => _weightWholeNumber.value;

  void setWeightWholeNumber(int weightWholeNumber) {
    _weightWholeNumber.value = weightWholeNumber;
    update();
  }

  Rx<int?> _weightDecimalNumber = Rx<int?>(0);

  int? get selectedWeightDecimalNumber => _weightDecimalNumber.value;

  void setWeightDecimalNumber(int weightDecimalNumber) {
    _weightDecimalNumber.value = weightDecimalNumber;
    update();
  }

  var weights = Rx<double>(0.0);
  var originalWeight = Rx<double>(0.0);

  double getWeight() => weights.value;

  void updateWeight() {
    weights.value = double.parse("${selectedWeightWholeNumber ?? 70}.${selectedWeightDecimalNumber ?? 0}");
    originalWeight.value = weights.value;
    isChanged.value = true;
    update();
  }

  void resetWeight() {
    if (originalWeight == 0.0) {
      weights.value = 0.0;
      setWeightWholeNumber(70);
      setWeightDecimalNumber(0);
    } else {
      int wholeNumber = originalWeight.value.floor();
      int decimalNumber = ((originalWeight.value - wholeNumber) * 10).round();
      setWeightWholeNumber(wholeNumber);
      setWeightDecimalNumber(decimalNumber);
    }
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
    update();
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

  Future<DataHarian?> fetchLog(DateTime logDate) async {
    isLoading.value = true;
    var dailyLog = await _logService.getLogsByDate(logDate);
    if (dailyLog != null && dailyLog.date != null) {
      dailyLogRequested.value = dailyLog;
      selectedSexActivity.value = dailyLog.sexActivity ?? "";
      selectedBleedingFlow.value = dailyLog.bleedingFlow ?? "";
      selectedVaginalDischarge.value = dailyLog.vaginalDischarge ?? "";

      originalTemperature.value = double.parse(dailyLog.temperature ?? "0.0");
      if (originalTemperature.value == 0.0) {
        temperature.value = 0.0;
      } else {
        temperature.value = double.parse(dailyLog.temperature ?? "0.0");
        int wholeNumber = temperature.value.floor();
        int decimalNumber = ((temperature.value - wholeNumber) * 10).round();
        setTemperatureWholeNumber(wholeNumber);
        setTemperatureDecimalNumber(decimalNumber);
      }

      originalWeight.value = double.parse(dailyLog.weight ?? "0.0");
      if (originalWeight.value == 0.0) {
        weights.value = 0.0;
      } else {
        weights.value = double.parse(dailyLog.weight ?? "0.0");
        int wholeNumber = weights.value.floor();
        int decimalNumber = ((weights.value - wholeNumber) * 10).round();
        setWeightWholeNumber(wholeNumber);
        setWeightDecimalNumber(decimalNumber);
      }

      notes.value = dailyLog.notes ?? "";

      selectedSymptoms.assignAll(
        dailyLog.symptoms?.toJson().entries.where((entry) => entry.value).map((entry) => entry.key).toList() ?? [],
      );

      selectedMoods.assignAll(
        dailyLog.moods?.toJson().entries.where((entry) => entry.value == true).map((entry) => entry.key).toList() ?? [],
      );

      selectedOthers.assignAll(
        dailyLog.others?.toJson().entries.where((entry) => entry.value == true).map((entry) => entry.key).toList() ?? [],
      );

      selectedPhysicalActivity.assignAll(
        dailyLog.physicalActivity?.toJson().entries.where((entry) => entry.value == true).map((entry) => entry.key).toList() ?? [],
      );

      update();
      isLoading.value = false;
      return dailyLog;
    } else {
      isLoading.value = false;
      return null;
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
      physicalActivityData[physicalActivity] = getSelectedPhysicalActivity().contains(physicalActivity);
    });

    return physicalActivityData;
  }

  Future<void> saveLog(context) async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    bool localSuccess = false;
    String formattedDate = formatDate(selectedDate);

    try {
      await _logService.upsertDailyLog(
        formattedDate,
        getSelectedSexActivity(),
        getSelectedBleedingFlow(),
        getUpdatedSymptoms(),
        getSelectedVaginalDischarge(),
        getUpdatedMoods(),
        getUpdatedOthers(),
        getUpdatedPhysicalActivity(),
        getTemperature().toString(),
        getWeight().toString(),
        getNotes(),
      );
      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(context)!.dailyLogSavedSuccess));

      localSuccess = true;
      isChanged.value = false;
      fetchLog(selectedDate);
      update();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.dailyLogSaveFailed));
    }

    if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      try {
        await logRepository.storeLog(
          formattedDate,
          getSelectedSexActivity(),
          getSelectedBleedingFlow(),
          getUpdatedSymptoms(),
          getSelectedVaginalDischarge(),
          getUpdatedMoods(),
          getUpdatedOthers(),
          getUpdatedPhysicalActivity(),
          getTemperature().toString(),
          getWeight().toString(),
          getNotes(),
        );
      } catch (e) {
        saveSyncLog(formattedDate);
      }
    } else if (localSuccess) {
      saveSyncLog(formattedDate);
    }
  }

  Future<void> saveSyncLog(String formattedDate) async {
    Map<String, dynamic> data = {
      "date": formattedDate,
      "sexActivity": getSelectedSexActivity(),
      "bleedingFlow": getSelectedBleedingFlow(),
      "symptoms": getUpdatedSymptoms(),
      "vaginalDischarge": getSelectedVaginalDischarge(),
      "moods": getUpdatedMoods(),
      "others": getUpdatedOthers(),
      "physicalActivity": getUpdatedPhysicalActivity(),
      "temperature": getTemperature().toString(),
      "weight": getWeight().toString(),
      "notes": getNotes(),
    };

    String jsonData = jsonEncode(data);

    SyncLog syncLog = SyncLog(
      tableName: 'tb_data_harian',
      operation: 'upsertDailyLog',
      data: jsonData,
      createdAt: DateTime.now().toString(),
    );

    await _syncDataRepository.addSyncLogData(syncLog);
  }

  Map<String, dynamic> createLogData() {
    return {
      "date": selectedDate.toString(),
      "sexActivity": getSelectedSexActivity(),
      "bleedingFlow": getSelectedBleedingFlow(),
      "symptoms": getUpdatedSymptoms(),
      "vaginalDischarge": getSelectedVaginalDischarge(),
      "moods": getUpdatedMoods(),
      "others": getUpdatedOthers(),
      "physicalActivity": getUpdatedPhysicalActivity(),
      "temperature": getTemperature(),
      "weight": getWeight(),
      "notes": getNotes(),
    };
  }

  Future<void> deleteLog(context) async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    bool localSuccess = false;
    String formattedDate = formatDate(selectedDate);

    try {
      await _logService.deleteDailyLog(formattedDate);
      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(context)!.dailyLogSavedSuccess));

      localSuccess = true;
      isChanged.value = false;
      fetchLog(selectedDate);
      update();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.dailyLogSaveFailed));
    }

    if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      try {
        await logRepository.deleteLog(formattedDate);
      } catch (e) {
        syncDeleteLog(formattedDate);
      }
    } else if (localSuccess) {
      syncDeleteLog(formattedDate);
    }
  }

  Future<void> syncDeleteLog(String formattedDate) async {
    Map<String, dynamic> data = {"date": formattedDate};

    String jsonData = jsonEncode(data);

    SyncLog syncLog = SyncLog(
      tableName: 'tb_data_harian',
      operation: 'deleteDailyLog',
      data: jsonData,
      createdAt: DateTime.now().toString(),
    );

    await _syncDataRepository.addSyncLogData(syncLog);
  }

  Future<void> resetLog() async {
    try {
      setSelectedSexActivity("");
      setSelectedBleedingFlow("");
      setSelectedSymptoms([]);
      setSelectedVaginalDischarge("");
      setSelectedMoods([]);
      setSelectedOthers([]);
      setSelectedPhysicalActivity([]);
      temperature.value = 0;
      weights.value = 0.0;
      notes.value = "";
      isChanged.value = false;

      await saveLog(Get.context);
      update();
    } catch (e) {
      print("Error resetting log: $e");
    }
  }
}
