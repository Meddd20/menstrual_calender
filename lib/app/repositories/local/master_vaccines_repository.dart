import 'package:logger/logger.dart';
import 'package:periodnpregnancycalender/app/models/master_vaccines_model.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';

class MasterVaccinesRepository {
  final DatabaseHelper _databaseHelper;
  final Logger _logger = Logger();

  MasterVaccinesRepository(this._databaseHelper);

  Future<List<MasterVaccine>> getAllVaccines() async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> getAllVaccines = await db.query(
        "tb_master_vaccines",
      );
      return List.generate(getAllVaccines.length, (i) {
        return MasterVaccine.fromJson(getAllVaccines[i]);
      });
    } catch (e) {
      _logger.e("Error during get all vaccines: $e");
      rethrow;
    }
  }

  Future<MasterVaccine?> getVaccinesById(int? id) async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> getVaccine = await db.query(
        "tb_master_vaccines",
        where: 'id = ?',
        whereArgs: [id],
      );
      if (getVaccine.isNotEmpty) {
        return MasterVaccine.fromJson(getVaccine.first);
      }
      return null;
    } catch (e) {
      _logger.e("Error during get vaccine by id: $e");
      rethrow;
    }
  }

  Future<void> addVaccines(MasterVaccine vaccine) async {
    final db = await _databaseHelper.database;
    try {
      await db.insert("tb_master_vaccines", vaccine.toJson());
    } catch (e) {
      _logger.e("Error during add vaccine: $e");
      rethrow;
    }
  }

  Future<void> editVaccines(MasterVaccine vaccine) async {
    final db = await _databaseHelper.database;
    try {
      await db.update(
        "tb_master_vaccines",
        vaccine.toJson(),
        where: 'id = ?',
        whereArgs: [vaccine.id],
      );
    } catch (e) {
      _logger.e("Error during edit vaccines: $e");
      rethrow;
    }
  }

  Future<void> deleteVaccines(int id) async {
    final db = await _databaseHelper.database;
    try {
      await db.delete(
        "tb_master_vaccines",
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      _logger.e("Error during delete vaccines: $e");
      rethrow;
    }
  }
}
