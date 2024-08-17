import 'package:periodnpregnancycalender/app/models/master_pregnancy_model.dart';
import 'package:periodnpregnancycalender/app/repositories/local/master_kehamilan_repository.dart';

class MasterKehamilanService {
  final MasterDataKehamilanRepository _masterKehamilanRepository;

  MasterKehamilanService(this._masterKehamilanRepository);

  Future<List<MasterPregnancy>> getAllPregnancyData() async {
    return await _masterKehamilanRepository.getAllPregnancyData();
  }

  Future<MasterPregnancy?> getPregnancyDataById(int? id) async {
    return await _masterKehamilanRepository.getPregnancyDataById(id);
  }

  Future<void> addPregnancyData(MasterPregnancy pregnancyData) async {
    await _masterKehamilanRepository.addPregnancyData(pregnancyData);
  }

  Future<void> editPregnancyData(MasterPregnancy pregnancyData) async {
    MasterPregnancy? editedPregnancyData = await getPregnancyDataById(pregnancyData.id);
    if (editedPregnancyData != null) {
      MasterPregnancy updatedPregnancy = editedPregnancyData.copyWith(
        id: pregnancyData.id,
        mingguKehamilan: pregnancyData.mingguKehamilan,
        beratJanin: pregnancyData.beratJanin,
        tinggiBadanJanin: pregnancyData.tinggiBadanJanin,
        ukuranBayiId: pregnancyData.ukuranBayiId,
        ukuranBayiEn: pregnancyData.ukuranBayiEn,
        poinUtamaId: pregnancyData.poinUtamaId,
        poinUtamaEn: pregnancyData.poinUtamaEn,
        perkembanganBayiId: pregnancyData.perkembanganBayiId,
        perkembanganBayiEn: pregnancyData.perkembanganBayiEn,
        perubahanTubuhId: pregnancyData.perubahanTubuhId,
        perubahanTubuhEn: pregnancyData.perubahanTubuhEn,
        gejalaUmumId: pregnancyData.gejalaUmumId,
        gejalaUmumEn: pregnancyData.gejalaUmumEn,
        tipsMingguanId: pregnancyData.tipsMingguanId,
        tipsMingguanEn: pregnancyData.tipsMingguanEn,
        bayiImgPath: pregnancyData.bayiImgPath,
        ukuranBayiImgPath: pregnancyData.ukuranBayiImgPath,
        updatedAt: pregnancyData.updatedAt,
      );
      await _masterKehamilanRepository.editPregnancyData(updatedPregnancy);
    } else {
      throw Exception('Pregnancy Data not found');
    }
  }

  Future<void> deletePregnancyData(int id) async {
    await _masterKehamilanRepository.deletePregnancyData(id);
  }
}
