import 'dart:ffi';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/widgets.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_model.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_weight_gain.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class PregnancyRepository {
  final ApiService apiService;

  PregnancyRepository(this.apiService);

  Future<Pregnancy?> getPregnancyIndex() async {
    try {
      http.Response response = await apiService.getPeriodSummary();

      if (response.statusCode == 200) {
        var decodedJson = json.decode(response.body);
        var pregnancySummary = Pregnancy.fromJson(decodedJson);
        return pregnancySummary;
      } else {
        throw jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "$e"));
      rethrow;
    }
  }

  Future<Map<String, dynamic>> pregnancyBegin(
      String firstDayLastMenstruation, String? email_regis) async {
    try {
      DateTime parsedDate = DateTime.parse(firstDayLastMenstruation);
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

      http.Response response =
          await apiService.pregnancyBegin(formattedDate, email_regis);

      if (response.statusCode == 200) {
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

  Future<Map<String, dynamic>> pregnancyEnded(
      int id, String pregnancyStatus, String pregnancyEndDate) async {
    try {
      DateTime parsedDate = DateTime.parse(pregnancyEndDate);
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

      http.Response response =
          await apiService.pregnancyEnded(id, pregnancyStatus, formattedDate);

      if (response.statusCode == 200) {
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

  Future<Map<String, dynamic>> editPregnancyStartDate(
      int id, String firstDayLastMenstruation) async {
    try {
      DateTime parsedDate = DateTime.parse(firstDayLastMenstruation);
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

      http.Response response =
          await apiService.editPregnancyStartDate(id, formattedDate);

      if (response.statusCode == 200) {
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

  Future<PregnancyWeightGain?> getWeightGainIndex() async {
    try {
      http.Response response = await apiService.getWeightGainIndex();

      if (response.statusCode == 200) {
        var decodedJson = json.decode(response.body);
        var weightGainIndex = PregnancyWeightGain.fromJson(decodedJson);
        return weightGainIndex;
      } else {
        throw jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "$e"));
      rethrow;
    }
  }

  Future<Map<String, dynamic>> initializeWeightGain(
      double tinggiBadan, double beratBadan, int isTwin) async {
    try {
      http.Response response = await apiService.initializeWeightGain(
          tinggiBadan, beratBadan, isTwin);

      if (response.statusCode == 200) {
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

  Future<Map<String, dynamic>> weeklyWeightGain(
      double beratBadan, int mingguKehamilan, String dateRecord) async {
    try {
      http.Response response = await apiService.weeklyWeightGain(
          beratBadan, mingguKehamilan, dateRecord);

      if (response.statusCode == 200) {
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

  Future<Map<String, dynamic>> editWeeklyWeightGain(
      int id, double beratBadan, int mingguKehamilan, String dateRecord) async {
    try {
      http.Response response = await apiService.editWeeklyWeightGain(
          id, beratBadan, mingguKehamilan, dateRecord);

      if (response.statusCode == 200) {
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

  Future<Map<String, dynamic>> deleteWeeklyWeightGain(int id) async {
    try {
      http.Response response = await apiService.deleteWeeklyWeightGain(id);

      if (response.statusCode == 200) {
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
