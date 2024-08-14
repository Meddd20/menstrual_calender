import 'package:periodnpregnancycalender/app/models/master_food_model.dart';
import 'package:periodnpregnancycalender/app/repositories/local/master_food_repository.dart';

class MasterFoodService {
  final MasterFoodRepository _masterFoodRepository;

  MasterFoodService(this._masterFoodRepository);

  Future<List<MasterFood>> getAllFood(String? foodSafety) async {
    return await _masterFoodRepository.getAllFood(foodSafety);
  }

  Future<MasterFood?> getFoodById(int? id) async {
    return await _masterFoodRepository.getFoodById(id);
  }

  Future<void> addFood(MasterFood food) async {
    await _masterFoodRepository.addFood(food);
  }

  Future<void> editFood(MasterFood food) async {
    MasterFood? editedFood = await getFoodById(food.id);
    if (editedFood != null) {
      MasterFood updatedFood = editedFood.copyWith(
        id: food.id,
        foodId: food.foodId,
        foodEn: food.foodEn,
        descriptionId: food.descriptionId,
        descriptionEn: food.descriptionEn,
        foodSafety: food.foodSafety,
        updatedAt: food.updatedAt,
      );
      await _masterFoodRepository.editFood(updatedFood);
    } else {
      throw Exception('Food edited not found');
    }
  }

  Future<void> deleteFood(int id) async {
    await _masterFoodRepository.deleteFood(id);
  }
}
