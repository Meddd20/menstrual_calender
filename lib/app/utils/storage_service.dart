import 'package:get_storage/get_storage.dart';

class StorageService {
  final GetStorage box = GetStorage();

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
    return box.read("isAuth");
  }

  void storeIsBackup(bool isBackup) {
    box.write("isBackup", isBackup);
  }

  bool getIsBackup() {
    return box.read("isBackup");
  }

  // void storePrimaryDataMechanism() {
  //   box.write("storeDataMechanism", "primary");
  // }

  // void storeManyDataMechanism() {
  //   box.write("storeDataMechanism", "many");
  // }

  // String? getStoreDataMechanism() {
  //   String? storageMechanism = box.read("storeDataMechanism");
  //   if (storageMechanism == null) {
  //     setLanguage("primary");
  //     return "primary";
  //   }
  //   return storageMechanism;
  // }

  void storeIsPregnant(String isPregnant) {
    box.write("isPregnant", isPregnant);
  }

  String? getIsPregnant() {
    return box.read("isPregnant");
  }

  void deleteIsPregnant() {
    box.remove("isPregnant");
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
}
