import 'package:logger/logger.dart';
import 'package:periodnpregnancycalender/app/models/date_event_model.dart';
import 'package:periodnpregnancycalender/app/models/master_gender.dart';
import 'package:periodnpregnancycalender/app/models/master_newmoon_model.dart';
import 'package:periodnpregnancycalender/app/models/period_cycle_model.dart';
import 'package:periodnpregnancycalender/app/models/profile_model.dart';
import 'package:periodnpregnancycalender/app/repositories/local/master_gender_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/master_newmoon_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/period_history_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/profile_repository.dart';
import 'package:periodnpregnancycalender/app/services/local_notification_service.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PeriodHistoryService {
  final PeriodHistoryRepository _periodHistoryRepository;
  final LocalProfileRepository _localProfileRepository;
  final MasterNewmoonRepository _masterNewmoonRepository;
  final MasterGenderRepository _masterGenderRepository;

  final Logger _logger = Logger();
  final StorageService storageService = StorageService();

  PeriodHistoryService(this._periodHistoryRepository, this._localProfileRepository, this._masterNewmoonRepository, this._masterGenderRepository);

  Future<void> addPeriod(int? remoteId, DateTime haidAwal, DateTime haidAkhir, int? lamaSiklus) async {
    try {
      int userId = storageService.getAccountLocalId();

      List<PeriodHistory> getAllPeriodHistory = await _periodHistoryRepository.getPeriodHistory(userId);
      List<PeriodHistory> isActualPeriodHistories = getAllPeriodHistory.where((period) => period.isActual == "1").toList();
      List<PeriodHistory> isNotActualPeriodHistories = getAllPeriodHistory.where((period) => period.isActual == "0").toList();

      for (var period in isActualPeriodHistories) {
        if ((haidAwal.isBefore(period.haidAkhir!) || haidAwal.isAtSameMomentAs(period.haidAkhir!)) && (haidAkhir.isAfter(period.haidAwal!) || haidAkhir.isAtSameMomentAs(period.haidAwal!))) {
          throw Exception('Siklus menstruasi yang dimasukkan overlap dengan siklus yang sudah ada');
        }
      }

      int durasiHaid = haidAkhir.difference(haidAwal).inDays + 1;
      int avgPeriodDuration = durasiHaid;
      int avgPeriodCycle = lamaSiklus ?? 0;
      int siklusTengahHaid;

      if (isActualPeriodHistories.isNotEmpty) {
        int totalSiklus = 0;
        int countSiklus = 0;

        int totalDurasiHaid = durasiHaid;
        int countDurasi = 1;

        for (var period in isActualPeriodHistories) {
          if (period.lamaSiklus != 0 && period.lamaSiklus != null) {
            totalSiklus += period.lamaSiklus!;
            countSiklus++;
          }
          if (period.durasiHaid != null) {
            totalDurasiHaid += period.durasiHaid!;
            countDurasi++;
          }
        }

        avgPeriodCycle = totalSiklus ~/ countSiklus;
        avgPeriodDuration = totalDurasiHaid ~/ countDurasi;
      }

      siklusTengahHaid = avgPeriodCycle ~/ 2;
      DateTime ovulasi = haidAwal.add(Duration(days: siklusTengahHaid));
      DateTime masaSuburAwal = ovulasi.subtract(Duration(days: 5));
      DateTime masaSuburAkhir = ovulasi.add(Duration(days: 2));
      DateTime haidBerikutnyaAwal = haidAwal.add(Duration(days: avgPeriodCycle));
      DateTime haidBerikutnyaAkhir = haidBerikutnyaAwal.add(Duration(days: avgPeriodDuration));
      DateTime ovulasiBerikutnya = haidBerikutnyaAwal.add(Duration(days: siklusTengahHaid));
      DateTime masaSuburBerikutnyaAwal = ovulasiBerikutnya.subtract(Duration(days: 5));
      DateTime masaSuburBerikutnyaAkhir = ovulasiBerikutnya.add(Duration(days: 2));
      DateTime hariTerakhirSiklusBerikutnya = haidBerikutnyaAwal.add(Duration(days: avgPeriodCycle));

      PeriodHistory? previousPeriod = isActualPeriodHistories.where((period) => period.haidAwal != null && period.haidAwal!.isBefore(haidAwal)).toList().fold<PeriodHistory?>(null, (previous, current) {
        if (previous == null || current.haidAwal!.isAfter(previous.haidAwal!)) {
          return current;
        }
        return previous;
      });

      PeriodHistory? nextPeriod = isActualPeriodHistories.where((period) => period.haidAwal != null && period.haidAwal!.isAfter(haidAwal)).toList().fold<PeriodHistory?>(null, (next, current) {
        if (next == null || current.haidAwal!.isBefore(next.haidAwal!)) {
          return current;
        }
        return next;
      });

      if (previousPeriod != null && previousPeriod.haidAwal != null) {
        DateTime? previousPeriodHaidAwal = previousPeriod.haidAwal;
        int previousLamaSiklus = (haidAwal.difference(previousPeriodHaidAwal!).inDays - 1).abs();

        PeriodHistory? updatedLastPeriod = previousPeriod.copyWith(
          lamaSiklus: previousLamaSiklus,
          hariTerakhirSiklus: haidAwal.subtract(Duration(days: 1)),
          hariTerakhirSiklusBerikutnya: previousPeriod.haidBerikutnyaAwal?.add(Duration(days: avgPeriodCycle)).subtract(Duration(days: 1)),
        );
        await _periodHistoryRepository.editPeriodHistory(updatedLastPeriod);
      }

      int? nextLamaSiklus;
      DateTime? hariTerakhirSiklus;
      if (nextPeriod != null && nextPeriod.haidAwal != null) {
        DateTime? nextPeriodHaidAwal = nextPeriod.haidAwal;
        nextLamaSiklus = (nextPeriodHaidAwal!.difference(haidAwal).inDays - 1).abs();
        hariTerakhirSiklus = nextPeriodHaidAwal.subtract(Duration(days: 1));
      }

      PeriodHistory newPeriodHistory = PeriodHistory(
        userId: userId,
        remoteId: remoteId,
        haidAwal: haidAwal,
        haidAkhir: haidAkhir,
        ovulasi: ovulasi,
        masaSuburAwal: masaSuburAwal,
        masaSuburAkhir: masaSuburAkhir,
        lamaSiklus: (isActualPeriodHistories.length < 1) ? avgPeriodCycle : nextLamaSiklus ?? 0,
        durasiHaid: durasiHaid,
        hariTerakhirSiklus: hariTerakhirSiklus ?? null,
        haidBerikutnyaAwal: haidBerikutnyaAwal,
        haidBerikutnyaAkhir: haidBerikutnyaAkhir,
        ovulasiBerikutnya: ovulasiBerikutnya,
        masaSuburBerikutnyaAwal: masaSuburBerikutnyaAwal,
        masaSuburBerikutnyaAkhir: masaSuburBerikutnyaAkhir,
        hariTerakhirSiklusBerikutnya: hariTerakhirSiklusBerikutnya,
        isActual: "1",
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      await _periodHistoryRepository.addPeriodHistory(newPeriodHistory);

      for (var isNotActualPeriod in isNotActualPeriodHistories) {
        await _periodHistoryRepository.deletePeriodHistory(isNotActualPeriod.id!, userId);
      }

      List<PeriodHistory> getUpdatedPeriodHistory = await _periodHistoryRepository.getPeriodHistory(userId);

      PeriodHistory lastUpdatedPeriodHistory = getUpdatedPeriodHistory.last;

      LocalNotificationService().scheduleNotificationPeriod(lastUpdatedPeriodHistory);

      if (lastUpdatedPeriodHistory.haidAwal != null) {
        generatePeriodPredictions(
          lastUpdatedPeriodHistory.haidAwal ?? DateTime.now(),
          avgPeriodDuration,
          avgPeriodCycle,
          userId,
        );
      }
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
    }
  }

  Future<void> updatePeriod(int id, DateTime haidAwal, DateTime haidAkhir, int lamaSiklus) async {
    try {
      int userId = storageService.getAccountLocalId();

      List<PeriodHistory> getAllPeriodHistory = await _periodHistoryRepository.getPeriodHistory(userId);

      List<PeriodHistory> isActualPeriodHistories = getAllPeriodHistory.where((period) => period.isActual == "1").toList();

      List<PeriodHistory> isNotActualPeriodHistories = getAllPeriodHistory.where((period) => period.isActual == "0").toList();

      PeriodHistory updatePeriod = isActualPeriodHistories.firstWhere((period) => period.id == id);

      for (var period in isActualPeriodHistories) {
        if (period.id != id) {
          if (!(haidAkhir.isBefore(period.haidAwal!) || haidAwal.isAfter(period.haidAkhir!))) {
            throw Exception('Siklus menstruasi yang dimasukkan overlap dengan siklus yang sudah ada');
          }
        }
      }

      int durasiHaid = haidAkhir.difference(haidAwal).inDays + 1;
      int avgPeriodDuration = durasiHaid;
      int avgPeriodCycle = lamaSiklus;
      int siklusTengahHaid;

      if (isActualPeriodHistories.isNotEmpty) {
        int totalSiklus = 0;
        int countSiklus = 0;

        int totalDurasiHaid = durasiHaid;
        int countDurasi = 1;

        for (var period in isActualPeriodHistories) {
          if (period.lamaSiklus != null) {
            totalSiklus += period.lamaSiklus!;
            countSiklus++;
          }
          if (period.durasiHaid != null) {
            totalDurasiHaid += period.durasiHaid!;
            countDurasi++;
          }
        }

        avgPeriodCycle = countSiklus > 0 ? (totalSiklus ~/ countSiklus) : lamaSiklus;
        avgPeriodDuration = totalDurasiHaid ~/ countDurasi;
      }

      siklusTengahHaid = avgPeriodCycle ~/ 2;
      DateTime ovulasi = haidAwal.add(Duration(days: siklusTengahHaid));
      DateTime masaSuburAwal = ovulasi.subtract(Duration(days: 5));
      DateTime masaSuburAkhir = ovulasi.add(Duration(days: 2));
      DateTime haidBerikutnyaAwal = haidAwal.add(Duration(days: avgPeriodCycle));
      DateTime haidBerikutnyaAkhir = haidBerikutnyaAwal.add(Duration(days: avgPeriodDuration));
      DateTime ovulasiBerikutnya = haidBerikutnyaAwal.add(Duration(days: siklusTengahHaid));
      DateTime masaSuburBerikutnyaAwal = ovulasiBerikutnya.subtract(Duration(days: 5));
      DateTime masaSuburBerikutnyaAkhir = ovulasiBerikutnya.add(Duration(days: 2));
      DateTime hariTerakhirSiklusBerikutnya = haidBerikutnyaAwal.add(Duration(days: avgPeriodCycle));

      PeriodHistory updatedPeriodHistory = updatePeriod.copyWith(
        userId: userId,
        haidAwal: haidAwal,
        haidAkhir: haidAkhir,
        ovulasi: ovulasi,
        masaSuburAwal: masaSuburAwal,
        masaSuburAkhir: masaSuburAkhir,
        durasiHaid: durasiHaid,
        haidBerikutnyaAwal: haidBerikutnyaAwal,
        haidBerikutnyaAkhir: haidBerikutnyaAkhir,
        ovulasiBerikutnya: ovulasiBerikutnya,
        masaSuburBerikutnyaAwal: masaSuburBerikutnyaAwal,
        masaSuburBerikutnyaAkhir: masaSuburBerikutnyaAkhir,
        hariTerakhirSiklusBerikutnya: hariTerakhirSiklusBerikutnya,
        isActual: "1",
        updatedAt: DateTime.now().toIso8601String(),
      );

      await _periodHistoryRepository.editPeriodHistory(updatedPeriodHistory);

      List<PeriodHistory> getNewAllPeriodHistory = await _periodHistoryRepository.getPeriodHistory(userId);

      List<PeriodHistory> isActualNewPeriodHistories = getNewAllPeriodHistory.where((period) => period.isActual == "1").toList();

      int index = isActualPeriodHistories.indexWhere((r) => r.id == id);
      PeriodHistory? previousPeriod;
      PeriodHistory? nextPeriod;

      if (index > 0) {
        previousPeriod = isActualPeriodHistories[index - 1];
      }
      if (index < isActualPeriodHistories.length - 1) {
        nextPeriod = isActualPeriodHistories[index + 1];
      }

      int newIndex = isActualNewPeriodHistories.indexWhere((r) => r.id == id);
      PeriodHistory? updatedPeriod = isActualNewPeriodHistories[newIndex];
      PeriodHistory? newPreviousPeriod;
      PeriodHistory? newNextPeriod;

      if (newIndex > 0) {
        newPreviousPeriod = isActualNewPeriodHistories[newIndex - 1];
      }
      if (newIndex < isActualNewPeriodHistories.length - 1) {
        newNextPeriod = isActualNewPeriodHistories[newIndex + 1];
      }

      if (previousPeriod != null && previousPeriod.haidAwal != null && previousPeriod.id != newPreviousPeriod?.id) {
        if (nextPeriod != null && nextPeriod.haidAwal != null) {
          int lamaSiklus = (previousPeriod.haidAwal!.difference(nextPeriod.haidAwal ?? DateTime.now()).inDays - 1).abs();

          PeriodHistory updatedPreviousPeriod = previousPeriod.copyWith(
            lamaSiklus: lamaSiklus,
            hariTerakhirSiklus: nextPeriod.haidAwal?.subtract(Duration(days: 1)),
            hariTerakhirSiklusBerikutnya: nextPeriod.haidAwal?.add(Duration(days: avgPeriodCycle)).subtract(Duration(days: 1)),
          );

          await _periodHistoryRepository.editPeriodHistory(updatedPreviousPeriod);
        } else {
          PeriodHistory updatedPreviousPeriod = previousPeriod.copyWith(
            lamaSiklus: 0,
            hariTerakhirSiklus: null,
          );

          await _periodHistoryRepository.editPeriodHistory(updatedPreviousPeriod);
        }
      }

      if (newPreviousPeriod != null && newPreviousPeriod.id != null) {
        int newPreviousPeriodLamaSiklus = (newPreviousPeriod.haidAwal!.difference(updatedPeriod.haidAwal ?? DateTime.now()).inDays - 1).abs();

        PeriodHistory updatedNewPreviousPeriod = newPreviousPeriod.copyWith(
          lamaSiklus: newPreviousPeriodLamaSiklus,
          hariTerakhirSiklus: newPreviousPeriod.haidAwal?.subtract(Duration(days: 1)),
          hariTerakhirSiklusBerikutnya: newPreviousPeriod.haidAwal?.add(Duration(days: avgPeriodCycle)),
        );

        await _periodHistoryRepository.editPeriodHistory(updatedNewPreviousPeriod);
      }

      if (newNextPeriod != null && newNextPeriod.id != null) {
        int newNextPeriodLamaSiklus = (newNextPeriod.haidAwal!.difference(updatedPeriod.haidAwal ?? DateTime.now()).inDays - 1).abs();

        PeriodHistory updatedNewPreviousPeriod = updatedPeriod.copyWith(
          lamaSiklus: newNextPeriodLamaSiklus,
          hariTerakhirSiklus: newPreviousPeriod?.haidAwal?.subtract(Duration(days: 1)),
        );

        await _periodHistoryRepository.editPeriodHistory(updatedNewPreviousPeriod);
      }

      for (var isNotActualPeriod in isNotActualPeriodHistories) {
        await _periodHistoryRepository.deletePeriodHistory(isNotActualPeriod.id!, userId);
      }

      PeriodHistory lastUpdatedPeriodHistory = isActualNewPeriodHistories.last;

      LocalNotificationService().scheduleNotificationPeriod(lastUpdatedPeriodHistory);

      if (lastUpdatedPeriodHistory.haidAwal != null) {
        generatePeriodPredictions(
          lastUpdatedPeriodHistory.haidAwal ?? DateTime.now(),
          avgPeriodDuration,
          avgPeriodCycle,
          userId,
        );
      }
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
    }
  }

  Future<void> generatePeriodPredictions(DateTime haidAwalSiklusAkhir, int avgPeriodDuration, int avgPeriodCycle, int userId) async {
    DateTime haidAwalSiklusAkhirUse = haidAwalSiklusAkhir;
    int periodDuration = avgPeriodDuration;
    int periodCycle = avgPeriodCycle;

    for (int i = 0; i < 3; i++) {
      DateTime haidAwal = haidAwalSiklusAkhirUse.add(Duration(days: periodCycle));
      int siklusTengahHaid = periodCycle ~/ 2;
      DateTime ovulasi = haidAwal.add(Duration(days: siklusTengahHaid));
      DateTime masaSuburAwal = ovulasi.subtract(Duration(days: 5));
      DateTime masaSuburAkhir = ovulasi.add(Duration(days: 2));
      DateTime haidBerikutnyaAwal = haidAwal.add(Duration(days: periodCycle));
      DateTime haidBerikutnyaAkhir = haidBerikutnyaAwal.add(Duration(days: avgPeriodDuration));
      DateTime ovulasiBerikutnya = haidBerikutnyaAwal.add(Duration(days: siklusTengahHaid));
      DateTime masaSuburBerikutnyaAwal = ovulasiBerikutnya.subtract(Duration(days: 5));
      DateTime masaSuburBerikutnyaAkhir = ovulasiBerikutnya.add(Duration(days: 2));

      PeriodHistory addNewPeriod = PeriodHistory(
        userId: userId,
        haidAwal: haidAwal,
        haidAkhir: haidAwal.add(Duration(days: periodDuration)),
        ovulasi: ovulasi,
        masaSuburAwal: masaSuburAwal,
        masaSuburAkhir: masaSuburAkhir,
        hariTerakhirSiklus: haidBerikutnyaAwal.subtract(Duration(days: 1)),
        lamaSiklus: periodCycle,
        durasiHaid: periodDuration,
        haidBerikutnyaAwal: haidBerikutnyaAwal,
        haidBerikutnyaAkhir: haidBerikutnyaAkhir,
        ovulasiBerikutnya: ovulasiBerikutnya,
        masaSuburBerikutnyaAwal: masaSuburBerikutnyaAwal,
        masaSuburBerikutnyaAkhir: masaSuburBerikutnyaAkhir,
        hariTerakhirSiklusBerikutnya: haidBerikutnyaAwal.add(Duration(days: periodCycle)),
        isActual: "0",
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );
      _periodHistoryRepository.addPeriodHistory(addNewPeriod);

      haidAwalSiklusAkhirUse = haidAwal;
    }
  }

  Future<PeriodCycleIndex> getPeriodIndex() async {
    try {
      int userId = storageService.getAccountLocalId();
      List<PeriodHistory> getAllPeriodHistory = await _periodHistoryRepository.getPeriodHistory(userId);

      User? getProfile = await _localProfileRepository.getProfile();

      if (getProfile?.tanggalLahir == null) {
        throw Exception('Invalid birth date for user');
      }

      int age = calculateAge(DateTime.parse(getProfile?.tanggalLahir ?? ""));

      List<PeriodHistory> isActualPeriodHistories = getAllPeriodHistory.where((period) => period.isActual == "1").toList();
      List<PeriodHistory> isPredictionPeriodHistories = getAllPeriodHistory.where((period) => period.isActual == "0").toList();

      if (getAllPeriodHistory.isEmpty) {
        throw Exception('Period history is empty');
      }

      PeriodHistory firstPeriod = getAllPeriodHistory.first;
      PeriodHistory lastPeriod = getAllPeriodHistory.last;

      // Menghitung shortestPeriod
      int shortestPeriod = isActualPeriodHistories.fold<int>(isActualPeriodHistories.first.durasiHaid!, (previousValue, element) => element.durasiHaid! < previousValue ? element.durasiHaid! : previousValue);
      // Menghitung longestPeriod
      int longestPeriod = isActualPeriodHistories.fold<int>(isActualPeriodHistories.first.durasiHaid!, (previousValue, element) => element.durasiHaid! > previousValue ? element.durasiHaid! : previousValue);
      // Menghitung shortestCycle
      int shortestCycle = isActualPeriodHistories.fold<int>(isActualPeriodHistories.first.lamaSiklus!, (previousValue, element) => element.lamaSiklus! < previousValue ? element.lamaSiklus! : previousValue);
      // Menghitung longestCycle
      int longestCycle = isActualPeriodHistories.fold<int>(isActualPeriodHistories.first.lamaSiklus!, (previousValue, element) => element.lamaSiklus! > previousValue ? element.lamaSiklus! : previousValue);
      // Menghitung rata-rata durasi periode dan siklus
      int avgPeriodDuration = (isActualPeriodHistories.map((p) => p.durasiHaid!).reduce((a, b) => a + b) / isActualPeriodHistories.length).ceil();
      int avgPeriodCycle = (isActualPeriodHistories.where((p) => p.lamaSiklus != null && p.lamaSiklus! > 0).map((p) => p.lamaSiklus!).reduce((a, b) => a + b) / isActualPeriodHistories.where((p) => p.lamaSiklus != null && p.lamaSiklus! > 0).length).ceil();

      List<PeriodChart> periodChartList = [];
      List<ShettlesGenderPrediction> shettlesGenderPredictionList = [];
      for (var period in isActualPeriodHistories) {
        int countPeriodCycle;
        if (period.lamaSiklus != null && period.lamaSiklus != 0) {
          countPeriodCycle = period.lamaSiklus!;
        } else {
          int daysDifference = period.haidAwal != null ? DateTime.now().difference(period.haidAwal!).inDays : avgPeriodCycle;
          countPeriodCycle = daysDifference > avgPeriodCycle ? daysDifference : avgPeriodCycle;
        }

        PeriodChart periodChart = PeriodChart(
          id: period.id,
          startDate: period.haidAwal,
          endDate: period.haidAkhir,
          periodCycle: countPeriodCycle,
          periodDuration: period.durasiHaid ?? avgPeriodDuration,
        );

        periodChartList.add(periodChart);
      }

      for (var periods in getAllPeriodHistory) {
        DateTime? boyStartDate = periods.ovulasi;
        DateTime? boyEndDate = periods.ovulasi?.add(Duration(days: 3));
        DateTime? girlStartDate = periods.haidAkhir?.add(Duration(days: 1));
        DateTime? girlEndDate = periods.ovulasi?.subtract(Duration(days: 2));

        DateTime hariTerakhirSiklus;
        if (periods.hariTerakhirSiklus != null && periods.hariTerakhirSiklus!.isAfter(boyStartDate!)) {
          hariTerakhirSiklus = periods.hariTerakhirSiklus!;
        } else {
          hariTerakhirSiklus = periods.haidAwal!.add(Duration(days: avgPeriodCycle));
        }

        ShettlesGenderPrediction shettlesGenderPrediction = ShettlesGenderPrediction(
          boyStartDate: boyStartDate,
          boyEndDate: (boyEndDate!.isAfter(hariTerakhirSiklus)) ? hariTerakhirSiklus : boyEndDate,
          girlStartDate: girlStartDate,
          girlEndDate: girlEndDate,
        );

        shettlesGenderPredictionList.add(shettlesGenderPrediction);
      }

      isActualPeriodHistories.sort((a, b) => b.haidAwal!.compareTo(a.haidAwal!));

      return PeriodCycleIndex(
        initialYear: firstPeriod.haidAwal?.year.toString(),
        latestYear: lastPeriod.haidAwal?.year.toString(),
        currentYear: DateTime.now().toIso8601String(),
        age: age,
        lunarAge: calculateLunarAge(age, DateTime.now()),
        shortestPeriod: shortestPeriod,
        longestPeriod: longestPeriod,
        shortestCycle: shortestCycle,
        longestCycle: longestCycle,
        avgPeriodDuration: avgPeriodDuration,
        avgPeriodCycle: avgPeriodCycle,
        periodChart: periodChartList,
        latestPeriodHistory: lastPeriod,
        periodHistory: getAllPeriodHistory,
        actualPeriod: isActualPeriodHistories,
        predictionPeriod: isPredictionPeriodHistories,
        shettlesGenderPrediction: shettlesGenderPredictionList,
      );
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
      rethrow;
    }
  }

  Future<Event> getDateEvent(DateTime specifiedDate) async {
    try {
      int userId = storageService.getAccountLocalId();
      List<PeriodHistory> getAllPeriodHistory = await _periodHistoryRepository.getPeriodHistory(userId);

      User? getProfile = await _localProfileRepository.getProfile();

      int countPeriodHistoryData = getAllPeriodHistory.length;

      if (specifiedDate.isAfter(DateTime(2030, 12, 31)) || specifiedDate.isBefore(DateTime(1979, 01, 01))) {
        throw Exception('Invalid specified date');
      }

      int eventId = 0;
      int dayOfCycle = 0;
      String event = '';
      String currentDataIsActual = '';
      String pregnancyChances = '';
      DateTime nextMenstruationStart = DateTime.now();
      DateTime nextMenstruationEnd = DateTime.now();
      DateTime nextOvulation = DateTime.now();
      DateTime nextFollicularStart = DateTime.now();
      DateTime nextFollicularEnd = DateTime.now();
      DateTime nextFertileStart = DateTime.now();
      DateTime nextFertileEnd = DateTime.now();
      DateTime nextLutealStart = DateTime.now();
      DateTime nextLutealEnd = DateTime.now();
      DateTime lutealEnd = DateTime.now();
      DateTime firstDayOfMenstruation = DateTime.now();

      int daysUntilNextMenstruation = 0;
      int daysUntilNextOvulation = 0;
      int daysUntilNextFollicular = 0;
      int daysUntilNextFertile = 0;
      int daysUntilNextLuteal = 0;

      ShettlesGenderPrediction? shettlesGenderPrediction;

      for (int key = 0; key < countPeriodHistoryData; key++) {
        var periodHistory = getAllPeriodHistory[key];
        currentDataIsActual = periodHistory.isActual ?? "1";
        int currentIndex = getAllPeriodHistory.indexOf(periodHistory);

        if (key < (countPeriodHistoryData - 1)) {
          var nextPeriodData = getAllPeriodHistory[key + 1];
          lutealEnd = nextPeriodData.haidAwal!.subtract(Duration(days: 1));
        } else {
          lutealEnd = periodHistory.hariTerakhirSiklus ?? DateTime.now();
        }

        DateTime periodStart = periodHistory.haidAwal ?? DateTime.now();
        DateTime periodEnd = periodHistory.haidAkhir ?? DateTime.now();
        DateTime ovulation = periodHistory.ovulasi ?? DateTime.now();
        DateTime fertileStart = periodHistory.masaSuburAwal ?? DateTime.now();
        DateTime fertileEnd = periodHistory.masaSuburAkhir ?? DateTime.now();
        DateTime follicularStart = periodEnd.add(Duration(days: 1));
        DateTime follicularEnd = fertileStart.subtract(Duration(days: 1));
        DateTime lutealStart = fertileEnd.add(Duration(days: 1));

        if (currentDataIsActual == "1") {
          firstDayOfMenstruation = periodStart;
        } else {
          List<PeriodHistory> sortedPeriodHistory = [...getAllPeriodHistory];
          sortedPeriodHistory.sort((a, b) => b.haidAwal!.compareTo(a.haidAwal!));

          PeriodHistory? lastIsActualPeriodData = sortedPeriodHistory.firstWhere((period) => period.isActual == "1");
          firstDayOfMenstruation = lastIsActualPeriodData.haidAwal ?? DateTime.now();
        }

        dayOfCycle = (specifiedDate.difference(firstDayOfMenstruation).inDays + 1);

        if (specifiedDate.isAfter(periodStart.subtract(Duration(days: 1))) && specifiedDate.isBefore(lutealEnd.add(Duration(days: 1)))) {
          shettlesGenderPrediction = ShettlesGenderPrediction(
            boyStartDate: ovulation,
            boyEndDate: ovulation.add(Duration(days: 3)),
            girlStartDate: periodEnd.add(Duration(days: 1)),
            girlEndDate: ovulation.subtract(Duration(days: 2)),
          );
        }

        if (specifiedDate.isAfter(periodStart.subtract(Duration(days: 1))) && specifiedDate.isBefore(periodEnd.add(Duration(days: 1)))) {
          event = storageService.getLanguage() == "en" ? "Menstruation Phase" : "Masa Menstruasi";
          pregnancyChances = storageService.getLanguage() == "en" ? "Low" : "Rendah";
          currentDataIsActual = periodHistory.isActual ?? '';
          eventId = periodHistory.id ?? 0;

          if (key == countPeriodHistoryData - 1) {
            nextMenstruationStart = periodHistory.haidBerikutnyaAwal ?? DateTime.now();
            nextMenstruationEnd = periodHistory.haidBerikutnyaAkhir ?? DateTime.now();
            nextLutealEnd = periodHistory.haidBerikutnyaAwal?.subtract(Duration(days: 1)) ?? DateTime.now();
          } else {
            var nextRecord = getAllPeriodHistory[currentIndex + 1];
            nextMenstruationStart = nextRecord.haidAwal ?? DateTime.now();
            nextMenstruationEnd = nextRecord.haidAkhir ?? DateTime.now();
            nextLutealEnd = nextRecord.haidAwal?.subtract(Duration(days: 1)) ?? DateTime.now();
          }
          daysUntilNextMenstruation = nextMenstruationStart.difference(specifiedDate).inDays;

          nextOvulation = periodHistory.ovulasi ?? DateTime.now();
          daysUntilNextOvulation = nextOvulation.difference(specifiedDate).inDays;

          nextFollicularStart = periodEnd.add(Duration(days: 1));
          nextFollicularEnd = fertileStart.subtract(Duration(days: 1));
          daysUntilNextFollicular = nextFollicularStart.difference(specifiedDate).inDays;

          nextFertileStart = fertileStart;
          nextFertileEnd = fertileEnd;
          daysUntilNextFertile = nextFertileStart.difference(specifiedDate).inDays;

          nextLutealStart = fertileEnd.add(Duration(days: 1));
          daysUntilNextLuteal = nextLutealStart.difference(specifiedDate).inDays;
          break;
        }

        if (specifiedDate.isAfter(fertileStart.subtract(Duration(days: 1))) && specifiedDate.isBefore(fertileEnd.add(Duration(days: 1)))) {
          event = specifiedDate.isAtSameMomentAs(ovulation)
              ? storageService.getLanguage() == "en"
                  ? "Ovulation"
                  : "Ovulasi"
              : storageService.getLanguage() == "en"
                  ? "Fertile Phase"
                  : "Masa Subur";
          pregnancyChances = storageService.getLanguage() == "en" ? "High" : "Tinggi";
          currentDataIsActual = periodHistory.isActual ?? '';
          eventId = periodHistory.id ?? 0;

          if (key == countPeriodHistoryData - 1) {
            nextMenstruationStart = periodHistory.haidBerikutnyaAwal ?? DateTime.now();
            nextMenstruationEnd = periodHistory.haidBerikutnyaAkhir ?? DateTime.now();
            nextFollicularStart = (periodHistory.haidBerikutnyaAkhir ?? DateTime.now()).add(Duration(days: 1));
            nextFollicularEnd = (periodHistory.masaSuburBerikutnyaAwal ?? DateTime.now()).subtract(Duration(days: 1));
            nextFertileStart = periodHistory.masaSuburBerikutnyaAwal ?? DateTime.now();
            nextFertileEnd = periodHistory.masaSuburBerikutnyaAkhir ?? DateTime.now();
            nextLutealEnd = (periodHistory.haidBerikutnyaAwal ?? DateTime.now()).subtract(Duration(days: 1));

            nextOvulation = specifiedDate.isBefore(ovulation) ? periodHistory.ovulasi ?? DateTime.now() : periodHistory.ovulasiBerikutnya ?? DateTime.now();
          } else {
            var nextRecord = getAllPeriodHistory[currentIndex + 1];
            nextMenstruationStart = nextRecord.haidAwal ?? DateTime.now();
            nextMenstruationEnd = nextRecord.haidAkhir ?? DateTime.now();
            nextFollicularStart = (nextRecord.haidAkhir ?? DateTime.now()).add(Duration(days: 1));
            nextFollicularEnd = (nextRecord.masaSuburAwal ?? DateTime.now()).subtract(Duration(days: 1));
            nextFertileStart = nextRecord.masaSuburAwal ?? DateTime.now();
            nextFertileEnd = nextRecord.masaSuburAkhir ?? DateTime.now();
            nextLutealEnd = periodHistory.hariTerakhirSiklus ?? DateTime.now();

            nextOvulation = specifiedDate.isBefore(ovulation) ? periodHistory.ovulasi ?? DateTime.now() : nextRecord.ovulasi ?? DateTime.now();
          }

          daysUntilNextMenstruation = nextMenstruationStart.difference(specifiedDate).inDays;
          daysUntilNextOvulation = nextOvulation.difference(specifiedDate).inDays;
          daysUntilNextFollicular = nextFollicularStart.difference(specifiedDate).inDays;
          daysUntilNextFertile = nextFertileStart.difference(specifiedDate).inDays;

          nextLutealStart = fertileEnd.add(Duration(days: 1));
          daysUntilNextLuteal = nextLutealStart.difference(specifiedDate).inDays;
          break;
        }

        if ((specifiedDate.isAfter(follicularStart) && specifiedDate.isBefore(follicularEnd)) || specifiedDate.isAtSameMomentAs(follicularStart) || specifiedDate.isAtSameMomentAs(follicularEnd)) {
          event = storageService.getLanguage() == "en" ? "Follicular Phase" : "Fase Folikuler";
          pregnancyChances = storageService.getLanguage() == "en" ? "Low" : "Rendah";
          currentDataIsActual = periodHistory.isActual ?? '';
          eventId = periodHistory.id ?? 0;

          if (key == countPeriodHistoryData - 1) {
            nextMenstruationStart = periodHistory.haidBerikutnyaAwal ?? DateTime.now();
            nextMenstruationEnd = periodHistory.haidBerikutnyaAkhir ?? DateTime.now();
            nextFollicularStart = (periodHistory.haidBerikutnyaAkhir ?? DateTime.now()).add(Duration(days: 1));
            nextFollicularEnd = (periodHistory.masaSuburBerikutnyaAwal ?? DateTime.now()).subtract(Duration(days: 1));
          } else {
            var nextRecord = getAllPeriodHistory[currentIndex + 1];
            nextMenstruationStart = nextRecord.haidAwal ?? DateTime.now();
            nextMenstruationEnd = nextRecord.haidAkhir ?? DateTime.now();
            nextFollicularStart = (nextRecord.haidAkhir ?? DateTime.now()).add(Duration(days: 1));
            nextFollicularEnd = (nextRecord.masaSuburAwal ?? DateTime.now()).subtract(Duration(days: 1));
            nextLutealEnd = nextRecord.haidAwal ?? DateTime.now();
          }
          daysUntilNextMenstruation = nextMenstruationStart.difference(specifiedDate).inDays;
          daysUntilNextFollicular = nextFollicularStart.difference(specifiedDate).inDays;

          nextOvulation = periodHistory.ovulasi ?? DateTime.now();
          daysUntilNextOvulation = nextOvulation.difference(specifiedDate).inDays;

          nextFertileStart = periodHistory.masaSuburAwal ?? DateTime.now();
          nextFertileEnd = periodHistory.masaSuburAkhir ?? DateTime.now();
          daysUntilNextFertile = nextFertileStart.difference(specifiedDate).inDays;

          nextLutealStart = periodHistory.masaSuburAkhir ?? DateTime.now();

          daysUntilNextLuteal = nextLutealStart.difference(specifiedDate).inDays;
          break;
        }

        if (specifiedDate.isAfter(lutealStart.subtract(Duration(days: 1))) && specifiedDate.isBefore(lutealEnd.add(Duration(days: 1)))) {
          event = storageService.getLanguage() == "en" ? "Luteal Phase" : "Fase Luteal";
          pregnancyChances = storageService.getLanguage() == "en" ? "Low" : "Rendah";
          currentDataIsActual = periodHistory.isActual ?? '';
          eventId = periodHistory.id ?? 0;

          if (key == countPeriodHistoryData - 1) {
            nextMenstruationStart = periodHistory.haidBerikutnyaAwal ?? DateTime.now();
            nextMenstruationEnd = periodHistory.haidBerikutnyaAkhir ?? DateTime.now();
            nextFollicularStart = (periodHistory.haidBerikutnyaAkhir ?? DateTime.now()).add(Duration(days: 1));
            nextFollicularEnd = (periodHistory.masaSuburBerikutnyaAwal ?? DateTime.now()).subtract(Duration(days: 1));
            nextFertileStart = periodHistory.masaSuburBerikutnyaAwal ?? DateTime.now();
            nextFertileEnd = periodHistory.masaSuburBerikutnyaAkhir ?? DateTime.now();
            nextOvulation = periodHistory.ovulasiBerikutnya ?? DateTime.now();
            nextLutealStart = (periodHistory.masaSuburBerikutnyaAkhir ?? DateTime.now()).add(Duration(days: 1));
            nextLutealEnd = periodHistory.hariTerakhirSiklusBerikutnya ?? DateTime.now();
          } else {
            var nextRecord = getAllPeriodHistory[currentIndex + 1];
            nextMenstruationStart = nextRecord.haidAwal ?? DateTime.now();
            nextMenstruationEnd = nextRecord.haidAkhir ?? DateTime.now();
            nextFollicularStart = (nextRecord.haidAkhir ?? DateTime.now()).add(Duration(days: 1));
            nextFollicularEnd = (nextRecord.masaSuburAwal ?? DateTime.now()).subtract(Duration(days: 1));
            nextFertileStart = nextRecord.masaSuburAwal ?? DateTime.now();
            nextFertileEnd = nextRecord.masaSuburAkhir ?? DateTime.now();
            nextOvulation = nextRecord.ovulasi ?? DateTime.now();
            nextLutealStart = (nextRecord.masaSuburAkhir ?? DateTime.now()).add(Duration(days: 1));
            nextLutealEnd = (nextRecord.haidBerikutnyaAwal ?? DateTime.now()).subtract(Duration(days: 1));
          }
          daysUntilNextMenstruation = nextMenstruationStart.difference(specifiedDate).inDays;
          daysUntilNextOvulation = nextOvulation.difference(specifiedDate).inDays;
          daysUntilNextFollicular = nextFollicularStart.difference(specifiedDate).inDays;
          daysUntilNextFertile = nextFertileStart.difference(specifiedDate).inDays;
          daysUntilNextLuteal = nextLutealStart.difference(specifiedDate).inDays;
          break;
        }
      }

      if (getProfile?.tanggalLahir == null) {
        throw Exception('Invalid birth date for user');
      }

      DateTime dateOfBirth = DateTime.parse(getProfile?.tanggalLahir ?? "");
      int age = calculateAge(dateOfBirth);
      int lunarAge = calculateLunarAge(age, specifiedDate);
      DateTime lunarSpecifiedDate = await calculateLunarDate(specifiedDate);

      ChineseGenderPrediction? chineseGenderPrediction;
      if (lunarAge >= 18) {
        chineseGenderPrediction = ChineseGenderPrediction(
          age: age,
          lunarAge: lunarAge,
          dateOfBirth: dateOfBirth.toString(),
          specifiedDate: specifiedDate.toString(),
          lunarSpecifiedDate: lunarSpecifiedDate.toString(),
          genderPrediction: await chineseGenderPredictions(lunarSpecifiedDate, lunarAge),
        );
      }

      return Event(
        specifiedDate: specifiedDate.toIso8601String(),
        event: event,
        isActual: currentDataIsActual,
        eventId: eventId,
        cycleDay: dayOfCycle,
        pregnancyChances: pregnancyChances,
        nextMenstruationStart: nextMenstruationStart.toIso8601String(),
        nextMenstruationEnd: nextMenstruationEnd.toIso8601String(),
        daysUntilNextMenstruation: daysUntilNextMenstruation,
        nextOvulation: nextOvulation.toIso8601String(),
        daysUntilNextOvulation: daysUntilNextOvulation,
        nextFollicularStart: nextFollicularStart.toIso8601String(),
        nextFollicularEnd: nextFollicularEnd.toIso8601String(),
        daysUntilNextFollicular: daysUntilNextFollicular,
        nextFertileStart: nextFertileStart.toIso8601String(),
        nextFertileEnd: nextFertileEnd.toIso8601String(),
        daysUntilNextFertile: daysUntilNextFertile,
        nextLutealStart: nextLutealStart.toIso8601String(),
        nextLutealEnd: nextLutealEnd.toIso8601String(),
        daysUntilNextLuteal: daysUntilNextLuteal,
        chineseGenderPrediction: chineseGenderPrediction,
        shettlesGenderPrediction: shettlesGenderPrediction,
      );
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
      rethrow;
    }
  }

  int calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;

    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  Future<DateTime> calculateLunarDate(DateTime date) async {
    List<MasterNewmoon> masterNewMoonData = await _masterNewmoonRepository.getAllNewmoon();

    DateTime? previousNewMoon;
    int? lunarMonth;

    for (int i = masterNewMoonData.length - 1; i >= 0; i--) {
      MasterNewmoon newMoonData = masterNewMoonData[i];
      DateTime newMoonDate = DateTime.parse(newMoonData.newMoon ?? "");
      if (newMoonDate.isBefore(date) || newMoonDate.isAtSameMomentAs(date)) {
        previousNewMoon = newMoonDate;
        lunarMonth = masterNewMoonData[i].lunarMonth;
        break;
      }
    }

    if (previousNewMoon == null || lunarMonth == null) {
      throw Exception('No previous new moon data found for the date provided.');
    }

    int lunarYear = previousNewMoon.year;
    int lunarDays = previousNewMoon.difference(date).inDays + 1;

    DateTime lunarDate = DateTime(lunarYear, lunarMonth, 0).add(Duration(days: lunarDays));

    return lunarDate;
  }

  Future<String?> chineseGenderPredictions(DateTime date, int lunarAge) async {
    List<MasterGender> masterGender = await _masterGenderRepository.getAllGenderData();
    return masterGender.firstWhere((gender) => gender.bulan == date.month && gender.usia == lunarAge).gender;
  }

  int calculateLunarAge(int age, DateTime? calculateOn) {
    // List tanggal Chinese New Year
    List<String> chineseNewYear = [
      '1930-01-29',
      '1931-02-17',
      '1932-02-06',
      '1933-01-26',
      '1934-02-14',
      '1935-02-04',
      '1936-01-24',
      '1937-02-11',
      '1938-01-31',
      '1939-02-19',
      '1940-02-08',
      '1941-01-27',
      '1942-02-15',
      '1943-02-04',
      '1944-01-25',
      '1945-02-13',
      '1946-02-01',
      '1947-01-22',
      '1948-02-10',
      '1949-01-29',
      '1950-02-17',
      '1951-02-06',
      '1952-01-27',
      '1953-02-14',
      '1954-02-03',
      '1955-01-24',
      '1956-02-12',
      '1957-01-31',
      '1958-02-18',
      '1959-02-08',
      '1960-01-28',
      '1961-02-15',
      '1962-02-05',
      '1963-01-25',
      '1964-02-13',
      '1965-02-02',
      '1966-01-21',
      '1967-02-09',
      '1968-01-30',
      '1969-02-17',
      '1970-02-06',
      '1971-01-27',
      '1972-02-15',
      '1973-02-03',
      '1974-01-23',
      '1975-02-11',
      '1976-01-31',
      '1977-02-18',
      '1978-02-07',
      '1979-01-28',
      '1980-02-16',
      '1981-02-05',
      '1982-01-25',
      '1983-02-12',
      '1984-02-02',
      '1985-02-20',
      '1986-02-09',
      '1987-01-29',
      '1988-02-17',
      '1989-02-06',
      '1990-01-27',
      '1991-02-14',
      '1992-02-04',
      '1993-01-22',
      '1994-02-10',
      '1995-01-31',
      '1996-02-19',
      '1997-02-07',
      '1998-01-28',
      '1999-02-16',
      '2000-02-05',
      '2001-01-24',
      '2002-02-12',
      '2003-02-01',
      '2004-01-22',
      '2005-02-09',
      '2006-01-29',
      '2007-02-18',
      '2008-02-07',
      '2009-01-26',
      '2010-02-14',
      '2011-02-03',
      '2012-01-23',
      '2013-02-10',
      '2014-01-31',
      '2015-02-19',
      '2016-02-08',
      '2017-01-28',
      '2018-02-16',
      '2019-02-05',
      '2020-01-25',
      '2021-02-12',
      '2022-02-01',
      '2023-01-22',
      '2024-02-10',
      '2025-01-29',
      '2026-02-17',
      '2027-02-06',
      '2028-01-26',
      '2029-02-13',
      '2030-02-03'
    ];

    DateTime currentDate = DateTime.now();
    List<DateTime> cnyDates = chineseNewYear.map((cnyDate) => DateTime.parse(cnyDate)).toList();

    DateTime? matchingDate;
    for (DateTime cnyDate in cnyDates) {
      if (cnyDate.year == currentDate.year) {
        matchingDate = cnyDate;
        break;
      }
    }

    if (matchingDate == null) {
      return age;
    }

    int lunarAge = age;
    if (calculateOn == null) {
      lunarAge += currentDate.isAfter(matchingDate) ? 2 : 1;
    } else {
      lunarAge += (currentDate.isAfter(matchingDate) && calculateOn.isAfter(matchingDate)) ? 2 : 1;
    }

    return lunarAge;
  }
}
