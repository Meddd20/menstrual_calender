import 'dart:convert';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';
import 'package:periodnpregnancycalender/app/utils/api_endpoints.dart';

class ApiService {
  final box = GetStorage();
  late Map<String, String> loginHeaders = {};

  Map<String, String> generalHeaders = {
    "token": "yghMCYkYmtX6YcHdw8lyL2WpQh1IVCiEBIuqOt3r2XTKZNgnuRzYA1XxteNN",
    "Accept": "application/json"
  };

  ApiService() {
    _initializeAuthHeaders();
  }

  void _initializeAuthHeaders() {
    final storedAuth = box.read("loginAuth");
    if (storedAuth != null) {
      loginHeaders = {
        "token": "yghMCYkYmtX6YcHdw8lyL2WpQh1IVCiEBIuqOt3r2XTKZNgnuRzYA1XxteNN",
        "Accept": "application/json",
        "user_id": box.read("loginAuth"),
      };
    } else {
      Get.offAllNamed(Routes.ONBOARDING);
    }
  }

  Future<http.Response> login(String email, String password) async {
    try {
      var url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.login);
      Map<String, String> body = {"email": email, "password": password};

      return await http.post(url, body: body, headers: generalHeaders);
    } catch (e) {
      print("Error: $e");
      throw "An error occurred during the request.";
    }
  }

  Future<http.Response> register(
      String name, DateTime birthday, String email, String password) async {
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.regisUser);

      String formattedBirthday = DateFormat('yyyy-MM-dd').format(birthday);
      Map<String, dynamic> body = {
        "name": name,
        "birthday": formattedBirthday,
        "email": email,
        "password": password
      };

      print(body);

      return await http.post(url, body: body, headers: generalHeaders);
    } catch (e) {
      print("Error: $e");
      throw "An error occurred during the request.";
    }
  }

  Future<http.Response> requestVerificationCode(
      String email, String type) async {
    try {
      var url = Uri.parse(ApiEndPoints.baseUrl +
          ApiEndPoints.authEndPoints.requestVerification);
      Map<String, String> body = {"email": email, "type": type};

      return await http.post(url, body: body, headers: generalHeaders);
    } catch (e) {
      print("Error: $e");
      throw "An error occurred during the request.";
    }
  }

  Future<http.Response> validateCodeVerif(
      String email, String codeVerif, String type, String role) async {
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.verifyCode);
      Map<String, String> body = {
        "email": email,
        "verif_code": codeVerif,
        "type": type,
        "user_role": role
      };

      return await http.post(url, body: body, headers: generalHeaders);
    } catch (e) {
      print("Error: $e");
      throw "An error occurred during the request.";
    }
  }

  Future<http.Response> resetPassword(
      String email, String newPassword, String confirmNewPassword) async {
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.resetPassword);
      Map<String, String> body = {
        "email": email,
        "new_password": newPassword,
        "new_password_confirmation": confirmNewPassword,
      };

      return await http.post(url, body: body, headers: generalHeaders);
    } catch (e) {
      print("Error: $e");
      throw "An error occurred during the request.";
    }
  }

  Future<void> logout() async {
    try {
      var url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.logOut);

      await http.post(url, headers: loginHeaders);
    } catch (e) {
      print("Error: $e");
      throw "An error occurred during the request.";
    }
  }

  Future<http.Response> getProfile() async {
    try {
      var url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.profile);
      return await http.get(url, headers: loginHeaders);
    } catch (e) {
      print("Error: $e");
      throw "An error occurred during the request.";
    }
  }

  Future<http.Response> getAllArticle(String? tags) async {
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.getAllArticle);

      if (tags != null) {
        url = Uri.parse("$url?tags=$tags");
      }

      return await http.get(url, headers: loginHeaders);
    } catch (e) {
      print("Error: $e");
      throw "An error occurred during the request.";
    }
  }

  Future<http.Response> getPeriodSummary() async {
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.indexPeriodCycle);
      return await http.post(url, headers: loginHeaders);
    } catch (e) {
      print("Error: $e");
      throw "An error occurred during the request.";
    }
  }

  Future<http.Response> getDateEvent(String selectedDate) async {
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.dateEvent);
      Map<String, String> body = {"date_selected": "${selectedDate}"};

      return await http.post(url, headers: loginHeaders, body: body);
    } catch (e) {
      print("Error: $e");
      throw "An error occurred during the request.";
    }
  }

  Future<http.Response> storePeriod(List<Map<String, dynamic>> periods,
      int? periodCycle, String? email_regis) async {
    try {
      late Uri url;
      late Map<String, String> headers;

      if (email_regis != null) {
        url = Uri.parse(ApiEndPoints.baseUrl +
            ApiEndPoints.authEndPoints.storePeriod +
            "?email_regis=$email_regis");
        headers = generalHeaders;
      } else {
        url = Uri.parse(
            ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.storePeriod);
        headers = loginHeaders;
      }
      var request = http.MultipartRequest('POST', url)..headers.addAll(headers);

      if (periodCycle != null) {
        request.fields['period_cycle'] = periodCycle.toString();
      }

      // Add each period as a separate field
      for (int i = 0; i < periods.length; i++) {
        request.fields['periods[$i][first_period]'] =
            periods[i]['first_period'].toString();
        request.fields['periods[$i][last_period]'] =
            periods[i]['last_period'].toString();
      }
      print("length : ${periods.length}");

      var response = await request.send();
      return http.Response.fromStream(response);
    } catch (e) {
      print("Error: $e");
      throw "An error occurred during the request.";
    }
  }

  Future<http.Response> updatePeriod(String periodId, String firstPeriod,
      String lastPeriod, int? periodCycle) async {
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.updatePeriod);
      Map<String, dynamic> body = {
        "period_id": periodId,
        "first_period": firstPeriod,
        "last_period": lastPeriod,
      };

      if (periodCycle != null) {
        body["period_cycle"] = periodCycle.toString();
      }

      return await http.patch(url, body: body, headers: loginHeaders);
    } catch (e) {
      print("Error: $e");
      throw "An error occurred during the request.";
    }
  }

  Future<http.Response> getLogByDate(String logDate) async {
    try {
      var url = Uri.parse(
          "${ApiEndPoints.baseUrl}${ApiEndPoints.authEndPoints.logByDate}?date=$logDate");

      return await http.get(url, headers: loginHeaders);
    } catch (e) {
      print("Error: $e");
      throw "An error occurred during the request.";
    }
  }

  Future<http.Response> storeLog(
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
      var url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.storeLog);

      Map<String, dynamic> body = {
        "date": date,
        "sex_activity": sexActivity,
        "bleeding_flow": bleedingFlow,
        "symptoms": jsonEncode(symptoms),
        "vaginal_discharge": vaginalDischarge,
        "moods": jsonEncode(moods),
        "others": jsonEncode(others),
        "physical_activity": jsonEncode(physicalActivity),
        "temperature": temperature,
        "weight": weight,
        "notes": notes,
      };

      return await http.patch(url, body: body, headers: loginHeaders);
    } catch (e) {
      print("Error: $e");
      throw "An error occurred during the request.";
    }
  }

  Future<http.Response> storeReminder(
      String title, String description, String dateTime) async {
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.storeReminder);

      Map<String, dynamic> body = {
        "title": title,
        "description": description,
        "datetime": dateTime
      };

      return await http.patch(url, body: body, headers: loginHeaders);
    } catch (e) {
      print("Error: $e");
      throw "An error occurred during the request.";
    }
  }

  Future<http.Response> editReminder(
      String id, String title, String? description, String dateTime) async {
    try {
      print(dateTime);
      var url = Uri.parse(
          '${ApiEndPoints.baseUrl}${ApiEndPoints.authEndPoints.editReminder}/$id');

      Map<String, dynamic> body = {
        "title": title,
        "description": description,
        "datetime": dateTime,
      };

      return await http.patch(url, body: body, headers: loginHeaders);
    } catch (e) {
      print("Error: $e");
      throw "An error occurred during the request.";
    }
  }

  Future<http.Response> deleteReminder(String id) async {
    try {
      var url = Uri.parse(
          '${ApiEndPoints.baseUrl}${ApiEndPoints.authEndPoints.deleteReminder}/$id');
      print(url);
      return await http.delete(url, headers: loginHeaders);
    } catch (e) {
      print("Error: $e");
      throw "An error occurred during the request.";
    }
  }

  Future<http.Response> getReminder(String id) async {
    try {
      var url = Uri.parse(
          '${ApiEndPoints.baseUrl}${ApiEndPoints.authEndPoints.getReminder}/$id');

      return await http.patch(url, headers: loginHeaders);
    } catch (e) {
      print("Error: $e");
      throw "An error occurred during the request.";
    }
  }

  Future<http.Response> getAllReminder() async {
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.getAllReminder);

      return await http.get(url, headers: loginHeaders);
    } catch (e) {
      print("Error: $e");
      throw "An error occurred during the request.";
    }
  }
}
