class MasterNewmoonPhase {
  int? id;
  int? year;
  String? newMoon;

  MasterNewmoonPhase({this.id, this.year, this.newMoon});

  factory MasterNewmoonPhase.fromJson(Map<String, dynamic> json) {
    return MasterNewmoonPhase(
      id: json['id'] as int?,
      year: json['year'] as int?,
      newMoon: json['new_moon'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'year': year,
      'new_moon': newMoon,
    };
    return data;
  }

  MasterNewmoonPhase copyWith({
    required int? id,
    required int? year,
    required String? newMoon,
  }) {
    return MasterNewmoonPhase(
      id: id ?? this.id,
      year: year ?? this.year,
      newMoon: newMoon ?? this.newMoon,
    );
  }
}
