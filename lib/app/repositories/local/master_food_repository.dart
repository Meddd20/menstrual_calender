import 'package:logger/logger.dart';

import 'package:periodnpregnancycalender/app/utils/utils.dart';
import 'package:periodnpregnancycalender/app/models/models.dart';
import 'package:sqflite/sqflite.dart';

class MasterFoodRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final Logger _logger = Logger();

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

  Future<void> addAllFood(List<MasterFood> foods) async {
    final db = await _databaseHelper.database;
    await db.transaction((txn) async {
      try {
        await txn.delete('tb_master_food');
        for (var food in foods) {
          await txn.insert(
            'tb_master_food',
            food.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      } catch (e) {
        _logger.e("Error during add food: $e");
        rethrow;
      }
    });
  }
}
