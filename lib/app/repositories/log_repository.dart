import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:periodnpregnancycalender/app/models/daily_log_date_model.dart';
import 'package:periodnpregnancycalender/app/models/daily_log_tags_model.dart';
import 'package:periodnpregnancycalender/app/models/reminder_model.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';

class LogRepository {
  final ApiService apiService;

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
        throw jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      }
    } catch (e) {
      print("Error: $e");
      throw "An error occurred during the request.";
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
        throw jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      }
    } catch (e) {
      print("Error: $e");
      throw "An error occurred during the request.";
    }
  }

  Future<Map<String, dynamic>> storeLog(
      String date,
      String? sexActivity,
      String? bleedingFlow,
      Map<String, bool> symptoms,
      String? vaginalDischarge,
      Map<String, bool> moods,
      Map<String, bool> others,
      Map<String, bool> physicalActivity,
      String? temperature,
      String? weight,
      String? notes) async {
    try {
      DateTime parsedDate = DateTime.parse(date);
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

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
      } else {
        throw jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      }
    } catch (e) {
      print("Error: $e");
      throw "An error occurred during the request.";
    }
  }

  Future<Map<String, dynamic>> storeReminder(
      String title, String description, String dateTime) async {
    try {
      http.Response response =
          await apiService.storeReminder(title, description, dateTime);

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

  Future<Map<String, dynamic>> editReminder(
      String id, String title, String? description, String dateTime) async {
    try {
      http.Response response =
          await apiService.editReminder(id, title, description, dateTime);

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

  Future<Map<String, dynamic>> deleteReminder(String id) async {
    try {
      http.Response response = await apiService.deleteReminder(id);

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

  Future<Reminders?> getReminder(String id) async {
    try {
      http.Response response = await apiService.getReminder(id);

      if (response.statusCode == 200) {
        final Map<String, dynamic> reminderJson = jsonDecode(response.body);
        final Reminders reminder = Reminders.fromJson(reminderJson);

        return reminder;
      } else {
        throw jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      }
    } catch (e) {
      print("Error: $e");
      throw "An error occurred during the request.";
    }
  }

  Future<Reminder?> getAllReminder() async {
    try {
      http.Response response = await apiService.getAllReminder();

      if (response.statusCode == 200) {
        final List<dynamic> reminderJson = jsonDecode(response.body)["data"];
        final List<Reminders> reminders = reminderJson
            .map<Reminders>((reminderJson) => Reminders.fromJson(reminderJson))
            .toList();

        return Reminder(data: reminders);
      } else {
        throw jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      }
    } catch (e) {
      print("Error: $e");
      throw "An error occurred during the request.";
    }
  }
}
