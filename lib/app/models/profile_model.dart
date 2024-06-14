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
}

class User {
  int? id;
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
}
