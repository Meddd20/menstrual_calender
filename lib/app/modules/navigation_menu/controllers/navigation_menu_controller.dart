import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/modules/home/views/home_view.dart';
import 'package:periodnpregnancycalender/app/modules/insight/views/insight_view.dart';
import 'package:periodnpregnancycalender/app/modules/profile/views/profile_view.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/views/analysis_view.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/auth_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/log_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/master_gender_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/master_kehamilan_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/master_newmoon_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/period_history_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/pregnancy_history_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/profile_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/sync_data_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/weight_history_repository.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/services/log_service.dart';
import 'package:periodnpregnancycalender/app/services/period_history_service.dart';
import 'package:periodnpregnancycalender/app/services/pregnancy_history_service.dart';
import 'package:periodnpregnancycalender/app/services/sync_data_service.dart';
import 'package:periodnpregnancycalender/app/services/weight_history_service.dart';
import 'package:periodnpregnancycalender/app/utils/conectivity.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';

class NavigationMenuController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  late var initialIndex = 0;
  late final SyncDataService _syncDataService;
  final ApiService apiService = ApiService();
  late final AuthRepository authRepository = AuthRepository(apiService);
  final storageService = StorageService();
  Rx<bool?> deleteData = Rx<bool>(false);

  @override
  void onInit() async {
    final databaseHelper = DatabaseHelper.instance;
    final periodHistoryRepository = PeriodHistoryRepository(databaseHelper);
    final pregnancyHistoryRepository = PregnancyHistoryRepository(databaseHelper);
    final weightHistoryRepository = WeightHistoryRepository(databaseHelper);
    final localProfileRepository = LocalProfileRepository(databaseHelper);
    final masterNewmoonRepository = MasterNewmoonRepository(databaseHelper);
    final masterGenderRepository = MasterGenderRepository(databaseHelper);
    final masterKehamilanRepository = MasterDataKehamilanRepository(databaseHelper);
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

    deleteData.value = Get.arguments as bool? ?? false;
    if (deleteData.value == true) {
      authRepository.deleteData();
    }

    super.onInit();
  }

  Future<void> initializeData() async {
    await Future.delayed(Duration(seconds: 2));
    if (storageService.getCredentialToken() != null) {
      bool isConnected = await CheckConnectivity().isConnectedToInternet();
      if (isConnected) {
        await _syncDataService.pendingDataChange();

        if (!storageService.isDataSync()) {
          await _syncDataService.syncData();
          storageService.setHasSyncData(true);
        }

        authRepository.checkToken();
        // if (storageService.getStoreDataMechanism() == "primary" && !storageService.isDataSync()) {
        //   await _syncDataService.syncData();
        //   storageService.setHasSyncData(true);
        // } else {
        //   await _syncDataService.syncData();
        // }
      }
    }
  }

  @override
  void onReady() async {
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
