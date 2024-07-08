import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:periodnpregnancycalender/app/common/widgets.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_weight_gain.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';

class WeightHistoryRepository {
  final DatabaseHelper _databaseHelper;
  final Logger _logger = Logger();

  WeightHistoryRepository(this._databaseHelper);

  Future<void> addWeightHistory(WeightHistory weightHistory) async {
    final db = await _databaseHelper.database;
    try {
      await db.insert("tb_berat_badan_kehamilan", weightHistory.toJson());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occurred. Please try again later."));
      _logger.e("Error during add weight history: $e");
      rethrow;
    }
  }

  Future<void> editWeightHistory(WeightHistory weightHistory) async {
    final db = await _databaseHelper.database;
    try {
      await db.update(
        "tb_berat_badan_kehamilan",
        weightHistory.toJson(),
        where: 'id = ? AND user_id = ?',
        whereArgs: [weightHistory.id, weightHistory.userId],
      );
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occurred. Please try again later."));
      _logger.e("Error during edit weight history: $e");
      rethrow;
    }
  }

  Future<List<WeightHistory>> getWeightHistory(int userId) async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> weightHistory = await db.query(
        "tb_berat_badan_kehamilan",
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'minggu_kehamilan ASC, tanggal_pencatatan ASC',
      );

      return List.generate(weightHistory.length, (i) {
        return WeightHistory.fromJson(weightHistory[i]);
      });
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occurred. Please try again later."));
      _logger.e("Error during get weight history: $e");
      rethrow;
    }
  }

  Future<void> deleteWeightHistory(String tanggalPencatatan, int userId) async {
    final db = await _databaseHelper.database;
    try {
      await db.delete(
        "tb_berat_badan_kehamilan",
        where: 'tanggal_pencatatan = ? AND user_id = ?',
        whereArgs: [tanggalPencatatan, userId],
      );
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occurred. Please try again later."));
      _logger.e("Error during delete weight history: $e");
      rethrow;
    }
  }
}
