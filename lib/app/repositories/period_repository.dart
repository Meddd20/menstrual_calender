import 'dart:convert';
import 'package:http/http.dart' as http;
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
      print("Error: $e");
      throw "An error occurred during the request.";
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
      print("Error: $e");
      throw "An error occurred during the request.";
    }
  }

  Future<Map<String, dynamic>> storePeriod(List<Map<String, dynamic>> periods,
      int? periodCycle, String? email_regis) async {
    try {
      print("bgebew8gb${periods}");
      http.Response response =
          await apiService.storePeriod(periods, periodCycle, email_regis);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      }
    } catch (e) {
      print("Error: $e");
      throw "An error occurred during the request.";
    }
  }

  Future<Map<String, dynamic>> updatePeriod(String periodId, String firstPeriod,
      String lastPeriod, int? periodCycle) async {
    try {
      http.Response response = await apiService.updatePeriod(
          periodId, firstPeriod, lastPeriod, periodCycle);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      }
    } catch (e) {
      print("Error: $e");
      throw "An error occurred during the request.";
    }
  }
}
