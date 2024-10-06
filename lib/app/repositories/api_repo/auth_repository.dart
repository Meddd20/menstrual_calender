import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_snackbar.dart';
import 'package:periodnpregnancycalender/app/models/profile_model.dart';
import 'package:periodnpregnancycalender/app/modules/profile/views/unauthorized_error_view.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';

class AuthRepository {
  final ApiService apiService;
  final Logger _logger = Logger();

  AuthRepository(this.apiService);

  Future<User?> login(String email, String password) async {
    http.Response response = await apiService.login(email, password);

    if (response.statusCode == 200) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: jsonDecode(response.body)["message"]));
      Profile profile = Profile.fromJson(jsonDecode(response.body));
      return profile.user;
    } else {
      var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occurred. Please try again later."));
      _logger.e('[API ERROR] $errorMessage');
      throw Exception(errorMessage);
    }
  }

  Future<Map<String, dynamic>> register(String name, DateTime birthday, String email, String password) async {
    http.Response response = await apiService.register(name, birthday, email, password);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occurred. Please try again later."));
      _logger.e('[API ERROR] $errorMessage');
      throw Exception(errorMessage);
    }
  }

  Future<Map<String, dynamic>> requestVerificationCode(String email, String type) async {
    http.Response response = await apiService.requestVerificationCode(email, type);

    if (response.statusCode == 200) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: jsonDecode(response.body)["message"]));
      return jsonDecode(response.body);
    } else {
      var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occurred. Please try again later."));
      _logger.e('[API ERROR] $errorMessage');
      throw Exception(errorMessage);
    }
  }

  Future<Map<String, dynamic>> validateCodeVerif(String email, String codeVerif, String type, String role) async {
    http.Response response = await apiService.validateCodeVerif(email, codeVerif, type, role);

    if (response.statusCode == 200) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: jsonDecode(response.body)["message"]));
      return jsonDecode(response.body);
    } else {
      var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occurred. Please try again later."));
      _logger.e('[API ERROR] $errorMessage');
      throw Exception(errorMessage);
    }
  }

  Future<Map<String, dynamic>> resetPassword(String email, String newPassword, String confirmNewPassword) async {
    http.Response response = await apiService.resetPassword(email, newPassword, confirmNewPassword);

    if (response.statusCode == 200) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: jsonDecode(response.body)["message"]));
      return jsonDecode(response.body);
    } else {
      var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occurred. Please try again later."));
      _logger.e('[API ERROR] $errorMessage');
      throw Exception(errorMessage);
    }
  }

  Future<void> logout() async {
    try {
      http.Response response = await apiService.logout();
      Get.showSnackbar(Ui.SuccessSnackBar(message: jsonDecode(response.body)["message"]));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occurred. Please try again later."));
      _logger.e('[API ERROR] $e');
      rethrow;
    }
  }

  Future<void> checkToken() async {
    http.Response response = await apiService.checkToken();
    if (response.statusCode == 401) {
      Get.to(() => UnauthorizedErrorView());
    }
  }

  Future<void> deleteData() async {
    http.Response response = await apiService.deleteData();

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
