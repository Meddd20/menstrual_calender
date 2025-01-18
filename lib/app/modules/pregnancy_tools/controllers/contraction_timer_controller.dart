import 'dart:async';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:periodnpregnancycalender/app/utils/utils.dart';
import 'package:periodnpregnancycalender/app/services/services.dart';
import 'package:periodnpregnancycalender/app/repositories/repositories.dart';
import 'package:periodnpregnancycalender/app/models/models.dart';
import 'package:periodnpregnancycalender/app/common/common.dart';

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
    _syncDataRepository = SyncDataRepository();
    _pregnancyLogService = PregnancyLogService();
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
      addContraction(Get.context, elapsedTime.value.inSeconds);
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

  Future<void> addContraction(context, int duration) async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    bool localSuccess = false;
    var uuid = Uuid();
    var id = uuid.v4();
    PregnancyDailyLog? pregnancyDailyLog;

    try {
      pregnancyDailyLog = await _pregnancyLogService.addContractionTimer(id, selectedDate.toString(), duration);
      localSuccess = true;
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.contractionAddFailed));
      return;
    }

    await fetchAllContraction();

    if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      try {
        await SyncDataService().pendingDataChange();
        await pregnancyLogAPIRepository.addContractionTimer(id, selectedDate, duration);
      } catch (e) {
        await syncAddContraction(id, pregnancyDailyLog?.riwayatKehamilanId ?? 0);
      }
    } else if (localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      await syncAddContraction(id, pregnancyDailyLog?.riwayatKehamilanId ?? 0);
    }
  }

  Future<void> syncAddContraction(String id, int pregnancyId) async {
    SyncLog syncLog = SyncLog(
      tableName: 'contraction_timer',
      operation: 'create',
      dataId: pregnancyId,
      optionalId: id,
      createdAt: DateTime.now().toString(),
    );

    await _syncDataRepository.addSyncLogData(syncLog);
  }

  Future<void> deleteContraction(context, String id) async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    bool localSuccess = false;
    PregnancyDailyLog? pregnancyDailyLog;

    try {
      pregnancyDailyLog = await _pregnancyLogService.deleteContractionTimer(id);
      localSuccess = true;
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.contractionDeleteFailed));
      return;
    }

    await fetchAllContraction();

    if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      try {
        await SyncDataService().pendingDataChange();
        await pregnancyLogAPIRepository.deleteContractionTimer(id);
      } catch (e) {
        await syncDeleteContraction(id, pregnancyDailyLog?.riwayatKehamilanId ?? 0);
      }
    } else if (localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      await syncDeleteContraction(id, pregnancyDailyLog?.riwayatKehamilanId ?? 0);
    }
  }

  Future<void> syncDeleteContraction(String id, int pregnancyId) async {
    SyncLog syncLog = SyncLog(
      tableName: 'contraction_timer',
      operation: 'delete',
      dataId: pregnancyId,
      optionalId: id,
      createdAt: DateTime.now().toString(),
    );

    await _syncDataRepository.addSyncLogData(syncLog);
  }
}
