import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:periodnpregnancycalender/app/utils/api_endpoints.dart';
import 'package:periodnpregnancycalender/app/utils/helpers.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';

class ApiService {
  final box = GetStorage();
  final storageService = StorageService();
  late Map<String, String> loginHeaders = {};

  Map<String, String> generalHeaders = {
    "token": dotenv.env["API_TOKEN"] ?? "",
    "Accept": "application/json",
  };

  ApiService() {
    _initializeAuthHeaders();
  }

  void _initializeAuthHeaders() {
    if (storageService.getCredentialToken() != null) {
      loginHeaders = {
        "token": dotenv.env["API_TOKEN"] ?? "",
        "Accept": "application/json",
        "user_id": storageService.getCredentialToken() ?? "",
      };
    }
  }

  Future<http.Response> getSycDataApi() async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.getSycData);
    return await http.get(url, headers: loginHeaders);
  }

  Future<http.Response> getSycMasterDataApi() async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.getSycMasterData);
    return await http.get(url, headers: loginHeaders);
  }

  Future<http.Response> storeFcmToken(String fcmToken, int userId) async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.storeFcmToken);
    Map<String, String> body = {
      "fcm_token": fcmToken,
      "user_id": userId.toString(),
    };

    return await http.post(url, body: body, headers: loginHeaders);
  }

  Future<http.Response> login(String email, String password) async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.login);
    Map<String, String> body = {"email": email, "password": password};
    print(generalHeaders);

    return await http.post(url, body: body, headers: generalHeaders);
  }

  Future<http.Response> register(String name, DateTime birthday, String email, String password) async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.regisUser);

    String formattedBirthday = formatDate(birthday);
    Map<String, dynamic> body = {"name": name, "birthday": formattedBirthday, "email": email, "password": password};

    return await http.post(url, body: body, headers: generalHeaders);
  }

  Future<http.Response> requestVerificationCode(String email, String type) async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.requestVerification);
    Map<String, String> body = {"email": email, "type": type};

    return await http.post(url, body: body, headers: generalHeaders);
  }

  Future<http.Response> validateCodeVerif(String email, String codeVerif, String type, String role) async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.verifyCode);
    Map<String, String> body = {"email": email, "verif_code": codeVerif, "type": type, "user_role": role};

    return await http.post(url, body: body, headers: generalHeaders);
  }

  Future<http.Response> resetPassword(String email, String newPassword, String confirmNewPassword) async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.resetPassword);
    Map<String, String> body = {
      "email": email,
      "new_password": newPassword,
      "new_password_confirmation": confirmNewPassword,
    };

    return await http.post(url, body: body, headers: generalHeaders);
  }

  Future<http.Response> logout() async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.logOut);

    return await http.post(url, headers: loginHeaders);
  }

  Future<http.Response> checkToken() async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.checkToken);

    return await http.post(url, headers: loginHeaders);
  }

  Future<http.Response> editProfile(String nama, String tanggalLahir) async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.editProfile);

    Map<String, dynamic> body = {"name": nama, "birthday": tanggalLahir};

    return await http.patch(url, body: body, headers: loginHeaders);
  }

  Future<http.Response> deleteData() async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.deleteData);
    print(url);
    print(loginHeaders);
    return await http.delete(url, headers: loginHeaders);
  }

  Future<http.Response> getAllArticle(String? tags) async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.getAllArticle);

    if (tags != null) {
      url = Uri.parse("$url?tags=$tags");
    }

    return await http.get(url, headers: generalHeaders);
  }

  Future<http.Response> getArticle(int id) async {
    var url = Uri.parse('${ApiEndPoints.apiUrl}${ApiEndPoints.authEndPoints.getArticle}/$id');

    return await http.get(url, headers: generalHeaders);
  }

  Future<http.Response> storePeriod(List<Map<String, dynamic>> periods, int? periodCycle, String? email_regis) async {
    late Uri url;
    late Map<String, String> headers;

    if (email_regis != null) {
      url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.storePeriod + "?email_regis=$email_regis");
      headers = generalHeaders;
    } else {
      url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.storePeriod);
      headers = loginHeaders;
    }
    var request = http.MultipartRequest('POST', url)..headers.addAll(headers);

    if (periodCycle != null) {
      request.fields['period_cycle'] = periodCycle.toString();
    }

    for (int i = 0; i < periods.length; i++) {
      final firstPeriod = periods[i]['first_period'];
      final lastPeriod = periods[i]['last_period'];
      if (firstPeriod != null && lastPeriod != null) {
        request.fields['periods[$i][first_period]'] = firstPeriod;
        request.fields['periods[$i][last_period]'] = lastPeriod;
      } else {
        throw Exception('Data tidak lengkap');
      }
    }

    var response = await request.send();
    return http.Response.fromStream(response);
  }

  Future<http.Response> updatePeriod(int periodId, String firstPeriod, String lastPeriod, int? periodCycle) async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.updatePeriod);
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

  Future<http.Response> storeLog(String date, String? sexActivity, String? bleedingFlow, Map<String, dynamic> symptoms, String? vaginalDischarge, Map<String, dynamic> moods, Map<String, dynamic> others, Map<String, dynamic> physicalActivity, String? temperature, String? weight, String? notes) async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.storeLog);

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

  Future<http.Response> deleteLog(String date) async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.deleteLog);

    Map<String, dynamic> body = {
      "date": date,
    };

    return await http.delete(url, body: body, headers: loginHeaders);
  }

  Future<http.Response> storeReminder(String id, String title, String description, String dateTime) async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.storeReminder);

    Map<String, dynamic> body = {"id": id, "title": title, "description": description, "datetime": dateTime};

    return await http.post(url, body: body, headers: loginHeaders);
  }

  Future<http.Response> editReminder(String id, String title, String? description, String dateTime) async {
    var url = Uri.parse('${ApiEndPoints.apiUrl}${ApiEndPoints.authEndPoints.editReminder}/$id');

    Map<String, dynamic> body = {
      "title": title,
      "description": description,
      "datetime": dateTime,
    };

    return await http.patch(url, body: body, headers: loginHeaders);
  }

  Future<http.Response> deleteReminder(String id) async {
    var url = Uri.parse('${ApiEndPoints.apiUrl}${ApiEndPoints.authEndPoints.deleteReminder}/$id');
    return await http.delete(url, headers: loginHeaders);
  }

  Future<http.Response> pregnancyBegin(String firstDayLastMenstruation, String? email_regis) async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.pregnancyBegin);

    Map<String, dynamic> body = {
      "hari_pertama_haid_terakhir": firstDayLastMenstruation,
    };

    if (email_regis != null) {
      body["email_regis"] = email_regis;
    }

    return await http.post(url, body: body, headers: loginHeaders);
  }

  Future<http.Response> pregnancyEnded(String pregnancyEndDate, String gender) async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.pregnancyEnded);

    Map<String, dynamic> body = {
      "pregnancy_end": pregnancyEndDate,
      "gender": gender,
    };

    print(body);

    return await http.post(url, body: body, headers: loginHeaders);
  }

  Future<http.Response> deletePregnancy() async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.deletePregnancy);

    return await http.post(url, headers: loginHeaders);
  }

  Future<http.Response> initializeWeightGain(double tinggiBadan, double beratBadan, int isTwin) async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.initializeWeightGain);

    Map<String, dynamic> body = {
      "tinggi_badan": tinggiBadan.toString(),
      "berat_badan": beratBadan.toString(),
      "is_twin": isTwin.toString(),
    };

    return await http.post(url, body: body, headers: loginHeaders);
  }

  Future<http.Response> weeklyWeightGain(double beratBadan, int mingguKehamilan, String dateRecord) async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.weeklyWeightGain);

    Map<String, dynamic> body = {
      "berat_badan": beratBadan.toString(),
      "minggu_kehamilan": mingguKehamilan.toString(),
      "tanggal_pencatatan": dateRecord,
    };

    return await http.post(url, body: body, headers: loginHeaders);
  }

  Future<http.Response> deleteWeeklyWeightGain(String dateRecord) async {
    var url = Uri.parse('${ApiEndPoints.apiUrl}${ApiEndPoints.authEndPoints.deleteWeeklyWeightGain}');

    Map<String, dynamic> body = {
      "tanggal_pencatatan": dateRecord,
    };

    return await http.delete(url, body: body, headers: loginHeaders);
  }

  Future<http.Response> storeComment(int? parentId, int articleId, String content) async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.storeComment);

    Map<String, dynamic> body = {
      "article_id": articleId.toString(),
      "content": content,
    };

    if (parentId != null) {
      body["parent_id"] = parentId.toString();
    }

    return await http.post(url, body: body, headers: loginHeaders);
  }

  Future<http.Response> likeComment(int commentId) async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.likeComment);

    Map<String, dynamic> body = {"comment_id": commentId.toString()};

    return await http.post(url, body: body, headers: loginHeaders);
  }

  Future<http.Response> deleteComment(int id) async {
    var url = Uri.parse('${ApiEndPoints.apiUrl}${ApiEndPoints.authEndPoints.deleteComment}/$id');
    return await http.delete(url, headers: loginHeaders);
  }

  Future<http.Response> getMasterDataFood() async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.getMasterDataFood);

    return await http.get(url, headers: generalHeaders);
  }

  Future<http.Response> getMasterDataPregnancy() async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.getMasterDataPregnancy);

    return await http.get(url, headers: generalHeaders);
  }

  Future<http.Response> getMasterDataVaccines() async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.getMasterDataVaccines);

    return await http.get(url, headers: generalHeaders);
  }

  Future<http.Response> getMasterDataVitamins() async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.getMasterDataVitamins);

    return await http.get(url, headers: generalHeaders);
  }

  Future<http.Response> storePregnancyLog(String date, Map<String, dynamic> pregnancySymptoms, String? temperature, String? notes) async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.addPregnancyLog);

    Map<String, dynamic> body = {
      "date": date,
      "pregnancy_symptoms": jsonEncode(pregnancySymptoms),
      "temperature": temperature,
      "notes": notes,
    };

    return await http.patch(url, body: body, headers: loginHeaders);
  }

  Future<http.Response> deletePregnancyLog(String date) async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.deletePregnancyLog);

    Map<String, dynamic> body = {
      "date": date,
    };

    return await http.delete(url, body: body, headers: loginHeaders);
  }

  Future<http.Response> addBloodPressure(String id, String tekananSistolik, String tekananDiastolik, String detakJantung, String datetime) async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.addBloodPressure);

    Map<String, dynamic> body = {
      "id": id,
      "tekanan_sistolik": tekananSistolik,
      "tekanan_diastolik": tekananDiastolik,
      "detak_jantung": detakJantung,
      "datetime": datetime,
    };

    return await http.post(url, body: body, headers: loginHeaders);
  }

  Future<http.Response> editBloodPressure(String id, String tekananSistolik, String tekananDiastolik, String detakJantung, String datetime) async {
    var url = Uri.parse('${ApiEndPoints.apiUrl}${ApiEndPoints.authEndPoints.editBloodPressure}/$id');

    Map<String, dynamic> body = {
      "tekanan_sistolik": tekananSistolik,
      "tekanan_diastolik": tekananDiastolik,
      "detak_jantung": detakJantung,
      "datetime": datetime,
    };

    return await http.patch(url, body: body, headers: loginHeaders);
  }

  Future<http.Response> deleteBloodPressure(String id) async {
    var url = Uri.parse('${ApiEndPoints.apiUrl}${ApiEndPoints.authEndPoints.deleteBloodPressure}/$id');

    return await http.delete(url, headers: loginHeaders);
  }

  Future<http.Response> addContractionTimer(String id, String startDate, String duration) async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.addContractionTimer);

    Map<String, dynamic> body = {
      "id": id,
      "waktu_mulai": startDate,
      "durasi": duration,
    };

    return await http.post(url, body: body, headers: loginHeaders);
  }

  Future<http.Response> deleteContractionTimer(String id) async {
    var url = Uri.parse('${ApiEndPoints.apiUrl}${ApiEndPoints.authEndPoints.deleteContractionTimer}/$id');

    return await http.delete(url, headers: loginHeaders);
  }

  Future<http.Response> addKickCounter(String id, String datetime) async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.addKickCounter);

    Map<String, dynamic> body = {
      "id": id,
      "datetime": datetime,
    };

    return await http.post(url, body: body, headers: loginHeaders);
  }

  Future<http.Response> addKickCounterData(String id, String startDate, String endDate, String totalKicks) async {
    var url = Uri.parse(ApiEndPoints.apiUrl + ApiEndPoints.authEndPoints.addKickCounterData);

    Map<String, dynamic> body = {
      "id": id,
      "waktu_mulai": startDate,
      "waktu_selesai": endDate,
      "jumlah_gerakan": totalKicks,
    };

    return await http.post(url, body: body, headers: loginHeaders);
  }

  Future<http.Response> deleteKickCounter(String id) async {
    var url = Uri.parse('${ApiEndPoints.apiUrl}${ApiEndPoints.authEndPoints.deleteKickCounter}/$id');

    return await http.delete(url, headers: loginHeaders);
  }
}
