import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_snackbar.dart';
import 'package:periodnpregnancycalender/app/models/master_data_version_model.dart';
import 'package:periodnpregnancycalender/app/models/sync_data_model.dart';
import 'package:periodnpregnancycalender/app/modules/profile/views/unauthorized_error_view.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';

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
}
