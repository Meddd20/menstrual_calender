class MasterDataVersion {
  int id;
  int majorVersion;
  int minorVersion;
  String masterTable;
  String createdAt;
  String updatedAt;

  MasterDataVersion({
    required this.id,
    required this.majorVersion,
    required this.minorVersion,
    required this.masterTable,
    required this.createdAt,
    required this.updatedAt,
  });

  MasterDataVersion.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        majorVersion = json['major_version'],
        minorVersion = json['minor_version'],
        masterTable = json['master_table'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'major_version': majorVersion,
      'minor_version': minorVersion,
      'master_table': masterTable,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
