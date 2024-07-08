import 'package:periodnpregnancycalender/app/models/daily_log_model.dart';
import 'package:periodnpregnancycalender/app/models/period_cycle_model.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_model.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_weight_gain.dart';
import 'package:periodnpregnancycalender/app/models/profile_model.dart';

class SyncData {
  String? status;
  String? message;
  DataCategoryByTable? data;

  SyncData({this.status, this.message, this.data});

  SyncData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new DataCategoryByTable.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DataCategoryByTable {
  User? user;
  List<PeriodHistory>? periodHistory;
  List<PregnancyHistory>? pregnancyHistory;
  DailyLog? logHistory;
  List<WeightHistory>? weightGainHistory;

  DataCategoryByTable({this.user, this.periodHistory, this.pregnancyHistory, this.logHistory, this.weightGainHistory});

  factory DataCategoryByTable.fromJson(Map<String, dynamic> json) {
    return DataCategoryByTable(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      periodHistory: json['period_history'] != null ? List<PeriodHistory>.from(json['period_history'].map((x) => PeriodHistory.fromJson(x))) : null,
      pregnancyHistory: json['pregnancy_history'] != null ? List<PregnancyHistory>.from(json['pregnancy_history'].map((x) => PregnancyHistory.fromJson(x))) : null,
      logHistory: json['log_history'] != null ? DailyLog.fromJson(json['log_history']) : null,
      weightGainHistory: json['weight_gain_history'] != null ? List<WeightHistory>.from(json['weight_gain_history'].map((x) => WeightHistory.fromJson(x))) : null,
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
      data['pregnancy_history'] = this.pregnancyHistory!.map((v) => v.toJson()).toList();
    }
    if (this.logHistory != null) {
      data['log_history'] = this.logHistory!.toJson();
    }
    if (this.weightGainHistory != null) {
      data['weight_gain_history'] = this.weightGainHistory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
