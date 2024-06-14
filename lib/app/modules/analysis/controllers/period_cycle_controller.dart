import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:periodnpregnancycalender/app/models/period_cycle_model.dart';
import 'package:periodnpregnancycalender/app/repositories/period_repository.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';

class PeriodCycleController extends GetxController {
  final ApiService apiService = ApiService();
  late final PeriodRepository periodRepository = PeriodRepository(apiService);
  late List<Map<String, dynamic>> periods = [];
  RxList<PeriodCycle> periodCycleData = <PeriodCycle>[].obs;
  Rx<DateTime?> startDate = Rx<DateTime?>(DateTime.now());
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

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
    periodCycleData = <PeriodCycle>[].obs;
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

  String get formattedStartDate => startDate.value != null
      ? DateFormat('yyyy-MM-dd').format(startDate.value!)
      : DateFormat('yyyy-MM-dd').format(DateTime.now());

  String get formattedEndDate => endDate.value != null
      ? DateFormat('yyyy-MM-dd').format(endDate.value!)
      : DateFormat('yyyy-MM-dd').format(DateTime.now());

  Future<void> fetchPeriod() async {
    PeriodCycle? periodCycle = await periodRepository.getPeriodSummary();
    if (periodCycle != null && periodCycle.data != null) {
      periodCycleData.assignAll([periodCycle]);
    }
  }

  void addPeriod(int avgPeriodDuration, int avgPeriodCycle) async {
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

      await periodRepository.storePeriod(periods, avgPeriodCycle, null);

      cancelEdit();
      await fetchPeriod();
    } else {
      print('Please select both start and end dates');
    }
  }

  Future<void> editPeriod(
      int periodId, int? periodCycle, int avgPeriodDuration) async {
    if (startDate.value != null) {
      if (formattedStartDate == formattedEndDate || endDate.value == null) {
        setEndDate(startDate.value!.add(Duration(days: avgPeriodDuration)));
      }
    }
    await periodRepository.updatePeriod(
        periodId, formattedStartDate, formattedEndDate, periodCycle);

    cancelEdit();
    await fetchPeriod();
  }

  void cancelEdit() {
    startDate.value = DateTime.now();
    endDate.value = DateTime.now();
  }
}
