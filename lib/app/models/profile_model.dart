class Profile {
  String? status;
  String? message;
  User? user;

  Profile({this.status, this.message, this.user});

  Profile.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    user = json['user'] != null ? User?.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (user != null) {
      data['user'] = user?.toJson();
    }
    return data;
  }
}

class User {
  String? id;
  String? status;
  String? role;
  String? nama;
  String? tanggalLahir;
  String? isPregnant;
  String? email;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

  User(
      {this.id,
      this.status,
      this.role,
      this.nama,
      this.tanggalLahir,
      this.isPregnant,
      this.email,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    role = json['role'];
    nama = json['nama'];
    tanggalLahir = json['tanggal_lahir'];
    isPregnant = json['is_pregnant'];
    email = json['email'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['role'] = role;
    data['nama'] = nama;
    data['tanggal_lahir'] = tanggalLahir;
    data['is_pregnant'] = isPregnant;
    data['email'] = email;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}
