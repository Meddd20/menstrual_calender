import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_snackbar.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_daily_log_model.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_model.dart';
import 'package:periodnpregnancycalender/app/models/sync_log_model.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/pregnancy_log_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/sync_data_repository.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/services/pregnancy_history_service.dart';
import 'package:periodnpregnancycalender/app/services/pregnancy_log_service.dart';
import 'package:periodnpregnancycalender/app/utils/conectivity.dart';
import 'package:periodnpregnancycalender/app/utils/helpers.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

    update();
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

      update();
    }
  }

  Future<void> savePregnancyLog(context) async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    bool localSuccess = false;
    String formattedDate = formatDate(selectedDate);
    PregnancyDailyLog? pregnancyDailyLog;

    try {
      pregnancyDailyLog = await _pregnancyLogService.upsertPregnancyDailyLog(selectedDate, getUpdatedSymptoms(), getTemperature(), getNotes());
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
        await pregnancyLogAPIRepository.storePregnancyLog(selectedDate, getUpdatedSymptoms(), getTemperature(), getNotes());
      } catch (e) {
        saveSyncPregnancyLog(formattedDate, pregnancyDailyLog?.id ?? 0);
      }
    } else if (localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      saveSyncPregnancyLog(formattedDate, pregnancyDailyLog?.id ?? 0);
    }
  }

  Future<void> saveSyncPregnancyLog(String formattedDate, int pregnancylog_id) async {
    SyncLog syncLog = SyncLog(
      tableName: 'pregnancy_log',
      operation: 'create',
      dataId: pregnancylog_id,
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
        await pregnancyLogAPIRepository.deletePregnancyLog(date);
      } catch (e) {
        syncDeletePregnancyLog(formattedDate, pregnancyDailyLog?.id ?? 0);
      }
    } else if (localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      syncDeletePregnancyLog(formattedDate, pregnancyDailyLog?.id ?? 0);
    }
  }

  Future<void> syncDeletePregnancyLog(String formattedDate, int pregnancylog_id) async {
    SyncLog syncLog = SyncLog(
      tableName: 'pregnancy_log',
      operation: 'delete',
      dataId: pregnancylog_id,
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
