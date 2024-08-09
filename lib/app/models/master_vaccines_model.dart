class MasterVaccine {
  final int? id;
  final String? vaccinesId;
  final String? vaccinesEn;
  final String? descriptionId;
  final String? descriptionEn;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MasterVaccine({
    this.id,
    this.vaccinesId,
    this.vaccinesEn,
    this.descriptionId,
    this.descriptionEn,
    this.createdAt,
    this.updatedAt,
  });

  factory MasterVaccine.fromJson(Map<String, dynamic> json) {
    return MasterVaccine(
      id: json['id'] as int?,
      vaccinesId: json['vaccines_id'] as String?,
      vaccinesEn: json['vaccines_en'] as String?,
      descriptionId: json['description_id'] as String?,
      descriptionEn: json['description_en'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vaccines_id': vaccinesId,
      'vaccines_en': vaccinesEn,
      'description_id': descriptionId,
      'description_en': descriptionEn,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  MasterVaccine copyWith({
    int? id,
    String? vaccinesId,
    String? vaccinesEn,
    String? descriptionId,
    String? descriptionEn,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MasterVaccine(
      id: id ?? this.id,
      vaccinesId: vaccinesId ?? this.vaccinesId,
      vaccinesEn: vaccinesEn ?? this.vaccinesEn,
      descriptionId: descriptionId ?? this.descriptionId,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
