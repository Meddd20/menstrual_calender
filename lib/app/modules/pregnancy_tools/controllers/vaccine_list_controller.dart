import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/models/master_vaccines_model.dart';
import 'package:periodnpregnancycalender/app/repositories/local/master_vaccines_repository.dart';
import 'package:periodnpregnancycalender/app/services/master_vaccines_service.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';

class VaccineListController extends GetxController {
  late final MasterVaccinesService _masterVaccinesService;
  late final Future<List<MasterVaccine>> listVaccines;
  final StorageService storageService = StorageService();

  @override
  void onInit() {
    final _databaseHelper = DatabaseHelper.instance;
    final masterVaccineRepository = MasterVaccinesRepository(_databaseHelper);
    _masterVaccinesService = MasterVaccinesService(masterVaccineRepository);
    listVaccines = getAllVaccineList();
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

  Future<List<MasterVaccine>> getAllVaccineList() async {
    return await _masterVaccinesService.getAllVaccines();
  }
}
