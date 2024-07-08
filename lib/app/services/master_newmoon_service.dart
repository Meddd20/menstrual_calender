import 'package:periodnpregnancycalender/app/models/master_newmoon_model.dart';
import 'package:periodnpregnancycalender/app/repositories/local/master_newmoon_repository.dart';

class MasterNewmoonService {
  final MasterNewmoonRepository _masterNewmoonRepository;

  MasterNewmoonService(this._masterNewmoonRepository);

  Future<List<MasterNewmoon>> getAllMasterNewmoon() async {
    return await _masterNewmoonRepository.getAllMasterNewmoon();
  }

  Future<MasterNewmoon?> getMasterNewmoonById(int? id) async {
    return await _masterNewmoonRepository.getMasterNewmoonById(id);
  }

  Future<void> addMasterNewmoon(MasterNewmoon masterNewmoon) async {
    await _masterNewmoonRepository.addMasterNewmoon(masterNewmoon);
  }

  Future<void> editMasterNewmoon(MasterNewmoon editedMasterNewmoonData) async {
    MasterNewmoon? masterNewmoonData = await getMasterNewmoonById(editedMasterNewmoonData.id);
    if (masterNewmoonData != null) {
      MasterNewmoon updatedNewmoon = masterNewmoonData.copyWith(
        id: editedMasterNewmoonData.id,
        lunarMonth: editedMasterNewmoonData.lunarMonth,
        newMoon: editedMasterNewmoonData.newMoon,
        shio: editedMasterNewmoonData.shio,
      );
      await _masterNewmoonRepository.editMasterNewmoon(updatedNewmoon);
    } else {
      throw Exception('Master Newmoon Data not found');
    }
  }

  Future<void> deleteMasterNewmoon(int id) async {
    await _masterNewmoonRepository.deleteMasterNewmoon(id);
  }
}
