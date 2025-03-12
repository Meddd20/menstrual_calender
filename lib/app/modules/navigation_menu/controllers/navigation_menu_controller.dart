import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/modules/home/views/home_view.dart';
import 'package:periodnpregnancycalender/app/modules/insight/views/insight_view.dart';
import 'package:periodnpregnancycalender/app/modules/profile/views/profile_view.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/views/analysis_view.dart';

import 'package:periodnpregnancycalender/app/utils/utils.dart';
import 'package:periodnpregnancycalender/app/services/services.dart';
import 'package:periodnpregnancycalender/app/repositories/repositories.dart';

class NavigationMenuController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  late var initialIndex = 0;
  late final SyncDataService _syncDataService;
  final ApiService apiService = ApiService();
  late final AuthRepository authRepository = AuthRepository(apiService);
  final storageService = StorageService();
  Rx<bool?> deleteData = Rx<bool>(false);
  Rx<String?> isPregnant = Rx<String?>(StorageService().getIsPregnant());

  @override
  void onInit() async {
    _syncDataService = SyncDataService();
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

        if (storageService.getIsAccountCreatedUnverified() && storageService.getCredentialToken() != null) {
          await authRepository.deleteData();
          await _syncDataService.rebackupData();
          storageService.storeIsAccountCreatedUnverified(false);
        }

        if (!storageService.isDataSync()) {
          await _syncDataService.syncData();
          storageService.setHasSyncData(true);
        }

        await _syncDataService.syncMasterDataVersion();

        await authRepository.checkToken();
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
