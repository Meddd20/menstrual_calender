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
    var url =
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.login);
    Map<String, String> body = {"email": email, "password": password};

    return await http.post(url, body: body, headers: generalHeaders);
  }

  Future<http.Response> register(
      String name, DateTime birthday, String email, String password) async {
    var url =
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.regisUser);

    String formattedBirthday = DateFormat('yyyy-MM-dd').format(birthday);
    Map<String, dynamic> body = {
      "name": name,
      "birthday": formattedBirthday,
      "email": email,
      "password": password
    };

    return await http.post(url, body: body, headers: generalHeaders);
  }

  Future<http.Response> requestVerificationCode(
      String email, String type) async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.requestVerification);
    Map<String, String> body = {"email": email, "type": type};

    return await http.post(url, body: body, headers: generalHeaders);
  }

  Future<http.Response> validateCodeVerif(
      String email, String codeVerif, String type, String role) async {
    var url =
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.verifyCode);
    Map<String, String> body = {
      "email": email,
      "verif_code": codeVerif,
      "type": type,
      "user_role": role
    };

    return await http.post(url, body: body, headers: generalHeaders);
  }

  Future<http.Response> resetPassword(
      String email, String newPassword, String confirmNewPassword) async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.resetPassword);
    Map<String, String> body = {
      "email": email,
      "new_password": newPassword,
      "new_password_confirmation": confirmNewPassword,
    };

    return await http.post(url, body: body, headers: generalHeaders);
  }

  Future<http.Response> logout() async {
    var url =
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.logOut);

    return await http.post(url, headers: loginHeaders);
  }

  Future<http.Response> getProfile() async {
    var url =
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.profile);
    return await http.get(url, headers: loginHeaders);
  }

  Future<http.Response> getAllArticle(String? tags) async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.getAllArticle);

    if (tags != null) {
      url = Uri.parse("$url?tags=$tags");
    }

    return await http.get(url, headers: loginHeaders);
  }

  Future<http.Response> getArticle(int id) async {
    var url = Uri.parse(
        '${ApiEndPoints.baseUrl}${ApiEndPoints.authEndPoints.getArticle}/$id');

    return await http.get(url, headers: loginHeaders);
  }

  Future<http.Response> getPeriodSummary() async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.getPregnancyIndex);
    return await http.get(url, headers: loginHeaders);
  }

  Future<http.Response> getDateEvent(String selectedDate) async {
    var url =
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.dateEvent);
    Map<String, String> body = {"date_selected": "${selectedDate}"};

    return await http.post(url, headers: loginHeaders, body: body);
  }

  Future<http.Response> storePeriod(List<Map<String, dynamic>> periods,
      int? periodCycle, String? email_regis) async {
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

    for (int i = 0; i < periods.length; i++) {
      request.fields['periods[$i][first_period]'] =
          periods[i]['first_period'].toString();
      request.fields['periods[$i][last_period]'] =
          periods[i]['last_period'].toString();
    }

    var response = await request.send();
    return http.Response.fromStream(response);
  }

  Future<http.Response> updatePeriod(int periodId, String firstPeriod,
      String lastPeriod, int? periodCycle) async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.updatePeriod);
    Map<String, dynamic> body = {
      "period_id": periodId.toString(),
      "first_period": firstPeriod,
      "last_period": lastPeriod,
    };

    if (periodCycle != null) {
      body["period_cycle"] = periodCycle.toString();
    }

    return await http.patch(url, body: body, headers: loginHeaders);
  }

  Future<http.Response> getLogByDate(String logDate) async {
    var url = Uri.parse(
        "${ApiEndPoints.baseUrl}${ApiEndPoints.authEndPoints.logByDate}?date=$logDate");

    return await http.get(url, headers: loginHeaders);
  }

  Future<http.Response> getLogByTags(String tag) async {
    var url = Uri.parse(
        "${ApiEndPoints.baseUrl}${ApiEndPoints.authEndPoints.logByTags}?tags=$tag");

    return await http.get(url, headers: loginHeaders);
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
  }

  Future<http.Response> storeReminder(
      String title, String description, String dateTime) async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.storeReminder);

    Map<String, dynamic> body = {
      "title": title,
      "description": description,
      "datetime": dateTime
    };

    return await http.post(url, body: body, headers: loginHeaders);
  }

  Future<http.Response> editReminder(
      String id, String title, String? description, String dateTime) async {
    print(dateTime);
    var url = Uri.parse(
        '${ApiEndPoints.baseUrl}${ApiEndPoints.authEndPoints.editReminder}/$id');

    Map<String, dynamic> body = {
      "title": title,
      "description": description,
      "datetime": dateTime,
    };

    return await http.patch(url, body: body, headers: loginHeaders);
  }

  Future<http.Response> deleteReminder(String id) async {
    var url = Uri.parse(
        '${ApiEndPoints.baseUrl}${ApiEndPoints.authEndPoints.deleteReminder}/$id');
    print(url);
    return await http.delete(url, headers: loginHeaders);
  }

  Future<http.Response> getAllReminder() async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.getAllReminder);

    return await http.get(url, headers: loginHeaders);
  }

  Future<http.Response> getPregnancyIndex() async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.getPregnancyIndex);

    return await http.get(url, headers: loginHeaders);
  }

  Future<http.Response> pregnancyBegin(
      String firstDayLastMenstruation, String? email_regis) async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.pregnancyBegin);

    Map<String, dynamic> body = {
      "hari_pertama_haid_terakhir": firstDayLastMenstruation,
      "email_regis": email_regis
    };

    return await http.post(url, body: body, headers: loginHeaders);
  }

  Future<http.Response> pregnancyEnded(
      int id, String pregnancyStatus, String pregnancyEndDate) async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.pregnancyEnded);

    Map<String, dynamic> body = {
      "pregnancy_id": id,
      "pregnancy_status": pregnancyStatus,
      "pregnancy_end": pregnancyEndDate,
    };

    return await http.post(url, body: body, headers: loginHeaders);
  }

  Future<http.Response> editPregnancyStartDate(
      int id, String firstDayLastMenstruation) async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.editPregnancy);

    Map<String, dynamic> body = {
      "pregnancy_id": id,
      "hari_pertama_haid_terakhir": firstDayLastMenstruation
    };

    return await http.post(url, body: body, headers: loginHeaders);
  }

  Future<http.Response> getWeightGainIndex() async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.getWeightGainIndex);

    return await http.get(url, headers: loginHeaders);
  }

  Future<http.Response> initializeWeightGain(
      double tinggiBadan, double beratBadan, int isTwin) async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.initializeWeightGain);

    Map<String, dynamic> body = {
      "tinggi_badan": tinggiBadan,
      "berat_badan": beratBadan,
      "is_twin": isTwin,
    };

    return await http.post(url, body: body, headers: loginHeaders);
  }

  Future<http.Response> weeklyWeightGain(
      double beratBadan, int mingguKehamilan, String dateRecord) async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.weeklyWeightGain);

    Map<String, dynamic> body = {
      "berat_badan": beratBadan,
      "minggu_kehamilan": mingguKehamilan,
      "tanggal_pencatatan": dateRecord,
    };

    return await http.post(url, body: body, headers: loginHeaders);
  }

  Future<http.Response> editWeeklyWeightGain(
      int id, double beratBadan, int mingguKehamilan, String dateRecord) async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.editWeeklyWeightGain);

    Map<String, dynamic> body = {
      "id": id,
      "berat_badan": beratBadan,
      "minggu_kehamilan": mingguKehamilan,
      "tanggal_pencatatan": dateRecord,
    };

    return await http.patch(url, body: body, headers: loginHeaders);
  }

  Future<http.Response> deleteWeeklyWeightGain(int id) async {
    var url = Uri.parse(ApiEndPoints.baseUrl +
        ApiEndPoints.authEndPoints.deleteWeeklyWeightGain);

    Map<dynamic, dynamic> body = {
      "id": id.toString(),
    };

    return await http.delete(url, body: body, headers: loginHeaders);
  }

  Future<http.Response> storeComment(
      int? parentId, int articleId, String content) async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.storeComment);

    Map<String, dynamic> body = {
      "article_id": articleId.toString(),
      "content": content,
    };

    if (parentId != null) {
      body["parent_id"] = parentId.toString();
    }

    return await http.post(url, body: body, headers: loginHeaders);
  }

  Future<http.Response> likeComment(int userId, int commentId) async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.likeComment);

    Map<String, dynamic> body = {
      "user_id": userId.toString(),
      "comment_id": commentId.toString()
    };

    return await http.post(url, body: body, headers: loginHeaders);
  }

  Future<http.Response> deleteComment(int id) async {
    var url = Uri.parse(
        '${ApiEndPoints.baseUrl}${ApiEndPoints.authEndPoints.deleteComment}/$id');
    return await http.delete(url, headers: loginHeaders);
  }
}
