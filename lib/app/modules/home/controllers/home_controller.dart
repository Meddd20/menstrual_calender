import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:periodnpregnancycalender/app/models/period_cycle_model.dart'
    as PeriodCycleModel;
import 'package:periodnpregnancycalender/app/models/date_event_model.dart'
    as DateEventModel;
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/repositories/period_repository.dart';

class HomeController extends GetxController {
  final ApiService apiService = ApiService();
  late final PeriodRepository periodRepository = PeriodRepository(apiService);
  final Rx<DateTime?> _selectedDate = Rx<DateTime?>(DateTime.now());
  final RxString currentCycleType = RxString("No Cycle");
  Rx<PeriodCycleModel.PeriodCycle?> periodCycle =
      Rx<PeriodCycleModel.PeriodCycle?>(null);
  late PeriodCycleModel.Data? data;
  late RxList<DateTime> haidAwalList;
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

  @override
  Future<void> onInit() async {
    haidAwalList = <DateTime>[].obs;
    print(haidAwalList);
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
    await fetchCycleData();
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

  Future<void> fetchCycleData() async {
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
      update();
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  String? formatDate(String? inputDate) {
    if (inputDate == null) {
      return null;
    }
    DateTime date = DateTime.parse(inputDate);
    String formattedDate = DateFormat('dd MMM').format(date);
    return formattedDate;
  }

  void dateSelectedEvent(DateTime? inputDate) async {
    try {
      if (inputDate != null) {
        String formattedDate = DateFormat('yyyy-MM-dd').format(inputDate);
        var dateEvent = await periodRepository.getDateEvent(formattedDate);
        if (dateEvent != null && dateEvent.status == "success") {
          // Access data here
          eventDatas.value = dateEvent.data ?? DateEventModel.Data();
          update();
        } else {
          // Handle the case when the API call is not successful
          print("Failed to get date event data");
        }
      }
    } catch (e) {
      print('Error fetching : $e');
    }
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
}
