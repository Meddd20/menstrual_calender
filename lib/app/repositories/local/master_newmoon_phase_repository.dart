import 'package:logger/logger.dart';
import 'package:periodnpregnancycalender/app/models/master_newmoon_phase_model.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';

class MasterNewmoonPhaseRepository {
  final DatabaseHelper _databaseHelper;
  final Logger _logger = Logger();

  MasterNewmoonPhaseRepository(this._databaseHelper);

  Future<List<MasterNewmoonPhase>> getAllMasterNewmoonPhase() async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> masterNewmoonPhase = await db.query(
        "tb_master_newmoon_phase",
      );
      return List.generate(masterNewmoonPhase.length, (i) {
        return MasterNewmoonPhase.fromJson(masterNewmoonPhase[i]);
      });
    } catch (e) {
      _logger.e("Error during get all master newmoon phase: $e");
      rethrow;
    }
  }

  Future<MasterNewmoonPhase?> getMasterNewmoonPhaseById(int? id) async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> masterNewmoonPhase = await db.query(
        "tb_master_newmoon_phase",
        where: 'id = ?',
        whereArgs: [id],
      );
      if (masterNewmoonPhase.isNotEmpty) {
        return MasterNewmoonPhase.fromJson(masterNewmoonPhase.first);
      }
      return null;
    } catch (e) {
      _logger.e("Error during get master newmoon phase by id: $e");
      rethrow;
    }
  }

  Future<void> addMasterNewmoonPhase(MasterNewmoonPhase masterNewmoonPhase) async {
    final db = await _databaseHelper.database;
    try {
      await db.insert("tb_master_newmoon_phase", masterNewmoonPhase.toJson());
    } catch (e) {
      _logger.e("Error during add master newmoon phase: $e");
      rethrow;
    }
  }

  Future<void> editMasterNewmoonPhase(MasterNewmoonPhase masterNewmoonPhase) async {
    final db = await _databaseHelper.database;
    try {
      await db.update(
        "tb_master_newmoon_phase",
        masterNewmoonPhase.toJson(),
        where: 'id = ?',
        whereArgs: [masterNewmoonPhase.id],
      );
    } catch (e) {
      _logger.e("Error during edit master newmoon phase: $e");
      rethrow;
    }
  }

  Future<void> deleteMasterNewmoonPhase(int id) async {
    final db = await _databaseHelper.database;
    try {
      await db.delete(
        "tb_master_newmoon_phase",
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      _logger.e("Error during delete master newmoon phase: $e");
      rethrow;
    }
  }
}
