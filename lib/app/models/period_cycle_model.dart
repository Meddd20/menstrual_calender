class PeriodCycle {
  PeriodCycle({
    required this.status,
    required this.message,
    required this.data,
  });

  final String? status;
  final String? message;
  final Data? data;

  factory PeriodCycle.fromJson(Map<String, dynamic> json) {
    return PeriodCycle(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }
}

class Data {
  Data(
      {required this.initialYear,
      required this.latestYear,
      required this.currentYear,
      required this.age,
      required this.lunarAge,
      required this.shortestPeriod,
      required this.longestPeriod,
      required this.shortestCycle,
      required this.longestCycle,
      required this.avgPeriodDuration,
      required this.avgPeriodCycle,
      required this.periodChart,
      required this.latestPeriodHistory,
      required this.periodHistory,
      required this.actualPeriod,
      required this.predictionPeriod,
      required this.shettlesGenderPrediction});

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
  final List<PeriodChart> periodChart;
  final LatestPeriodHistory? latestPeriodHistory;
  final List<LatestPeriodHistory> periodHistory;
  final List<LatestPeriodHistory> actualPeriod;
  final List<LatestPeriodHistory> predictionPeriod;
  final List<ShettlesGenderPrediction> shettlesGenderPrediction;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
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
      periodChart: json["period_chart"] == null
          ? []
          : List<PeriodChart>.from(
              json["period_chart"]!.map((x) => PeriodChart.fromJson(x))),
      latestPeriodHistory: json["latest_period_history"] == null
          ? null
          : LatestPeriodHistory.fromJson(json["latest_period_history"]),
      periodHistory: json["period_history"] == null
          ? []
          : List<LatestPeriodHistory>.from(json["period_history"]!
              .map((x) => LatestPeriodHistory.fromJson(x))),
      actualPeriod: json["actual_period"] == null
          ? []
          : List<LatestPeriodHistory>.from(json["actual_period"]!
              .map((x) => LatestPeriodHistory.fromJson(x))),
      predictionPeriod: json["prediction_period"] == null
          ? []
          : List<LatestPeriodHistory>.from(json["prediction_period"]!
              .map((x) => LatestPeriodHistory.fromJson(x))),
      shettlesGenderPrediction: json["shettlesGenderPrediction"] == null
          ? []
          : List<ShettlesGenderPrediction>.from(
              json["shettlesGenderPrediction"]!
                  .map((x) => ShettlesGenderPrediction.fromJson(x))),
    );
  }
}

class LatestPeriodHistory {
  LatestPeriodHistory({
    required this.id,
    required this.userId,
    required this.haidAwal,
    required this.haidAkhir,
    required this.ovulasi,
    required this.masaSuburAwal,
    required this.masaSuburAkhir,
    required this.hariTerakhirSiklus,
    required this.lamaSiklus,
    required this.durasiHaid,
    required this.haidBerikutnyaAwal,
    required this.haidBerikutnyaAkhir,
    required this.ovulasiBerikutnya,
    required this.masaSuburBerikutnyaAwal,
    required this.masaSuburBerikutnyaAkhir,
    required this.hariTerakhirSiklusBerikutnya,
    required this.isActual,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final int? userId;
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
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory LatestPeriodHistory.fromJson(Map<String, dynamic> json) {
    return LatestPeriodHistory(
      id: json["id"],
      userId: json["user_id"],
      haidAwal: DateTime.tryParse(json["haid_awal"] ?? ""),
      haidAkhir: DateTime.tryParse(json["haid_akhir"] ?? ""),
      ovulasi: DateTime.tryParse(json["ovulasi"] ?? ""),
      masaSuburAwal: DateTime.tryParse(json["masa_subur_awal"] ?? ""),
      masaSuburAkhir: DateTime.tryParse(json["masa_subur_akhir"] ?? ""),
      hariTerakhirSiklus: DateTime.tryParse(json["hari_terakhir_siklus"] ?? ""),
      lamaSiklus: json["lama_siklus"],
      durasiHaid: json["durasi_haid"],
      haidBerikutnyaAwal: DateTime.tryParse(json["haid_berikutnya_awal"] ?? ""),
      haidBerikutnyaAkhir:
          DateTime.tryParse(json["haid_berikutnya_akhir"] ?? ""),
      ovulasiBerikutnya: DateTime.tryParse(json["ovulasi_berikutnya"] ?? ""),
      masaSuburBerikutnyaAwal:
          DateTime.tryParse(json["masa_subur_berikutnya_awal"] ?? ""),
      masaSuburBerikutnyaAkhir:
          DateTime.tryParse(json["masa_subur_berikutnya_akhir"] ?? ""),
      hariTerakhirSiklusBerikutnya:
          DateTime.tryParse(json["hari_terakhir_siklus_berikutnya"] ?? ""),
      isActual: json["is_actual"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
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
