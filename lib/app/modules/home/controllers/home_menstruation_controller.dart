import 'dart:async';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:periodnpregnancycalender/app/utils/utils.dart';
import 'package:periodnpregnancycalender/app/services/services.dart';
import 'package:periodnpregnancycalender/app/repositories/repositories.dart';
import 'package:periodnpregnancycalender/app/models/models.dart';
import 'package:periodnpregnancycalender/app/common/common.dart';

class HomeMenstruationController extends GetxController {
  final ApiService apiService = ApiService();
  late final PeriodRepository periodRepository = PeriodRepository(apiService);
  final Rx<DateTime?> _selectedDate = Rx<DateTime?>(DateTime.now());
  final Rx<DateTime> _focusedDate = Rx<DateTime>(DateTime.now());
  PeriodCycleIndex? data;
  RxList<DateTime> haidAwalList = <DateTime>[].obs;
  late RxList<DateTime> haidAkhirList;
  late RxList<DateTime> ovulasiList;
  late RxList<DateTime> masaSuburAwalList;
  late RxList<DateTime> masaSuburAkhirList;
  late RxList<DateTime> predictHaidAwalList;
  late RxList<DateTime> predictHaidAkhirList;
  late RxList<DateTime> predictOvulasiList;
  late RxList<DateTime> predictMasaSuburAwalList;
  late RxList<DateTime> predictMasaSuburAkhirList;
  late RxList<DateTime> nextPredictHaidAwalList;
  late RxList<DateTime> nextPredictHaidAkhirList;
  late RxList<DateTime> nextPredictOvulasiList;
  late RxList<DateTime> nextPredictMasaSuburAwalList;
  late RxList<DateTime> nextPredictMasaSuburAkhirList;

  late final SyncDataRepository _syncDataRepository;
  late final PeriodHistoryService _periodHistoryService;
  late final PregnancyHistoryService _pregnancyHistoryService;
  final storageService = StorageService();

  Rx<Event> eventDatas = Rx<Event>(Event());

  late List<Map<String, dynamic>> periods = [];
  Rx<DateTime?> startDate = Rx<DateTime?>(DateTime.now());
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  Rx<CalendarFormat> format = Rx<CalendarFormat>(CalendarFormat.week);
  CalendarFormat get getFormat => format.value;
  void setFormat(CalendarFormat newFormat) {
    format.value = newFormat;
  }

  void setStartDate(DateTime? date) {
    startDate.value = date;
    print(startDate);
  }

  void setEndDate(DateTime? date) {
    endDate.value = date;
    print(endDate);
  }

  late Future<PeriodCycleIndex?> periodStream;
  late Future<void> period;

  @override
  Future<void> onInit() async {
    _syncDataRepository = SyncDataRepository();
    _periodHistoryService = PeriodHistoryService();
    _pregnancyHistoryService = PregnancyHistoryService();

    periodStream = fetchCycleData();
    haidAwalList = <DateTime>[].obs;
    haidAkhirList = <DateTime>[].obs;
    ovulasiList = <DateTime>[].obs;
    masaSuburAwalList = <DateTime>[].obs;
    masaSuburAkhirList = <DateTime>[].obs;
    predictHaidAwalList = <DateTime>[].obs;
    predictHaidAkhirList = <DateTime>[].obs;
    predictOvulasiList = <DateTime>[].obs;
    predictMasaSuburAwalList = <DateTime>[].obs;
    predictMasaSuburAkhirList = <DateTime>[].obs;
    nextPredictHaidAwalList = <DateTime>[].obs;
    nextPredictHaidAkhirList = <DateTime>[].obs;
    nextPredictOvulasiList = <DateTime>[].obs;
    nextPredictMasaSuburAwalList = <DateTime>[].obs;
    nextPredictMasaSuburAkhirList = <DateTime>[].obs;
    dateSelectedEvent(DateTime.now());

    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  DateTime? get selectedDate => _selectedDate.value;

  void setSelectedDate(DateTime selectedDate) {
    _selectedDate.value = selectedDate;
    dateSelectedEvent(selectedDate);
    update();
  }

  DateTime get getFocusedDate => _focusedDate.value;

  void setFocusedDate(DateTime selectedDate) {
    _focusedDate.value = selectedDate;
    update();
  }

  Future<PeriodCycleIndex?> fetchCycleData() async {
    try {
      data = await _periodHistoryService.getPeriodIndex();

      if (data != null) {
        data?.actualPeriod?.forEach((history) {
          DateTime haidAwal = DateTime.tryParse('${history.haidAwal}') ?? DateTime.now();
          DateTime haidAkhir = DateTime.tryParse('${history.haidAkhir}') ?? DateTime.now();
          DateTime ovulasi = DateTime.tryParse('${history.ovulasi}') ?? DateTime.now();
          DateTime masaSuburAwal = DateTime.tryParse('${history.masaSuburAwal}') ?? DateTime.now();
          DateTime masaSuburAkhir = DateTime.tryParse('${history.masaSuburAkhir}') ?? DateTime.now();

          haidAwalList.add(haidAwal);
          haidAkhirList.add(haidAkhir);
          ovulasiList.add(ovulasi);
          masaSuburAwalList.add(masaSuburAwal);
          masaSuburAkhirList.add(masaSuburAkhir);
        });

        data?.predictionPeriod?.forEach((predict) {
          DateTime predictHaidAwal = DateTime.tryParse('${predict.haidAwal}') ?? DateTime.now();
          DateTime predictHaidAkhir = DateTime.tryParse('${predict.haidAkhir}') ?? DateTime.now();
          DateTime predictOvulasi = DateTime.tryParse('${predict.ovulasi}') ?? DateTime.now();
          DateTime predictMasaSuburAwal = DateTime.tryParse('${predict.masaSuburAwal}') ?? DateTime.now();
          DateTime predictMasaSuburAkhir = DateTime.tryParse('${predict.masaSuburAkhir}') ?? DateTime.now();

          predictHaidAwalList.add(predictHaidAwal);
          predictHaidAkhirList.add(predictHaidAkhir);
          predictOvulasiList.add(predictOvulasi);
          predictMasaSuburAwalList.add(predictMasaSuburAwal);
          predictMasaSuburAkhirList.add(predictMasaSuburAkhir);
        });
      }
      await getAllPregnancyHistory();
      update();
      return data;
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }

  void dateSelectedEvent(DateTime? inputDate) async {
    if (inputDate != null) {
      var dateEvent = await _periodHistoryService.getDateEvent(inputDate, Get.context);
      if (dateEvent.toString().isNotEmpty) {
        eventDatas.value = dateEvent;
        update();
      } else {
        print("Failed to get date event data");
      }
    }
  }

  bool checkDateMenstruation(DateTime selectedDate) {
    for (int i = 0; i < haidAwalList.length; i++) {
      DateTime haidAwal = haidAwalList[i];
      DateTime haidAkhir = haidAkhirList[i];

      if ((selectedDate.isAtSameMomentAs(haidAwal) || selectedDate.isAfter(haidAwal)) && (selectedDate.isAtSameMomentAs(haidAkhir) || selectedDate.isBefore(haidAkhir))) {
        return true;
      }
    }
    return false;
  }

  String getOrdinalSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    } else {
      switch (day % 10) {
        case 1:
          return 'st';
        case 2:
          return 'nd';
        case 3:
          return 'rd';
        default:
          return 'th';
      }
    }
  }

  String get formattedStartDate => startDate.value != null ? formatDate(startDate.value!) : formatDate(DateTime.now());

  String get formattedEndDate => endDate.value != null ? formatDate(endDate.value!) : formatDate(DateTime.now());

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

        cancelEdit();

        await fetchCycleData();
        await Get.offAllNamed(Routes.NAVIGATION_MENU);
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

  void cancelEdit() {
    startDate.value = DateTime.now();
    endDate.value = DateTime.now();
  }

  List<PregnancyHistory>? pregnancyHistoryList = [];

  Future<void> getAllPregnancyHistory() async {
    pregnancyHistoryList = await _pregnancyHistoryService.getAllPregnancyHistory();
  }
}
