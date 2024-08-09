import 'dart:convert';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_snackbar.dart';
import 'package:periodnpregnancycalender/app/models/daily_log_date_model.dart';
import 'package:periodnpregnancycalender/app/models/daily_log_tags_model.dart';
import 'package:periodnpregnancycalender/app/models/reminder_model.dart';
import 'package:periodnpregnancycalender/app/modules/profile/views/unauthorized_error_view.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/utils/helpers.dart';

class LogRepository {
  final ApiService apiService;
  final Logger _logger = Logger();

  LogRepository(this.apiService);

  Future<DailyLogDate?> getLogsByDate(String logDate) async {
    try {
      DateTime parsedDate = DateTime.parse(logDate);
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

      http.Response response = await apiService.getLogByDate(formattedDate);

      if (response.statusCode == 200) {
        var decodedJson = json.decode(response.body);
        var logsDate = DailyLogDate.fromJson(decodedJson);
        return logsDate;
      } else {
        var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
        Get.showSnackbar(Ui.ErrorSnackBar(message: errorMessage));
        _logger.e("Error during get daily log: $errorMessage");
        return null;
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occurred. Please try again later."));
      _logger.e("Error during get logs by date: $e");
      rethrow;
    }
  }

  Future<DailyLogTags?> getLogsByTags(String tag) async {
    try {
      http.Response response = await apiService.getLogByTags(tag);

      if (response.statusCode == 200) {
        var decodedJson = json.decode(response.body);
        var log = DailyLogTags.fromJson(decodedJson);
        return log;
      } else {
        var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
        Get.showSnackbar(Ui.ErrorSnackBar(message: errorMessage));
        _logger.e("Error during get daily log: $errorMessage");
        return null;
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occurred. Please try again later."));
      _logger.e("Error during get logs by tags: $e");
      rethrow;
    }
  }

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

  Future<Reminder?> getAllReminder() async {
    try {
      http.Response response = await apiService.getAllReminder();

      if (response.statusCode == 200) {
        final List<dynamic> reminderJson = jsonDecode(response.body)["data"];
        final List<Reminders> reminders = reminderJson.map<Reminders>((reminderJson) => Reminders.fromJson(reminderJson)).toList();

        return Reminder(data: reminders);
      } else {
        var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
        Get.showSnackbar(Ui.ErrorSnackBar(message: errorMessage));
        _logger.e("Error during get daily log: $errorMessage");
        return null;
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occurred. Please try again later."));
      _logger.e("Error during get all reminder: $e");
      rethrow;
    }
  }
}
