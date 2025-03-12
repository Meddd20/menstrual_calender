import 'package:logger/logger.dart';

import 'package:periodnpregnancycalender/app/utils/utils.dart';
import 'package:periodnpregnancycalender/app/models/models.dart';
import 'package:sqflite/sqflite.dart';

class MasterVaccinesRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final Logger _logger = Logger();

  Future<List<MasterVaccine>> getAllVaccines() async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> getAllVaccines = await db.query(
        "tb_master_vaccines",
      );
      return List.generate(getAllVaccines.length, (i) {
        return MasterVaccine.fromJson(getAllVaccines[i]);
      });
    } catch (e) {
      _logger.e("Error during get all vaccines: $e");
      rethrow;
    }
  }

  Future<MasterVaccine?> getVaccinesById(int? id) async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> getVaccine = await db.query(
        "tb_master_vaccines",
        where: 'id = ?',
        whereArgs: [id],
      );
      if (getVaccine.isNotEmpty) {
        return MasterVaccine.fromJson(getVaccine.first);
      }
      return null;
    } catch (e) {
      _logger.e("Error during get vaccine by id: $e");
      rethrow;
    }
  }

  Future<void> addAllVaccines(List<MasterVaccine> vaccines) async {
    final db = await _databaseHelper.database;
    await db.transaction((txn) async {
      try {
        await txn.delete('tb_master_vaccines');
        for (var vaccine in vaccines) {
          await txn.insert(
            'tb_master_vaccines',
            vaccine.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      } catch (e) {
        _logger.e("Error during add vaccines: $e");
        rethrow;
      }
    });
  }
}
