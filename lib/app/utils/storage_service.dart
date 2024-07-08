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
    return box.read("loginId");
  }

  void storeAccountLocalId(int id) {
    box.write("localId", id);
  }

  int getAccountLocalId() {
    return box.read("localId");
  }

  void storeIsAuth(bool isAuth) {
    box.write("isAuth", isAuth);
  }

  bool getIsAuth() {
    return box.read("isAuth");
  }

  void storePrimaryDataMechanism() {
    box.write("storeDataMechanism", "primary");
  }

  void storeManyDataMechanism() {
    box.write("storeDataMechanism", "many");
  }

  String? getStoreDataMechanism() {
    return box.read("storeDataMechanism");
  }

  void storeIsPregnant(String isPregnant) {
    box.write("isPregnant", isPregnant);
  }

  String? getIsPregnant() {
    return box.read("isPregnant");
  }

  void deleteIsPregnant() {
    box.remove("isPregnant");
  }
}
