class DataHarian {
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

  DataHarian({
    this.date,
    this.moods,
    this.notes,
    this.others,
    this.weight,
    this.symptoms,
    this.temperature,
    this.sexActivity,
    this.bleedingFlow,
    this.physicalActivity,
    this.vaginalDischarge,
  });

  DataHarian.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    moods = json['moods'] != null ? Moods.fromJson(json['moods']) : null;
    notes = json['notes'];
    others = json['others'] != null ? Others.fromJson(json['others']) : null;
    weight = json['weight'];
    symptoms = json['symptoms'] != null ? Symptoms.fromJson(json['symptoms']) : null;
    temperature = json['temperature'];
    sexActivity = json['sex_activity'];
    bleedingFlow = json['bleeding_flow'];
    physicalActivity = json['physical_activity'] != null ? PhysicalActivity.fromJson(json['physical_activity']) : null;
    vaginalDischarge = json['vaginal_discharge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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

  DataHarian copyWith({
    String? date,
    Moods? moods,
    String? notes,
    Others? others,
    String? weight,
    Symptoms? symptoms,
    String? temperature,
    String? sexActivity,
    String? bleedingFlow,
    PhysicalActivity? physicalActivity,
    String? vaginalDischarge,
  }) {
    return DataHarian(
      date: date ?? this.date,
      moods: moods ?? this.moods,
      notes: notes ?? this.notes,
      others: others ?? this.others,
      weight: weight ?? this.weight,
      symptoms: symptoms ?? this.symptoms,
      temperature: temperature ?? this.temperature,
      sexActivity: sexActivity ?? this.sexActivity,
      bleedingFlow: bleedingFlow ?? this.bleedingFlow,
      physicalActivity: physicalActivity ?? this.physicalActivity,
      vaginalDischarge: vaginalDischarge ?? this.vaginalDischarge,
    );
  }
}

class Moods {
  bool sad;
  bool calm;
  bool angry;
  bool happy;
  bool tired;
  bool cranky;
  bool frisky;
  bool sleepy;
  bool anxious;
  bool excited;
  bool confused;
  bool apathetic;
  bool depressed;
  bool emotional;
  bool energetic;
  bool irritated;
  bool sensitive;
  bool unfocused;
  bool frustrated;
  bool lowEnergy;
  bool moodSwings;
  bool feelingGuilty;
  bool obsessiveThoughts;
  bool verySelfCritical;

  Moods({
    required this.sad,
    required this.calm,
    required this.angry,
    required this.happy,
    required this.tired,
    required this.cranky,
    required this.frisky,
    required this.sleepy,
    required this.anxious,
    required this.excited,
    required this.confused,
    required this.apathetic,
    required this.depressed,
    required this.emotional,
    required this.energetic,
    required this.irritated,
    required this.sensitive,
    required this.unfocused,
    required this.frustrated,
    required this.lowEnergy,
    required this.moodSwings,
    required this.feelingGuilty,
    required this.obsessiveThoughts,
    required this.verySelfCritical,
  });

  Moods.fromJson(Map<String, dynamic> json)
      : sad = json['Sad'],
        calm = json['Calm'],
        angry = json['Angry'],
        happy = json['Happy'],
        tired = json['Tired'],
        cranky = json['Cranky'],
        frisky = json['Frisky'],
        sleepy = json['Sleepy'],
        anxious = json['Anxious'],
        excited = json['Excited'],
        confused = json['Confused'],
        apathetic = json['Apathetic'],
        depressed = json['Depressed'],
        emotional = json['Emotional'],
        energetic = json['Energetic'],
        irritated = json['Irritated'],
        sensitive = json['Sensitive'],
        unfocused = json['Unfocused'],
        frustrated = json['Frustrated'],
        lowEnergy = json['Low energy'],
        moodSwings = json['Mood swings'],
        feelingGuilty = json['Feeling guilty'],
        obsessiveThoughts = json['Obsessive thoughts'],
        verySelfCritical = json['Very self-critical'];

  Map<String, bool> toJson() {
    final Map<String, bool> data = new Map<String, bool>();
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

  Moods copyWith({
    bool? sad,
    bool? calm,
    bool? angry,
    bool? happy,
    bool? tired,
    bool? cranky,
    bool? frisky,
    bool? sleepy,
    bool? anxious,
    bool? excited,
    bool? confused,
    bool? apathetic,
    bool? depressed,
    bool? emotional,
    bool? energetic,
    bool? irritated,
    bool? sensitive,
    bool? unfocused,
    bool? frustrated,
    bool? lowEnergy,
    bool? moodSwings,
    bool? feelingGuilty,
    bool? obsessiveThoughts,
    bool? verySelfCritical,
  }) {
    return Moods(
      sad: sad ?? this.sad,
      calm: calm ?? this.calm,
      angry: angry ?? this.angry,
      happy: happy ?? this.happy,
      tired: tired ?? this.tired,
      cranky: cranky ?? this.cranky,
      frisky: frisky ?? this.frisky,
      sleepy: sleepy ?? this.sleepy,
      anxious: anxious ?? this.anxious,
      excited: excited ?? this.excited,
      confused: confused ?? this.confused,
      apathetic: apathetic ?? this.apathetic,
      depressed: depressed ?? this.depressed,
      emotional: emotional ?? this.emotional,
      energetic: energetic ?? this.energetic,
      irritated: irritated ?? this.irritated,
      sensitive: sensitive ?? this.sensitive,
      unfocused: unfocused ?? this.unfocused,
      frustrated: frustrated ?? this.frustrated,
      lowEnergy: lowEnergy ?? this.lowEnergy,
      moodSwings: moodSwings ?? this.moodSwings,
      feelingGuilty: feelingGuilty ?? this.feelingGuilty,
      obsessiveThoughts: obsessiveThoughts ?? this.obsessiveThoughts,
      verySelfCritical: verySelfCritical ?? this.verySelfCritical,
    );
  }
}

class Others {
  bool stress;
  bool travel;
  bool alcohol;
  bool diseaseOrInjury;

  Others({
    required this.stress,
    required this.travel,
    required this.alcohol,
    required this.diseaseOrInjury,
  });

  Others.fromJson(Map<String, dynamic> json)
      : stress = json['Stress'],
        travel = json['Travel'],
        alcohol = json['Alcohol'],
        diseaseOrInjury = json['Disease or Injury'];

  Map<String, bool> toJson() {
    final Map<String, bool> data = <String, bool>{};
    data['Stress'] = this.stress;
    data['Travel'] = this.travel;
    data['Alcohol'] = this.alcohol;
    data['Disease or Injury'] = this.diseaseOrInjury;
    return data;
  }

  Others copyWith({
    bool? stress,
    bool? travel,
    bool? alcohol,
    bool? diseaseOrInjury,
  }) {
    return Others(
      stress: stress ?? this.stress,
      travel: travel ?? this.travel,
      alcohol: alcohol ?? this.alcohol,
      diseaseOrInjury: diseaseOrInjury ?? this.diseaseOrInjury,
    );
  }
}

class Symptoms {
  bool gas;
  bool pMS;
  bool acne;
  bool chills;
  bool cramps;
  bool nausea;
  bool fatigue;
  bool backache;
  bool bloating;
  bool cravings;
  bool diarrhea;
  bool headache;
  bool insomnia;
  bool spotting;
  bool swelling;
  bool dizziness;
  bool feelGood;
  bool bodyAches;
  bool hotFlashes;
  bool constipation;
  bool lowBackPain;
  bool nippleChanges;
  bool tenderBreasts;
  bool abdominalCramps;

  Symptoms({
    required this.gas,
    required this.pMS,
    required this.acne,
    required this.chills,
    required this.cramps,
    required this.nausea,
    required this.fatigue,
    required this.backache,
    required this.bloating,
    required this.cravings,
    required this.diarrhea,
    required this.headache,
    required this.insomnia,
    required this.spotting,
    required this.swelling,
    required this.dizziness,
    required this.feelGood,
    required this.bodyAches,
    required this.hotFlashes,
    required this.constipation,
    required this.lowBackPain,
    required this.nippleChanges,
    required this.tenderBreasts,
    required this.abdominalCramps,
  });

  Symptoms.fromJson(Map<String, dynamic> json)
      : gas = json['Gas'],
        pMS = json['PMS'],
        acne = json['Acne'],
        chills = json['Chills'],
        cramps = json['Cramps'],
        nausea = json['Nausea'],
        fatigue = json['Fatigue'],
        backache = json['Backache'],
        bloating = json['Bloating'],
        cravings = json['Cravings'],
        diarrhea = json['Diarrhea'],
        headache = json['Headache'],
        insomnia = json['Insomnia'],
        spotting = json['Spotting'],
        swelling = json['Swelling'],
        dizziness = json['Dizziness'],
        feelGood = json['Feel good'],
        bodyAches = json['Body aches'],
        hotFlashes = json['Hot flashes'],
        constipation = json['Constipation'],
        lowBackPain = json['Low back pain'],
        nippleChanges = json['Nipple changes'],
        tenderBreasts = json['Tender breasts'],
        abdominalCramps = json['Abdominal cramps'];

  Map<String, bool> toJson() {
    final Map<String, bool> data = <String, bool>{};
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

  Symptoms copyWith({
    bool? gas,
    bool? pMS,
    bool? acne,
    bool? chills,
    bool? cramps,
    bool? nausea,
    bool? fatigue,
    bool? backache,
    bool? bloating,
    bool? cravings,
    bool? diarrhea,
    bool? headache,
    bool? insomnia,
    bool? spotting,
    bool? swelling,
    bool? dizziness,
    bool? feelGood,
    bool? bodyAches,
    bool? hotFlashes,
    bool? constipation,
    bool? lowBackPain,
    bool? nippleChanges,
    bool? tenderBreasts,
    bool? abdominalCramps,
  }) {
    return Symptoms(
      gas: gas ?? this.gas,
      pMS: pMS ?? this.pMS,
      acne: acne ?? this.acne,
      chills: chills ?? this.chills,
      cramps: cramps ?? this.cramps,
      nausea: nausea ?? this.nausea,
      fatigue: fatigue ?? this.fatigue,
      backache: backache ?? this.backache,
      bloating: bloating ?? this.bloating,
      cravings: cravings ?? this.cravings,
      diarrhea: diarrhea ?? this.diarrhea,
      headache: headache ?? this.headache,
      insomnia: insomnia ?? this.insomnia,
      spotting: spotting ?? this.spotting,
      swelling: swelling ?? this.swelling,
      dizziness: dizziness ?? this.dizziness,
      feelGood: feelGood ?? this.feelGood,
      bodyAches: bodyAches ?? this.bodyAches,
      hotFlashes: hotFlashes ?? this.hotFlashes,
      constipation: constipation ?? this.constipation,
      lowBackPain: lowBackPain ?? this.lowBackPain,
      nippleChanges: nippleChanges ?? this.nippleChanges,
      tenderBreasts: tenderBreasts ?? this.tenderBreasts,
      abdominalCramps: abdominalCramps ?? this.abdominalCramps,
    );
  }
}

class PhysicalActivity {
  bool gym;
  bool yoga;
  bool cycling;
  bool running;
  bool walking;
  bool swimming;
  bool teamSports;
  bool didnTExercise;
  bool aerobicsDancing;

  PhysicalActivity({
    required this.gym,
    required this.yoga,
    required this.cycling,
    required this.running,
    required this.walking,
    required this.swimming,
    required this.teamSports,
    required this.didnTExercise,
    required this.aerobicsDancing,
  });

  PhysicalActivity.fromJson(Map<String, dynamic> json)
      : gym = json['Gym'],
        yoga = json['Yoga'],
        cycling = json['Cycling'],
        running = json['Running'],
        walking = json['Walking'],
        swimming = json['Swimming'],
        teamSports = json['Team sports'],
        didnTExercise = json["Didn't exercise"],
        aerobicsDancing = json['Aerobics & Dancing'];

  Map<String, bool> toJson() {
    final Map<String, bool> data = <String, bool>{};
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

  PhysicalActivity copyWith({
    bool? gym,
    bool? yoga,
    bool? cycling,
    bool? running,
    bool? walking,
    bool? swimming,
    bool? teamSports,
    bool? didnTExercise,
    bool? aerobicsDancing,
  }) {
    return PhysicalActivity(
      gym: gym ?? this.gym,
      yoga: yoga ?? this.yoga,
      cycling: cycling ?? this.cycling,
      running: running ?? this.running,
      walking: walking ?? this.walking,
      swimming: swimming ?? this.swimming,
      teamSports: teamSports ?? this.teamSports,
      didnTExercise: didnTExercise ?? this.didnTExercise,
      aerobicsDancing: aerobicsDancing ?? this.aerobicsDancing,
    );
  }
}
