import 'dart:async';
import 'package:periodnpregnancycalender/app/services/api_service.dart';

class CheckConnectivity {
  final ApiService apiService = ApiService();

  Future<bool> isConnectedToInternet() async {
    return await _hasInternetAccess();
  }

  Future<bool> _hasInternetAccess() async {
    try {
      final response = await apiService.checkAPIConnection().timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          print('Connection timed out after 3 seconds');
          throw TimeoutException('Connection timed out');
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
