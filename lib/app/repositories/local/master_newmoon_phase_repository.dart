import 'package:logger/logger.dart';
import 'package:periodnpregnancycalender/app/models/master_newmoon_phase_model.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';

class MasterNewmoonPhaseRepository {
  final DatabaseHelper _databaseHelper;
  final Logger _logger = Logger();

  MasterNewmoonPhaseRepository(this._databaseHelper);

  Future<List<MasterNewmoonPhase>> getAllNewmoonPhase() async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> newmoonPhases = await db.query(
        "tb_master_newmoon_phase",
      );
      return List.generate(newmoonPhases.length, (i) {
        return MasterNewmoonPhase.fromJson(newmoonPhases[i]);
      });
    } catch (e) {
      _logger.e("Error during get all newmoon phase: $e");
      rethrow;
    }
  }

  Future<MasterNewmoonPhase?> getNewmoonPhaseById(int? id) async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> newmoonPhase = await db.query(
        "tb_master_newmoon_phase",
        where: 'id = ?',
        whereArgs: [id],
      );
      if (newmoonPhase.isNotEmpty) {
        return MasterNewmoonPhase.fromJson(newmoonPhase.first);
      }
      return null;
    } catch (e) {
      _logger.e("Error during get newmoon phase by id: $e");
      rethrow;
    }
  }

  Future<void> addNewmoonPhase(MasterNewmoonPhase newmoonPhase) async {
    final db = await _databaseHelper.database;
    try {
      await db.insert("tb_master_newmoon_phase", newmoonPhase.toJson());
    } catch (e) {
      _logger.e("Error during add newmoon phase: $e");
      rethrow;
    }
  }

  Future<void> editNewmoonPhase(MasterNewmoonPhase newmoonPhase) async {
    final db = await _databaseHelper.database;
    try {
      await db.update(
        "tb_master_newmoon_phase",
        newmoonPhase.toJson(),
        where: 'id = ?',
        whereArgs: [newmoonPhase.id],
      );
    } catch (e) {
      _logger.e("Error during edit newmoon phase: $e");
      rethrow;
    }
  }

  Future<void> deleteNewmoonPhase(int id) async {
    final db = await _databaseHelper.database;
    try {
      await db.delete(
        "tb_master_newmoon_phase",
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      _logger.e("Error during delete newmoon phase: $e");
      rethrow;
    }
  }
}
