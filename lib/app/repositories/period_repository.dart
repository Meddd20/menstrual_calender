import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:periodnpregnancycalender/app/common/widgets.dart';
import 'package:periodnpregnancycalender/app/models/date_event_model.dart';
import 'package:periodnpregnancycalender/app/models/period_cycle_model.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';

class PeriodRepository {
  final ApiService apiService;

  PeriodRepository(this.apiService);

  Future<PeriodCycle?> getPeriodSummary() async {
    try {
      http.Response response = await apiService.getPeriodSummary();

      if (response.statusCode == 200) {
        var decodedJson = json.decode(response.body);
        var periodSummary = PeriodCycle.fromJson(decodedJson);
        return periodSummary;
      } else {
        throw jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "$e"));
      rethrow;
    }
  }

  Future<DateEvent?> getDateEvent(String selectedDate) async {
    try {
      http.Response response = await apiService.getDateEvent(selectedDate);

      if (response.statusCode == 200) {
        var decodedJson = json.decode(response.body);
        var dateEvent = DateEvent.fromJson(decodedJson);
        return dateEvent;
      } else {
        throw jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "$e"));
      rethrow;
    }
  }

  Future<Map<String, dynamic>> storePeriod(List<Map<String, dynamic>> periods,
      int? periodCycle, String? email_regis) async {
    try {
      http.Response response =
          await apiService.storePeriod(periods, periodCycle, email_regis);

      if (response.statusCode == 200) {
        Get.back();
        Get.showSnackbar(
            Ui.SuccessSnackBar(message: jsonDecode(response.body)["message"]));
        return jsonDecode(response.body);
      } else {
        throw jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "$e"));
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updatePeriod(int periodId, String firstPeriod,
      String lastPeriod, int? periodCycle) async {
    try {
      http.Response response = await apiService.updatePeriod(
          periodId, firstPeriod, lastPeriod, periodCycle);

      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Get.back();
        Get.showSnackbar(
            Ui.SuccessSnackBar(message: jsonDecode(response.body)["message"]));
        return jsonDecode(response.body);
      } else {
        throw jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "$e"));
      rethrow;
    }
  }
}
