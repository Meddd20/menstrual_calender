import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:periodnpregnancycalender/app/common/widgets.dart';
import 'package:periodnpregnancycalender/app/models/profile_model.dart';
import 'package:periodnpregnancycalender/app/models/sync_data_model.dart';
import 'package:periodnpregnancycalender/app/models/sync_log_model.dart';
import 'package:periodnpregnancycalender/app/repositories/local/sync_data_repository.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';

class ProfileRepository {
  final ApiService apiService;
  final DatabaseHelper databaseHelper;
  final Logger _logger = Logger();

  late final SyncDataRepository _syncDataRepository;

  ProfileRepository(this.apiService, this.databaseHelper) {
    _syncDataRepository = SyncDataRepository(databaseHelper);
  }

  Future<DataCategoryByTable?> fetchSyncDataFromApi() async {
    try {
      http.Response response = await apiService.getSycDataApi();

      if (response.statusCode == 200) {
        var decodedJson = json.decode(response.body);
        var syncData = DataCategoryByTable.fromJson(decodedJson['data']);
        return syncData;
      } else {
        var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
        Get.showSnackbar(Ui.ErrorSnackBar(message: errorMessage));
        _logger.e("Error during get daily log: $errorMessage");
        return null;
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occurred. Please try again later."));
      _logger.e("Error during get sync data: $e");
      rethrow;
    }
  }

  Future<Profile?> getProfile() async {
    try {
      http.Response response = await apiService.getProfile();

      if (response.statusCode == 200) {
        var decodedJson = json.decode(response.body);
        var profile = Profile.fromJson(decodedJson);
        return profile;
      } else {
        var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
        Get.showSnackbar(Ui.ErrorSnackBar(message: errorMessage));
        _logger.e("Error during get daily log: $errorMessage");
        return null;
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occurred. Please try again later."));
      _logger.e("Error during get profile: $e");
      rethrow;
    }
  }

  Future<void> editProfile(String nama, String tanggalLahir) async {
    try {
      http.Response response = await apiService.editProfile(nama, tanggalLahir);

      if (response.statusCode == 200) {
        Get.showSnackbar(Ui.SuccessSnackBar(message: jsonDecode(response.body)["message"]));
        return jsonDecode(response.body);
      } else {
        var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
        Get.showSnackbar(Ui.ErrorSnackBar(message: errorMessage));
        _logger.e("Error during edit profile: $errorMessage");
        throw Exception(errorMessage);
      }
    } catch (e) {
      Map<String, dynamic> data = {"nama": nama, "birthday": tanggalLahir};

      String jsonData = jsonEncode(data);

      SyncLog syncLog = SyncLog(
        tableName: 'tb_user',
        operation: 'updateProfile',
        data: jsonData,
        createdAt: DateTime.now().toString(),
      );

      await _syncDataRepository.addSyncLogData(syncLog);
    }
  }
}
