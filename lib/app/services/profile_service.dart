import 'dart:math';
import 'package:logger/logger.dart';

import 'package:periodnpregnancycalender/app/utils/utils.dart';
import 'package:periodnpregnancycalender/app/repositories/repositories.dart';
import 'package:periodnpregnancycalender/app/models/models.dart';

class ProfileService {
  final Logger _logger = Logger();
  final StorageService storageService = StorageService();

  late final LocalProfileRepository _localProfileRepository = LocalProfileRepository();

  Future<void> createProfile(String tanggalLahir, int isPregnant) async {
    try {
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
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
    }
  }

  Future<void> createLoginProfile(String nama, String tanggalLahir, int isPregnant, String email) async {
    try {
      final newProfile = User(
        status: "Verified",
        nama: nama,
        tanggalLahir: tanggalLahir,
        isPregnant: isPregnant.toString(),
        email: email,
        updatedAt: DateTime.now().toIso8601String(),
        createdAt: DateTime.now().toIso8601String(),
      );
      await _localProfileRepository.createProfile(newProfile);
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
    }
  }

  Future<void> updateProfileToGuest(String tanggalLahir, int isPregnant) async {
    try {
      final profile = await _localProfileRepository.getProfile();
      final random = Random();
      String randomDigits = '';

      for (int i = 0; i < 6; i++) {
        randomDigits += random.nextInt(10).toString();
      }

      String nama = 'User$randomDigits';

      if (profile != null) {
        User? updatedProfileGuest = profile.copyWith(
          nama: nama,
          status: "Unverified",
          tanggalLahir: tanggalLahir,
          isPregnant: isPregnant.toString(),
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
        );
        await _localProfileRepository.updateProfile(updatedProfileGuest);
      } else {
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
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
    }
  }

  Future<void> updateProfile(String nama, String tanggalLahir) async {
    try {
      final profile = await _localProfileRepository.getProfile();
      final updatedProfile = profile!.copyWith(
        nama: nama,
        tanggalLahir: tanggalLahir,
        updatedAt: DateTime.now().toIso8601String(),
      );
      await _localProfileRepository.updateProfile(updatedProfile);
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
    }
  }

  Future<User?> getProfile() async {
    return await _localProfileRepository.getProfile();
  }

  Future<void> deleteProfile() async {
    try {
      await _localProfileRepository.deleteProfile();
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
    }
  }

  Future<void> deletePendingDataChanges() async {
    try {
      await _localProfileRepository.deletePendingDataChanges();
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
    }
  }
}
