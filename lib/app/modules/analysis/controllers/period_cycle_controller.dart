import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_snackbar.dart';
import 'package:periodnpregnancycalender/app/models/period_cycle_model.dart';
import 'package:periodnpregnancycalender/app/models/sync_log_model.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/views/period_cycle_view.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/period_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/master_gender_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/master_newmoon_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/period_history_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/profile_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/sync_data_repository.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/services/period_history_service.dart';
import 'package:periodnpregnancycalender/app/utils/conectivity.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';

class PeriodCycleController extends GetxController {
  final ApiService apiService = ApiService();
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;
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
    print(startDate);
  }

  void setEndDate(DateTime? date) {
    endDate.value = date;
    print(endDate);
  }

  @override
  void onInit() {
    final DatabaseHelper databaseHelper = DatabaseHelper.instance;
    final PeriodHistoryRepository periodHistoryRepository = PeriodHistoryRepository(databaseHelper);
    final LocalProfileRepository localProfileRepository = LocalProfileRepository(databaseHelper);
    final MasterNewmoonRepository masterNewmoonRepository = MasterNewmoonRepository(databaseHelper);
    final MasterGenderRepository masterGenderRepository = MasterGenderRepository(databaseHelper);
    _syncDataRepository = SyncDataRepository(databaseHelper);
    _periodHistoryService = PeriodHistoryService(
      periodHistoryRepository,
      localProfileRepository,
      masterNewmoonRepository,
      masterGenderRepository,
    );
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

  String get formattedStartDate => startDate.value != null ? DateFormat('yyyy-MM-dd').format(startDate.value!) : DateFormat('yyyy-MM-dd').format(DateTime.now());

  String get formattedEndDate => endDate.value != null ? DateFormat('yyyy-MM-dd').format(endDate.value!) : DateFormat('yyyy-MM-dd').format(DateTime.now());

  Future<void> fetchPeriod() async {
    PeriodCycleIndex? periodCycle = await _periodHistoryService.getPeriodIndex();
    if (periodCycle.toString().isNotEmpty) {
      periodCycleData.assignAll([periodCycle]);
    }
    update();
  }

  void addPeriod(int avgPeriodDuration, int avgPeriodCycle, context) async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();

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

      var newPeriod;
      if (isConnected && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
        try {
          newPeriod = await periodRepository.storePeriod(periods, avgPeriodCycle, null);
        } catch (e) {
          await syncAddedPeriod(periods, avgPeriodCycle);
        }
      } else {
        await syncAddedPeriod(periods, avgPeriodCycle);
      }

      try {
        await _periodHistoryService.addPeriod(newPeriod?[0].id ?? null, DateTime.parse(formattedStartDate), DateTime.parse(formattedEndDate), avgPeriodCycle);
        Get.showSnackbar(Ui.SuccessSnackBar(message: 'Period added successfully!'));

        await fetchPeriod();
        cancelEdit();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PeriodCycleView()),
        );
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: 'Failed to add period. Please try again!'));
      }
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: 'Please select your period start date!'));
    }
  }

  Future<void> syncAddedPeriod(List<Map<String, dynamic>> periods, int periodCycle) async {
    Map<String, dynamic> data = {
      "periods": periods,
      "periodCycle": periodCycle,
    };
    String jsonData = jsonEncode(data);

    SyncLog syncLog = SyncLog(
      tableName: 'tb_riwayat_mens',
      operation: 'addPeriod',
      data: jsonData,
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
        Get.showSnackbar(Ui.SuccessSnackBar(message: 'Period edited successfully!'));
        localSuccess = true;
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: 'Failed to edit period. Please try again!'));
      }

      await fetchPeriod();
      update();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PeriodCycleView()),
      );

      if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
        try {
          await periodRepository.updatePeriod(remoteId, formattedStartDate, formattedEndDate, periodCycle);
        } catch (e) {
          await syncEditPeriod(remoteId, formattedStartDate, formattedEndDate, periodCycle);
        }
      } else {
        await syncEditPeriod(remoteId, formattedStartDate, formattedEndDate, periodCycle);
      }

      cancelEdit();
    }
  }

  Future<void> syncEditPeriod(int remoteId, String firstPeriod, String lastPeriod, int periodCycle) async {
    Map<String, dynamic> data = {
      "periodId": remoteId.toInt(),
      "firstPeriod": firstPeriod,
      "lastPeriod": lastPeriod,
      "periodCycle": periodCycle,
    };

    String jsonData = jsonEncode(data);

    SyncLog syncLog = SyncLog(
      tableName: 'tb_riwayat_mens',
      operation: 'updatePeriod',
      data: jsonData,
      createdAt: DateTime.now().toString(),
    );

    await _syncDataRepository.addSyncLogData(syncLog);
  }

  void cancelEdit() {
    startDate.value = DateTime.now();
    endDate.value = DateTime.now();
  }
}
