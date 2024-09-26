class PeriodCycleIndex {
  final String? initialYear;
  final String? latestYear;
  final String? currentYear;
  final int? age;
  final int? lunarAge;
  final int? shortestPeriod;
  final int? longestPeriod;
  final int? shortestCycle;
  final int? longestCycle;
  final int? avgPeriodDuration;
  final int? avgPeriodCycle;
  final List<PeriodChart>? periodChart;
  final PeriodHistory? latestPeriodHistory;
  final List<PeriodHistory>? periodHistory;
  final List<PeriodHistory>? actualPeriod;
  final List<PeriodHistory>? predictionPeriod;
  final List<ShettlesGenderPrediction>? shettlesGenderPrediction;

  PeriodCycleIndex({
    this.initialYear,
    this.latestYear,
    this.currentYear,
    this.age,
    this.lunarAge,
    this.shortestPeriod,
    this.longestPeriod,
    this.shortestCycle,
    this.longestCycle,
    this.avgPeriodDuration,
    this.avgPeriodCycle,
    this.periodChart,
    this.latestPeriodHistory,
    this.periodHistory,
    this.actualPeriod,
    this.predictionPeriod,
    this.shettlesGenderPrediction,
  });

  factory PeriodCycleIndex.fromJson(Map<String, dynamic> json) {
    return PeriodCycleIndex(
      initialYear: json["initial_year"],
      latestYear: json["latest_year"],
      currentYear: json["current_year"],
      age: json["age"],
      lunarAge: json["lunar_age"],
      shortestPeriod: json["shortest_period"],
      longestPeriod: json["longest_period"],
      shortestCycle: json["shortest_cycle"],
      longestCycle: json["longest_cycle"],
      avgPeriodDuration: json["avg_period_duration"],
      avgPeriodCycle: json["avg_period_cycle"],
      periodChart: json["period_chart"] == null ? [] : List<PeriodChart>.from(json["period_chart"]!.map((x) => PeriodChart.fromJson(x))),
      latestPeriodHistory: json["latest_period_history"] == null ? null : PeriodHistory.fromJson(json["latest_period_history"]),
      periodHistory: json["period_history"] == null ? [] : List<PeriodHistory>.from(json["period_history"]!.map((x) => PeriodHistory.fromJson(x))),
      actualPeriod: json["actual_period"] == null ? [] : List<PeriodHistory>.from(json["actual_period"]!.map((x) => PeriodHistory.fromJson(x))),
      predictionPeriod: json["prediction_period"] == null ? [] : List<PeriodHistory>.from(json["prediction_period"]!.map((x) => PeriodHistory.fromJson(x))),
      shettlesGenderPrediction: json["shettlesGenderPrediction"] == null ? [] : List<ShettlesGenderPrediction>.from(json["shettlesGenderPrediction"]!.map((x) => ShettlesGenderPrediction.fromJson(x))),
    );
  }
}

class PeriodHistory {
  final int? id;
  final int? userId;
  final int? remoteId;
  final DateTime? haidAwal;
  final DateTime? haidAkhir;
  final DateTime? ovulasi;
  final DateTime? masaSuburAwal;
  final DateTime? masaSuburAkhir;
  final DateTime? hariTerakhirSiklus;
  final int? lamaSiklus;
  final int? durasiHaid;
  final DateTime? haidBerikutnyaAwal;
  final DateTime? haidBerikutnyaAkhir;
  final DateTime? ovulasiBerikutnya;
  final DateTime? masaSuburBerikutnyaAwal;
  final DateTime? masaSuburBerikutnyaAkhir;
  final DateTime? hariTerakhirSiklusBerikutnya;
  final String? isActual;
  final String? createdAt;
  final String? updatedAt;

  PeriodHistory({
    this.id,
    this.userId,
    this.remoteId,
    this.haidAwal,
    this.haidAkhir,
    this.ovulasi,
    this.masaSuburAwal,
    this.masaSuburAkhir,
    this.hariTerakhirSiklus,
    this.lamaSiklus,
    this.durasiHaid,
    this.haidBerikutnyaAwal,
    this.haidBerikutnyaAkhir,
    this.ovulasiBerikutnya,
    this.masaSuburBerikutnyaAwal,
    this.masaSuburBerikutnyaAkhir,
    this.hariTerakhirSiklusBerikutnya,
    this.isActual,
    this.createdAt,
    this.updatedAt,
  });

  factory PeriodHistory.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return PeriodHistory(
      id: parseInt(json["id"]),
      userId: parseInt(json["user_id"]),
      remoteId: parseInt(json["remote_id"] ?? 0),
      haidAwal: DateTime.tryParse(json["haid_awal"] ?? ""),
      haidAkhir: DateTime.tryParse(json["haid_akhir"] ?? ""),
      ovulasi: DateTime.tryParse(json["ovulasi"] ?? ""),
      masaSuburAwal: DateTime.tryParse(json["masa_subur_awal"] ?? ""),
      masaSuburAkhir: DateTime.tryParse(json["masa_subur_akhir"] ?? ""),
      hariTerakhirSiklus: DateTime.tryParse(json["hari_terakhir_siklus"] ?? ""),
      lamaSiklus: parseInt(json["lama_siklus"]),
      durasiHaid: parseInt(json["durasi_haid"]),
      haidBerikutnyaAwal: DateTime.tryParse(json["haid_berikutnya_awal"] ?? ""),
      haidBerikutnyaAkhir: DateTime.tryParse(json["haid_berikutnya_akhir"] ?? ""),
      ovulasiBerikutnya: DateTime.tryParse(json["ovulasi_berikutnya"] ?? ""),
      masaSuburBerikutnyaAwal: DateTime.tryParse(json["masa_subur_berikutnya_awal"] ?? ""),
      masaSuburBerikutnyaAkhir: DateTime.tryParse(json["masa_subur_berikutnya_akhir"] ?? ""),
      hariTerakhirSiklusBerikutnya: DateTime.tryParse(json["hari_terakhir_siklus_berikutnya"] ?? ""),
      isActual: json["is_actual"]?.toString(),
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "remote_id": remoteId,
      "haid_awal": haidAwal?.toString(),
      "haid_akhir": haidAkhir?.toString(),
      "ovulasi": ovulasi?.toString(),
      "masa_subur_awal": masaSuburAwal?.toString(),
      "masa_subur_akhir": masaSuburAkhir?.toString(),
      "hari_terakhir_siklus": hariTerakhirSiklus?.toString(),
      "lama_siklus": lamaSiklus,
      "durasi_haid": durasiHaid,
      "haid_berikutnya_awal": haidBerikutnyaAwal?.toString(),
      "haid_berikutnya_akhir": haidBerikutnyaAkhir?.toString(),
      "ovulasi_berikutnya": ovulasiBerikutnya?.toString(),
      "masa_subur_berikutnya_awal": masaSuburBerikutnyaAwal?.toString(),
      "masa_subur_berikutnya_akhir": masaSuburBerikutnyaAkhir?.toString(),
      "hari_terakhir_siklus_berikutnya": hariTerakhirSiklusBerikutnya?.toString(),
      "is_actual": isActual,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }

  PeriodHistory copyWith({
    int? id,
    int? userId,
    int? remoteId,
    DateTime? haidAwal,
    DateTime? haidAkhir,
    DateTime? ovulasi,
    DateTime? masaSuburAwal,
    DateTime? masaSuburAkhir,
    DateTime? hariTerakhirSiklus,
    int? lamaSiklus,
    int? durasiHaid,
    DateTime? haidBerikutnyaAwal,
    DateTime? haidBerikutnyaAkhir,
    DateTime? ovulasiBerikutnya,
    DateTime? masaSuburBerikutnyaAwal,
    DateTime? masaSuburBerikutnyaAkhir,
    DateTime? hariTerakhirSiklusBerikutnya,
    String? isActual,
    String? createdAt,
    String? updatedAt,
  }) {
    return PeriodHistory(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      remoteId: remoteId ?? this.remoteId,
      haidAwal: haidAwal ?? this.haidAwal,
      haidAkhir: haidAkhir ?? this.haidAkhir,
      ovulasi: ovulasi ?? this.ovulasi,
      masaSuburAwal: masaSuburAwal ?? this.masaSuburAwal,
      masaSuburAkhir: masaSuburAkhir ?? this.masaSuburAkhir,
      hariTerakhirSiklus: hariTerakhirSiklus ?? this.hariTerakhirSiklus,
      lamaSiklus: lamaSiklus ?? this.lamaSiklus,
      durasiHaid: durasiHaid ?? this.durasiHaid,
      haidBerikutnyaAwal: haidBerikutnyaAwal ?? this.haidBerikutnyaAwal,
      haidBerikutnyaAkhir: haidBerikutnyaAkhir ?? this.haidBerikutnyaAkhir,
      ovulasiBerikutnya: ovulasiBerikutnya ?? this.ovulasiBerikutnya,
      masaSuburBerikutnyaAwal: masaSuburBerikutnyaAwal ?? this.masaSuburBerikutnyaAwal,
      masaSuburBerikutnyaAkhir: masaSuburBerikutnyaAkhir ?? this.masaSuburBerikutnyaAkhir,
      hariTerakhirSiklusBerikutnya: hariTerakhirSiklusBerikutnya ?? this.hariTerakhirSiklusBerikutnya,
      isActual: isActual ?? this.isActual,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class PeriodChart {
  PeriodChart({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.periodCycle,
    required this.periodDuration,
  });

  final int? id;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? periodCycle;
  final int? periodDuration;

  factory PeriodChart.fromJson(Map<String, dynamic> json) {
    return PeriodChart(
      id: json['id'],
      startDate: DateTime.tryParse(json["start_date"] ?? ""),
      endDate: DateTime.tryParse(json["end_date"] ?? ""),
      periodCycle: json["period_cycle"],
      periodDuration: json["period_duration"],
    );
  }
}

class ShettlesGenderPrediction {
  ShettlesGenderPrediction({
    required this.boyStartDate,
    required this.boyEndDate,
    required this.girlStartDate,
    required this.girlEndDate,
  });

  final DateTime? boyStartDate;
  final DateTime? boyEndDate;
  final DateTime? girlStartDate;
  final DateTime? girlEndDate;

  factory ShettlesGenderPrediction.fromJson(Map<String, dynamic> json) {
    return ShettlesGenderPrediction(
      boyStartDate: DateTime.tryParse(json["boyStartDate"] ?? ""),
      boyEndDate: DateTime.tryParse(json["boyEndDate"] ?? ""),
      girlStartDate: DateTime.tryParse(json["girlStartDate"] ?? ""),
      girlEndDate: DateTime.tryParse(json["girlEndDate"] ?? ""),
    );
  }
}
