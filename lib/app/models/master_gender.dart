class MasterGender {
  int? id;
  int? usia;
  int? bulan;
  String? gender;

  MasterGender({
    this.id,
    this.usia,
    this.bulan,
    this.gender,
  });

  MasterGender.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    usia = json['usia'];
    bulan = json['bulan'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['usia'] = this.usia;
    data['bulan'] = this.bulan;
    data['gender'] = this.gender;
    return data;
  }

  MasterGender copyWith({
    required int? id,
    required int? usia,
    required int? bulan,
    required String? gender,
  }) {
    return MasterGender(
      id: id ?? this.id,
      usia: usia ?? this.usia,
      bulan: bulan ?? this.bulan,
      gender: gender ?? this.gender,
    );
  }
}
