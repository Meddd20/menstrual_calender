import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/views/period_cycle_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:periodnpregnancycalender/app/utils/utils.dart';
import 'package:periodnpregnancycalender/app/services/services.dart';
import 'package:periodnpregnancycalender/app/repositories/repositories.dart';
import 'package:periodnpregnancycalender/app/models/models.dart';
import 'package:periodnpregnancycalender/app/common/common.dart';

class PeriodCycleController extends GetxController {
  final ApiService apiService = ApiService();
  late final PeriodRepository periodRepository = PeriodRepository(apiService);
  late List<Map<String, dynamic>> periods = [];
  RxList<PeriodCycleIndex> periodCycleData = <PeriodCycleIndex>[].obs;
  Rx<DateTime?> startDate = Rx<DateTime?>(DateTime.now());
  Rx<DateTime?> endDate = Rx<DateTime?>(null);
  late final SyncDataRepository _syncDataRepository;
  late final PeriodHistoryService _periodHistoryService;
  final storageService = StorageService();

  void setStartDate(DateTime? date) {
    startDate.value = date;
  }

  void setEndDate(DateTime? date) {
    endDate.value = date;
  }

  @override
  void onInit() {
    _syncDataRepository = SyncDataRepository();
    _periodHistoryService = PeriodHistoryService();
    periodCycleData = <PeriodCycleIndex>[].obs;
    fetchPeriod();
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

  String get formattedStartDate => startDate.value != null ? formatDate(startDate.value!) : formatDate(DateTime.now());

  String get formattedEndDate => endDate.value != null ? formatDate(endDate.value!) : formatDate(DateTime.now());

  Future<void> fetchPeriod() async {
    PeriodCycleIndex? periodCycle = await _periodHistoryService.getPeriodIndex();
    if (periodCycle.toString().isNotEmpty) {
      periodCycleData.assignAll([periodCycle]);
    }
    update();
  }

  void addPeriod(int avgPeriodDuration, int avgPeriodCycle, context) async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    bool remoteSuccess = false;
    var periodStoredRemote;

    if (startDate.value != null) {
      if (formattedStartDate == formattedEndDate || endDate.value == null) {
        setEndDate(startDate.value!.add(Duration(days: avgPeriodDuration)));
      }

      periods = [
        {
          'first_period': formattedStartDate,
          'last_period': formattedEndDate,
        }
      ];

      if (isConnected && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
        await SyncDataService().pendingDataChange();
        periodStoredRemote = await periodRepository.storePeriod(periods, avgPeriodCycle, null);
        remoteSuccess = true;
      }

      try {
        if (remoteSuccess) {
          await _periodHistoryService.addPeriod(
            periodStoredRemote?[0].id,
            DateTime.parse(formattedStartDate),
            DateTime.parse(formattedEndDate),
            avgPeriodCycle,
          );
        } else {
          PeriodHistory? addedPeriod = await _periodHistoryService.addPeriod(
            null,
            DateTime.parse(formattedStartDate),
            DateTime.parse(formattedEndDate),
            avgPeriodCycle,
          );
          await syncAddedPeriod(addedPeriod?.id ?? 0);
        }

        Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(context)!.periodAddedSuccess));

        await fetchPeriod();
        cancelEdit();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => PeriodCycleView()),
          (Route<dynamic> route) => route.isFirst,
        );

        update();
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.periodAddFailed));
        return;
      }
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.selectPeriodStartDate));
      return;
    }
  }

  Future<void> syncAddedPeriod(int period_id) async {
    SyncLog syncLog = SyncLog(
      tableName: 'period',
      operation: 'create',
      dataId: period_id,
      createdAt: DateTime.now().toString(),
    );

    await _syncDataRepository.addSyncLogData(syncLog);
  }

  Future<void> editPeriod(context, int periodId, int remoteId, int periodCycle, int avgPeriodDuration) async {
    bool localSuccess = false;
    bool isConnected = await CheckConnectivity().isConnectedToInternet();

    if (startDate.value != null) {
      if (formattedStartDate == formattedEndDate || endDate.value == null) {
        setEndDate(startDate.value!.add(Duration(days: avgPeriodDuration)));
      }

      try {
        await _periodHistoryService.updatePeriod(periodId, DateTime.parse(formattedStartDate), DateTime.parse(formattedEndDate), periodCycle);
        Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(context)!.periodEditedSuccess));
        localSuccess = true;
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.periodEditFailed));
        return;
      }

      if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
        try {
          await SyncDataService().pendingDataChange();
          await periodRepository.updatePeriod(remoteId, formattedStartDate, formattedEndDate, periodCycle);
        } catch (e) {
          await syncEditPeriod(periodId, remoteId);
        }
      } else if (localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
        await syncEditPeriod(periodId, remoteId);
      }

      await fetchPeriod();
      cancelEdit();
      update();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => PeriodCycleView()),
        (Route<dynamic> route) => route.isFirst,
      );
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.selectPeriodStartDate));
      return;
    }
  }

  Future<void> syncEditPeriod(int period_id, int? remote_id) async {
    SyncLog syncLog = SyncLog(
      tableName: 'period',
      operation: 'update',
      dataId: period_id,
      optionalId: remote_id != null ? remote_id.toString() : null,
      createdAt: DateTime.now().toString(),
    );

    await _syncDataRepository.addSyncLogData(syncLog);
  }

  void cancelEdit() {
    startDate.value = DateTime.now();
    endDate.value = DateTime.now();
  }
}
