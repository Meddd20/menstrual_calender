import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:periodnpregnancycalender/app/common/widgets.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_model.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_weight_gain.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class PregnancyRepository {
  final ApiService apiService;
  final Logger _logger = Logger();

  PregnancyRepository(this.apiService);

  Future<Pregnancy?> getPregnancyIndex() async {
    try {
      http.Response response = await apiService.getPregnancyIndex();

      if (response.statusCode == 200) {
        var decodedJson = json.decode(response.body);
        var pregnancySummary = Pregnancy.fromJson(decodedJson);
        return pregnancySummary;
      } else {
        var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
        Get.showSnackbar(Ui.ErrorSnackBar(message: errorMessage));
        _logger.e("Error during get daily log: $errorMessage");
        return null;
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occurred. Please try again later."));
      _logger.e("Error during get pregnancy index: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> pregnancyBegin(String firstDayLastMenstruation, String? email_regis) async {
    DateTime parsedDate = DateTime.parse(firstDayLastMenstruation);
    String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

    http.Response response = await apiService.pregnancyBegin(formattedDate, email_regis);

    if (response.statusCode == 200) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: jsonDecode(response.body)["message"]));
      return jsonDecode(response.body);
    } else {
      var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      Get.showSnackbar(Ui.ErrorSnackBar(message: errorMessage));
      _logger.e("Error during get daily log: $errorMessage");
      throw Exception(errorMessage);
    }
  }

  Future<void> pregnancyEnded(String pregnancyEndDate, String gender) async {
    DateTime parsedDate = DateTime.parse(pregnancyEndDate);
    String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

    http.Response response = await apiService.pregnancyEnded(formattedDate, gender);

    if (response.statusCode == 200) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: jsonDecode(response.body)["message"]));
      return jsonDecode(response.body);
    } else {
      var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      Get.showSnackbar(Ui.ErrorSnackBar(message: errorMessage));
      _logger.e("Error during get daily log: $errorMessage");
      throw Exception(errorMessage);
    }
  }

  Future<void> deletePregnancy() async {
    http.Response response = await apiService.deletePregnancy();

    if (response.statusCode == 200) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: jsonDecode(response.body)["message"]));
      return jsonDecode(response.body);
    } else {
      var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      Get.showSnackbar(Ui.ErrorSnackBar(message: errorMessage));
      _logger.e("Error during get daily log: $errorMessage");
      throw Exception(errorMessage);
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
        var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
        Get.showSnackbar(Ui.ErrorSnackBar(message: errorMessage));
        _logger.e("Error during get daily log: $errorMessage");
        return null;
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occurred. Please try again later."));
      _logger.e("Error during get weight gain index: $e");
      rethrow;
    }
  }

  Future<void> initializeWeightGain(double tinggiBadan, double beratBadan, int isTwin) async {
    http.Response response = await apiService.initializeWeightGain(tinggiBadan, beratBadan, isTwin);

    if (response.statusCode == 200) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: jsonDecode(response.body)["message"]));
      return jsonDecode(response.body);
    } else {
      var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      Get.showSnackbar(Ui.ErrorSnackBar(message: errorMessage));
      _logger.e("Error during get daily log: $errorMessage");
      throw Exception(errorMessage);
    }
  }

  Future<void> weeklyWeightGain(double beratBadan, int mingguKehamilan, String dateRecord) async {
    http.Response response = await apiService.weeklyWeightGain(beratBadan, mingguKehamilan, dateRecord);

    if (response.statusCode == 200) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: jsonDecode(response.body)["message"]));
      return jsonDecode(response.body);
    } else {
      var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      Get.showSnackbar(Ui.ErrorSnackBar(message: errorMessage));
      _logger.e("Error during get daily log: $errorMessage");
      throw Exception(errorMessage);
    }
  }

  Future<void> deleteWeeklyWeightGain(DateTime dateRecord) async {
    http.Response response = await apiService.deleteWeeklyWeightGain(dateRecord.toString());

    if (response.statusCode == 200) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: jsonDecode(response.body)["message"]));
      return jsonDecode(response.body);
    } else {
      var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      Get.showSnackbar(Ui.ErrorSnackBar(message: errorMessage));
      _logger.e("Error during get daily log: $errorMessage");
      throw Exception(errorMessage);
    }
  }
}
