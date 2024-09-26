import 'dart:convert';

import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_snackbar.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_model.dart';
import 'package:periodnpregnancycalender/app/models/sync_log_model.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/pregnancy_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/sync_data_repository.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/services/local_notification_service.dart';
import 'package:periodnpregnancycalender/app/services/pregnancy_history_service.dart';
import 'package:periodnpregnancycalender/app/services/profile_service.dart';
import 'package:periodnpregnancycalender/app/services/sync_data_service.dart';
import 'package:periodnpregnancycalender/app/utils/conectivity.dart';
import 'package:periodnpregnancycalender/app/utils/helpers.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EndPregnancyController extends GetxController {
  final ApiService apiService = ApiService();
  final StorageService storageService = StorageService();
  late final PregnancyRepository pregnancyRepository = PregnancyRepository(apiService);
  late final PregnancyHistoryService _pregnancyHistoryService;
  late final ProfileService profileService;
  late final SyncDataRepository syncDataRepository;
  late final SyncDataService syncDataService;
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
    bool localSuccess = false;
    bool isConnected = await CheckConnectivity().isConnectedToInternet();

    try {
      await _pregnancyHistoryService.endPregnancy(selectedDate!, gender.value);
      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(context)!.pregnancyEndedSuccess));
      localSuccess = true;
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.pregnancyEndFailed));
    }

    storageService.storeIsPregnant("2");
    storageService.storeIsBirthSuccess(true);
    LocalNotificationService().cancelAllPregnancyNotifications(storageService.getAccountLocalId());
    Get.offAllNamed(Routes.NAVIGATION_MENU);

    if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      try {
        await pregnancyRepository.pregnancyEnded(selectedDate.toString(), gender.value);
      } catch (e) {
        await _syncPregnancyEnded();
      }
    } else if (localSuccess) {
      await _syncPregnancyEnded();
    }
  }

  Future<void> _syncPregnancyEnded() async {
    Map<String, dynamic> data = {
      "pregnancyEndDate": selectedDate.toString(),
      "gender": gender.value,
    };

    String jsonData = jsonEncode(data);

    SyncLog syncLog = SyncLog(
      tableName: 'tb_riwayat_kehamilan',
      operation: 'endPregnancy',
      data: jsonData,
      createdAt: DateTime.now().toString(),
    );

    await syncDataRepository.addSyncLogData(syncLog);
  }

  Future<void> deletePregnancy(context) async {
    bool localSuccess = false;
    bool isConnected = await CheckConnectivity().isConnectedToInternet();

    try {
      await _pregnancyHistoryService.deletePregnancy();
      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(context)!.pregnancyDeletedSuccess));
      localSuccess = true;
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.pregnancyDeleteFailed));
    }

    storageService.storeIsPregnant("2");
    storageService.storeIsBirthSuccess(false);
    LocalNotificationService().cancelAllPregnancyNotifications(storageService.getAccountLocalId());
    Get.offAllNamed(Routes.NAVIGATION_MENU);

    if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      try {
        await pregnancyRepository.deletePregnancy();
      } catch (e) {
        await _syncPregnancyDelete();
      }
    } else if (localSuccess) {
      await _syncPregnancyDelete();
    }
  }

  Future<void> _syncPregnancyDelete() async {
    SyncLog syncLog = SyncLog(
      tableName: 'tb_riwayat_kehamilan',
      operation: 'deletePregnancy',
      data: '{}',
      createdAt: DateTime.now().toString(),
    );

    await syncDataRepository.addSyncLogData(syncLog);
  }

  void resetValuePregnancy() {
    gender.value = "";
    setSelectedDate(DateTime.now());
  }
}
