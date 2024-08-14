import 'package:periodnpregnancycalender/app/models/period_cycle_model.dart';

class Event {
  String? specifiedDate;
  String? event;
  String? isActual;
  int? eventId;
  int? cycleDay;
  String? pregnancyChances;
  String? nextMenstruationStart;
  String? nextMenstruationEnd;
  int? daysUntilNextMenstruation;
  String? nextOvulation;
  int? daysUntilNextOvulation;
  String? nextFollicularStart;
  String? nextFollicularEnd;
  int? daysUntilNextFollicular;
  String? nextFertileStart;
  String? nextFertileEnd;
  int? daysUntilNextFertile;
  String? nextLutealStart;
  String? nextLutealEnd;
  int? daysUntilNextLuteal;
  ChineseGenderPrediction? chineseGenderPrediction;
  ShettlesGenderPrediction? shettlesGenderPrediction;

  Event(
      {this.specifiedDate,
      this.event,
      this.isActual,
      this.eventId,
      this.cycleDay,
      this.pregnancyChances,
      this.nextMenstruationStart,
      this.nextMenstruationEnd,
      this.daysUntilNextMenstruation,
      this.nextOvulation,
      this.daysUntilNextOvulation,
      this.nextFollicularStart,
      this.nextFollicularEnd,
      this.daysUntilNextFollicular,
      this.nextFertileStart,
      this.nextFertileEnd,
      this.daysUntilNextFertile,
      this.nextLutealStart,
      this.nextLutealEnd,
      this.daysUntilNextLuteal,
      this.chineseGenderPrediction,
      this.shettlesGenderPrediction});

  Event.fromJson(Map<String, dynamic> json) {
    specifiedDate = json['specifiedDate'];
    event = json['event'];
    isActual = json['is_actual'];
    eventId = json['event_id'];
    cycleDay = json['cycle_day'];
    pregnancyChances = json['pregnancy_chances'];
    nextMenstruationStart = json['nextMenstruationStart'];
    nextMenstruationEnd = json['nextMenstruationEnd'];
    daysUntilNextMenstruation = json['daysUntilNextMenstruation'];
    nextOvulation = json['nextOvulation'];
    daysUntilNextOvulation = json['daysUntilNextOvulation'];
    nextFollicularStart = json['nextFollicularStart'];
    nextFollicularEnd = json['nextFollicularEnd'];
    daysUntilNextFollicular = json['daysUntilNextFollicular'];
    nextFertileStart = json['nextFertileStart'];
    nextFertileEnd = json['nextFertileEnd'];
    daysUntilNextFertile = json['daysUntilNextFertile'];
    nextLutealStart = json['nextLutealStart'];
    nextLutealEnd = json['nextLutealEnd'];
    daysUntilNextLuteal = json['daysUntilNextLuteal'];
    chineseGenderPrediction = json['chineseGenderPrediction'] != null ? new ChineseGenderPrediction.fromJson(json['chineseGenderPrediction']) : null;
    shettlesGenderPrediction:
    json['shettlesGenderPrediction'] != null ? ShettlesGenderPrediction.fromJson(json['shettlesGenderPrediction']) : null;
  }
}

class ChineseGenderPrediction {
  int? age;
  int? lunarAge;
  String? dateOfBirth;
  String? lunarDateOfBirth;
  String? specifiedDate;
  String? lunarSpecifiedDate;
  String? genderPrediction;

  ChineseGenderPrediction({this.age, this.lunarAge, this.dateOfBirth, this.lunarDateOfBirth, this.specifiedDate, this.lunarSpecifiedDate, this.genderPrediction});

  ChineseGenderPrediction.fromJson(Map<String, dynamic> json) {
    age = json['age'];
    lunarAge = json['lunarAge'];
    dateOfBirth = json['dateOfBirth'];
    lunarDateOfBirth = json['lunarDateOfBirth'];
    specifiedDate = json['specifiedDate'];
    lunarSpecifiedDate = json['lunarSpecifiedDate'];
    genderPrediction = json['genderPrediction'];
  }
}