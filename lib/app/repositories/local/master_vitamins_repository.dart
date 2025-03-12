import 'package:logger/logger.dart';

import 'package:periodnpregnancycalender/app/utils/utils.dart';
import 'package:periodnpregnancycalender/app/models/models.dart';
import 'package:sqflite/sqflite.dart';

class MasterVitaminsRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final Logger _logger = Logger();

  Future<List<MasterVitamin>> getAllVitamins() async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> getAllVitamins = await db.query(
        "tb_master_vitamins",
      );
      return List.generate(getAllVitamins.length, (i) {
        return MasterVitamin.fromJson(getAllVitamins[i]);
      });
    } catch (e) {
      _logger.e("Error during get all vitamins: $e");
      rethrow;
    }
  }

  Future<MasterVitamin?> getVitaminsById(int? id) async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> getVitamin = await db.query(
        "tb_master_vitamins",
        where: 'id = ?',
        whereArgs: [id],
      );
      if (getVitamin.isNotEmpty) {
        return MasterVitamin.fromJson(getVitamin.first);
      }
      return null;
    } catch (e) {
      _logger.e("Error during get vitamin by id: $e");
      rethrow;
    }
  }

  Future<void> addAllVitamins(List<MasterVitamin> vitamins) async {
    final db = await _databaseHelper.database;
    await db.transaction((txn) async {
      try {
        await txn.delete('tb_master_vitamins');
        for (var vitamin in vitamins) {
          await txn.insert(
            'tb_master_vitamins',
            vitamin.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      } catch (e) {
        _logger.e("Error during add vitamins: $e");
        rethrow;
      }
    });
  }
}
