class SyncLog {
  final int? id;
  final String tableName;
  final String operation;
  final int? dataId;
  final String? optionalId;
  final String createdAt;

  SyncLog({
    this.id,
    required this.tableName,
    required this.operation,
    this.dataId,
    this.optionalId,
    required this.createdAt,
  });

  factory SyncLog.fromJson(Map<String, dynamic> json) {
    return SyncLog(
      id: json['id'] as int?,
      tableName: json['table_name'] as String,
      operation: json['operation'] as String,
      dataId: json['data_id'] as int?,
      optionalId: json['optional_id'] as String?,
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'table_name': tableName,
      'operation': operation,
      'data_id': dataId,
      'optional_id': dataId,
      'created_at': createdAt,
    };
  }

  SyncLog copyWith({
    int? id,
    String? tableName,
    String? operation,
    int? dataId,
    String? optionalId,
    String? createdAt,
  }) {
    return SyncLog(
      id: id ?? this.id,
      tableName: tableName ?? this.tableName,
      operation: operation ?? this.operation,
      dataId: dataId ?? this.dataId,
      optionalId: optionalId ?? this.optionalId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
