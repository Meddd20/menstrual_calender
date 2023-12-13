class LogModel {
  String? date;
  PregnancySigns? pregnancySigns;
  String? sexActivity;
  Symptoms? symptoms;
  String? vaginalDischarge;
  Moods? moods;
  Others? others;
  String? temperature;
  String? weight;
  Reminder? reminder;
  String? notes;

  LogModel(
      {this.date,
      this.pregnancySigns,
      this.sexActivity,
      this.symptoms,
      this.vaginalDischarge,
      this.moods,
      this.others,
      this.temperature,
      this.weight,
      this.reminder,
      this.notes});

  LogModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    pregnancySigns = json['pregnancy_signs'] != null
        ? PregnancySigns?.fromJson(json['pregnancy_signs'])
        : null;
    sexActivity = json['sex_activity'];
    symptoms =
        json['symptoms'] != null ? Symptoms?.fromJson(json['symptoms']) : null;
    vaginalDischarge = json['vaginal_discharge'];
    moods = json['moods'] != null ? Moods?.fromJson(json['moods']) : null;
    others = json['others'] != null ? Others?.fromJson(json['others']) : null;
    temperature = json['temperature'];
    weight = json['weight'];
    reminder =
        json['reminder'] != null ? Reminder?.fromJson(json['reminder']) : null;
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['date'] = date;
    if (pregnancySigns != null) {
      data['pregnancy_signs'] = pregnancySigns?.toJson();
    }
    data['sex_activity'] = sexActivity;
    if (symptoms != null) {
      data['symptoms'] = symptoms?.toJson();
    }
    data['vaginal_discharge'] = vaginalDischarge;
    if (moods != null) {
      data['moods'] = moods?.toJson();
    }
    if (others != null) {
      data['others'] = others?.toJson();
    }
    data['temperature'] = temperature;
    data['weight'] = weight;
    if (reminder != null) {
      data['reminder'] = reminder?.toJson();
    }
    data['notes'] = notes;
    return data;
  }
}

class PregnancySigns {
  bool? moodSwings;
  bool? nippleChanges;
  bool? fatigue;
  bool? cravings;
  bool? tenderBreasts;
  bool? foodAversions;
  bool? nausea;
  bool? bloating;
  bool? vomiting;
  bool? cramps;
  bool? frequentUrination;
  bool? dizziness;

  PregnancySigns(
      {this.moodSwings,
      this.nippleChanges,
      this.fatigue,
      this.cravings,
      this.tenderBreasts,
      this.foodAversions,
      this.nausea,
      this.bloating,
      this.vomiting,
      this.cramps,
      this.frequentUrination,
      this.dizziness});

  PregnancySigns.fromJson(Map<String, dynamic> json) {
    moodSwings = json['Mood swings'];
    nippleChanges = json['Nipple changes'];
    fatigue = json['Fatigue'];
    cravings = json['Cravings'];
    tenderBreasts = json['Tender breasts'];
    foodAversions = json['Food aversions'];
    nausea = json['Nausea'];
    bloating = json['Bloating'];
    vomiting = json['Vomiting'];
    cramps = json['Cramps'];
    frequentUrination = json['Frequent urination'];
    dizziness = json['Dizziness'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Mood swings'] = moodSwings;
    data['Nipple changes'] = nippleChanges;
    data['Fatigue'] = fatigue;
    data['Cravings'] = cravings;
    data['Tender breasts'] = tenderBreasts;
    data['Food aversions'] = foodAversions;
    data['Nausea'] = nausea;
    data['Bloating'] = bloating;
    data['Vomiting'] = vomiting;
    data['Cramps'] = cramps;
    data['Frequent urination'] = frequentUrination;
    data['Dizziness'] = dizziness;
    return data;
  }
}

class Symptoms {
  bool? imOkay;
  bool? headache;
  bool? swelling;
  bool? dizziness;
  bool? cramps;
  bool? acne;
  bool? insomnia;
  bool? tenderBreasts;
  bool? backache;
  bool? vaginalPain;
  bool? fatigue;
  bool? frequentUrination;
  bool? nippleChanges;

  Symptoms(
      {this.imOkay,
      this.headache,
      this.swelling,
      this.dizziness,
      this.cramps,
      this.acne,
      this.insomnia,
      this.tenderBreasts,
      this.backache,
      this.vaginalPain,
      this.fatigue,
      this.frequentUrination,
      this.nippleChanges});

  Symptoms.fromJson(Map<String, dynamic> json) {
    imOkay = json['Im okay'];
    headache = json['Headache'];
    swelling = json['Swelling'];
    dizziness = json['Dizziness'];
    cramps = json['Cramps'];
    acne = json['Acne'];
    insomnia = json['Insomnia'];
    tenderBreasts = json['Tender breasts'];
    backache = json['Backache'];
    vaginalPain = json['Vaginal pain'];
    fatigue = json['Fatigue'];
    frequentUrination = json['Frequent urination'];
    nippleChanges = json['Nipple changes'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Im okay'] = imOkay;
    data['Headache'] = headache;
    data['Swelling'] = swelling;
    data['Dizziness'] = dizziness;
    data['Cramps'] = cramps;
    data['Acne'] = acne;
    data['Insomnia'] = insomnia;
    data['Tender breasts'] = tenderBreasts;
    data['Backache'] = backache;
    data['Vaginal pain'] = vaginalPain;
    data['Fatigue'] = fatigue;
    data['Frequent urination'] = frequentUrination;
    data['Nipple changes'] = nippleChanges;
    return data;
  }
}

class Moods {
  bool? happy;
  bool? sensitive;
  bool? anxious;
  bool? moodSwings;
  bool? emotional;
  bool? irritated;
  bool? calm;
  bool? sad;
  bool? energetic;

  Moods(
      {this.happy,
      this.sensitive,
      this.anxious,
      this.moodSwings,
      this.emotional,
      this.irritated,
      this.calm,
      this.sad,
      this.energetic});

  Moods.fromJson(Map<String, dynamic> json) {
    happy = json['Happy'];
    sensitive = json['Sensitive'];
    anxious = json['Anxious'];
    moodSwings = json['Mood swings'];
    emotional = json['Emotional'];
    irritated = json['Irritated'];
    calm = json['Calm'];
    sad = json['Sad'];
    energetic = json['Energetic'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Happy'] = happy;
    data['Sensitive'] = sensitive;
    data['Anxious'] = anxious;
    data['Mood swings'] = moodSwings;
    data['Emotional'] = emotional;
    data['Irritated'] = irritated;
    data['Calm'] = calm;
    data['Sad'] = sad;
    data['Energetic'] = energetic;
    return data;
  }
}

class Others {
  bool? travel;
  bool? stress;
  bool? meditation;
  bool? diseaseOrInjury;
  bool? alcohol;
  bool? kegelExercise;

  Others(
      {this.travel,
      this.stress,
      this.meditation,
      this.diseaseOrInjury,
      this.alcohol,
      this.kegelExercise});

  Others.fromJson(Map<String, dynamic> json) {
    travel = json['Travel'];
    stress = json['Stress'];
    meditation = json['Meditation'];
    diseaseOrInjury = json['Disease or injury'];
    alcohol = json['Alcohol'];
    kegelExercise = json['Kegel exercise'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Travel'] = travel;
    data['Stress'] = stress;
    data['Meditation'] = meditation;
    data['Disease or injury'] = diseaseOrInjury;
    data['Alcohol'] = alcohol;
    data['Kegel exercise'] = kegelExercise;
    return data;
  }
}

class Reminder {
  String? datetime;
  String? notes;

  Reminder({this.datetime, this.notes});

  Reminder.fromJson(Map<String, dynamic> json) {
    datetime = json['datetime'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['datetime'] = datetime;
    data['notes'] = notes;
    return data;
  }
}
