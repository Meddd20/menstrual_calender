import 'package:logger/logger.dart';
import 'package:periodnpregnancycalender/app/models/daily_log_model.dart';
import 'package:periodnpregnancycalender/app/models/period_cycle_model.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_model.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_weight_gain.dart';
import 'package:periodnpregnancycalender/app/models/profile_model.dart';
import 'package:periodnpregnancycalender/app/models/sync_log_model.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class SyncDataRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final Logger _logger = Logger();

  Future<void> fetchNewlySyncPeriodHistoryData(List<PeriodHistory> periodHistoryDataFetchFromAPI, int userId) async {
    final db = await _databaseHelper.database;
    try {
      await db.transaction((txn) async {
        await txn.delete("tb_riwayat_mens", where: 'user_id = ?', whereArgs: [userId]);
        for (var periodHistoryData in periodHistoryDataFetchFromAPI) {
          await txn.insert(
            'tb_riwayat_mens',
            periodHistoryData.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });
    } catch (e) {
      _logger.e("Error during create fetchNewlySyncPeriodHistoryData: $e");
      rethrow;
    }
  }

  Future<void> fetchNewlySyncPregnancyHistoryData(PregnancyHistory pregnancyHistoryDataFetchFromAPI, int userId) async {
    final db = await _databaseHelper.database;
    try {
      await db.transaction((txn) async {
        pregnancyHistoryDataFetchFromAPI.userId = userId;

        await txn.insert(
          'tb_riwayat_kehamilan',
          pregnancyHistoryDataFetchFromAPI.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
    } catch (e) {
      _logger.e("Error during create fetch NewlySyncPregnancyHistoryData: $e");
      rethrow;
    }
  }

  Future<void> fetchNewlySyncWeightGainHistoryData(List<WeightHistory> weightGainHistoryDataFetchFromAPI, int userId) async {
    final db = await _databaseHelper.database;
    try {
      await db.transaction((txn) async {
        for (var weightGainData in weightGainHistoryDataFetchFromAPI) {
          weightGainData.userId = userId;
          await txn.insert(
            'tb_berat_badan_kehamilan',
            weightGainData.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });
    } catch (e) {
      _logger.e("Error during create fetchNewlySyncWeightGainHistoryData: $e");
      rethrow;
    }
  }

  Future<void> fetchNewlySyncUserData(User userDataFetchFromAPI) async {
    final db = await _databaseHelper.database;
    try {
      await db.transaction((txn) async {
        await txn.insert("tb_user", userDataFetchFromAPI.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
      });
    } catch (e) {
      _logger.e("Error during create fetchNewlySyncUserData: $e");
      rethrow;
    }
  }

  Future<void> fetchNewlySyncDailyLogData(DailyLog dailyLogDataFetchFromAPI, int userId) async {
    final db = await _databaseHelper.database;
    try {
      await db.transaction((txn) async {
        dailyLogDataFetchFromAPI.userId = userId;
        await txn.insert("tb_data_harian", dailyLogDataFetchFromAPI.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
      });
    } catch (e) {
      _logger.e("Error during create fetchNewlySyncDailyLogData: $e");
      rethrow;
    }
  }

  Future<List<SyncLog>> getAllSyncLogData() async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> syncLogData = await db.query("sync_log");
      return List.generate(syncLogData.length, (i) {
        return SyncLog.fromJson(syncLogData[i]);
      });
    } catch (e) {
      _logger.e("Error during get all synclog data: $e");
      rethrow;
    }
  }

  Future<void> addSyncLogData(SyncLog syncLog) async {
    final db = await _databaseHelper.database;
    try {
      await db.insert("sync_log", syncLog.toJson());
    } catch (e) {
      _logger.e("Error during add sycnlog data: $e");
      rethrow;
    }
  }

  Future<void> deleteSyncLogData(int id) async {
    final db = await _databaseHelper.database;
    try {
      await db.delete(
        "sync_log",
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      _logger.e("Error during delete sycnlog data: $e");
      rethrow;
    }
  }

  Future<void> deleteAllSyncLogData() async {
    final db = await _databaseHelper.database;
    try {
      await db.delete("sync_log");
    } catch (e) {
      _logger.e("Error during delete sycnlog data: $e");
      rethrow;
    }
  }
}
