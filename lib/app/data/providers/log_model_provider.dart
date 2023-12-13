import 'package:get/get.dart';

import '../models/log_model_model.dart';

class LogModelProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return LogModel.fromJson(map);
      if (map is List)
        return map.map((item) => LogModel.fromJson(item)).toList();
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<LogModel?> getLogModel(int id) async {
    final response = await get('logmodel/$id');
    return response.body;
  }

  Future<Response<LogModel>> postLogModel(LogModel logmodel) async =>
      await post('logmodel', logmodel);
  Future<Response> deleteLogModel(int id) async => await delete('logmodel/$id');
}
