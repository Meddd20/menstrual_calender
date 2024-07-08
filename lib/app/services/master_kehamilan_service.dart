import 'package:periodnpregnancycalender/app/models/master_pregnancy_model.dart';
import 'package:periodnpregnancycalender/app/repositories/local/master_kehamilan_repository.dart';

class MasterKehamilanService {
  final MasterKehamilanRepository _masterKehamilanRepository;

  MasterKehamilanService(this._masterKehamilanRepository);

  Future<List<MasterPregnancy>> getAllMasterKehamilan() async {
    return await _masterKehamilanRepository.getAllMasterKehamilan();
  }

  Future<MasterPregnancy?> getMasterPregnancyById(int? id) async {
    return await _masterKehamilanRepository.getMasterPregnancyById(id);
  }

  Future<void> addMasterKehamilan(MasterPregnancy masterPregnancy) async {
    await _masterKehamilanRepository.addMasterKehamilan(masterPregnancy);
  }

  Future<void> editMasterKehamilan(
    MasterPregnancy updatedMasterPregnancyData,
  ) async {
    MasterPregnancy? masterPregnancyData = await getMasterPregnancyById(updatedMasterPregnancyData.id);
    if (masterPregnancyData != null) {
      MasterPregnancy updatedPregnancy = masterPregnancyData.copyWith(
        id: updatedMasterPregnancyData.id,
        mingguKehamilan: updatedMasterPregnancyData.mingguKehamilan,
        beratJanin: updatedMasterPregnancyData.beratJanin,
        tinggiBadanJanin: updatedMasterPregnancyData.tinggiBadanJanin,
        ukuranBayiId: updatedMasterPregnancyData.ukuranBayiId,
        ukuranBayiEn: updatedMasterPregnancyData.ukuranBayiEn,
        poinUtamaId: updatedMasterPregnancyData.poinUtamaId,
        poinUtamaEn: updatedMasterPregnancyData.poinUtamaEn,
        perkembanganBayiId: updatedMasterPregnancyData.perkembanganBayiId,
        perkembanganBayiEn: updatedMasterPregnancyData.perkembanganBayiEn,
        perubahanTubuhId: updatedMasterPregnancyData.perubahanTubuhId,
        perubahanTubuhEn: updatedMasterPregnancyData.perubahanTubuhEn,
        gejalaUmumId: updatedMasterPregnancyData.gejalaUmumId,
        gejalaUmumEn: updatedMasterPregnancyData.gejalaUmumEn,
        tipsMingguanId: updatedMasterPregnancyData.tipsMingguanId,
        tipsMingguanEn: updatedMasterPregnancyData.tipsMingguanEn,
        bayiImgPath: updatedMasterPregnancyData.bayiImgPath,
        ukuranBayiImgPath: updatedMasterPregnancyData.ukuranBayiImgPath,
      );
      await _masterKehamilanRepository.editMasterKehamilan(updatedPregnancy);
    } else {
      throw Exception('Master Pregnancy Data not found');
    }
  }

  Future<void> deleteMasterKehamilan(int id) async {
    await _masterKehamilanRepository.deleteMasterKehamilan(id);
  }
}
