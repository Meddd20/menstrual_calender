import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_snackbar.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_daily_log_model.dart';
import 'package:periodnpregnancycalender/app/models/sync_log_model.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/pregnancy_log_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/sync_data_repository.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/services/pregnancy_log_service.dart';
import 'package:periodnpregnancycalender/app/utils/conectivity.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BabykicksController extends GetxController {
  final storageService = StorageService();
  final apiService = ApiService();
  late final PregnancyLogAPIRepository pregnancyLogAPIRepository = PregnancyLogAPIRepository(apiService);
  late final PregnancyLogService _pregnancyLogService;
  late final SyncDataRepository _syncDataRepository;
  RxList<BabyKicks> allKicks = <BabyKicks>[].obs;

  @override
  void onInit() {
    _syncDataRepository = SyncDataRepository();
    _pregnancyLogService = PregnancyLogService();
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

  Future<void> addKickCounter(context) async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    bool localSuccess = false;
    var uuid = Uuid();
    var id = uuid.v4();
    PregnancyDailyLog? pregnancyDailyLog;

    try {
      pregnancyDailyLog = await _pregnancyLogService.addKicksCounter(id, DateTime.now().toString());
      localSuccess = true;
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.babyKickAddFailed));
    }

    await fetchAllBabyKicks();

    if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      try {
        await pregnancyLogAPIRepository.addKickCounter(id, DateTime.now());
      } catch (e) {
        await syncAddKickCounter(id, pregnancyDailyLog?.riwayatKehamilanId ?? 0);
      }
    } else if (localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      await syncAddKickCounter(id, pregnancyDailyLog?.riwayatKehamilanId ?? 0);
    }
  }

  Future<void> syncAddKickCounter(String id, int pregnancyId) async {
    SyncLog syncLog = SyncLog(
      tableName: 'baby_kicks',
      operation: 'create',
      dataId: pregnancyId,
      optionalId: id,
      createdAt: DateTime.now().toString(),
    );

    await _syncDataRepository.addSyncLogData(syncLog);
  }

  Future<void> deleteKickCounter(context, String id) async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    bool localSuccess = false;
    PregnancyDailyLog? pregnancyDailyLog;

    try {
      pregnancyDailyLog = await _pregnancyLogService.deleteKicksCounter(id);
      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(context)!.kickDataDeletedSuccess));
      localSuccess = true;
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.kickDataDeleteFailed));
    }

    await fetchAllBabyKicks();

    if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      try {
        await pregnancyLogAPIRepository.deleteKickCounter(id);
      } catch (e) {
        await syncDeleteKickCounter(id, pregnancyDailyLog?.riwayatKehamilanId ?? 0);
      }
    } else if (localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      await syncDeleteKickCounter(id, pregnancyDailyLog?.riwayatKehamilanId ?? 0);
    }
  }

  Future<void> syncDeleteKickCounter(String id, int pregnancyId) async {
    SyncLog syncLog = SyncLog(
      tableName: 'baby_kicks',
      operation: 'delete',
      dataId: pregnancyId,
      optionalId: id,
      createdAt: DateTime.now().toString(),
    );

    await _syncDataRepository.addSyncLogData(syncLog);
  }

  bool isLastDateIsInWithin2Hours(String dateTimeString) {
    final now = DateTime.now();
    final dateTime = DateTime.parse(dateTimeString);
    final difference = now.difference(dateTime).inSeconds;
    return difference <= 7200;
  }
}
