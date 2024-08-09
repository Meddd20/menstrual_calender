import 'package:periodnpregnancycalender/app/models/master_newmoon_phase_model.dart';
import 'package:periodnpregnancycalender/app/repositories/local/master_newmoon_phase_repository.dart';

class MasterNewmoonPhaseService {
  final MasterNewmoonPhaseRepository _masterNewmoonRepository;

  MasterNewmoonPhaseService(this._masterNewmoonRepository);

  Future<List<MasterNewmoonPhase>> getAllNewmoonPhase() async {
    return await _masterNewmoonRepository.getAllNewmoonPhase();
  }

  Future<MasterNewmoonPhase?> getNewmoonPhaseById(int? id) async {
    return await _masterNewmoonRepository.getNewmoonPhaseById(id);
  }

  Future<void> addNewmoonPhase(MasterNewmoonPhase newmoonPhase) async {
    await _masterNewmoonRepository.addNewmoonPhase(newmoonPhase);
  }

  Future<void> editNewmoonPhase(MasterNewmoonPhase newmoonPhase) async {
    MasterNewmoonPhase? editedNewmoonPhaseData = await getNewmoonPhaseById(newmoonPhase.id);
    if (editedNewmoonPhaseData != null) {
      MasterNewmoonPhase updatedNewmoonPhase = editedNewmoonPhaseData.copyWith(
        id: newmoonPhase.id,
        year: newmoonPhase.year,
        newMoon: newmoonPhase.newMoon,
      );
      await _masterNewmoonRepository.editNewmoonPhase(updatedNewmoonPhase);
    } else {
      throw Exception('Newmoon Phase Data not found');
    }
  }

  Future<void> deleteNewmoonPhase(int id) async {
    await _masterNewmoonRepository.deleteNewmoonPhase(id);
  }
}
