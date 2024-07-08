import 'package:periodnpregnancycalender/app/models/master_newmoon_phase_model.dart';
import 'package:periodnpregnancycalender/app/repositories/local/master_newmoon_phase_repository.dart';

class MasterNewmoonPhaseService {
  final MasterNewmoonPhaseRepository _masterNewmoonRepository;

  MasterNewmoonPhaseService(this._masterNewmoonRepository);

  Future<List<MasterNewmoonPhase>> getAllMasterNewmoonPhase() async {
    return await _masterNewmoonRepository.getAllMasterNewmoonPhase();
  }

  Future<MasterNewmoonPhase?> getMasterNewmoonPhaseById(int? id) async {
    return await _masterNewmoonRepository.getMasterNewmoonPhaseById(id);
  }

  Future<void> addMasterNewmoonPhase(MasterNewmoonPhase masterNewmoonPhase) async {
    await _masterNewmoonRepository.addMasterNewmoonPhase(masterNewmoonPhase);
  }

  Future<void> editMasterNewmoonPhase(MasterNewmoonPhase editedMasterNewmoonPhaseData) async {
    MasterNewmoonPhase? masterNewmoonPhaseData = await getMasterNewmoonPhaseById(editedMasterNewmoonPhaseData.id);
    if (masterNewmoonPhaseData != null) {
      MasterNewmoonPhase updatedNewmoonPhase = masterNewmoonPhaseData.copyWith(
        id: editedMasterNewmoonPhaseData.id,
        year: editedMasterNewmoonPhaseData.year,
        newMoon: editedMasterNewmoonPhaseData.newMoon,
      );
      await _masterNewmoonRepository.editMasterNewmoonPhase(updatedNewmoonPhase);
    } else {
      throw Exception('Master Newmoon Phase Data not found');
    }
  }

  Future<void> deleteMasterNewmoonPhase(int id) async {
    await _masterNewmoonRepository.deleteMasterNewmoonPhase(id);
  }
}
