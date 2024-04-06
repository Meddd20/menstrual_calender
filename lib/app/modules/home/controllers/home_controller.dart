import 'dart:async';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:periodnpregnancycalender/app/models/period_cycle_model.dart'
    as PeriodCycleModel;
import 'package:periodnpregnancycalender/app/models/date_event_model.dart'
    as DateEventModel;
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/repositories/period_repository.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeController extends GetxController {
  final ApiService apiService = ApiService();
  late final PeriodRepository periodRepository = PeriodRepository(apiService);
  final Rx<DateTime?> _selectedDate = Rx<DateTime?>(DateTime.now());
  final Rx<DateTime> _focusedDate = Rx<DateTime>(DateTime.now());
  final RxString currentCycleType = RxString("No Cycle");
  Rx<PeriodCycleModel.PeriodCycle?> periodCycle =
      Rx<PeriodCycleModel.PeriodCycle?>(null);
  late PeriodCycleModel.Data? data;
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

  Rx<DateEventModel.Data> eventDatas =
      Rx<DateEventModel.Data>(DateEventModel.Data());

  late List<Map<String, dynamic>> periods = [];
  Rx<DateTime?> startDate = Rx<DateTime?>(DateTime.now());
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  Rx<CalendarFormat> format = Rx<CalendarFormat>(CalendarFormat.week);
  CalendarFormat get getFormat => format.value;
  void setFormat(CalendarFormat newFormat) {
    format.value = newFormat;
    print(format);
  }

  void setStartDate(DateTime? date) {
    startDate.value = date;
    print(startDate);
  }

  void setEndDate(DateTime? date) {
    endDate.value = date;
    print(endDate);
  }

  late Stream<PeriodCycleModel.Data?> periodStream;
  final StreamController<String> _addPeriodController =
      StreamController<String>();

  Stream<String> get addCommentStream => _addPeriodController.stream;

  void setAddPeriodStream(String comment) {
    _addPeriodController.sink.add(comment);
  }

  @override
  Future<void> onInit() async {
    periodStream = fetchCycleData().asBroadcastStream();
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
    data = PeriodCycleModel.Data(
      initialYear: null,
      latestYear: null,
      currentYear: null,
      age: null,
      lunarAge: null,
      shortestPeriod: null,
      longestPeriod: null,
      shortestCycle: null,
      longestCycle: null,
      avgPeriodDuration: null,
      avgPeriodCycle: null,
      periodChart: [],
      latestPeriodHistory: null,
      periodHistory: [],
      actualPeriod: [],
      predictionPeriod: [],
      gender: [],
    );

    for (int i = 0; i < haidAwalList.length; i++) {
      print(haidAwalList[i]);
    }
    dateSelectedEvent(DateTime.now());
    super.onInit();
  }

  @override
  void onClose() {
    _addPeriodController.close();
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

  Stream<PeriodCycleModel.Data?> fetchCycleData() async* {
    try {
      var periodCycle = await periodRepository.getPeriodSummary();

      data = periodCycle?.data;

      if (data != null) {
        data?.actualPeriod.forEach((history) {
          DateTime haidAwal =
              DateTime.tryParse('${history.haidAwal}') ?? DateTime.now();
          DateTime haidAkhir =
              DateTime.tryParse('${history.haidAkhir}') ?? DateTime.now();
          DateTime ovulasi =
              DateTime.tryParse('${history.ovulasi}') ?? DateTime.now();
          DateTime masaSuburAwal =
              DateTime.tryParse('${history.masaSuburAwal}') ?? DateTime.now();
          DateTime masaSuburAkhir =
              DateTime.tryParse('${history.masaSuburAkhir}') ?? DateTime.now();

          haidAwalList.add(haidAwal);
          haidAkhirList.add(haidAkhir);
          ovulasiList.add(ovulasi);
          masaSuburAwalList.add(masaSuburAwal);
          masaSuburAkhirList.add(masaSuburAkhir);
        });

        data?.predictionPeriod.forEach((predict) {
          DateTime predictHaidAwal =
              DateTime.tryParse('${predict.haidAwal}') ?? DateTime.now();
          DateTime predictHaidAkhir =
              DateTime.tryParse('${predict.haidAkhir}') ?? DateTime.now();
          DateTime predictOvulasi =
              DateTime.tryParse('${predict.ovulasi}') ?? DateTime.now();
          DateTime predictMasaSuburAwal =
              DateTime.tryParse('${predict.masaSuburAwal}') ?? DateTime.now();
          DateTime predictMasaSuburAkhir =
              DateTime.tryParse('${predict.masaSuburAkhir}') ?? DateTime.now();

          predictHaidAwalList.add(predictHaidAwal);
          predictHaidAkhirList.add(predictHaidAkhir);
          predictOvulasiList.add(predictOvulasi);
          predictMasaSuburAwalList.add(predictMasaSuburAwal);
          predictMasaSuburAkhirList.add(predictMasaSuburAkhir);
        });
      }

      // Menyampaikan data melalui stream
      yield data;
    } catch (e) {
      print('Error fetching profile: $e');
      // Jika terjadi kesalahan, Anda bisa melempar kesalahan atau memberikan null
      yield null;
    }
  }

  // Stream<void> fetchCycleData() async* {
  //   try {
  //     var periodCycle = await periodRepository.getPeriodSummary();

  //     data = periodCycle?.data;

  //     if (data != null) {
  //       data?.actualPeriod.forEach((history) {
  //         DateTime haidAwal =
  //             DateTime.tryParse('${history.haidAwal}') ?? DateTime.now();
  //         DateTime haidAkhir =
  //             DateTime.tryParse('${history.haidAkhir}') ?? DateTime.now();
  //         DateTime ovulasi =
  //             DateTime.tryParse('${history.ovulasi}') ?? DateTime.now();
  //         DateTime masaSuburAwal =
  //             DateTime.tryParse('${history.masaSuburAwal}') ?? DateTime.now();
  //         DateTime masaSuburAkhir =
  //             DateTime.tryParse('${history.masaSuburAkhir}') ?? DateTime.now();

  //         haidAwalList.add(haidAwal);
  //         haidAkhirList.add(haidAkhir);
  //         ovulasiList.add(ovulasi);
  //         masaSuburAwalList.add(masaSuburAwal);
  //         masaSuburAkhirList.add(masaSuburAkhir);
  //       });

  //       data?.predictionPeriod.forEach((predict) {
  //         DateTime predictHaidAwal =
  //             DateTime.tryParse('${predict.haidAwal}') ?? DateTime.now();
  //         DateTime predictHaidAkhir =
  //             DateTime.tryParse('${predict.haidAkhir}') ?? DateTime.now();
  //         DateTime predictOvulasi =
  //             DateTime.tryParse('${predict.ovulasi}') ?? DateTime.now();
  //         DateTime predictMasaSuburAwal =
  //             DateTime.tryParse('${predict.masaSuburAwal}') ?? DateTime.now();
  //         DateTime predictMasaSuburAkhir =
  //             DateTime.tryParse('${predict.masaSuburAkhir}') ?? DateTime.now();

  //         predictHaidAwalList.add(predictHaidAwal);
  //         predictHaidAkhirList.add(predictHaidAkhir);
  //         predictOvulasiList.add(predictOvulasi);
  //         predictMasaSuburAwalList.add(predictMasaSuburAwal);
  //         predictMasaSuburAkhirList.add(predictMasaSuburAkhir);
  //       });
  //     }
  //     update();
  //   } catch (e) {
  //     print('Error fetching profile: $e');
  //   }
  // }

  void dateSelectedEvent(DateTime? inputDate) async {
    try {
      if (inputDate != null) {
        String formattedDate = DateFormat('yyyy-MM-dd').format(inputDate);
        var dateEvent = await periodRepository.getDateEvent(formattedDate);
        if (dateEvent != null && dateEvent.status == "success") {
          eventDatas.value = dateEvent.data ?? DateEventModel.Data();
          update();
        } else {
          print("Failed to get date event data");
        }
      }
    } catch (e) {
      print('Error fetching : $e');
    }
  }

  bool checkDateMenstruation(DateTime selectedDate) {
    for (int i = 0; i < haidAwalList.length; i++) {
      DateTime haidAwal = haidAwalList[i];
      DateTime haidAkhir = haidAkhirList[i];

      if ((selectedDate.isAtSameMomentAs(haidAwal) ||
              selectedDate.isAfter(haidAwal)) &&
          (selectedDate.isAtSameMomentAs(haidAkhir) ||
              selectedDate.isBefore(haidAkhir))) {
        return true;
      }
    }
    return false;
  }

  String? formatDate(String? inputDate) {
    if (inputDate == null) {
      return null;
    }
    DateTime date = DateTime.parse(inputDate);
    String formattedDate = DateFormat('MMM dd').format(date);
    return formattedDate;
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

  String get formattedStartDate => startDate.value != null
      ? DateFormat('yyyy-MM-dd').format(startDate.value!)
      : DateFormat('yyyy-MM-dd').format(DateTime.now());

  String get formattedEndDate => endDate.value != null
      ? DateFormat('yyyy-MM-dd').format(endDate.value!)
      : DateFormat('yyyy-MM-dd').format(DateTime.now());

  void addPeriod(int avgPeriodDuration) async {
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

      Map<String, dynamic> saveMenstruationData =
          await periodRepository.storePeriod(periods, null, null);
      _addPeriodController.sink.add("period_added");
      Get.back();
      cancelEdit();
    } else {
      print('Please select both start and end dates');
    }
  }

  void cancelEdit() {
    startDate.value = DateTime.now();
    endDate.value = DateTime.now();
  }
}
