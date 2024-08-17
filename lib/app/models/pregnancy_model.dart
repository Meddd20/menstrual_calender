class PregnancyHistory {
  int? id;
  int? userId;
  int? remoteId;
  String? status;
  String? hariPertamaHaidTerakhir;
  String? tanggalPerkiraanLahir;
  String? kehamilanAkhir;
  double? tinggiBadan;
  double? beratPrakehamilan;
  double? bmiPrakehamilan;
  String? kategoriBmi;
  String? gender;
  String? isTwin;
  String? createdAt;
  String? updatedAt;

  PregnancyHistory({
    this.id,
    this.userId,
    this.remoteId,
    this.status,
    this.hariPertamaHaidTerakhir,
    this.tanggalPerkiraanLahir,
    this.kehamilanAkhir,
    this.tinggiBadan,
    this.beratPrakehamilan,
    this.bmiPrakehamilan,
    this.kategoriBmi,
    this.gender,
    this.isTwin,
    this.createdAt,
    this.updatedAt,
  });

  PregnancyHistory.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['user_id'],
        remoteId = json['remote_id'],
        status = json['status'],
        hariPertamaHaidTerakhir = json['hari_pertama_haid_terakhir'],
        tanggalPerkiraanLahir = json['tanggal_perkiraan_lahir'],
        kehamilanAkhir = json['kehamilan_akhir'],
        tinggiBadan = json['tinggi_badan']?.toDouble(),
        beratPrakehamilan = json['berat_prakehamilan']?.toDouble(),
        bmiPrakehamilan = json['bmi_prakehamilan']?.toDouble(),
        kategoriBmi = json['kategori_bmi'],
        gender = json['gender'],
        isTwin = json['is_twin'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'user_id': userId,
      'remote_id': remoteId,
      'status': status,
      'hari_pertama_haid_terakhir': hariPertamaHaidTerakhir,
      'tanggal_perkiraan_lahir': tanggalPerkiraanLahir,
      'kehamilan_akhir': kehamilanAkhir,
      'tinggi_badan': tinggiBadan,
      'berat_prakehamilan': beratPrakehamilan,
      'bmi_prakehamilan': bmiPrakehamilan,
      'kategori_bmi': kategoriBmi,
      'gender': gender,
      'is_twin': isTwin,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
    return data;
  }

  PregnancyHistory copyWith({
    int? id,
    int? userId,
    int? remoteId,
    String? status,
    String? hariPertamaHaidTerakhir,
    String? tanggalPerkiraanLahir,
    String? kehamilanAkhir,
    double? tinggiBadan,
    double? beratPrakehamilan,
    double? bmiPrakehamilan,
    String? kategoriBmi,
    String? gender,
    String? isTwin,
    String? createdAt,
    String? updatedAt,
  }) {
    return PregnancyHistory(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      remoteId: remoteId ?? this.remoteId,
      status: status ?? this.status,
      hariPertamaHaidTerakhir: hariPertamaHaidTerakhir ?? this.hariPertamaHaidTerakhir,
      tanggalPerkiraanLahir: tanggalPerkiraanLahir ?? this.tanggalPerkiraanLahir,
      kehamilanAkhir: kehamilanAkhir ?? this.kehamilanAkhir,
      tinggiBadan: tinggiBadan ?? this.tinggiBadan,
      beratPrakehamilan: beratPrakehamilan ?? this.beratPrakehamilan,
      bmiPrakehamilan: bmiPrakehamilan ?? this.bmiPrakehamilan,
      kategoriBmi: kategoriBmi ?? this.kategoriBmi,
      gender: gender ?? this.gender,
      isTwin: isTwin ?? this.isTwin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CurrentlyPregnant {
  int? pregnancyId;
  String? status;
  String? hariPertamaHaidTerakhir;
  String? tanggalPerkiraanLahir;
  int? usiaKehamilan;
  List<WeeklyData>? weeklyData;

  CurrentlyPregnant({
    this.pregnancyId,
    this.status,
    this.hariPertamaHaidTerakhir,
    this.tanggalPerkiraanLahir,
    this.usiaKehamilan,
    this.weeklyData,
  });

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
  int? beratJanin;
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
      beratJanin: (json['berat_janin'] as num?)?.toInt(),
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

  WeeklyData copyWith({
    int? mingguKehamilan,
    int? trimester,
    int? mingguSisa,
    String? mingguLabel,
    String? tanggalAwalMinggu,
    String? tanggalAkhirMinggu,
    int? beratJanin,
    double? tinggiBadanJanin,
    String? poinUtama,
    String? ukuranBayi,
    String? perkembanganBayi,
    String? perubahanTubuh,
    String? gejalaUmum,
    String? tipsMingguan,
    String? bayiImgPath,
    String? ukuranBayiImgPath,
  }) {
    return WeeklyData(
      mingguKehamilan: mingguKehamilan ?? this.mingguKehamilan,
      trimester: trimester ?? this.trimester,
      mingguSisa: mingguSisa ?? this.mingguSisa,
      mingguLabel: mingguLabel ?? this.mingguLabel,
      tanggalAwalMinggu: tanggalAwalMinggu ?? this.tanggalAwalMinggu,
      tanggalAkhirMinggu: tanggalAkhirMinggu ?? this.tanggalAkhirMinggu,
      beratJanin: beratJanin ?? this.beratJanin,
      tinggiBadanJanin: tinggiBadanJanin ?? this.tinggiBadanJanin,
      poinUtama: poinUtama ?? this.poinUtama,
      ukuranBayi: ukuranBayi ?? this.ukuranBayi,
      perkembanganBayi: perkembanganBayi ?? this.perkembanganBayi,
      perubahanTubuh: perubahanTubuh ?? this.perubahanTubuh,
      gejalaUmum: gejalaUmum ?? this.gejalaUmum,
      tipsMingguan: tipsMingguan ?? this.tipsMingguan,
      bayiImgPath: bayiImgPath ?? this.bayiImgPath,
      ukuranBayiImgPath: ukuranBayiImgPath ?? this.ukuranBayiImgPath,
    );
  }
}
