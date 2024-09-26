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
  bool alteredBodyImage;
  bool anxiety;
  bool backPain;
  bool breastPain;
  bool brownishMarksOnFace;
  bool carpalTunnel;
  bool changesInLibido;
  bool changesInNipples;
  bool constipation;
  bool dizziness;
  bool dryMouth;
  bool fainting;
  bool feelingDepressed;
  bool foodCravings;
  bool forgetfulness;
  bool greasySkinAcne;
  bool haemorrhoids;
  bool headache;
  bool heartPalpitations;
  bool hipPelvicPain;
  bool increasedVaginalDischarge;
  bool incontinenceLeakingUrine;
  bool itchySkin;
  bool legCramps;
  bool nausea;
  bool painfulVaginalVeins;
  bool poorSleep;
  bool reflux;
  bool restlessLegs;
  bool shortnessOfBreath;
  bool sciatica;
  bool snoring;
  bool soreNipples;
  bool stretchMarks;
  bool swollenHandsFeet;
  bool tasteSmellChanges;
  bool thrush;
  bool tirednessFatigue;
  bool urinaryFrequency;
  bool varicoseVeins;
  bool vividDreams;
  bool vomiting;

  PregnancySymptoms({
    required this.alteredBodyImage,
    required this.anxiety,
    required this.backPain,
    required this.breastPain,
    required this.brownishMarksOnFace,
    required this.carpalTunnel,
    required this.changesInLibido,
    required this.changesInNipples,
    required this.constipation,
    required this.dizziness,
    required this.dryMouth,
    required this.fainting,
    required this.feelingDepressed,
    required this.foodCravings,
    required this.forgetfulness,
    required this.greasySkinAcne,
    required this.haemorrhoids,
    required this.headache,
    required this.heartPalpitations,
    required this.hipPelvicPain,
    required this.increasedVaginalDischarge,
    required this.incontinenceLeakingUrine,
    required this.itchySkin,
    required this.legCramps,
    required this.nausea,
    required this.painfulVaginalVeins,
    required this.poorSleep,
    required this.reflux,
    required this.restlessLegs,
    required this.shortnessOfBreath,
    required this.sciatica,
    required this.snoring,
    required this.soreNipples,
    required this.stretchMarks,
    required this.swollenHandsFeet,
    required this.tasteSmellChanges,
    required this.thrush,
    required this.tirednessFatigue,
    required this.urinaryFrequency,
    required this.varicoseVeins,
    required this.vividDreams,
    required this.vomiting,
  });

  PregnancySymptoms.fromJson(Map<String, dynamic> json)
      : alteredBodyImage = json['Altered Body Image'],
        anxiety = json['Anxiety'],
        backPain = json['Back Pain'],
        breastPain = json['Breast Pain'],
        brownishMarksOnFace = json['Brownish Marks on Face'],
        carpalTunnel = json['Carpal Tunnel'],
        changesInLibido = json['Changes in Libido'],
        changesInNipples = json['Changes in Nipples'],
        constipation = json['Constipation'],
        dizziness = json['Dizziness'],
        dryMouth = json['Dry Mouth'],
        fainting = json['Fainting'],
        feelingDepressed = json['Feeling Depressed'],
        foodCravings = json['Food Cravings'],
        forgetfulness = json['Forgetfulness'],
        greasySkinAcne = json['Greasy Skin/Acne'],
        haemorrhoids = json['Haemorrhoids'],
        headache = json['Headache'],
        heartPalpitations = json['Heart Palpitations'],
        hipPelvicPain = json['Hip/Pelvic Pain'],
        increasedVaginalDischarge = json['Increased Vaginal Discharge'],
        incontinenceLeakingUrine = json['Incontinence/Leaking Urine'],
        itchySkin = json['Itchy Skin'],
        legCramps = json['Leg Cramps'],
        nausea = json['Nausea'],
        painfulVaginalVeins = json['Painful Vaginal Veins'],
        poorSleep = json['Poor Sleep'],
        reflux = json['Reflux'],
        restlessLegs = json['Restless Legs'],
        shortnessOfBreath = json['Shortness of Breath'],
        sciatica = json['Sciatica'],
        snoring = json['Snoring'],
        soreNipples = json['Sore Nipples'],
        stretchMarks = json['Stretch Marks'],
        swollenHandsFeet = json['Swollen Hands/Feet'],
        tasteSmellChanges = json['Taste/Smell Changes'],
        thrush = json['Thrush'],
        tirednessFatigue = json['Tiredness/Fatigue'],
        urinaryFrequency = json['Urinary Frequency'],
        varicoseVeins = json['Varicose Veins'],
        vividDreams = json['Vivid Dreams'],
        vomiting = json['Vomiting'];

  Map<String, dynamic> toJson() {
    final Map<String, bool> data = <String, bool>{};
    data['Altered Body Image'] = alteredBodyImage;
    data['Anxiety'] = anxiety;
    data['Back Pain'] = backPain;
    data['Breast Pain'] = breastPain;
    data['Brownish Marks on Face'] = brownishMarksOnFace;
    data['Carpal Tunnel'] = carpalTunnel;
    data['Changes in Libido'] = changesInLibido;
    data['Changes in Nipples'] = changesInNipples;
    data['Constipation'] = constipation;
    data['Dizziness'] = dizziness;
    data['Dry Mouth'] = dryMouth;
    data['Fainting'] = fainting;
    data['Feeling Depressed'] = feelingDepressed;
    data['Food Cravings'] = foodCravings;
    data['Forgetfulness'] = forgetfulness;
    data['Greasy Skin/Acne'] = greasySkinAcne;
    data['Haemorrhoids'] = haemorrhoids;
    data['Headache'] = headache;
    data['Heart Palpitations'] = heartPalpitations;
    data['Hip/Pelvic Pain'] = hipPelvicPain;
    data['Increased Vaginal Discharge'] = increasedVaginalDischarge;
    data['Incontinence/Leaking Urine'] = incontinenceLeakingUrine;
    data['Itchy Skin'] = itchySkin;
    data['Leg Cramps'] = legCramps;
    data['Nausea'] = nausea;
    data['Painful Vaginal Veins'] = painfulVaginalVeins;
    data['Poor Sleep'] = poorSleep;
    data['Reflux'] = reflux;
    data['Restless Legs'] = restlessLegs;
    data['Shortness of Breath'] = shortnessOfBreath;
    data['Sciatica'] = sciatica;
    data['Snoring'] = snoring;
    data['Sore Nipples'] = soreNipples;
    data['Stretch Marks'] = stretchMarks;
    data['Swollen Hands/Feet'] = swollenHandsFeet;
    data['Taste/Smell Changes'] = tasteSmellChanges;
    data['Thrush'] = thrush;
    data['Tiredness/Fatigue'] = tirednessFatigue;
    data['Urinary Frequency'] = urinaryFrequency;
    data['Varicose Veins'] = varicoseVeins;
    data['Vivid Dreams'] = vividDreams;
    data['Vomiting'] = vomiting;
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
