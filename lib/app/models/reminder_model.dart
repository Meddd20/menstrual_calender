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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['datetime'] = this.datetime;
    data['description'] = this.description;
    return data;
  }

  Reminders copyWith({
    String? id,
    String? title,
    String? datetime,
    String? description,
  }) {
    return Reminders(
      id: id ?? this.id,
      title: title ?? this.title,
      datetime: datetime ?? this.datetime,
      description: description ?? this.description,
    );
  }
}
