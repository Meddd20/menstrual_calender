import 'package:periodnpregnancycalender/app/models/daily_log_date_model.dart';
import 'package:periodnpregnancycalender/app/models/master_data_version_model.dart';
import 'package:periodnpregnancycalender/app/models/period_cycle_model.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_daily_log_model.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_model.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_weight_gain.dart';
import 'package:periodnpregnancycalender/app/models/profile_model.dart';
import 'package:periodnpregnancycalender/app/models/reminder_model.dart';

class DataCategoryByTable {
  User? user;
  List<PeriodHistory>? periodHistory;
  PregnancyHistory? pregnancyHistory;
  DailyLogss? logHistory;
  PregnancyDailyLog? pregnancyDailyLog;
  List<WeightHistory>? weightGainHistory;
  List<MasterDataVersion>? masterDataVersion;

  DataCategoryByTable({
    this.user,
    this.periodHistory,
    this.pregnancyHistory,
    this.logHistory,
    this.pregnancyDailyLog,
    this.weightGainHistory,
    this.masterDataVersion,
  });

  factory DataCategoryByTable.fromJson(Map<String, dynamic> json) {
    return DataCategoryByTable(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      periodHistory: json['period_history'] != null ? List<PeriodHistory>.from(json['period_history'].map((x) => PeriodHistory.fromJson(x))) : null,
      pregnancyHistory: json['pregnancy_history'] != null ? PregnancyHistory.fromJson(json['pregnancy_history']) : null,
      logHistory: json['log_history'] != null ? DailyLogss.fromJson(json['log_history']) : null,
      pregnancyDailyLog: json['pregnancy_log_history'] != null ? PregnancyDailyLog.fromJson(json['pregnancy_log_history']) : null,
      weightGainHistory: json['weight_gain_history'] != null ? List<WeightHistory>.from(json['weight_gain_history'].map((x) => WeightHistory.fromJson(x))) : null,
      masterDataVersion: json['master_data_version'] != null ? List<MasterDataVersion>.from(json['master_data_version'].map((x) => MasterDataVersion.fromJson(x))) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.periodHistory != null) {
      data['period_history'] = this.periodHistory!.map((v) => v.toJson()).toList();
    }
    if (this.pregnancyHistory != null) {
      data['pregnancy_history'] = this.pregnancyHistory!.toJson();
    }
    if (this.logHistory != null) {
      data['log_history'] = this.logHistory!.toJson();
    }
    if (this.pregnancyDailyLog != null) {
      data['pregnancy_log_history'] = this.pregnancyDailyLog!.toJson();
    }
    if (this.weightGainHistory != null) {
      data['weight_gain_history'] = this.weightGainHistory!.map((v) => v.toJson()).toList();
    }
    if (this.masterDataVersion != null) {
      data['master_data_version'] = this.masterDataVersion!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DailyLogss {
  int? id;
  int? userId;
  Map<String, DataHarian>? dataHarian;
  List<Reminders>? pengingat;
  String? createdAt;
  String? updatedAt;

  DailyLogss({
    this.id,
    this.userId,
    this.dataHarian,
    this.pengingat,
    this.createdAt,
    this.updatedAt,
  });

  DailyLogss.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    if (json['data_harian'] != null) {
      dataHarian = {};
      json['data_harian'].forEach((key, value) {
        dataHarian![key] = DataHarian.fromJson(value);
      });
    }
    if (json['pengingat'] != null) {
      pengingat = [];
      (json['pengingat'] as List).forEach((v) {
        pengingat!.add(Reminders.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['user_id'] = userId;
    if (dataHarian != null) {
      data['data_harian'] = Map.fromIterable(dataHarian!.keys, key: (key) => key, value: (key) => dataHarian![key]!.toJson());
    }
    if (pengingat != null) {
      data['pengingat'] = pengingat!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
