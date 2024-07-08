import 'package:periodnpregnancycalender/app/models/master_pregnancy_model.dart';
import 'package:periodnpregnancycalender/app/models/period_cycle_model.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_model.dart';
import 'package:periodnpregnancycalender/app/models/profile_model.dart';
import 'package:periodnpregnancycalender/app/repositories/local/master_kehamilan_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/period_history_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/pregnancy_history_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/profile_repository.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';

class PregnancyHistoryService {
  final PregnancyHistoryRepository _pregnancyHistoryRepository;
  final MasterKehamilanRepository _masterKehamilanRepository;
  final PeriodHistoryRepository _periodHistoryRepository;
  final LocalProfileRepository _localProfileRepository;
  final StorageService storageService = StorageService();

  PregnancyHistoryService(
    this._pregnancyHistoryRepository,
    this._masterKehamilanRepository,
    this._periodHistoryRepository,
    this._localProfileRepository,
  );

  Future<void> beginPregnancy(DateTime hariPertamaHaidTerakhir) async {
    try {
      int userId = storageService.getAccountLocalId();
      User? userProfile = await _localProfileRepository.getProfile();
      PregnancyHistory? existingPregnancyData = await _pregnancyHistoryRepository.getCurrentPregnancyHistory(userId);
      List<PeriodHistory> getAllPeriodHistory = await _periodHistoryRepository.getPeriodHistory(userId);
      List<PeriodHistory> isActualPeriodHistories = getAllPeriodHistory.where((period) => period.isActual == "1").toList();

      DateTime estimatedDueDate = hariPertamaHaidTerakhir.add(Duration(days: 280));

      if (isActualPeriodHistories.isNotEmpty) {
        int totalSiklus = 0;
        int countSiklus = 0;

        for (var period in isActualPeriodHistories) {
          if (period.lamaSiklus != null) {
            totalSiklus += period.lamaSiklus!;
            countSiklus++;
          }
        }

        if (countSiklus > 0) {
          int avgPeriodCycle = totalSiklus ~/ countSiklus;

          PeriodHistory lastPeriod = isActualPeriodHistories.last;
          PeriodHistory updatedLastPeriod = lastPeriod.copyWith(
            lamaSiklus: avgPeriodCycle,
            hariTerakhirSiklus: lastPeriod.haidAwal?.add(Duration(days: avgPeriodCycle)),
          );

          await _periodHistoryRepository.editPeriodHistory(updatedLastPeriod);
        }
      }

      if (existingPregnancyData != null && userProfile?.isPregnant == "1") {
        PregnancyHistory updatedPregnancyData = existingPregnancyData.copyWith(
          hariPertamaHaidTerakhir: hariPertamaHaidTerakhir.toIso8601String(),
          tanggalPerkiraanLahir: estimatedDueDate.toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
        );

        await _pregnancyHistoryRepository.editPregnancy(updatedPregnancyData);
      } else {
        PregnancyHistory newPregnancyData = PregnancyHistory(
          userId: userId,
          status: "Hamil",
          hariPertamaHaidTerakhir: hariPertamaHaidTerakhir.toIso8601String(),
          tanggalPerkiraanLahir: estimatedDueDate.toIso8601String(),
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
        );
        await _pregnancyHistoryRepository.beginPregnancy(newPregnancyData);

        User updateUserProfile = userProfile!.copyWith(
          isPregnant: "1",
          updatedAt: DateTime.now().toIso8601String(),
        );

        await _localProfileRepository.updateProfile(updateUserProfile);
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<void> endPregnancy(DateTime kehamilanAkhir, String babyGender) async {
    int userId = storageService.getAccountLocalId();
    if (babyGender != "Boy" && babyGender != "Girl") {
      throw Exception("Gender harus diisi dengan 'boy' atau 'girl'.");
    }
    User? userProfile = await _localProfileRepository.getProfile();
    PregnancyHistory? existingPregnancyData = await _pregnancyHistoryRepository.getCurrentPregnancyHistory(userId);

    if (existingPregnancyData != null) {
      PregnancyHistory updatedPregnancyData = existingPregnancyData.copyWith(
        status: "Melahirkan",
        kehamilanAkhir: kehamilanAkhir.toIso8601String(),
        gender: babyGender,
        updatedAt: DateTime.now().toIso8601String(),
      );

      await _pregnancyHistoryRepository.editPregnancy(updatedPregnancyData);

      User updateUserProfile = userProfile!.copyWith(
        isPregnant: "0",
        updatedAt: DateTime.now().toIso8601String(),
      );

      await _localProfileRepository.updateProfile(updateUserProfile);
    } else {
      throw Exception('Data kehamilan tidak ditemukan');
    }
  }

  Future<void> deletePregnancy() async {
    int userId = storageService.getAccountLocalId();
    User? userProfile = await _localProfileRepository.getProfile();

    User updateUserProfile = userProfile!.copyWith(
      isPregnant: "0",
      updatedAt: DateTime.now().toIso8601String(),
    );

    await _localProfileRepository.updateProfile(updateUserProfile);
    await _pregnancyHistoryRepository.deletePregnancy(userId);
  }

  Future<List<PregnancyHistory>?> getAllPregnancyHistory(int userId) async {
    return await _pregnancyHistoryRepository.getAllPregnancyHistory(userId);
  }

  Future<CurrentlyPregnant?> getCurrentPregnancyData(String lang) async {
    int userId = storageService.getAccountLocalId();
    PregnancyHistory? currentPregnancyData = await _pregnancyHistoryRepository.getCurrentPregnancyHistory(userId);

    List<MasterPregnancy> masterDataKehamilan = await _masterKehamilanRepository.getAllMasterKehamilan();

    if (currentPregnancyData != null) {
      DateTime hariPertamaHaidTerakhir = DateTime.parse(currentPregnancyData.hariPertamaHaidTerakhir ?? "");
      Duration differenceDays = DateTime.now().difference(hariPertamaHaidTerakhir);

      int weeksPregnant = (differenceDays.inDays / 7).ceil();
      List<WeeklyData>? weeklyData = [];

      for (var minggu = 1; minggu <= 40; minggu++) {
        MasterPregnancy? masterDataKehamilanMingguIni = masterDataKehamilan.firstWhere((masterDataKehamilan) => masterDataKehamilan.mingguKehamilan == minggu);

        int mingguSisa = 40 - minggu;

        DateTime parsedhariPertamaHaidTerakhir = DateTime.parse(currentPregnancyData.hariPertamaHaidTerakhir ?? "");

        DateTime parsedTanggalAwalMinggu = parsedhariPertamaHaidTerakhir.add(Duration(days: (minggu - 1) * 7));
        DateTime parsedTanggalAkhirMinggu = parsedhariPertamaHaidTerakhir.add(Duration(days: (minggu * 7) - 1));

        int trimester;
        if (minggu <= 12) {
          trimester = 1;
        } else if (minggu <= 26) {
          trimester = 2;
        } else {
          trimester = 3;
        }

        String mingguLabel = minggu < weeksPregnant
            ? lang == "en"
                ? "${(weeksPregnant - minggu)} Weeks ago"
                : "${(weeksPregnant - minggu)} minggu lalu"
            : minggu > weeksPregnant
                ? lang == "en"
                    ? "Next ${(minggu - weeksPregnant)} week"
                    : "${(minggu - weeksPregnant)} minggu ke depan"
                : lang == "en"
                    ? "This week"
                    : "Minggu ini";

        WeeklyData weeklyMasterData = WeeklyData(
          mingguKehamilan: minggu,
          trimester: trimester,
          mingguSisa: mingguSisa,
          mingguLabel: mingguLabel,
          tanggalAwalMinggu: parsedTanggalAwalMinggu.toIso8601String(),
          tanggalAkhirMinggu: parsedTanggalAkhirMinggu.toIso8601String(),
          beratJanin: masterDataKehamilanMingguIni.beratJanin,
          tinggiBadanJanin: masterDataKehamilanMingguIni.tinggiBadanJanin,
          ukuranBayi: lang == "en" ? masterDataKehamilanMingguIni.ukuranBayiEn : masterDataKehamilanMingguIni.ukuranBayiId,
          poinUtama: lang == "en" ? masterDataKehamilanMingguIni.perkembanganBayiEn : masterDataKehamilanMingguIni.perkembanganBayiId,
          perkembanganBayi: lang == "en" ? masterDataKehamilanMingguIni.perkembanganBayiEn : masterDataKehamilanMingguIni.perkembanganBayiId,
          perubahanTubuh: lang == "en" ? masterDataKehamilanMingguIni.perubahanTubuhEn : masterDataKehamilanMingguIni.perubahanTubuhId,
          gejalaUmum: lang == "en" ? masterDataKehamilanMingguIni.gejalaUmumEn : masterDataKehamilanMingguIni.gejalaUmumId,
          tipsMingguan: lang == "en" ? masterDataKehamilanMingguIni.tipsMingguanEn : masterDataKehamilanMingguIni.tipsMingguanId,
          bayiImgPath: masterDataKehamilanMingguIni.bayiImgPath,
          ukuranBayiImgPath: masterDataKehamilanMingguIni.ukuranBayiImgPath,
        );

        weeklyData.add(weeklyMasterData);
      }

      return await CurrentlyPregnant(
        pregnancyId: currentPregnancyData.id,
        status: currentPregnancyData.status,
        hariPertamaHaidTerakhir: currentPregnancyData.hariPertamaHaidTerakhir,
        tanggalPerkiraanLahir: currentPregnancyData.tanggalPerkiraanLahir,
        usiaKehamilan: weeksPregnant,
        weeklyData: weeklyData,
      );
    } else {
      throw Exception('Data kehamilan tidak ditemukan');
    }
  }
}
