import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:periodnpregnancycalender/app/models/profile_model.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';

class LocalProfileRepository {
  final DatabaseHelper _databaseHelper;
  final Logger _logger = Logger();

  LocalProfileRepository(this._databaseHelper);

  Future<void> createProfile(User profile) async {
    final db = await _databaseHelper.database;
    try {
      await db.insert("tb_user", profile.toJson(includeRole: false, includeEmail: false));
    } catch (e) {
      _logger.e("Error during create profile: $e");
      rethrow;
    }
  }

  Future<void> updateProfile(User profile) async {
    final db = await _databaseHelper.database;
    try {
      await db.update("tb_user", profile.toJson(), where: 'id = ?', whereArgs: [profile.id]);
    } catch (e) {
      _logger.e("Error during update profile: $e");
      rethrow;
    }
  }

  Future<User?> getProfile() async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> profiles = await db.query(
        "tb_user",
      );

      if (profiles.isNotEmpty) {
        return User.fromJson(profiles.first);
      }
      return null;
    } catch (e) {
      _logger.e("Error during get profile: $e");
      rethrow;
    }
  }

  Future<void> deleteProfile(int id) async {
    final db = await _databaseHelper.database;
    await db.transaction((txn) async {
      try {
        await txn.delete("tb_user", where: 'id = ?', whereArgs: [id]);
        await txn.delete("tb_berat_badan_kehamilan", where: 'user_id = ?', whereArgs: [id]);
        await txn.delete("tb_data_harian", where: 'user_id = ?', whereArgs: [id]);
        await txn.delete("tb_riwayat_kehamilan", where: 'user_id = ?', whereArgs: [id]);
        await txn.delete("tb_riwayat_mens", where: 'user_id = ?', whereArgs: [id]);
      } catch (e) {
        _logger.e("Error during delete profile: $e");
        rethrow;
      }
    });
  }

  Future<void> saveChangeToSyncLog(String tableName, int recordId, Map<String, dynamic> data, String operation) async {
    final db = await _databaseHelper.database;

    try {
      if (operation != 'create' || operation != 'update' || operation != 'delete') {
        throw ArgumentError('Invalid operation: $operation. Operation must be "create", "update", or "delete".');
      }

      await db.insert('sync_log', {
        'table_name': tableName,
        'record_id': recordId,
        'data': jsonEncode(data),
        'operation': operation,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.e("Error during save changes to synclog: $e");
      rethrow;
    }
  }

  Future<void> deleteSyncLogEntry(int recordId, String tableName, String operation) async {
    final db = await _databaseHelper.database;
    try {
      await db.delete(
        'sync_log',
        where: 'record_id = ? AND table_name = ? AND operation = ?',
        whereArgs: [recordId, tableName, operation],
      );
    } catch (e) {
      _logger.e("Error during delete changes to synclog: $e");
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getSyncLogEntry() async {
    final db = await _databaseHelper.database;
    try {
      return await db.query('sync_log');
    } catch (e) {
      _logger.e("Error during get all changes in synclog: $e");
      rethrow;
    }
  }
}
