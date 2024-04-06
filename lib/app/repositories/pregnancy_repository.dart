import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class PregnancyRepository {
  final ApiService apiService;

  PregnancyRepository(this.apiService);

  Future<Map<String, dynamic>> pregnancyBegin(
      String firstDayLastMenstruation, String? email_regis) async {
    try {
      DateTime parsedDate = DateTime.parse(firstDayLastMenstruation);
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

      http.Response response =
          await apiService.pregnancyBegin(formattedDate, email_regis);

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
