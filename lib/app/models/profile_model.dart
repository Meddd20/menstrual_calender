class Profile {
  String? status;
  String? message;
  UserData? userData;

  Profile({this.status, this.message, this.userData});

  Profile.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userData = json['data'] != null ? new UserData.fromJson(json['data']) : null;
  }
}

class UserData {
  Credential? credential;
  User? user;

  UserData({
    this.credential,
    this.user,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    credential = json['credential'] != null ? new Credential.fromJson(json['credential']) : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }
}

class Credential {
  int? userId;
  String? token;
  int? id;

  Credential({this.userId, this.token, this.id});

  Credential.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    token = json['token'];
    id = json['id'];
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

  User({this.id, this.status, this.role, this.nama, this.tanggalLahir, this.isPregnant, this.email, this.createdAt, this.updatedAt});

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
  }

  Map<String, dynamic> toJson({bool includeRole = false, bool includeEmail = false}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    if (includeRole) {
      data['role'] = this.role;
    }
    data['nama'] = this.nama;
    data['tanggal_lahir'] = this.tanggalLahir;
    data['is_pregnant'] = this.isPregnant;
    if (includeEmail) {
      data['email'] = this.email;
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }

  User copyWith({
    int? id,
    String? status,
    String? role,
    String? nama,
    String? tanggalLahir,
    String? isPregnant,
    String? email,
    String? createdAt,
    String? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      status: status ?? this.status,
      role: role ?? this.role,
      nama: nama ?? this.nama,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      isPregnant: isPregnant ?? this.isPregnant,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
