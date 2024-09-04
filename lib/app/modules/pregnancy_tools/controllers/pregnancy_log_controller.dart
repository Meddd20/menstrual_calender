import 'dart:convert';

import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_snackbar.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_model.dart';
import 'package:periodnpregnancycalender/app/models/sync_log_model.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/pregnancy_log_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/master_kehamilan_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/period_history_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/pregnancy_history_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/pregnancy_log_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/profile_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/sync_data_repository.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/services/pregnancy_history_service.dart';
import 'package:periodnpregnancycalender/app/services/pregnancy_log_service.dart';
import 'package:periodnpregnancycalender/app/utils/conectivity.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';
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
    final DatabaseHelper databaseHelper = DatabaseHelper.instance;
    final LocalProfileRepository localProfileRepository = LocalProfileRepository(databaseHelper);
    final PregnancyHistoryRepository pregnancyHistoryRepository = PregnancyHistoryRepository(databaseHelper);
    final MasterDataKehamilanRepository masterKehamilanRepository = MasterDataKehamilanRepository(databaseHelper);
    final PeriodHistoryRepository periodHistoryRepository = PeriodHistoryRepository(databaseHelper);
    final PregnancyLogRepository pregnancyLogRepository = PregnancyLogRepository(databaseHelper);
    _syncDataRepository = SyncDataRepository(databaseHelper);
    _pregnancyHistoryService = PregnancyHistoryService(
      pregnancyHistoryRepository,
      masterKehamilanRepository,
      periodHistoryRepository,
      localProfileRepository,
    );
    _pregnancyLogService = PregnancyLogService(
      pregnancyLogRepository,
      pregnancyHistoryRepository,
    );
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

    try {
      await _pregnancyLogService.upsertPregnancyDailyLog(selectedDate, getUpdatedSymptoms(), getTemperature(), getNotes());
      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(context)!.pregnancyLogSavedSuccess));

      localSuccess = true;
      isChanged.value = false;
      fetchPregnancyLog(selectedDate);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.pregnancyLogSaveFailed));
    }

    if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      try {
        await pregnancyLogAPIRepository.storePregnancyLog(selectedDate, getUpdatedSymptoms(), getTemperature(), getNotes());
      } catch (e) {
        saveSyncPregnancyLog(formattedDate);
      }
    } else if (localSuccess) {
      saveSyncPregnancyLog(formattedDate);
    }
  }

  Future<void> saveSyncPregnancyLog(String formattedDate) async {
    Map<String, dynamic> data = {
      "date": formattedDate,
      "pregnancySymptoms": getUpdatedSymptoms(),
      "temperature": getTemperature().toString(),
      "notes": getNotes(),
    };

    String jsonData = jsonEncode(data);

    SyncLog syncLog = SyncLog(
      tableName: 'tb_data_harian_kehamilan',
      operation: 'upsertPregnancyDailyLog',
      data: jsonData,
      createdAt: DateTime.now().toString(),
    );

    await _syncDataRepository.addSyncLogData(syncLog);
  }

  Future<void> deletePregnancyLog(context, DateTime date) async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    bool localSuccess = false;
    String formattedDate = formatDate(date);

    try {
      await _pregnancyLogService.deletePregnancyDailyLog(formattedDate);

      localSuccess = true;
      isChanged.value = false;
      fetchPregnancyLog(selectedDate);
      update();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.pregnancyLogResetFailed));
    }
    if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      try {
        await pregnancyLogAPIRepository.deletePregnancyLog(date);
      } catch (e) {
        syncDeletePregnancyLog(formattedDate);
      }
    } else {
      syncDeletePregnancyLog(formattedDate);
    }
  }

  Future<void> syncDeletePregnancyLog(String formattedDate) async {
    Map<String, dynamic> data = {
      "date": formattedDate,
    };

    String jsonData = jsonEncode(data);

    SyncLog syncLog = SyncLog(
      tableName: 'tb_data_harian_kehamilan',
      operation: 'deletePregnancyDailyLog',
      data: jsonData,
      createdAt: DateTime.now().toString(),
    );

    await _syncDataRepository.addSyncLogData(syncLog);
  }

  List<String> pregnancySymptoms = [
    "Aches and Pains",
    "Abdominal Pressure",
    "Abdominal Stretching",
    "Baby Kicks",
    "Back Pain",
    "Backaches",
    "Breast Enlargement",
    "Breast Soreness",
    "Breast Swelling",
    "Breast Tenderness",
    "Breathlessness",
    "Carpal Tunnel Syndrome",
    "Changes in Libido",
    "Clumsiness",
    "Constipation",
    "Cervical Dilation",
    "Decreased Libido",
    "Darkening of Skin",
    "Dizziness",
    "Dry Eyes",
    "Dry Mouth",
    "Dry Skin",
    "Easier Breathing",
    "Excessive Salivation",
    "Fast-Growing Hair and Nails",
    "Fatigue",
    "Food Aversions",
    "Food Cravings",
    "Frequent Headaches",
    "Frequent Urination",
    "General Discomfort",
    "Gum Sensitivity",
    "Hair Growth Changes",
    "Heart Palpitations",
    "Heartburn",
    "Hip Pain",
    "Hip, Groin, and Abdominal Pain",
    "Hemorrhoids",
    "Increased Appetite",
    "Increased Saliva",
    "Increased Thirst",
    "Increased Urge to Push",
    "Increased Vaginal Discharge",
    "Insomnia",
    "Itchiness in Hands and Feet",
    "Leg Cramps",
    "Leg Swelling",
    "Leaky Breasts",
    "Loose Ligaments",
    "Loss of Mucus Plug",
    "Lower Back Pain",
    "Mood Swings",
    "Nasal Congestion",
    "Nausea and Vomiting",
    "Numbness or Tingling",
    "Pelvic Pain",
    "Pelvic Pain as Baby Descends",
    "Pelvic Pressure",
    "Pregnancy Brain (Forgetfulness)",
    "Pregnancy Glow",
    "Round Ligament Pain",
    "Skin Changes",
    "Shortness of Breath",
    "Spotting After Sex",
    "Stuffy Nose",
    "Stretch Marks",
    "Swelling in Hands and Feet",
    "Swollen Feet",
    "Vivid Dreams",
    "Varicose Veins",
    "Water Breaking",
  ];

  Map<String, String> pregnancySymptomsTranslate(context) {
    return {
      "Aches and Pains": "Nyeri",
      "Abdominal Pressure": "Tekanan Perut",
      "Abdominal Stretching": "Peregangan Perut",
      "Baby Kicks": "Tendangan Bayi",
      "Back Pain": "Sakit Punggung",
      "Backaches": "Nyeri Punggung",
      "Breast Enlargement": "Pembesaran Payudara",
      "Breast Soreness": "Nyeri Payudara",
      "Breast Swelling": "Bengkak Payudara",
      "Breast Tenderness": "Payudara Sensitif",
      "Breathlessness": "Sesak Napas",
      "Carpal Tunnel Syndrome": "Nyeri Pergelangan",
      "Changes in Libido": "Perubahan Libido",
      "Clumsiness": "Kikuk",
      "Constipation": "Sembelit",
      "Cervical Dilation": "Pembukaan Serviks",
      "Decreased Libido": "Libido Menurun",
      "Darkening of Skin": "Kulit Menggelap",
      "Dizziness": "Pusing",
      "Dry Eyes": "Mata Kering",
      "Dry Mouth": "Mulut Kering",
      "Dry Skin": "Kulit Kering",
      "Easier Breathing": "Napas Lebih Mudah",
      "Excessive Salivation": "Air Liur Berlebih",
      "Fast-Growing Hair and Nails": "Rambut/Kuku Cepat Tumbuh",
      "Fatigue": "Lelah",
      "Food Aversions": "Mual Makanan",
      "Food Cravings": "Ngidam",
      "Frequent Headaches": "Sering Sakit Kepala",
      "Frequent Urination": "Sering Buang Air Kecil",
      "General Discomfort": "Tidak Nyaman",
      "Gum Sensitivity": "Gusi Sensitif",
      "Hair Growth Changes": "Perubahan Rambut",
      "Heart Palpitations": "Jantung Berdebar",
      "Heartburn": "Maag",
      "Hip Pain": "Nyeri Pinggul",
      "Hip, Groin, and Abdominal Pain": "Nyeri Pinggul/Perut",
      "Hemorrhoids": "Wasir",
      "Increased Appetite": "Nafsu Makan Bertambah",
      "Increased Saliva": "Air Liur Bertambah",
      "Increased Thirst": "Haus Bertambah",
      "Increased Urge to Push": "Dorongan Mendorong",
      "Increased Vaginal Discharge": "Keputihan Bertambah",
      "Insomnia": "Sulit Tidur",
      "Itchiness in Hands and Feet": "Gatal di Tangan/Kaki",
      "Leg Cramps": "Kram Kaki",
      "Leg Swelling": "Bengkak Kaki",
      "Leaky Breasts": "Payudara Bocor",
      "Loose Ligaments": "Ligamen Longgar",
      "Loss of Mucus Plug": "Lendir Hilang",
      "Lower Back Pain": "Nyeri Punggung Bawah",
      "Mood Swings": "Perubahan Mood",
      "Nasal Congestion": "Hidung Tersumbat",
      "Nausea and Vomiting": "Mual dan Muntah",
      "Numbness or Tingling": "Mati Rasa/Kesemutan",
      "Pelvic Pain": "Nyeri Panggul",
      "Pelvic Pain as Baby Descends": "Nyeri Saat Bayi Turun",
      "Pelvic Pressure": "Tekanan Panggul",
      "Pregnancy Brain (Forgetfulness)": "Pelupa Kehamilan",
      "Pregnancy Glow": "Kulit Bersinar",
      "Round Ligament Pain": "Nyeri Ligamen",
      "Skin Changes": "Perubahan Kulit",
      "Shortness of Breath": "Sesak Napas",
      "Spotting After Sex": "Bercak Setelah Berhubungan",
      "Stuffy Nose": "Hidung Tersumbat",
      "Stretch Marks": "Garis Perut",
      "Swelling in Hands and Feet": "Bengkak Tangan/Kaki",
      "Swollen Feet": "Kaki Bengkak",
      "Vivid Dreams": "Mimpi Jelas",
      "Varicose Veins": "Varises",
      "Water Breaking": "Ketuban Pecah",
    };
  }
}
