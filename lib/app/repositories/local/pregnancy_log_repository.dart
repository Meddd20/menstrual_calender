import 'package:logger/logger.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_daily_log_model.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class PregnancyLogRepository {
  final DatabaseHelper _databaseHelper;
  final Logger _logger = Logger();

  PregnancyLogRepository(this._databaseHelper);

  Future<void> upsertPregnancyDailyLog(PregnancyDailyLog pregnancyDailyLog) async {
    final db = await _databaseHelper.database;
    try {
      final data = pregnancyDailyLog.toJson();
      await db.insert(
        "tb_data_harian_kehamilan",
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      _logger.e("Error during upsert pregnancy daily log: $e");
      rethrow;
    }
  }

  Future<PregnancyDailyLog?> getPregnancyDailyLog(int userId, int riwayatKehamilanId) async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> log = await db.query(
        "tb_data_harian_kehamilan",
        where: 'user_id = ? AND riwayat_kehamilan_id = ?',
        whereArgs: [userId, riwayatKehamilanId],
      );

      if (log.isNotEmpty) {
        return PregnancyDailyLog.fromJson(log.first);
      }
      return null;
    } catch (e) {
      print(userId);
      _logger.e("Error during get pregnancy daily log: $e");
      rethrow;
    }
  }

  Future<List<PregnancyDailyLog>?> getAllPregnancyDailyLog(int userId) async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> log = await db.query(
        "tb_data_harian_kehamilan",
        where: 'user_id = ?',
        whereArgs: [userId],
      );

      return List.generate(log.length, (i) {
        return PregnancyDailyLog.fromJson(log[i]);
      });
    } catch (e) {
      _logger.e("Error during get all pregnancy daily log: $e");
      rethrow;
    }
  }

  Future<void> deletePregnancyDailyLog(int id) async {
    final db = await _databaseHelper.database;
    try {
      await db.delete(
        "tb_data_harian_kehamilan",
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      _logger.e("Error during delete pregnancy daily log: $e");
      rethrow;
    }
  }
}
