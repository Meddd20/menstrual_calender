import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

import 'package:periodnpregnancycalender/app/utils/utils.dart';
import 'package:periodnpregnancycalender/app/models/models.dart';

class LocalLogRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final Logger _logger = Logger();

  Future<void> upsertDailyLog(DailyLog dailyLog) async {
    final db = await _databaseHelper.database;
    try {
      await db.insert(
        "tb_data_harian",
        dailyLog.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      _logger.e("Error during upsert daily log: $e");
      rethrow;
    }
  }

  Future<DailyLog?> getDailyLog(int userId) async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> log = await db.query(
        "tb_data_harian",
        where: 'user_id = ?',
        whereArgs: [userId],
      );

      if (log.isNotEmpty) {
        return DailyLog.fromJson(log.first);
      }
      return null;
    } catch (e) {
      print(userId);
      _logger.e("Error during get daily log: $e");
      rethrow;
    }
  }
}
