import 'package:logger/logger.dart';
import 'package:periodnpregnancycalender/app/models/master_pregnancy_model.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';

class MasterDataKehamilanRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final Logger _logger = Logger();

  Future<List<MasterPregnancy>> getAllPregnancyData() async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> getAllPregnancyData = await db.query(
        "tb_master_kehamilan",
      );
      return List.generate(getAllPregnancyData.length, (i) {
        return MasterPregnancy.fromJson(getAllPregnancyData[i]);
      });
    } catch (e) {
      _logger.e("Error during get all data kehamilan: $e");
      rethrow;
    }
  }

  Future<MasterPregnancy?> getPregnancyDataById(int? id) async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> pregnancyData = await db.query(
        "tb_master_kehamilan",
        where: 'id = ?',
        whereArgs: [id],
      );
      if (pregnancyData.isNotEmpty) {
        return MasterPregnancy.fromJson(pregnancyData.first);
      }
      return null;
    } catch (e) {
      _logger.e("Error during get data kehamilan by id: $e");
      rethrow;
    }
  }

  Future<void> addPregnancyData(MasterPregnancy pregnancyData) async {
    final db = await _databaseHelper.database;
    try {
      await db.insert("tb_master_kehamilan", pregnancyData.toJson());
    } catch (e) {
      _logger.e("Error during add data kehamilan: $e");
      rethrow;
    }
  }

  Future<void> editPregnancyData(MasterPregnancy pregnancyData) async {
    final db = await _databaseHelper.database;
    try {
      await db.update(
        "tb_master_kehamilan",
        pregnancyData.toJson(),
        where: 'id = ?',
        whereArgs: [pregnancyData.id],
      );
    } catch (e) {
      _logger.e("Error during edit data kehamilan: $e");
      rethrow;
    }
  }

  Future<void> deletePregnancyData(int id) async {
    final db = await _databaseHelper.database;
    try {
      await db.delete(
        "tb_master_kehamilan",
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      _logger.e("Error during delete data kehamilan: $e");
      rethrow;
    }
  }
}
