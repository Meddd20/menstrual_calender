import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/views/blood_pressure_view.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:periodnpregnancycalender/app/utils/utils.dart';
import 'package:periodnpregnancycalender/app/services/services.dart';
import 'package:periodnpregnancycalender/app/repositories/repositories.dart';
import 'package:periodnpregnancycalender/app/models/models.dart';
import 'package:periodnpregnancycalender/app/common/common.dart';

class BloodPressureController extends GetxController {
  final StorageService storageService = StorageService();
  final ApiService apiService = ApiService();
  late final PregnancyLogAPIRepository pregnancyLogAPIRepository = PregnancyLogAPIRepository(apiService);
  Rx<CurrentlyPregnant> currentlyPregnantData = Rx<CurrentlyPregnant>(CurrentlyPregnant());
  RxList<WeeklyData> weeklyData = <WeeklyData>[].obs;
  late final PregnancyHistoryService _pregnancyHistoryService;
  late final PregnancyLogService _pregnancyLogService;
  late final SyncDataRepository _syncDataRepository;
  RxList<BloodPressure> allBloodPressure = <BloodPressure>[].obs;

  @override
  void onInit() {
    _syncDataRepository = SyncDataRepository();
    _pregnancyHistoryService = PregnancyHistoryService();
    _pregnancyLogService = PregnancyLogService();
    fetchPregnancyData();
    fetchAllBloodPressure();
    setTime(TimeOfDay.now());
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

  Rx<TimeOfDay?> timeSelected = Rx<TimeOfDay?>(null);

  String? get formattedSelectedTime {
    final time = timeSelected.value;

    if (time != null) {
      return formatHourMinute(DateTime(
        0,
        0,
        0,
        time.hour,
        time.minute,
      ));
    }

    return null;
  }

  void setTime(TimeOfDay? time) {
    timeSelected.value = time;
  }

  final Rx<DateTime?> _selectedDate = Rx<DateTime?>(DateTime.now());

  DateTime? get selectedDate => _selectedDate.value;

  void setSelectedDate(DateTime selectedDate) {
    _selectedDate.value = selectedDate;
    update();
  }

  DateTime get combinedDateTime {
    final date = selectedDate;
    final time = timeSelected.value;

    if (date != null && time != null) {
      return DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    }

    return DateTime.now();
  }

  final Rx<int?> _systolicPressure = Rx<int?>(120);

  int? get getSystolicPressure => _systolicPressure.value;

  void setSystolicPressure(int systolic) {
    _systolicPressure.value = systolic;
    update();
  }

  final Rx<int?> _diastolicPressure = Rx<int?>(80);

  int? get getDiastolicPressure => _diastolicPressure.value;

  void setDiastolicPressure(int diastolic) {
    _diastolicPressure.value = diastolic;
    update();
  }

  final Rx<int?> _pulse = Rx<int?>(60);

  int? get getPulse => _pulse.value;

  void setPulse(int pulse) {
    _pulse.value = pulse;
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
        tanggalAwalMinggu.add(formatDateStr(entry.tanggalAwalMinggu!));
      }
      if (entry.tanggalAkhirMinggu != null) {
        tanggalAkhirMinggu.add(formatDateStr(entry.tanggalAkhirMinggu!));
      }
    }

    update();
  }

  Future<void> fetchAllBloodPressure() async {
    List<BloodPressure>? result = await _pregnancyLogService.getAllBloodPressure();

    allBloodPressure.assignAll(result);
    allBloodPressure.sort((a, b) => b.datetime.compareTo(a.datetime));
    update();
  }

  Future<void> addBloodPressure(context) async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    bool localSuccess = false;
    var uuid = Uuid();
    var id = uuid.v4();
    PregnancyDailyLog? pregnancyDailyLog;

    BloodPressure bloodPressure = BloodPressure(
      id: id,
      systolicPressure: getSystolicPressure ?? 120,
      diastolicPressure: getDiastolicPressure ?? 80,
      heartRate: getPulse ?? 60,
      datetime: combinedDateTime.toString(),
    );

    try {
      pregnancyDailyLog = await _pregnancyLogService.addBloodPressure(bloodPressure);
      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(context)!.bloodPressureAddedSuccess));
      localSuccess = true;
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.bloodPressureAddFailed));
      return;
    }

    if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      try {
        await SyncDataService().pendingDataChange();
        await pregnancyLogAPIRepository.addBloodPressure(
          id,
          getSystolicPressure ?? 80,
          getDiastolicPressure ?? 120,
          getPulse ?? 60,
          combinedDateTime,
        );
      } catch (e) {
        await syncAddBloodPressure(id, pregnancyDailyLog?.riwayatKehamilanId ?? 0);
      }
    } else if (localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      await syncAddBloodPressure(id, pregnancyDailyLog?.riwayatKehamilanId ?? 0);
    }

    await fetchAllBloodPressure();
    resetBloodPressure();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => BloodPressureView()),
      (Route<dynamic> route) => route.isFirst,
    );
  }

  Future<void> syncAddBloodPressure(String id, int pregnancyId) async {
    SyncLog syncLog = SyncLog(
      tableName: 'blood_pressure',
      operation: 'create',
      dataId: pregnancyId,
      optionalId: id,
      createdAt: DateTime.now().toString(),
    );

    await _syncDataRepository.addSyncLogData(syncLog);
  }

  Future<void> editBloodPressure(context, String id) async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    bool localSuccess = false;
    PregnancyDailyLog? pregnancyDailyLog;

    BloodPressure bloodPressure = BloodPressure(
      id: id,
      systolicPressure: getSystolicPressure ?? 80,
      diastolicPressure: getDiastolicPressure ?? 120,
      heartRate: getPulse ?? 60,
      datetime: combinedDateTime.toString(),
    );

    try {
      pregnancyDailyLog = await _pregnancyLogService.editBloodPressure(bloodPressure);
      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(context)!.bloodPressureEditedSuccess));
      localSuccess = true;
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.bloodPressureEditFailed));
      return;
    }

    if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      try {
        await SyncDataService().pendingDataChange();
        await pregnancyLogAPIRepository.editBloodPressure(
          id,
          getSystolicPressure ?? 80,
          getDiastolicPressure ?? 120,
          getPulse ?? 60,
          combinedDateTime,
        );
      } catch (e) {
        await syncEditBloodPressure(id, pregnancyDailyLog?.riwayatKehamilanId ?? 0);
      }
    } else if (localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      await syncEditBloodPressure(id, pregnancyDailyLog?.riwayatKehamilanId ?? 0);
    }

    await fetchAllBloodPressure();
    resetBloodPressure();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => BloodPressureView()),
      (Route<dynamic> route) => route.isFirst,
    );
  }

  Future<void> syncEditBloodPressure(String id, int pregnancyId) async {
    SyncLog syncLog = SyncLog(
      tableName: 'blood_pressure',
      operation: 'edit',
      dataId: pregnancyId,
      optionalId: id,
      createdAt: DateTime.now().toString(),
    );

    await _syncDataRepository.addSyncLogData(syncLog);
  }

  Future<void> deleteBloodPressure(context, String id) async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    bool localSuccess = false;
    PregnancyDailyLog? pregnancyDailyLog;

    try {
      pregnancyDailyLog = await _pregnancyLogService.deleteBloodPressure(id);
      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(context)!.bloodPressureDeletedSuccess));
      localSuccess = true;
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.bloodPressureDeleteFailed));
      return;
    }

    if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      try {
        await SyncDataService().pendingDataChange();
        await pregnancyLogAPIRepository.deleteBloodPressure(id);
      } catch (e) {
        await syncDeleteBloodPressure(id, pregnancyDailyLog?.riwayatKehamilanId ?? 0);
      }
    } else if (localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      await syncDeleteBloodPressure(id, pregnancyDailyLog?.riwayatKehamilanId ?? 0);
    }

    await fetchAllBloodPressure();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => BloodPressureView()),
      (Route<dynamic> route) => route.isFirst,
    );
  }

  Future<void> syncDeleteBloodPressure(String id, int pregnancyId) async {
    SyncLog syncLog = SyncLog(
      tableName: 'blood_pressure',
      operation: 'delete',
      dataId: pregnancyId,
      optionalId: id,
      createdAt: DateTime.now().toString(),
    );

    await _syncDataRepository.addSyncLogData(syncLog);
  }

  void resetBloodPressure() {
    setSystolicPressure(120);
    setDiastolicPressure(80);
    setPulse(60);
    setTime(TimeOfDay.now());
    setSelectedDate(DateTime.now());
    setFocusedDate(DateTime.now());
  }
}
