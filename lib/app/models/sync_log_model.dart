class SyncLog {
  int? id;
  String? tableName;
  String? operation;
  String? data;
  String? createdAt;

  SyncLog({
    this.id,
    this.tableName,
    this.operation,
    this.data,
    this.createdAt,
  });

  SyncLog.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tableName = json['table_name'];
    operation = json['operation'];
    data = json['data'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['table_name'] = this.tableName;
    data['operation'] = this.operation;
    data['data'] = this.data;
    data['created_at'] = this.createdAt;
    return data;
  }

  SyncLog copyWith({
    required int? id,
    required String? tableName,
    required String? operation,
    required String? data,
    required String? createdAt,
  }) {
    return SyncLog(
      id: id ?? this.id,
      tableName: tableName ?? this.tableName,
      operation: operation ?? this.operation,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
