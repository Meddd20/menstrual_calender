class MasterNewmoon {
  int? id;
  int? lunarMonth;
  String? newMoon;
  String? shio;

  MasterNewmoon({this.id, this.lunarMonth, this.newMoon, this.shio});

  factory MasterNewmoon.fromJson(Map<String, dynamic> json) {
    return MasterNewmoon(
      id: json['id'] as int?,
      lunarMonth: json['lunar_month'] as int?,
      newMoon: json['new_moon'] as String?,
      shio: json['shio'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'lunar_month': lunarMonth,
      'new_moon': newMoon,
      'shio': shio,
    };
    return data;
  }

  MasterNewmoon copyWith({
    required int? id,
    required int? lunarMonth,
    required String? newMoon,
    required String? shio,
  }) {
    return MasterNewmoon(
      id: id ?? this.id,
      lunarMonth: lunarMonth ?? this.lunarMonth,
      newMoon: newMoon ?? this.newMoon,
      shio: shio ?? this.shio,
    );
  }
}
