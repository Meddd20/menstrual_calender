class Profile {
  String? status;
  String? message;
  User? user;

  Profile({this.status, this.message, this.user});

  Profile.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    user = json['data'] != null ? new User.fromJson(json['data']) : null;
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
  String? token;
  String? deviceToken;
  String? createdAt;
  String? updatedAt;

  User({this.id, this.status, this.role, this.nama, this.tanggalLahir, this.isPregnant, this.email, this.token, this.deviceToken, this.createdAt, this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    role = json['role'];
    nama = json['nama'];
    tanggalLahir = json['tanggal_lahir'];
    isPregnant = json['is_pregnant'];
    email = json['email'];
    token = json['token'];
    deviceToken = json['device_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['role'] = this.role;
    data['nama'] = this.nama;
    data['tanggal_lahir'] = this.tanggalLahir;
    data['is_pregnant'] = this.isPregnant;
    data['email'] = this.email;
    data['token'] = this.token;
    data['device_token'] = this.deviceToken;
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
    String? token,
    String? deviceToken,
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
      token: token ?? this.token,
      deviceToken: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
