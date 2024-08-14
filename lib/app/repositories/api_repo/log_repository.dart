import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:periodnpregnancycalender/app/modules/profile/views/unauthorized_error_view.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/utils/helpers.dart';

class LogRepository {
  final ApiService apiService;
  final Logger _logger = Logger();

  LogRepository(this.apiService);

  Future<void> storeLog(String date, String? sexActivity, String? bleedingFlow, Map<String, dynamic> symptoms, String? vaginalDischarge, Map<String, dynamic> moods, Map<String, dynamic> others, Map<String, dynamic> physicalActivity, String? temperature, String? weight, String? notes) async {
    String formattedDate = formatDate(DateTime.parse(date));

    http.Response response = await apiService.storeLog(
      formattedDate,
      sexActivity,
      bleedingFlow,
      symptoms,
      vaginalDischarge,
      moods,
      others,
      physicalActivity,
      temperature,
      weight,
      notes,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      Get.to(() => UnauthorizedErrorView());
    } else {
      var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      _logger.e('[API ERROR] $errorMessage');
    }
  }

  Future<void> storeReminder(String id, String title, String description, String dateTime) async {
    http.Response response = await apiService.storeReminder(id, title, description, dateTime);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      Get.to(() => UnauthorizedErrorView());
    } else {
      var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      _logger.e('[API ERROR] $errorMessage');
    }
  }

  Future<void> editReminder(String id, String title, String? description, String dateTime) async {
    http.Response response = await apiService.editReminder(id, title, description, dateTime);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      Get.to(() => UnauthorizedErrorView());
    } else {
      var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      _logger.e('[API ERROR] $errorMessage');
    }
  }

  Future<void> deleteReminder(String id) async {
    http.Response response = await apiService.deleteReminder(id);

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
