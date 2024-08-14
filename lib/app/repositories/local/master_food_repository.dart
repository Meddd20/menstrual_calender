import 'package:logger/logger.dart';
import 'package:periodnpregnancycalender/app/models/master_food_model.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';

class MasterFoodRepository {
  final DatabaseHelper _databaseHelper;
  final Logger _logger = Logger();

  MasterFoodRepository(this._databaseHelper);

  Future<List<MasterFood>> getAllFood(String? foodSafety) async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> getAllFoods;
      if (foodSafety == null) {
        getAllFoods = await db.query(
          "tb_master_food",
        );
      } else {
        getAllFoods = await db.query(
          "tb_master_food",
          where: 'food_safety = ?',
          whereArgs: [foodSafety],
        );
      }

      return List.generate(getAllFoods.length, (i) {
        return MasterFood.fromJson(getAllFoods[i]);
      });
    } catch (e) {
      _logger.e("Error during get all food: $e");
      rethrow;
    }
  }

  Future<MasterFood?> getFoodById(int? id) async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> getFood = await db.query(
        "tb_master_food",
        where: 'id = ?',
        whereArgs: [id],
      );
      if (getFood.isNotEmpty) {
        return MasterFood.fromJson(getFood.first);
      }
      return null;
    } catch (e) {
      _logger.e("Error during get food by id: $e");
      rethrow;
    }
  }

  Future<void> addFood(MasterFood food) async {
    final db = await _databaseHelper.database;
    try {
      await db.insert("tb_master_food", food.toJson());
    } catch (e) {
      _logger.e("Error during add food: $e");
      rethrow;
    }
  }

  Future<void> editFood(MasterFood food) async {
    final db = await _databaseHelper.database;
    try {
      await db.update(
        "tb_master_food",
        food.toJson(),
        where: 'id = ?',
        whereArgs: [food.id],
      );
    } catch (e) {
      _logger.e("Error during edit food: $e");
      rethrow;
    }
  }

  Future<void> deleteFood(int id) async {
    final db = await _databaseHelper.database;
    try {
      await db.delete(
        "tb_master_food",
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      _logger.e("Error during delete food: $e");
      rethrow;
    }
  }
}
