import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:periodnpregnancycalender/app/services/api_service.dart';

class AuthRepository {
  final ApiService apiService;

  AuthRepository(this.apiService);

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      http.Response response = await apiService.login(email, password);

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

  Future<Map<String, dynamic>> register(
      String name, DateTime birthday, String email, String password) async {
    try {
      print(name + " " + birthday.toString() + " " + email + " " + password);
      http.Response response =
          await apiService.register(name, birthday, email, password);

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

  Future<Map<String, dynamic>> requestVerificationCode(
      String email, String type) async {
    try {
      http.Response response =
          await apiService.requestVerificationCode(email, type);

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

  Future<Map<String, dynamic>> validateCodeVerif(
      String email, String codeVerif, String type, String role) async {
    try {
      http.Response response =
          await apiService.validateCodeVerif(email, codeVerif, type, role);

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

  Future<Map<String, dynamic>> resetPassword(
      String email, String newPassword, String confirmNewPassword) async {
    try {
      http.Response response = await apiService.resetPassword(
          email, newPassword, confirmNewPassword);

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

  Future<void> logout() async {
    try {
      await apiService.logout();
    } catch (e) {
      print("Error: $e");
      throw "An error occurred during the request.";
    }
  }
}
