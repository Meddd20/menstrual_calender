import 'package:get/get.dart';

class InsightController extends GetxController {
  //Filter Chip Symptoms
  List<String> filterTags = [
    "Premenstrual Syndrome (PMS)",
    "Pregnancy",
    "Ovulation",
    "Menstruation",
    "Trying to conceive",
    "Fertility",
    "Sex",
    "Perimenopause",
    "Birth Control",
  ];

  var selectedTag = "".obs;
  String getSelectedTag() => selectedTag.value;
  void setSelectedTag(String value) {
    selectedTag.value = value;
    update();
  }
}
