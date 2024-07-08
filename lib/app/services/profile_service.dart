import 'dart:math';
import 'package:periodnpregnancycalender/app/models/profile_model.dart';
import 'package:periodnpregnancycalender/app/repositories/local/profile_repository.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';

class ProfileService {
  final LocalProfileRepository _localProfileRepository;
  final StorageService storageService = StorageService();

  ProfileService(this._localProfileRepository);

  Future<void> createProfile(String tanggalLahir, int isPregnant) async {
    final random = Random();
    String randomDigits = '';

    for (int i = 0; i < 6; i++) {
      randomDigits += random.nextInt(10).toString();
    }

    String nama = 'User$randomDigits';

    final newProfile = User(
      status: "Unverified",
      nama: nama,
      tanggalLahir: tanggalLahir,
      isPregnant: isPregnant.toString(),
      updatedAt: DateTime.now().toIso8601String(),
      createdAt: DateTime.now().toIso8601String(),
    );
    await _localProfileRepository.createProfile(newProfile);
  }

  Future<void> createLoginProfile(String nama, String tanggalLahir, int isPregnant) async {
    final newProfile = User(
      status: "Verified",
      nama: nama,
      tanggalLahir: tanggalLahir,
      isPregnant: isPregnant.toString(),
      updatedAt: DateTime.now().toIso8601String(),
      createdAt: DateTime.now().toIso8601String(),
    );
    await _localProfileRepository.createProfile(newProfile);
  }

  Future<void> updateProfile(int id, String nama, String tanggalLahir) async {
    final profile = await _localProfileRepository.getProfile();
    final updatedProfile = profile!.copyWith(
      nama: nama,
      tanggalLahir: tanggalLahir,
      updatedAt: DateTime.now().toIso8601String(),
    );
    await _localProfileRepository.updateProfile(updatedProfile);
  }

  Future<User?> getProfile() async {
    return await _localProfileRepository.getProfile();
  }

  Future<void> deleteProfile() async {
    int userId = storageService.getAccountLocalId();
    await _localProfileRepository.deleteProfile(userId);
  }
}
