class MasterFood {
  final int? id;
  final String? foodId;
  final String? foodEn;
  final String? descriptionId;
  final String? descriptionEn;
  final String? foodSafety;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MasterFood({
    this.id,
    this.foodId,
    this.foodEn,
    this.descriptionId,
    this.descriptionEn,
    this.foodSafety,
    this.createdAt,
    this.updatedAt,
  });

  factory MasterFood.fromJson(Map<String, dynamic> json) {
    return MasterFood(
      id: json['id'] as int?,
      foodId: json['food_id'] as String?,
      foodEn: json['food_en'] as String?,
      descriptionId: json['description_id'] as String?,
      descriptionEn: json['description_en'] as String?,
      foodSafety: json['food_safety'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'food_id': foodId,
      'food_en': foodEn,
      'description_id': descriptionId,
      'description_en': descriptionEn,
      'food_safety': foodSafety,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  MasterFood copyWith({
    int? id,
    String? foodId,
    String? foodEn,
    String? descriptionId,
    String? descriptionEn,
    String? foodSafety,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MasterFood(
      id: id ?? this.id,
      foodId: foodId ?? this.foodId,
      foodEn: foodEn ?? this.foodEn,
      descriptionId: descriptionId ?? this.descriptionId,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      foodSafety: foodSafety ?? this.foodSafety,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
