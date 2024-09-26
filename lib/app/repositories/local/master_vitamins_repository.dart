import 'package:logger/logger.dart';
import 'package:periodnpregnancycalender/app/models/master_vitamins_model.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';

class MasterVitaminsRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final Logger _logger = Logger();

  Future<List<MasterVitamin>> getAllVitamins() async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> getAllVitamins = await db.query(
        "tb_master_vitamins",
      );
      return List.generate(getAllVitamins.length, (i) {
        return MasterVitamin.fromJson(getAllVitamins[i]);
      });
    } catch (e) {
      _logger.e("Error during get all vitamins: $e");
      rethrow;
    }
  }

  Future<MasterVitamin?> getVitaminsById(int? id) async {
    final db = await _databaseHelper.database;
    try {
      List<Map<String, dynamic>> getVitamin = await db.query(
        "tb_master_vitamins",
        where: 'id = ?',
        whereArgs: [id],
      );
      if (getVitamin.isNotEmpty) {
        return MasterVitamin.fromJson(getVitamin.first);
      }
      return null;
    } catch (e) {
      _logger.e("Error during get vitamin by id: $e");
      rethrow;
    }
  }

  Future<void> addVitamin(MasterVitamin vitamin) async {
    final db = await _databaseHelper.database;
    try {
      await db.insert("tb_master_vitamins", vitamin.toJson());
    } catch (e) {
      _logger.e("Error during add vitamin: $e");
      rethrow;
    }
  }

  Future<void> editVitamin(MasterVitamin vitamin) async {
    final db = await _databaseHelper.database;
    try {
      await db.update(
        "tb_master_vitamins",
        vitamin.toJson(),
        where: 'id = ?',
        whereArgs: [vitamin.id],
      );
    } catch (e) {
      _logger.e("Error during edit vitamin: $e");
      rethrow;
    }
  }

  Future<void> deleteVitamin(int id) async {
    final db = await _databaseHelper.database;
    try {
      await db.delete(
        "tb_master_vitamins",
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      _logger.e("Error during delete vitamin: $e");
      rethrow;
    }
  }
}
