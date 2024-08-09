class MasterVitamin {
  final int? id;
  final String? vitaminsId;
  final String? vitaminsEn;
  final String? descriptionId;
  final String? descriptionEn;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MasterVitamin({
    this.id,
    this.vitaminsId,
    this.vitaminsEn,
    this.descriptionId,
    this.descriptionEn,
    this.createdAt,
    this.updatedAt,
  });

  factory MasterVitamin.fromJson(Map<String, dynamic> json) {
    return MasterVitamin(
      id: json['id'] as int?,
      vitaminsId: json['vitamins_id'] as String?,
      vitaminsEn: json['vitamins_en'] as String?,
      descriptionId: json['description_id'] as String?,
      descriptionEn: json['description_en'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vitamins_id': vitaminsId,
      'vitamins_en': vitaminsEn,
      'description_id': descriptionId,
      'description_en': descriptionEn,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  MasterVitamin copyWith({
    int? id,
    String? vitaminsId,
    String? vitaminsEn,
    String? descriptionId,
    String? descriptionEn,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MasterVitamin(
      id: id ?? this.id,
      vitaminsId: vitaminsId ?? this.vitaminsId,
      vitaminsEn: vitaminsEn ?? this.vitaminsEn,
      descriptionId: descriptionId ?? this.descriptionId,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
