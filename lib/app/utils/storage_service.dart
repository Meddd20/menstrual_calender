import 'package:get_storage/get_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final GetStorage box = GetStorage();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  // void setAuthToken(String authToken) async {
  //   await secureStorage.write(key: "authToken", value: authToken);
  //   print("lalala ${await getAuthToken()}");
  // }

  // Future<String> getAuthToken() async {
  //   return await secureStorage.read(key: "authToken") ?? "";
  // }

  // void deleteAuthToken() async {
  //   await secureStorage.delete(key: "authToken");
  // }

  void storeCredentialToken(String token) {
    box.write("loginAuth", token);
  }

  String? getCredentialToken() {
    return box.read("loginAuth");
  }

  void deleteCredentialToken() {
    box.remove("loginAuth");
  }

  void storeAccountId(int id) {
    box.write("loginId", id);
  }

  int? getAccountId() {
    int? loginId = box.read("loginId");
    return loginId ?? 0;
  }

  void storeAccountLocalId(int id) {
    box.write("localId", id);
  }

  int getAccountLocalId() {
    int? localId = box.read("localId");
    return localId ?? 0;
  }

  void deleteAccountLocalId() {
    box.remove("localId");
  }

  void storeIsAuth(bool isAuth) {
    box.write("isAuth", isAuth);
  }

  bool getIsAuth() {
    return box.read("isAuth") ?? false;
  }

  void storeIsBackup(bool isBackup) {
    box.write("isBackup", isBackup);
  }

  bool getIsBackup() {
    return box.read("isBackup");
  }

  void storeIsPregnant(String isPregnant) {
    box.write("isPregnant", isPregnant);
  }

  String getIsPregnant() {
    return box.read("isPregnant");
  }

  void deleteIsPregnant() {
    box.remove("isPregnant");
  }

  void storeIsBirthSuccess(bool isBirthSuccess) {
    box.write("isBirthSucess", isBirthSuccess);
  }

  bool getIsBirthSuccess() {
    return box.read("isBirthSucess") ?? true;
  }

  String getLanguage() {
    String? language = box.read("language");
    if (language == null) {
      setLanguage("en");
      return "en";
    }
    return language;
  }

  void setLanguage(String language) {
    box.write("language", language);
  }

  bool isDataSync() {
    bool isDataSync = box.read("hasSyncData");
    if (isDataSync.toString() == "null") {
      setHasSyncData(false);
      return false;
    }
    return isDataSync;
  }

  void setHasSyncData(bool isSync) {
    box.write("hasSyncData", isSync);
  }

  void setMajorVersionMasterFoodData(int majorVersion) {
    box.write("majorVersionFood", majorVersion);
  }

  void setMinorVersionMasterFoodData(int minorVersion) {
    box.write("minorVersionFood", minorVersion);
  }

  int getMajorVersionMasterFoodData() {
    int majorVersionFood = box.read("majorVersionFood") ?? 1;
    return majorVersionFood;
  }

  int getMinorVersionMasterFoodData() {
    int minorVersionFood = box.read("minorVersionFood") ?? 0;
    return minorVersionFood;
  }

  void setMajorVersionMasterKehamilanData(int majorVersion) {
    box.write("majorVersionKehamilan", majorVersion);
  }

  void setMinorVersionMasterKehamilanData(int minorVersion) {
    box.write("minorVersionKehamilan", minorVersion);
  }

  int getMajorVersionMasterKehamilanData() {
    int majorVersionKehamilan = box.read("majorVersionKehamilan") ?? 1;
    return majorVersionKehamilan;
  }

  int getMinorVersionMasterKehamilanData() {
    int minorVersionKehamilan = box.read("minorVersionKehamilan") ?? 0;
    return minorVersionKehamilan;
  }

  void setMajorVersionMasterVaccineData(int majorVersion) {
    box.write("majorVersionVaccine", majorVersion);
  }

  void setMinorVersionMasterVaccineData(int minorVersion) {
    box.write("minorVersionVaccine", minorVersion);
  }

  int getMajorVersionMasterVaccineData() {
    int majorVersionVaccine = box.read("majorVersionVaccine") ?? 1;
    return majorVersionVaccine;
  }

  int getMinorVersionMasterVaccineData() {
    int minorVersionVaccine = box.read("minorVersionVaccine") ?? 0;
    return minorVersionVaccine;
  }

  void setMajorVersionMasterVitaminData(int majorVersion) {
    box.write("majorVersionVitamin", majorVersion);
  }

  void setMinorVersionMasterVitaminData(int minorVersion) {
    box.write("minorVersionVitamin", minorVersion);
  }

  int getMajorVersionMasterVitaminData() {
    int majorVersionVitamin = box.read("majorVersionVitamin") ?? 1;
    return majorVersionVitamin;
  }

  int getMinorVersionMasterVitaminData() {
    int minorVersionVitamin = box.read("minorVersionVitamin") ?? 0;
    return minorVersionVitamin;
  }

  void setPin(bool pinSecure) {
    box.write("pinSecure", pinSecure);
  }

  bool isPinSecure() {
    bool pinSecure = box.read("pinSecure") ?? false;
    return pinSecure;
  }

  void currentPin(String pin) {
    box.write("pin", pin);
  }

  String getCurrentPin() {
    String? pin = box.read("pin");
    return pin ?? "";
  }
}
