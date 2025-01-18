import 'dart:math';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import 'package:periodnpregnancycalender/app/utils/utils.dart';
import 'package:periodnpregnancycalender/app/repositories/repositories.dart';
import 'package:periodnpregnancycalender/app/models/models.dart';

class WeightHistoryService {
  final Logger _logger = Logger();
  final StorageService storageService = StorageService();

  late final WeightHistoryRepository _weightHistoryRepository = WeightHistoryRepository();
  late final PregnancyHistoryRepository _pregnancyHistoryRepository = PregnancyHistoryRepository();

  Future<WeightHistory?> initWeightGain(double tinggiBadan, double beratPrakehamilan, int isTwin) async {
    try {
      int userId = storageService.getAccountLocalId();
      PregnancyHistory? currentPregnancyData = await _pregnancyHistoryRepository.getCurrentPregnancyHistory(userId);
      List<WeightHistory?> weightHistory = await _weightHistoryRepository.getWeightHistory(userId);
      List<WeightHistory?> weightDataOnThisPregnancy;
      if (currentPregnancyData != null) {
        weightDataOnThisPregnancy = weightHistory.where((weight) => weight?.riwayatKehamilanId == currentPregnancyData.id).toList();

        if (isTwin != 0 && isTwin != 1) {
          throw Exception("Is Twin harus diisi dengan 0 atau 1");
        }

        double tinggiBadanByMeter = tinggiBadan / 100;
        double bmiPrakehamilan = beratPrakehamilan / pow(tinggiBadanByMeter, 2);

        String kategoriBMI;
        if (bmiPrakehamilan < 18.5) {
          kategoriBMI = "underweight";
        } else if (bmiPrakehamilan >= 18.5 && bmiPrakehamilan < 24.9) {
          kategoriBMI = "normal";
        } else if (bmiPrakehamilan >= 25 && bmiPrakehamilan < 29.9) {
          kategoriBMI = "overweight";
        } else {
          kategoriBMI = "obese";
        }

        PregnancyHistory? updatedPregnancyWeightData = currentPregnancyData.copyWith(
          tinggiBadan: tinggiBadan,
          beratPrakehamilan: beratPrakehamilan,
          bmiPrakehamilan: bmiPrakehamilan,
          kategoriBmi: kategoriBMI,
          isTwin: isTwin.toString(),
          updatedAt: DateTime.now().toIso8601String(),
        );

        await _pregnancyHistoryRepository.editPregnancy(updatedPregnancyWeightData);

        if (weightDataOnThisPregnancy.length > 0) {
          WeightHistory? initWeightHistory = weightDataOnThisPregnancy[0];
          WeightHistory? nextWeightHistory = weightDataOnThisPregnancy.length > 1 ? weightDataOnThisPregnancy[1] : null;

          if (initWeightHistory != null) {
            WeightHistory updatedinitWeightHistory = initWeightHistory.copyWith(
              beratBadan: beratPrakehamilan,
              pertambahanBerat: 0,
              updatedAt: DateTime.now().toString(),
            );
            await _weightHistoryRepository.editWeightHistory(updatedinitWeightHistory);
          }

          double? weightGain;
          if (nextWeightHistory != null && nextWeightHistory.beratBadan != null) {
            weightGain = nextWeightHistory.beratBadan! - beratPrakehamilan;
            WeightHistory updatednextWeightHistory = nextWeightHistory.copyWith(
              pertambahanBerat: weightGain,
              updatedAt: DateTime.now().toIso8601String(),
            );
            await _weightHistoryRepository.editWeightHistory(updatednextWeightHistory);
          }
        } else {
          DateTime hariPertamaHaidTerakhirDate = DateTime.parse(currentPregnancyData.hariPertamaHaidTerakhir ?? "");
          DateTime tanggalPencatatan = hariPertamaHaidTerakhirDate.subtract(Duration(days: 1));

          WeightHistory? newWeightData = WeightHistory(
            userId: userId,
            riwayatKehamilanId: currentPregnancyData.id,
            beratBadan: beratPrakehamilan,
            mingguKehamilan: 0,
            tanggalPencatatan: tanggalPencatatan.toString(),
            pertambahanBerat: 0,
            updatedAt: DateTime.now().toString(),
            createdAt: DateTime.now().toString(),
          );

          await _weightHistoryRepository.addWeightHistory(newWeightData);
        }

        List<WeightHistory?> updatedWeightDataOnThisPregnancy = weightHistory.where((weight) => weight?.riwayatKehamilanId == currentPregnancyData.id).toList();
        WeightHistory? updatedWeight = updatedWeightDataOnThisPregnancy.firstWhereOrNull((weight) => weight?.mingguKehamilan == 0);
        return updatedWeight != null ? updatedWeight : null;
      } else {
        throw Exception('Data tidak lengkap');
      }
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
      rethrow;
    }
  }

  Future<WeightHistory?> addWeeklyWeightGain(DateTime tanggalPencatatan, double beratBadan, int mingguKehamilan) async {
    try {
      String formattedDate = formatDate(tanggalPencatatan);

      int userId = storageService.getAccountLocalId();
      PregnancyHistory? currentPregnancyData = await _pregnancyHistoryRepository.getCurrentPregnancyHistory(userId);
      List<WeightHistory?> getAllWeightHistory = await _weightHistoryRepository.getWeightHistory(userId);
      List<WeightHistory?> weightDataOnThisPregnancy = getAllWeightHistory.where((weight) => weight?.riwayatKehamilanId == currentPregnancyData?.id).toList();

      if (currentPregnancyData != null) {
        DateTime hariPertamaHaidTerakhir = DateTime.parse(currentPregnancyData.hariPertamaHaidTerakhir ?? "");
        DateTime tanggalPerkiraanLahir = DateTime.parse(currentPregnancyData.tanggalPerkiraanLahir ?? "");

        if ((tanggalPencatatan.isAfter(hariPertamaHaidTerakhir) && tanggalPencatatan.isBefore(tanggalPerkiraanLahir)) || tanggalPencatatan.isAtSameMomentAs(hariPertamaHaidTerakhir) || tanggalPencatatan.isAtSameMomentAs(tanggalPerkiraanLahir)) {
          WeightHistory? matchingTanggalPencatatan = weightDataOnThisPregnancy.firstWhereOrNull(
            (wh) => wh?.userId == userId && wh?.riwayatKehamilanId == currentPregnancyData.id && wh?.tanggalPencatatan == formattedDate,
          );

          if (matchingTanggalPencatatan != null) {
            WeightHistory updatedCurrentIndexWeightData = matchingTanggalPencatatan.copyWith(
              beratBadan: beratBadan,
              updatedAt: DateTime.now().toString(),
            );
            await _weightHistoryRepository.editWeightHistory(updatedCurrentIndexWeightData);
          } else {
            WeightHistory newWeightData = WeightHistory(
              userId: userId,
              riwayatKehamilanId: currentPregnancyData.id,
              beratBadan: beratBadan,
              mingguKehamilan: mingguKehamilan,
              tanggalPencatatan: formattedDate,
              createdAt: DateTime.now().toString(),
              updatedAt: DateTime.now().toString(),
            );

            await _weightHistoryRepository.addWeightHistory(newWeightData);
          }

          List<WeightHistory?> updatedWeightHistory = await _weightHistoryRepository.getWeightHistory(userId);
          List<WeightHistory?> updatedWeightDataOnThisPregnancy = updatedWeightHistory.where((weight) => weight?.riwayatKehamilanId == currentPregnancyData.id).toList();

          updatedWeightDataOnThisPregnancy.sort((a, b) {
            if (a != null && b != null) {
              int compareMinggu = a.mingguKehamilan!.compareTo(b.mingguKehamilan!);
              if (compareMinggu != 0) {
                return compareMinggu;
              }
              return a.tanggalPencatatan!.compareTo(b.tanggalPencatatan!);
            }
            return 0;
          });

          WeightHistory? matchingNewTanggalPencatatan = updatedWeightDataOnThisPregnancy.firstWhereOrNull((wh) {
            if (wh?.userId == userId && wh?.tanggalPencatatan != null) {
              return formatDate(DateTime.parse(wh!.tanggalPencatatan!)) == formattedDate;
            }
            return false;
          });

          if (matchingNewTanggalPencatatan != null) {
            int index = updatedWeightDataOnThisPregnancy.indexWhere((r) => r?.id == matchingNewTanggalPencatatan.id);
            WeightHistory? previousIndexWeightData = index > 0 ? updatedWeightDataOnThisPregnancy[index - 1] : null;
            WeightHistory? nextIndexWeightData = index < updatedWeightDataOnThisPregnancy.length - 1 ? updatedWeightDataOnThisPregnancy[index + 1] : null;

            if (nextIndexWeightData != null && nextIndexWeightData.beratBadan != null) {
              double pertambahanBeratNextIndexData = nextIndexWeightData.beratBadan! - beratBadan;
              WeightHistory updatedNextIndexWeightData = nextIndexWeightData.copyWith(
                pertambahanBerat: pertambahanBeratNextIndexData,
                updatedAt: DateTime.now().toString(),
              );
              await _weightHistoryRepository.editWeightHistory(updatedNextIndexWeightData);
            }
            if (previousIndexWeightData != null && previousIndexWeightData.beratBadan != null) {
              double pertambahanBeratCurrentIndexData = beratBadan - previousIndexWeightData.beratBadan!;
              WeightHistory updatedCurrentIndexWeightData = matchingNewTanggalPencatatan.copyWith(
                pertambahanBerat: pertambahanBeratCurrentIndexData,
                updatedAt: DateTime.now().toString(),
              );

              await _weightHistoryRepository.editWeightHistory(updatedCurrentIndexWeightData);
            }

            return matchingNewTanggalPencatatan;
          } else {
            throw Exception("Data Weight History tidak ditemukan");
          }
        } else {
          throw Exception('Tanggal pencatatan harus antara hari pertama haid terakhir dan tanggal perkiraan lahir');
        }
      } else {
        throw Exception('Data kehamilan tidak ditemukan');
      }
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
      rethrow;
    }
  }

  Future<WeightHistory?> deleteWeeklyWeightGain(String tanggalPencatatan) async {
    try {
      int userId = storageService.getAccountLocalId();
      PregnancyHistory? currentPregnancyData = await _pregnancyHistoryRepository.getCurrentPregnancyHistory(userId);
      List<WeightHistory?> getAllWeightHistory = await _weightHistoryRepository.getWeightHistory(userId);
      List<WeightHistory?> weightDataOnThisPregnancy = getAllWeightHistory.where((weight) => weight?.riwayatKehamilanId == currentPregnancyData?.id).toList();

      WeightHistory? matchingDataById = weightDataOnThisPregnancy.firstWhereOrNull((wh) => wh != null && wh.tanggalPencatatan! == tanggalPencatatan && wh.userId == userId);

      if (matchingDataById != null) {
        int index = weightDataOnThisPregnancy.indexWhere((r) => r != null && formatDate(DateTime.parse(r.tanggalPencatatan!)) == tanggalPencatatan);

        if (index != -1) {
          WeightHistory? previousIndexWeightData = index > 0 ? weightDataOnThisPregnancy[index - 1] : null;
          WeightHistory? nextIndexWeightData = index < weightDataOnThisPregnancy.length - 1 ? weightDataOnThisPregnancy[index + 1] : null;

          await _weightHistoryRepository.deleteWeightHistory(tanggalPencatatan.toString(), userId);

          if (nextIndexWeightData != null && nextIndexWeightData.beratBadan != null && previousIndexWeightData != null && previousIndexWeightData.beratBadan != null) {
            double pertambahanBeratNewNextData = nextIndexWeightData.beratBadan! - previousIndexWeightData.beratBadan!;

            WeightHistory? updateNextWeightData = nextIndexWeightData.copyWith(
              pertambahanBerat: pertambahanBeratNewNextData,
              updatedAt: DateTime.now().toString(),
            );

            await _weightHistoryRepository.editWeightHistory(updateNextWeightData);
          }
        } else {
          throw Exception("Data Weight History tidak ditemukan");
        }

        return matchingDataById;
      } else {
        throw Exception("Data Weight History tidak ditemukan");
      }
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
      rethrow;
    }
  }

  Future<PregnancyWeightGainData> getPregnancyWeightGainData() async {
    int userId = storageService.getAccountLocalId();
    PregnancyHistory? currentPregnancyData = await _pregnancyHistoryRepository.getCurrentPregnancyHistory(userId);
    List<WeightHistory>? getAllWeightHistory = await _weightHistoryRepository.getWeightHistory(userId);
    List<WeightHistory>? weightDataOnThisPregnancy = getAllWeightHistory.where((weight) => weight.riwayatKehamilanId == currentPregnancyData!.id).toList();

    WeightHistory? initWeightData = weightDataOnThisPregnancy.isNotEmpty ? weightDataOnThisPregnancy[0] : null;
    WeightHistory? lastWeightData = weightDataOnThisPregnancy.isNotEmpty ? weightDataOnThisPregnancy[weightDataOnThisPregnancy.length - 1] : null;

    if (currentPregnancyData == null) {
      throw Exception('Data kehamilan tidak ditemukan');
    }

    if (weightDataOnThisPregnancy.length < 1) {
      return PregnancyWeightGainData();
    }

    double? totalGain;
    if (lastWeightData?.beratBadan != null && initWeightData?.beratBadan != null) {
      totalGain = lastWeightData!.beratBadan! - initWeightData!.beratBadan!;
    } else {
      totalGain = 0;
    }

    List<RecommendWeightGain> recommendWeightGain = (weightData[currentPregnancyData.kategoriBmi?.toLowerCase()] ?? []).map<RecommendWeightGain>((data) => RecommendWeightGain.fromJson(data)).toList();

    double prepregnancyWeight = currentPregnancyData.beratPrakehamilan ?? 0;
    recommendWeightGain = recommendWeightGain.map((data) {
      return RecommendWeightGain(
        week: data.week,
        lowerWeightGain: data.lowerWeightGain,
        upperWeightGain: data.upperWeightGain,
        recommendWeightLower: data.lowerWeightGain! + prepregnancyWeight,
        recommendWeightUpper: data.upperWeightGain! + prepregnancyWeight,
      );
    }).toList();

    Duration differenceDays = DateTime.now().difference(DateTime.parse(currentPregnancyData.hariPertamaHaidTerakhir ?? ""));
    int weeksPregnant = (differenceDays.inDays / 7).ceil();

    RecommendWeightGain? thisWeekData;
    RecommendWeightGain? nextWeekData;

    for (var data in recommendWeightGain) {
      if (data.week == weeksPregnant) {
        thisWeekData = data;
      } else if (data.week == weeksPregnant + 1) {
        nextWeekData = data;
      }
      if (thisWeekData != null && nextWeekData != null) {
        break;
      }
    }

    weightDataOnThisPregnancy.sort((a, b) {
      int compareMinggu = b.mingguKehamilan!.compareTo(a.mingguKehamilan!);
      if (compareMinggu != 0) {
        return compareMinggu;
      }
      return b.tanggalPencatatan!.compareTo(a.tanggalPencatatan!);
    });

    return PregnancyWeightGainData(
      week: weeksPregnant,
      prepregnancyWeight: prepregnancyWeight,
      currentWeight: lastWeightData?.beratBadan,
      totalGain: totalGain,
      prepregnancyBmi: currentPregnancyData.bmiPrakehamilan,
      prepregnancyHeight: currentPregnancyData.tinggiBadan,
      bmiCategory: currentPregnancyData.kategoriBmi,
      isTwin: currentPregnancyData.isTwin,
      currentWeekReccomendWeight: "${thisWeekData?.recommendWeightLower} - ${thisWeekData?.recommendWeightUpper}",
      nextWeekReccomendWeight: "${nextWeekData?.recommendWeightLower} - ${nextWeekData?.recommendWeightUpper}",
      weightHistory: weightDataOnThisPregnancy,
      reccomendWeightGain: recommendWeightGain,
    );
  }

  Future<void> syncWeeklyWeightGain(WeightHistory weightHistory) async {
    int userId = storageService.getAccountLocalId();
    List<PregnancyHistory>? allPregnancyHistory = await _pregnancyHistoryRepository.getAllPregnancyHistory(userId);

    PregnancyHistory? currentPregnancyData = allPregnancyHistory.firstWhere(
      (ph) => ph.remoteId == weightHistory.riwayatKehamilanId,
      orElse: () => PregnancyHistory(id: -1),
    );

    if (currentPregnancyData.id == -1) {
      throw Exception("Pregnancy history not found for the given weight history.");
    }

    WeightHistory? newWeightData = WeightHistory(
      userId: userId,
      riwayatKehamilanId: currentPregnancyData.id,
      beratBadan: weightHistory.beratBadan,
      mingguKehamilan: weightHistory.mingguKehamilan,
      tanggalPencatatan: weightHistory.tanggalPencatatan.toString(),
      pertambahanBerat: weightHistory.pertambahanBerat,
      updatedAt: DateTime.now().toString(),
      createdAt: DateTime.now().toString(),
    );

    await _weightHistoryRepository.addWeightHistory(newWeightData);
  }
}

final weightData = {
  'underweight': [
    {'week': 1, 'lower_weight_gain': 0, 'upper_weight_gain': 0},
    {'week': 2, 'lower_weight_gain': 0.04, 'upper_weight_gain': 0.2},
    {'week': 3, 'lower_weight_gain': 0.08, 'upper_weight_gain': 0.3},
    {'week': 4, 'lower_weight_gain': 0.1, 'upper_weight_gain': 0.5},
    {'week': 5, 'lower_weight_gain': 0.2, 'upper_weight_gain': 0.7},
    {'week': 6, 'lower_weight_gain': 0.2, 'upper_weight_gain': 0.8},
    {'week': 7, 'lower_weight_gain': 0.2, 'upper_weight_gain': 1.0},
    {'week': 8, 'lower_weight_gain': 0.3, 'upper_weight_gain': 1.2},
    {'week': 9, 'lower_weight_gain': 0.3, 'upper_weight_gain': 1.3},
    {'week': 10, 'lower_weight_gain': 0.4, 'upper_weight_gain': 1.5},
    {'week': 11, 'lower_weight_gain': 0.4, 'upper_weight_gain': 1.7},
    {'week': 12, 'lower_weight_gain': 0.5, 'upper_weight_gain': 1.8},
    {'week': 13, 'lower_weight_gain': 0.5, 'upper_weight_gain': 2.0},
    {'week': 14, 'lower_weight_gain': 1.0, 'upper_weight_gain': 2.6},
    {'week': 15, 'lower_weight_gain': 1.4, 'upper_weight_gain': 3.2},
    {'week': 16, 'lower_weight_gain': 1.9, 'upper_weight_gain': 3.8},
    {'week': 17, 'lower_weight_gain': 2.3, 'upper_weight_gain': 4.4},
    {'week': 18, 'lower_weight_gain': 2.8, 'upper_weight_gain': 5.0},
    {'week': 19, 'lower_weight_gain': 3.2, 'upper_weight_gain': 5.6},
    {'week': 20, 'lower_weight_gain': 3.7, 'upper_weight_gain': 6.2},
    {'week': 21, 'lower_weight_gain': 4.1, 'upper_weight_gain': 6.8},
    {'week': 22, 'lower_weight_gain': 4.6, 'upper_weight_gain': 7.4},
    {'week': 23, 'lower_weight_gain': 5.0, 'upper_weight_gain': 8.0},
    {'week': 24, 'lower_weight_gain': 5.5, 'upper_weight_gain': 8.6},
    {'week': 25, 'lower_weight_gain': 5.9, 'upper_weight_gain': 9.2},
    {'week': 26, 'lower_weight_gain': 6.4, 'upper_weight_gain': 9.8},
    {'week': 27, 'lower_weight_gain': 6.8, 'upper_weight_gain': 10.4},
    {'week': 28, 'lower_weight_gain': 7.3, 'upper_weight_gain': 11.0},
    {'week': 29, 'lower_weight_gain': 7.7, 'upper_weight_gain': 11.6},
    {'week': 30, 'lower_weight_gain': 8.2, 'upper_weight_gain': 12.2},
    {'week': 31, 'lower_weight_gain': 8.6, 'upper_weight_gain': 12.8},
    {'week': 32, 'lower_weight_gain': 9.1, 'upper_weight_gain': 13.4},
    {'week': 33, 'lower_weight_gain': 9.5, 'upper_weight_gain': 14.0},
    {'week': 34, 'lower_weight_gain': 10.0, 'upper_weight_gain': 14.6},
    {'week': 35, 'lower_weight_gain': 10.4, 'upper_weight_gain': 15.2},
    {'week': 36, 'lower_weight_gain': 10.9, 'upper_weight_gain': 15.8},
    {'week': 37, 'lower_weight_gain': 11.3, 'upper_weight_gain': 16.3},
    {'week': 38, 'lower_weight_gain': 11.8, 'upper_weight_gain': 16.9},
    {'week': 39, 'lower_weight_gain': 12.2, 'upper_weight_gain': 17.5},
    {'week': 40, 'lower_weight_gain': 12.7, 'upper_weight_gain': 18.1},
  ],
  'normal': [
    {'week': 1, 'lower_weight_gain': 0, 'upper_weight_gain': 0},
    {'week': 2, 'lower_weight_gain': 0.04, 'upper_weight_gain': 0.2},
    {'week': 3, 'lower_weight_gain': 0.08, 'upper_weight_gain': 0.3},
    {'week': 4, 'lower_weight_gain': 0.1, 'upper_weight_gain': 0.5},
    {'week': 5, 'lower_weight_gain': 0.2, 'upper_weight_gain': 0.7},
    {'week': 6, 'lower_weight_gain': 0.2, 'upper_weight_gain': 0.8},
    {'week': 7, 'lower_weight_gain': 0.2, 'upper_weight_gain': 1.0},
    {'week': 8, 'lower_weight_gain': 0.3, 'upper_weight_gain': 1.2},
    {'week': 9, 'lower_weight_gain': 0.3, 'upper_weight_gain': 1.3},
    {'week': 10, 'lower_weight_gain': 0.4, 'upper_weight_gain': 1.5},
    {'week': 11, 'lower_weight_gain': 0.4, 'upper_weight_gain': 1.7},
    {'week': 12, 'lower_weight_gain': 0.5, 'upper_weight_gain': 1.8},
    {'week': 13, 'lower_weight_gain': 0.5, 'upper_weight_gain': 2.0},
    {'week': 14, 'lower_weight_gain': 0.9, 'upper_weight_gain': 2.5},
    {'week': 15, 'lower_weight_gain': 1.3, 'upper_weight_gain': 3.0},
    {'week': 16, 'lower_weight_gain': 1.7, 'upper_weight_gain': 3.5},
    {'week': 17, 'lower_weight_gain': 2.1, 'upper_weight_gain': 4.1},
    {'week': 18, 'lower_weight_gain': 2.5, 'upper_weight_gain': 4.6},
    {'week': 19, 'lower_weight_gain': 2.9, 'upper_weight_gain': 5.1},
    {'week': 20, 'lower_weight_gain': 3.3, 'upper_weight_gain': 5.6},
    {'week': 21, 'lower_weight_gain': 3.7, 'upper_weight_gain': 6.1},
    {'week': 22, 'lower_weight_gain': 4.1, 'upper_weight_gain': 6.6},
    {'week': 23, 'lower_weight_gain': 4.5, 'upper_weight_gain': 7.1},
    {'week': 24, 'lower_weight_gain': 4.9, 'upper_weight_gain': 7.7},
    {'week': 25, 'lower_weight_gain': 5.3, 'upper_weight_gain': 8.2},
    {'week': 26, 'lower_weight_gain': 5.7, 'upper_weight_gain': 8.7},
    {'week': 27, 'lower_weight_gain': 6.1, 'upper_weight_gain': 9.2},
    {'week': 28, 'lower_weight_gain': 6.5, 'upper_weight_gain': 9.7},
    {'week': 29, 'lower_weight_gain': 6.9, 'upper_weight_gain': 10.2},
    {'week': 30, 'lower_weight_gain': 7.3, 'upper_weight_gain': 10.7},
    {'week': 31, 'lower_weight_gain': 7.7, 'upper_weight_gain': 11.2},
    {'week': 32, 'lower_weight_gain': 8.1, 'upper_weight_gain': 11.8},
    {'week': 33, 'lower_weight_gain': 8.5, 'upper_weight_gain': 12.3},
    {'week': 34, 'lower_weight_gain': 8.9, 'upper_weight_gain': 12.8},
    {'week': 35, 'lower_weight_gain': 9.3, 'upper_weight_gain': 13.3},
    {'week': 36, 'lower_weight_gain': 9.7, 'upper_weight_gain': 13.8},
    {'week': 37, 'lower_weight_gain': 10.1, 'upper_weight_gain': 14.3},
    {'week': 38, 'lower_weight_gain': 10.5, 'upper_weight_gain': 14.8},
    {'week': 39, 'lower_weight_gain': 10.9, 'upper_weight_gain': 15.4},
    {'week': 40, 'lower_weight_gain': 11.3, 'upper_weight_gain': 15.9},
  ],
  'overweight': [
    {'week': 1, 'lower_weight_gain': 0, 'upper_weight_gain': 0},
    {'week': 2, 'lower_weight_gain': 0.04, 'upper_weight_gain': 0.2},
    {'week': 3, 'lower_weight_gain': 0.08, 'upper_weight_gain': 0.3},
    {'week': 4, 'lower_weight_gain': 0.1, 'upper_weight_gain': 0.5},
    {'week': 5, 'lower_weight_gain': 0.2, 'upper_weight_gain': 0.7},
    {'week': 6, 'lower_weight_gain': 0.2, 'upper_weight_gain': 0.8},
    {'week': 7, 'lower_weight_gain': 0.2, 'upper_weight_gain': 1.0},
    {'week': 8, 'lower_weight_gain': 0.3, 'upper_weight_gain': 1.2},
    {'week': 9, 'lower_weight_gain': 0.3, 'upper_weight_gain': 1.3},
    {'week': 10, 'lower_weight_gain': 0.4, 'upper_weight_gain': 1.5},
    {'week': 11, 'lower_weight_gain': 0.4, 'upper_weight_gain': 1.7},
    {'week': 12, 'lower_weight_gain': 0.5, 'upper_weight_gain': 1.8},
    {'week': 13, 'lower_weight_gain': 0.5, 'upper_weight_gain': 2.0},
    {'week': 14, 'lower_weight_gain': 0.7, 'upper_weight_gain': 2.3},
    {'week': 15, 'lower_weight_gain': 1.0, 'upper_weight_gain': 2.7},
    {'week': 16, 'lower_weight_gain': 1.2, 'upper_weight_gain': 3.0},
    {'week': 17, 'lower_weight_gain': 1.4, 'upper_weight_gain': 3.4},
    {'week': 18, 'lower_weight_gain': 1.7, 'upper_weight_gain': 3.7},
    {'week': 19, 'lower_weight_gain': 1.9, 'upper_weight_gain': 4.1},
    {'week': 20, 'lower_weight_gain': 2.1, 'upper_weight_gain': 4.4},
    {'week': 21, 'lower_weight_gain': 2.4, 'upper_weight_gain': 4.8},
    {'week': 22, 'lower_weight_gain': 2.6, 'upper_weight_gain': 5.1},
    {'week': 23, 'lower_weight_gain': 2.8, 'upper_weight_gain': 5.5},
    {'week': 24, 'lower_weight_gain': 3.1, 'upper_weight_gain': 5.8},
    {'week': 25, 'lower_weight_gain': 3.3, 'upper_weight_gain': 6.1},
    {'week': 26, 'lower_weight_gain': 3.5, 'upper_weight_gain': 6.5},
    {'week': 27, 'lower_weight_gain': 3.8, 'upper_weight_gain': 6.8},
    {'week': 28, 'lower_weight_gain': 4.0, 'upper_weight_gain': 7.2},
    {'week': 29, 'lower_weight_gain': 4.2, 'upper_weight_gain': 7.5},
    {'week': 30, 'lower_weight_gain': 4.5, 'upper_weight_gain': 7.9},
    {'week': 31, 'lower_weight_gain': 4.7, 'upper_weight_gain': 8.2},
    {'week': 32, 'lower_weight_gain': 4.9, 'upper_weight_gain': 8.6},
    {'week': 33, 'lower_weight_gain': 5.2, 'upper_weight_gain': 8.9},
    {'week': 34, 'lower_weight_gain': 5.4, 'upper_weight_gain': 9.3},
    {'week': 35, 'lower_weight_gain': 5.6, 'upper_weight_gain': 9.6},
    {'week': 36, 'lower_weight_gain': 5.9, 'upper_weight_gain': 10.0},
    {'week': 37, 'lower_weight_gain': 6.1, 'upper_weight_gain': 10.3},
    {'week': 38, 'lower_weight_gain': 6.3, 'upper_weight_gain': 10.6},
    {'week': 39, 'lower_weight_gain': 6.6, 'upper_weight_gain': 11.0},
    {'week': 40, 'lower_weight_gain': 6.8, 'upper_weight_gain': 11.3},
  ],
  'obese': [
    {'week': 1, 'lower_weight_gain': 0, 'upper_weight_gain': 0},
    {'week': 2, 'lower_weight_gain': 0.04, 'upper_weight_gain': 0.2},
    {'week': 3, 'lower_weight_gain': 0.08, 'upper_weight_gain': 0.3},
    {'week': 4, 'lower_weight_gain': 0.1, 'upper_weight_gain': 0.5},
    {'week': 5, 'lower_weight_gain': 0.2, 'upper_weight_gain': 0.7},
    {'week': 6, 'lower_weight_gain': 0.2, 'upper_weight_gain': 0.8},
    {'week': 7, 'lower_weight_gain': 0.2, 'upper_weight_gain': 1.0},
    {'week': 8, 'lower_weight_gain': 0.3, 'upper_weight_gain': 1.2},
    {'week': 9, 'lower_weight_gain': 0.3, 'upper_weight_gain': 1.3},
    {'week': 10, 'lower_weight_gain': 0.4, 'upper_weight_gain': 1.5},
    {'week': 11, 'lower_weight_gain': 0.4, 'upper_weight_gain': 1.7},
    {'week': 12, 'lower_weight_gain': 0.5, 'upper_weight_gain': 1.8},
    {'week': 13, 'lower_weight_gain': 0.5, 'upper_weight_gain': 2.0},
    {'week': 14, 'lower_weight_gain': 0.7, 'upper_weight_gain': 2.3},
    {'week': 15, 'lower_weight_gain': 0.8, 'upper_weight_gain': 2.5},
    {'week': 16, 'lower_weight_gain': 1.0, 'upper_weight_gain': 2.8},
    {'week': 17, 'lower_weight_gain': 1.2, 'upper_weight_gain': 3.0},
    {'week': 18, 'lower_weight_gain': 1.3, 'upper_weight_gain': 3.3},
    {'week': 19, 'lower_weight_gain': 1.5, 'upper_weight_gain': 3.6},
    {'week': 20, 'lower_weight_gain': 1.7, 'upper_weight_gain': 3.8},
    {'week': 21, 'lower_weight_gain': 1.8, 'upper_weight_gain': 4.1},
    {'week': 22, 'lower_weight_gain': 2.0, 'upper_weight_gain': 4.4},
    {'week': 23, 'lower_weight_gain': 2.2, 'upper_weight_gain': 4.6},
    {'week': 24, 'lower_weight_gain': 2.3, 'upper_weight_gain': 4.9},
    {'week': 25, 'lower_weight_gain': 2.5, 'upper_weight_gain': 5.1},
    {'week': 26, 'lower_weight_gain': 2.7, 'upper_weight_gain': 5.4},
    {'week': 27, 'lower_weight_gain': 2.8, 'upper_weight_gain': 5.7},
    {'week': 28, 'lower_weight_gain': 3.0, 'upper_weight_gain': 5.9},
    {'week': 29, 'lower_weight_gain': 3.2, 'upper_weight_gain': 6.2},
    {'week': 30, 'lower_weight_gain': 3.3, 'upper_weight_gain': 6.5},
    {'week': 31, 'lower_weight_gain': 3.5, 'upper_weight_gain': 6.7},
    {'week': 32, 'lower_weight_gain': 3.7, 'upper_weight_gain': 7.0},
    {'week': 33, 'lower_weight_gain': 3.8, 'upper_weight_gain': 7.2},
    {'week': 34, 'lower_weight_gain': 4.0, 'upper_weight_gain': 7.5},
    {'week': 35, 'lower_weight_gain': 4.2, 'upper_weight_gain': 7.8},
    {'week': 36, 'lower_weight_gain': 4.3, 'upper_weight_gain': 8.0},
    {'week': 37, 'lower_weight_gain': 4.5, 'upper_weight_gain': 8.3},
    {'week': 38, 'lower_weight_gain': 4.7, 'upper_weight_gain': 8.5},
    {'week': 39, 'lower_weight_gain': 4.8, 'upper_weight_gain': 8.8},
    {'week': 40, 'lower_weight_gain': 5.0, 'upper_weight_gain': 9.1},
  ],
  'underweight_twin': [
    {'week': 1, 'lower_weight_gain': 0, 'upper_weight_gain': 0},
    {'week': 2, 'lower_weight_gain': 0.04, 'upper_weight_gain': 0.2},
    {'week': 3, 'lower_weight_gain': 0.08, 'upper_weight_gain': 0.3},
    {'week': 4, 'lower_weight_gain': 0.1, 'upper_weight_gain': 0.5},
    {'week': 5, 'lower_weight_gain': 0.2, 'upper_weight_gain': 0.7},
    {'week': 6, 'lower_weight_gain': 0.2, 'upper_weight_gain': 0.8},
    {'week': 7, 'lower_weight_gain': 0.2, 'upper_weight_gain': 1.0},
    {'week': 8, 'lower_weight_gain': 0.3, 'upper_weight_gain': 1.2},
    {'week': 9, 'lower_weight_gain': 0.3, 'upper_weight_gain': 1.3},
    {'week': 10, 'lower_weight_gain': 0.4, 'upper_weight_gain': 1.5},
    {'week': 11, 'lower_weight_gain': 0.4, 'upper_weight_gain': 1.7},
    {'week': 12, 'lower_weight_gain': 0.5, 'upper_weight_gain': 1.8},
    {'week': 13, 'lower_weight_gain': 0.5, 'upper_weight_gain': 2.0},
    {'week': 14, 'lower_weight_gain': 1.1, 'upper_weight_gain': 2.8},
    {'week': 15, 'lower_weight_gain': 1.7, 'upper_weight_gain': 3.7},
    {'week': 16, 'lower_weight_gain': 2.3, 'upper_weight_gain': 4.5},
    {'week': 17, 'lower_weight_gain': 2.9, 'upper_weight_gain': 5.3},
    {'week': 18, 'lower_weight_gain': 3.5, 'upper_weight_gain': 6.2},
    {'week': 19, 'lower_weight_gain': 4.1, 'upper_weight_gain': 7.0},
    {'week': 20, 'lower_weight_gain': 4.7, 'upper_weight_gain': 7.8},
    {'week': 21, 'lower_weight_gain': 5.3, 'upper_weight_gain': 8.7},
    {'week': 22, 'lower_weight_gain': 5.9, 'upper_weight_gain': 9.5},
    {'week': 23, 'lower_weight_gain': 6.5, 'upper_weight_gain': 10.3},
    {'week': 24, 'lower_weight_gain': 7.1, 'upper_weight_gain': 11.2},
    {'week': 25, 'lower_weight_gain': 7.7, 'upper_weight_gain': 12.0},
    {'week': 26, 'lower_weight_gain': 8.3, 'upper_weight_gain': 12.8},
    {'week': 27, 'lower_weight_gain': 8.9, 'upper_weight_gain': 13.7},
    {'week': 28, 'lower_weight_gain': 9.5, 'upper_weight_gain': 14.5},
    {'week': 29, 'lower_weight_gain': 10.1, 'upper_weight_gain': 15.3},
    {'week': 30, 'lower_weight_gain': 10.8, 'upper_weight_gain': 16.2},
    {'week': 31, 'lower_weight_gain': 11.4, 'upper_weight_gain': 17.0},
    {'week': 32, 'lower_weight_gain': 12.0, 'upper_weight_gain': 17.8},
    {'week': 33, 'lower_weight_gain': 12.6, 'upper_weight_gain': 18.7},
    {'week': 34, 'lower_weight_gain': 13.2, 'upper_weight_gain': 19.5},
    {'week': 35, 'lower_weight_gain': 13.8, 'upper_weight_gain': 20.3},
    {'week': 36, 'lower_weight_gain': 14.4, 'upper_weight_gain': 21.2},
    {'week': 37, 'lower_weight_gain': 15.0, 'upper_weight_gain': 22.0},
    {'week': 38, 'lower_weight_gain': 15.6, 'upper_weight_gain': 22.8},
    {'week': 39, 'lower_weight_gain': 16.2, 'upper_weight_gain': 23.7},
    {'week': 40, 'lower_weight_gain': 16.8, 'upper_weight_gain': 24.5},
  ],
  'normal_twin': [
    {'week': 1, 'lower_weight_gain': 0, 'upper_weight_gain': 0},
    {'week': 2, 'lower_weight_gain': 0.04, 'upper_weight_gain': 0.2},
    {'week': 3, 'lower_weight_gain': 0.08, 'upper_weight_gain': 0.3},
    {'week': 4, 'lower_weight_gain': 0.1, 'upper_weight_gain': 0.5},
    {'week': 5, 'lower_weight_gain': 0.2, 'upper_weight_gain': 0.7},
    {'week': 6, 'lower_weight_gain': 0.2, 'upper_weight_gain': 0.8},
    {'week': 7, 'lower_weight_gain': 0.2, 'upper_weight_gain': 1.0},
    {'week': 8, 'lower_weight_gain': 0.3, 'upper_weight_gain': 1.2},
    {'week': 9, 'lower_weight_gain': 0.3, 'upper_weight_gain': 1.3},
    {'week': 10, 'lower_weight_gain': 0.4, 'upper_weight_gain': 1.5},
    {'week': 11, 'lower_weight_gain': 0.4, 'upper_weight_gain': 1.7},
    {'week': 12, 'lower_weight_gain': 0.5, 'upper_weight_gain': 1.8},
    {'week': 13, 'lower_weight_gain': 0.5, 'upper_weight_gain': 2.0},
    {'week': 14, 'lower_weight_gain': 1.1, 'upper_weight_gain': 2.8},
    {'week': 15, 'lower_weight_gain': 1.7, 'upper_weight_gain': 3.7},
    {'week': 16, 'lower_weight_gain': 2.3, 'upper_weight_gain': 4.5},
    {'week': 17, 'lower_weight_gain': 2.9, 'upper_weight_gain': 5.3},
    {'week': 18, 'lower_weight_gain': 3.5, 'upper_weight_gain': 6.2},
    {'week': 19, 'lower_weight_gain': 4.1, 'upper_weight_gain': 7.0},
    {'week': 20, 'lower_weight_gain': 4.7, 'upper_weight_gain': 7.8},
    {'week': 21, 'lower_weight_gain': 5.3, 'upper_weight_gain': 8.7},
    {'week': 22, 'lower_weight_gain': 5.9, 'upper_weight_gain': 9.5},
    {'week': 23, 'lower_weight_gain': 6.5, 'upper_weight_gain': 10.3},
    {'week': 24, 'lower_weight_gain': 7.1, 'upper_weight_gain': 11.2},
    {'week': 25, 'lower_weight_gain': 7.7, 'upper_weight_gain': 12.0},
    {'week': 26, 'lower_weight_gain': 8.3, 'upper_weight_gain': 12.8},
    {'week': 27, 'lower_weight_gain': 8.9, 'upper_weight_gain': 13.7},
    {'week': 28, 'lower_weight_gain': 9.5, 'upper_weight_gain': 14.5},
    {'week': 29, 'lower_weight_gain': 10.1, 'upper_weight_gain': 15.3},
    {'week': 30, 'lower_weight_gain': 10.8, 'upper_weight_gain': 16.2},
    {'week': 31, 'lower_weight_gain': 11.4, 'upper_weight_gain': 17.0},
    {'week': 32, 'lower_weight_gain': 12.0, 'upper_weight_gain': 17.8},
    {'week': 33, 'lower_weight_gain': 12.6, 'upper_weight_gain': 18.7},
    {'week': 34, 'lower_weight_gain': 13.2, 'upper_weight_gain': 19.5},
    {'week': 35, 'lower_weight_gain': 13.8, 'upper_weight_gain': 20.3},
    {'week': 36, 'lower_weight_gain': 14.4, 'upper_weight_gain': 21.2},
    {'week': 37, 'lower_weight_gain': 15.0, 'upper_weight_gain': 22.0},
    {'week': 38, 'lower_weight_gain': 15.6, 'upper_weight_gain': 22.8},
    {'week': 39, 'lower_weight_gain': 16.2, 'upper_weight_gain': 23.7},
    {'week': 40, 'lower_weight_gain': 16.8, 'upper_weight_gain': 24.5},
  ],
  'overweight_twin': [
    {'week': 1, 'lower_weight_gain': 0, 'upper_weight_gain': 0},
    {'week': 2, 'lower_weight_gain': 0.04, 'upper_weight_gain': 0.2},
    {'week': 3, 'lower_weight_gain': 0.08, 'upper_weight_gain': 0.3},
    {'week': 4, 'lower_weight_gain': 0.1, 'upper_weight_gain': 0.5},
    {'week': 5, 'lower_weight_gain': 0.2, 'upper_weight_gain': 0.7},
    {'week': 6, 'lower_weight_gain': 0.2, 'upper_weight_gain': 0.8},
    {'week': 7, 'lower_weight_gain': 0.2, 'upper_weight_gain': 1.0},
    {'week': 8, 'lower_weight_gain': 0.3, 'upper_weight_gain': 1.2},
    {'week': 9, 'lower_weight_gain': 0.3, 'upper_weight_gain': 1.3},
    {'week': 10, 'lower_weight_gain': 0.4, 'upper_weight_gain': 1.5},
    {'week': 11, 'lower_weight_gain': 0.4, 'upper_weight_gain': 1.7},
    {'week': 12, 'lower_weight_gain': 0.5, 'upper_weight_gain': 1.8},
    {'week': 13, 'lower_weight_gain': 0.5, 'upper_weight_gain': 2.0},
    {'week': 14, 'lower_weight_gain': 1.0, 'upper_weight_gain': 2.8},
    {'week': 15, 'lower_weight_gain': 1.5, 'upper_weight_gain': 3.5},
    {'week': 16, 'lower_weight_gain': 2.0, 'upper_weight_gain': 4.3},
    {'week': 17, 'lower_weight_gain': 2.5, 'upper_weight_gain': 5.1},
    {'week': 18, 'lower_weight_gain': 3.0, 'upper_weight_gain': 5.8},
    {'week': 19, 'lower_weight_gain': 3.5, 'upper_weight_gain': 6.6},
    {'week': 20, 'lower_weight_gain': 4.0, 'upper_weight_gain': 7.4},
    {'week': 21, 'lower_weight_gain': 4.5, 'upper_weight_gain': 8.1},
    {'week': 22, 'lower_weight_gain': 5.0, 'upper_weight_gain': 8.9},
    {'week': 23, 'lower_weight_gain': 5.5, 'upper_weight_gain': 9.7},
    {'week': 24, 'lower_weight_gain': 6.0, 'upper_weight_gain': 10.4},
    {'week': 25, 'lower_weight_gain': 6.5, 'upper_weight_gain': 11.2},
    {'week': 26, 'lower_weight_gain': 7.0, 'upper_weight_gain': 12.0},
    {'week': 27, 'lower_weight_gain': 7.5, 'upper_weight_gain': 12.7},
    {'week': 28, 'lower_weight_gain': 8.0, 'upper_weight_gain': 13.5},
    {'week': 29, 'lower_weight_gain': 8.5, 'upper_weight_gain': 14.3},
    {'week': 30, 'lower_weight_gain': 9.0, 'upper_weight_gain': 15.0},
    {'week': 31, 'lower_weight_gain': 9.5, 'upper_weight_gain': 15.8},
    {'week': 32, 'lower_weight_gain': 10.0, 'upper_weight_gain': 16.6},
    {'week': 33, 'lower_weight_gain': 10.5, 'upper_weight_gain': 17.3},
    {'week': 34, 'lower_weight_gain': 11.0, 'upper_weight_gain': 18.1},
    {'week': 35, 'lower_weight_gain': 11.5, 'upper_weight_gain': 18.8},
    {'week': 36, 'lower_weight_gain': 12.1, 'upper_weight_gain': 19.6},
    {'week': 37, 'lower_weight_gain': 12.6, 'upper_weight_gain': 20.4},
    {'week': 38, 'lower_weight_gain': 13.1, 'upper_weight_gain': 21.1},
    {'week': 39, 'lower_weight_gain': 13.6, 'upper_weight_gain': 21.9},
    {'week': 40, 'lower_weight_gain': 14.1, 'upper_weight_gain': 22.7},
  ],
  'obese_twin': [
    {'week': 1, 'lower_weight_gain': 0, 'upper_weight_gain': 0},
    {'week': 2, 'lower_weight_gain': 0.04, 'upper_weight_gain': 0.2},
    {'week': 3, 'lower_weight_gain': 0.08, 'upper_weight_gain': 0.3},
    {'week': 4, 'lower_weight_gain': 0.1, 'upper_weight_gain': 0.5},
    {'week': 5, 'lower_weight_gain': 0.2, 'upper_weight_gain': 0.7},
    {'week': 6, 'lower_weight_gain': 0.2, 'upper_weight_gain': 0.8},
    {'week': 7, 'lower_weight_gain': 0.2, 'upper_weight_gain': 1.0},
    {'week': 8, 'lower_weight_gain': 0.3, 'upper_weight_gain': 1.2},
    {'week': 9, 'lower_weight_gain': 0.3, 'upper_weight_gain': 1.3},
    {'week': 10, 'lower_weight_gain': 0.4, 'upper_weight_gain': 1.5},
    {'week': 11, 'lower_weight_gain': 0.4, 'upper_weight_gain': 1.7},
    {'week': 12, 'lower_weight_gain': 0.5, 'upper_weight_gain': 1.8},
    {'week': 13, 'lower_weight_gain': 0.5, 'upper_weight_gain': 2.0},
    {'week': 14, 'lower_weight_gain': 0.9, 'upper_weight_gain': 2.6},
    {'week': 15, 'lower_weight_gain': 1.3, 'upper_weight_gain': 3.3},
    {'week': 16, 'lower_weight_gain': 1.7, 'upper_weight_gain': 3.9},
    {'week': 17, 'lower_weight_gain': 2.1, 'upper_weight_gain': 4.5},
    {'week': 18, 'lower_weight_gain': 2.5, 'upper_weight_gain': 5.2},
    {'week': 19, 'lower_weight_gain': 2.9, 'upper_weight_gain': 5.8},
    {'week': 20, 'lower_weight_gain': 3.3, 'upper_weight_gain': 6.4},
    {'week': 21, 'lower_weight_gain': 3.7, 'upper_weight_gain': 7.0},
    {'week': 22, 'lower_weight_gain': 4.1, 'upper_weight_gain': 7.7},
    {'week': 23, 'lower_weight_gain': 4.5, 'upper_weight_gain': 8.3},
    {'week': 24, 'lower_weight_gain': 4.9, 'upper_weight_gain': 8.9},
    {'week': 25, 'lower_weight_gain': 5.3, 'upper_weight_gain': 9.6},
    {'week': 26, 'lower_weight_gain': 5.7, 'upper_weight_gain': 10.2},
    {'week': 27, 'lower_weight_gain': 6.1, 'upper_weight_gain': 10.8},
    {'week': 28, 'lower_weight_gain': 6.5, 'upper_weight_gain': 11.5},
    {'week': 29, 'lower_weight_gain': 6.9, 'upper_weight_gain': 12.1},
    {'week': 30, 'lower_weight_gain': 7.3, 'upper_weight_gain': 12.7},
    {'week': 31, 'lower_weight_gain': 7.7, 'upper_weight_gain': 13.4},
    {'week': 32, 'lower_weight_gain': 8.1, 'upper_weight_gain': 14.0},
    {'week': 33, 'lower_weight_gain': 8.5, 'upper_weight_gain': 14.6},
    {'week': 34, 'lower_weight_gain': 8.9, 'upper_weight_gain': 15.3},
    {'week': 35, 'lower_weight_gain': 9.3, 'upper_weight_gain': 15.9},
    {'week': 36, 'lower_weight_gain': 9.7, 'upper_weight_gain': 16.5},
    {'week': 37, 'lower_weight_gain': 10.1, 'upper_weight_gain': 17.2},
    {'week': 38, 'lower_weight_gain': 10.5, 'upper_weight_gain': 17.8},
    {'week': 39, 'lower_weight_gain': 10.9, 'upper_weight_gain': 18.4},
    {'week': 40, 'lower_weight_gain': 11.3, 'upper_weight_gain': 19.1},
  ],
};
