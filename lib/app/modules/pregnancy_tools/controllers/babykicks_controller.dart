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
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';
import 'package:uuid/uuid.dart';

class BabykicksController extends GetxController {
  final storageService = StorageService();
  final apiService = ApiService();
  late final PregnancyLogAPIRepository pregnancyLogAPIRepository = PregnancyLogAPIRepository(apiService);
  late final PregnancyLogService _pregnancyLogService;
  late final SyncDataRepository _syncDataRepository;
  RxList<BabyKicks> allKicks = <BabyKicks>[].obs;

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
    fetchAllBabyKicks();
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

  Future<void> fetchAllBabyKicks() async {
    List<BabyKicks>? result = await _pregnancyLogService.getAllKicksCounter();

    allKicks.assignAll(result);
    update();
  }

  Future<void> addKickCounter() async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    bool localSuccess = false;
    var uuid = Uuid();
    var id = uuid.v4();

    try {
      await _pregnancyLogService.addKicksCounter(id, DateTime.now().toString());
      localSuccess = true;
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: 'Failed to add contraction. Please try again later!'));
    }

    await fetchAllBabyKicks();

    if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      try {
        await pregnancyLogAPIRepository.addKickCounter(id, DateTime.now());
      } catch (e) {
        await syncAddKickCounter(id);
      }
    } else if (localSuccess) {
      await syncAddKickCounter(id);
    }
  }

  Future<void> syncAddKickCounter(String id) async {
    Map<String, dynamic> data = {
      'id': id,
      'datetime': DateTime.now().toString(),
    };

    String jsonData = jsonEncode(data);

    SyncLog syncLog = SyncLog(
      tableName: 'tb_data_harian_kehamilan',
      operation: 'addKickCounter',
      data: jsonData,
      createdAt: DateTime.now().toString(),
    );

    await _syncDataRepository.addSyncLogData(syncLog);
  }

  Future<void> deleteKickCounter(String id) async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    bool localSuccess = false;

    try {
      await _pregnancyLogService.deleteKicksCounter(id);
      Get.showSnackbar(Ui.SuccessSnackBar(message: 'Kick counter deleted successfully!'));
      localSuccess = true;
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: 'Failed to delete kick counter. Please try again later!'));
    }

    await fetchAllBabyKicks();

    if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      try {
        await pregnancyLogAPIRepository.deleteKickCounter(id);
      } catch (e) {
        await syncDeleteKickCounter(id);
      }
    } else if (localSuccess) {
      await syncDeleteKickCounter(id);
    }
  }

  Future<void> syncDeleteKickCounter(String id) async {
    Map<String, dynamic> data = {'id': id};

    String jsonData = jsonEncode(data);

    SyncLog syncLog = SyncLog(
      tableName: 'tb_data_harian_kehamilan',
      operation: 'deleteKickCounter',
      data: jsonData,
      createdAt: DateTime.now().toString(),
    );

    await _syncDataRepository.addSyncLogData(syncLog);
  }
}
