import 'package:logger/logger.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_model.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class PregnancyHistoryRepository {
  final DatabaseHelper _databaseHelper;
  final Logger _logger = Logger();

  PregnancyHistoryRepository(this._databaseHelper);

  Future<void> beginPregnancy(PregnancyHistory pregnancyHistory) async {
    final db = await _databaseHelper.database;
    try {
      await db.insert("tb_riwayat_kehamilan", pregnancyHistory.toJson());
    } catch (e) {
      _logger.e("Error during begin pregnancy: $e");
      rethrow;
    }
  }

  Future<void> editPregnancy(PregnancyHistory pregnancyHistory) async {
    final db = await _databaseHelper.database;
    try {
      await db.update(
        "tb_riwayat_kehamilan",
        pregnancyHistory.toJson(),
        where: 'id = ?',
        whereArgs: [pregnancyHistory.id],
      );
    } catch (e) {
      _logger.e("Error during edit pregnancy: $e");
      rethrow;
    }
  }

  Future<PregnancyHistory?> getCurrentPregnancyHistory(int userId) async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> pregnancyData = await db.query(
        "tb_riwayat_kehamilan",
        where: 'status = ?',
        whereArgs: ["Hamil"],
      );

      if (pregnancyData.isNotEmpty) {
        return PregnancyHistory.fromJson(pregnancyData.first);
      }
      return null;
    } catch (e) {
      _logger.e("Error during get current pregnancy history: $e");
      rethrow;
    }
  }

  Future<List<PregnancyHistory>> getAllPregnancyHistory(int user_id) async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> pregnancyData = await db.query("tb_riwayat_kehamilan", where: 'user_id = ?', whereArgs: [user_id], orderBy: 'hari_pertama_haid_terakhir ASC');

      return List.generate(pregnancyData.length, (i) {
        return PregnancyHistory.fromJson(pregnancyData[i]);
      });
    } catch (e) {
      _logger.e("Error during get all pregnancy history: $e");
      rethrow;
    }
  }

  Future<void> deletePregnancy(int userId) async {
    final db = await _databaseHelper.database;
    try {
      await db.delete(
        "tb_riwayat_kehamilan",
        where: 'status = ? AND user_id = ?',
        whereArgs: ["Hamil", userId],
      );
    } catch (e) {
      _logger.e("Error during delete pregnancy: $e");
      rethrow;
    }
  }

  Future<void> addPregnancyData(PregnancyHistory pregnancyHistory, int userId, {int? remoteId}) async {
    final db = await _databaseHelper.database;
    try {
      pregnancyHistory.userId = userId;
      if (remoteId != null) {
        pregnancyHistory = pregnancyHistory.copyWith(remoteId: remoteId);
      }
      await db.insert(
        "tb_riwayat_kehamilan",
        pregnancyHistory.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      _logger.e("Error during add pregnancy data: $e");
      rethrow;
    }
  }
}
