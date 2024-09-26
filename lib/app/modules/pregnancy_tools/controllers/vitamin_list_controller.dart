import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/models/master_vitamins_model.dart';
import 'package:periodnpregnancycalender/app/services/master_vitamins_service.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';

class VitaminListController extends GetxController {
  late final MasterVitaminsService _masterVitaminsService;
  late final Future<List<MasterVitamin>> listVitamins;
  final StorageService storageService = StorageService();
  @override
  void onInit() {
    _masterVitaminsService = MasterVitaminsService();
    listVitamins = getAllVitaminList();
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

  Future<List<MasterVitamin>> getAllVitaminList() async {
    return await _masterVitaminsService.getAllVitamin();
  }
}
