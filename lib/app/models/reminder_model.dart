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
        data!.add(new Reminders.fromJson(v));
      });
    }
  }
}

class Reminders {
  String? id;
  String? title;
  String? datetime;
  String? description;

  Reminders({this.id, this.title, this.datetime, this.description});

  Reminders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    datetime = json['datetime'];
    description = json['description'];
  }
}
