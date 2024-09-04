import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_snackbar.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_daily_log_model.dart';
import 'package:periodnpregnancycalender/app/models/sync_log_model.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/pregnancy_log_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/pregnancy_history_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/pregnancy_log_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/sync_data_repository.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/services/pregnancy_log_service.dart';
import 'package:periodnpregnancycalender/app/utils/conectivity.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';
import 'package:periodnpregnancycalender/app/utils/helpers.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';
import 'package:uuid/uuid.dart';

class ContractionTimerController extends GetxController {
  final StorageService storageService = StorageService();
  final ApiService apiService = ApiService();
  late final PregnancyLogAPIRepository pregnancyLogAPIRepository = PregnancyLogAPIRepository(apiService);
  late final PregnancyLogService _pregnancyLogService;
  late final SyncDataRepository _syncDataRepository;
  RxList<ContractionTimer> allContraction = <ContractionTimer>[].obs;
  var elapsedTime = Duration().obs;
  var isRunning = false.obs;

  Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;

  @override
  void onInit() {
    final DatabaseHelper databaseHelper = DatabaseHelper.instance;
    final PregnancyLogRepository pregnancyLogRepository = PregnancyLogRepository(databaseHelper);
    final PregnancyHistoryRepository pregnancyHistoryRepository = PregnancyHistoryRepository(databaseHelper);
    _syncDataRepository = SyncDataRepository(databaseHelper);
    _pregnancyLogService = PregnancyLogService(
      pregnancyLogRepository,
      pregnancyHistoryRepository,
    );
    fetchAllContraction();
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

  void start() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
      isRunning.value = true;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        elapsedTime.value = _stopwatch.elapsed;
      });
      setSelectedDate(DateTime.now());
    }
  }

  void stop() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      isRunning.value = false;
      _timer.cancel();
      addContraction(elapsedTime.value.inSeconds);
      reset();
    }
  }

  void reset() {
    stop();
    _stopwatch.reset();
    elapsedTime.value = Duration();
  }

  final Rx<DateTime> _selectedDate = Rx<DateTime>(DateTime.now());

  DateTime get selectedDate => _selectedDate.value;

  void setSelectedDate(DateTime selectedDate) {
    _selectedDate.value = selectedDate;
    update();
  }

  final Rx<int?> _duration = Rx<int?>(60);

  int? get getContractionDuration => _duration.value;

  void setContractionDuration(int duration) {
    _duration.value = duration;
    update();
  }

  Future<void> fetchAllContraction() async {
    List<ContractionTimer>? result = await _pregnancyLogService.getAllContractionTimer();

    allContraction.assignAll(result);
    update();
  }

  Future<void> addContraction(int duration) async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    bool localSuccess = false;
    var uuid = Uuid();
    var id = uuid.v4();

    try {
      await _pregnancyLogService.addContractionTimer(id, selectedDate.toString(), duration);
      localSuccess = true;
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: 'Failed to add contraction. Please try again later!'));
    }

    await fetchAllContraction();

    if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      try {
        await pregnancyLogAPIRepository.addContractionTimer(id, selectedDate, duration);
      } catch (e) {
        await syncAddContraction(id, duration);
      }
    } else if (localSuccess) {
      await syncAddContraction(id, duration);
    }
  }

  Future<void> syncAddContraction(String id, int duration) async {
    Map<String, dynamic> data = {
      'id': id,
      'startDate': formatDateTime(selectedDate),
      'duration': duration,
    };

    print(data.toString());

    String jsonData = jsonEncode(data);

    SyncLog syncLog = SyncLog(
      tableName: 'tb_data_harian_kehamilan',
      operation: 'addContractionTimer',
      data: jsonData,
      createdAt: DateTime.now().toString(),
    );

    await _syncDataRepository.addSyncLogData(syncLog);
  }

  Future<void> deleteContraction(String id) async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    bool localSuccess = false;

    try {
      await _pregnancyLogService.deleteContractionTimer(id);
      localSuccess = true;
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: 'Failed to delete contraction. Please try again later!'));
    }

    await fetchAllContraction();

    if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      try {
        await pregnancyLogAPIRepository.deleteContractionTimer(id);
      } catch (e) {
        await syncDeleteContraction(id);
      }
    } else if (localSuccess) {
      await syncDeleteContraction(id);
    }
  }

  Future<void> syncDeleteContraction(String id) async {
    Map<String, dynamic> data = {'id': id};

    String jsonData = jsonEncode(data);

    SyncLog syncLog = SyncLog(
      tableName: 'tb_data_harian_kehamilan',
      operation: 'deleteContractionTimer',
      data: jsonData,
      createdAt: DateTime.now().toString(),
    );

    await _syncDataRepository.addSyncLogData(syncLog);
  }
}
