import 'dart:convert';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:periodnpregnancycalender/app/modules/profile/views/unauthorized_error_view.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/utils/helpers.dart';

class PregnancyLogAPIRepository {
  final ApiService apiService;
  final Logger _logger = Logger();

  PregnancyLogAPIRepository(this.apiService);

  Future<void> storePregnancyLog(DateTime date, Map<String, dynamic> pregnancySymptoms, double? temperature, String? notes) async {
    http.Response response = await apiService.storePregnancyLog(
      formatDate(date),
      pregnancySymptoms,
      temperature.toString(),
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

  Future<void> deletePregnancyLog(DateTime date) async {
    http.Response response = await apiService.deletePregnancyLog(formatDate(date));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      Get.to(() => UnauthorizedErrorView());
    } else {
      var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      _logger.e('[API ERROR] $errorMessage');
    }
  }

  Future<void> addBloodPressure(String id, int tekananSistolik, int tekananDiastolik, int detakJantung, DateTime datetime) async {
    http.Response response = await apiService.addBloodPressure(
      id,
      tekananSistolik.toString(),
      tekananDiastolik.toString(),
      detakJantung.toString(),
      formatDateTime(datetime),
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

  Future<void> editBloodPressure(String id, int tekananSistolik, int tekananDiastolik, int detakJantung, DateTime datetime) async {
    http.Response response = await apiService.editBloodPressure(
      id,
      tekananSistolik.toString(),
      tekananDiastolik.toString(),
      detakJantung.toString(),
      formatDateTime(datetime),
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

  Future<void> deleteBloodPressure(String id) async {
    http.Response response = await apiService.deleteBloodPressure(id);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      Get.to(() => UnauthorizedErrorView());
    } else {
      var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      _logger.e('[API ERROR] $errorMessage');
    }
  }

  Future<void> addContractionTimer(String id, DateTime startDate, int duration) async {
    http.Response response = await apiService.addContractionTimer(
      id,
      formatDateTime(startDate),
      duration.toString(),
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

  Future<void> deleteContractionTimer(String id) async {
    http.Response response = await apiService.deleteContractionTimer(id);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      Get.to(() => UnauthorizedErrorView());
    } else {
      var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      _logger.e('[API ERROR] $errorMessage');
    }
  }

  Future<void> addKickCounter(String id, DateTime datetime) async {
    http.Response response = await apiService.addKickCounter(id, formatDateTime(datetime));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      Get.to(() => UnauthorizedErrorView());
    } else {
      var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      _logger.e('[API ERROR] $errorMessage');
    }
  }

  Future<void> addKickCounterData(String id, DateTime startDate, DateTime endDate, int totalKicks) async {
    http.Response response = await apiService.addKickCounterData(
      id,
      formatDateTime(startDate),
      formatDateTime(endDate),
      totalKicks.toString(),
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

  Future<void> deleteKickCounter(String id) async {
    http.Response response = await apiService.deleteKickCounter(id);

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
