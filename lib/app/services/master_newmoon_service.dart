import 'package:periodnpregnancycalender/app/models/master_newmoon_model.dart';
import 'package:periodnpregnancycalender/app/repositories/local/master_newmoon_repository.dart';

class MasterNewmoonService {
  late final MasterNewmoonRepository _masterNewmoonRepository = MasterNewmoonRepository();

  Future<List<MasterNewmoon>> getAllNewmoon() async {
    return await _masterNewmoonRepository.getAllNewmoon();
  }

  Future<MasterNewmoon?> getNewmoonById(int? id) async {
    return await _masterNewmoonRepository.getNewmoonById(id);
  }

  Future<void> addNewmoon(MasterNewmoon masterNewmoon) async {
    await _masterNewmoonRepository.addNewmoon(masterNewmoon);
  }

  Future<void> editNewmoon(MasterNewmoon editedNewmoonData) async {
    MasterNewmoon? masterNewmoonData = await getNewmoonById(editedNewmoonData.id);
    if (masterNewmoonData != null) {
      MasterNewmoon updatedNewmoon = masterNewmoonData.copyWith(
        id: editedNewmoonData.id,
        lunarMonth: editedNewmoonData.lunarMonth,
        newMoon: editedNewmoonData.newMoon,
        shio: editedNewmoonData.shio,
      );
      await _masterNewmoonRepository.editNewmoon(updatedNewmoon);
    } else {
      throw Exception('Master Newmoon Data not found');
    }
  }

  Future<void> deleteNewmoon(int id) async {
    await _masterNewmoonRepository.deleteNewmoon(id);
  }
}
