class PregnancyWeightGain {
  String? status;
  String? message;
  Data? data;

  PregnancyWeightGain({this.status, this.message, this.data});

  PregnancyWeightGain.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
}

class Data {
  double? prepregnancyWeight;
  double? currentWeight;
  double? totalGain;
  double? prepregnancyBmi;
  String? bmiCategory;
  String? isTwin;
  String? currentWeekReccomendWeight;
  String? nextWeekReccomendWeight;
  List<WeightHistory>? weightHistory;
  List<ReccomendWeightGain>? reccomendWeightGain;

  Data(
      {this.prepregnancyWeight,
      this.currentWeight,
      this.totalGain,
      this.prepregnancyBmi,
      this.bmiCategory,
      this.isTwin,
      this.currentWeekReccomendWeight,
      this.nextWeekReccomendWeight,
      this.weightHistory,
      this.reccomendWeightGain});

  Data.fromJson(Map<String, dynamic> json) {
    prepregnancyWeight = (json['prepregnancy_weight'] as num?)?.toDouble();
    currentWeight = (json['current_weight'] as num?)?.toDouble();
    totalGain = (json['total_gain'] as num?)?.toDouble();
    prepregnancyBmi = (json['prepregnancy_bmi'] as num?)?.toDouble();
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
      reccomendWeightGain = <ReccomendWeightGain>[];
      json['reccomend_weight_gain'].forEach((v) {
        reccomendWeightGain!.add(new ReccomendWeightGain.fromJson(v));
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
    beratBadan =
        (json['berat_badan'] as num?)?.toDouble(); // Handle int and double
    mingguKehamilan = json['minggu_kehamilan'];
    tanggalPencatatan = json['tanggal_pencatatan'];
    pertambahanBerat = (json['pertambahan_berat'] as num?)
        ?.toDouble(); // Handle int and double
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

class ReccomendWeightGain {
  int? week;
  double? lowerWeightGain;
  double? upperWeightGain;
  double? reccomendWeightLower;
  double? reccomendWeightUpper;

  ReccomendWeightGain({
    this.week,
    this.lowerWeightGain,
    this.upperWeightGain,
    this.reccomendWeightLower,
    this.reccomendWeightUpper
  });

  ReccomendWeightGain.fromJson(Map<String, dynamic> json) {
    week = json['week'];
    lowerWeightGain = (json['lower_weight_gain'] as num?)?.toDouble();
    upperWeightGain = (json['upper_weight_gain'] as num?)?.toDouble();
    reccomendWeightLower = (json['reccomend_weight_lower'] as num?)?.toDouble();
    reccomendWeightUpper = (json['reccomend_weight_upper'] as num?)?.toDouble();
  }
}
