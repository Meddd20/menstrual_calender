import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_snackbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:periodnpregnancycalender/app/utils/utils.dart';
import 'package:periodnpregnancycalender/app/services/services.dart';
import 'package:periodnpregnancycalender/app/repositories/repositories.dart';
import 'package:periodnpregnancycalender/app/models/models.dart';
import 'package:periodnpregnancycalender/app/common/common.dart';

class PregnancyLogController extends GetxController {
  final StorageService storageService = StorageService();
  final apiService = ApiService();
  late final PregnancyLogAPIRepository pregnancyLogAPIRepository = PregnancyLogAPIRepository(apiService);
  late final PregnancyHistoryService _pregnancyHistoryService;
  late final PregnancyLogService _pregnancyLogService;
  late final SyncDataRepository _syncDataRepository;
  Rx<CurrentlyPregnant> currentlyPregnantData = Rx<CurrentlyPregnant>(CurrentlyPregnant());
  RxList<WeeklyData> weeklyData = <WeeklyData>[].obs;
  RxBool isChanged = RxBool(false);

  @override
  void onInit() {
    _syncDataRepository = SyncDataRepository();
    _pregnancyHistoryService = PregnancyHistoryService();
    _pregnancyLogService = PregnancyLogService();
    fetchPregnancyData();
    fetchPregnancyLog(DateTime.now());
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

  final Rx<DateTime> _focusedDate = Rx<DateTime>(DateTime.now());
  DateTime get getFocusedDate => _focusedDate.value;

  void setFocusedDate(DateTime selectedDate) {
    _focusedDate.value = selectedDate;
    update();
  }

  final Rx<DateTime> _selectedDate = Rx<DateTime>(DateTime.now());
  DateTime get selectedDate => _selectedDate.value;
  void setSelectedDate(DateTime selectedDate) {
    _selectedDate.value = selectedDate;
    update();
  }

  RxList<String> selectedPregnancySymptoms = RxList<String>();
  RxList<String> getSelectedPregnancySymptoms() => selectedPregnancySymptoms;
  void setSelectedPregnancySymptoms(List<String> list) {
    selectedPregnancySymptoms.value = list;
    isChanged.value = true;
    update();
  }

  Map<String, bool> getUpdatedSymptoms() {
    Map<String, bool> symptomsData = {};

    pregnancySymptoms.forEach((symptom) {
      symptomsData[symptom] = getSelectedPregnancySymptoms().contains(symptom);
    });

    return symptomsData;
  }

  RxString notes = RxString("");
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

  Rx<int?> _fundusUteriHeightWholeNumber = Rx<int?>(14);
  int get selectedFundusUteriHeightWholeNumber => _fundusUteriHeightWholeNumber.value ?? currentWeek.value;
  void setFundusUteriHeightWholeNumber(int fundusUteriHeightWholeNumber) {
    _fundusUteriHeightWholeNumber.value = fundusUteriHeightWholeNumber;
    setAutoGenerateTFUNote();
    update();
  }

  Rx<int?> _fundusUteriHeightDecimalNumber = Rx<int?>(0);
  int get selectedFundusUteriHeightDecimalNumber => _fundusUteriHeightDecimalNumber.value ?? 0;
  void setFundusUteriHeightDecimalNumber(int fundusUteriHeightDecimalNumber) {
    _fundusUteriHeightDecimalNumber.value = fundusUteriHeightDecimalNumber;
    update();
  }

  var fundusUteriHeight = Rx<double>(0.0);
  RxnDouble originalFundusUteriHeight = RxnDouble();

  double getFundusUteriHeight() => fundusUteriHeight.value;

  void updateFundusUteriHeight() {
    fundusUteriHeight.value = double.parse("${selectedFundusUteriHeightWholeNumber}.${selectedFundusUteriHeightDecimalNumber}");
    originalFundusUteriHeight.value = fundusUteriHeight.value;
    isChanged.value = true;
    update();
  }

  void resetFundusUteriHeight() {
    if (originalFundusUteriHeight == 0.0 && originalFundusUteriHeight.value == null) {
      fundusUteriHeight.value = 0.0;
      setFundusUteriHeightWholeNumber(currentWeek.value);
      setFundusUteriHeightDecimalNumber(0);
    } else {
      int wholeNumber = originalFundusUteriHeight.value!.floor();
      int decimalNumber = ((originalFundusUteriHeight.value! - wholeNumber) * 10).round();
      setFundusUteriHeightWholeNumber(wholeNumber);
      setFundusUteriHeightDecimalNumber(decimalNumber);
    }
  }

  RxString _autoGenerateTFUNote = "*Tinggi fundus uteri sesuai dengan usia kehamilan.".obs;
  String get selectedAutoGenerateTFUNote => _autoGenerateTFUNote.value;
  void setAutoGenerateTFUNote() {
    int lowerLimit = currentWeek.value - 2;
    int upperLimit = currentWeek.value + 2;

    if (selectedFundusUteriHeightWholeNumber >= lowerLimit && selectedFundusUteriHeightWholeNumber <= upperLimit)
      _autoGenerateTFUNote.value = "*Tinggi fundus uteri sesuai dengan usia kehamilan.";
    else if (selectedFundusUteriHeightWholeNumber < lowerLimit)
      _autoGenerateTFUNote.value = "*Tinggi fundus uteri lebih kecil dari yang diharapkan, pemeriksaan lebih lanjut disarankan.";
    else
      _autoGenerateTFUNote.value = "*Tinggi fundus uteri lebih besar dari yang diharapkan, pemeriksaan lebih lanjut disarankan.";
  }

  RxInt fetalHeartRate = 120.obs;
  RxnInt originalFetalHeartRate = RxnInt();
  int get selectedFetalHeartRate => fetalHeartRate.value;
  void setFetalHeartRate(int value) {
    fetalHeartRate.value = value;
    setAutoGenerateDJJNote(value);
    heartRateFetus(value);
    update();
  }

  RxString _autoGenerateDJJNote = "*Denyut janin jantung berada dalam rentang normal.".obs;
  String get selectedAutoGenerateDJJNote => _autoGenerateDJJNote.value;
  void setAutoGenerateDJJNote(int denyutNadiJanin) {
    if (denyutNadiJanin < 120)
      _autoGenerateDJJNote.value = "*Denyut janin jantung lebih rendah dari normal, disarankan pemeriksaan lanjutan.";
    else if (denyutNadiJanin > 160)
      _autoGenerateDJJNote.value = "*Denyut janin jantung lebih tinggi dari normal, disarankan pemeriksaan lanjutan.";
    else
      _autoGenerateDJJNote.value = "*Denyut janin jantung berada dalam rentang normal.";
  }

  RxString _heartRateFetus = "Normal".obs;
  String get selectedHeartRateFetus => _heartRateFetus.value;
  void heartRateFetus(int denyutNadiJanin) {
    if (denyutNadiJanin < 120)
      _heartRateFetus.value = "Bradycardia";
    else if (denyutNadiJanin > 160)
      _heartRateFetus.value = "Tachycardia";
    else
      _heartRateFetus.value = "Normal";
  }

  RxnString originalHeartRateMethod = RxnString();
  RxString _heartRateMethod = "Doppler".obs;
  String get selectedHeartRateMethod => _heartRateMethod.value;
  void setHeartRateMethod(String method) {
    originalHeartRateMethod.value = method;
    _heartRateMethod.value = method;
    update();
  }

  void resetFetalHeartRate() {
    if (originalFetalHeartRate.value == null) {
      fetalHeartRate.value = 120;
      setAutoGenerateDJJNote(120);
      heartRateFetus(120);
      setHeartRateMethod("Doppler");
      update();
    } else {
      fetalHeartRate.value = originalFetalHeartRate.value!;
      setAutoGenerateDJJNote(originalFetalHeartRate.value!);
      heartRateFetus(originalFetalHeartRate.value!);
      setHeartRateMethod(originalHeartRateMethod.value ?? "Doppler");
      update();
    }
  }

  void updateFetalHeartRate() {
    originalHeartRateMethod.value = selectedHeartRateMethod;
    originalFetalHeartRate.value = selectedFetalHeartRate;
    setAutoGenerateDJJNote(originalFetalHeartRate.value!);
    heartRateFetus(originalFetalHeartRate.value!);
    isChanged.value = true;
  }

  RxnString originalFetalPosition = RxnString();
  RxString _fetalPosition = "Cephalic".obs;
  String get selectedFetalPosition => _fetalPosition.value;
  void setFetalPosition(String method) {
    originalFetalPosition.value = method;
    _fetalPosition.value = method;
    update();
  }

  RxnString originalPlacentaCondition = RxnString();
  RxString _placentaCondition = "Normal".obs;
  String get selectedPlacentaCondition => _placentaCondition.value;
  void setPlacentaCondition(String condition) {
    originalPlacentaCondition.value = condition;
    _placentaCondition.value = condition;
    setPlacentaConditionExplanation(condition);
    update();
  }

  RxString placentaConditionDesc = "".obs;
  void setPlacentaConditionExplanation(String condition) {
    placentaConditionDesc.value = switch (condition) {
      "Normal" => "*Plasenta dalam kondisi sehat tanpa komplikasi.",
      "Previa" => "*Plasenta menutupi serviks, dapat menyebabkan masalah saat persalinan.",
      "Acretia" => "*Plasenta tumbuh terlalu dalam ke dinding rahim, berisiko mengganggu proses pelepasan plasenta.",
      "Abruptio" => "*Plasenta terlepas dari dinding rahim sebelum melahirkan.",
      "Insufficiency" => "*Plasenta tidak cukup memberi oksigen dan nutrisi untuk janin.",
      _ => "*Kondisi yang kurang umum atau tidak disebutkan.",
    };
  }

  TextEditingController fetalWeight = TextEditingController();
  RxnString originalFetalWeight = RxnString();
  void setFetalWeight(String weight) {
    originalFetalWeight.value = weight;
    fetalWeight.text = weight;
    update();
  }

  void updateUSG() {
    originalFetalPosition.value = selectedFetalPosition;
    originalPlacentaCondition.value = selectedPlacentaCondition;
    originalFetalWeight.value = fetalWeight.text;
    isChanged.value = true;
  }

  RxList<DateTime> tanggalAwalMinggu = <DateTime>[].obs;
  RxList<DateTime> tanggalAkhirMinggu = <DateTime>[].obs;

  Future<void> fetchPregnancyData() async {
    var result = await _pregnancyHistoryService.getCurrentPregnancyData(storageService.getLanguage());
    currentlyPregnantData.value = result!;
    weeklyData.assignAll(currentlyPregnantData.value.weeklyData!);

    for (var entry in weeklyData) {
      if (entry.tanggalAwalMinggu != null) {
        DateTime parsedDate = formatDateStr(entry.tanggalAwalMinggu!);
        tanggalAwalMinggu.add(parsedDate);
      }
      if (entry.tanggalAkhirMinggu != null) {
        DateTime parsedDate = formatDateStr(entry.tanggalAkhirMinggu!);
        tanggalAkhirMinggu.add(parsedDate);
      }
    }
    currentDatePregnancyWeek(DateTime.now());

    update();
  }

  RxInt currentWeek = 1.obs;
  void currentDatePregnancyWeek(DateTime date) {
    for (int i = 0; i < tanggalAwalMinggu.length; i++) {
      DateTime start = tanggalAwalMinggu[i];
      DateTime end = tanggalAkhirMinggu[i];

      if (date.isAfter(start.subtract(Duration(days: 1))) && date.isBefore(end.add(Duration(days: 1)))) {
        currentWeek.value = i + 1;
        break;
      }
    }
  }

  Future<void> fetchPregnancyLog(DateTime date) async {
    var pregnancyLog = await _pregnancyLogService.getPregnancyLogByDate(formatDate(date));
    if (pregnancyLog != null) {
      originalTemperature.value = double.tryParse(pregnancyLog.temperature ?? "0.0") ?? 0.0;
      if (originalTemperature.value == 0.0) {
        temperature.value = 0.0;
      } else {
        temperature.value = double.tryParse(pregnancyLog.temperature ?? "0.0") ?? 0.0;
        int wholeNumber = temperature.value.floor();
        int decimalNumber = ((temperature.value - wholeNumber) * 10).round();
        setTemperatureWholeNumber(wholeNumber);
        setTemperatureDecimalNumber(decimalNumber);
      }
      selectedPregnancySymptoms.assignAll(
        pregnancyLog.pregnancySymptoms?.toJson().entries.where((entry) => entry.value).map((entry) => entry.key).toList() ?? [],
      );
      print(selectedPregnancySymptoms.toJson());
      notes.value = pregnancyLog.notes ?? "";
      originalFundusUteriHeight.value = pregnancyLog.fundusUteriHeight ?? null;
      originalFetalHeartRate.value = pregnancyLog.fetalHeartRate ?? null;
      originalHeartRateMethod.value = pregnancyLog.examinationMethod ?? null;
      originalFetalPosition.value = pregnancyLog.fetalPosition ?? null;
      originalPlacentaCondition.value = pregnancyLog.placentaCondition ?? null;
      originalFetalWeight.value = pregnancyLog.fetalWeight?.toString() ?? null;
      fetalWeight.text = pregnancyLog.fetalWeight?.toString() ?? "";
      update();
    }
  }

  Future<void> savePregnancyLog(context) async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    bool localSuccess = false;
    String formattedDate = formatDate(selectedDate);
    PregnancyDailyLog? pregnancyDailyLog;

    try {
      print("${originalFetalHeartRate.value} ${originalHeartRateMethod.value} ${originalFetalPosition.value} ${originalPlacentaCondition.value} ${int.tryParse(originalFetalWeight.value ?? "")}");
      pregnancyDailyLog = await _pregnancyLogService.upsertPregnancyDailyLog(
        selectedDate,
        getUpdatedSymptoms(),
        getTemperature(),
        getNotes(),
        originalFundusUteriHeight.value,
        originalFetalHeartRate.value,
        originalHeartRateMethod.value,
        originalFetalPosition.value,
        originalPlacentaCondition.value,
        int.tryParse(originalFetalWeight.value ?? ""),
      );
      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(context)!.pregnancyLogSavedSuccess));

      localSuccess = true;
      isChanged.value = false;
      fetchPregnancyLog(selectedDate);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.pregnancyLogSaveFailed));
      return;
    }

    if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      try {
        await SyncDataService().pendingDataChange();
        await pregnancyLogAPIRepository.storePregnancyLog(selectedDate, getUpdatedSymptoms(), getTemperature(), getNotes());
      } catch (e) {
        saveSyncPregnancyLog(formattedDate, pregnancyDailyLog?.riwayatKehamilanId ?? 0);
      }
    } else if (localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      saveSyncPregnancyLog(formattedDate, pregnancyDailyLog?.riwayatKehamilanId ?? 0);
    }
  }

  Future<void> saveSyncPregnancyLog(String formattedDate, int pregnancyId) async {
    SyncLog syncLog = SyncLog(
      tableName: 'pregnancy_log',
      operation: 'create',
      dataId: pregnancyId,
      optionalId: formattedDate,
      createdAt: DateTime.now().toString(),
    );

    await _syncDataRepository.addSyncLogData(syncLog);
  }

  Future<void> deletePregnancyLog(context, DateTime date) async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    bool localSuccess = false;
    String formattedDate = formatDate(date);
    PregnancyDailyLog? pregnancyDailyLog;

    try {
      pregnancyDailyLog = await _pregnancyLogService.deletePregnancyDailyLog(formattedDate);

      localSuccess = true;
      isChanged.value = false;
      fetchPregnancyLog(selectedDate);
      update();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.pregnancyLogResetFailed));
      return;
    }

    if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      try {
        await SyncDataService().pendingDataChange();
        await pregnancyLogAPIRepository.deletePregnancyLog(date);
      } catch (e) {
        syncDeletePregnancyLog(formattedDate, pregnancyDailyLog?.riwayatKehamilanId ?? 0);
      }
    } else if (localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      syncDeletePregnancyLog(formattedDate, pregnancyDailyLog?.riwayatKehamilanId ?? 0);
    }
  }

  Future<void> syncDeletePregnancyLog(String formattedDate, int pregnancyId) async {
    SyncLog syncLog = SyncLog(
      tableName: 'pregnancy_log',
      operation: 'delete',
      dataId: pregnancyId,
      optionalId: formattedDate,
      createdAt: DateTime.now().toString(),
    );

    await _syncDataRepository.addSyncLogData(syncLog);
  }

  List<String> pregnancySymptoms = [
    "Altered Body Image",
    "Anxiety",
    "Back Pain",
    "Breast Pain",
    "Brownish Marks on Face",
    "Carpal Tunnel",
    "Changes in Libido",
    "Changes in Nipples",
    "Constipation",
    "Dizziness",
    "Dry Mouth",
    "Fainting",
    "Feeling Depressed",
    "Food Cravings",
    "Forgetfulness",
    "Greasy Skin/Acne",
    "Haemorrhoids",
    "Headache",
    "Heart Palpitations",
    "Hip/Pelvic Pain",
    "Increased Vaginal Discharge",
    "Incontinence/Leaking Urine",
    "Itchy Skin",
    "Leg Cramps",
    "Nausea",
    "Painful Vaginal Veins",
    "Poor Sleep",
    "Reflux",
    "Restless Legs",
    "Shortness of Breath",
    "Sciatica",
    "Snoring",
    "Sore Nipples",
    "Stretch Marks",
    "Swollen Hands/Feet",
    "Taste/Smell Changes",
    "Thrush",
    "Tiredness/Fatigue",
    "Urinary Frequency",
    "Varicose Veins",
    "Vivid Dreams",
    "Vomiting"
  ];

  Map<String, String> pregnancySymptomsTranslate(context) {
    return {
      "Altered Body Image": AppLocalizations.of(context)!.alteredBodyImage,
      "Anxiety": AppLocalizations.of(context)!.anxiety,
      "Back Pain": AppLocalizations.of(context)!.backPain,
      "Breast Pain": AppLocalizations.of(context)!.breastPain,
      "Brownish Marks on Face": AppLocalizations.of(context)!.brownishMarksOnFace,
      "Carpal Tunnel": AppLocalizations.of(context)!.carpalTunnel,
      "Changes in Libido": AppLocalizations.of(context)!.changesInLibido,
      "Changes in Nipples": AppLocalizations.of(context)!.changesInNipples,
      "Constipation": AppLocalizations.of(context)!.constipation,
      "Dizziness": AppLocalizations.of(context)!.dizziness,
      "Dry Mouth": AppLocalizations.of(context)!.dryMouth,
      "Fainting": AppLocalizations.of(context)!.fainting,
      "Feeling Depressed": AppLocalizations.of(context)!.feelingDepressed,
      "Food Cravings": AppLocalizations.of(context)!.foodCravings,
      "Forgetfulness": AppLocalizations.of(context)!.forgetfulness,
      "Greasy Skin/Acne": AppLocalizations.of(context)!.greasySkinAcne,
      "Haemorrhoids": AppLocalizations.of(context)!.haemorrhoids,
      "Headache": AppLocalizations.of(context)!.headache,
      "Heart Palpitations": AppLocalizations.of(context)!.heartPalpitations,
      "Hip/Pelvic Pain": AppLocalizations.of(context)!.hipPelvicPain,
      "Increased Vaginal Discharge": AppLocalizations.of(context)!.increasedVaginalDischarge,
      "Incontinence/Leaking Urine": AppLocalizations.of(context)!.incontinenceLeakingUrine,
      "Itchy Skin": AppLocalizations.of(context)!.itchySkin,
      "Leg Cramps": AppLocalizations.of(context)!.legCramps,
      "Nausea": AppLocalizations.of(context)!.nausea,
      "Painful Vaginal Veins": AppLocalizations.of(context)!.painfulVaginalVeins,
      "Poor Sleep": AppLocalizations.of(context)!.poorSleep,
      "Reflux": AppLocalizations.of(context)!.reflux,
      "Restless Legs": AppLocalizations.of(context)!.restlessLegs,
      "Shortness of Breath": AppLocalizations.of(context)!.shortnessOfBreath,
      "Sciatica": AppLocalizations.of(context)!.sciatica,
      "Snoring": AppLocalizations.of(context)!.snoring,
      "Sore Nipples": AppLocalizations.of(context)!.soreNipples,
      "Stretch Marks": AppLocalizations.of(context)!.stretchMarks,
      "Swollen Hands/Feet": AppLocalizations.of(context)!.swollenHandsFeet,
      "Taste/Smell Changes": AppLocalizations.of(context)!.tasteSmellChanges,
      "Thrush": AppLocalizations.of(context)!.thrush,
      "Tiredness/Fatigue": AppLocalizations.of(context)!.tirednessFatigue,
      "Urinary Frequency": AppLocalizations.of(context)!.urinaryFrequency,
      "Varicose Veins": AppLocalizations.of(context)!.varicoseVeins,
      "Vivid Dreams": AppLocalizations.of(context)!.vividDreams,
      "Vomiting": AppLocalizations.of(context)!.vomiting,
    };
  }
}
