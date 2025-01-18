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

  Future<void> addVaccine(MasterVaccine vaccine) async {
    await _masterVaccinesRepository.addVaccines(vaccine);
  }

  Future<void> editVaccine(MasterVaccine vaccine) async {
    MasterVaccine? editedVaccine = await getVaccineById(vaccine.id);
    if (editedVaccine != null) {
      MasterVaccine updatedVaccine = editedVaccine.copyWith(
        id: vaccine.id,
        vaccinesId: vaccine.vaccinesId,
        vaccinesEn: vaccine.vaccinesEn,
        descriptionId: vaccine.descriptionId,
        descriptionEn: vaccine.descriptionEn,
        updatedAt: vaccine.updatedAt,
      );
      await _masterVaccinesRepository.editVaccines(updatedVaccine);
    } else {
      throw Exception('Vaccine edited not found');
    }
  }

  Future<void> deleteVaccine(int id) async {
    await _masterVaccinesRepository.deleteVaccines(id);
  }
}
