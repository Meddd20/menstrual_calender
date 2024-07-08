import 'dart:convert';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_model.dart';
import 'package:periodnpregnancycalender/app/models/sync_log_model.dart';
import 'package:periodnpregnancycalender/app/modules/navigation_menu/views/navigation_menu_view.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/pregnancy_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/master_kehamilan_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/period_history_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/pregnancy_history_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/profile_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/sync_data_repository.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:intl/intl.dart';
import 'package:periodnpregnancycalender/app/services/pregnancy_history_service.dart';
import 'package:periodnpregnancycalender/app/utils/conectivity.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';

class HomePregnancyController extends GetxController {
  final ApiService apiService = ApiService();
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;
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
    final databaseHelper = DatabaseHelper.instance;
    final PregnancyHistoryRepository pregnancyHistoryRepository = PregnancyHistoryRepository(databaseHelper);
    final MasterKehamilanRepository masterKehamilanRepository = MasterKehamilanRepository(databaseHelper);
    final PeriodHistoryRepository periodHistoryRepository = PeriodHistoryRepository(databaseHelper);
    final LocalProfileRepository localProfileRepository = LocalProfileRepository(databaseHelper);
    _syncDataRepository = SyncDataRepository(databaseHelper);
    _pregnancyHistoryService = PregnancyHistoryService(pregnancyHistoryRepository, masterKehamilanRepository, periodHistoryRepository, localProfileRepository);
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

  // Future<void> fetchPregnancyData() async {
  //   var result = await pregnancyRepository.getPregnancyIndex();
  //   currentlyPregnantData.value = result!.data!.currentlyPregnant!.first;
  //   weeklyData.assignAll(currentlyPregnantData.value.weeklyData!);
  //   currentPregnancyWeekIndex.value = (currentlyPregnantData.value.usiaKehamilan ?? 0) - 1;
  //   setSelectedDate(DateTime.parse(currentlyPregnantData.value.hariPertamaHaidTerakhir ?? "${DateTime.now()}"));
  //   setFocusedDate(DateTime.parse(currentlyPregnantData.value.hariPertamaHaidTerakhir ?? "${DateTime.now()}"));
  //   update();
  // }

  Future<void> fetchPregnancyData() async {
    var result = await _pregnancyHistoryService.getCurrentPregnancyData("id");
    currentlyPregnantData.value = result!;
    weeklyData.assignAll(currentlyPregnantData.value.weeklyData!);
    currentPregnancyWeekIndex.value = (currentlyPregnantData.value.usiaKehamilan ?? 0) - 1;
    setSelectedDate(DateTime.parse(currentlyPregnantData.value.hariPertamaHaidTerakhir ?? "${DateTime.now()}"));
    setFocusedDate(DateTime.parse(currentlyPregnantData.value.hariPertamaHaidTerakhir ?? "${DateTime.now()}"));
    update();
  }

  Future<void> editPregnancyStartDate() async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    await _pregnancyHistoryService.beginPregnancy(selectedDate!);

    if (storageService.getIsAuth() && !isConnected) {
      await _syncPregnancyBegin();
      return;
    }

    try {
      await pregnancyRepository.pregnancyBegin(selectedDate.toString(), null);
      Get.offAll(() => NavigationMenuView());
    } catch (e) {
      print("Error editing pregnancy start date: $e");
      await _syncPregnancyBegin();
    }
  }

  Future<void> _syncPregnancyBegin() async {
    Map<String, dynamic> data = {
      "hari_pertama_haid_terakhir": selectedDate,
    };

    String jsonData = jsonEncode(data);

    SyncLog syncLog = SyncLog(
      tableName: 'tb_riwayat_kehamilan',
      operation: 'beginPregnancy',
      data: jsonData,
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

  String? formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    DateFormat formatter = DateFormat('MMMM dd');
    return formatter.format(date);
  }
}

String foodToAvoidEn = """
<ul>
    <li>
        <strong>Raw Seafood:</strong> All seafood dishes should be cooked to 145°F (63°C). Consuming raw seafood, which may include parasites or bacteria like Listeria, can make pregnant women ill and perhaps endanger their newborns. Therefore, it is advised to avoid foods like sushi, sashimi, raw oysters, raw clams, raw scallops, and ceviche.
    </li>
    <li>
        <strong>Smoked Seafood:</strong> Refrigerated smoked seafood contains a high risk of Listeria. Avoid eating cold smoked seafood unless it is cooked to an internal temperature of 165°F (74°C). Refrigerated smoked seafood includes salmon, trout, whitefish, cod, tuna, and mackerel, which are frequently marketed as Nova-style, lox, kippered, smoked, or jerky. Smoked seafood is acceptable to eat during pregnancy if it is canned, shelf-stable, or part of a cooked meal.
    </li>
    <li>
        <strong>Fish:</strong> Fish are essential in a healthy diet and provide crucial nutrients during pregnancy, breastfeeding, and early childhood, supporting a child’s brain development. However, fish can also contain mercury, a highly toxic element found in polluted waters. High mercury levels can damage the nervous system, immune system, and kidneys, and cause serious developmental issues in children. Therefore, it is best to avoid high-mercury fish such as shark, swordfish, king mackerel, bigeye tuna, marlin, tilefish from the Gulf of Mexico, and orange roughy during pregnancy and breastfeeding.
    </li>
    <li>
        <strong>Unpasteurized Juice or Cider:</strong> Unpasteurized juice, including fresh-squeezed juice and cider, can cause foodborne illnesses and have been linked to outbreaks of E. coli and other harmful bacteria. To prevent infections, choose pasteurized versions or boil unpasteurized juice or cider for at least one minute before drinking.
    </li>
    <li>
        <strong>Raw Milk Products:</strong> Raw milk from any animal that has not been pasteurized may contain harmful bacteria like <i>Campylobacter</i>, <i>E. coli</i>, <i>Listeria</i>, <i>Salmonella</i>, or bacteria that cause tuberculosis. To avoid these foodborne illnesses, consume only pasteurized milk and milk products, including cheese. Soft cheeses such as Brie, feta, camembert, roquefort, queso blanco, and queso fresco should be avoided unless made with pasteurized milk. Instead, opt for hard cheeses like cheddar or Swiss.
    </li>
    <li>
        <strong>Eggs:</strong> Undercooked eggs can contain Salmonella. Ensure eggs are cooked until the yolks and whites are firm to kill germs. Casseroles or dishes containing eggs should be cooked to 160°F (71°C). Foods containing raw or lightly cooked eggs should be made with pasteurized eggs. Avoid foods that may contain raw eggs, such as homemade eggnog, raw batter, homemade Caesar salad dressing, tiramisu, eggs benedict, homemade ice cream, freshly made hollandaise sauce, lightly scrambled eggs, homemade mayonnaise, and some homemade cake icings.
    </li>
    <li>
        <strong>Premade Salad:</strong> Avoid buying or eating premade ham, chicken, or seafood salads from delis, as they may contain Listeria.
    </li>
    <li>
        <strong>Sprouts:</strong> Raw or undercooked sprouts like alfalfa, clover, mung bean, and radish may harbor E. coli or Salmonella. Cook sprouts thoroughly.
    </li>
    <li>
        <strong>Meat and Poultry:</strong> All meat and poultry should be thoroughly cooked. Use a food thermometer to ensure the meat has reached the USDA-recommended safe minimum internal temperature. Refer to minimum cooking temperatures for specific details. Raw or undercooked meat and poultry may contain E. coli, Salmonella, Campylobacter, or Toxoplasma gondii.
    </li>
    <li>
        <strong>Hot Dogs and Luncheon Meats:</strong> Hot dogs, luncheon meats, cold cuts, fermented or dry sausage, and other deli-style meats and poultry can harbor various bacteria during processing or storage. Reheat these meats to steaming hot or 165°F (74°C) before eating. These meat items may contain Listeria and are unsafe if not thoroughly reheated.
    </li>
    <li>
        <strong>Meat Spreads or Pâté:</strong> Avoid refrigerated pâtés or meat spreads from a deli or the refrigerated section of a store as they can contain Listeria. Opt for canned, jarred, or sealed pouch meat spreads that do not require refrigeration before opening, and refrigerate them after opening.
    </li>
    <li>
        <strong>Dough:</strong> Unbaked (raw) dough or batter can cause illness as flour may contain E. coli and raw eggs may contain Salmonella. Ensure batter is thoroughly baked or cooked before eating. Do not consume any raw cookie dough, cake mix, batter, or other raw dough products meant to be cooked or baked.
    </li>
    <li>
        <strong>Fruits and Vegetables:</strong> Unwashed or unpeeled fruits and vegetables may be contaminated with bacteria and parasites such as Toxoplasma, E. coli, Salmonella, and Listeria. These contaminants can be present from soil or handling at any production stage. Thoroughly wash all fruits and vegetables with clean water and peel or cook them before eating.
    </li>
    <li>
        <strong>Processed Foods:</strong> Highly processed foods are typically low in nutrients and high in calories, sugar, and added fats, increasing the risk of weight gain. During pregnancy, it is essential to consume nutrients like protein, folate, choline, and iron. While some weight gain is necessary, excessive weight gain can increase the risk of delivery complications and childhood obesity. Focus on meals and snacks rich in protein, vegetables, fruits, healthy fats, and fiber-rich carbohydrates like whole grains, beans, and starchy vegetables.
    </li>
    <li>
        <strong>Alcohol:</strong> During pregnancy, alcohol increases the risk of pregnancy loss, stillbirth, and fetal alcohol syndrome (FAS), which can affect many aspects of development, including the heart and brain. Since no level of alcohol is proven safe during pregnancy, it is best to avoid it altogether.
    </li>
    <li>
        <strong>Caffeine:</strong> Caffeine is present in coffee, tea, soft drinks, and cocoa. High caffeine intake is linked to pregnancy loss, stillbirth, low birth weight, and various developmental issues. Caffeine is quickly absorbed and passes easily into the placenta. Because babies and their placentas lack the main enzyme needed to metabolize caffeine, high levels can accumulate. The American College of Obstetricians and Gynecologists (ACOG) recommends limiting caffeine intake to less than 200 milligrams (mg) per day during pregnancy.
    </li>
</ul>
""";

String pregnancyVaccines = """
<ul>
    <li>
        <strong>Influenza Vaccine:</strong> Getting an influenza vaccine during flu season can prevent mothers from serious medical and obstetric complications, as well as protect their newborns throughout early infancy. This vaccine can be safely given at any point during pregnancy. Pregnant and postpartum women are more likely than non-pregnant women to have severe illness and complications from influenza due to changes in their immune systems, hearts, and lungs. Women who are or will be pregnant during flu season should take either the inactivated influenza vaccination (IIV) or the recombinant influenza vaccine (RIV).
    </li>
    <li>
        <strong>Tdap Vaccine:</strong> The tetanus, diphtheria, and pertussis (Tdap) vaccine, given during the third trimester, protects pregnant women and newborns from whooping cough. This vaccine is also advised for anyone who will have close contact with infants under one year old, such as grandparents or daycare workers. Regardless of previous Tdap immunization history, healthcare providers should give a Tdap dosage throughout each pregnancy. Tdap is best administered between 27 and 36 weeks gestation to enhance maternal antibody response and passive antibody transmission to the newborn, although it can be given at any time throughout pregnancy. If not given during pregnancy, it should be given promptly after birth.
    </li>
    <li>
        <strong>COVID-19:</strong> Pregnant women infected with SARS-CoV-2 have a higher risk of severe COVID-19 disease compared to non-pregnant women. Healthy pregnant women are up to four times more likely to need intensive care and respiratory support than their non-pregnant counterparts. Babies born to mothers with COVID-19 are up to seven times more likely to be born prematurely and up to five times more likely to require newborn intensive care.
    </li>
    <li>
        <strong>Additional Vaccines:</strong> Hepatitis A, Hepatitis B, and pneumococcal vaccines may be recommended if you have certain risk factors or are in the middle of a vaccination series that began before pregnancy. Consult your doctor to determine if these vaccines would be beneficial for you.
    </li>
</ul>
""";

String prenatalVitamins = """
<h2>Prenatal Vitamins</h2>
    <p>Prenatal vitamins are supplements designed for pregnant women to supply essential vitamins and minerals needed for a healthy pregnancy. Healthcare professionals advise beginning their intake when planning for pregnancy and continuing throughout gestation. These supplements contain a combination of nutrients such as folic acid, calcium, and iron, essential for fetal growth and maternal health. They help address any nutritional deficiencies and are crucial for supporting overall well-being during pregnancy. Consulting with a doctor before initiating any vitamin, supplement, or herbal regimen during pregnancy is imperative.</p>

    <p>Ensuring adequate nutrient intake is crucial for a healthy pregnancy, and selecting the right prenatal vitamins is important. Optimal prenatal vitamin requirements include essential nutrients such as folic acid (400 mcg), vitamin D (600 IU), calcium (1,000 mg), vitamin C (80 mg), thiamine (1.4 mg), riboflavin (1.4 mg), niacin (18 mg), vitamin B12 (2.6 mcg), vitamin B6 (1.9 mg), vitamin E (15 mg), zinc (11 mg), iron (27 mg), and vitamin A (770 mcg). When choosing prenatal vitamins, it's important to ensure they are not expired or close to expiration. Additionally, checking for potential allergens like corn, eggs, or wheat in the ingredient list is advisable for those with food allergies or sensitivities. If unsure about the quality or specific needs, consulting with a healthcare provider for recommended brands or additional supplements tailored to individual requirements is recommended.</p>

    <h3>Essential Nutrients in Prenatal Vitamins</h3>
    <ul>
        <li><strong>Folic Acid (Folate):</strong> Folic acid is crucial for preventing neural tube defects in babies, such as spina bifida and anencephaly. These defects develop early in pregnancy, often before a woman knows she's pregnant, which is why it's recommended to start taking folic acid before conception and continue through the first trimester. While folic acid is naturally found in foods like green leafy vegetables, nuts, and beans, supplementation is recommended to ensure adequate intake, especially during pregnancy's critical early stages.</li>
        <li><strong>Calcium:</strong> Calcium is essential for the development of the baby's bones and teeth. While some prenatal vitamins contain calcium, additional supplementation may be necessary to meet the increased demands of pregnancy. Adequate calcium intake also supports maternal bone health during pregnancy.</li>
        <li><strong>Iodine:</strong> Iodine is critical for maintaining healthy thyroid function during pregnancy. Insufficient iodine intake can lead to miscarriage, stillbirth, or developmental issues in the baby, such as stunted physical growth, severe mental disability, or deafness. It's important to ensure adequate iodine intake either through diet or supplementation.</li>
        <li><strong>Iron:</strong> Iron is necessary for producing red blood cells, which carry oxygen to the baby for proper development. Many pregnant women don’t consume enough iron in their diet to meet the increased demands of pregnancy, leading to iron deficiency anemia. Iron supplementation during pregnancy helps prevent anemia and reduces the risk of preterm delivery and low birth weight.</li>
        <li><strong>Omega-3 Fatty Acids:</strong> Omega-3 fatty acids, including DHA and EPA, are essential for the development of the baby's brain, nerve, and eye tissue. While some prenatal vitamins may not include omega-3 fatty acids, they can be obtained from food sources like fatty fish and nuts. Supplementation may be necessary if dietary intake is insufficient.</li>
        <li><strong>Vitamin D:</strong> Vitamin D is important for building the baby's bones and teeth and maintaining calcium and phosphorus levels in the body. Adequate vitamin D intake during pregnancy helps prevent bone-related issues in both the mother and the baby. Deficiency in vitamin D has been associated with an increased risk of pregnancy complications such as preeclampsia and gestational diabetes.</li>
        <li><strong>Choline:</strong> Choline is essential for healthy brain growth in the baby. While the body can produce some choline on its own, most of it comes from dietary sources like meat and eggs. A pregnant woman should ensure sufficient choline intake either through diet or supplementation to support the baby's neurological development.</li>
        <li><strong>Protein:</strong> Protein intake needs to increase during pregnancy to support the growing needs of both the mother and the developing baby. Adequate protein intake helps in the formation of new tissue, including the placenta, which provides oxygen and nutrients to the baby. Protein-rich foods should be included in the maternal diet to meet the increased protein requirements during pregnancy.</li>
    </ul>
""";
