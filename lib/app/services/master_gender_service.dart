import 'package:periodnpregnancycalender/app/models/master_gender.dart';
import 'package:periodnpregnancycalender/app/repositories/local/master_gender_repository.dart';

class MasterGenderService {
  final MasterGenderRepository _masterGenderRepository;

  MasterGenderService(this._masterGenderRepository);

  Future<List<MasterGender>> getGenderData() async {
    return await _masterGenderRepository.getAllGenderData();
  }

  Future<MasterGender?> getGenderById(int? id) async {
    return await _masterGenderRepository.getGenderById(id);
  }

  Future<void> addGenderData(MasterGender masterGender) async {
    await _masterGenderRepository.addGenderData(masterGender);
  }

  Future<void> editGenderData(MasterGender genderData) async {
    MasterGender? editedGenderData = await getGenderById(genderData.id);
    if (editedGenderData != null) {
      MasterGender updatedGenderData = editedGenderData.copyWith(
        id: genderData.id,
        usia: genderData.usia,
        bulan: genderData.bulan,
        gender: genderData.gender,
      );
      await _masterGenderRepository.editGenderData(updatedGenderData);
    } else {
      throw Exception('Master Gender Data not found');
    }
  }

  Future<void> deleteGenderData(int id) async {
    await _masterGenderRepository.deleteGenderData(id);
  }
}
