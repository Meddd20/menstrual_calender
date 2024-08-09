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
      Map<String, dynamic> data = profile.toJson();
      data.remove('token');
      data.remove('device_token');
      data.remove('role');
      await db.insert("tb_user", data);
    } catch (e) {
      _logger.e("Error during create profile: $e");
      rethrow;
    }
  }

  Future<void> updateProfile(User profile) async {
    final db = await _databaseHelper.database;
    try {
      Map<String, dynamic> data = profile.toJson();
      data.remove('token');
      data.remove('device_token');
      data.remove('role');
      print(data.toString());
      await db.update("tb_user", data, where: 'id = ?', whereArgs: [profile.id]);
    } catch (e) {
      _logger.e("Error during update profile: $e");
      rethrow;
    }
  }

  Future<User?> getProfile() async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> profiles = await db.query("tb_user");

      if (profiles.isNotEmpty) {
        return User.fromJson(profiles.first);
      }
      return null;
    } catch (e) {
      _logger.e("Error during get profile: $e");
      rethrow;
    }
  }

  Future<void> deleteProfile() async {
    final db = await _databaseHelper.database;
    await db.transaction((txn) async {
      try {
        await txn.delete("tb_user");
        await txn.delete("tb_berat_badan_kehamilan");
        await txn.delete("tb_data_harian");
        await txn.delete("tb_riwayat_kehamilan");
        await txn.delete("tb_riwayat_mens");
      } catch (e) {
        _logger.e("Error during delete profile: $e");
        rethrow;
      }
    });
  }

  Future<void> deletePendingDataChanges() async {
    final db = await _databaseHelper.database;
    await db.transaction((txn) async {
      try {
        await txn.delete("sync_log");
      } catch (e) {
        _logger.e("Error during delete pending data changes: $e");
        rethrow;
      }
    });
  }
}
