class MasterPregnancy {
  final int? id;
  final int? mingguKehamilan;
  final int? beratJanin;
  final double? tinggiBadanJanin;
  final String? ukuranBayiId;
  final String? ukuranBayiEn;
  final String? poinUtamaId;
  final String? poinUtamaEn;
  final String? perkembanganBayiId;
  final String? perkembanganBayiEn;
  final String? perubahanTubuhId;
  final String? perubahanTubuhEn;
  final String? gejalaUmumId;
  final String? gejalaUmumEn;
  final String? tipsMingguanId;
  final String? tipsMingguanEn;
  final String? bayiImgPath;
  final String? ukuranBayiImgPath;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MasterPregnancy({
    this.id,
    this.mingguKehamilan,
    this.beratJanin,
    this.tinggiBadanJanin,
    this.ukuranBayiId,
    this.ukuranBayiEn,
    this.poinUtamaId,
    this.poinUtamaEn,
    this.perkembanganBayiId,
    this.perkembanganBayiEn,
    this.perubahanTubuhId,
    this.perubahanTubuhEn,
    this.gejalaUmumId,
    this.gejalaUmumEn,
    this.tipsMingguanId,
    this.tipsMingguanEn,
    this.bayiImgPath,
    this.ukuranBayiImgPath,
    this.createdAt,
    this.updatedAt,
  });

  factory MasterPregnancy.fromJson(Map<String, dynamic> json) {
    return MasterPregnancy(
      id: json['id'] as int?,
      mingguKehamilan: json['minggu_kehamilan'] as int?,
      beratJanin: json['berat_janin'] as int?,
      tinggiBadanJanin: (json['tinggi_badan_janin'] as num?)?.toDouble(),
      ukuranBayiId: json['ukuran_bayi_id'] as String?,
      ukuranBayiEn: json['ukuran_bayi_en'] as String?,
      poinUtamaId: json['poin_utama_id'] as String?,
      poinUtamaEn: json['poin_utama_en'] as String?,
      perkembanganBayiId: json['perkembangan_bayi_id'] as String?,
      perkembanganBayiEn: json['perkembangan_bayi_en'] as String?,
      perubahanTubuhId: json['perubahan_tubuh_id'] as String?,
      perubahanTubuhEn: json['perubahan_tubuh_en'] as String?,
      gejalaUmumId: json['gejala_umum_id'] as String?,
      gejalaUmumEn: json['gejala_umum_en'] as String?,
      tipsMingguanId: json['tips_mingguan_id'] as String?,
      tipsMingguanEn: json['tips_mingguan_en'] as String?,
      bayiImgPath: json['bayi_img_path'] as String?,
      ukuranBayiImgPath: json['ukuran_bayi_img_path'] as String?,
      createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'minggu_kehamilan': mingguKehamilan,
      'berat_janin': beratJanin,
      'tinggi_badan_janin': tinggiBadanJanin,
      'ukuran_bayi_id': ukuranBayiId,
      'ukuran_bayi_en': ukuranBayiEn,
      'poin_utama_id': poinUtamaId,
      'poin_utama_en': poinUtamaEn,
      'perkembangan_bayi_id': perkembanganBayiId,
      'perkembangan_bayi_en': perkembanganBayiEn,
      'perubahan_tubuh_id': perubahanTubuhId,
      'perubahan_tubuh_en': perubahanTubuhEn,
      'gejala_umum_id': gejalaUmumId,
      'gejala_umum_en': gejalaUmumEn,
      'tips_mingguan_id': tipsMingguanId,
      'tips_mingguan_en': tipsMingguanEn,
      'bayi_img_path': bayiImgPath,
      'ukuran_bayi_img_path': ukuranBayiImgPath,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  MasterPregnancy copyWith({
    int? id,
    int? mingguKehamilan,
    int? beratJanin,
    double? tinggiBadanJanin,
    String? ukuranBayiId,
    String? ukuranBayiEn,
    String? poinUtamaId,
    String? poinUtamaEn,
    String? perkembanganBayiId,
    String? perkembanganBayiEn,
    String? perubahanTubuhId,
    String? perubahanTubuhEn,
    String? gejalaUmumId,
    String? gejalaUmumEn,
    String? tipsMingguanId,
    String? tipsMingguanEn,
    String? bayiImgPath,
    String? ukuranBayiImgPath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MasterPregnancy(
      id: id ?? this.id,
      mingguKehamilan: mingguKehamilan ?? this.mingguKehamilan,
      beratJanin: beratJanin ?? this.beratJanin,
      tinggiBadanJanin: tinggiBadanJanin ?? this.tinggiBadanJanin,
      ukuranBayiId: ukuranBayiId ?? this.ukuranBayiId,
      ukuranBayiEn: ukuranBayiEn ?? this.ukuranBayiEn,
      poinUtamaId: poinUtamaId ?? this.poinUtamaId,
      poinUtamaEn: poinUtamaEn ?? this.poinUtamaEn,
      perkembanganBayiId: perkembanganBayiId ?? this.perkembanganBayiId,
      perkembanganBayiEn: perkembanganBayiEn ?? this.perkembanganBayiEn,
      perubahanTubuhId: perubahanTubuhId ?? this.perubahanTubuhId,
      perubahanTubuhEn: perubahanTubuhEn ?? this.perubahanTubuhEn,
      gejalaUmumId: gejalaUmumId ?? this.gejalaUmumId,
      gejalaUmumEn: gejalaUmumEn ?? this.gejalaUmumEn,
      tipsMingguanId: tipsMingguanId ?? this.tipsMingguanId,
      tipsMingguanEn: tipsMingguanEn ?? this.tipsMingguanEn,
      bayiImgPath: bayiImgPath ?? this.bayiImgPath,
      ukuranBayiImgPath: ukuranBayiImgPath ?? this.ukuranBayiImgPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
