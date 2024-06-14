class Pregnancy {
  String? status;
  String? message;
  Data? data;

  Pregnancy({this.status, this.message, this.data});

  Pregnancy.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  List<PregnancyHistory>? pregnancyHistory;
  List<CurrentlyPregnant>? currentlyPregnant;

  Data({this.pregnancyHistory, this.currentlyPregnant});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['pregnancy_history'] != null) {
      pregnancyHistory = <PregnancyHistory>[];
      json['pregnancy_history'].forEach((v) {
        pregnancyHistory!.add(PregnancyHistory.fromJson(v));
      });
    }
    if (json['currently_pregnant'] != null) {
      currentlyPregnant = <CurrentlyPregnant>[];
      json['currently_pregnant'].forEach((v) {
        currentlyPregnant!.add(CurrentlyPregnant.fromJson(v));
      });
    }
  }
}

class PregnancyHistory {
  int? id;
  int? userId;
  String? status;
  String? hariPertamaHaidTerakhir;
  String? tanggalPerkiraanLahir;
  String? kehamilanAkhir;
  String? createdAt;
  String? updatedAt;

  PregnancyHistory(
      {this.id,
      this.userId,
      this.status,
      this.hariPertamaHaidTerakhir,
      this.tanggalPerkiraanLahir,
      this.kehamilanAkhir,
      this.createdAt,
      this.updatedAt});

  PregnancyHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    status = json['status'];
    hariPertamaHaidTerakhir = json['hari_pertama_haid_terakhir'];
    tanggalPerkiraanLahir = json['tanggal_perkiraan_lahir'];
    kehamilanAkhir = json['kehamilan_akhir'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

class CurrentlyPregnant {
  int? pregnancyId;
  String? status;
  String? hariPertamaHaidTerakhir;
  String? tanggalPerkiraanLahir;
  int? usiaKehamilan;
  List<WeeklyData>? weeklyData;

  CurrentlyPregnant(
      {this.pregnancyId,
      this.status,
      this.hariPertamaHaidTerakhir,
      this.tanggalPerkiraanLahir,
      this.usiaKehamilan,
      this.weeklyData});

  CurrentlyPregnant.fromJson(Map<String, dynamic> json) {
    pregnancyId = json['pregnancy_id'];
    status = json['status'];
    hariPertamaHaidTerakhir = json['hari_pertama_haid_terakhir'];
    tanggalPerkiraanLahir = json['tanggal_perkiraan_lahir'];
    usiaKehamilan = json['usia_kehamilan'];
    if (json['weekly_data'] != null) {
      weeklyData = <WeeklyData>[];
      json['weekly_data'].forEach((v) {
        weeklyData!.add(WeeklyData.fromJson(v));
      });
    }
  }
}

class WeeklyData {
  int? mingguKehamilan;
  int? trimester;
  int? mingguSisa;
  String? mingguLabel;
  String? tanggalAwalMinggu;
  String? tanggalAkhirMinggu;
  double? beratJanin;
  double? tinggiBadanJanin;
  String? poinUtama;
  String? ukuranBayi;
  String? perkembanganBayi;
  String? perubahanTubuh;
  String? gejalaUmum;
  String? tipsMingguan;
  String? bayiImgPath;
  String? ukuranBayiImgPath;

  WeeklyData({
    this.mingguKehamilan,
    this.trimester,
    this.mingguSisa,
    this.mingguLabel,
    this.tanggalAwalMinggu,
    this.tanggalAkhirMinggu,
    this.beratJanin,
    this.tinggiBadanJanin,
    this.poinUtama,
    this.ukuranBayi,
    this.perkembanganBayi,
    this.perubahanTubuh,
    this.gejalaUmum,
    this.tipsMingguan,
    this.bayiImgPath,
    this.ukuranBayiImgPath,
  });

  factory WeeklyData.fromJson(Map<String, dynamic> json) {
    return WeeklyData(
      mingguKehamilan: json['minggu_kehamilan'] as int?,
      trimester: json['trimester'] as int?,
      mingguSisa: json['minggu_sisa'] as int?,
      mingguLabel: json['minggu_label'] as String?,
      tanggalAwalMinggu: json['tanggal_awal_minggu'] as String?,
      tanggalAkhirMinggu: json['tanggal_akhir_minggu'] as String?,
      beratJanin: (json['berat_janin'] as num?)?.toDouble(),
      tinggiBadanJanin: (json['tinggi_badan_janin'] as num?)?.toDouble(),
      poinUtama: json['poin_utama'] as String?,
      ukuranBayi: json['ukuran_bayi'] as String?,
      perkembanganBayi: json['perkembangan_bayi'] as String?,
      perubahanTubuh: json['perubahan_tubuh'] as String?,
      gejalaUmum: json['gejala_umum'] as String?,
      tipsMingguan: json['tips_mingguan'] as String?,
      bayiImgPath: json['bayi_img_path'] as String?,
      ukuranBayiImgPath: json['ukuran_bayi_img_path'] as String?,
    );
  }
}
