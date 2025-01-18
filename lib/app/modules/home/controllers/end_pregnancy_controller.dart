import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:periodnpregnancycalender/app/utils/utils.dart';
import 'package:periodnpregnancycalender/app/services/services.dart';
import 'package:periodnpregnancycalender/app/repositories/repositories.dart';
import 'package:periodnpregnancycalender/app/models/models.dart';
import 'package:periodnpregnancycalender/app/common/common.dart';

class EndPregnancyController extends GetxController {
  final ApiService apiService = ApiService();
  final StorageService storageService = StorageService();
  late final PregnancyRepository pregnancyRepository = PregnancyRepository(apiService);
  late final PregnancyHistoryService _pregnancyHistoryService;
  late final ProfileService profileService;
  late final SyncDataRepository syncDataRepository;
  var gender = "".obs;
  Rx<CurrentlyPregnant> currentlyPregnantData = Rx<CurrentlyPregnant>(CurrentlyPregnant());
  RxList<WeeklyData> weeklyData = <WeeklyData>[].obs;

  @override
  void onInit() {
    _pregnancyHistoryService = PregnancyHistoryService();
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

  final Rx<DateTime?> _selectedDate = Rx<DateTime?>(DateTime.now());

  DateTime? get selectedDate => _selectedDate.value;

  void setSelectedDate(DateTime selectedDate) {
    _selectedDate.value = selectedDate;
    update();
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

  int weekPregnancyEnded() {
    int week = 0;
    for (int i = 0; i < tanggalAwalMinggu.length; i++) {
      if (selectedDate!.isAtSameMomentAs(tanggalAwalMinggu[i]) || (selectedDate!.isAfter(tanggalAwalMinggu[i]) && selectedDate!.isBefore(tanggalAkhirMinggu[i])) || selectedDate!.isAtSameMomentAs(tanggalAkhirMinggu[i])) {
        week = i + 1;
        break;
      }
    }
    return week;
  }

  Future<void> endPregnancy(context) async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    bool localSuccess = false;
    PregnancyHistory? updatedPregnancy;

    try {
      updatedPregnancy = await _pregnancyHistoryService.endPregnancy(selectedDate!, gender.value);
      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(context)!.pregnancyEndedSuccess));
      localSuccess = true;
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.pregnancyEndFailed));
      return;
    }

    if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      try {
        await SyncDataService().pendingDataChange();
        await pregnancyRepository.pregnancyEnded(selectedDate.toString(), gender.value);
      } catch (e) {
        await _syncPregnancyEnded(updatedPregnancy?.id ?? 0, updatedPregnancy?.remoteId ?? 0);
      }
    } else if (localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      await _syncPregnancyEnded(updatedPregnancy?.id ?? 0, updatedPregnancy?.remoteId ?? 0);
    }

    storageService.storeIsPregnant("2");
    storageService.storeIsBirthSuccess(true);
    LocalNotificationService().cancelAllPregnancyNotifications(storageService.getAccountLocalId());
    Get.offAllNamed(Routes.NAVIGATION_MENU);
  }

  Future<void> _syncPregnancyEnded(int pregnancy_id, int remote_id) async {
    SyncLog syncLog = SyncLog(
      tableName: 'pregnancy',
      operation: 'update',
      dataId: pregnancy_id,
      optionalId: remote_id.toString(),
      createdAt: DateTime.now().toString(),
    );

    await syncDataRepository.addSyncLogData(syncLog);
  }

  Future<void> deletePregnancy(context) async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    bool localSuccess = false;
    PregnancyHistory? deletedPregnancy;

    try {
      deletedPregnancy = await _pregnancyHistoryService.deletePregnancy();
      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(context)!.pregnancyDeletedSuccess));
      localSuccess = true;
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.pregnancyDeleteFailed));
      return;
    }

    if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      try {
        await SyncDataService().pendingDataChange();
        await pregnancyRepository.deletePregnancy();
      } catch (e) {
        await _syncPregnancyDelete(deletedPregnancy?.id ?? 0, deletedPregnancy?.remoteId ?? 0);
      }
    } else if (localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      await _syncPregnancyDelete(deletedPregnancy?.id ?? 0, deletedPregnancy?.remoteId ?? 0);
    }

    storageService.storeIsPregnant("2");
    storageService.storeIsBirthSuccess(false);
    LocalNotificationService().cancelAllPregnancyNotifications(storageService.getAccountLocalId());
    Get.offAllNamed(Routes.NAVIGATION_MENU);
  }

  Future<void> _syncPregnancyDelete(int pregnancy_id, int remote_id) async {
    SyncLog syncLog = SyncLog(
      tableName: 'pregnancy',
      operation: 'delete',
      dataId: pregnancy_id,
      optionalId: remote_id.toString(),
      createdAt: DateTime.now().toString(),
    );

    await syncDataRepository.addSyncLogData(syncLog);
  }

  void resetValuePregnancy() {
    gender.value = "";
    setSelectedDate(DateTime.now());
  }
}
