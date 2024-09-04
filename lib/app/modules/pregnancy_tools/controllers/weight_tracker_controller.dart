import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_snackbar.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_model.dart' as Pregnancy;
import 'package:periodnpregnancycalender/app/models/pregnancy_weight_gain.dart';
import 'package:periodnpregnancycalender/app/models/sync_log_model.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/views/weight_tracker_view.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/pregnancy_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/master_kehamilan_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/period_history_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/pregnancy_history_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/profile_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/sync_data_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/weight_history_repository.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/services/pregnancy_history_service.dart';
import 'package:periodnpregnancycalender/app/services/weight_history_service.dart';
import 'package:periodnpregnancycalender/app/utils/conectivity.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';
import 'package:periodnpregnancycalender/app/utils/helpers.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WeightTrackerController extends GetxController {
  final ApiService apiService = ApiService();
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;
  late final PregnancyRepository pregnancyRepository = PregnancyRepository(apiService);
  late Future<void> weightGainIndexData;
  Rx<PregnancyWeightGainData?> pregnancyWeightGainData = Rx<PregnancyWeightGainData>(PregnancyWeightGainData());
  RxList<WeightHistory> weightGainHistory = <WeightHistory>[].obs;
  RxList<RecommendWeightGain> reccomendWeightGain = <RecommendWeightGain>[].obs;
  FocusNode focusNode = FocusNode();
  late final SyncDataRepository _syncDataRepository;
  late final PregnancyHistoryService _pregnancyHistoryService;
  late final WeightHistoryService _weightHistoryService;
  final StorageService storageService = StorageService();
  RxBool isTwin = RxBool(false);

  PregnancyWeightGainData? get getPregnancyWeightGainData => pregnancyWeightGainData.value;
  List<WeightHistory>? get getweightGainHistory => weightGainHistory;

  Rx<Pregnancy.CurrentlyPregnant> currentlyPregnantData = Rx<Pregnancy.CurrentlyPregnant>(Pregnancy.CurrentlyPregnant());
  RxList<Pregnancy.WeeklyData> weeklyData = <Pregnancy.WeeklyData>[].obs;

  @override
  void onInit() {
    super.onInit();
    final databaseHelper = DatabaseHelper.instance;
    final weightHistoryRepository = WeightHistoryRepository(databaseHelper);
    final pregnancyHistoryRepository = PregnancyHistoryRepository(databaseHelper);
    final masterKehamilanRepository = MasterDataKehamilanRepository(databaseHelper);
    final periodHistoryRepository = PeriodHistoryRepository(databaseHelper);
    final localProfileRepository = LocalProfileRepository(databaseHelper);
    _syncDataRepository = SyncDataRepository(databaseHelper);
    _pregnancyHistoryService = PregnancyHistoryService(pregnancyHistoryRepository, masterKehamilanRepository, periodHistoryRepository, localProfileRepository);
    _weightHistoryService = WeightHistoryService(weightHistoryRepository, pregnancyHistoryRepository);

    weightGainIndexData = fetchWeightGainIndex().then((_) {
      update();
    });
    getSelectedWeek(DateTime.now());
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

  final Rx<DateTime?> _selectedDate = Rx<DateTime?>(DateTime.now());

  DateTime? get selectedDate => _selectedDate.value;

  void setSelectedDate(DateTime selectedDate) {
    _selectedDate.value = selectedDate;
    update();
  }

  final Rx<int?> _selectedWeight = Rx<int?>(30);

  int? get selectedWeight => _selectedWeight.value;

  void setSelectedWeight(int selectedDate) {
    _selectedWeight.value = selectedDate;
    updateWeight();
    update();
  }

  final Rx<int?> _selectedWeightDecimal = Rx<int?>(0);

  int? get selectedWeightDecimal => _selectedWeightDecimal.value;

  void setSelectedWeightDecimal(int selectedDate) {
    _selectedWeightDecimal.value = selectedDate;
    updateWeight();
    update();
  }

  var weights = Rx<double>(0.0);

  double getWeight() => weights.value;

  void updateWeight() {
    weights.value = double.parse("${selectedWeight ?? 30}.${selectedWeightDecimal ?? 0}");
    update();
  }

  void resetValue() {
    setFocusedDate(DateTime.now());
    setSelectedDate(DateTime.now());
    setSelectedWeight(30);
    setSelectedWeightDecimal(0);
    getSelectedWeek(DateTime.now());
  }

  final Rx<int> _selectedWeek = Rx<int>(0);

  int get selectedWeek => _selectedWeek.value;
  void setSelectedWeek(int week) {
    _selectedWeek.value = week;
    updateWeight();
    update();
  }

  void getSelectedWeek(DateTime date) {
    for (int i = 0; i < tanggalAwalMinggu.length; i++) {
      if (date.isAfter(tanggalAwalMinggu[i].subtract(Duration(days: 1))) && date.isBefore(tanggalAkhirMinggu[i].add(Duration(days: 1)))) {
        _selectedWeek.value = i + 1;
        break;
      }
    }
  }

  double getMinWeightGain(List<WeightHistory> weightGainHistory) {
    if (weightGainHistory.isEmpty) {
      return 0.0;
    }
    return weightGainHistory.map((data) => data.beratBadan!).reduce((value, element) => value < element ? value : element);
  }

  double getMinReccomendWeightGain(List<RecommendWeightGain> recommendWeightLower) {
    if (reccomendWeightGain.isEmpty) {
      return 0.0;
    }
    return recommendWeightLower.map((data) => data.recommendWeightLower!).reduce((value, element) => value < element ? value : element);
  }

  double getMinYAxisValue(List<WeightHistory> weightGainHistory, List<RecommendWeightGain> reccomendWeightGain) {
    double minWeightHistory = getMinWeightGain(weightGainHistory);
    double minReccomendWeightGain = getMinReccomendWeightGain(reccomendWeightGain);

    return minWeightHistory < minReccomendWeightGain ? minWeightHistory : minReccomendWeightGain;
  }

  final Rx<int?> _selectedInitHeight = Rx<int?>(125);
  final Rx<int?> _selectedInitHeightDecimal = Rx<int?>(0);

  int? get selectedInitHeight => _selectedInitHeight.value;
  int? get selectedInitHeightDecimal => _selectedInitHeightDecimal.value;

  void setSelectedInitHeight(int selectedWeight) {
    _selectedInitHeight.value = selectedWeight;
  }

  void setSelectedInitHeightDecimal(int selectedWeightDecimal) {
    _selectedInitHeightDecimal.value = selectedWeightDecimal;
  }

  var height = Rx<double>(0.0);

  double getHeight() => height.value;

  void updateHeight() {
    height.value = double.parse("${selectedInitHeight ?? 125}.${selectedInitHeightDecimal ?? 0}");
    update();
  }

  Future<void> fetchWeightGainIndex() async {
    var result = await _weightHistoryService.getPregnancyWeightGainData();
    pregnancyWeightGainData.value = result;
    weightGainHistory.assignAll(pregnancyWeightGainData.value?.weightHistory ?? []);
    reccomendWeightGain.assignAll(pregnancyWeightGainData.value?.reccomendWeightGain ?? []);
    isTwin.value = pregnancyWeightGainData.value?.isTwin == "0" ? false : true;
    fetchPregnancyData();
    update();
  }

  RxList<DateTime> tanggalAwalMinggu = <DateTime>[].obs;
  RxList<DateTime> tanggalAkhirMinggu = <DateTime>[].obs;

  Future<void> fetchPregnancyData() async {
    var result = await _pregnancyHistoryService.getCurrentPregnancyData("id");
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
    getSelectedWeek(DateTime.now());
  }

  Future<void> initializeWeightGain(context) async {
    bool localSuccess = false;
    bool isConnected = await CheckConnectivity().isConnectedToInternet();

    try {
      await _weightHistoryService.initWeightGain(getHeight(), getWeight(), (isTwin.value == false) ? 0 : 1);
      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(context)!.weightGainInitializedSuccess));
      localSuccess = true;
    } catch (e) {
      await _syncInitializedWeightData();
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.weightGainInitializeFailed));
    }

    await fetchWeightGainIndex();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => WeightGainTrackerView()),
      (Route<dynamic> route) => route.isFirst,
    );

    if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      try {
        await pregnancyRepository.initializeWeightGain(getHeight(), getWeight(), (isTwin.value == false) ? 0 : 1);
      } catch (e) {
        await _syncInitializedWeightData();
      }
    } else if (localSuccess) {
      await _syncInitializedWeightData();
    }
  }

  Future<void> _syncInitializedWeightData() async {
    Map<String, dynamic> data = {
      'tinggiBadan': getHeight(),
      'beratBadan': getWeight(),
      'isTwin': (isTwin.value == false) ? 0 : 1,
    };

    String jsonData = jsonEncode(data);

    SyncLog syncLog = SyncLog(
      tableName: 'tb_berat_badan_kehamilan',
      operation: 'initWeightGain',
      data: jsonData,
      createdAt: DateTime.now().toString(),
    );

    await _syncDataRepository.addSyncLogData(syncLog);
  }

  Future<void> weeklyWeightGain(context) async {
    bool localSuccess = false;
    bool isConnected = await CheckConnectivity().isConnectedToInternet();

    if (selectedDate != null) {
      try {
        await _weightHistoryService.addWeeklyWeightGain(DateTime.parse(formatDate(selectedDate!)), getWeight(), selectedWeek);
        Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(context)!.weightGainAddedSuccess));
        localSuccess = true;
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.weightGainAddFailed));
      }

      await fetchWeightGainIndex();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => WeightGainTrackerView()),
        (Route<dynamic> route) => route.isFirst,
      );

      if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
        try {
          await pregnancyRepository.weeklyWeightGain(getWeight(), selectedWeek, formatDate(selectedDate!));
        } catch (e) {
          await _syncAddWeeklyWeightData();
        }
      } else if (localSuccess) {
        await _syncAddWeeklyWeightData();
      }
      resetValue();
    }
  }

  Future<void> _syncAddWeeklyWeightData() async {
    Map<String, dynamic> data = {
      'dateRecord': formatDate(selectedDate!),
      'beratBadan': getWeight(),
      'mingguKehamilan': selectedWeek,
    };

    String jsonData = jsonEncode(data);

    SyncLog syncLog = SyncLog(
      tableName: 'tb_berat_badan_kehamilan',
      operation: 'addWeeklyWeightGain',
      data: jsonData,
      createdAt: DateTime.now().toString(),
    );

    await _syncDataRepository.addSyncLogData(syncLog);
  }

  Future<void> deleteWeeklyWeightGain(DateTime selectedDate, context) async {
    bool localSuccess = false;
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    var deletedWeeklyWeightDate = formatDate(selectedDate);

    try {
      await _weightHistoryService.deleteWeeklyWeightGain(deletedWeeklyWeightDate);
      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(context)!.weightGainDeletedSuccess));
      localSuccess = true;
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.weightGainDeleteFailed));
    }

    await fetchWeightGainIndex();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => WeightGainTrackerView()),
      (Route<dynamic> route) => route.isFirst,
    );

    if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      try {
        await pregnancyRepository.deleteWeeklyWeightGain(deletedWeeklyWeightDate);
      } catch (e) {
        await _syncDeleteWeightData();
      }
    } else if (localSuccess) {
      await _syncDeleteWeightData();
    }
  }

  Future<void> _syncDeleteWeightData() async {
    Map<String, dynamic> data = {
      'tanggalPencatatan': formatDate(selectedDate!),
    };

    String jsonData = jsonEncode(data);

    SyncLog syncLog = SyncLog(
      tableName: 'tb_berat_badan_kehamilan',
      operation: 'deleteWeeklyWeightGain',
      data: jsonData,
      createdAt: DateTime.now().toString(),
    );

    await _syncDataRepository.addSyncLogData(syncLog);
  }
}
