import 'package:logger/logger.dart';
import 'package:periodnpregnancycalender/app/models/master_gender.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';

class MasterGenderRepository {
  final DatabaseHelper _databaseHelper;
  final Logger _logger = Logger();

  MasterGenderRepository(this._databaseHelper);

  Future<List<MasterGender>> getAllMasterGenderData() async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> masterGenderData = await db.query(
        "tb_master_gender",
      );
      return List.generate(masterGenderData.length, (i) {
        return MasterGender.fromJson(masterGenderData[i]);
      });
    } catch (e) {
      _logger.e("Error during get all master gender data: $e");
      rethrow;
    }
  }

  Future<MasterGender?> getMasterGenderById(int? id) async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> masterGenderData = await db.query(
        "tb_master_gender",
        where: 'id = ?',
        whereArgs: [id],
      );
      if (masterGenderData.isNotEmpty) {
        return MasterGender.fromJson(masterGenderData.first);
      }
      return null;
    } catch (e) {
      _logger.e("Error during get master gender data by id: $e");
      rethrow;
    }
  }

  Future<void> addMasterGenderData(MasterGender masterGender) async {
    final db = await _databaseHelper.database;
    try {
      await db.insert("tb_master_gender", masterGender.toJson());
    } catch (e) {
      _logger.e("Error during add master gender data: $e");
      rethrow;
    }
  }

  Future<void> editMasterGenderData(MasterGender masterGender) async {
    final db = await _databaseHelper.database;
    try {
      await db.update(
        "tb_master_gender",
        masterGender.toJson(),
        where: 'id = ?',
        whereArgs: [masterGender.id],
      );
    } catch (e) {
      _logger.e("Error during edit master gender data: $e");
      rethrow;
    }
  }

  Future<void> deleteMasterGenderData(int id) async {
    final db = await _databaseHelper.database;
    try {
      await db.delete(
        "tb_master_gender",
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      _logger.e("Error during delete master gender data: $e");
      rethrow;
    }
  }
}
