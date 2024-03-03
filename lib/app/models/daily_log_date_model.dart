class DailyLogDate {
  String? status;
  String? message;
  Data? data;

  DailyLogDate({this.status, this.message, this.data});

  DailyLogDate.fromJson(Map<String, dynamic> json) {
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
  String? date;
  Moods? moods;
  String? notes;
  Others? others;
  String? weight;
  Symptoms? symptoms;
  String? temperature;
  String? sexActivity;
  String? bleedingFlow;
  PhysicalActivity? physicalActivity;
  String? vaginalDischarge;

  Data(
      {this.date,
      this.moods,
      this.notes,
      this.others,
      this.weight,
      this.symptoms,
      this.temperature,
      this.sexActivity,
      this.bleedingFlow,
      this.physicalActivity,
      this.vaginalDischarge});

  Data.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    moods = json['moods'] != null ? new Moods.fromJson(json['moods']) : null;
    notes = json['notes'];
    others =
        json['others'] != null ? new Others.fromJson(json['others']) : null;
    weight = json['weight'];
    symptoms = json['symptoms'] != null
        ? new Symptoms.fromJson(json['symptoms'])
        : null;
    temperature = json['temperature'];
    sexActivity = json['sex_activity'];
    bleedingFlow = json['bleeding_flow'];
    physicalActivity = json['physical_activity'] != null
        ? new PhysicalActivity.fromJson(json['physical_activity'])
        : null;
    vaginalDischarge = json['vaginal_discharge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    if (this.moods != null) {
      data['moods'] = this.moods!.toJson();
    }
    data['notes'] = this.notes;
    if (this.others != null) {
      data['others'] = this.others!.toJson();
    }
    data['weight'] = this.weight;
    if (this.symptoms != null) {
      data['symptoms'] = this.symptoms!.toJson();
    }
    data['temperature'] = this.temperature;
    data['sex_activity'] = this.sexActivity;
    data['bleeding_flow'] = this.bleedingFlow;
    if (this.physicalActivity != null) {
      data['physical_activity'] = this.physicalActivity!.toJson();
    }
    data['vaginal_discharge'] = this.vaginalDischarge;
    return data;
  }
}

class Moods {
  bool? sad;
  bool? calm;
  bool? angry;
  bool? happy;
  bool? tired;
  bool? cranky;
  bool? frisky;
  bool? sleepy;
  bool? anxious;
  bool? excited;
  bool? confused;
  bool? apathetic;
  bool? depressed;
  bool? emotional;
  bool? energetic;
  bool? irritated;
  bool? sensitive;
  bool? unfocused;
  bool? frustrated;
  bool? lowEnergy;
  bool? moodSwings;
  bool? feelingGuilty;
  bool? obsessiveThoughts;
  bool? verySelfCritical;

  Moods(
      {this.sad,
      this.calm,
      this.angry,
      this.happy,
      this.tired,
      this.cranky,
      this.frisky,
      this.sleepy,
      this.anxious,
      this.excited,
      this.confused,
      this.apathetic,
      this.depressed,
      this.emotional,
      this.energetic,
      this.irritated,
      this.sensitive,
      this.unfocused,
      this.frustrated,
      this.lowEnergy,
      this.moodSwings,
      this.feelingGuilty,
      this.obsessiveThoughts,
      this.verySelfCritical});

  Moods.fromJson(Map<String, dynamic> json) {
    sad = json['Sad'];
    calm = json['Calm'];
    angry = json['Angry'];
    happy = json['Happy'];
    tired = json['Tired'];
    cranky = json['Cranky'];
    frisky = json['Frisky'];
    sleepy = json['Sleepy'];
    anxious = json['Anxious'];
    excited = json['Excited'];
    confused = json['Confused'];
    apathetic = json['Apathetic'];
    depressed = json['Depressed'];
    emotional = json['Emotional'];
    energetic = json['Energetic'];
    irritated = json['Irritated'];
    sensitive = json['Sensitive'];
    unfocused = json['Unfocused'];
    frustrated = json['Frustrated'];
    lowEnergy = json['Low energy'];
    moodSwings = json['Mood swings'];
    feelingGuilty = json['Feeling guilty'];
    obsessiveThoughts = json['Obsessive thoughts'];
    verySelfCritical = json['Very self-critical'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Sad'] = this.sad;
    data['Calm'] = this.calm;
    data['Angry'] = this.angry;
    data['Happy'] = this.happy;
    data['Tired'] = this.tired;
    data['Cranky'] = this.cranky;
    data['Frisky'] = this.frisky;
    data['Sleepy'] = this.sleepy;
    data['Anxious'] = this.anxious;
    data['Excited'] = this.excited;
    data['Confused'] = this.confused;
    data['Apathetic'] = this.apathetic;
    data['Depressed'] = this.depressed;
    data['Emotional'] = this.emotional;
    data['Energetic'] = this.energetic;
    data['Irritated'] = this.irritated;
    data['Sensitive'] = this.sensitive;
    data['Unfocused'] = this.unfocused;
    data['Frustrated'] = this.frustrated;
    data['Low energy'] = this.lowEnergy;
    data['Mood swings'] = this.moodSwings;
    data['Feeling guilty'] = this.feelingGuilty;
    data['Obsessive thoughts'] = this.obsessiveThoughts;
    data['Very self-critical'] = this.verySelfCritical;
    return data;
  }
}

class Others {
  bool? stress;
  bool? travel;
  bool? alcohol;
  bool? diseaseOrInjury;

  Others({this.stress, this.travel, this.alcohol, this.diseaseOrInjury});

  Others.fromJson(Map<String, dynamic> json) {
    stress = json['Stress'];
    travel = json['Travel'];
    alcohol = json['Alcohol'];
    diseaseOrInjury = json['Disease or Injury'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Stress'] = this.stress;
    data['Travel'] = this.travel;
    data['Alcohol'] = this.alcohol;
    data['Disease or Injury'] = this.diseaseOrInjury;
    return data;
  }
}

class Symptoms {
  bool? gas;
  bool? pMS;
  bool? acne;
  bool? chills;
  bool? cramps;
  bool? nausea;
  bool? fatigue;
  bool? backache;
  bool? bloating;
  bool? cravings;
  bool? diarrhea;
  bool? headache;
  bool? insomnia;
  bool? spotting;
  bool? swelling;
  bool? dizziness;
  bool? feelGood;
  bool? bodyAches;
  bool? hotFlashes;
  bool? constipation;
  bool? lowBackPain;
  bool? nippleChanges;
  bool? tenderBreasts;
  bool? abdominalCramps;

  Symptoms(
      {this.gas,
      this.pMS,
      this.acne,
      this.chills,
      this.cramps,
      this.nausea,
      this.fatigue,
      this.backache,
      this.bloating,
      this.cravings,
      this.diarrhea,
      this.headache,
      this.insomnia,
      this.spotting,
      this.swelling,
      this.dizziness,
      this.feelGood,
      this.bodyAches,
      this.hotFlashes,
      this.constipation,
      this.lowBackPain,
      this.nippleChanges,
      this.tenderBreasts,
      this.abdominalCramps});

  Symptoms.fromJson(Map<String, dynamic> json) {
    gas = json['Gas'];
    pMS = json['PMS'];
    acne = json['Acne'];
    chills = json['Chills'];
    cramps = json['Cramps'];
    nausea = json['Nausea'];
    fatigue = json['Fatigue'];
    backache = json['Backache'];
    bloating = json['Bloating'];
    cravings = json['Cravings'];
    diarrhea = json['Diarrhea'];
    headache = json['Headache'];
    insomnia = json['Insomnia'];
    spotting = json['Spotting'];
    swelling = json['Swelling'];
    dizziness = json['Dizziness'];
    feelGood = json['Feel good'];
    bodyAches = json['Body aches'];
    hotFlashes = json['Hot flashes'];
    constipation = json['Constipation'];
    lowBackPain = json['Low back pain'];
    nippleChanges = json['Nipple changes'];
    tenderBreasts = json['Tender breasts'];
    abdominalCramps = json['Abdominal cramps'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Gas'] = this.gas;
    data['PMS'] = this.pMS;
    data['Acne'] = this.acne;
    data['Chills'] = this.chills;
    data['Cramps'] = this.cramps;
    data['Nausea'] = this.nausea;
    data['Fatigue'] = this.fatigue;
    data['Backache'] = this.backache;
    data['Bloating'] = this.bloating;
    data['Cravings'] = this.cravings;
    data['Diarrhea'] = this.diarrhea;
    data['Headache'] = this.headache;
    data['Insomnia'] = this.insomnia;
    data['Spotting'] = this.spotting;
    data['Swelling'] = this.swelling;
    data['Dizziness'] = this.dizziness;
    data['Feel good'] = this.feelGood;
    data['Body aches'] = this.bodyAches;
    data['Hot flashes'] = this.hotFlashes;
    data['Constipation'] = this.constipation;
    data['Low back pain'] = this.lowBackPain;
    data['Nipple changes'] = this.nippleChanges;
    data['Tender breasts'] = this.tenderBreasts;
    data['Abdominal cramps'] = this.abdominalCramps;
    return data;
  }
}

class PhysicalActivity {
  bool? gym;
  bool? yoga;
  bool? cycling;
  bool? running;
  bool? walking;
  bool? swimming;
  bool? teamSports;
  bool? didnTExercise;
  bool? aerobicsDancing;

  PhysicalActivity(
      {this.gym,
      this.yoga,
      this.cycling,
      this.running,
      this.walking,
      this.swimming,
      this.teamSports,
      this.didnTExercise,
      this.aerobicsDancing});

  PhysicalActivity.fromJson(Map<String, dynamic> json) {
    gym = json['Gym'];
    yoga = json['Yoga'];
    cycling = json['Cycling'];
    running = json['Running'];
    walking = json['Walking'];
    swimming = json['Swimming'];
    teamSports = json['Team sports'];
    didnTExercise = json["Didn't exercise"];
    aerobicsDancing = json['Aerobics & Dancing'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Gym'] = this.gym;
    data['Yoga'] = this.yoga;
    data['Cycling'] = this.cycling;
    data['Running'] = this.running;
    data['Walking'] = this.walking;
    data['Swimming'] = this.swimming;
    data['Team sports'] = this.teamSports;
    data["Didn't exercise"] = this.didnTExercise;
    data['Aerobics & Dancing'] = this.aerobicsDancing;
    return data;
  }
}
