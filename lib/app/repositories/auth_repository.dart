import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:periodnpregnancycalender/app/common/widgets.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';

class AuthRepository {
  final ApiService apiService;

  AuthRepository(this.apiService);

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      http.Response response = await apiService.login(email, password);

      print(response.body.toString());

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

  Future<Map<String, dynamic>> register(
      String name, DateTime birthday, String email, String password) async {
    try {
      http.Response response =
          await apiService.register(name, birthday, email, password);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "$e"));
      rethrow;
    }
  }

  Future<Map<String, dynamic>> requestVerificationCode(
      String email, String type) async {
    try {
      http.Response response =
          await apiService.requestVerificationCode(email, type);

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

  Future<Map<String, dynamic>> validateCodeVerif(
      String email, String codeVerif, String type, String role) async {
    try {
      http.Response response =
          await apiService.validateCodeVerif(email, codeVerif, type, role);

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

  Future<Map<String, dynamic>> resetPassword(
      String email, String newPassword, String confirmNewPassword) async {
    try {
      http.Response response = await apiService.resetPassword(
          email, newPassword, confirmNewPassword);

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

  Future<void> logout() async {
    try {
      http.Response response = await apiService.logout();
      Get.showSnackbar(
          Ui.SuccessSnackBar(message: jsonDecode(response.body)["message"]));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "$e"));
      rethrow;
    }
  }
}
