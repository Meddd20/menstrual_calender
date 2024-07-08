import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:periodnpregnancycalender/app/models/period_cycle_model.dart';
import 'package:periodnpregnancycalender/app/models/sync_log_model.dart';
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
    periodCycleData = <PeriodCycleIndex>[].obs;
    fetchPeriod();
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
  }

  void addPeriod(int avgPeriodDuration, int avgPeriodCycle) async {
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

      if (storageService.getIsAuth() && !isConnected) {
        await syncAddedPeriod(periods, avgPeriodCycle);
        return;
      }

      try {
        var addPeriod = await periodRepository.storePeriod(periods, avgPeriodCycle, null);
        var idPeriodAdded = addPeriod?[0].id;
        await _periodHistoryService.addPeriod(idPeriodAdded ?? null, DateTime.parse(formattedStartDate), DateTime.parse(formattedEndDate), avgPeriodCycle);
        cancelEdit();
        await fetchPeriod();
      } catch (e) {
        print("Error adding period: $e");
        await syncAddedPeriod(periods, avgPeriodCycle);
      }
    } else {
      print('Please select both start and end dates');
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

  Future<void> editPeriod(int periodId, int remoteId, int periodCycle, int avgPeriodDuration) async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();

    if (startDate.value != null) {
      if (formattedStartDate == formattedEndDate || endDate.value == null) {
        setEndDate(startDate.value!.add(Duration(days: avgPeriodDuration)));
      }

      if (storageService.getIsAuth() && !isConnected) {
        await syncEditPeriod(remoteId, formattedStartDate, formattedEndDate, periodCycle);
        return;
      }

      try {
        await periodRepository.updatePeriod(remoteId, formattedStartDate, formattedEndDate, periodCycle);
        await _periodHistoryService.updatePeriod(periodId, DateTime.parse(formattedStartDate), DateTime.parse(formattedEndDate), periodCycle);
        cancelEdit();
        await fetchPeriod();
      } catch (e) {
        print("Error editing period: $e");
        await syncEditPeriod(remoteId, formattedStartDate, formattedEndDate, periodCycle);
      }
    }
  }

  Future<void> syncEditPeriod(int remoteId, String firstPeriod, String lastPeriod, int periodCycle) async {
    Map<String, dynamic> data = {
      "period_id": remoteId.toString(),
      "first_period": firstPeriod,
      "last_period": lastPeriod,
      "period_cycle": periodCycle,
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
