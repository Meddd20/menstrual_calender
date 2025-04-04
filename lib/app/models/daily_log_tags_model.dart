class DailyLogTagsData {
  String tags;
  Map<String, dynamic> logs;
  dynamic percentage30Days;
  dynamic percentage3Months;
  dynamic percentage6Months;
  dynamic percentage1Year;

  DailyLogTagsData({
    required this.tags,
    required this.logs,
    required this.percentage30Days,
    required this.percentage3Months,
    required this.percentage6Months,
    required this.percentage1Year,
  });

  factory DailyLogTagsData.fromJson(Map<String, dynamic> json) {
    return DailyLogTagsData(
      tags: json['tags'],
      logs: json['logs'],
      percentage30Days: json['percentage_30days'],
      percentage3Months: json['percentage_3months'],
      percentage6Months: json['percentage_6months'],
      percentage1Year: json['percentage_1year'],
    );
  }
}
