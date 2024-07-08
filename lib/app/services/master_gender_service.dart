import 'package:periodnpregnancycalender/app/models/master_gender.dart';
import 'package:periodnpregnancycalender/app/repositories/local/master_gender_repository.dart';

class MasterGenderService {
  final MasterGenderRepository _masterGenderRepository;

  MasterGenderService(this._masterGenderRepository);

  Future<List<MasterGender>> getMasterGenderData() async {
    return await _masterGenderRepository.getAllMasterGenderData();
  }

  Future<MasterGender?> getMasterGenderById(int? id) async {
    return await _masterGenderRepository.getMasterGenderById(id);
  }

  Future<void> addMasterGenderData(MasterGender masterGender) async {
    await _masterGenderRepository.addMasterGenderData(masterGender);
  }

  Future<void> editMasterGenderData(MasterGender updatedMasterGenderData) async {
    MasterGender? masterGenderData = await getMasterGenderById(updatedMasterGenderData.id);
    if (masterGenderData != null) {
      MasterGender updatedGender = masterGenderData.copyWith(
        id: updatedMasterGenderData.id,
        usia: updatedMasterGenderData.usia,
        bulan: updatedMasterGenderData.bulan,
        gender: updatedMasterGenderData.gender,
      );
      await _masterGenderRepository.editMasterGenderData(updatedGender);
    } else {
      throw Exception('Master Gender Data not found');
    }
  }

  Future<void> deleteMasterGenderData(int id) async {
    await _masterGenderRepository.deleteMasterGenderData(id);
  }
}
