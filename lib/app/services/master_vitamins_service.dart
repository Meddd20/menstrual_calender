import 'package:periodnpregnancycalender/app/models/master_vitamins_model.dart';
import 'package:periodnpregnancycalender/app/repositories/local/master_vitamins_repository.dart';

class MasterVitaminsService {
  final MasterVitaminsRepository _masterVitaminsRepository;

  MasterVitaminsService(this._masterVitaminsRepository);

  Future<List<MasterVitamin>> getAllVitamin() async {
    return await _masterVitaminsRepository.getAllVitamins();
  }

  Future<MasterVitamin?> getVitaminById(int? id) async {
    return await _masterVitaminsRepository.getVitaminsById(id);
  }

  Future<void> addVitamin(MasterVitamin vitamin) async {
    await _masterVitaminsRepository.addVitamins(vitamin);
  }

  Future<void> editVitamin(MasterVitamin vitamin) async {
    MasterVitamin? editedVitamin = await getVitaminById(vitamin.id);
    if (editedVitamin != null) {
      MasterVitamin updatedVitamin = editedVitamin.copyWith(
        id: vitamin.id,
        vitaminsId: vitamin.vitaminsId,
        vitaminsEn: vitamin.vitaminsEn,
        descriptionId: vitamin.descriptionId,
        descriptionEn: vitamin.descriptionEn,
        updatedAt: vitamin.updatedAt,
      );
      await _masterVitaminsRepository.editVitamin(updatedVitamin);
    } else {
      throw Exception('Vitamin edited not found');
    }
  }

  Future<void> deleteVitamin(int id) async {
    await _masterVitaminsRepository.deleteVitamin(id);
  }
}
