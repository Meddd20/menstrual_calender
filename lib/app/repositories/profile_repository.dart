import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:periodnpregnancycalender/app/models/profile_model.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';

class ProfileRepository {
  final ApiService apiService;

  ProfileRepository(this.apiService);

  Future<Profile?> getProfile() async {
    try {
      http.Response response = await apiService.getProfile();

      if (response.statusCode == 200) {
        var decodedJson = json.decode(response.body);
        var profile = Profile.fromJson(decodedJson);
        return profile;
      } else {
        throw jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      }
    } catch (e) {
      print("Error: $e");
      throw "An error occurred during the request.";
    }
  }
}
