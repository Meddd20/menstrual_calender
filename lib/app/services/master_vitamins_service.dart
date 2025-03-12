import 'package:periodnpregnancycalender/app/repositories/repositories.dart';
import 'package:periodnpregnancycalender/app/models/models.dart';

class MasterVitaminsService {
  late final MasterVitaminsRepository _masterVitaminsRepository = MasterVitaminsRepository();

  Future<List<MasterVitamin>> getAllVitamin() async {
    return await _masterVitaminsRepository.getAllVitamins();
  }

  Future<MasterVitamin?> getVitaminById(int? id) async {
    return await _masterVitaminsRepository.getVitaminsById(id);
  }

  Future<void> addAllVitamins(List<MasterVitamin> vitamins) async {
    await _masterVitaminsRepository.addAllVitamins(vitamins);
  }
}
