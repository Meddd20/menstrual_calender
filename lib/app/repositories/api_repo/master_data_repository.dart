import 'dart:convert';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_snackbar.dart';
import 'package:periodnpregnancycalender/app/models/master_food_model.dart';
import 'package:http/http.dart' as http;
import 'package:periodnpregnancycalender/app/models/master_pregnancy_model.dart';
import 'package:periodnpregnancycalender/app/models/master_vaccines_model.dart';
import 'package:periodnpregnancycalender/app/models/master_vitamins_model.dart';
import 'package:periodnpregnancycalender/app/modules/profile/views/unauthorized_error_view.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';

class MasterDataRepository {
  final ApiService apiService;
  final Logger _logger = Logger();

  MasterDataRepository(this.apiService);

  Future<List<MasterFood>> getMasterDataFood() async {
    http.Response response = await apiService.getMasterDataFood();

    if (response.statusCode == 200) {
      final List<dynamic> foodsJson = jsonDecode(response.body)["data"];
      final List<MasterFood> food = foodsJson.map<MasterFood>((foodJson) => MasterFood.fromJson(foodJson)).toList();

      return food;
    } else if (response.statusCode == 401) {
      Get.to(() => UnauthorizedErrorView());
      return [];
    } else {
      var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occurred. Please try again later."));
      _logger.e('[API ERROR] $errorMessage');
      throw Exception(errorMessage);
    }
  }

  Future<List<MasterPregnancy>> getMasterDataKehamilan() async {
    http.Response response = await apiService.getMasterDataFood();

    if (response.statusCode == 200) {
      final List<dynamic> pregnancyDatasJson = jsonDecode(response.body)["data"];
      final List<MasterPregnancy> pregnancyData = pregnancyDatasJson.map<MasterPregnancy>((pregnancyDataJson) => MasterPregnancy.fromJson(pregnancyDataJson)).toList();

      return pregnancyData;
    } else if (response.statusCode == 401) {
      Get.to(() => UnauthorizedErrorView());
      return [];
    } else {
      var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occurred. Please try again later."));
      _logger.e('[API ERROR] $errorMessage');
      throw Exception(errorMessage);
    }
  }

  Future<List<MasterVaccine>> getMasterDataVaccines() async {
    http.Response response = await apiService.getMasterDataVaccines();

    if (response.statusCode == 200) {
      final List<dynamic> vaccinesDataJson = jsonDecode(response.body)["data"];
      final List<MasterVaccine> vaccineData = vaccinesDataJson.map<MasterVaccine>((vaccineDataJson) => MasterVaccine.fromJson(vaccineDataJson)).toList();

      return vaccineData;
    } else if (response.statusCode == 401) {
      Get.to(() => UnauthorizedErrorView());
      return [];
    } else {
      var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occurred. Please try again later."));
      _logger.e('[API ERROR] $errorMessage');
      throw Exception(errorMessage);
    }
  }

  Future<List<MasterVitamin>> getMasterDataVitamin() async {
    http.Response response = await apiService.getMasterDataVitamins();

    if (response.statusCode == 200) {
      final List<dynamic> vitaminsDataJson = jsonDecode(response.body)["data"];
      final List<MasterVitamin> vitaminData = vitaminsDataJson.map<MasterVitamin>((vitaminDataJson) => MasterVitamin.fromJson(vitaminDataJson)).toList();

      return vitaminData;
    } else if (response.statusCode == 401) {
      Get.to(() => UnauthorizedErrorView());
      return [];
    } else {
      var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occurred. Please try again later."));
      _logger.e('[API ERROR] $errorMessage');
      throw Exception(errorMessage);
    }
  }
}
