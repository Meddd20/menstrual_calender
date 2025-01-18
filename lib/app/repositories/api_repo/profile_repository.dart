import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:periodnpregnancycalender/app/modules/profile/views/unauthorized_error_view.dart';

import 'package:periodnpregnancycalender/app/services/services.dart';
import 'package:periodnpregnancycalender/app/repositories/repositories.dart';
import 'package:periodnpregnancycalender/app/models/models.dart';
import 'package:periodnpregnancycalender/app/common/common.dart';

class ProfileRepository {
  final ApiService apiService;
  final Logger _logger = Logger();

  ProfileRepository(this.apiService);

  Future<DataCategoryByTable?> fetchSyncDataFromApi() async {
    http.Response response = await apiService.getSycDataApi();

    if (response.statusCode == 200) {
      var decodedJson = json.decode(response.body);
      var syncData = DataCategoryByTable.fromJson(decodedJson['data']);
      return syncData;
    } else if (response.statusCode == 401) {
      Get.to(() => UnauthorizedErrorView());
      return null;
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occurred. Please try again later."));
      var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      _logger.e('[API ERROR] $errorMessage');
      return null;
    }
  }

  Future<List<MasterDataVersion>?> fetchSyncMasterDataVersion() async {
    http.Response response = await apiService.getSycMasterDataApi();

    if (response.statusCode == 200) {
      var decodedJson = json.decode(response.body);
      List<MasterDataVersion> syncDataList = (decodedJson['data'] as List).map((item) => MasterDataVersion.fromJson(item)).toList();
      return syncDataList;
    } else if (response.statusCode == 401) {
      Get.to(() => UnauthorizedErrorView());
      return null;
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occurred. Please try again later."));
      var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      _logger.e('[API ERROR] $errorMessage');
      return null;
    }
  }

  Future<void> editProfile(String nama, String tanggalLahir) async {
    http.Response response = await apiService.editProfile(nama, tanggalLahir);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      Get.to(() => UnauthorizedErrorView());
    } else {
      var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      _logger.e('[API ERROR] $errorMessage');
    }
  }

  Future<DataCategoryByTable?> resyncData(Map<String, dynamic> userData) async {
    http.Response response = await apiService.resyncData(userData);

    if (response.statusCode == 200) {
      var decodedJson = json.decode(response.body);
      var syncData = DataCategoryByTable.fromJson(decodedJson['data']);
      return syncData;
    } else if (response.statusCode == 401) {
      Get.to(() => UnauthorizedErrorView());
      return null;
    } else {
      var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      _logger.e('[API ERROR] $errorMessage');
      return null;
    }
  }

  Future<DataCategoryByTable?> resyncPendingData(Map<String, dynamic> userData) async {
    http.Response response = await apiService.resyncPendingData(userData);

    if (response.statusCode == 200) {
      SyncDataRepository().deleteAllSyncLogData();
      var decodedJson = json.decode(response.body);
      var syncData = DataCategoryByTable.fromJson(decodedJson['data']);
      return syncData;
    } else if (response.statusCode == 401) {
      Get.to(() => UnauthorizedErrorView());
      return null;
    } else {
      var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      _logger.e('[API ERROR] $errorMessage');
      return null;
    }
  }
}
