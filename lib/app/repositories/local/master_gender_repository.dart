import 'package:logger/logger.dart';
import 'package:periodnpregnancycalender/app/models/master_gender.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';

class MasterGenderRepository {
  final DatabaseHelper _databaseHelper;
  final Logger _logger = Logger();

  MasterGenderRepository(this._databaseHelper);

  Future<List<MasterGender>> getAllGenderData() async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> getAllGenderData = await db.query(
        "tb_master_gender",
      );
      return List.generate(getAllGenderData.length, (i) {
        return MasterGender.fromJson(getAllGenderData[i]);
      });
    } catch (e) {
      _logger.e("Error during get all gender data: $e");
      rethrow;
    }
  }

  Future<MasterGender?> getGenderById(int? id) async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> getGenderData = await db.query(
        "tb_master_gender",
        where: 'id = ?',
        whereArgs: [id],
      );
      if (getGenderData.isNotEmpty) {
        return MasterGender.fromJson(getGenderData.first);
      }
      return null;
    } catch (e) {
      _logger.e("Error during get gender data by id: $e");
      rethrow;
    }
  }

  Future<void> addGenderData(MasterGender genderData) async {
    final db = await _databaseHelper.database;
    try {
      await db.insert("tb_master_gender", genderData.toJson());
    } catch (e) {
      _logger.e("Error during add gender data: $e");
      rethrow;
    }
  }

  Future<void> editGenderData(MasterGender genderData) async {
    final db = await _databaseHelper.database;
    try {
      await db.update(
        "tb_master_gender",
        genderData.toJson(),
        where: 'id = ?',
        whereArgs: [genderData.id],
      );
    } catch (e) {
      _logger.e("Error during edit gender data: $e");
      rethrow;
    }
  }

  Future<void> deleteGenderData(int id) async {
    final db = await _databaseHelper.database;
    try {
      await db.delete(
        "tb_master_gender",
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      _logger.e("Error during delete gender data: $e");
      rethrow;
    }
  }
}
