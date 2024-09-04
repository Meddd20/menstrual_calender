import 'dart:convert';

class PregnancyDailyLog {
  int? id;
  int? userId;
  int? riwayatKehamilanId;
  List<DataHarianKehamilan>? dataHarianKehamilan;
  List<BloodPressure>? tekananDarah;
  List<ContractionTimer>? timerKontraksi;
  List<BabyKicks>? gerakanBayi;
  String? createdAt;
  String? updatedAt;

  PregnancyDailyLog({
    this.id,
    this.userId,
    this.riwayatKehamilanId,
    this.dataHarianKehamilan,
    this.tekananDarah,
    this.timerKontraksi,
    this.gerakanBayi,
    this.createdAt,
    this.updatedAt,
  });

  PregnancyDailyLog.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    riwayatKehamilanId = json['riwayat_kehamilan_id'];

    if (json['data_harian'] != null) {
      dataHarianKehamilan = [];
      var decodedDataHarian = json['data_harian'] is String ? jsonDecode(json['data_harian']) : json['data_harian'];
      decodedDataHarian.forEach((v) {
        dataHarianKehamilan!.add(DataHarianKehamilan.fromJson(v));
      });
    }

    if (json['tekanan_darah'] != null) {
      tekananDarah = [];
      var decodedTekananDarah = json['tekanan_darah'] is String ? jsonDecode(json['tekanan_darah']) : json['tekanan_darah'];
      decodedTekananDarah.forEach((v) {
        tekananDarah!.add(BloodPressure.fromJson(v));
      });
    }

    if (json['timer_kontraksi'] != null) {
      timerKontraksi = [];
      var decodedTimerKontraksi = json['timer_kontraksi'] is String ? jsonDecode(json['timer_kontraksi']) : json['timer_kontraksi'];
      decodedTimerKontraksi.forEach((v) {
        timerKontraksi!.add(ContractionTimer.fromJson(v));
      });
    }

    if (json['gerakan_bayi'] != null) {
      gerakanBayi = [];
      var decodedGerakanBayi = json['gerakan_bayi'] is String ? jsonDecode(json['gerakan_bayi']) : json['gerakan_bayi'];
      decodedGerakanBayi.forEach((v) {
        gerakanBayi!.add(BabyKicks.fromJson(v));
      });
    }

    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['riwayat_kehamilan_id'] = riwayatKehamilanId;
    if (dataHarianKehamilan != null) {
      data['data_harian'] = jsonEncode(dataHarianKehamilan!.map((v) => v.toJson()).toList());
    }
    if (tekananDarah != null) {
      data['tekanan_darah'] = jsonEncode(tekananDarah!.map((v) => v.toJson()).toList());
    }
    if (timerKontraksi != null) {
      data['timer_kontraksi'] = jsonEncode(timerKontraksi!.map((v) => v.toJson()).toList());
    }
    if (gerakanBayi != null) {
      data['gerakan_bayi'] = jsonEncode(gerakanBayi!.map((v) => v.toJson()).toList());
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }

  PregnancyDailyLog copyWith({
    int? id,
    int? userId,
    int? riwayatKehamilanId,
    List<DataHarianKehamilan>? dataHarianKehamilan,
    List<BloodPressure>? tekananDarah,
    List<ContractionTimer>? timerKontraksi,
    List<BabyKicks>? gerakanBayi,
    String? createdAt,
    String? updatedAt,
  }) {
    return PregnancyDailyLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      riwayatKehamilanId: riwayatKehamilanId ?? this.riwayatKehamilanId,
      dataHarianKehamilan: dataHarianKehamilan ?? this.dataHarianKehamilan,
      tekananDarah: tekananDarah ?? this.tekananDarah,
      timerKontraksi: timerKontraksi ?? this.timerKontraksi,
      gerakanBayi: gerakanBayi ?? this.gerakanBayi,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class DataHarianKehamilan {
  String date;
  PregnancySymptoms? pregnancySymptoms;
  String? notes;
  String? temperature;

  DataHarianKehamilan({
    required this.date,
    this.pregnancySymptoms,
    this.notes,
    this.temperature,
  });

  factory DataHarianKehamilan.fromJson(Map<String, dynamic> json) {
    return DataHarianKehamilan(
      date: json['date'] as String,
      pregnancySymptoms: json['pregnancy_symptoms'] != null ? PregnancySymptoms.fromJson(json['pregnancy_symptoms']) : null,
      notes: json['notes'] as String?,
      temperature: json['temperature'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'pregnancy_symptoms': pregnancySymptoms?.toJson(),
      'notes': notes,
      'temperature': temperature,
    };
  }
}

class PregnancySymptoms {
  bool achesAndPains;
  bool abdominalPressure;
  bool abdominalStretching;
  bool babyKicks;
  bool backPain;
  bool backaches;
  bool breastEnlargement;
  bool breastSoreness;
  bool breastSwelling;
  bool breastTenderness;
  bool breathlessness;
  bool carpalTunnelSyndrome;
  bool changesInLibido;
  bool clumsiness;
  bool constipation;
  bool cervicalDilation;
  bool decreasedLibido;
  bool darkeningOfSkin;
  bool dizziness;
  bool dryEyes;
  bool dryMouth;
  bool drySkin;
  bool easierBreathing;
  bool excessiveSalivation;
  bool fastGrowingHairAndNails;
  bool fatigue;
  bool foodAversions;
  bool foodCravings;
  bool frequentHeadaches;
  bool frequentUrination;
  bool generalDiscomfort;
  bool gumSensitivity;
  bool hairGrowthChanges;
  bool heartPalpitations;
  bool heartburn;
  bool hipPain;
  bool hipGroinAndAbdominalPain;
  bool hemorrhoids;
  bool increasedAppetite;
  bool increasedSaliva;
  bool increasedThirst;
  bool increasedUrgeToPush;
  bool increasedVaginalDischarge;
  bool insomnia;
  bool itchinessInHandsAndFeet;
  bool legCramps;
  bool legSwelling;
  bool leakyBreasts;
  bool looseLigaments;
  bool lossOfMucusPlug;
  bool lowerBackPain;
  bool moodSwings;
  bool nasalCongestion;
  bool nauseaAndVomiting;
  bool numbnessOrTingling;
  bool pelvicPain;
  bool pelvicPainAsBabyDescends;
  bool pelvicPressure;
  bool pregnancyBrain;
  bool pregnancyGlow;
  bool roundLigamentPain;
  bool skinChanges;
  bool shortnessOfBreath;
  bool spottingAfterSex;
  bool stuffyNose;
  bool stretchMarks;
  bool swellingInHandsAndFeet;
  bool swollenFeet;
  bool vividDreams;
  bool varicoseVeins;
  bool waterBreaking;

  PregnancySymptoms({
    required this.achesAndPains,
    required this.abdominalPressure,
    required this.abdominalStretching,
    required this.babyKicks,
    required this.backPain,
    required this.backaches,
    required this.breastEnlargement,
    required this.breastSoreness,
    required this.breastSwelling,
    required this.breastTenderness,
    required this.breathlessness,
    required this.carpalTunnelSyndrome,
    required this.changesInLibido,
    required this.clumsiness,
    required this.constipation,
    required this.cervicalDilation,
    required this.decreasedLibido,
    required this.darkeningOfSkin,
    required this.dizziness,
    required this.dryEyes,
    required this.dryMouth,
    required this.drySkin,
    required this.easierBreathing,
    required this.excessiveSalivation,
    required this.fastGrowingHairAndNails,
    required this.fatigue,
    required this.foodAversions,
    required this.foodCravings,
    required this.frequentHeadaches,
    required this.frequentUrination,
    required this.generalDiscomfort,
    required this.gumSensitivity,
    required this.hairGrowthChanges,
    required this.heartPalpitations,
    required this.heartburn,
    required this.hipPain,
    required this.hipGroinAndAbdominalPain,
    required this.hemorrhoids,
    required this.increasedAppetite,
    required this.increasedSaliva,
    required this.increasedThirst,
    required this.increasedUrgeToPush,
    required this.increasedVaginalDischarge,
    required this.insomnia,
    required this.itchinessInHandsAndFeet,
    required this.legCramps,
    required this.legSwelling,
    required this.leakyBreasts,
    required this.looseLigaments,
    required this.lossOfMucusPlug,
    required this.lowerBackPain,
    required this.moodSwings,
    required this.nasalCongestion,
    required this.nauseaAndVomiting,
    required this.numbnessOrTingling,
    required this.pelvicPain,
    required this.pelvicPainAsBabyDescends,
    required this.pelvicPressure,
    required this.pregnancyBrain,
    required this.pregnancyGlow,
    required this.roundLigamentPain,
    required this.skinChanges,
    required this.shortnessOfBreath,
    required this.spottingAfterSex,
    required this.stuffyNose,
    required this.stretchMarks,
    required this.swellingInHandsAndFeet,
    required this.swollenFeet,
    required this.vividDreams,
    required this.varicoseVeins,
    required this.waterBreaking,
  });

  PregnancySymptoms.fromJson(Map<String, dynamic> json)
      : achesAndPains = json["Aches and Pains"],
        abdominalPressure = json["Abdominal Pressure"],
        abdominalStretching = json["Abdominal Stretching"],
        babyKicks = json["Baby Kicks"],
        backPain = json["Back Pain"],
        backaches = json["Backaches"],
        breastEnlargement = json["Breast Enlargement"],
        breastSoreness = json["Breast Soreness"],
        breastSwelling = json["Breast Swelling"],
        breastTenderness = json["Breast Tenderness"],
        breathlessness = json["Breathlessness"],
        carpalTunnelSyndrome = json["Carpal Tunnel Syndrome"],
        changesInLibido = json["Changes in Libido"],
        clumsiness = json["Clumsiness"],
        constipation = json["Constipation"],
        cervicalDilation = json["Cervical Dilation"],
        decreasedLibido = json["Decreased Libido"],
        darkeningOfSkin = json["Darkening of Skin"],
        dizziness = json["Dizziness"],
        dryEyes = json["Dry Eyes"],
        dryMouth = json["Dry Mouth"],
        drySkin = json["Dry Skin"],
        easierBreathing = json["Easier Breathing"],
        excessiveSalivation = json["Excessive Salivation"],
        fastGrowingHairAndNails = json["Fast-Growing Hair and Nails"],
        fatigue = json["Fatigue"],
        foodAversions = json["Food Aversions"],
        foodCravings = json["Food Cravings"],
        frequentHeadaches = json["Frequent Headaches"],
        frequentUrination = json["Frequent Urination"],
        generalDiscomfort = json["General Discomfort"],
        gumSensitivity = json["Gum Sensitivity"],
        hairGrowthChanges = json["Hair Growth Changes"],
        heartPalpitations = json["Heart Palpitations"],
        heartburn = json["Heartburn"],
        hipPain = json["Hip Pain"],
        hipGroinAndAbdominalPain = json["Hip, Groin, and Abdominal Pain"],
        hemorrhoids = json["Hemorrhoids"],
        increasedAppetite = json["Increased Appetite"],
        increasedSaliva = json["Increased Saliva"],
        increasedThirst = json["Increased Thirst"],
        increasedUrgeToPush = json["Increased Urge to Push"],
        increasedVaginalDischarge = json["Increased Vaginal Discharge"],
        insomnia = json["Insomnia"],
        itchinessInHandsAndFeet = json["Itchiness in Hands and Feet"],
        legCramps = json["Leg Cramps"],
        legSwelling = json["Leg Swelling"],
        leakyBreasts = json["Leaky Breasts"],
        looseLigaments = json["Loose Ligaments"],
        lossOfMucusPlug = json["Loss of Mucus Plug"],
        lowerBackPain = json["Lower Back Pain"],
        moodSwings = json["Mood Swings"],
        nasalCongestion = json["Nasal Congestion"],
        nauseaAndVomiting = json["Nausea and Vomiting"],
        numbnessOrTingling = json["Numbness or Tingling"],
        pelvicPain = json["Pelvic Pain"],
        pelvicPainAsBabyDescends = json["Pelvic Pain as Baby Descends"],
        pelvicPressure = json["Pelvic Pressure"],
        pregnancyBrain = json["Pregnancy Brain (Forgetfulness)"],
        pregnancyGlow = json["Pregnancy Glow"],
        roundLigamentPain = json["Round Ligament Pain"],
        skinChanges = json["Skin Changes"],
        shortnessOfBreath = json["Shortness of Breath"],
        spottingAfterSex = json["Spotting After Sex"],
        stuffyNose = json["Stuffy Nose"],
        stretchMarks = json["Stretch Marks"],
        swellingInHandsAndFeet = json["Swelling in Hands and Feet"],
        swollenFeet = json["Swollen Feet"],
        vividDreams = json["Vivid Dreams"],
        varicoseVeins = json["Varicose Veins"],
        waterBreaking = json["Water Breaking"];

  Map<String, dynamic> toJson() {
    final Map<String, bool> data = <String, bool>{};
    data["Aches and Pains"] = this.achesAndPains;
    data["Abdominal Pressure"] = this.abdominalPressure;
    data["Abdominal Stretching"] = this.abdominalStretching;
    data["Baby Kicks"] = this.babyKicks;
    data["Back Pain"] = this.backPain;
    data["Backaches"] = this.backaches;
    data["Breast Enlargement"] = this.breastEnlargement;
    data["Breast Soreness"] = this.breastSoreness;
    data["Breast Swelling"] = this.breastSwelling;
    data["Breast Tenderness"] = this.breastTenderness;
    data["Breathlessness"] = this.breathlessness;
    data["Carpal Tunnel Syndrome"] = this.carpalTunnelSyndrome;
    data["Changes in Libido"] = this.changesInLibido;
    data["Clumsiness"] = this.clumsiness;
    data["Constipation"] = this.constipation;
    data["Cervical Dilation"] = this.cervicalDilation;
    data["Decreased Libido"] = this.decreasedLibido;
    data["Darkening of Skin"] = this.darkeningOfSkin;
    data["Dizziness"] = this.dizziness;
    data["Dry Eyes"] = this.dryEyes;
    data["Dry Mouth"] = this.dryMouth;
    data["Dry Skin"] = this.drySkin;
    data["Easier Breathing"] = this.easierBreathing;
    data["Excessive Salivation"] = this.excessiveSalivation;
    data["Fast-Growing Hair and Nails"] = this.fastGrowingHairAndNails;
    data["Fatigue"] = this.fatigue;
    data["Food Aversions"] = this.foodAversions;
    data["Food Cravings"] = this.foodCravings;
    data["Frequent Headaches"] = this.frequentHeadaches;
    data["Frequent Urination"] = this.frequentUrination;
    data["General Discomfort"] = this.generalDiscomfort;
    data["Gum Sensitivity"] = this.gumSensitivity;
    data["Hair Growth Changes"] = this.hairGrowthChanges;
    data["Heart Palpitations"] = this.heartPalpitations;
    data["Heartburn"] = this.heartburn;
    data["Hip Pain"] = this.hipPain;
    data["Hip, Groin, and Abdominal Pain"] = this.hipGroinAndAbdominalPain;
    data["Hemorrhoids"] = this.hemorrhoids;
    data["Increased Appetite"] = this.increasedAppetite;
    data["Increased Saliva"] = this.increasedSaliva;
    data["Increased Thirst"] = this.increasedThirst;
    data["Increased Urge to Push"] = this.increasedUrgeToPush;
    data["Increased Vaginal Discharge"] = this.increasedVaginalDischarge;
    data["Insomnia"] = this.insomnia;
    data["Itchiness in Hands and Feet"] = this.itchinessInHandsAndFeet;
    data["Leg Cramps"] = this.legCramps;
    data["Leg Swelling"] = this.legSwelling;
    data["Leaky Breasts"] = this.leakyBreasts;
    data["Loose Ligaments"] = this.looseLigaments;
    data["Loss of Mucus Plug"] = this.lossOfMucusPlug;
    data["Lower Back Pain"] = this.lowerBackPain;
    data["Mood Swings"] = this.moodSwings;
    data["Nasal Congestion"] = this.nasalCongestion;
    data["Nausea and Vomiting"] = this.nauseaAndVomiting;
    data["Numbness or Tingling"] = this.numbnessOrTingling;
    data["Pelvic Pain"] = this.pelvicPain;
    data["Pelvic Pain as Baby Descends"] = this.pelvicPainAsBabyDescends;
    data["Pelvic Pressure"] = this.pelvicPressure;
    data["Pregnancy Brain (Forgetfulness)"] = this.pregnancyBrain;
    data["Pregnancy Glow"] = this.pregnancyGlow;
    data["Round Ligament Pain"] = this.roundLigamentPain;
    data["Skin Changes"] = this.skinChanges;
    data["Shortness of Breath"] = this.shortnessOfBreath;
    data["Spotting After Sex"] = this.spottingAfterSex;
    data["Stuffy Nose"] = this.stuffyNose;
    data["Stretch Marks"] = this.stretchMarks;
    data["Swelling in Hands and Feet"] = this.swellingInHandsAndFeet;
    data["Swollen Feet"] = this.swollenFeet;
    data["Vivid Dreams"] = this.vividDreams;
    data["Varicose Veins"] = this.varicoseVeins;
    data["Water Breaking"] = this.waterBreaking;
    return data;
  }
}

class BloodPressure {
  String? id;
  int systolicPressure;
  int diastolicPressure;
  int heartRate;
  String datetime;

  BloodPressure({
    this.id,
    required this.systolicPressure,
    required this.diastolicPressure,
    required this.heartRate,
    required this.datetime,
  });

  factory BloodPressure.fromJson(Map<String, dynamic> json) {
    return BloodPressure(
      id: json['id'] as String?,
      systolicPressure: int.tryParse(json['tekanan_sistolik'].toString()) ?? 0,
      diastolicPressure: int.tryParse(json['tekanan_diastolik'].toString()) ?? 0,
      heartRate: int.tryParse(json['detak_jantung'].toString()) ?? 0,
      datetime: json['datetime'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'tekanan_sistolik': systolicPressure,
      'tekanan_diastolik': diastolicPressure,
      'detak_jantung': heartRate,
      'datetime': datetime,
    };
    if (id != null) {
      data['id'] = id!;
    }
    return data;
  }

  BloodPressure copyWith({
    String? id,
    int? systolicPressure,
    int? diastolicPressure,
    int? heartRate,
    String? datetime,
  }) {
    return BloodPressure(
      id: id ?? this.id,
      systolicPressure: systolicPressure ?? this.systolicPressure,
      diastolicPressure: diastolicPressure ?? this.diastolicPressure,
      heartRate: heartRate ?? this.heartRate,
      datetime: datetime ?? this.datetime,
    );
  }
}

class ContractionTimer {
  String? id;
  String timeStart;
  int duration;
  int? interval;

  ContractionTimer({
    this.id,
    required this.timeStart,
    required this.duration,
    this.interval,
  });

  factory ContractionTimer.fromJson(Map<String, dynamic> json) {
    return ContractionTimer(
      id: json['id'] as String?,
      timeStart: json['waktu_mulai'] as String,
      duration: int.tryParse(json['durasi'].toString()) ?? 0,
      interval: json['interval'] != null ? int.tryParse(json['interval'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'waktu_mulai': timeStart,
      'durasi': duration,
      'interval': interval,
    };
    if (id != null) {
      data['id'] = id!;
    }
    return data;
  }

  ContractionTimer copyWith({
    String? id,
    String? timeStart,
    int? duration,
    int? interval,
  }) {
    return ContractionTimer(
      id: id ?? this.id,
      timeStart: timeStart ?? this.timeStart,
      duration: duration ?? this.duration,
      interval: interval ?? this.interval,
    );
  }
}

class BabyKicks {
  String? id;
  String datetimeStart;
  String datetimeEnd;
  int totalKicks;

  BabyKicks({
    this.id,
    required this.datetimeStart,
    required this.datetimeEnd,
    required this.totalKicks,
  });

  factory BabyKicks.fromJson(Map<String, dynamic> json) {
    return BabyKicks(
      id: json['id'] as String?,
      datetimeStart: json['waktu_mulai'] as String,
      datetimeEnd: json['waktu_selesai'] as String,
      totalKicks: int.tryParse(json['jumlah_gerakan'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'waktu_mulai': datetimeStart,
      'waktu_selesai': datetimeEnd,
      'jumlah_gerakan': totalKicks,
    };
    if (id != null) {
      data['id'] = id!;
    }
    return data;
  }

  BabyKicks copyWith({
    String? id,
    String? datetimeStart,
    String? datetimeEnd,
    int? totalKicks,
  }) {
    return BabyKicks(
      id: id ?? this.id,
      datetimeStart: datetimeStart ?? this.datetimeStart,
      datetimeEnd: datetimeEnd ?? this.datetimeEnd,
      totalKicks: totalKicks ?? this.totalKicks,
    );
  }
}
