import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_snackbar.dart';
import 'package:periodnpregnancycalender/app/models/date_event_model.dart';
import 'package:periodnpregnancycalender/app/models/period_cycle_model.dart';
import 'package:periodnpregnancycalender/app/modules/profile/views/unauthorized_error_view.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';

class PeriodRepository {
  final ApiService apiService;
  final Logger _logger = Logger();

  PeriodRepository(this.apiService);

  Future<PeriodCycle?> getPeriodSummary() async {
    try {
      http.Response response = await apiService.getPeriodSummary();

      if (response.statusCode == 200) {
        var decodedJson = json.decode(response.body);
        var periodSummary = PeriodCycle.fromJson(decodedJson);
        return periodSummary;
      } else {
        var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
        Get.showSnackbar(Ui.ErrorSnackBar(message: errorMessage));
        _logger.e("Error during get daily log: $errorMessage");
        return null;
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occurred. Please try again later."));
      _logger.e("Error during get period summary: $e");
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
        var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
        Get.showSnackbar(Ui.ErrorSnackBar(message: errorMessage));
        _logger.e("Error during get daily log: $errorMessage");
        return null;
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occurred. Please try again later."));
      _logger.e("Error during get date event: $e");
      rethrow;
    }
  }

  Future<List<PeriodHistory>?> storePeriod(List<Map<String, dynamic>> periods, int? periodCycle, String? email_regis) async {
    http.Response response = await apiService.storePeriod(periods, periodCycle, email_regis);
    try {
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final List<dynamic> periodHistoryJsonList = responseBody["data"] as List<dynamic>;

        final List<PeriodHistory> periodHistories = periodHistoryJsonList.map((json) => PeriodHistory.fromJson(json as Map<String, dynamic>)).toList();

        return periodHistories;
      } else if (response.statusCode == 401) {
        Get.to(() => UnauthorizedErrorView());
        return [];
      } else {
        var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
        _logger.e('[API ERROR] $errorMessage');
        return null;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> updatePeriod(int periodId, String firstPeriod, String lastPeriod, int? periodCycle) async {
    http.Response response = await apiService.updatePeriod(periodId, firstPeriod, lastPeriod, periodCycle);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      Get.to(() => UnauthorizedErrorView());
    } else {
      var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      _logger.e('[API ERROR] $errorMessage');
    }
  }
}
