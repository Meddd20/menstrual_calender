class Reminder {
  String? status;
  String? message;
  List<Reminders>? data;

  Reminder({this.status, this.message, this.data});

  Reminder.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Reminders>[];
      json['data'].forEach((v) {
        data!.add(Reminders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Reminder copyWith({
    String? status,
    String? message,
    List<Reminders>? data,
  }) {
    return Reminder(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}

class Reminders {
  String? id;
  String? remoteId;
  String? title;
  String? datetime;
  String? description;

  Reminders({this.id, this.remoteId, this.title, this.datetime, this.description});

  Reminders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    remoteId = json['remoteId'];
    title = json['title'];
    datetime = json['datetime'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['remoteId'] = this.remoteId;
    data['title'] = this.title;
    data['datetime'] = this.datetime;
    data['description'] = this.description;
    return data;
  }

  Reminders copyWith({
    String? id,
    String? remoteId,
    String? title,
    String? datetime,
    String? description,
  }) {
    return Reminders(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      title: title ?? this.title,
      datetime: datetime ?? this.datetime,
      description: description ?? this.description,
    );
  }
}
