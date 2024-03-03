class DateEvent {
  String? status;
  String? message;
  Data? data;

  DateEvent({this.status, this.message, this.data});

  DateEvent.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  String? specifiedDate;
  String? event;
  String? isActual;
  String? eventId;
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

  Data(
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
      this.daysUntilNextLuteal});

  Data.fromJson(Map<String, dynamic> json) {
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['specifiedDate'] = this.specifiedDate;
    data['event'] = this.event;
    data['is_actual'] = this.isActual;
    data['event_id'] = this.eventId;
    data['cycle_day'] = this.cycleDay;
    data['pregnancy_chances'] = this.pregnancyChances;
    data['nextMenstruationStart'] = this.nextMenstruationStart;
    data['nextMenstruationEnd'] = this.nextMenstruationEnd;
    data['daysUntilNextMenstruation'] = this.daysUntilNextMenstruation;
    data['nextOvulation'] = this.nextOvulation;
    data['daysUntilNextOvulation'] = this.daysUntilNextOvulation;
    data['nextFollicularStart'] = this.nextFollicularStart;
    data['nextFollicularEnd'] = this.nextFollicularEnd;
    data['daysUntilNextFollicular'] = this.daysUntilNextFollicular;
    data['nextFertileStart'] = this.nextFertileStart;
    data['nextFertileEnd'] = this.nextFertileEnd;
    data['daysUntilNextFertile'] = this.daysUntilNextFertile;
    data['nextLutealStart'] = this.nextLutealStart;
    data['nextLutealEnd'] = this.nextLutealEnd;
    data['daysUntilNextLuteal'] = this.daysUntilNextLuteal;
    return data;
  }
}
