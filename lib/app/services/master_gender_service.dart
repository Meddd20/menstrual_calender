import 'package:periodnpregnancycalender/app/repositories/repositories.dart';
import 'package:periodnpregnancycalender/app/models/models.dart';

class MasterGenderService {
  late final MasterGenderRepository _masterGenderRepository = MasterGenderRepository();

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
