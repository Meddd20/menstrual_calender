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

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  Data({
    required this.initialYear,
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
    required this.gender,
  });

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
  final List<Gender> gender;

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
      gender: json["gender"] == null
          ? []
          : List<Gender>.from(json["gender"]!.map((x) => Gender.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "initial_year": initialYear,
        "latest_year": latestYear,
        "current_year": currentYear,
        "age": age,
        "lunar_age": lunarAge,
        "shortest_period": shortestPeriod,
        "longest_period": longestPeriod,
        "shortest_cycle": shortestCycle,
        "longest_cycle": longestCycle,
        "avg_period_duration": avgPeriodDuration,
        "avg_period_cycle": avgPeriodCycle,
        "period_chart": periodChart.map((x) => x.toJson()).toList(),
        "latest_period_history": latestPeriodHistory?.toJson(),
        "period_history": periodHistory.map((x) => x.toJson()).toList(),
        "actual_period": actualPeriod.map((x) => x.toJson()).toList(),
        "prediction_period": predictionPeriod.map((x) => x.toJson()).toList(),
        "gender": gender.map((x) => x.toJson()).toList(),
      };
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

  final String? id;
  final String? userId;
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

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "haid_awal": haidAwal != null
            ? "${haidAwal!.year.toString().padLeft(4, '0')}-${haidAwal!.month.toString().padLeft(2, '0')}-${haidAwal!.day.toString().padLeft(2, '0')}"
            : null,
        "haid_akhir": haidAkhir != null
            ? "${haidAkhir!.year.toString().padLeft(4, '0')}-${haidAkhir!.month.toString().padLeft(2, '0')}-${haidAkhir!.day.toString().padLeft(2, '0')}"
            : null,
        "ovulasi": ovulasi != null
            ? "${ovulasi!.year.toString().padLeft(4, '0')}-${ovulasi!.month.toString().padLeft(2, '0')}-${ovulasi!.day.toString().padLeft(2, '0')}"
            : null,
        "masa_subur_awal": masaSuburAwal != null
            ? "${masaSuburAwal!.year.toString().padLeft(4, '0')}-${masaSuburAwal!.month.toString().padLeft(2, '0')}-${masaSuburAwal!.day.toString().padLeft(2, '0')}"
            : null,
        "masa_subur_akhir": masaSuburAkhir != null
            ? "${masaSuburAkhir!.year.toString().padLeft(4, '0')}-${masaSuburAkhir!.month.toString().padLeft(2, '0')}-${masaSuburAkhir!.day.toString().padLeft(2, '0')}"
            : null,
        "hari_terakhir_siklus": hariTerakhirSiklus != null
            ? "${hariTerakhirSiklus!.year.toString().padLeft(4, '0')}-${hariTerakhirSiklus!.month.toString().padLeft(2, '0')}-${hariTerakhirSiklus!.day.toString().padLeft(2, '0')}"
            : null,
        "lama_siklus": lamaSiklus,
        "durasi_haid": durasiHaid,
        "haid_berikutnya_awal": haidBerikutnyaAwal != null
            ? "${haidBerikutnyaAwal!.year.toString().padLeft(4, '0')}-${haidBerikutnyaAwal!.month.toString().padLeft(2, '0')}-${haidBerikutnyaAwal!.day.toString().padLeft(2, '0')}"
            : null,
        "haid_berikutnya_akhir": haidBerikutnyaAkhir != null
            ? "${haidBerikutnyaAkhir!.year.toString().padLeft(4, '0')}-${haidBerikutnyaAkhir!.month.toString().padLeft(2, '0')}-${haidBerikutnyaAkhir!.day.toString().padLeft(2, '0')}"
            : null,
        "ovulasi_berikutnya": ovulasiBerikutnya != null
            ? "${ovulasiBerikutnya!.year.toString().padLeft(4, '0')}-${ovulasiBerikutnya!.month.toString().padLeft(2, '0')}-${ovulasiBerikutnya!.day.toString().padLeft(2, '0')}"
            : null,
        "masa_subur_berikutnya_awal": masaSuburBerikutnyaAwal != null
            ? "${masaSuburBerikutnyaAwal!.year.toString().padLeft(4, '0')}-${masaSuburBerikutnyaAwal!.month.toString().padLeft(2, '0')}-${masaSuburBerikutnyaAwal!.day.toString().padLeft(2, '0')}"
            : null,
        "masa_subur_berikutnya_akhir": masaSuburBerikutnyaAkhir != null
            ? "${masaSuburBerikutnyaAkhir!.year.toString().padLeft(4, '0')}-${masaSuburBerikutnyaAkhir!.month.toString().padLeft(2, '0')}-${masaSuburBerikutnyaAkhir!.day.toString().padLeft(2, '0')}"
            : null,
        "hari_terakhir_siklus_berikutnya": hariTerakhirSiklusBerikutnya != null
            ? "${hariTerakhirSiklusBerikutnya!.year.toString().padLeft(4, '0')}-${hariTerakhirSiklusBerikutnya!.month.toString().padLeft(2, '0')}-${hariTerakhirSiklusBerikutnya!.day.toString().padLeft(2, '0')}"
            : null,
        "is_actual": isActual,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Gender {
  Gender({
    required this.bulan,
    required this.namaBulan,
    required this.lunarAge,
    required this.prediksiJenisKelamin,
  });

  final int? bulan;
  final String? namaBulan;
  final int? lunarAge;
  final String? prediksiJenisKelamin;

  factory Gender.fromJson(Map<String, dynamic> json) {
    return Gender(
      bulan: json["bulan"],
      namaBulan: json["nama_bulan"],
      lunarAge: json["lunar_age"],
      prediksiJenisKelamin: json["prediksi_jenis_kelamin"],
    );
  }

  Map<String, dynamic> toJson() => {
        "bulan": bulan,
        "nama_bulan": namaBulan,
        "lunar_age": lunarAge,
        "prediksi_jenis_kelamin": prediksiJenisKelamin,
      };
}

class PeriodChart {
  PeriodChart({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.periodCycle,
    required this.periodDuration,
  });

  final String? id;
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

  Map<String, dynamic> toJson() => {
        "id": id,
        "start_date": startDate != null
            ? "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}"
            : null,
        "end_date": endDate != null
            ? "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}"
            : null,
        "period_cycle": periodCycle,
        "period_duration": periodDuration,
      };
}
