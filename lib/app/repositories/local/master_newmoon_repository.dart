import 'package:logger/logger.dart';

import 'package:periodnpregnancycalender/app/utils/utils.dart';
import 'package:periodnpregnancycalender/app/models/models.dart';

class MasterNewmoonRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final Logger _logger = Logger();

  Future<List<MasterNewmoon>> getAllNewmoon() async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> getAllNewmoon = await db.query(
        "tb_master_newmoon",
      );
      return List.generate(getAllNewmoon.length, (i) {
        return MasterNewmoon.fromJson(getAllNewmoon[i]);
      });
    } catch (e) {
      _logger.e("Error during get all newmoon: $e");
      rethrow;
    }
  }

  Future<MasterNewmoon?> getNewmoonById(int? id) async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> getNewmoon = await db.query(
        "tb_master_newmoon",
        where: 'id = ?',
        whereArgs: [id],
      );
      if (getNewmoon.isNotEmpty) {
        return MasterNewmoon.fromJson(getNewmoon.first);
      }
      return null;
    } catch (e) {
      _logger.e("Error during get newmoon by id: $e");
      rethrow;
    }
  }

  Future<void> addNewmoon(MasterNewmoon newmoon) async {
    final db = await _databaseHelper.database;
    try {
      await db.insert("tb_master_newmoon", newmoon.toJson());
    } catch (e) {
      _logger.e("Error during add newmoon: $e");
      rethrow;
    }
  }

  Future<void> editNewmoon(MasterNewmoon newmoon) async {
    final db = await _databaseHelper.database;
    try {
      await db.update(
        "tb_master_newmoon",
        newmoon.toJson(),
        where: 'id = ?',
        whereArgs: [newmoon.id],
      );
    } catch (e) {
      _logger.e("Error during edit newmoon: $e");
      rethrow;
    }
  }

  Future<void> deleteNewmoon(int id) async {
    final db = await _databaseHelper.database;
    try {
      await db.delete(
        "tb_master_newmoon",
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      _logger.e("Error during delete newmoon: $e");
      rethrow;
    }
  }
}
