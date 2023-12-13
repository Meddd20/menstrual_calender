import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final Rx<DateTime?> _selectedDate = Rx<DateTime?>(DateTime.now());
  DateTime? get selectedDate => _selectedDate.value;
  var temperatures = RxString("");
  var weights = RxString("");
  TextEditingController dailyNotes = TextEditingController();
  TextEditingController reminderName = TextEditingController();
  RxString notes = RxString('');

  void updateText(String text) {
    notes.value = text;
    update();
  }

  var wholeNumberTemperature = 36.obs;
  var decimalNumberTemperature = 0.obs;

  void onWholeNumberTemperatureChanged(int value) {
    wholeNumberTemperature.value = value;
    updateTemperature();
  }

  void onDecimalNumberTemperatureChanged(int value) {
    decimalNumberTemperature.value = value;
    updateTemperature();
  }

  void updateTemperature() {
    temperatures.value =
        "${wholeNumberTemperature.value}.${decimalNumberTemperature.value}";
  }

  var wholeNumberWeight = 70.obs;
  var decimalNumberWeight = 0.obs;

  void onWholeNumberWeightChanged(int value) {
    wholeNumberWeight.value = value;
    updateWeight();
  }

  void onDecimalNumberWeightChanged(int value) {
    decimalNumberWeight.value = value;
    updateWeight();
  }

  void updateWeight() {
    weights.value = "${wholeNumberWeight.value}.${decimalNumberWeight.value}";
  }

  var temperature = 0.obs;
  var temperatureDecimal = 0.obs;

  //Filter Chip Pregnancy Signs
  List<String> pregnancySigns = [
    "Mood swings",
    "Nipple changes",
    "Fatigue",
    "Cravings",
    "Tender breasts",
    "Food aversions",
    "Nausea",
    "Bloating",
    "Vomiting",
    "Cramps",
    "Frequent urination",
    "Dizziness",
  ];

  var _selectedPregnancySigns = List<String>.empty(growable: true).obs;
  getSelectedPregnancySigns() => _selectedPregnancySigns;
  setSelectedPregnancySigns(List<String> list) =>
      _selectedPregnancySigns.value = list;

  //Choice Chip Sex Activity
  List<String> sex_activity = [
    "Sex",
    "Didn't have sex",
    "Unprotected sex",
    "Protected sex"
  ];

  var selectedSexActivity = "".obs;
  String getSelectedSexActivity() => selectedSexActivity.value;
  void setSelectedSexActivity(String value) {
    selectedSexActivity.value = value;
    update();
  }

  //Filter Chip Symptoms
  List<String> symptoms = [
    "I'm okay",
    "Headache",
    "Swelling",
    "Dizziness",
    "Cramps",
    "Acne",
    "Insomnia",
    "Tender breasts",
    "Backache",
    "Vaginal pain",
    "Fatigue",
    "Frequent urination",
    "Nipple changes"
  ];

  var _selectedSymptoms = List<String>.empty(growable: true).obs;
  getSelectedSymptoms() => _selectedSymptoms;
  setSelectedSymptoms(List<String> list) => _selectedSymptoms.value = list;

  //Choice Chip Vaginal Discharge
  List<String> vaginal_discharge = [
    "No discharges",
    "Creamy",
    "Spotting",
    "Eggwhite",
    "Sticky",
    "Watery",
    "Unusual"
  ];

  var selectedVaginalDischarge = "".obs;
  String getSelectedVaginalDischarge() => selectedVaginalDischarge.value;
  void setSelectedVaginalDischarge(String value) {
    selectedVaginalDischarge.value = value;
    update();
  }

  List<String> moods = [
    "Happy",
    "Sensitive",
    "Anxious",
    "Mood swings",
    "Emotional",
    "Irritated",
    "Calm",
    "Sad",
    "Energetic"
  ];

  var _selectedMoods = List<String>.empty(growable: true).obs;
  getSelectedMoods() => _selectedMoods;
  setSelectedMoods(List<String> list) => _selectedMoods.value = list;

  List<String> others = [
    "Travel",
    "Stress",
    "Meditation",
    "Disease or injury",
    "Alcohol",
    "Kegel exercise"
  ];

  var _selectedOthers = List<String>.empty(growable: true).obs;
  getSelectedOthers() => _selectedOthers;
  setSelectedOthers(List<String> list) => _selectedOthers.value = list;

  void setSelectedDate(DateTime selectedDate) {
    _selectedDate.value = selectedDate;
    update();
  }

  final List<NeatCleanCalendarEvent> _menstruationCycle = [
    NeatCleanCalendarEvent(
      'Menstruation',
      startTime: DateTime(DateTime.now().year, DateTime.now().month, 10, 0),
      endTime: DateTime(DateTime.now().year, DateTime.now().month, 20, 12, 0),
      color: Color(0xFFFF6A6A),
      isAllDay: true,
      isMultiDay: true,
    ),
    NeatCleanCalendarEvent(
      'Menstruation',
      startTime: DateTime(DateTime.now().year, 12, 12),
      endTime: DateTime(DateTime.now().year, 12, 13),
      color: Color(0xFF88E6BF),
      isAllDay: true,
      isMultiDay: true,
    ),
  ];
  List<NeatCleanCalendarEvent> getMenstruationCycle() => _menstruationCycle;
}
