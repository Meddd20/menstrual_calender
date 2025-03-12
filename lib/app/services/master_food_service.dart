import 'package:periodnpregnancycalender/app/repositories/repositories.dart';
import 'package:periodnpregnancycalender/app/models/models.dart';

class MasterFoodService {
  late final MasterFoodRepository _masterFoodRepository = MasterFoodRepository();

  Future<List<MasterFood>> getAllFood(String? foodSafety) async {
    return await _masterFoodRepository.getAllFood(foodSafety);
  }

  Future<MasterFood?> getFoodById(int? id) async {
    return await _masterFoodRepository.getFoodById(id);
  }

  Future<void> addAllFood(List<MasterFood> foods) async {
    await _masterFoodRepository.addAllFood(foods);
  }
}
