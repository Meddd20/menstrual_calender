import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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

  String setActual(String? isActual) {
    if (isActual == "1") {
      return "Data Actual";
    } else {
      return "Data Prediksi";
    }
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
    try {
      PeriodCycle? periodCycle = await periodRepository.getPeriodSummary();
      if (periodCycle != null && periodCycle.data != null) {
        periodCycleData.assignAll([periodCycle]);
      }
    } catch (e) {
      print("Error fetching articles: $e");
    }
  }

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
      await fetchPeriod();
      Get.back();
      cancelEdit();
    } else {
      print('Please select both start and end dates');
    }
  }

  Future<void> editPeriod(String periodId, int? periodCycle) async {
    try {
      String startDateString = startDate.value != null
          ? DateFormat('y-MM-dd').format(startDate.value!)
          : "";
      String endDateString = endDate.value != null
          ? DateFormat('y-MM-dd').format(endDate.value!)
          : "";
      var periodData = await periodRepository.updatePeriod(
          periodId, startDateString, endDateString, periodCycle);
      await fetchPeriod();
      Get.back();
      cancelEdit();
    } catch (e) {
      print("Error editing period: $e");
    }
  }

  void cancelEdit() {
    startDate.value = DateTime.now();
    endDate.value = DateTime.now();
  }
}
