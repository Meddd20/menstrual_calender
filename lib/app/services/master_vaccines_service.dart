import 'package:periodnpregnancycalender/app/repositories/repositories.dart';
import 'package:periodnpregnancycalender/app/models/models.dart';

class MasterVaccinesService {
  late final MasterVaccinesRepository _masterVaccinesRepository = MasterVaccinesRepository();

  Future<List<MasterVaccine>> getAllVaccines() async {
    return await _masterVaccinesRepository.getAllVaccines();
  }

  Future<MasterVaccine?> getVaccineById(int? id) async {
    return await _masterVaccinesRepository.getVaccinesById(id);
  }

  Future<void> addAllVaccines(List<MasterVaccine> vaccines) async {
    await _masterVaccinesRepository.addAllVaccines(vaccines);
  }
}
