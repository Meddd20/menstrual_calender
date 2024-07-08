import 'dart:convert';

import 'package:periodnpregnancycalender/app/models/daily_log_date_model.dart';
import 'package:periodnpregnancycalender/app/models/reminder_model.dart';

class DailyLog {
  int? id;
  int? userId;
  List<DataHarian>? dataHarian;
  List<Reminders>? pengingat;
  String? createdAt;
  String? updatedAt;

  DailyLog({
    this.id,
    this.userId,
    this.dataHarian,
    this.pengingat,
    this.createdAt,
    this.updatedAt,
  });

  DailyLog.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    if (json['data_harian'] != null) {
      dataHarian = [];
      jsonDecode(json['data_harian']).forEach((v) {
        dataHarian!.add(DataHarian.fromJson(v));
      });
    }
    if (json['pengingat'] != null) {
      pengingat = [];
      jsonDecode(json['pengingat']).forEach((v) {
        pengingat!.add(Reminders.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    if (dataHarian != null) {
      data['data_harian'] =
          jsonEncode(dataHarian!.map((v) => v.toJson()).toList());
    }
    if (pengingat != null) {
      data['pengingat'] =
          jsonEncode(pengingat!.map((v) => v.toJson()).toList());
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }

  DailyLog copyWith({
    int? id,
    int? userId,
    List<DataHarian>? dataHarian,
    List<Reminders>? pengingat,
    String? createdAt,
    String? updatedAt,
  }) {
    return DailyLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      dataHarian: dataHarian ?? this.dataHarian,
      pengingat: pengingat ?? this.pengingat,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
