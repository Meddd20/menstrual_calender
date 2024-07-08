import 'package:logger/logger.dart';
import 'package:periodnpregnancycalender/app/models/master_pregnancy_model.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';

class MasterKehamilanRepository {
  final DatabaseHelper _databaseHelper;
  final Logger _logger = Logger();

  MasterKehamilanRepository(this._databaseHelper);

  Future<List<MasterPregnancy>> getAllMasterKehamilan() async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> masterPregnancyData = await db.query(
        "tb_master_kehamilan",
      );
      return List.generate(masterPregnancyData.length, (i) {
        return MasterPregnancy.fromJson(masterPregnancyData[i]);
      });
    } catch (e) {
      _logger.e("Error during get all master data kehamilan: $e");
      rethrow;
    }
  }

  Future<MasterPregnancy?> getMasterPregnancyById(int? id) async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> masterPregnancyData = await db.query(
        "tb_master_kehamilan",
        where: 'id = ?',
        whereArgs: [id],
      );
      if (masterPregnancyData.isNotEmpty) {
        return MasterPregnancy.fromJson(masterPregnancyData.first);
      }
      return null;
    } catch (e) {
      _logger.e("Error during get master data kehamilan by id: $e");
      rethrow;
    }
  }

  Future<void> addMasterKehamilan(MasterPregnancy masterPregnancy) async {
    final db = await _databaseHelper.database;
    try {
      await db.insert("tb_master_kehamilan", masterPregnancy.toJson());
    } catch (e) {
      _logger.e("Error during add master data kehamilan: $e");
      rethrow;
    }
  }

  Future<void> editMasterKehamilan(MasterPregnancy masterPregnancy) async {
    final db = await _databaseHelper.database;
    try {
      await db.update(
        "tb_master_kehamilan",
        masterPregnancy.toJson(),
        where: 'id = ?',
        whereArgs: [masterPregnancy.id],
      );
    } catch (e) {
      _logger.e("Error during edit master data kehamilan: $e");
      rethrow;
    }
  }

  Future<void> deleteMasterKehamilan(int id) async {
    final db = await _databaseHelper.database;
    try {
      await db.delete(
        "tb_master_kehamilan",
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      _logger.e("Error during delete master data kehamilan: $e");
      rethrow;
    }
  }
}
