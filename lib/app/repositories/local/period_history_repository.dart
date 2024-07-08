import 'package:logger/logger.dart';
import 'package:periodnpregnancycalender/app/models/period_cycle_model.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';

class PeriodHistoryRepository {
  final DatabaseHelper _databaseHelper;
  final Logger _logger = Logger();

  PeriodHistoryRepository(this._databaseHelper);

  Future<void> addPeriodHistory(PeriodHistory periodHistory) async {
    final db = await _databaseHelper.database;
    try {
      await db.insert("tb_riwayat_mens", periodHistory.toJson());
    } catch (e) {
      _logger.e("Error during add period: $e");
      rethrow;
    }
  }

  Future<void> editPeriodHistory(PeriodHistory periodHistory) async {
    final db = await _databaseHelper.database;
    try {
      await db.update(
        "tb_riwayat_mens",
        periodHistory.toJson(),
        where: 'id = ? AND user_id = ?',
        whereArgs: [periodHistory.id, periodHistory.userId],
      );
    } catch (e) {
      _logger.e("Error during edit period: $e");
      rethrow;
    }
  }

  Future<List<PeriodHistory>> getPeriodHistory(int user_id) async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> periodData = await db.query(
        "tb_riwayat_mens",
        where: 'user_id = ?',
        whereArgs: [user_id],
        orderBy: 'haid_awal ASC',
      );

      return List.generate(periodData.length, (i) {
        return PeriodHistory.fromJson(periodData[i]);
      });
    } catch (e) {
      _logger.e("Error during get period history: $e");
      rethrow;
    }
  }

  Future<void> deletePeriodHistory(int id, int userId) async {
    final db = await _databaseHelper.database;
    try {
      await db.delete(
        "tb_riwayat_mens",
        where: 'id = ? AND user_id = ?',
        whereArgs: [id, userId],
      );
    } catch (e) {
      _logger.e("Error during delete period: $e");
      rethrow;
    }
  }
}
