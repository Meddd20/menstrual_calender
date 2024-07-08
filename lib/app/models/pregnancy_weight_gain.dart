class PregnancyWeightGain {
  String? status;
  String? message;
  PregnancyWeightGainData? data;

  PregnancyWeightGain({this.status, this.message, this.data});

  PregnancyWeightGain.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new PregnancyWeightGainData.fromJson(json['data'])
        : null;
  }
}

class PregnancyWeightGainData {
  int? week;
  double? prepregnancyWeight;
  double? currentWeight;
  double? totalGain;
  double? prepregnancyBmi;
  double? prepregnancyHeight;
  String? bmiCategory;
  String? isTwin;
  String? currentWeekReccomendWeight;
  String? nextWeekReccomendWeight;
  List<WeightHistory>? weightHistory;
  List<RecommendWeightGain>? reccomendWeightGain;

  PregnancyWeightGainData(
      {this.week,
      this.prepregnancyWeight,
      this.currentWeight,
      this.totalGain,
      this.prepregnancyBmi,
      this.prepregnancyHeight,
      this.bmiCategory,
      this.isTwin,
      this.currentWeekReccomendWeight,
      this.nextWeekReccomendWeight,
      this.weightHistory,
      this.reccomendWeightGain});

  PregnancyWeightGainData.fromJson(Map<String, dynamic> json) {
    week = json['week'];
    prepregnancyWeight = (json['prepregnancy_weight'] as num?)?.toDouble();
    currentWeight = (json['current_weight'] as num?)?.toDouble();
    totalGain = (json['total_gain'] as num?)?.toDouble();
    prepregnancyBmi = (json['prepregnancy_bmi'] as num?)?.toDouble();
    prepregnancyHeight = (json['prepregnancy_height'] as num?)?.toDouble();
    bmiCategory = json['bmi_category'];
    isTwin = json['is_twin'];
    currentWeekReccomendWeight = json['current_week_reccomend_weight'];
    nextWeekReccomendWeight = json['next_week_reccomend_weight'];
    if (json['weight_history'] != null) {
      weightHistory = <WeightHistory>[];
      json['weight_history'].forEach((v) {
        weightHistory!.add(new WeightHistory.fromJson(v));
      });
    }
    if (json['reccomend_weight_gain'] != null) {
      reccomendWeightGain = <RecommendWeightGain>[];
      json['reccomend_weight_gain'].forEach((v) {
        reccomendWeightGain!.add(new RecommendWeightGain.fromJson(v));
      });
    }
  }
}

class WeightHistory {
  int? id;
  int? userId;
  int? riwayatKehamilanId;
  double? beratBadan;
  int? mingguKehamilan;
  String? tanggalPencatatan;
  double? pertambahanBerat;
  String? createdAt;
  String? updatedAt;

  WeightHistory(
      {this.id,
      this.userId,
      this.riwayatKehamilanId,
      this.beratBadan,
      this.mingguKehamilan,
      this.tanggalPencatatan,
      this.pertambahanBerat,
      this.createdAt,
      this.updatedAt});

  WeightHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    riwayatKehamilanId = json['riwayat_kehamilan_id'];
    beratBadan = (json['berat_badan'] as num?)?.toDouble();
    mingguKehamilan = json['minggu_kehamilan'];
    tanggalPencatatan = json['tanggal_pencatatan'];
    pertambahanBerat = (json['pertambahan_berat'] as num?)?.toDouble();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['riwayat_kehamilan_id'] = this.riwayatKehamilanId;
    data['berat_badan'] = this.beratBadan;
    data['minggu_kehamilan'] = this.mingguKehamilan;
    data['tanggal_pencatatan'] = this.tanggalPencatatan;
    data['pertambahan_berat'] = this.pertambahanBerat;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }

  WeightHistory copyWith({
    int? id,
    int? userId,
    int? riwayatKehamilanId,
    double? beratBadan,
    int? mingguKehamilan,
    String? tanggalPencatatan,
    double? pertambahanBerat,
    String? createdAt,
    String? updatedAt,
  }) {
    return WeightHistory(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      riwayatKehamilanId: riwayatKehamilanId ?? this.riwayatKehamilanId,
      beratBadan: beratBadan ?? this.beratBadan,
      mingguKehamilan: mingguKehamilan ?? this.mingguKehamilan,
      tanggalPencatatan: tanggalPencatatan ?? this.tanggalPencatatan,
      pertambahanBerat: pertambahanBerat ?? this.pertambahanBerat,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class RecommendWeightGain {
  int? week;
  double? lowerWeightGain;
  double? upperWeightGain;
  double? recommendWeightLower;
  double? recommendWeightUpper;

  RecommendWeightGain(
      {this.week,
      this.lowerWeightGain,
      this.upperWeightGain,
      this.recommendWeightLower,
      this.recommendWeightUpper});

  RecommendWeightGain.fromJson(Map<String, dynamic> json) {
    week = json['week'];
    lowerWeightGain = (json['lower_weight_gain'] as num?)?.toDouble();
    upperWeightGain = (json['upper_weight_gain'] as num?)?.toDouble();
    recommendWeightLower = (json['reccomend_weight_lower'] as num?)?.toDouble();
    recommendWeightUpper = (json['reccomend_weight_upper'] as num?)?.toDouble();
  }
}
