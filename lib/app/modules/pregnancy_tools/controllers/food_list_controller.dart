import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:periodnpregnancycalender/app/utils/utils.dart';
import 'package:periodnpregnancycalender/app/services/services.dart';
import 'package:periodnpregnancycalender/app/models/models.dart';

class FoodListController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  late final MasterFoodService _masterFoodService;
  final RxList<MasterFood> foodList = <MasterFood>[].obs;
  final StorageService storageService = StorageService();
  final RxList<MasterFood> filteredFoodList = <MasterFood>[].obs;

  @override
  void onInit() {
    _masterFoodService = MasterFoodService();
    getAllFoodList(null);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> getAllFoodList(String? foodSafety) async {
    List<MasterFood> fetchedFoodList = await _masterFoodService.getAllFood(foodSafety);
    foodList.assignAll(fetchedFoodList);
    filteredFoodList.assignAll(fetchedFoodList);
  }

  List<String> filterTags = [
    "Unsafe",
    "Caution",
    "Safe",
  ];

  Map<String, String> getFilterTag(BuildContext context) {
    return {
      "Unsafe": AppLocalizations.of(context)!.unsafe,
      "Caution": AppLocalizations.of(context)!.caution,
      "Safe": AppLocalizations.of(context)!.safe,
    };
  }

  var selectedTag = "".obs;
  String getSelectedTag() => selectedTag.value;

  void setSelectedTag(String value) {
    selectedTag.value = value;
    if (value != "") {
      getAllFoodList(selectedTag.value);
    } else {
      getAllFoodList(null);
    }

    update();
  }

  void searchFood(String query) {
    if (query.isEmpty) {
      filteredFoodList.assignAll(foodList);
    } else {
      filteredFoodList.assignAll(foodList.where((food) {
        final foodIdName = food.foodId?.toLowerCase() ?? '';
        final foodEnName = food.foodEn?.toLowerCase() ?? '';
        final searchLower = query.toLowerCase();
        print(searchLower);
        return foodIdName.contains(searchLower) || foodEnName.contains(searchLower);
      }).toList());
    }
  }
}
