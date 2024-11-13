import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_snackbar.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_model.dart';
import 'package:periodnpregnancycalender/app/models/sync_log_model.dart';
import 'package:periodnpregnancycalender/app/modules/navigation_menu/views/navigation_menu_view.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/pregnancy_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/sync_data_repository.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/services/pregnancy_history_service.dart';
import 'package:periodnpregnancycalender/app/utils/conectivity.dart';
import 'package:periodnpregnancycalender/app/utils/helpers.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePregnancyController extends GetxController {
  final ApiService apiService = ApiService();
  late final PregnancyRepository pregnancyRepository = PregnancyRepository(apiService);
  late Future<void> pregnancyData;
  Rx<CurrentlyPregnant> currentlyPregnantData = Rx<CurrentlyPregnant>(CurrentlyPregnant());
  RxList<WeeklyData> weeklyData = <WeeklyData>[].obs;
  RxInt currentPregnancyWeekIndex = 0.obs;
  final StorageService storageService = StorageService();
  late final SyncDataRepository _syncDataRepository;
  late final PregnancyHistoryService _pregnancyHistoryService;

  int? get getPregnancyIndex => currentPregnancyWeekIndex.value;

  final Rx<DateTime> _focusedDate = Rx<DateTime>(DateTime.now());
  DateTime get getFocusedDate => _focusedDate.value;

  void setFocusedDate(DateTime selectedDate) {
    _focusedDate.value = selectedDate;
    update();
  }

  final Rx<DateTime?> _selectedDate = Rx<DateTime?>(DateTime.now());

  DateTime? get selectedDate => _selectedDate.value;

  void setSelectedDate(DateTime selectedDate) {
    _selectedDate.value = selectedDate;
    update();
  }

  @override
  void onInit() {
    _syncDataRepository = SyncDataRepository();
    _pregnancyHistoryService = PregnancyHistoryService();
    pregnancyData = fetchPregnancyData();
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

  Future<void> fetchPregnancyData() async {
    var result = await _pregnancyHistoryService.getCurrentPregnancyData("id");
    currentlyPregnantData.value = result!;
    weeklyData.assignAll(currentlyPregnantData.value.weeklyData!);
    currentPregnancyWeekIndex.value = currentlyPregnantData.value.usiaKehamilan! - 1;
    update();
  }

  Future<void> editPregnancyStartDate(context) async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    String formattedDate = formatDate(selectedDate!);
    bool localSuccess = false;
    PregnancyHistory? updatedPregnancy;

    try {
      updatedPregnancy = await _pregnancyHistoryService.beginPregnancy(selectedDate!, null);
      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(context)!.firstDayOfLastPeriodEditedSuccess));
      localSuccess = true;
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.firstDayOfLastPeriodEditFailed));
      return;
    }

    if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      try {
        await pregnancyRepository.pregnancyBegin(formattedDate, null);
      } catch (e) {
        await _syncPregnancyBegin(updatedPregnancy?.id ?? 0);
      }
    } else if (localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      await _syncPregnancyBegin(updatedPregnancy?.id ?? 0);
    }

    Get.offAll(() => NavigationMenuView());
  }

  Future<void> _syncPregnancyBegin(int id) async {
    SyncLog syncLog = SyncLog(
      tableName: 'pregnancy',
      operation: 'update',
      dataId: id,
      createdAt: DateTime.now().toString(),
    );

    await _syncDataRepository.addSyncLogData(syncLog);
  }

  void pregnancyIndexBackward() {
    currentPregnancyWeekIndex.value--;
    if (currentPregnancyWeekIndex.value < 1) {
      currentPregnancyWeekIndex.value = 0;
    }
  }

  void pregnancyIndexForward() {
    currentPregnancyWeekIndex.value++;
    if (currentPregnancyWeekIndex.value > 40) {
      currentPregnancyWeekIndex.value = 40;
    }
  }
}
