import 'package:logger/logger.dart';
import 'package:periodnpregnancycalender/app/models/master_newmoon_model.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';

class MasterNewmoonRepository {
  final DatabaseHelper _databaseHelper;
  final Logger _logger = Logger();

  MasterNewmoonRepository(this._databaseHelper);

  Future<List<MasterNewmoon>> getAllMasterNewmoon() async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> masterNewmoon = await db.query(
        "tb_master_newmoon",
      );
      return List.generate(masterNewmoon.length, (i) {
        return MasterNewmoon.fromJson(masterNewmoon[i]);
      });
    } catch (e) {
      _logger.e("Error during get all master newmoon: $e");
      rethrow;
    }
  }

  Future<MasterNewmoon?> getMasterNewmoonById(int? id) async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> masterNewmoon = await db.query(
        "tb_master_newmoon",
        where: 'id = ?',
        whereArgs: [id],
      );
      if (masterNewmoon.isNotEmpty) {
        return MasterNewmoon.fromJson(masterNewmoon.first);
      }
      return null;
    } catch (e) {
      _logger.e("Error during get master newmoon by id: $e");
      rethrow;
    }
  }

  Future<void> addMasterNewmoon(MasterNewmoon masterNewmoon) async {
    final db = await _databaseHelper.database;
    try {
      await db.insert("tb_master_newmoon", masterNewmoon.toJson());
    } catch (e) {
      _logger.e("Error during add master newmoon: $e");
      rethrow;
    }
  }

  Future<void> editMasterNewmoon(MasterNewmoon masterNewmoon) async {
    final db = await _databaseHelper.database;
    try {
      await db.update(
        "tb_master_newmoon",
        masterNewmoon.toJson(),
        where: 'id = ?',
        whereArgs: [masterNewmoon.id],
      );
    } catch (e) {
      _logger.e("Error during edit master newmoon: $e");
      rethrow;
    }
  }

  Future<void> deleteMasterNewmoon(int id) async {
    final db = await _databaseHelper.database;
    try {
      await db.delete(
        "tb_master_newmoon",
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      _logger.e("Error during delete master newmoon: $e");
      rethrow;
    }
  }
}
