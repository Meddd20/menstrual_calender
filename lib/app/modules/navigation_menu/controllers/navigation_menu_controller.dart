import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/modules/home/views/home_view.dart';
import 'package:periodnpregnancycalender/app/modules/insight/views/insight_view.dart';
import 'package:periodnpregnancycalender/app/modules/profile/views/profile_view.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/views/analysis_view.dart';
import 'package:periodnpregnancycalender/app/repositories/local/log_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/master_gender_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/master_kehamilan_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/master_newmoon_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/period_history_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/pregnancy_history_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/profile_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/sync_data_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/weight_history_repository.dart';
import 'package:periodnpregnancycalender/app/services/log_service.dart';
import 'package:periodnpregnancycalender/app/services/period_history_service.dart';
import 'package:periodnpregnancycalender/app/services/pregnancy_history_service.dart';
import 'package:periodnpregnancycalender/app/services/sync_data_service.dart';
import 'package:periodnpregnancycalender/app/services/weight_history_service.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';

class NavigationMenuController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  late var initialIndex = 0;
  late final SyncDataService _syncDataService;
  final storageService = StorageService();

  @override
  void onInit() {
    final databaseHelper = DatabaseHelper.instance;
    final periodHistoryRepository = PeriodHistoryRepository(databaseHelper);
    final pregnancyHistoryRepository = PregnancyHistoryRepository(databaseHelper);
    final weightHistoryRepository = WeightHistoryRepository(databaseHelper);
    final localProfileRepository = LocalProfileRepository(databaseHelper);
    final masterNewmoonRepository = MasterNewmoonRepository(databaseHelper);
    final masterGenderRepository = MasterGenderRepository(databaseHelper);
    final masterKehamilanRepository = MasterKehamilanRepository(databaseHelper);
    final syncDataRepository = SyncDataRepository(databaseHelper);
    final localLogRepository = LocalLogRepository(databaseHelper);

    final periodHistoryService = PeriodHistoryService(periodHistoryRepository, localProfileRepository, masterNewmoonRepository, masterGenderRepository);
    final pregnancyHistoryService = PregnancyHistoryService(pregnancyHistoryRepository, masterKehamilanRepository, periodHistoryRepository, localProfileRepository);
    final weightHistoryService = WeightHistoryService(weightHistoryRepository, pregnancyHistoryRepository);
    final logService = LogService(localLogRepository);

    _syncDataService = SyncDataService(
      weightHistoryRepository,
      periodHistoryRepository,
      pregnancyHistoryRepository,
      localProfileRepository,
      syncDataRepository,
      localLogRepository,
      periodHistoryService,
      weightHistoryService,
      pregnancyHistoryService,
      logService,
    );

    if (storageService.getCredentialToken() != null) {
      _syncDataService.pendingDataChange();
      // if (storageService.getStoreDataMechanism() == "primary") {
      //   return;
      // }
      _syncDataService.syncData();
    }
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  final screens = [HomeView(), AnalysisView(), InsightView(), ProfileView()];

  void goToProfile() {
    selectedIndex.value = 3;
  }
}
