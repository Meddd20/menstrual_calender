import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String fileName = "permens_new.db";

class DatabaseHelper {
  DatabaseHelper._init();

  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDB(fileName);
    return _database!;
  }

  Future<Database> _initializeDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    // if (await databaseExists(path)) {
    //   await deleteDatabase(path);
    // }

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await _createTables(db);
        await _seedData(db);
      },
    );
  }

  Future<void> _createTables(Database db) async {
    await db.execute(_createTableTbUser);
    await db.execute(_createTableTbBeratBadanKehamilan);
    await db.execute(_createTableTbDataHarian);
    await db.execute(_createTableTbMasterGender);
    await db.execute(_createTableTbMasterKehamilan);
    await db.execute(_createTableTbMasterNewmoon);
    await db.execute(_createTableTbMasterNewmoonPhase);
    await db.execute(_createTableTbRiwayatKehamilan);
    await db.execute(_createTableTbRiwayatMens);
    await db.execute(_createTableSyncLog);
    await db.execute(_createTableTbMasterFood);
    await db.execute(_createTableTbMasterVaccines);
    await db.execute(_createTableTbMasterVitamins);
  }

  Future<void> _seedData(Database db) async {
    Batch batch = db.batch();

    initialTbMasterGender.forEach((item) {
      batch.insert('tb_master_gender', item);
    });

    initialTbMasterKehamilan.forEach((item) {
      batch.insert('tb_master_kehamilan', item);
    });

    initialTbMasterNewmoon.forEach((item) {
      batch.insert('tb_master_newmoon', item);
    });

    initialTbMasterNewmoonPhase.forEach((item) {
      batch.insert('tb_master_newmoon_phase', item);
    });

    initialTbMasterFood.forEach((item) {
      batch.insert('tb_master_food', item);
    });

    initialTbMasterVaccines.forEach((item) {
      batch.insert('tb_master_vaccines', item);
    });

    initialTbMasterVitamins.forEach((item) {
      batch.insert('tb_master_vitamins', item);
    });

    await batch.commit(noResult: true);
  }

  Future close() async {
    Database db = await instance.database;
    db.close();
  }

  static const String _createTableTbUser = '''
    CREATE TABLE tb_user (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      status TEXT CHECK(status IN('Verified','Unverified')),
      nama TEXT,
      tanggal_lahir DATE,
      is_pregnant TEXT CHECK(is_pregnant IN ('0', '1')) DEFAULT '0',
      email TEXT,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  ''';

  static const String _createTableTbBeratBadanKehamilan = '''
    CREATE TABLE tb_berat_badan_kehamilan (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      riwayat_kehamilan_id INTEGER,
      berat_badan REAL,
      minggu_kehamilan INTEGER,
      tanggal_pencatatan DATE,
      pertambahan_berat REAL,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (riwayat_kehamilan_id) REFERENCES tb_riwayat_kehamilan(id),
      FOREIGN KEY (user_id) REFERENCES tb_user(id)
    )
  ''';

  static const String _createTableTbDataHarian = '''
    CREATE TABLE tb_data_harian (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      data_harian TEXT,
      pengingat TEXT,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (user_id) REFERENCES tb_1001(id)
    )
  ''';

  static const String _createTableTbMasterGender = '''
    CREATE TABLE tb_master_gender (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      usia INTEGER,
      bulan INTEGER,
      gender TEXT CHECK(gender IN ('m', 'f'))
    )
  ''';

  static const String _createTableTbMasterKehamilan = '''
    CREATE TABLE tb_master_kehamilan (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      minggu_kehamilan INTEGER,
      berat_janin INTEGER,
      tinggi_badan_janin REAL,
      ukuran_bayi_id TEXT,
      ukuran_bayi_en TEXT,
      poin_utama_id TEXT,
      poin_utama_en TEXT,
      perkembangan_bayi_id TEXT,
      perkembangan_bayi_en TEXT,
      perubahan_tubuh_id TEXT,
      perubahan_tubuh_en TEXT,
      gejala_umum_id TEXT,
      gejala_umum_en TEXT,
      tips_mingguan_id TEXT,
      tips_mingguan_en TEXT,
      bayi_img_path TEXT,
      ukuran_bayi_img_path TEXT
    )
  ''';

  static const String _createTableTbMasterNewmoon = '''
    CREATE TABLE tb_master_newmoon (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      lunar_month INTEGER,
      new_moon DATE,
      shio TEXT CHECK(shio IN ('Goat','Monkey','Rooster','Dog','Pig','Mouse','Ox','Tiger','Rabbit','Dragon','Snake','Horse'))
    )
  ''';

  static const String _createTableTbMasterNewmoonPhase = '''
    CREATE TABLE tb_master_newmoon_phase (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      year INTEGER,
      new_moon DATE
    )
  ''';

  static const String _createTableTbRiwayatKehamilan = '''
    CREATE TABLE tb_riwayat_kehamilan (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      remote_id INTEGER NULL,
      status TEXT NOT NULL CHECK(status IN ('Melahirkan','Hamil')) DEFAULT 'Hamil',
      hari_pertama_haid_terakhir DATE,
      tanggal_perkiraan_lahir DATE,
      kehamilan_akhir DATE,
      tinggi_badan REAL,
      berat_prakehamilan REAL,
      bmi_prakehamilan REAL,
      kategori_bmi TEXT CHECK(kategori_bmi IN ('underweight','normal','overweight','obese')),
      gender TEXT CHECK(gender IN ('Boy','Girl')),
      is_twin TEXT CHECK(is_twin IN ('0','1')) DEFAULT '0',
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (user_id) REFERENCES tb_1001(id)
    )
  ''';

  static const String _createTableTbRiwayatMens = '''
    CREATE TABLE tb_riwayat_mens (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      remote_id INTEGER NULL,
      haid_awal DATE,
      haid_akhir DATE,
      ovulasi DATE,
      masa_subur_awal DATE,
      masa_subur_akhir DATE,
      hari_terakhir_siklus DATE,
      lama_siklus INTEGER,
      durasi_haid INTEGER,
      haid_berikutnya_awal DATE,
      haid_berikutnya_akhir DATE,
      ovulasi_berikutnya DATE,
      masa_subur_berikutnya_awal DATE,
      masa_subur_berikutnya_akhir DATE,
      hari_terakhir_siklus_berikutnya DATE,
      is_actual TEXT CHECK(is_actual IN ('0','1')) NOT NULL DEFAULT '1',
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (user_id) REFERENCES tb_1001(id)
    )
  ''';

  static const String _createTableSyncLog = '''
    CREATE TABLE sync_log (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        table_name TEXT NOT NULL,
        operation TEXT NOT NULL,
        data TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  ''';

  static const String _createTableTbMasterFood = '''
    CREATE TABLE tb_master_food (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      food_id TEXT,
      food_en TEXT,
      description_id TEXT,
      description_en TEXT,
      food_safety TEXT CHECK(food_safety IN ('Safe','Unsafe','Caution')),
      created_at DATE,
      updated_at DATE
    )
  ''';

  static const String _createTableTbMasterVaccines = '''
    CREATE TABLE tb_master_vaccines (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      vaccines_id TEXT,
      vaccines_en TEXT,
      description_id TEXT,
      description_en TEXT,
      created_at DATE,
      updated_at DATE
    )
  ''';

  static const String _createTableTbMasterVitamins = '''
    CREATE TABLE tb_master_vitamins (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      vitamins_id TEXT,
      vitamins_en TEXT,
      description_id TEXT,
      description_en TEXT,
      created_at DATE,
      updated_at DATE
    )
  ''';
}

List<Map<String, dynamic>> initialTbMasterGender = [
  {'id': 1, 'usia': 18, 'bulan': 1, 'gender': 'f'},
  {'id': 2, 'usia': 18, 'bulan': 2, 'gender': 'm'},
  {'id': 3, 'usia': 18, 'bulan': 3, 'gender': 'f'},
  {'id': 4, 'usia': 18, 'bulan': 4, 'gender': 'm'},
  {'id': 5, 'usia': 18, 'bulan': 5, 'gender': 'm'},
  {'id': 6, 'usia': 18, 'bulan': 6, 'gender': 'm'},
  {'id': 7, 'usia': 18, 'bulan': 7, 'gender': 'm'},
  {'id': 8, 'usia': 18, 'bulan': 8, 'gender': 'm'},
  {'id': 9, 'usia': 18, 'bulan': 9, 'gender': 'm'},
  {'id': 10, 'usia': 18, 'bulan': 10, 'gender': 'm'},
  {'id': 11, 'usia': 18, 'bulan': 11, 'gender': 'm'},
  {'id': 12, 'usia': 18, 'bulan': 12, 'gender': 'm'},
  {'id': 13, 'usia': 19, 'bulan': 1, 'gender': 'm'},
  {'id': 14, 'usia': 19, 'bulan': 2, 'gender': 'f'},
  {'id': 15, 'usia': 19, 'bulan': 3, 'gender': 'm'},
  {'id': 16, 'usia': 19, 'bulan': 4, 'gender': 'f'},
  {'id': 17, 'usia': 19, 'bulan': 5, 'gender': 'f'},
  {'id': 18, 'usia': 19, 'bulan': 6, 'gender': 'm'},
  {'id': 19, 'usia': 19, 'bulan': 7, 'gender': 'm'},
  {'id': 20, 'usia': 19, 'bulan': 8, 'gender': 'm'},
  {'id': 21, 'usia': 19, 'bulan': 9, 'gender': 'm'},
  {'id': 22, 'usia': 19, 'bulan': 10, 'gender': 'm'},
  {'id': 23, 'usia': 19, 'bulan': 11, 'gender': 'f'},
  {'id': 24, 'usia': 19, 'bulan': 12, 'gender': 'f'},
  {'id': 25, 'usia': 20, 'bulan': 1, 'gender': 'f'},
  {'id': 26, 'usia': 20, 'bulan': 2, 'gender': 'm'},
  {'id': 27, 'usia': 20, 'bulan': 3, 'gender': 'f'},
  {'id': 28, 'usia': 20, 'bulan': 4, 'gender': 'm'},
  {'id': 29, 'usia': 20, 'bulan': 5, 'gender': 'm'},
  {'id': 30, 'usia': 20, 'bulan': 6, 'gender': 'm'},
  {'id': 31, 'usia': 20, 'bulan': 7, 'gender': 'm'},
  {'id': 32, 'usia': 20, 'bulan': 8, 'gender': 'm'},
  {'id': 33, 'usia': 20, 'bulan': 9, 'gender': 'm'},
  {'id': 34, 'usia': 20, 'bulan': 10, 'gender': 'f'},
  {'id': 35, 'usia': 20, 'bulan': 11, 'gender': 'm'},
  {'id': 36, 'usia': 20, 'bulan': 12, 'gender': 'm'},
  {'id': 37, 'usia': 21, 'bulan': 1, 'gender': 'm'},
  {'id': 38, 'usia': 21, 'bulan': 2, 'gender': 'f'},
  {'id': 39, 'usia': 21, 'bulan': 3, 'gender': 'f'},
  {'id': 40, 'usia': 21, 'bulan': 4, 'gender': 'f'},
  {'id': 41, 'usia': 21, 'bulan': 5, 'gender': 'f'},
  {'id': 42, 'usia': 21, 'bulan': 6, 'gender': 'f'},
  {'id': 43, 'usia': 21, 'bulan': 7, 'gender': 'f'},
  {'id': 44, 'usia': 21, 'bulan': 8, 'gender': 'f'},
  {'id': 45, 'usia': 21, 'bulan': 9, 'gender': 'f'},
  {'id': 46, 'usia': 21, 'bulan': 10, 'gender': 'f'},
  {'id': 47, 'usia': 21, 'bulan': 11, 'gender': 'f'},
  {'id': 48, 'usia': 21, 'bulan': 12, 'gender': 'f'},
  {'id': 49, 'usia': 22, 'bulan': 1, 'gender': 'f'},
  {'id': 50, 'usia': 22, 'bulan': 2, 'gender': 'm'},
  {'id': 51, 'usia': 22, 'bulan': 3, 'gender': 'm'},
  {'id': 52, 'usia': 22, 'bulan': 4, 'gender': 'f'},
  {'id': 53, 'usia': 22, 'bulan': 5, 'gender': 'm'},
  {'id': 54, 'usia': 22, 'bulan': 6, 'gender': 'f'},
  {'id': 55, 'usia': 22, 'bulan': 7, 'gender': 'f'},
  {'id': 56, 'usia': 22, 'bulan': 8, 'gender': 'm'},
  {'id': 57, 'usia': 22, 'bulan': 9, 'gender': 'f'},
  {'id': 58, 'usia': 22, 'bulan': 10, 'gender': 'f'},
  {'id': 59, 'usia': 22, 'bulan': 11, 'gender': 'f'},
  {'id': 60, 'usia': 22, 'bulan': 12, 'gender': 'f'},
  {'id': 61, 'usia': 23, 'bulan': 1, 'gender': 'm'},
  {'id': 62, 'usia': 23, 'bulan': 2, 'gender': 'm'},
  {'id': 63, 'usia': 23, 'bulan': 3, 'gender': 'f'},
  {'id': 64, 'usia': 23, 'bulan': 4, 'gender': 'm'},
  {'id': 65, 'usia': 23, 'bulan': 5, 'gender': 'm'},
  {'id': 66, 'usia': 23, 'bulan': 6, 'gender': 'f'},
  {'id': 67, 'usia': 23, 'bulan': 7, 'gender': 'm'},
  {'id': 68, 'usia': 23, 'bulan': 8, 'gender': 'f'},
  {'id': 69, 'usia': 23, 'bulan': 9, 'gender': 'm'},
  {'id': 70, 'usia': 23, 'bulan': 10, 'gender': 'm'},
  {'id': 71, 'usia': 23, 'bulan': 11, 'gender': 'm'},
  {'id': 72, 'usia': 23, 'bulan': 12, 'gender': 'f'},
  {'id': 73, 'usia': 24, 'bulan': 1, 'gender': 'm'},
  {'id': 74, 'usia': 24, 'bulan': 2, 'gender': 'f'},
  {'id': 75, 'usia': 24, 'bulan': 3, 'gender': 'm'},
  {'id': 76, 'usia': 24, 'bulan': 4, 'gender': 'm'},
  {'id': 77, 'usia': 24, 'bulan': 5, 'gender': 'f'},
  {'id': 78, 'usia': 24, 'bulan': 6, 'gender': 'm'},
  {'id': 79, 'usia': 24, 'bulan': 7, 'gender': 'm'},
  {'id': 80, 'usia': 24, 'bulan': 8, 'gender': 'f'},
  {'id': 81, 'usia': 24, 'bulan': 9, 'gender': 'f'},
  {'id': 82, 'usia': 24, 'bulan': 10, 'gender': 'f'},
  {'id': 83, 'usia': 24, 'bulan': 11, 'gender': 'f'},
  {'id': 84, 'usia': 24, 'bulan': 12, 'gender': 'f'},
  {'id': 85, 'usia': 25, 'bulan': 1, 'gender': 'f'},
  {'id': 86, 'usia': 25, 'bulan': 2, 'gender': 'm'},
  {'id': 87, 'usia': 25, 'bulan': 3, 'gender': 'm'},
  {'id': 88, 'usia': 25, 'bulan': 4, 'gender': 'f'},
  {'id': 89, 'usia': 25, 'bulan': 5, 'gender': 'f'},
  {'id': 90, 'usia': 25, 'bulan': 6, 'gender': 'm'},
  {'id': 91, 'usia': 25, 'bulan': 7, 'gender': 'f'},
  {'id': 92, 'usia': 25, 'bulan': 8, 'gender': 'm'},
  {'id': 93, 'usia': 25, 'bulan': 9, 'gender': 'm'},
  {'id': 94, 'usia': 25, 'bulan': 10, 'gender': 'm'},
  {'id': 95, 'usia': 25, 'bulan': 11, 'gender': 'm'},
  {'id': 96, 'usia': 25, 'bulan': 12, 'gender': 'm'},
  {'id': 97, 'usia': 26, 'bulan': 1, 'gender': 'm'},
  {'id': 98, 'usia': 26, 'bulan': 2, 'gender': 'f'},
  {'id': 99, 'usia': 26, 'bulan': 3, 'gender': 'm'},
  {'id': 100, 'usia': 26, 'bulan': 4, 'gender': 'f'},
  {'id': 101, 'usia': 26, 'bulan': 5, 'gender': 'f'},
  {'id': 102, 'usia': 26, 'bulan': 6, 'gender': 'm'},
  {'id': 103, 'usia': 26, 'bulan': 7, 'gender': 'f'},
  {'id': 104, 'usia': 26, 'bulan': 8, 'gender': 'm'},
  {'id': 105, 'usia': 26, 'bulan': 9, 'gender': 'f'},
  {'id': 106, 'usia': 26, 'bulan': 10, 'gender': 'f'},
  {'id': 107, 'usia': 26, 'bulan': 11, 'gender': 'f'},
  {'id': 108, 'usia': 26, 'bulan': 12, 'gender': 'f'},
  {'id': 109, 'usia': 27, 'bulan': 1, 'gender': 'f'},
  {'id': 110, 'usia': 27, 'bulan': 2, 'gender': 'm'},
  {'id': 111, 'usia': 27, 'bulan': 3, 'gender': 'f'},
  {'id': 112, 'usia': 27, 'bulan': 4, 'gender': 'm'},
  {'id': 113, 'usia': 27, 'bulan': 5, 'gender': 'f'},
  {'id': 114, 'usia': 27, 'bulan': 6, 'gender': 'f'},
  {'id': 115, 'usia': 27, 'bulan': 7, 'gender': 'm'},
  {'id': 116, 'usia': 27, 'bulan': 8, 'gender': 'm'},
  {'id': 117, 'usia': 27, 'bulan': 9, 'gender': 'm'},
  {'id': 118, 'usia': 27, 'bulan': 10, 'gender': 'm'},
  {'id': 119, 'usia': 27, 'bulan': 11, 'gender': 'f'},
  {'id': 120, 'usia': 27, 'bulan': 12, 'gender': 'm'},
  {'id': 121, 'usia': 28, 'bulan': 1, 'gender': 'm'},
  {'id': 122, 'usia': 28, 'bulan': 2, 'gender': 'f'},
  {'id': 123, 'usia': 28, 'bulan': 3, 'gender': 'm'},
  {'id': 124, 'usia': 28, 'bulan': 4, 'gender': 'f'},
  {'id': 125, 'usia': 28, 'bulan': 5, 'gender': 'f'},
  {'id': 126, 'usia': 28, 'bulan': 6, 'gender': 'f'},
  {'id': 127, 'usia': 28, 'bulan': 7, 'gender': 'm'},
  {'id': 128, 'usia': 28, 'bulan': 8, 'gender': 'm'},
  {'id': 129, 'usia': 28, 'bulan': 9, 'gender': 'm'},
  {'id': 130, 'usia': 28, 'bulan': 10, 'gender': 'm'},
  {'id': 131, 'usia': 28, 'bulan': 11, 'gender': 'f'},
  {'id': 132, 'usia': 28, 'bulan': 12, 'gender': 'f'},
  {'id': 133, 'usia': 29, 'bulan': 1, 'gender': 'f'},
  {'id': 134, 'usia': 29, 'bulan': 2, 'gender': 'm'},
  {'id': 135, 'usia': 29, 'bulan': 3, 'gender': 'f'},
  {'id': 136, 'usia': 29, 'bulan': 4, 'gender': 'f'},
  {'id': 137, 'usia': 29, 'bulan': 5, 'gender': 'm'},
  {'id': 138, 'usia': 29, 'bulan': 6, 'gender': 'm'},
  {'id': 139, 'usia': 29, 'bulan': 7, 'gender': 'm'},
  {'id': 140, 'usia': 29, 'bulan': 8, 'gender': 'm'},
  {'id': 141, 'usia': 29, 'bulan': 9, 'gender': 'm'},
  {'id': 142, 'usia': 29, 'bulan': 10, 'gender': 'f'},
  {'id': 143, 'usia': 29, 'bulan': 11, 'gender': 'f'},
  {'id': 144, 'usia': 29, 'bulan': 12, 'gender': 'f'},
  {'id': 145, 'usia': 30, 'bulan': 1, 'gender': 'm'},
  {'id': 146, 'usia': 30, 'bulan': 2, 'gender': 'f'},
  {'id': 147, 'usia': 30, 'bulan': 3, 'gender': 'f'},
  {'id': 148, 'usia': 30, 'bulan': 4, 'gender': 'f'},
  {'id': 149, 'usia': 30, 'bulan': 5, 'gender': 'f'},
  {'id': 150, 'usia': 30, 'bulan': 6, 'gender': 'f'},
  {'id': 151, 'usia': 30, 'bulan': 7, 'gender': 'f'},
  {'id': 152, 'usia': 30, 'bulan': 8, 'gender': 'f'},
  {'id': 153, 'usia': 30, 'bulan': 9, 'gender': 'f'},
  {'id': 154, 'usia': 30, 'bulan': 10, 'gender': 'f'},
  {'id': 155, 'usia': 30, 'bulan': 11, 'gender': 'm'},
  {'id': 156, 'usia': 30, 'bulan': 12, 'gender': 'm'},
  {'id': 157, 'usia': 31, 'bulan': 1, 'gender': 'm'},
  {'id': 158, 'usia': 31, 'bulan': 2, 'gender': 'f'},
  {'id': 159, 'usia': 31, 'bulan': 3, 'gender': 'm'},
  {'id': 160, 'usia': 31, 'bulan': 4, 'gender': 'f'},
  {'id': 161, 'usia': 31, 'bulan': 5, 'gender': 'f'},
  {'id': 162, 'usia': 31, 'bulan': 6, 'gender': 'f'},
  {'id': 163, 'usia': 31, 'bulan': 7, 'gender': 'f'},
  {'id': 164, 'usia': 31, 'bulan': 8, 'gender': 'f'},
  {'id': 165, 'usia': 31, 'bulan': 9, 'gender': 'f'},
  {'id': 166, 'usia': 31, 'bulan': 10, 'gender': 'f'},
  {'id': 167, 'usia': 31, 'bulan': 11, 'gender': 'f'},
  {'id': 168, 'usia': 31, 'bulan': 12, 'gender': 'm'},
  {'id': 169, 'usia': 32, 'bulan': 1, 'gender': 'm'},
  {'id': 170, 'usia': 32, 'bulan': 2, 'gender': 'f'},
  {'id': 171, 'usia': 32, 'bulan': 3, 'gender': 'm'},
  {'id': 172, 'usia': 32, 'bulan': 4, 'gender': 'f'},
  {'id': 173, 'usia': 32, 'bulan': 5, 'gender': 'f'},
  {'id': 174, 'usia': 32, 'bulan': 6, 'gender': 'f'},
  {'id': 175, 'usia': 32, 'bulan': 7, 'gender': 'f'},
  {'id': 176, 'usia': 32, 'bulan': 8, 'gender': 'f'},
  {'id': 177, 'usia': 32, 'bulan': 9, 'gender': 'f'},
  {'id': 178, 'usia': 32, 'bulan': 10, 'gender': 'f'},
  {'id': 179, 'usia': 32, 'bulan': 11, 'gender': 'f'},
  {'id': 180, 'usia': 32, 'bulan': 12, 'gender': 'm'},
  {'id': 181, 'usia': 33, 'bulan': 1, 'gender': 'f'},
  {'id': 182, 'usia': 33, 'bulan': 2, 'gender': 'm'},
  {'id': 183, 'usia': 33, 'bulan': 3, 'gender': 'f'},
  {'id': 184, 'usia': 33, 'bulan': 4, 'gender': 'm'},
  {'id': 185, 'usia': 33, 'bulan': 5, 'gender': 'f'},
  {'id': 186, 'usia': 33, 'bulan': 6, 'gender': 'f'},
  {'id': 187, 'usia': 33, 'bulan': 7, 'gender': 'f'},
  {'id': 188, 'usia': 33, 'bulan': 8, 'gender': 'm'},
  {'id': 189, 'usia': 33, 'bulan': 9, 'gender': 'f'},
  {'id': 190, 'usia': 33, 'bulan': 10, 'gender': 'f'},
  {'id': 191, 'usia': 33, 'bulan': 11, 'gender': 'f'},
  {'id': 192, 'usia': 33, 'bulan': 12, 'gender': 'm'},
  {'id': 193, 'usia': 34, 'bulan': 1, 'gender': 'm'},
  {'id': 194, 'usia': 34, 'bulan': 2, 'gender': 'f'},
  {'id': 195, 'usia': 34, 'bulan': 3, 'gender': 'm'},
  {'id': 196, 'usia': 34, 'bulan': 4, 'gender': 'f'},
  {'id': 197, 'usia': 34, 'bulan': 5, 'gender': 'f'},
  {'id': 198, 'usia': 34, 'bulan': 6, 'gender': 'f'},
  {'id': 199, 'usia': 34, 'bulan': 7, 'gender': 'f'},
  {'id': 200, 'usia': 34, 'bulan': 8, 'gender': 'f'},
  {'id': 201, 'usia': 34, 'bulan': 9, 'gender': 'f'},
  {'id': 202, 'usia': 34, 'bulan': 10, 'gender': 'f'},
  {'id': 203, 'usia': 34, 'bulan': 11, 'gender': 'm'},
  {'id': 204, 'usia': 34, 'bulan': 12, 'gender': 'm'},
  {'id': 205, 'usia': 35, 'bulan': 1, 'gender': 'm'},
  {'id': 206, 'usia': 35, 'bulan': 2, 'gender': 'm'},
  {'id': 207, 'usia': 35, 'bulan': 3, 'gender': 'f'},
  {'id': 208, 'usia': 35, 'bulan': 4, 'gender': 'm'},
  {'id': 209, 'usia': 35, 'bulan': 5, 'gender': 'f'},
  {'id': 210, 'usia': 35, 'bulan': 6, 'gender': 'f'},
  {'id': 211, 'usia': 35, 'bulan': 7, 'gender': 'f'},
  {'id': 212, 'usia': 35, 'bulan': 8, 'gender': 'm'},
  {'id': 213, 'usia': 35, 'bulan': 9, 'gender': 'f'},
  {'id': 214, 'usia': 35, 'bulan': 10, 'gender': 'f'},
  {'id': 215, 'usia': 35, 'bulan': 11, 'gender': 'm'},
  {'id': 216, 'usia': 35, 'bulan': 12, 'gender': 'm'},
  {'id': 217, 'usia': 36, 'bulan': 1, 'gender': 'f'},
  {'id': 218, 'usia': 36, 'bulan': 2, 'gender': 'm'},
  {'id': 219, 'usia': 36, 'bulan': 3, 'gender': 'm'},
  {'id': 220, 'usia': 36, 'bulan': 4, 'gender': 'f'},
  {'id': 221, 'usia': 36, 'bulan': 5, 'gender': 'm'},
  {'id': 222, 'usia': 36, 'bulan': 6, 'gender': 'f'},
  {'id': 223, 'usia': 36, 'bulan': 7, 'gender': 'f'},
  {'id': 224, 'usia': 36, 'bulan': 8, 'gender': 'f'},
  {'id': 225, 'usia': 36, 'bulan': 9, 'gender': 'm'},
  {'id': 226, 'usia': 36, 'bulan': 10, 'gender': 'm'},
  {'id': 227, 'usia': 36, 'bulan': 11, 'gender': 'm'},
  {'id': 228, 'usia': 36, 'bulan': 12, 'gender': 'm'},
  {'id': 229, 'usia': 37, 'bulan': 1, 'gender': 'm'},
  {'id': 230, 'usia': 37, 'bulan': 2, 'gender': 'f'},
  {'id': 231, 'usia': 37, 'bulan': 3, 'gender': 'm'},
  {'id': 232, 'usia': 37, 'bulan': 4, 'gender': 'm'},
  {'id': 233, 'usia': 37, 'bulan': 5, 'gender': 'f'},
  {'id': 234, 'usia': 37, 'bulan': 6, 'gender': 'm'},
  {'id': 235, 'usia': 37, 'bulan': 7, 'gender': 'f'},
  {'id': 236, 'usia': 37, 'bulan': 8, 'gender': 'm'},
  {'id': 237, 'usia': 37, 'bulan': 9, 'gender': 'f'},
  {'id': 238, 'usia': 37, 'bulan': 10, 'gender': 'm'},
  {'id': 239, 'usia': 37, 'bulan': 11, 'gender': 'f'},
  {'id': 240, 'usia': 37, 'bulan': 12, 'gender': 'm'},
  {'id': 241, 'usia': 38, 'bulan': 1, 'gender': 'f'},
  {'id': 242, 'usia': 38, 'bulan': 2, 'gender': 'm'},
  {'id': 243, 'usia': 38, 'bulan': 3, 'gender': 'f'},
  {'id': 244, 'usia': 38, 'bulan': 4, 'gender': 'm'},
  {'id': 245, 'usia': 38, 'bulan': 5, 'gender': 'm'},
  {'id': 246, 'usia': 38, 'bulan': 6, 'gender': 'f'},
  {'id': 247, 'usia': 38, 'bulan': 7, 'gender': 'm'},
  {'id': 248, 'usia': 38, 'bulan': 8, 'gender': 'f'},
  {'id': 249, 'usia': 38, 'bulan': 9, 'gender': 'm'},
  {'id': 250, 'usia': 38, 'bulan': 10, 'gender': 'f'},
  {'id': 251, 'usia': 38, 'bulan': 11, 'gender': 'm'},
  {'id': 252, 'usia': 38, 'bulan': 12, 'gender': 'f'},
  {'id': 253, 'usia': 39, 'bulan': 1, 'gender': 'm'},
  {'id': 254, 'usia': 39, 'bulan': 2, 'gender': 'f'},
  {'id': 255, 'usia': 39, 'bulan': 3, 'gender': 'm'},
  {'id': 256, 'usia': 39, 'bulan': 4, 'gender': 'm'},
  {'id': 257, 'usia': 39, 'bulan': 5, 'gender': 'm'},
  {'id': 258, 'usia': 39, 'bulan': 6, 'gender': 'f'},
  {'id': 259, 'usia': 39, 'bulan': 7, 'gender': 'f'},
  {'id': 260, 'usia': 39, 'bulan': 8, 'gender': 'm'},
  {'id': 261, 'usia': 39, 'bulan': 9, 'gender': 'f'},
  {'id': 262, 'usia': 39, 'bulan': 10, 'gender': 'm'},
  {'id': 263, 'usia': 39, 'bulan': 11, 'gender': 'f'},
  {'id': 264, 'usia': 39, 'bulan': 12, 'gender': 'f'},
  {'id': 265, 'usia': 40, 'bulan': 1, 'gender': 'f'},
  {'id': 266, 'usia': 40, 'bulan': 2, 'gender': 'm'},
  {'id': 267, 'usia': 40, 'bulan': 3, 'gender': 'f'},
  {'id': 268, 'usia': 40, 'bulan': 4, 'gender': 'm'},
  {'id': 269, 'usia': 40, 'bulan': 5, 'gender': 'f'},
  {'id': 270, 'usia': 40, 'bulan': 6, 'gender': 'm'},
  {'id': 271, 'usia': 40, 'bulan': 7, 'gender': 'm'},
  {'id': 272, 'usia': 40, 'bulan': 8, 'gender': 'f'},
  {'id': 273, 'usia': 40, 'bulan': 9, 'gender': 'm'},
  {'id': 274, 'usia': 40, 'bulan': 10, 'gender': 'f'},
  {'id': 275, 'usia': 40, 'bulan': 11, 'gender': 'm'},
  {'id': 276, 'usia': 40, 'bulan': 12, 'gender': 'f'},
  {'id': 277, 'usia': 41, 'bulan': 1, 'gender': 'm'},
  {'id': 278, 'usia': 41, 'bulan': 2, 'gender': 'f'},
  {'id': 279, 'usia': 41, 'bulan': 3, 'gender': 'm'},
  {'id': 280, 'usia': 41, 'bulan': 4, 'gender': 'f'},
  {'id': 281, 'usia': 41, 'bulan': 5, 'gender': 'm'},
  {'id': 282, 'usia': 41, 'bulan': 6, 'gender': 'f'},
  {'id': 283, 'usia': 41, 'bulan': 7, 'gender': 'm'},
  {'id': 284, 'usia': 41, 'bulan': 8, 'gender': 'm'},
  {'id': 285, 'usia': 41, 'bulan': 9, 'gender': 'f'},
  {'id': 286, 'usia': 41, 'bulan': 10, 'gender': 'm'},
  {'id': 287, 'usia': 41, 'bulan': 11, 'gender': 'f'},
  {'id': 288, 'usia': 41, 'bulan': 12, 'gender': 'm'},
  {'id': 289, 'usia': 42, 'bulan': 1, 'gender': 'f'},
  {'id': 290, 'usia': 42, 'bulan': 2, 'gender': 'm'},
  {'id': 291, 'usia': 42, 'bulan': 3, 'gender': 'f'},
  {'id': 292, 'usia': 42, 'bulan': 4, 'gender': 'm'},
  {'id': 293, 'usia': 42, 'bulan': 5, 'gender': 'f'},
  {'id': 294, 'usia': 42, 'bulan': 6, 'gender': 'm'},
  {'id': 295, 'usia': 42, 'bulan': 7, 'gender': 'f'},
  {'id': 296, 'usia': 42, 'bulan': 8, 'gender': 'm'},
  {'id': 297, 'usia': 42, 'bulan': 9, 'gender': 'm'},
  {'id': 298, 'usia': 42, 'bulan': 10, 'gender': 'f'},
  {'id': 299, 'usia': 42, 'bulan': 11, 'gender': 'm'},
  {'id': 300, 'usia': 42, 'bulan': 12, 'gender': 'f'},
  {'id': 301, 'usia': 43, 'bulan': 1, 'gender': 'm'},
  {'id': 302, 'usia': 43, 'bulan': 2, 'gender': 'f'},
  {'id': 303, 'usia': 43, 'bulan': 3, 'gender': 'm'},
  {'id': 304, 'usia': 43, 'bulan': 4, 'gender': 'f'},
  {'id': 305, 'usia': 43, 'bulan': 5, 'gender': 'm'},
  {'id': 306, 'usia': 43, 'bulan': 6, 'gender': 'f'},
  {'id': 307, 'usia': 43, 'bulan': 7, 'gender': 'm'},
  {'id': 308, 'usia': 43, 'bulan': 8, 'gender': 'f'},
  {'id': 309, 'usia': 43, 'bulan': 9, 'gender': 'm'},
  {'id': 310, 'usia': 43, 'bulan': 10, 'gender': 'm'},
  {'id': 311, 'usia': 43, 'bulan': 11, 'gender': 'm'},
  {'id': 312, 'usia': 43, 'bulan': 12, 'gender': 'm'},
  {'id': 313, 'usia': 44, 'bulan': 1, 'gender': 'm'},
  {'id': 314, 'usia': 44, 'bulan': 2, 'gender': 'm'},
  {'id': 315, 'usia': 44, 'bulan': 3, 'gender': 'f'},
  {'id': 316, 'usia': 44, 'bulan': 4, 'gender': 'm'},
  {'id': 317, 'usia': 44, 'bulan': 5, 'gender': 'm'},
  {'id': 318, 'usia': 44, 'bulan': 6, 'gender': 'm'},
  {'id': 319, 'usia': 44, 'bulan': 7, 'gender': 'f'},
  {'id': 320, 'usia': 44, 'bulan': 8, 'gender': 'm'},
  {'id': 321, 'usia': 44, 'bulan': 9, 'gender': 'f'},
  {'id': 322, 'usia': 44, 'bulan': 10, 'gender': 'm'},
  {'id': 323, 'usia': 44, 'bulan': 11, 'gender': 'f'},
  {'id': 324, 'usia': 44, 'bulan': 12, 'gender': 'f'},
  {'id': 325, 'usia': 45, 'bulan': 1, 'gender': 'f'},
  {'id': 326, 'usia': 45, 'bulan': 2, 'gender': 'm'},
  {'id': 327, 'usia': 45, 'bulan': 3, 'gender': 'm'},
  {'id': 328, 'usia': 45, 'bulan': 4, 'gender': 'f'},
  {'id': 329, 'usia': 45, 'bulan': 5, 'gender': 'f'},
  {'id': 330, 'usia': 45, 'bulan': 6, 'gender': 'f'},
  {'id': 331, 'usia': 45, 'bulan': 7, 'gender': 'm'},
  {'id': 332, 'usia': 45, 'bulan': 8, 'gender': 'f'},
  {'id': 333, 'usia': 45, 'bulan': 9, 'gender': 'm'},
  {'id': 334, 'usia': 45, 'bulan': 10, 'gender': 'f'},
  {'id': 335, 'usia': 45, 'bulan': 11, 'gender': 'm'},
  {'id': 336, 'usia': 45, 'bulan': 12, 'gender': 'm'},
];

List<Map<String, dynamic>> initialTbMasterKehamilan = [
  {"id": "1", "minggu_kehamilan": "1", "berat_janin": null, "tinggi_badan_janin": null, "ukuran_bayi_id": null, "ukuran_bayi_en": null, "poin_utama_id": null, "poin_utama_en": null, "perkembangan_bayi_id": null, "perkembangan_bayi_en": null, "perubahan_tubuh_id": null, "perubahan_tubuh_en": null, "gejala_umum_id": null, "gejala_umum_en": null, "tips_mingguan_id": null, "tips_mingguan_en": null, "bayi_img_path": "week_1.jpg", "ukuran_bayi_img_path": null},
  {"id": "2", "minggu_kehamilan": "2", "berat_janin": null, "tinggi_badan_janin": null, "ukuran_bayi_id": null, "ukuran_bayi_en": null, "poin_utama_id": null, "poin_utama_en": null, "perkembangan_bayi_id": null, "perkembangan_bayi_en": null, "perubahan_tubuh_id": null, "perubahan_tubuh_en": null, "gejala_umum_id": null, "gejala_umum_en": null, "tips_mingguan_id": null, "tips_mingguan_en": null, "bayi_img_path": "week_2.jpg", "ukuran_bayi_img_path": null},
  {
    "id": "3",
    "minggu_kehamilan": "3",
    "berat_janin": null,
    "tinggi_badan_janin": null,
    "ukuran_bayi_id": null,
    "ukuran_bayi_en": null,
    "poin_utama_id": """<h2>Highlight pada Kehamilan Minggu Pertama, Kedua, dan Ketiga</h2>
<p>Sebelum membahas lebih jauh, berikut beberapa poin penting yang bisa diantisipasi selama minggu-minggu awal kehamilan:</p>
<ul>
    <li><strong>Memantau gejala pada minggu-minggu awal.</strong> Mungkin kamu penasaran apakah mungkin merasakan kehamilan dalam beberapa hari pertama atau selama minggu-minggu awal. Sekitar minggu ketiga, mungkin kamu akan memperhatikan gejala seperti perdarahan ringan, bercak, kram, atau kembung saat sel telur menempel pada rahim.</li>
    <li><strong>Menghitung tanggal jatuh tempo.</strong> Penyedia layanan kesehatan umumnya mengukur kehamilan sebagai 40 minggu dari hari pertama haid terakhir. Oleh karena itu, kehamilan sebenarnya dimulai dengan pembuahan dan konsepsi, yang terjadi antara minggu kedua dan ketiga.</li>
    <li><strong>Mengadopsi kebiasaan sehat sejak dini.</strong> Sangat bermanfaat untuk memulai gaya hidup sehat sedini mungkin selama kehamilan untuk mendukung perkembangan bayi. Penyedia layanan kesehatan mungkin memberikan saran khusus, tetapi biasanya ini termasuk mengonsumsi vitamin tertentu, makanan bergizi, dan olahraga teratur dalam rutinitas.</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 1, 2, and 3 Weeks Pregnant</h2>
<p>Before diving into the specifics, here are some key points to anticipate during the early weeks of pregnancy:</p>
<ul>
    <li><strong>Monitoring symptoms in the initial weeks.</strong> You might be curious if it's possible to feel pregnant within the first few days or during the initial weeks. Around the third week, you may notice symptoms such as light bleeding, spotting, cramps, or bloating when the egg implants into your uterus.</li>
    <li><strong>Calculating your due date.</strong> Healthcare providers generally measure pregnancy as 40 weeks from the first day of your last menstrual period. Therefore, actual pregnancy starts with fertilization and conception, which occur between the second and third week.</li>
    <li><strong>Adopting healthy habits early.</strong> It's beneficial to start a healthy lifestyle as early as possible during pregnancy to support your baby's development. Your healthcare provider may offer specific advice, but typically this includes incorporating certain vitamins, nutritious foods, and regular exercise into your routine.</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>Tiga Minggu Pertama Kehamilan Kamu</h2>
<p>Mungkin menarik, sebenarnya kamu tidak benar-benar hamil selama dua minggu pertama atau lebih. Kehamilan dihitung sebagai 280 hari, atau 40 minggu, dimulai dari hari pertama haid terakhir kamu (metode LMP).</p>
<p>Pada usia kehamilan 1 minggu, kamu sedang mengalami menstruasi. Pada usia kehamilan 2 minggu, kamu kemungkinan sedang ovulasi. Karena ovulasi terjadi sekitar 14 hari setelah haid dimulai (dalam siklus 28 hari), pembuahan dan konsepsi terjadi sekitar minggu ketiga.</p>
<p>Meskipun mungkin terasa membingungkan, kamu sebenarnya tidak benar-benar hamil sampai minggu ketiga. Meskipun kamu mungkin tidak menyadari gejala kehamilan pada minggu ke-1, ke-2, atau ke-3, proses signifikan sedang terjadi di dalam tubuh.</p>""",
    "perkembangan_bayi_en": """<h2>Your First Three Weeks of Pregnancy</h2>
<p>Interestingly, you’re not actually pregnant during the first two weeks or so. Pregnancy is calculated as 280 days, or 40 weeks, starting from the first day of your last menstrual period (LMP method).</p>
<p>At 1 week pregnant, you are experiencing your period. At 2 weeks pregnant, you are likely ovulating. Since ovulation happens approximately 14 days after your period starts (in a 28-day cycle), fertilization and conception occur around the third week.</p>
<p>Although it may seem confusing, you are not truly pregnant until the third week. Even though you might not notice any pregnancy symptoms at 1, 2, or 3 weeks, significant processes are occurring internally.</p>""",
    "perubahan_tubuh_id": """<p>Meskipun kehamilan telah resmi dimulai, sebenarnya kamu tidak akan merasa hamil selama beberapa hari pertama atau mungkin bahkan beberapa minggu pertama karena cara kehamilan dihitung. Namun, perubahan signifikan mulai terjadi setelah minggu kedua:</p>
<ul>
    <li><strong>Pelepasan telur.</strong> Sebuah sel telur dilepaskan dari salah satu ovarium kamu sekitar 14 hari setelah haid terakhir dimulai.</li>
    <li><strong>Pembuahan.</strong> Sel telur bergerak turun ke saluran tuba dan mungkin bergabung dengan sperma, menghasilkan zigot. Proses ini juga menentukan jenis kelamin bayi.</li>
    <li><strong>Penyusunan DNA pertama.</strong> Zigot mengandung kromosom dari sel telur dan sperma, membentuk cetakan genetik awal untuk bayi kamu.</li>
    <li><strong>Perkembangan.</strong> Zigot bergerak turun ke saluran tuba menuju rahim, membelah menjadi lebih banyak sel saat bayi kamu mulai berkembang.</li>
</ul>""",
    "perubahan_tubuh_en": """<p>Although pregnancy has officially begun, you won’t actually feel pregnant during the first few days or possibly even the first few weeks due to the way pregnancy is calculated. However, significant changes start happening after the second week:</p>
<ul>
    <li><strong>Egg release.</strong> An egg is released from one of your ovaries around 14 days after your last period starts.</li>
    <li><strong>Fertilization.</strong> The egg travels down a fallopian tube and may unite with sperm, resulting in a zygote. This process also determines the baby's sex.</li>
    <li><strong>First DNA.</strong> The zygote contains chromosomes from both the egg and sperm, forming the initial genetic blueprint for your baby.</li>
    <li><strong>Development.</strong> The zygote moves down the fallopian tube to the uterus, dividing into more cells as your baby starts developing.</li>
</ul>""",
    "gejala_umum_id": """<h2>Tanda-tanda Awal Kehamilan yang Umum</h2>
<p>Pada tiga minggu pertama, kamu mungkin tidak curiga bahwa kamu hamil dan mungkin tidak akan memperhatikan gejala apa pun, karena masih terlalu awal (pembuahan mungkin bahkan belum terjadi hingga minggu ketiga). Namun, dalam beberapa minggu berikutnya, kamu mungkin mengalami:</p>
<ul>
    <li><strong>Menstruasi terlambat.</strong> Seringkali merupakan indikasi pertama kehamilan, tetapi ini tidak akan terjadi sampai kamu hamil sekitar 4 minggu.</li>
    <li><strong>Perdarahan implantasi.</strong> Bercak ringan atau perdarahan ketika sel telur yang dibuahi menempel pada lapisan rahim, biasanya terjadi 10 hingga 14 hari setelah pembuahan.</li>
    <li><strong>Mual di pagi hari.</strong> Biasanya dimulai antara minggu ke-4 dan ke-9.</li>
    <li><strong>Gejala lainnya.</strong> Gas, kelelahan, nyeri payudara, perubahan suasana hati, dan sering buang air kecil juga dapat terjadi pada awal kehamilan.</li>
</ul>""",
    "gejala_umum_en": """<h2>Typical Early Signs of Pregnancy</h2>
<p>In the first three weeks, you might not suspect you're pregnant and probably won’t notice any symptoms, as it's still early (conception might not even have happened until the third week). However, in the following weeks, you might experience:</p>
<ul>
    <li><strong>Missed period.</strong> Often the first indication of pregnancy, but it won't occur until you're about 4 weeks pregnant.</li>
    <li><strong>Implantation bleeding.</strong> Light spotting or bleeding when the fertilized egg attaches to the uterine lining, typically 10 to 14 days after conception.</li>
    <li><strong>Morning sickness.</strong> Usually begins between weeks 4 and 9.</li>
    <li><strong>Other symptoms.</strong> Gas, fatigue, breast tenderness, moodiness, and frequent urination may also occur in early pregnancy.</li>
</ul>""",
    "tips_mingguan_id": """<h2>Apa Langkah Pencegahan yang Harus Kamu Ambil Selama Awal Kehamilan?</h2>
<p>Meskipun kamu belum mengalami gejala awal kehamilan pada minggu 1, 2, atau 3, penting untuk mengambil langkah-langkah untuk tetap sehat dan aman, terutama saat mencoba hamil atau setelah mengetahui kamu hamil.</p>

<h3>Penyesuaian Gaya Hidup</h3>
<p>Perubahan sederhana dapat mendukung kehamilan awal kamu. Meskipun berkonsultasi dengan penyedia layanan kesehatan adalah yang terbaik, pertimbangkan:</p>
<ul>
    <li>Mengonsumsi diet sehat</li>
    <li>Menjaga hidrasi tubuh</li>
    <li>Mengurangi stres</li>
    <li>Berolahraga secara teratur</li>
</ul>

<h3>Asam Folat</h3>
<p>Saat mencoba hamil atau setelah mengetahui kamu hamil, asam folat sangat penting karena membantu mengurangi risiko cacat lahir yang mempengaruhi otak dan tulang belakang bayi. Penyedia layanan kesehatan kamu mungkin merekomendasikan vitamin prenatal dengan setidaknya 400 mikrogram asam folat.</p>

<h3>Menghilangkan Kebiasaan Buruk</h3>
<p>Sebelum hamil adalah waktu yang tepat untuk berhenti dari kebiasaan tidak sehat, termasuk:</p>
<ul>
    <li>Merokok</li>
    <li>Paparan asap rokok</li>
    <li>Mengonsumsi alkohol</li>
</ul>
<p>Selain itu, penyedia layanan kesehatan kamu mungkin menyarankan untuk membatasi konsumsi kafein. Konsultasikan dengan penyedia layanan kesehatan kamu untuk cara terbaik menjaga kesehatan dan keselamatan selama kehamilan.</p>""",
    "tips_mingguan_en": """<h2>What Precautions Should You Take During Early Pregnancy?</h2>
<p>Even if you haven't experienced early pregnancy symptoms in weeks 1, 2, or 3, it's important to take steps to stay healthy and safe, especially when trying to conceive or upon learning you're pregnant.</p>

<h3>Lifestyle Adjustments</h3>
<p>Simple changes can support your early pregnancy. Though consulting your healthcare provider is best, consider:</p>
<ul>
    <li>Eating a healthy diet</li>
    <li>Staying hydrated</li>
    <li>Reducing stress</li>
    <li>Exercising regularly</li>
</ul>

<h3>Folic Acid</h3>
<p>When trying for a baby or upon learning you’re pregnant, folic acid is crucial as it helps reduce the risk of birth defects affecting the baby’s brain and spine. Your healthcare provider may recommend a prenatal vitamin with at least 400 micrograms of folic acid.</p>

<h3>Eliminating Bad Habits</h3>
<p>Pre-pregnancy is a great time to quit unhealthy habits, including:</p>
<ul>
    <li>Smoking</li>
    <li>Exposure to secondhand smoke</li>
    <li>Drinking alcohol</li>
</ul>
<p>Additionally, your provider might suggest limiting caffeine intake. Consult your healthcare provider for the best ways to maintain health and safety during pregnancy.</p>""",
    "bayi_img_path": "week_3.jpg",
    "ukuran_bayi_img_path": null
  },
  {
    "id": "4",
    "minggu_kehamilan": "4",
    "berat_janin": null,
    "tinggi_badan_janin": 2,
    "ukuran_bayi_id": "Biji Poppy",
    "ukuran_bayi_en": "Poppy Seed",
    "poin_utama_id": """<h2>Highlights pada Minggu ke-4 Kehamilan</h2>
<p>Inilah yang perlu kamu ingat dan antisipasi selama minggu ke-4 kehamilan:</p>
<ul>
  <li>Kamu baru saja memulai perjalanan kehamilanmu, namun ada banyak hal yang terjadi! Sel telur yang telah dibuahi menempel pada rahimmu dan mulai membelah diri dengan cepat, membentuk dasar perkembangan bayimu, termasuk lengan, kaki, otak, otot, dan lainnya.</li>
  <li>Bayimu sangat kecil, sekitar seukuran biji opium dengan panjang 0,04 inci.</li>
  <li>Kamu mungkin tidak menyadari adanya gejala pada usia kehamilan 4 minggu, tetapi jika ada, gejala tersebut mungkin termasuk tanda umum seperti kembung, nyeri payudara, kelelahan, atau bercak—semuanya merupakan indikator menarik dari kehamilan!</li>
  <li>Siapkan dirimu untuk fokus pada dirimu sendiri dan bayimu yang sedang tumbuh dengan mengadopsi gaya hidup sehat. Ini bisa melibatkan meninggalkan kebiasaan tidak sehat dan mencari cara untuk mengurangi stres, misalnya melalui yoga atau meditasi.</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 4 Weeks Pregnant</h2>
<p>Here's what to keep in mind and anticipate during your fourth week of pregnancy:</p>
<ul>
  <li>You're just beginning your pregnancy journey, but there's a lot going on! The fertilized egg implants itself into your uterus and begins rapid cell division, laying the foundation for your baby's development, including arms, legs, brain, muscles, and more.</li>
  <li>Your baby is incredibly tiny, about the size of a poppy seed at 0.04 inches long.</li>
  <li>You might not notice any symptoms at 4 weeks pregnant, but if you do, they could include common signs like bloating, breast tenderness, fatigue, or spotting—all exciting indicators of pregnancy!</li>
  <li>Prepare to focus on yourself and your growing baby by adopting a healthy lifestyle. This could involve ditching any unhealthy habits and finding ways to reduce stress, such as through yoga or meditation.</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>Kehamilan 4 Minggu: Perkembangan Bayi Kamu</h2>
<p>Saat kamu menyesuaikan diri dengan kehamilan, bayimu sudah sibuk tumbuh di dalam rahimmu. Inilah yang sedang terjadi di dalam rahimmu pada usia kehamilan 4 minggu:</p>
<ul>
  <li><strong>Sel telur yang telah dibuahi menempel</strong> pada sisi rahimmu.</li>
  <li><strong>Sel telur membelah dengan cepat</strong> menjadi lapisan-lapisan sel, dengan beberapa membentuk embrio. Sel-sel ini akan berkembang menjadi berbagai bagian tubuh bayimu, termasuk sistem saraf, kerangka, otot, organ, dan kulit.</li>
  <li><strong>Plasenta mulai terbentuk,</strong> menghubungkan sistem tubuhmu dengan bayi dan melekat pada dinding rahim tempat sel telur menempel.</li>
  <li><strong>Tali pusar akhirnya akan muncul</strong> dari salah satu sisi plasenta. Selain itu, cairan amnion, yang akan memberikan bantalan sepanjang kehamilanmu, sudah mulai terbentuk di dalam sebuah selaput, atau kantung kuning telur.</li>
</ul>
<p>Pada minggu-minggu mendatang, bayimu akan mulai mengembangkan tabung saraf, membentuk dasar untuk otak dan tulang belakang. Aktivitas pada usia kehamilan 4 minggu menyiapkan panggung untuk perkembangan penting ini.</p>""",
    "perkembangan_bayi_en": """<h2>4 Weeks Pregnant: Your Baby's Development</h2>
<p>As you adjust to pregnancy, your baby is already busy growing inside you. Here's what's happening in your uterus at 4 weeks pregnant:</p>
<ul>
  <li><strong>The fertilized egg implants</strong> itself into the side of your uterus.</li>
  <li><strong>The egg rapidly divides</strong> into layers of cells, with some forming the embryo. These cells will develop into various parts of your baby's body, including the nervous system, skeleton, muscles, organs, and skin.</li>
  <li><strong>The placenta begins to form,</strong> linking your body's systems with the baby's and attaching to the uterine wall where the egg implanted.</li>
  <li><strong>The umbilical cord will eventually emerge</strong> from one side of the placenta. Additionally, amniotic fluid, which will provide cushioning throughout your pregnancy, is already forming within a surrounding membrane, or yolk sac.</li>
</ul>
<p>In the weeks ahead, your baby will start developing a neural tube, laying the groundwork for the brain and spine. The activity at 4 weeks pregnant sets the stage for this crucial development.</p>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda pada Usia Kehamilan 4 Minggu</h2>
<p>Pada usia kehamilan 4 minggu, Anda mungkin mulai mengalami beberapa gejala kehamilan, meskipun wajar jika Anda belum memperhatikannya. Umumnya, gejala ringan pada tahap ini, sehingga Anda mungkin merasakan sedikit kram dan melihat bercak ringan, yang terjadi ketika sel telur yang telah dibuahi menanamkan diri di rahim Anda.</p>
<p>Seperti yang disebutkan sebelumnya, tubuh Anda mulai memproduksi hormon kehamilan hCG pada tahap ini. Hormon ini mengirim sinyal kepada ovarium Anda untuk menghentikan pelepasan telur bulanan, menghentikan siklus menstruasi Anda. Selain itu, hCG merangsang produksi estrogen dan progesteron, sehingga Anda mungkin mengalami gejala yang terkait dengan hormon-hormon ini.</p>""",
    "perubahan_tubuh_en": """<h2>Your Body at 4 Weeks Pregnant</h2>
<p>At 4 weeks pregnant, you might start experiencing a few pregnancy symptoms, though it’s normal if you haven’t noticed any yet. Typically, symptoms are mild during this stage, so you might feel some cramping and notice slight spotting, both of which occur as the fertilized egg implants in your uterus.</p>
<p>As mentioned earlier, your body begins producing the pregnancy hormone hCG at this stage. This hormone signals your ovaries to halt monthly egg release, stopping your menstrual cycle. Additionally, hCG stimulates the production of estrogen and progesterone, so you might experience symptoms related to these hormones.</p>""",
    "gejala_umum_id": """<h2>Gejala Kehamilan pada Usia 4 Minggu</h2>
<p>Setiap kehamilan itu unik, dan apa yang Anda alami selama kehamilan ini mungkin berbeda dengan kehamilan sebelumnya. Untuk membantu Anda merasa lebih siap menghadapi apa pun yang mungkin terjadi, pertimbangkan kemungkinan gejala kehamilan pada usia kehamilan empat minggu:</p>
<ul>
  <li><strong>Kembung:</strong> Tubuh Anda bersiap untuk menampung bayi yang berkembang pesat dalam beberapa bulan mendatang. Pada usia kehamilan 4 minggu, Anda mungkin mengalami sedikit kembung dan kram di perut karena lapisan rahim Anda menjadi lebih tebal, menyebabkan rahim Anda memakan lebih banyak ruang dari biasanya.</li>
  <li><strong>Pendarahan ringan atau bercak:</strong> Beberapa wanita mengalami bercak pada usia kehamilan 4 minggu, yang disebut pendarahan implantasi, yang seharusnya tidak seberat haid. Jika Anda melihat sejumlah besar darah, jika bercak tersebut berlangsung lebih dari dua hari, atau jika Anda memiliki kekhawatiran apa pun, konsultasikan dengan penyedia layanan kesehatan Anda segera.</li>
  <li><strong>Perubahan mood:</strong> Gejala lain yang mungkin Anda perhatikan pada usia kehamilan 4 minggu adalah perubahan mood. Dipicu oleh peningkatan kadar hormon, emosi ekstrem dan fluktuasi mungkin paling mencolok pada trimester pertama dan ketiga. Latihan relaksasi, pijat, tidur yang cukup, dan diet seimbang adalah beberapa cara sederhana untuk membantu mengelola perubahan mood.</li>
  <li><strong>Ketidaknyamanan pada payudara:</strong> Seperti halnya perut Anda, payudara Anda mulai mempersiapkan diri untuk tugas penting memberi makan bayi baru. Jumlah kelenjar susu meningkat, dan lapisan lemak juga mengental, menyebabkan payudara Anda membesar.</li>
  <li><strong>Mual di pagi hari:</a></strong> Apakah Anda mengalami mual di pagi hari pada usia kehamilan 4 minggu dapat bervariasi dari orang ke orang. Beberapa mungkin hanya mengalami mual ringan, sementara yang lain mungkin muntah. Sekitar 85 persen wanita hamil mengalami beberapa tingkat mual di pagi hari, yang sering membaik pada trimester kedua.</li>
  <li><strong>Bercak berwarna terang:</strong> Peningkatan keluarnya cairan vagina adalah gejala normal pada usia kehamilan 4 minggu. Itu harus lengket, jernih, atau putih. Jika Anda mencatat bau yang tidak sedap atau mengalami nyeri atau gatal di area vagina, konsultasikan dengan penyedia layanan kesehatan Anda.</li>
  <li><strong>Kelelahan:</strong> Jangan heran jika Anda merasa lelah bahkan pada usia kehamilan 4 minggu! Tubuh Anda bekerja tanpa henti untuk mendukung bayi Anda, dan peningkatan kadar progesteron dapat menyebabkan kelelahan.</li>
</ul>""",
    "gejala_umum_en": """<h2>4 Weeks Pregnant: Your Symptoms</h2>
<p>Every pregnancy is unique, and what you experience during this pregnancy may differ from previous ones. To help you feel more prepared for whatever may come, consider these potential symptoms of pregnancy at four weeks:</p>
<ul>
  <li><strong>Bloating:</strong> Your body is gearing up to accommodate a rapidly growing baby over the next few months. At 4 weeks pregnant, you may experience some bloating and cramping in your abdomen as your uterine lining thickens, causing your womb to take up more space than usual.</li>
  <li><strong>Light bleeding or spotting:</strong> Some women experience spotting at 4 weeks pregnant, known as implantation bleeding, which should not be as heavy as a period. If you see a significant amount of blood, if the spotting persists for more than two days, or if you have any concerns, consult your healthcare provider immediately.</li>
  <li><strong>Mood swings:</strong> Another symptom you may notice at 4 weeks pregnant is mood swings. Triggered by increasing hormone levels, these extreme emotions and fluctuations may be most pronounced in the first and third trimesters. Relaxation exercises, massage, adequate sleep, and a balanced diet are some simple ways to help manage mood swings.</li>
  <li><strong>Breast tenderness:</strong> Similar to your abdomen, your breasts are beginning to prepare for the important task of nourishing a new baby. The number of milk glands increases, and the fat layer thickens, causing your breasts to enlarge.</li>
  <li><strong>Morning sickness:</strong> Whether or not you experience morning sickness at 4 weeks pregnant can vary from person to person. Some may only experience mild nausea, while others may experience vomiting. Approximately 85 percent of pregnant women experience some level of morning sickness, which often improves in the second trimester.</li>
  <li><strong>Light-colored discharge:</strong> Increased vaginal discharge is a normal symptom at 4 weeks pregnant. It should be sticky, clear, or white. If you notice a foul odor or experience soreness or itching in the vaginal area, consult your healthcare provider.</li>
  <li><strong>Fatigue:</strong> Don't be surprised if you feel tired even at 4 weeks pregnant! Your body is working around the clock to support your baby, and rising progesterone levels can contribute to fatigue.</li>
</ul>""",
    "tips_mingguan_id": """<h2>4 Minggu Hamil: Hal yang Perlu Dipertimbangkan</h2>
<p>Meskipun masih awal dalam perjalanan kehamilan Anda, ada beberapa faktor penting yang perlu dipertimbangkan. Mulai dari menyesuaikan gaya hidup hingga mencatat pencapaian, berikut daftar yang perlu dipertimbangkan:</p>
<ul>
  <li><strong>Memulai rencana makan sehat </strong> jika belum melakukannya. Pastikan Anda memasukkan makanan kaya zat besi seperti bayam dan sereal untuk mencegah anemia, serta kalsium dari susu, keju, yogurt, tahu, atau jus jeruk untuk membantu perkembangan tulang bayi Anda.</li>
  <li><strong>Hentikan kebiasaan tidak sehat segera.</strong> Berhenti merokok dan gantikan alkohol dengan air dan minuman bergizi lainnya untuk mengurangi risiko kelahiran prematur dan cacat lahir lainnya. Penting juga untuk menjauhkan diri dari paparan asap rokok, karena penelitian menunjukkan bahwa hal itu dapat meningkatkan risiko komplikasi seperti berat badan lahir rendah, keguguran, dan kehamilan ektopik.</li>
  <li><strong>Berusaha untuk rileks dan menjaga tingkat stres tetap rendah.</strong> Anda dapat mencapainya melalui modifikasi gaya hidup, meditasi, dan aktivitas fisik. Kemungkinan besar, Anda dapat terus berolahraga selama kehamilan, asalkan tidak ada komplikasi. Jika Anda belum pernah berolahraga sebelumnya, konsultasikan dengan penyedia layanan kesehatan Anda tentang rencana latihan yang paling cocok untuk Anda. Persalinan dan kelahiran melibatkan usaha yang besar, dan semakin bugar Anda, semakin siap Anda menghadapinya.</li>
  <li><strong>Mulailah mengonsumsi vitamin prenatal</strong> setiap hari untuk meningkatkan kesehatan Anda dan memfasilitasi perkembangan kehidupan baru di dalam Anda! Cari vitamin yang mengandung setidaknya 400 mikrogram (mcg) asam folat, nutrisi penting yang terbukti dapat mengurangi risiko cacat lahir.</li>
  <li><strong>Lakukan penelitian jenis penyedia layanan kesehatan </strong> yang ingin Anda ajak bekerja sama selama kehamilan.</li>
  <li><strong>Mulailah mengabadikan kenangan,</strong> baik melalui album foto, jurnal kehamilan, atau catatan harian. Pertimbangkan untuk menyertakan gambar perut Anda yang semakin membesar dari minggu ke minggu, tanggal penting seperti saat Anda mengetahui kehamilan Anda, surat untuk anak Anda di masa depan, atau bahkan prediksi tentang warna mata dan rambut mereka.</li>
</ul>""",
    "tips_mingguan_en": """<h2>4 Weeks Pregnant: Considerations to Keep in Mind</h2>
<p>While it's still early in your pregnancy journey, there are several important factors to take into account. From adjusting your lifestyle to documenting milestones, here's a list to consider:</p>
<ul>
  <li><strong>Initiate a healthy eating plan if you haven't already.</strong> Ensure you're incorporating iron-rich foods like spinach and cereals to prevent anemia, as well as calcium from milk, cheese, yogurt, tofu, or orange juice to aid in your growing baby's bone development.</li>
  <li><strong>Discontinue unhealthy habits promptly.</strong> Cease smoking and substitute alcohol with water and other nourishing beverages to mitigate the risk of preterm birth and other birth defects. It's also crucial to steer clear of secondhand smoke exposure, as research indicates it can heighten the likelihood of complications such as low birth weight, miscarriage, and ectopic pregnancy.</li>
  <li><strong>Strive to unwind and maintain a low stress level.</strong> You can achieve this through lifestyle modifications, meditation, and physical activity. Most likely, you can continue exercising throughout pregnancy, provided there are no complications. If you haven't been physically active before, consult your healthcare provider about the most suitable exercise regimen for you. Labor and delivery entail considerable effort, and the fitter you are, the better equipped you'll be.</li>
  <li><strong>Commence taking prenatal vitamins</strong> daily to bolster your health and facilitate the development of the new life inside you! Seek out a vitamin containing at least 400 micrograms (mcg) of folic acid, a vital nutrient proven to diminish the risk of birth defects.</li>
  <li><strong>Research the type of healthcare provider</strong> you'd prefer to collaborate with during your pregnancy.</li>
  <li><strong>Commence capturing memories,</strong> whether through a photo album, pregnancy journal, or diary. Consider including images of your growing bump week by week, significant dates such as when you discovered your pregnancy, a letter to your future child, or even predictions about their eye and hair color.</li>
</ul>""",
    "bayi_img_path": "week_4.jpg",
    "ukuran_bayi_img_path": "week_4_poppy_seed.svg"
  },
  {
    "id": "5",
    "minggu_kehamilan": "5",
    "berat_janin": null,
    "tinggi_badan_janin": 2,
    "ukuran_bayi_id": "Biji Wijen",
    "ukuran_bayi_en": "Sesame Seed",
    "poin_utama_id": """<h2>Highlights pada Minggu ke-5 Kehamilan</h2>
<p>Lihat apa yang sedang terjadi dan apa yang harus dilakukan selama minggu kelima kehamilan Anda:</p>
<ul>
  <li>Minggu ini, tabung saraf terus berkembang, menuju menjadi tulang belakang dan otak bayi Anda. Plasenta dan tali pusar juga sedang berkembang untuk mengalirkan oksigen dan nutrisi ke bayi Anda.</li>
  <li>Meskipun begitu banyak yang terjadi, bayi Anda masih sangat kecil, hanya seukuran biji jeruk kecil atau sebutir nasi.</li>
  <li>Anda mungkin tidak memiliki gejala kehamilan pada usia kehamilan 5 minggu, tetapi kemungkinan besar Anda akan merasa lelah, melihat bercak, mengalami nyeri payudara, dan bahkan mual di pagi hari pada tahap ini.</li>
  <li>Pertimbangkan untuk mengadopsi beberapa perubahan gaya hidup pada tahap ini, seperti menjaga pola makan sehat, menghindari makanan tertentu, dan mengurangi stres.</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 5 Weeks Pregnant</h2>
<p>Find out what's happening and what you can do during your fifth week of pregnancy:</p>
<ul>
  <li>The neural tube continues to develop, forming your baby's spine and brain. The placenta and umbilical cord are also progressing to provide oxygen and nutrients to your baby.</li>
  <li>Despite these developments, your baby is still very small, about the size of a small orange seed or a grain of rice.</li>
  <li>You may or may not experience pregnancy symptoms at 5 weeks pregnant, but it's common to feel fatigue, notice spotting, experience breast tenderness, and possibly have morning sickness.</li>
  <li>Consider making some lifestyle changes at this stage, such as maintaining a healthy diet, avoiding certain foods, and finding ways to reduce stress.</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>Minggu ke-5 Kehamilan: Perkembangan Bayi Anda</h2>
<p>Ketika Anda 5 minggu hamil, perubahan penting sedang terjadi untuk mendukung perkembangan bayi Anda. Berikut adalah yang terjadi selama minggu kelima kehamilan Anda:</p>
<ul>
  <li><strong>Plasenta dan awal pembentukan tali pusar sedang terbentuk.</strong> Struktur ini mengangkut nutrisi penting (seperti kalsium, asam folat, dan vitamin lainnya) dan oksigen dari tubuh Anda ke embrio, memainkan peran penting dalam memastikan pertumbuhan yang sehat.</li>
  <li><strong>Tabung saraf terus berkembang.</strong> Pada akhirnya, itu akan berubah menjadi tulang belakang dan otak. Mengonsumsi setidaknya 400 mikrogram asam folat setiap hari sangat bermanfaat pada tahap ini, mendukung pertumbuhan sehat dan mengurangi risiko cacat tabung saraf.</li>
  <li><strong>Jantung bayi Anda mulai terbentuk</strong> dari apa yang saat ini hanya tonjolan di tengah embrio. Detak jantung itu sendiri mungkin dapat terdeteksi secepat minggu ke-6 kehamilan.</li>
</ul>""",
    "perkembangan_bayi_en": """<h2>5 Weeks Pregnant: Your Baby's Growth</h2>
<p>At 5 weeks pregnant, significant changes are occurring to facilitate your baby's development. Here's what's happening during this stage of your pregnancy:</p>
<ul>
  <li><strong>The placenta and the initial formation of the umbilical cord are underway.</strong> These structures transport vital nutrients (such as calcium, folic acid, and other vitamins) and oxygen from your body to the embryo, playing a crucial role in ensuring healthy growth.</li>
  <li><strong>The neural tube continues its development.</strong> Eventually, it will transform into the spinal column and the brain. Taking at least 400 micrograms of folic acid daily is highly beneficial at this stage, supporting your baby's healthy growth and reducing the risk of neural tube defects.</li>
  <li><strong>Your baby's heart is beginning to form</strong> from what is currently just a bulge in the center of the embryo. The heartbeat itself may be detectable as early as the sixth week of pregnancy.</li>
</ul>""",
    "perubahan_tubuh_id": null,
    "perubahan_tubuh_en": null,
    "gejala_umum_id": """<h2>Minggu ke-5 Kehamilan: Tanda dan Gejala</h2>
<p>Pada usia kehamilan 5 minggu, Anda mungkin mengalami berbagai gejala umum, meskipun beberapa mungkin datang dan pergi, atau Anda mungkin tidak mengalami gejala sama sekali! Setiap kehamilan berbeda, namun berikut adalah beberapa perubahan fisik dan emosional yang mungkin Anda alami:</p>
<ul>
  <li><strong>Mual dan muntah:</strong> Anda mungkin mengalami mual dan muntah, yang dapat terjadi kapan saja. Minum banyak cairan dan makan makanan kecil dan sering dapat membantu mengurangi ketidaknyamanan ini.</li>
  <li><strong>Pendarahan ringan atau bercak:</strong> Melihat sedikit pendarahan atau bercak tidak aneh pada tahap ini, tetapi jika Anda memiliki kekhawatiran, lebih baik berkonsultasi dengan penyedia layanan kesehatan Anda.</li>
  <li><strong>Nyeri pada payudara:</strong> Perubahan hormon dapat menyebabkan payudara Anda terasa nyeri saat mereka bersiap untuk menyusui.</li>
  <li><strong>Sering buang air kecil:</strong> Kebutuhan untuk buang air kecil lebih sering umum terjadi karena peningkatan volume cairan dalam tubuh Anda.</li>
  <li><strong>Jerawat:</strong> Fluktuasi hormon dapat menyebabkan jerawat yang terkait dengan kehamilan, yang seharusnya hilang setelah melahirkan.</li>
  <li><strong>Kembung dan kram:</strong> Merasa kembung, mengalami kram, atau nyeri ringan akibat gas adalah hal yang normal pada kehamilan 5 minggu.</li>
  <li><strong>Kelelahan:</strong> Peningkatan kadar progesteron dapat membuat Anda merasa sangat lelah, jadi penting untuk istirahat saat diperlukan.</li>
  <li><strong>Perubahan suasana hati:</strong> Fluktuasi emosi, mirip dengan gejala pra-menstruasi, umum terjadi selama kehamilan.</li>
  <li><strong>Gejala ringan atau tidak ada:</strong> Beberapa wanita mungkin tidak mengalami gejala sama sekali, yang merupakan hal yang normal. Konsultasikan dengan penyedia layanan kesehatan Anda jika Anda memiliki kekhawatiran.</li>
</ul>""",
    "gejala_umum_en": """<h2>5 Weeks Pregnant: Signs and Symptoms</h2>
<p>At 5 weeks pregnant, you might experience various common symptoms, though some may come and go, or you might have none at all! Every pregnancy is different, but here are some physical and emotional changes you might notice:</p>
<ul>
  <li><strong>Morning sickness:</strong> You might experience nausea and vomiting, which can occur at any time of day. Drinking plenty of fluids and opting for small, frequent meals can help ease this discomfort.</li>
  <li><strong>Light bleeding or spotting:</strong> Seeing some light bleeding or spotting is not unusual at this stage, but if you have concerns, it's best to consult your healthcare provider.</li>
  <li><strong>Breast tenderness:</strong> Hormonal changes may cause your breasts to feel sore as they prepare for breastfeeding.</li>
  <li><strong>Frequent urination:</strong> The need to pee more often is common due to increased fluid volume in your body.</li>
  <li><strong>Acne:</strong> Hormonal fluctuations may lead to pregnancy-related acne, which should clear up after childbirth.</li>
  <li><strong>Bloating and cramping:</strong> Feeling bloated, experiencing cramps, or slight gas pains are normal at 5 weeks pregnant.</li>
  <li><strong>Fatigue:</strong> Increased levels of progesterone can leave you feeling exhausted, so it's important to rest when needed.</li>
  <li><strong>Mood swings:</strong> Emotional fluctuations, similar to PMS, are common during pregnancy.</li>
  <li><strong>Mild or no symptoms:</strong> Some women may have no symptoms at all, which is normal. Consult your healthcare provider if you have concerns.</li>
</ul>""",
    "tips_mingguan_id": """<h2>Minggu ke-5 Kehamilan: Pertimbangan Penting</h2>
<p>Meskipun Anda baru saja memulai perjalanan kehamilan, ada beberapa aspek penting yang perlu dipertimbangkan. Mulai dari penyesuaian pola makan hingga berbagi kabar dengan orang-orang terdekat, jelajahi daftar berikut.</p>
<h3>Penyesuaian Gaya Hidup</h3>
<ul>
  <li><strong>Pantau pola makan Anda:</strong> Pastikan Anda mengonsumsi berbagai makanan bergizi sambil menghindari makanan berisiko seperti ikan bermerkuri tinggi, makanan yang belum matang, dan produk yang tidak dipasteurisasi. Langkah ini penting untuk melindungi Anda dan bayi dari potensi penyakit yang ditularkan melalui makanan.</li>
  <li><strong>Pelajari tentang gejala kehamilan:</strong> Kenali tanda-tanda awal kehamilan dan cara mengatasinya untuk menghadapi tahap ini dengan efektif.</li>
  <li><strong>Perawatan kucing:</strong> Delegasikan tanggung jawab membersihkan kotak pasir kucing untuk meminimalkan risiko toksoplasmosis, infeksi yang dapat berbahaya selama kehamilan.</li>
</ul>
<h3>Berbagi dan Belajar</h3>
<ul>
  <li><strong>Memberi tahu pasangan Anda:</strong> Pertimbangkan cara kreatif untuk mengungkapkan kehamilan Anda kepada pasangan Anda. Mengenai pemberitahuan kepada orang lain, Anda mungkin memilih untuk menunggu hingga akhir trimester pertama ketika risiko keguguran berkurang.</li>
  <li><strong>Akses sumber daya kehamilan:</strong> Unduh Panduan Kehamilan komprehensif untuk mendapatkan wawasan tentang berbagai aspek kehamilan, mulai dari nutrisi hingga pertanyaan untuk penyedia layanan kesehatan Anda.</li>
  <li><strong>Pemahaman tentang trimester:</strong> Edukasi diri Anda tentang trimester kehamilan, terutama jika ini adalah kehamilan pertama Anda.</li>
  <li><strong>Membuat jurnal:</strong> Mulailah membuat jurnal untuk mengekspresikan emosi Anda dan mendokumentasikan perjalanan kehamilan Anda.</li>
  <li><strong>Foto perut hamil:</strong> Mulailah sesi foto perut bulanan untuk menangkap perkembangan kehamilan Anda. Baik untuk kenang-kenangan pribadi atau berbagi di media sosial, foto-foto ini akan menjadi kenangan berharga.</li>
</ul>""",
    "tips_mingguan_en": """<h2>5 Weeks Pregnant: Important Considerations</h2>
<p>While you're just beginning your pregnancy journey, there are several essential aspects to keep in mind. From dietary adjustments to sharing the news with loved ones, explore the following lists.</p>
<h3>Lifestyle Adjustments</h3>
<ul>
  <li><strong>Monitor your diet:</strong> Ensure you're consuming a variety of nutritious foods while avoiding items like high-mercury fish, undercooked meals, and unpasteurized products. These precautions are crucial for protecting both you and your baby from potential food-borne illnesses.</li>
  <li><strong>Learn about pregnancy symptoms:</strong> Familiarize yourself with early signs of pregnancy and coping mechanisms to navigate this stage effectively.</li>
  <li><strong>Cat care:</strong> Delegate the responsibility of cat litter box cleaning to minimize the risk of toxoplasmosis, an infection that can be harmful during pregnancy.</li>
</ul>
<h3>Sharing and Learning</h3>
<ul>
  <li><strong>Informing your partner:</strong> Consider creative ways to reveal your pregnancy to your partner. As for informing others, you might opt to wait until the end of the first trimester when the risk of miscarriage decreases.</li>
  <li><strong>Access pregnancy resources:</strong> Download a comprehensive Pregnancy Guide to gain insights into various aspects of pregnancy, from nutrition to questions for your healthcare provider.</li>
  <li><strong>Trimester understanding:</strong> Educate yourself about the trimesters of pregnancy, particularly if this is your first pregnancy.</li>
  <li><strong>Journaling:</strong> Start a journal to express your emotions and document your pregnancy journey.</li>
  <li><strong>Baby bump photos:</strong> Commence a monthly baby bump photo shoot to capture the progression of your pregnancy. Whether for personal keepsake or sharing on social media, these photos will be cherished memories.</li>
</ul>""",
    "bayi_img_path": "week_5.jpg",
    "ukuran_bayi_img_path": "week_5_sesame_seed.svg"
  },
  {
    "id": "6",
    "minggu_kehamilan": "6",
    "berat_janin": null,
    "tinggi_badan_janin": 5,
    "ukuran_bayi_id": "Kacang Kedelai",
    "ukuran_bayi_en": "Lentil",
    "poin_utama_id": """<h2>Sorotan pada Minggu ke-6 Kehamilan</h2>
<p>Berikut adalah beberapa hal penting yang perlu diperhatikan selama minggu ke-6 kehamilan:</p>
<ul>
  <li>Bayi Anda sedang mengalami perkembangan signifikan, membentuk dasar untuk organ dan sistem penting.</li>
  <li>Anda mungkin mulai merasakan peningkatan gejala kehamilan, seperti mual di pagi hari, kelelahan, dan nyeri payudara.</li>
  <li>Ingatlah untuk mengatasi aspek emosional kehamilan. Anda dapat mengelola perubahan mood dengan mendokumentasikan perjalanan kehamilan Anda dalam sebuah jurnal atau buku.</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 6 Weeks Pregnant</h2>
<p>Here are some important things to look forward to during your sixth week of pregnancy:</p>
<ul>
  <li>Your baby is undergoing significant development, laying the groundwork for vital organs and systems.</li>
  <li>You may notice an increase in pregnancy symptoms, such as morning sickness, fatigue, and breast tenderness.</li>
  <li>Remember to address the emotional aspects of pregnancy. You can manage mood swings by documenting your pregnancy journey in a journal or book.</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>6 Minggu Hamil: Perkembangan Bayi Anda</h2>
<p>Pada usia kehamilan 6 minggu, bayi Anda mengalami pertumbuhan dan perkembangan yang cepat. Berikut adalah tonggak penting untuk minggu ini:</p>
<ul>
  <li>Tabung saraf mulai menutup, membentuk dasar untuk sumsum tulang belakang bayi Anda.</li>
  <li>Pembentukan awal mata, telinga, lengan, dan kaki mulai muncul.</li>
  <li>Pada usia 6 minggu, detak jantung kecil, biasanya sekitar 105 denyut per menit, mungkin terdeteksi melalui ultrasound.</li>
  <li>Otak, sistem saraf, hidung, mulut, telinga dalam dan luar, serta paru-paru semuanya dalam tahap awal perkembangan.</li>
</ul>""",
    "perkembangan_bayi_en": """<h2>6 Weeks Pregnant: Your Baby's Development</h2>
<p>At 6 weeks pregnant, your baby is experiencing rapid growth and development. Here are the significant milestones for this week:</p>
<ul>
  <li>The neural tube is beginning to close, forming the basis for your baby's spinal cord.</li>
  <li>The early formations of the eyes, ears, arms, and legs are emerging.</li>
  <li>By 6 weeks, a tiny heartbeat, typically around 105 beats per minute, may be detectable via ultrasound.</li>
  <li>The brain, nervous system, nose, mouth, inner and outer ears, and lungs are all in the early stages of development.</li>
</ul>""",
    "perubahan_tubuh_id": null,
    "perubahan_tubuh_en": null,
    "gejala_umum_id": """<h3>6 Minggu Hamil: Gejala Anda</h3>
    <p>Pada usia enam minggu kehamilan, Anda mungkin merasakan berbagai tanda kehamilan. Berikut adalah beberapa hal yang mungkin Anda alami:</p>
    <ul>
        <li><strong>Bercak darah</strong>. Biasa melihat sedikit darah, tetapi harus ringan. Jika Anda melihat banyak darah atau jika berlangsung lebih dari dua hari, bicarakan dengan dokter Anda.</li>
        <li><strong>Kram</strong>. Beberapa kram ringan dan cairan yang berwarna putih atau jernih adalah hal yang normal. Ini adalah tubuh Anda membuat ruang untuk bayi Anda. Tetapi jika Anda merasa sakit sangat parah, terutama dengan demam atau diare, beritahu dokter Anda.</li>
        <li><strong>Konstipasi</strong>. Anda mungkin kesulitan buang air besar karena ada lebih banyak progesteron dalam tubuh Anda. Berolahraga secara teratur, makan makanan dengan banyak serat, dan minum air.</li>
        <li><strong>Ketidaknyamanan pada payudara</strong>. Payudara Anda mungkin terasa sakit atau sensitif karena aliran darah yang lebih banyak. Ini persiapan untuk menyusui.</li>
        <li><strong>Mual</strong>. Jika Anda belum merasa mual, Anda mungkin mulai sekarang. Ini bisa terjadi kapan saja dan karena alasan yang berbeda.</li>
        <li><strong>Sering buang air kecil</strong>. Anda mungkin perlu buang air kecil lebih sering karena ginjal Anda bekerja lebih keras.</li>
        <li><strong>Kelelahan</strong>. Merasa sangat lelah adalah hal yang normal. Tidur siang dan makan makanan dengan zat besi bisa membantu.</li>
        <li><strong>Perubahan suasana hati</strong>. Anda mungkin merasa sangat bahagia satu menit dan sedih berikutnya. Makan dengan baik dan melakukan sedikit olahraga bisa membuat Anda merasa lebih baik.</li>
        <li><strong>Tidak ada gejala</strong>. Jika Anda tidak merasa salah satu hal ini, jangan khawatir. Setiap kehamilan berbeda.</li>
    </ul>""",
    "gejala_umum_en": """<h2>6 Weeks Pregnant: Your Symptoms</h2>
    <p>At six weeks into your pregnancy, you might notice various signs of being pregnant. Here are some things you might experience:</p>
    <ul>
        <li><strong>Spotting</strong>. It’s common to see a bit of blood, but it should be light. If you see a lot of blood or if it lasts more than two days, talk to your doctor.</li>
        <li><strong>Cramping</strong>. Some slight cramps and discharge that’s white or clear are normal. It’s your body making space for your baby. But if you feel a lot of pain, especially with a fever or diarrhea, tell your doctor.</li>
        <li><strong>Constipation</strong>. You might have trouble going to the bathroom because of more progesterone in your body. Exercise regularly, eat foods with lots of fiber, and drink water.</li>
        <li><strong>Breast tenderness</strong>. Your breasts might feel sore or sensitive because of more blood flowing to them. This is getting ready for breastfeeding.</li>
        <li><strong>Morning sickness</strong>. If you haven’t felt sick yet, you might start now. It can happen anytime and for different reasons.</li>
        <li><strong>Frequent urination</strong>. You might need to pee more often because your kidneys are working harder.</li>
        <li><strong>Exhaustion</strong>. Feeling really tired is normal. Taking naps and eating foods with iron can help.</li>
        <li><strong>Mood swings</strong>. You might feel really happy one minute and sad the next. Eating well and doing some light exercise can make you feel better.</li>
        <li><strong>No symptoms</strong>. If you don’t feel any of these things, don’t worry. Every pregnancy is different.</li>
    </ul>""",
    "tips_mingguan_id": """<h2>6 Minggu Hamil: Hal-hal yang Perlu Dipertimbangkan</h2>
    <p>Pada tahap awal kehamilan Anda, ada banyak hal yang perlu dipikirkan, dan Anda mungkin memiliki banyak pertanyaan atau kekhawatiran. Berikut adalah beberapa hal yang mungkin ingin Anda pertimbangkan selama minggu yang menyenangkan ini:</p>
    <ul>
        <li>Ada yang bertanya-tanya apakah 6 minggu sudah terlalu dini untuk memberi tahu keluarga tentang kehamilan Anda. Demikian pula, Anda mungkin ragu apakah memberi tahu atasan Anda. Meskipun keputusannya ada pada Anda, banyak orang memilih untuk menunggu hingga akhir trimester pertama atau awal trimester kedua ketika risiko keguguran menurun signifikan. Namun, memiliki seseorang untuk mendukung sejak awal bisa menjadi penghiburan, jadi pertimbangkan cara yang lucu dan kreatif untuk berbagi kabar dengan pasangan Anda!</li>
        <li>Salah satu perubahan awal yang mungkin Anda perhatikan adalah peningkatan ukuran payudara, disertai dengan beberapa perubahan pada kulit akibat hormon kehamilan. Hiperpigmentasi dapat membuat puting susu Anda sedikit lebih gelap.</li>
        <li>Periksa lemari pakaian Anda untuk memastikan Anda memiliki pakaian yang nyaman dan elastis untuk menyesuaikan tubuh yang berubah. Meskipun Anda mungkin belum siap untuk menggunakan pakaian hamil, menghindari pakaian yang terlalu ketat dan memilih pakaian dalam katun dapat meningkatkan kenyamanan Anda.</li>
        <li>Jika Anda berpikir untuk melakukan tes kehamilan pada usia kehamilan enam minggu, perlu diingat bahwa masih mungkin mendapatkan hasil negatif palsu, karena kadar hormon kehamilan hCG mungkin belum terdeteksi. Mengonfirmasi kehamilan dengan penyedia layanan kesehatan adalah langkah terbaik.</li>
        <li>Pertimbangkan untuk memulai jurnal foto mingguan atau scrapbook kehamilan untuk mendokumentasikan perjalanan Anda dengan catatan, foto, dan kenang-kenangan. Ini adalah cara yang indah untuk merayakan kehamilan Anda dan membuat kenang-kenangan berharga untuk bayi Anda dalam beberapa tahun mendatang.</li>
    </ul>""",
    "tips_mingguan_en": """<h2>6 Weeks Pregnant: Things to Consider</h2>
    <p>At this early stage of your pregnancy, there’s a lot to think about, and you may have many questions or concerns. Here are a few things you might want to consider during this exciting week:</p>
    <ul>
        <li>Some may wonder if it’s too soon, at 6 weeks, to share the news of your pregnancy with family. Similarly, you might be unsure whether to inform your boss. While the decision is yours, many choose to wait until the end of the first trimester or the beginning of the second when the risk of miscarriage decreases significantly. However, having someone for support from the start can be comforting, so consider cute and creative ways to share the news with your partner!</li>
        <li>One of the initial changes you might notice is an increase in breast size, accompanied by some skin alterations due to pregnancy hormones. Hyperpigmentation may cause your nipples to darken slightly.</li>
        <li>Check your wardrobe to ensure you have comfortable, stretchy clothing to accommodate your changing body. While you may not be ready for maternity wear just yet, avoiding tight-fitting clothes and opting for cotton underwear can enhance your comfort.</li>
        <li>If you’re contemplating taking a pregnancy test at six weeks, be aware that it’s still possible to receive a false negative result, as the pregnancy hormone hCG levels may not be detectable. Confirming your pregnancy with a healthcare provider is the best course of action.</li>
        <li>Consider starting a weekly photo journal or pregnancy scrapbook to document your journey with notes, photos, and keepsakes. It’s a wonderful way to celebrate your pregnancy and create a cherished memento for your baby in the years to come.</li>
    </ul>""",
    "bayi_img_path": "week_6.jpg",
    "ukuran_bayi_img_path": "week_6_lentil.svg"
  },
  {
    "id": "7",
    "minggu_kehamilan": "7",
    "berat_janin": null,
    "tinggi_badan_janin": 9.5,
    "ukuran_bayi_id": "Blueberry",
    "ukuran_bayi_en": "Blueberry",
    "poin_utama_id": """<h2>7 Minggu Hamil: Sorotan Penting</h2>
    <p>Berikut adalah beberapa poin penting dan hal-hal yang bisa Anda antisipasi sekarang bahwa Anda sudah memasuki minggu ketujuh kehamilan:</p>
    <ul>
        <li>Jika Anda melewatkan periode dan melakukan tes kehamilan, Anda mungkin ingin mengonfirmasi kehamilan Anda dengan profesional kesehatan.</li>
        <li>Otak, paru-paru, sistem pencernaan, anggota tubuh, dan fitur wajah bayi Anda masih terus berkembang pada tahap ini.</li>
        <li>Siap-siaplah untuk keinginan makan selama kehamilan—mereka mungkin menjadi lebih terasa sekarang. Tidak apa-apa untuk sedikit memanjakan diri selama Anda tetap menjaga pola makan seimbang.</li>
    </ul>""",
    "poin_utama_en": """<h2>7 Weeks Pregnant: Key Highlights</h2>
    <p>Here are some important points to note and things to anticipate now that you’re in your seventh week of pregnancy:</p>
    <ul>
        <li>If you've missed your period and taken a pregnancy test, you may want to confirm your pregnancy with a healthcare professional.</li>
        <li>Your baby's brain, lungs, digestive system, limbs, and facial features are still developing at this stage.</li>
        <li>Get ready for pregnancy cravings—they might become more noticeable now. It's okay to indulge a little as long as you're maintaining a balanced diet.</li>
    </ul>""",
    "perkembangan_bayi_id": """<h2>7 Minggu Hamil: Perkembangan Bayi Anda</h2>
<p>Mungkin Anda akan terkejut melihat seberapa banyak perkembangan bayi Anda minggu ini! Pada usia kehamilan 7 minggu, fondasi sedang dibangun untuk organ, sistem, dan fitur utama.</p>
<ul>    
    <li>Meskipun perkembangan otak bayi Anda akan terus berlanjut setelah lahir, struktur dasarnya telah terbentuk.</li>
    <li>Selama minggu berjalan, sistem pencernaan dan paru-paru juga sedang berkembang.</li>
    <li>Fitur wajah yang kecil mulai terbentuk, dan setiap lengan kecil sekarang memiliki tangan berbentuk dayung yang melekat padanya.</li>
    <li>Melewati tonggak penting lainnya minggu ini adalah pembentukan tali pusar. Tali ini membentuk hubungan penting antara Anda dan bayi Anda yang sedang berkembang, memfasilitasi pertukaran nutrisi dan oksigen sambil menghilangkan limbah.</li>
    <li>Jika Anda memiliki jadwal pemeriksaan prenatal pada usia kehamilan 7 minggu atau sesaat setelahnya, penyedia layanan kesehatan Anda mungkin dapat mendeteksi aktivitas jantung (meskipun belum detak jantung sebenarnya) menggunakan ultrasonografi. Namun, adalah umum bagi pemeriksaan ultrasonografi pertama dilakukan lebih lanjut dalam kehamilan, jadi tidak perlu khawatir.</li>
</ul>""",
    "perkembangan_bayi_en": """<h2>7 Weeks Pregnant: Your Baby's Development</h2>
<p>Surprisingly, your baby's development is quite active this week! At 7 weeks, the groundwork is being laid for major organs, systems, and features.</p>
<ul>
    <li>While your baby's brain will continue to develop well beyond birth, the basic structures are already in place.</li>
    <li>Additionally, the digestive system and lungs are undergoing development as the week progresses.</li>
    <li>Tiny facial features are starting to form, and each little arm now has a paddle-shaped hand attached to it.</li>
    <li>Another significant milestone this week is the formation of the umbilical cord. This cord establishes a vital connection between you and your growing baby, facilitating the exchange of nutrients and oxygen while eliminating waste.</li>
    <li>If you have a prenatal checkup scheduled at 7 weeks pregnant or shortly thereafter, your healthcare provider may be able to detect cardiac activity (although not a true heartbeat yet) using ultrasound. However, it's common for the first ultrasound scan to occur later in pregnancy, so there's no need to worry.</li>
</ul>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda pada Usia Kehamilan 7 Minggu</h2>
<p>Tanda dan gejala kehamilan yang mungkin telah Anda alami dalam beberapa minggu terakhir kemungkinan akan terus berlanjut, dan beberapa dari mereka mungkin menjadi lebih jelas minggu ini. Meskipun gejala-gejala ini bisa melelahkan dan menjengkelkan, ingatlah bahwa banyak di antaranya dapat berkurang saat Anda memasuki trimester kedua kehamilan Anda, yang hanya beberapa minggu lagi.</p>
<p>Adopsi kebiasaan hidup sehat sekarang harus menjadi prioritas utama. Penyedia layanan kesehatan Anda mungkin akan memperingatkan Anda tentang risiko terjangkit toxoplasmosis, infeksi yang ditularkan melalui daging mentah atau setengah matang serta kotoran kucing. Untuk meminimalkan risiko terkena infeksi, pastikan bahwa daging Anda dimasak hingga matang sempurna, praktikkan kebersihan tangan yang baik setelah menangani daging, dan hindari membersihkan kotak pasir kucing selama sisa kehamilan Anda, jika Anda belum melakukannya.</p>""",
    "perubahan_tubuh_en": """<h2>Your Body at 7 Weeks Pregnant</h2>
<p>The signs and symptoms of pregnancy that you may have noticed in the previous weeks are likely to persist, and some of them may become more noticeable this week. While these symptoms can be exhausting and bothersome, remember that many of them may lessen as you progress into your second trimester, which is only a few weeks away.</p>
<p>It's crucial to prioritize healthy habits now. Your healthcare provider might warn you about the risks of contracting toxoplasmosis, an infection transmitted through raw or undercooked meat and cat feces. To minimize the risk of exposure to the infection, ensure that your meat is thoroughly cooked, practice proper hand hygiene after handling meat, and avoid cleaning the cat litter box for the remainder of your pregnancy, if you haven't already done so.</p>""",
    "gejala_umum_id": """<h2>Gejala Kehamilan pada Usia Kehamilan 7 Minggu</h2>
<p>Pada usia kehamilan 7 minggu, Anda mungkin mengalami beberapa gejala berikut:</p>
<ul>
  <li><strong>Kelebihan air liur:</strong> Anda mungkin memperhatikan lebih banyak air liur dari biasanya, seringkali menyertai mual dan muntah pada pagi hari. Meskipun terasa aneh, ini hanya bagian normal dari kehamilan.</li>
  <li><strong>Hasrat atau ketidaksukaan terhadap makanan:</strong> Anda mungkin mengalami hasrat untuk makanan tertentu atau merasa tidak tahan dengan aroma tertentu. Perubahan preferensi makanan ini sering disebabkan oleh fluktuasi hormon.</li>
  <li><strong>Mual:</strong> Mual bisa sangat mengganggu pada tahap kehamilan ini, tetapi biasanya mereda setelah trimester pertama.</li>
  <li><strong>Diare:</strong> Gejala gastrointestinal seperti diare dapat terjadi akibat perubahan hormon. Pastikan Anda tetap terhidrasi dan pertimbangkan untuk menambahkan makanan seperti saus apel dan pisang ke dalam diet Anda.</li>
  <li><strong>Bercak:</strong> Bercak ringan saat membersihkan diri adalah hal yang umum pada kehamilan 7 minggu. Namun, pendarahan yang lebih berat harus dilaporkan kepada penyedia layanan kesehatan Anda.</li>
  <li><strong>Kram:</strong> Kram ringan dan nyeri pinggang adalah hal yang normal ketika rahim Anda membesar. Kram yang parah atau berkepanjangan harus dibicarakan dengan penyedia layanan kesehatan Anda.</li>
  <li><strong>Kelelahan:</strong> Merasa lelah adalah hal yang wajar akibat peningkatan kadar progesteron. Pastikan untuk beristirahat secara teratur dan konsultasikan dengan penyedia layanan kesehatan Anda jika Anda mengalami sakit kepala yang parah.</li>
  <li><strong>Buang air kecil yang sering:</strong> Perubahan hormon dan peningkatan volume darah dapat menyebabkan buang air kecil yang lebih sering. Tetap terhidrasi dengan minum banyak air.</li>
  <li><strong>Keputihan:</strong> Keputihan vagina adalah hal yang umum selama kehamilan dan normal pada usia kehamilan 7 minggu.</li>
</ul>""",
    "gejala_umum_en": """<h2>7 Weeks Pregnant: Your Symptoms</h2>
<p>At 7 weeks pregnant, you may be experiencing the following symptoms:</p>
<ul>
  <li><strong>Excess salivation:</strong> You might notice more saliva than usual, often accompanying morning sickness. While it may feel odd, it's a normal part of pregnancy.</li>
  <li><strong>Food cravings or aversions:</strong> You may develop cravings for specific foods or find certain smells intolerable. These changes in food preferences are often due to hormonal fluctuations.</li>
  <li><strong>Nausea:</strong> Morning sickness can be particularly bothersome at this stage of pregnancy, but it typically subsides after the first trimester.</li>
  <li><strong>Diarrhea:</strong> Gastrointestinal symptoms like diarrhea may occur due to hormonal changes. Ensure you stay hydrated and consider adding foods like applesauce and bananas to your diet.</li>
  <li><strong>Spotting:</strong> Light spotting while wiping is common at 7 weeks pregnant. However, heavier bleeding should be reported to your healthcare provider.</li>
  <li><strong>Cramping:</strong> Mild cramping and lower back pain are normal as your uterus expands. Severe or prolonged cramping should be discussed with your healthcare provider.</li>
  <li><strong>Fatigue:</strong> Feeling tired is typical due to increasing progesterone levels. Make sure to rest frequently and consult your healthcare provider if you experience severe headaches.</li>
  <li><strong>Frequent urination:</strong> Hormonal changes and increased blood volume may lead to more frequent urination. Stay hydrated by drinking plenty of water.</li>
  <li><strong>Discharge:</strong> Vaginal discharge is common during pregnancy and is normal at 7 weeks.</li>
</ul>""",
    "tips_mingguan_id": """<h2>Kehamilan 7 Minggu: Hal yang Perlu Dipertimbangkan</h2>
<p>Meskipun Anda baru memulai perjalanan kehamilan, ada beberapa hal penting yang perlu dipertimbangkan. Berikut adalah daftarnya:</p>
<ul>
  <li><strong>Perbarui Lemari Pakaian Anda:</strong> Belilah beberapa pakaian yang akan cocok dengan tubuh yang berubah. Pakaian yang elastis dan nyaman adalah pilihan yang ideal, dan jangan lupa untuk memastikan bra yang pas dan memilih kain bernapas seperti katun.</li>
  <li><strong>Pastikan Asupan Nutrisi yang Tepat:</strong> Fokuslah pada konsumsi makanan yang bergizi dan pertimbangkan untuk menghindari makanan pedas atau digoreng untuk mencegah sakit maag. Jika Anda vegetarian atau vegan, carilah sumber protein alternatif seperti biji-bijian dan kacang-kacangan. Konsultasikan dengan penyedia layanan kesehatan Anda tentang suplemen yang diperlukan, seperti vitamin B12.</li>
  <li><strong>Merawat Kulit Anda:</strong> Perubahan hormon dapat menyebabkan jerawat selama kehamilan. Meskipun normal, penggunaan produk bebas minyak dapat membantu mengatasi jerawat.</li>
  <li><strong>Mengelola Gejala:</strong> Pelajari cara efektif untuk mengatasi gejala fisik dan emosional. Ingatlah bahwa banyak gejala cenderung mereda pada trimester kedua, dan penyedia layanan kesehatan Anda dapat memberikan panduan tentang cara mengelolanya.</li>
  <li><strong>Mulai Foto Perut Bulanan:</strong> Mulailah mengambil foto bulanan untuk mendokumentasikan perjalanan kehamilan Anda. Gunakan pengaturan yang sama setiap bulan dan buat kenang-kenangan yang akan Anda hargai di masa depan. Anda juga dapat membagikan foto-foto ini di media sosial atau kepada orang yang Anda cintai.</li>
</ul>""",
    "tips_mingguan_en": """<h2>7 Weeks Pregnant: Things to Keep in Mind</h2>
<p>Even though you're just starting your pregnancy journey, there are several important things to consider. Take a look at the list below:</p>
<ul>
  <li><strong>Update Your Wardrobe:</strong> Purchase some clothing items that will accommodate your changing body. Stretchy and comfortable clothes are ideal, and don't forget to ensure proper fitting bras and choose breathable fabrics like cotton.</li>
  <li><strong>Ensure Proper Nutrition:</strong> Focus on consuming nutritious foods and consider avoiding spicy or fried foods to prevent heartburn. If you're vegetarian or vegan, find alternative protein sources like grains and legumes. Consult your healthcare provider about necessary supplements, such as vitamin B12.</li>
  <li><strong>Care for Your Skin:</strong> Hormonal changes may lead to acne during pregnancy. While it's normal, using oil-free products can help manage breakouts.</li>
  <li><strong>Manage Symptoms:</strong> Learn effective ways to cope with physical and emotional symptoms. Remember that many symptoms tend to ease up in the second trimester, and your healthcare provider can provide guidance on managing them.</li>
  <li><strong>Start Monthly Bump Photos:</strong> Begin taking monthly photos to document your pregnancy journey. Use the same setup each month and create a keepsake that you'll cherish in the future. You can also share these photos on social media or with loved ones.</li>
</ul>""",
    "bayi_img_path": "week_7.jpg",
    "ukuran_bayi_img_path": "week_7_blueberry.svg"
  },
  {
    "id": "8",
    "minggu_kehamilan": "8",
    "berat_janin": null,
    "tinggi_badan_janin": 16,
    "ukuran_bayi_id": "Kacang Merah",
    "ukuran_bayi_en": "Kidney Bean",
    "poin_utama_id": """<h2>Highlights pada Minggu Kedelapan Kehamilan</h2>
<p>Saat Anda memasuki minggu kedelapan kehamilan, ada beberapa sorotan yang menarik dan penting untuk dicatat:</p>
<ul>
  <li>Bayi Anda mulai membentuk jari-jari dan jempol yang sangat kecil!</li>
  <li>Anda mungkin memiliki janji pranatal dengan penyedia layanan kesehatan Anda minggu ini atau dalam waktu dekat. Ini adalah kesempatan yang bagus untuk membahas pertanyaan atau kekhawatiran yang Anda miliki.</li>
  <li>Mulailah mempertimbangkan kapan dan bagaimana Anda ingin membagikan berita kehamilan Anda! Akhir trimester pertama sudah dekat, yang seringkali menjadi waktu ketika orang memilih untuk mengumumkan kehamilan mereka kepada orang lain.</li>
  <li>Bersiaplah untuk beberapa gejala baru, seperti nyeri pinggang bagian bawah. Otot Anda bekerja lebih keras untuk mendukung uterus yang sedang berkembang.</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 8 Weeks Pregnant</h2>
<p>As you enter your eighth week of pregnancy, there are some exciting and significant highlights to take note of:</p>
<ul>
  <li>Your baby is beginning to form tiny fingers and toes!</li> 
  <li>You may have a prenatal appointment scheduled with your healthcare provider this week or in the near future. It's a great opportunity to discuss any questions or concerns you may have.</li>
  <li>Start considering when and how you want to share your pregnancy news! The end of the first trimester is approaching, which is often when people choose to announce their pregnancy to others.</li>
  <li>Be prepared for some new symptoms, such as lower back pain. Your muscles are working harder to support the growing uterus.</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>Perkembangan Janin Anda pada Usia Kehamilan 8 Minggu</h2>
<p>Minggu ini menandai fase penting dalam perkembangan janin Anda, dengan fokus pada fitur internal dan eksternal, termasuk jari-jari dan jempol yang menggemaskan:</p>
<ul>
  <li>Tangan dan kaki bayi Anda, yang awalnya hanya tunas sederhana, kini mulai membentuk jari-jari dan jempol yang sangat kecil. Selain itu, lengan mulai fleksibel di siku dan pergelangan tangan.</li>
  <li>Pada tahap ini, mata mulai mengembangkan pigmen, dan alat kelamin juga sedang terbentuk. Namun, masih terlalu dini untuk mengetahui jenis kelamin biologis bayi Anda.</li>
  <li>Secara internal, organ-organ berkembang. Usus mulai mengambil bentuk, dan mereka mengisi ruang di tali pusat karena belum cukup ruang di perut bayi. Meskipun masih pada tahap awal, usus sudah berfungsi untuk mengeluarkan limbah dari tubuh.</li>
</ul>""",
    "perkembangan_bayi_en": """<h2>8 Weeks Pregnant: Your Baby's Development</h2>
<p>This week marks a significant phase in your baby's development, with focus on both internal and external features, including the adorable fingers and toes:</p>
<ul>
  <li>Your baby's hands and feet, which were once simple buds, are now forming tiny fingers and toes. Additionally, the arms are gaining flexibility at the elbows and wrists.</li>
  <li>At this stage, the eyes are beginning to develop pigment, and the genitals are also forming. However, it's still too early to determine your baby's biological sex.</li>
  <li>Internally, the organs are progressing. The intestines are starting to take shape, and they occupy space in the umbilical cord because there isn't enough room in the baby's abdomen yet. Despite being in the early stages, the intestines are already functioning to remove waste from the body.</li>
</ul>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda saat Hamil 8 Minggu</h2>
<p>Saat Anda mencapai minggu ke-8 kehamilan, Anda mungkin mulai memperhatikan gejala kehamilan yang lebih mencolok. Pakaian Anda mungkin mulai terasa lebih sempit, dan Anda mungkin mengalami gejala baru atau yang muncul dan menghilang. Di sisi positif, penyedia layanan kesehatan Anda mungkin dapat mendeteksi beberapa aktivitas jantung pada usia kehamilan 8 minggu ini, meskipun detak jantung bayi Anda mungkin terlalu cepat untuk dideteksi dengan ultrasonografi internal atau eksternal.</p>""",
    "perubahan_tubuh_en": """<h2>Your Body at 8 Weeks Pregnant</h2>
<p>As you reach the 8th week of pregnancy, you may start noticing more prominent pregnancy symptoms. Your clothing might begin to feel tighter, and you may experience new symptoms or ones that come and go. On a positive note, your healthcare provider might be able to detect some cardiac activity at this stage, although your baby's heart rate may be too rapid to be picked up by an internal or external ultrasound.</p>""",
    "gejala_umum_id": """<h2>Gejala Hamil 8 Minggu: Gejala Anda</h2>
<p>Pada usia kehamilan 8 minggu, Anda mungkin mengalami beberapa gejala berikut:</p>
<ul>
  <li><strong>Mual dan muntah:</strong> Nausea dan muntah adalah gejala umum, tetapi biasanya membaik pada trimester kedua. Mengonsumsi kerupuk dan makan dalam porsi kecil, lebih sering dapat membantu mengurangi gejala.</li>
  <li><strong>Penolakan makanan dan bau:</strong> Perubahan hormon dapat membuat rasa dan bau tertentu terasa sangat kuat atau tidak menyenangkan.</li>
  <li><strong>Diare:</strong> Sensitivitas pencernaan dapat menyebabkan gejala seperti diare, sembelit, dan nyeri perut. Menjaga pola makan sehat dan tetap terhidrasi dapat memberikan bantuan.</li>
  <li><strong>Sering buang air kecil:</strong> Tekanan kandung kemih yang meningkat akibat pertumbuhan rahim dapat menyebabkan Anda harus buang air kecil lebih sering.</li>
  <li><strong>Kram perut:</strong> Kram ringan yang terkait dengan pertumbuhan rahim adalah hal yang umum, tetapi gejala yang parah harus dibicarakan dengan penyedia layanan kesehatan Anda.</li>
  <li><strong>Nyeri punggung:</strong> Nyeri punggung bagian bawah dapat terjadi karena tubuh Anda menyesuaikan diri untuk menampung rahim yang berkembang dan perubahan postur.</li>
  <li><strong>Bercak dan keluarnya cairan:</strong> Pendarahan ringan dan keluarnya cairan bisa normal, tetapi pendarahan berat atau keluarnya cairan yang tidak normal harus dilaporkan kepada penyedia layanan kesehatan Anda.</li>
  <li><strong>Kelelahan:</strong> Peningkatan kadar progesteron dapat menyebabkan kelelahan, jadi penting untuk beristirahat kapan pun memungkinkan.</li>
  <li><strong>Kesulitan tidur:</strong> Perubahan hormonal dan ketidaknyamanan fisik dapat mengganggu pola tidur. Menemukan teknik relaksasi dan posisi tidur yang nyaman dapat membantu meningkatkan kualitas tidur.</li>
</ul>""",
    "gejala_umum_en": """<h2>8 Weeks Pregnant: Your Symptoms</h2>
<p>At 8 weeks pregnant, you may experience the following symptoms:</p>
<ul>
  <li><strong>Morning sickness:</strong> Nausea and vomiting are common symptoms, but they typically improve in the second trimester. Snacking on crackers and eating smaller, more frequent meals may help alleviate the symptoms.</li>
  <li><strong>Food and smell aversions:</strong> Hormonal changes may cause certain tastes and odors to be overwhelming or unpleasant.</li>
  <li><strong>Diarrhea:</strong> Digestive sensitivity can lead to symptoms like diarrhea, constipation, and stomach pain. Maintaining a healthy diet and staying hydrated may provide relief.</li>
  <li><strong>Frequent urination:</strong> Increased bladder pressure due to the growing uterus may result in more trips to the bathroom.</li>
  <li><strong>Abdominal cramping:</strong> Mild cramping associated with the uterus' growth is common, but severe symptoms should be discussed with your healthcare provider.</li>
  <li><strong>Back pain:</strong> Lower back pain may occur as your body adjusts to accommodate your growing uterus and changes in posture.</li>
  <li><strong>Spotting and discharge:</strong> Light bleeding and discharge can be normal, but heavy bleeding or abnormal discharge should be reported to your healthcare provider.</li>
  <li><strong>Fatigue:</strong> Increasing progesterone levels may cause fatigue, so it's important to rest whenever possible.</li>
  <li><strong>Trouble sleeping:</strong> Hormonal changes and physical discomfort may disrupt sleep patterns. Finding relaxation techniques and comfortable sleeping positions can help improve sleep quality.</li>
</ul>""",
    "tips_mingguan_id": """<h2>8 Minggu Hamil: Hal yang Perlu Dipertimbangkan</h2>
<p>Saat Anda memasuki akhir bulan kedua dalam perjalanan kehamilan Anda, ada beberapa hal penting yang perlu dipikirkan dan dilakukan dalam beberapa minggu mendatang. Berikut beberapa pertimbangan penting:</p>
<ul>
  <li><strong>Perbarui pakaian Anda:</strong> Pertimbangkan untuk menambahkan beberapa pakaian yang elastis untuk menyesuaikan perut yang semakin membesar. Penting untuk tetap nyaman, jadi pilihlah pakaian yang pas dan pilihlah pakaian dalam berbahan katun untuk kenyamanan tambahan.</li>
  <li><strong>Tetap aktif:</strong> Jika Anda aktif secara fisik sebelum hamil, umumnya aman untuk tetap berolahraga. Namun, konsultasikan dengan penyedia layanan kesehatan Anda untuk memastikan aktivitas yang Anda pilih sesuai dengan kondisi Anda.</li>
  <li><strong>Cari perawatan prenatal:</strong> Jadwalkan janji pertama Anda dengan penyedia layanan kesehatan jika belum melakukannya. Pilih penyedia yang membuat Anda merasa nyaman dan filosofinya sejalan dengan Anda.</li>
  <li><strong>Tentukan kapan untuk berbagi kabar:</strong> Apakah memberitahu bos, keluarga, dan teman tentang kehamilan Anda pada usia kehamilan 8 minggu adalah keputusan pribadi. Ada yang memilih untuk berbagi kabar secara dini, sementara yang lain menunggu setelah trimester pertama.</li>
  <li><strong>Kenali tanda peringatan kehamilan:</strong> Edukasikan diri Anda tentang komplikasi potensial dan tanda-tanda peringatan yang mungkin memerlukan perhatian medis. Selalu konsultasikan dengan penyedia layanan kesehatan Anda jika Anda memiliki kekhawatiran.</li>
  <li><strong>Temukan nama bayi:</strong> Mulailah mengumpulkan ide nama bayi dan buat daftar nama favorit Anda. Pertimbangkan untuk menambahkannya ke buku kenangan kehamilan untuk referensi di masa depan.</li>
  <li><strong>Terhubung dengan orangtua lain:</strong> Bergabunglah dengan grup media sosial atau kelompok dukungan masyarakat untuk terhubung dengan orangtua lain yang sedang mengandung. Berbagi pengalaman dan saran dapat berharga selama masa ini.</li>
</ul>""",
    "tips_mingguan_en": """<h2>8 Weeks Pregnant: Things to Consider</h2>
<p>As you approach the end of the second month of your pregnancy, there are several important things to keep in mind and take care of in the coming weeks. Here are some key considerations:</p>
<ul>
  <li><strong>Update your wardrobe:</strong> Consider adding some stretchy clothing to accommodate your growing belly. It's essential to stay comfortable, so choose clothes that fit well and opt for cotton underwear for added comfort.</li>
  <li><strong>Stay active:</strong> If you were physically active before pregnancy, it's generally safe to continue exercising. However, consult your healthcare provider to ensure the activities you choose are suitable for your condition.</li>
  <li><strong>Seek prenatal care:</strong> Schedule your first appointment with a healthcare provider if you haven't already. Choose a provider you feel comfortable with and whose philosophy aligns with yours.</li>
  <li><strong>Decide when to share the news:</strong> Whether to inform your boss, family, and friends about your pregnancy at 8 weeks is a personal decision. Some prefer to share the news early, while others wait until after the first trimester.</li>
  <li><strong>Be aware of pregnancy warning signs:</strong> Educate yourself about potential complications and warning signs that may require medical attention. Always consult your healthcare provider if you have concerns.</li>
  <li><strong>Explore baby names:</strong> Start brainstorming baby names and keep a list of your favorites. Consider adding them to a pregnancy memory book for future reference.</li>
  <li><strong>Connect with other parents:</strong> Join social media groups or community support groups to connect with other expecting parents. Sharing experiences and advice can be valuable during this time.</li>
</ul>""",
    "bayi_img_path": "week_8.jpg",
    "ukuran_bayi_img_path": "week_8_kidney_bean.svg"
  },
  {
    "id": "9",
    "minggu_kehamilan": "9",
    "berat_janin": null,
    "tinggi_badan_janin": 23,
    "ukuran_bayi_id": "Anggur",
    "ukuran_bayi_en": "Grape",
    "poin_utama_id": """<h2>Info Penting pada Usia Kehamilan 9 Minggu</h2>
<p>Berikut adalah ringkasan singkat dari beberapa perkembangan penting yang dapat diantisipasi selama kehamilan minggu ke-9:</p>
<ul>
  <li>Bayi Anda mulai menyerupai manusia kecil, dengan pembentukan jari kaki dan fitur wajah yang lucu.</li>
  <li>Meskipun demikian, bayi Anda masih sangat kecil, seukuran buah ceri!</li>
  <li>Walaupun mual di pagi hari mungkin mulai mereda, perubahan hormon dapat menyebabkan gejala lain seperti perubahan suasana hati, kelelahan, atau jerawat.</li>
  <li>Untuk kenyamanan, pertimbangkan untuk memperoleh beberapa pakaian longgar atau elastis. Selain itu, mungkin bermanfaat untuk meminta bantuan profesional untuk memilih bra yang pas, karena payudara Anda akan terus tumbuh lebih besar, penuh, dan lebih sensitif.</li>
  <li>Bahas opsi latihan yang aman dengan penyedia layanan kesehatan Anda. Jika belum melakukannya, sekarang adalah waktu yang tepat untuk menjelajahi yoga!</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 9 Weeks Pregnant</h2>
<p>Here's a brief overview of some important developments to anticipate during the 9th week of pregnancy:</p>
<ul>
  <li>Your baby is beginning to resemble a tiny human, with the formation of cute little toes and facial features.</li>
  <li>Despite these developments, your baby is still very small, comparable in size to a cherry!</li>
  <li>While morning sickness may gradually subside, hormonal changes could bring about other symptoms such as mood swings, fatigue, or acne.</li>
  <li>To ensure comfort, consider acquiring some loose or stretchy clothing. Additionally, it may be beneficial to have a professional fit you for a bra, as your breasts will continue to grow larger, fuller, and more sensitive.</li>
  <li>Discuss safe exercise options with your healthcare provider. If you haven't already, now is an opportune time to explore yoga!</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>Usia Kehamilan 9 Minggu: Perkembangan Bayi Anda</h2>
<p>Pada usia kehamilan 9 minggu, bayi Anda mulai membentuk gambaran seperti manusia mini! Bahkan ekor yang ada pada minggu-minggu sebelumnya hampir benar-benar menghilang. Berikut adalah beberapa perubahan perkembangan penting lainnya yang terjadi minggu ini:</p>
<ul>
  <li>Perkembangan terus-menerus dari fitur wajah yang kecil, termasuk pembentukan kelopak mata dan hidung yang lebih terdefinisi.</li>
  <li>Perbedaan yang mencolok dalam proporsi, dengan kepala terlihat lebih besar dibandingkan tubuh, sementara jari-jari kaki mulai terlihat di ujung lain.</li>
  <li>Organ-organ internal, seperti sistem pencernaan dan reproduksi, sedang dalam proses pembentukan, menandakan pertumbuhan usus dan alat kelamin.</li>
</ul>
<p>Sekarang setelah Anda mencapai usia kehamilan 9 minggu, Anda mungkin penasaran apakah Anda bisa merasakan gerakan bayi Anda, apakah itu getaran lembut atau gerakan halus. Meskipun bayi Anda memang bergerak karena perkembangan otot baru-baru ini, Anda kemungkinan harus menunggu hingga trimester kedua untuk benar-benar merasakan gerakan tersebut.</p>""",
    "perkembangan_bayi_en": """<h2>9 Weeks Pregnant: Your Baby's Growth</h2>
<p>At 9 weeks pregnant, your baby is gradually taking on the appearance of a miniature human! The tail that was present in previous weeks has almost completely disappeared. Here are some other significant developmental changes occurring this week:</p>
<ul>
  <li>Continued development of tiny facial features, including the formation of eyelids and a more defined nose.</li>
  <li>A noticeable difference in proportions, with the head appearing larger in comparison to the body, while the toes become visible at the other end.</li>
  <li>Internal organs, such as the digestive and reproductive systems, are in the process of formation, indicating the growth of intestines and genitals.</li>
</ul>
<p>Now that you've reached the 9th week of pregnancy, you might be curious about feeling your baby's movements, whether they're gentle flutters or subtle motions. While your baby is indeed moving due to recent muscle development, you'll likely have to wait until the second trimester to perceive these movements.</p>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda Saat Hamil 9 Minggu</h2>
<p>Saat tubuh Anda mengalami perubahan normal selama kehamilan, adalah ide bagus untuk berkonsultasi dengan penyedia layanan kesehatan Anda tentang berolahraga selama kehamilan. Jika Anda sudah aktif, Anda mungkin perlu menyesuaikan rutinitas latihan Anda. Bagi mereka yang tidak terlalu aktif, memulai dengan latihan yang lembut dan aman disarankan.</p>
<p>Melakukan latihan ringan dapat membantu Anda membangun kekuatan dan daya tahan yang diperlukan untuk persalinan. Aktivitas seperti berjalan, yoga prenatal, renang, dan aerobik air adalah pilihan yang sangat baik karena mudah bagi sendi Anda. Lebih baik untuk menghindari aktivitas yang melibatkan lompatan atau gerakan tiba-tiba yang dapat menimbulkan tekanan berlebihan pada sendi Anda. Untuk saran yang dipersonalisasi tentang jenis latihan yang tepat untuk Anda, konsultasikan dengan penyedia layanan kesehatan Anda.</p>""",
    "perubahan_tubuh_en": """<h2>Your Body at 9 Weeks Pregnant</h2>
<p>As your body undergoes the normal changes of pregnancy, it's a good idea to talk to your healthcare provider about exercising during pregnancy. If you're already active, you might need to adjust your workout routine. For those who haven't been as active, starting with gentle and safe exercises is recommended.</p>
<p>Engaging in moderate exercise can help you build the strength and endurance necessary for labor and delivery. Activities like walking, prenatal yoga, swimming, and water aerobics are excellent choices because they are easy on your joints. It's best to avoid activities involving bouncing or sudden movements that could strain your joints. For personalized advice on the right type of exercise for you, consult your healthcare provider.</p>""",
    "gejala_umum_id": """<h2>Gejala pada Kehamilan 9 Minggu</h2>
<p>Penasaran dengan apa yang akan dirasakan saat hamil 9 minggu? Berikut beberapa gejala yang mungkin Anda alami:</p>
<ul>
  <li><strong>Perut membesar:</strong> Pakaian Anda mungkin terasa lebih sempit akibat kembung dan perut yang semakin tebal.</li>
  <li><strong>Bercak:</strong> Pendarahan ringan atau bercak adalah hal yang umum selama trimester pertama, tetapi hubungi penyedia layanan kesehatan Anda jika Anda memperhatikan keluarnya cairan yang tidak biasa.</li>
  <li><strong>Kram rahim:</strong> Kram ringan dan nyeri punggung bagian bawah bisa terjadi saat rahim Anda membesar.</li>
  <li><strong>Mual:</strong> Mual mungkin mulai mereda, tetapi beberapa wanita mengalaminya pada kehamilan 9 minggu.</li>
  <li><strong>Nafsu makan meningkat:</strong> Anda mungkin merasa lapar lebih dari biasanya, jadi siapkan camilan.</li>
  <li><strong>Keinginan dan ketidaksukaan makanan:</strong> Indra penciuman Anda mungkin meningkat, menyebabkan keinginan atau ketidaksukaan terhadap makanan.</li>
  <li><strong>Kelelahan:</strong> Tingkat progesteron yang lebih tinggi dapat menyebabkan kelelahan dan sakit kepala.</li>
  <li><strong>Perubahan suasana hati:</strong> Perubahan hormon dapat menyebabkan perubahan suasana hati.</li>
  <li><strong>Sering buang air kecil:</strong> Bayi dan rahim yang berkembang dapat memberi tekanan pada kandung kemih Anda.</li>
  <li><strong>Jerawat:</strong> Hormon kehamilan dapat menyebabkan atau memperburuk jerawat.</li>
  <li><strong>Nyeri pada payudara:</strong> Payudara Anda mungkin terasa lebih penuh, berat, dan sensitif karena perubahan hormon.</li>
</ul>""",
    "gejala_umum_en": """<h2>9 Weeks Pregnant: Your Symptoms</h2>
<p>Wondering what to expect at 9 weeks pregnant? Here are some symptoms you might experience:</p>
<ul>
  <li><strong>Expanding waistline:</strong> Your clothes may feel tighter due to bloating and a thickening waistline.</li>
  <li><strong>Spotting:</strong> Light bleeding or spotting is common during the first trimester, but contact your healthcare provider if you notice any unusual discharge.</li>
  <li><strong>Uterine cramping:</strong> Mild cramping and lower back pain can occur as your uterus expands.</li>
  <li><strong>Morning sickness:</strong> Nausea may start to ease, but some women experience it at 9 weeks pregnant.</li>
  <li><strong>Increased hunger:</strong> You may feel hungrier than usual, so keep snacks on hand.</li>
  <li><strong>Food cravings and aversions:</strong> Your sense of smell may heighten, leading to cravings or aversions.</li>
  <li><strong>Fatigue:</strong> Higher levels of progesterone may cause fatigue and headaches.</li>
  <li><strong>Mood swings:</strong> Hormonal changes can lead to mood swings.</li>
  <li><strong>Frequent urination:</strong> Your growing baby and uterus may put pressure on your bladder.</li>
  <li><strong>Acne:</strong> Pregnancy hormones may cause or worsen acne.</li>
  <li><strong>Breast tenderness:</strong> Your breasts may feel fuller, heavier, and tender due to hormonal changes.</li>
</ul>""",
    "tips_mingguan_id": """<h2>9 Minggu Hamil: Hal-hal yang Perlu Dipertimbangkan</h2>
<p>Sekarang Anda telah memasuki bulan ketiga kehamilan, ada banyak hal yang perlu dipikirkan. Berikut beberapa hal penting yang perlu dipertimbangkan:</p>
<ul>
  <li>Pastikan Anda secara teratur <strong>mencari ukuran bra yang tepat</strong> untuk tetap nyaman, terutama karena payudara Anda bertambah besar.</li>
  <li>Jika belum, temukan cara yang menyenangkan untuk <strong>membagikan kabar kepada pasangan Anda</strong> tentang kehamilan Anda.</li>
  <li>Pantau <strong>asupan kafein Anda</strong> selama kehamilan, batasi hingga sekitar 200 mg per hari.</li>
  <li>Rencanakan untuk kemungkinan biaya tambahan terkait kehamilan dan perlengkapan bayi. Pertimbangkan untuk membuat anggaran dan mencari dukungan dari keluarga, teman, dan orangtua lainnya.</li>
</ul>""",
    "tips_mingguan_en": """<h2>9 Weeks Pregnant: Things to Consider</h2>
<p>Now that you're in your third month of pregnancy, there's a lot to think about. Here are some important things to consider:</p>
<ul>
  <li>Make sure you regularly <strong>get fitted for the correct size bra</strong> to stay comfortable, especially as your breasts grow.</li>
  <li>If you haven't already, find a fun way to <strong>share the news with your partner</strong> about your pregnancy.</li>
  <li>Keep an eye on your <strong>caffeine intake</strong> during pregnancy, limiting it to about 200 mg per day.</li>
  <li>Plan for potential additional expenses related to pregnancy and baby gear. Consider creating a budget and seeking support from family, friends, and other parents.</li>
</ul>""",
    "bayi_img_path": "week_9.jpg",
    "ukuran_bayi_img_path": "week_9_grape.svg"
  },
  {
    "id": "10",
    "minggu_kehamilan": "10",
    "berat_janin": 35,
    "tinggi_badan_janin": 32,
    "ukuran_bayi_id": "Jeruk Kumkuat",
    "ukuran_bayi_en": "Kumquat",
    "poin_utama_id": """<h2>Perkembangan pada 10 Minggu Kehamilan</h2>
<p>Berikut adalah beberapa hal penting yang perlu diperhatikan tentang pertumbuhan dan perubahan bayi Anda, serta bagaimana perasaan Anda mungkin pada usia kehamilan 10 minggu:</p>
<ul>
  <li>Bayi Anda mulai menyerupai bayi lebih banyak, dengan kepala yang lebih bulat dan berbagai perkembangan seperti mata, jari, kaki, dan tunas gigi.</li>
  <li>Dengan ukuran sekitar 1 inci, bayi Anda sekarang memiliki organ dalam tempatnya.</li>
  <li>Gejala kehamilan mungkin lebih intens minggu ini, tetapi ingatlah bahwa mereka akan segera mulai mereda.</li>
  <li>Karena perut Anda mungkin akan mulai terlihat dalam beberapa minggu mendatang, saat yang tepat untuk memulai serangkaian foto perut hamil!</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 10 Weeks Pregnant</h2>
<p>Here are some key points to note about your baby's growth and changes, as well as how you might be feeling at 10 weeks pregnant:</p>
<ul>
  <li>Your baby is beginning to resemble more like a baby, with a rounder head and various developments such as eyes, fingers, toes, and tooth buds.</li>
  <li>Measuring about 1 inch long, your baby now has internal organs in place.</li>
  <li>Pregnancy symptoms might be more intense this week, but remember they will soon start to ease.</li>
  <li>Since your belly bump might become noticeable in the coming weeks, it's a good time to think about starting a baby bump photo series!</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>Perkembangan Bayi Anda pada Usia Kehamilan 10 Minggu</h2>
<p>Pada minggu ini, bayi Anda mengalami kemajuan perkembangan yang signifikan. Berikut adalah beberapa tonggak perkembangan yang menarik yang terjadi di dalam kandungan Anda:</p>
<ul>
  <li>Kepala bayi menjadi lebih bulat dan menyerupai manusia, sementara organ-organ internal kemungkinan sudah mulai terbentuk dan mulai berfungsi.</li>
  <li>Tunas gigi kecil mulai muncul.</li>
  <li>Jari-jari dan jari kaki memanjang, dan selaput yang ada di antara mereka mulai menghilang.</li>
  <li>Meskipun masih dalam tahap perkembangan, mata, kelopak mata, dan telinga bayi terus mengalami pembentukan.</li>
</ul>""",
    "perkembangan_bayi_en": """<h2>10 Weeks Pregnant: Your Baby's Development</h2>
<p>During this week, your baby is undergoing significant developmental progress. Here are some exciting milestones taking place inside your womb:</p>
<ul>
  <li>The baby's head is becoming more rounded and human-like, while internal organs are likely forming and beginning to function.</li>
  <li>Small tooth buds have started to emerge.</li>
  <li>Fingers and toes are elongating, and the webbing between them is starting to disappear.</li>
  <li>Although still in development, the baby's eyes, eyelids, and ears are continuing to take shape.</li>
</ul>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda pada Usia Kehamilan 10 Minggu</h2>
<p>Pada usia kehamilan 10 minggu, rahim Anda sekarang sekitar sebesar jeruk besar, dibandingkan dengan ukurannya sebelum hamil, yang sekitar sebesar buah pir kecil. Pada titik ini, Anda mungkin sudah memiliki atau akan segera memiliki janji dengan penyedia layanan kesehatan Anda, yang mencakup pemeriksaan internal dan eksternal pada perut untuk menentukan ukuran dan posisi bayi Anda.</p>
<p>Penyedia layanan kesehatan Anda juga mungkin melakukan tes darah untuk memeriksa adanya infeksi, menentukan golongan darah dan faktor Rh Anda, dan memastikan bahwa vaksinasi Anda terkini. Meskipun ada banyak hal yang perlu dipertimbangkan, penyedia Anda akan memandu Anda melalui proses ini dan menjadwalkan janji dan tes masa depan yang diperlukan.</p>""",
    "perubahan_tubuh_en": """<h2>Your Body at 10 Weeks Pregnant</h2>
<p>At 10 weeks pregnant, your uterus is now approximately the size of a large orange, compared to its pre-pregnancy size, which was about the size of a small pear. By this point, you may have already had or will soon have a prenatal appointment with your healthcare provider, during which they will conduct both internal and external abdominal examinations to assess the size and position of your baby.</p>
<p>Your healthcare provider may also perform blood tests to check for infections, determine your blood type and Rh factor, and ensure that your immunizations are up to date. While there may be a lot to consider, your provider will guide you through the process and schedule any necessary future appointments and tests.</p>""",
    "gejala_umum_id": """<h2>Gejala pada Usia Kehamilan 10 Minggu</h2>
<p>Minggu ke-10 kehamilan bisa menjadi tantangan bagi beberapa wanita, karena gejala cenderung mencapai puncaknya pada saat ini, terutama mual. Namun, kabar baiknya adalah banyak gejala, termasuk mual di pagi hari, seringkali membaik setelah trimester pertama, membuka jalan bagi trimester kedua yang lebih nyaman. Berikut adalah beberapa gejala yang mungkin Anda alami pada usia kehamilan 10 minggu:</p>
<ul>
  <li><strong>Mual di pagi hari:</strong> Mual dan nyeri perut mungkin masih ada pada tahap ini. Jika Anda mengalami mual di pagi hari yang parah, yang dikenal sebagai hiperemesis gravidarum, konsultasikan dengan penyedia layanan kesehatan Anda.</li>
  <li><strong>Nyeri ligamen bulat:</strong> Ketidaknyamanan ini disebabkan oleh perenggangan dan pelembutan ligamen yang mendukung rahim. Hal ini dapat menyebabkan nyeri pinggang bagian bawah atau nyeri samping. Peregangan lembut dan gerakan dapat membantu mengurangi nyeri ini.</li>
  <li><strong>Penambahan berat badan minimal:</strong> Meskipun pakaian terasa lebih ketat, penambahan berat badan mungkin minimal atau bahkan ada penurunan sedikit karena mual di pagi hari. Diskusikan setiap kekhawatiran tentang penambahan berat badan dengan penyedia layanan kesehatan Anda.</li>
  <li><strong>Kecapekan:</strong> Tingkat progesteron yang meningkat dapat menyebabkan kelelahan, mendorong tidur siang yang sering. Istirahat yang cukup penting selama kehamilan.</li>
  <li><strong>Sakit kepala:</strong> Sakit kepala terkait kehamilan bisa terjadi sesekali. Beristirahat di ruangan yang gelap dan menggunakan kompres es mungkin memberikan bantuan.</li>
  <li><strong>Perubahan suasana hati:</strong> Fluktuasi hormon dapat berkontribusi pada perubahan suasana hati. Arahkan perhatian Anda pada kegiatan yang menyenangkan dan pertimbangkan untuk mendapatkan pijatan dari terapis terlatih.</li>
  <li><strong>Keputihan:</strong> Peningkatan keputihan vagina normal karena peningkatan aliran darah dan kadar hormon yang lebih tinggi. Hubungi penyedia layanan kesehatan Anda jika Anda melihat bau yang tidak biasa, perubahan warna, atau gatal.</li>
  <li><strong>Jerawat:</strong> Perubahan hormon selama kehamilan dapat menyebabkan atau memperburuk jerawat. Gejala ini biasanya hilang setelah melahirkan.</li>
</ul>""",
    "gejala_umum_en": """<h2>10 Weeks Pregnant: Your Symptoms</h2>
<p>Week 10 of pregnancy can be challenging for some women, as symptoms tend to peak around this time, particularly nausea. However, the good news is that many symptoms, including morning sickness, often improve after the first trimester, making way for a more comfortable second trimester. Here are some symptoms you might be experiencing at 10 weeks pregnant:</p>
<ul>
  <li><strong>Morning sickness:</strong> Nausea and stomach pain may still be present at this stage. If you're experiencing severe morning sickness, known as hyperemesis gravidarum, consult your healthcare provider.</li>
  <li><strong>Round ligament pain:</strong> This discomfort arises from the stretching and softening of the ligaments supporting the uterus. It may cause lower back pain or side pain. Gentle stretching and movement can help alleviate this pain.</li>
  <li><strong>Minimal weight gain:</strong> Despite tighter clothes, weight gain may be minimal or even a slight loss due to morning sickness. Discuss any concerns about weight gain with your healthcare provider.</li>
  <li><strong>Exhaustion:</strong> Increased progesterone levels may lead to fatigue, prompting frequent naps. Adequate rest is essential during pregnancy.</li>
  <li><strong>Headaches:</strong> Pregnancy-related headaches can occur occasionally. Resting in a darkened room and applying ice packs may provide relief.</li>
  <li><strong>Mood swings:</strong> Hormonal fluctuations can contribute to mood swings. Distract yourself with enjoyable activities and consider seeking a massage from a trained therapist.</li>
  <li><strong>Discharge:</strong> Increased vaginal discharge is normal due to heightened blood supply and hormone levels. Contact your healthcare provider if you notice unusual odor, color changes, or itching.</li>
  <li><strong>Acne:</strong> Hormonal changes during pregnancy can cause or worsen acne. This symptom typically resolves after childbirth.</li>
</ul>""",
    "tips_mingguan_id": """<h2>Usia Kehamilan 10 Minggu: Hal yang Perlu Dipertimbangkan</h2>
<p>Saat Anda menjalani kehamilan, ada beberapa faktor penting yang perlu diperhatikan, termasuk penyesuaian pola makan dan perawatan diri. Berikut adalah beberapa pertimbangan:</p>
<ul>
  <li><strong>Batasi konsumsi kafein:</strong> Jika belum melakukannya, pertimbangkan untuk mengurangi konsumsi kafein Anda. Banyak penyedia layanan kesehatan menyarankan untuk membatasi kafein hingga 200 mg per hari untuk meningkatkan kualitas tidur.</li>
  <li><strong>Preventif varises:</strong> Saat rahim Anda membesar, itu mungkin menghambat aliran darah ke bagian bawah tubuh Anda, menyebabkan pembengkakan dan nyeri pada pembuluh darah di kaki Anda. Meskipun varises tidak dapat sepenuhnya dicegah, Anda dapat mengurangi ketidaknyamanan dan mencegah memburuk dengan:
    <ul>
      <li>Menghindari silangkan kaki dan duduk atau berdiri dalam waktu lama.</li>
      <li>Menggunakan stoking penyangga dan mengangkat kaki Anda setiap kali memungkinkan.</li>
      <li>Tetap aktif secara fisik dan menggabungkan latihan kehamilan yang aman ke dalam rutinitas Anda dengan persetujuan penyedia layanan kesehatan.</li>
    </ul>
  </li>
  <li><strong>Mulai seri foto perut bayi:</strong> Mengantisipasi pertumbuhan perut Anda, pertimbangkan untuk memulai seri foto perut bayi sekitar usia kehamilan 10 minggu. Berikut cara melakukannya:
    <ul>
      <li>Pilih hari tertentu dalam seminggu, posisi berdiri yang disukai, dan pakaian untuk konsistensi.</li>
      <li>Ambil foto profil samping sendiri atau dengan bantuan, menangkap perkembangan perut Anda.</li>
      <li>Pertimbangkan untuk menyertakan foto pasca melahirkan dengan bayi Anda untuk mendokumentasikan perjalanan secara komprehensif.</li>
    </ul>
  </li>
</ul>""",
    "tips_mingguan_en": """<h2>10 Weeks Pregnant: Things to Consider</h2>
<p>As you navigate through pregnancy, there are several essential factors to keep in mind, including dietary adjustments and self-care practices. Here are some considerations:</p>
<ul>
  <li><strong>Limit caffeine intake:</strong> If you haven't already, consider reducing your caffeine consumption. Many healthcare providers advise limiting caffeine to 200 mg per day to improve sleep quality.</li>
  <li><strong>Prevent varicose veins:</strong> As your uterus grows, it may obstruct blood flow to your lower body, leading to swollen and sore veins in your legs. While varicose veins cannot be prevented entirely, you can alleviate discomfort and prevent worsening by:
    <ul>
      <li>Avoiding crossing your legs and prolonged sitting or standing.</li>
      <li>Wearing support hose and elevating your legs whenever possible.</li>
      <li>Staying physically active and incorporating safe pregnancy exercises into your routine with your healthcare provider's approval.</li>
    </ul>
  </li>
  <li><strong>Start a baby bump photo series:</strong> Anticipating the growth of your belly, consider initiating a baby bump photo series around 10 weeks of pregnancy. Here's how to do it:
    <ul>
      <li>Choose a specific day of the week, preferred standing position, and outfit for consistency.</li>
      <li>Take a side profile photo either by yourself or with assistance, capturing your belly's progression.</li>
      <li>Consider including postpartum shots with your newborn to document the journey comprehensively.</li>
    </ul>
  </li>
</ul>""",
    "bayi_img_path": "week_10.jpg",
    "ukuran_bayi_img_path": "week_10_kumquat.svg"
  },
  {
    "id": "11",
    "minggu_kehamilan": "11",
    "berat_janin": 45,
    "tinggi_badan_janin": 41,
    "ukuran_bayi_id": "Buah Ara",
    "ukuran_bayi_en": "Fig",
    "poin_utama_id": """<h2>Pentingnya Usia Kehamilan 11 Minggu</h2>
<p>Berikut adalah ringkasan singkat tentang apa yang terjadi selama kehamilan minggu ke-11:</p>
<ul>
  <li>Kepala bayi Anda sedang tumbuh, fitur wajah sedang berkembang, dan tunas gigi kecil sedang terbentuk, bersamaan dengan genitalia bayi Anda.</li>
  <li>Anda mungkin akan melihat peningkatan ukuran payudara Anda pada saat ini.</li>
  <li>Perut Anda mungkin mulai terlihat sekarang atau tidak lama lagi, dan Anda bisa mempertimbangkan untuk mengambil beberapa foto perut Anda pada usia kehamilan 11 minggu dan beberapa minggu mendatang!</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 11 Weeks Pregnant</h2>
<p>Here's a brief overview of what's happening during the 11th week of pregnancy:</p>
<ul>
  <li>Your baby's head is growing, facial features are developing, and tiny tooth buds are forming, along with the genitalia.</li>
  <li>You may observe an increase in the size of your breasts at this stage.</li>
  <li>Your baby bump might begin to become noticeable around this time, prompting you to capture some belly pictures at 11 weeks pregnant and in the weeks to come!</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>Kehamilan 11 Minggu: Perkembangan Bayi Anda</h2>
<p>Ada banyak perkembangan yang terjadi pada bayi Anda minggu ini. Anda mungkin bertanya-tanya, “Seperti apa rupa bayi saya pada kehamilan 11 minggu?” Inilah yang sedang terjadi:</p>
<ul>
  <li>Fitur wajah bayi Anda perlahan-lahan matang. Telinga bergerak ke posisi akhir di sisi kepala, dan mata berada jauh terpisah dengan kelopak mata tertutup rapat.</li>
  <li>Alat kelamin juga mulai terbentuk, meskipun masih terlalu dini untuk mengetahui jenis kelamin bayi Anda. Anda bisa mulai memikirkan nama bayi untuk kedua jenis kelamin. Nikmati membuat daftar nama favorit Anda.</li>
  <li>Tunas kecil yang akan menjadi gigi sedang berkembang.</li>
  <li>Kepala bayi Anda adalah setengah dari panjang tubuhnya pada tahap ini. Dalam beberapa minggu mendatang, tubuhnya akan tumbuh secara signifikan. Untuk mendukung pertumbuhan ini, plasenta berkembang, dan sel darah merahnya meningkat untuk memenuhi kebutuhan nutrisi bayi.</li>
</ul>""",
    "perkembangan_bayi_en": """<h2>11 Weeks Pregnant: Your Baby’s Development</h2>
<p>There's a lot of development happening with your baby this week. You might wonder, “What does my baby look like at 11 weeks pregnant?” Here's the latest:</p>
<ul>
  <li>Your baby's facial features are slowly maturing. The ears are moving to their final position on the sides of the head, and the eyes are set wide apart with eyelids fused shut.</li>
  <li>The genitals are forming, but it's still too early to tell if you're having a boy or a girl. You can start thinking about baby names for both genders. Have fun creating a list of your favorite names.</li>
  <li>Tiny buds that will become teeth are developing.</li>
  <li>Your baby's head is half the length of their body at this stage. In the coming weeks, the body will grow significantly. To support this growth, the placenta expands, and its red blood cells increase to meet the baby’s nutritional needs.</li>
</ul>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda pada Kehamilan 11 Minggu</h2>
<p>Apakah Anda mengalami ngidam makanan yang tidak biasa minggu ini? Ngidam makanan sangat umum—sekitar 50 hingga 90 persen wanita mengalaminya pada suatu saat selama kehamilan.</p>
<p>Alasan pasti untuk ngidam makanan selama kehamilan tidak diketahui. Beberapa ahli berpikir ngidam adalah cara tubuh memberi sinyal apa yang dibutuhkannya, sementara yang lain percaya itu disebabkan oleh perubahan hormon. Selama ngidam Anda masih dalam pola makan sehat selama kehamilan, tidak masalah untuk memenuhinya!</p>
<p>Namun, jika Anda mengidam benda non-makanan seperti tanah liat atau tanah, hubungi penyedia layanan kesehatan Anda karena ini memerlukan perhatian medis.</p>""",
    "perubahan_tubuh_en": """<h2>Your Body at 11 Weeks Pregnant</h2>
<p>Are you experiencing unusual food cravings this week? These cravings are very common—about 50 to 90 percent of women have them at some point during pregnancy.</p>
<p>The exact reason for pregnancy cravings isn't known. Some experts think cravings are your body’s way of signaling what it needs, while others believe they're due to changing hormone levels. As long as your cravings fit into a healthy pregnancy diet, it's okay to indulge!</p>
<p>However, if you crave non-food items like clay or dirt, contact your healthcare provider as this requires medical attention.</p>""",
    "gejala_umum_id": """<h2>Gejala Kehamilan 11 Minggu</h2>
<p>Setiap kehamilan itu unik. Apa yang Anda alami di sebelas minggu mungkin berbeda dari gejala orang lain. Berikut adalah beberapa gejala umum yang mungkin Anda alami di kehamilan 11 minggu:</p>
<ul>
  <li><strong>Pertumbuhan payudara:</strong> Payudara Anda mungkin mulai membesar sekarang, dan akan terus tumbuh selama kehamilan. Ini sebagian karena kelenjar susu yang bersiap untuk menyusui. Anda mungkin menambah hingga tiga pon jaringan payudara selama kehamilan.</li>
  <li><strong>Peningkatan keputihan:</strong> Anda mungkin melihat lebih banyak keputihan pada 11 minggu. Ini normal jika tidak berbau dan berwarna bening atau putih. Jika Anda melihat keputihan berwarna coklat, darah, atau mengalami gatal-gatal, sakit perut, atau bau tidak sedap, hubungi penyedia layanan kesehatan Anda.</li>
  <li><strong>Garis gelap pada perut:</strong> Anda mungkin mengembangkan garis gelap yang membentang di perut, yang dikenal sebagai linea nigra atau "garis kehamilan." Ini terkait dengan perubahan hormon dan kemungkinan akan memudar setelah melahirkan.</li>
  <li><strong>Kram kaki:</strong> Anda mungkin mengalami kram kaki yang ketat dan menyakitkan, terutama di malam hari. Peregangan, olahraga, dan tetap terhidrasi bisa membantu. Pastikan diet Anda mengandung cukup kalsium dan magnesium.</li>
  <li><strong>Kelelahan:</strong> Peningkatan kadar hormon progesteron bisa membuat Anda mengantuk. Tidur yang terganggu karena sering buang air kecil, kram kaki, atau mulas dapat menambah kelelahan Anda. Menghindari kafein dan memiliki rutinitas tidur yang santai dapat membantu.</li>
  <li><strong>Perubahan suasana hati:</strong> Perubahan hormon dapat menyebabkan perubahan suasana hati. Hindari stres dan pastikan Anda mendapatkan cukup zat besi. Yoga, meditasi, dan musik yang menenangkan dapat membantu. Jika perubahan suasana hati mengganggu kehidupan sehari-hari, carilah nasihat dari penyedia layanan kesehatan Anda.</li>
  <li><strong>Mual di pagi hari:</strong> Anda mungkin masih mengalami mual di pagi hari, termasuk mual dan muntah, pada waktu kapan saja. Ini biasanya membaik di trimester kedua, yang akan segera tiba!</li>
</ul>""",
    "gejala_umum_en": """<h2>11 Weeks Pregnant: Your Symptoms</h2>
<p>Every pregnancy is unique. What you experience at eleven weeks might differ from someone else’s symptoms. Here are some common symptoms you may have at 11 weeks pregnant:</p>
<ul>
  <li><strong>Breast growth:</strong> Your breasts might be getting bigger now, and they will continue to grow throughout your pregnancy. This is partly due to the milk glands preparing for breastfeeding. You might gain up to three pounds of breast tissue during your pregnancy.</li>
  <li><strong>Increased vaginal discharge:</strong> You may notice more vaginal discharge at 11 weeks. This is normal if it is odorless and clear or white. If you see brown discharge, blood, or experience itchiness, abdominal pain, or a foul odor, contact your healthcare provider.</li>
  <li><strong>Dark abdominal line:</strong> You might develop a dark line running down your belly, known as the linea nigra or "pregnancy line." This is related to hormonal changes and will likely fade after birth.</li>
  <li><strong>Leg cramps:</strong> You might experience tight, painful leg cramps, especially at night. Stretching, exercise, and staying hydrated can help. Ensure your diet includes enough calcium and magnesium.</li>
  <li><strong>Fatigue:</strong> Increased levels of the hormone progesterone can make you sleepy. Disrupted sleep from frequent urination, leg cramps, or heartburn can add to your fatigue. Avoiding caffeine and having a relaxing bedtime routine can help.</li>
  <li><strong>Mood swings:</strong> Hormonal changes can cause mood swings. Avoid stress and make sure you’re getting enough iron. Yoga, meditation, and relaxing music can help. If mood swings interfere with daily life, seek advice from your healthcare provider.</li>
  <li><strong>Morning sickness:</strong> You may still experience morning sickness, including nausea and vomiting, at any time of day. This usually improves in the second trimester, which is coming up soon!</li>
</ul>""",
    "tips_mingguan_id": """<h2>11 Minggu Hamil: Hal-hal yang Perlu Dipertimbangkan</h2>
<p>Pada 11 minggu kehamilan, ada banyak hal yang perlu diingat selama perjalanan kehamilan Anda. Lihat daftar dan tips kami di bawah ini, dan jaga diri Anda dengan diet sehat serta bagikan kabar kehamilan Anda dengan teman dan keluarga.</p>
<ul>
  <li>Selama kehamilan, Anda membutuhkan sekitar 80 hingga 85 miligram vitamin C setiap hari untuk membantu perkembangan tulang dan gigi bayi Anda. Tambahkan jeruk dan buah-buahan sitrus lainnya, stroberi, tomat, dan b
  <li>Pikirkan tentang tempat Anda akan melahirkan. Anda tidak harus memutuskan sekarang, tetapi mulailah meneliti pilihan Anda dan mengunjungi tempat-tempat tersebut. Mintalah saran dari penyedia layanan kesehatan Anda dan berbicaralah dengan ibu-ibu lain di daerah Anda untuk mendapatkan pendapat mereka juga.</li>
</ul>""",
    "tips_mingguan_en": """<h2>11 Weeks Pregnant: Things to Consider</h2>
<p>At 11 weeks pregnant, there are many things to keep in mind during your pregnancy journey. Check out our list and tips below, and take care of yourself with a healthy diet and sharing your pregnancy news with friends and family.</p>
<ul>
  <li>While you’re pregnant, you need about 80 to 85 milligrams of vitamin C each day to help your baby’s bones and teeth develop. Add oranges and other citrus fruits, strawberries, tomatoes, and broccoli to your diet to boost your vitamin C intake. If you’re unsure if you’re getting enough vitamin C, check with your healthcare provider.</li>
  <li>Think about where you will give birth. You don’t have to decide right now, but start researching your options and visiting places. Ask your healthcare provider for advice and talk to other moms in your area to get their opinions too.</li>
</ul>""",
    "bayi_img_path": "week_11.jpg",
    "ukuran_bayi_img_path": "week_11_fig.svg"
  },
  {
    "id": "12",
    "minggu_kehamilan": "12",
    "berat_janin": 58,
    "tinggi_badan_janin": 54,
    "ukuran_bayi_id": "Jeruk Nipis",
    "ukuran_bayi_en": "Lime",
    "poin_utama_id": """<h2>Highlight pada 12 Minggu Kehamilan</h2>
<p>Berikut beberapa hal menarik yang terjadi saat Anda hamil 12 minggu:</p>
<ul>
  <li>Anda akan segera meninggalkan trimester pertama dan memasuki trimester kedua, di mana gejala seperti mual dan kelelahan biasanya membaik. Tetap semangat!</li>
  <li>Bayi Anda sekarang sebesar buah markisa dan tumbuh dengan cepat!</li>
  <li>Perut bayi Anda mungkin mulai terlihat sekarang atau segera, jadi perhatikan perubahan di perut Anda minggu ini dan minggu-minggu mendatang.</li>
  <li>Pertimbangkan untuk memulai latihan Kegel untuk memperkuat dasar panggul Anda untuk kehamilan dan persalinan.</li>
  <li>Jika musim flu mendekat (biasanya Oktober hingga Maret), tanyakan kepada penyedia layanan kesehatan Anda tentang mendapatkan suntikan flu.</li>
  <li>Masih terlalu dini untuk mengetahui jenis kelamin bayi Anda, tetapi Anda tetap bisa bersenang-senang menebak dan memikirkan nama bayi!</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 12 Weeks Pregnant</h2>
<p>Here are some exciting things happening when you’re 12 weeks pregnant:</p>
<ul>
  <li>You’re about to leave the first trimester and enter the second, where symptoms like nausea and fatigue usually get better. Hang in there!</li>
  <li>Your baby is now the size of a passion fruit and is growing quickly!</li>
  <li>Your baby bump might start to show now or soon, so watch for changes in your belly this week and in the coming weeks.</li>
  <li>Consider starting Kegel exercises to strengthen your pelvic floor for pregnancy and delivery.</li>
  <li>If flu season is approaching (usually October through March), ask your healthcare provider about getting a flu shot.</li>
  <li>It’s still early to know your baby’s gender, but you can still have fun guessing and thinking of baby names!</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>Perkembangan Bayi Anda pada 12 Minggu Kehamilan</h2>
<p>Pada usia 12 minggu kehamilan, Anda hampir mencapai akhir trimester pertama, dan perkembangan bayi Anda berlangsung dengan cepat. Anda mungkin harus menunggu ultrasound pertengahan kehamilan untuk melihat bayi Anda, tetapi ketahuilah bahwa semua organ utama dan bagian tubuh bayi sedang terbentuk.</p>
<ul>
  <li>Semua <strong>organ vital</strong> dan <strong>bagian tubuh</strong> bayi Anda sudah terbentuk minggu ini; bahkan organ kelamin sudah berkembang.</li>
  <li>Mengetahui <strong>jenis kelamin biologis</strong> pada usia 12 minggu mungkin tidak mungkin, tetapi Anda dapat menantikannya pada ultrasound trimester kedua.</li>
  <li><strong>Aktivitas jantung</strong> bayi Anda mungkin sudah terdengar dengan perangkat Doppler sekarang, dan Anda mungkin mendengarnya selama pemeriksaan minggu ini.</li>
  <li>Bayi Anda sekarang memiliki <strong>kelopak mata yang terbentuk sempurna</strong>. Mereka tertutup rapat dan akan tetap begitu sampai akhir trimester kedua.</li>
  <li><strong>Tangan</strong> bayi Anda lebih berkembang daripada kaki, dan lengannya lebih panjang daripada kakinya. Tempat kuku kecil mulai menumbuhkan <strong>kuku jari tangan dan kaki</strong>, yang akan terus tumbuh selama trimester berikutnya.</li>
  <li>Bayi Anda juga mulai <strong>bergerak</strong> sedikit, tetapi masih terlalu awal bagi Anda untuk merasakan gerakan ini.</li>
  <li>Dalam beberapa minggu mendatang, <strong>organ dan otot</strong> bayi Anda akan terus berkembang.</li>
</ul>""",
    "perkembangan_bayi_en": """<h2>Your Baby’s Development at 12 Weeks Pregnant</h2>
<p>At 12 weeks pregnant, you're nearing the end of the first trimester, and your baby's development is moving quickly. You might have to wait for the mid-pregnancy ultrasound to see your baby, but know that all the major organs and body parts are forming.</p>
<ul>
  <li>All of your baby’s <strong>vital organs</strong> and <strong>body parts</strong> are in place this week; even the sex organs are developed.</li>
  <li>Finding out the <strong>biological sex</strong> at 12 weeks is unlikely, but you can look forward to knowing more during your second-trimester ultrasound.</li>
  <li>Your baby’s <strong>cardiac activity</strong> might be audible with a Doppler device now, and you might hear it during a checkup this week.</li>
  <li>Your baby now has <strong>fully formed eyelids</strong>. They are fused shut and will stay that way until late in the second trimester.</li>
  <li>Your baby’s <strong>hands</strong> are more developed than the feet, and the arms are longer than the legs. Little nailbeds are starting to grow <strong>fingernails and toenails</strong>, which will keep growing during the next trimester.</li>
  <li>Your baby is also starting to <strong>move</strong> a bit, but it’s too early for you to feel these movements.</li>
  <li>Over the coming weeks, your baby’s <strong>organs and muscles</strong> will keep developing.</li>
</ul>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda pada 12 Minggu Kehamilan</h2>
<p>Pada usia 12 minggu kehamilan, ketika mual dan ketidaknyamanan awal kehamilan mulai berkurang, Anda mungkin merasa nafsu makan Anda kembali. Pastikan Anda makan dengan baik dan menjaga pola makan sehat, tetapi ingat, Anda tidak perlu makan untuk dua orang.</p>
<p>Para ahli menyarankan untuk menambahkan sekitar 300 kalori ekstra per hari rata-rata selama kehamilan. Penyedia layanan kesehatan Anda dapat memberikan saran yang dipersonalisasi tentang apa yang terbaik untuk Anda.</p>""",
    "perubahan_tubuh_en": """<h2>Your Body at 12 Weeks Pregnant</h2>
<p>At 12 weeks pregnant, as nausea and early pregnancy discomfort start to fade, you might notice your appetite returning. Make sure you're eating well and maintaining a healthy diet, but remember, you don’t need to eat for two.</p>
<p>Experts suggest adding only about 300 extra calories a day on average during pregnancy. Your healthcare provider can give you personalized advice on what’s best for you.</p>""",
    "gejala_umum_id": """<h2>12 Minggu Hamil: Gejala Anda</h2>
<p>Bertanya-tanya apa yang harus Anda rasakan pada 12 minggu kehamilan? Setiap kehamilan itu unik, tetapi berikut adalah beberapa gejala yang mungkin Anda alami minggu ini:</p>
<ul>
  <li><strong>Gusi berdarah dan sensitif.</strong> Saat volume darah Anda meningkat dan kadar hormon berubah, gusi Anda mungkin membengkak dan menjadi lebih sensitif, terkadang berdarah saat Anda menyikat atau membersihkan gigi dengan benang. Tetap menyikat dan membersihkan gigi secara teratur dan bicarakan dengan dokter gigi Anda jika perlu. Sikat gigi yang lebih lembut dan berkumur dengan air garam (satu sendok teh garam dalam secangkir air hangat) bisa membantu.</li>
  <li><strong>Merasa pusing.</strong> Perubahan dalam sirkulasi dan kadar hormon dapat membuat Anda merasa pusing, lelah, atau pusing. Mengenakan pakaian longgar, tetap terhidrasi, menghindari berdiri lama, dan makan secara teratur bisa membantu. Hubungi penyedia layanan kesehatan Anda jika Anda juga mengalami sakit perut, pendarahan vagina, atau jika perasaan pusing terus berlanjut.</li>
  <li><strong>Sensitivitas terhadap bau.</strong> Meskipun mual di pagi hari mungkin mulai mereda, indra penciuman Anda mungkin masih sangat sensitif. Jika bau tertentu membuat Anda mual, cobalah makan makanan dingin atau bersuhu ruangan, menggunakan kipas saat memasak, dan meminta orang lain untuk membuang sampah.</li>
  <li><strong>Kembung.</strong> Perubahan hormonal dan rahim yang tumbuh dapat menyebabkan kembung atau masalah pencernaan seperti sembelit atau diare. Makan perlahan untuk menghindari menelan udara dapat membantu mengurangi kembung.</li>
  <li><strong>Bercak atau pendarahan.</strong> Bercak ringan atau pendarahan mungkin terjadi, mungkin setelah berhubungan seks. Ini biasanya tidak perlu dikhawatirkan, tetapi jika pendarahannya lebih berat atau disertai dengan kram, sakit perut, atau sakit punggung bawah, hubungi penyedia layanan kesehatan Anda.</li>
</ul>""",
    "gejala_umum_en": """<h2>12 Weeks Pregnant: Your Symptoms</h2>
<p>Wondering what you should be feeling at 12 weeks pregnant? Each pregnancy is unique, but here are some symptoms you might experience this week:</p>
<ul>
  <li><strong>Bleeding and sensitive gums.</strong> As your blood volume increases and hormone levels change, your gums might swell and become more sensitive, sometimes bleeding when you brush or floss. Keep brushing and flossing regularly and talk to your dentist if needed. A softer toothbrush and rinsing with salt water (a teaspoon of salt in a cup of warm water) can help.</li>
  <li><strong>Feeling lightheaded.</strong> Changes in circulation and hormone levels can make you feel lightheaded, tired, or dizzy. Wearing loose clothing, staying hydrated, avoiding long periods of standing, and eating regularly can help. Contact your healthcare provider if you also have abdominal pain, vaginal bleeding, or if lightheadedness persists.</li>
  <li><strong>Sensitivity to smells.</strong> Even as morning sickness fades, your sense of smell may still be very sensitive. If certain odors make you nauseous, try eating cold or room-temperature food, using a fan when cooking, and asking someone else to take out the trash.</li>
  <li><strong>Bloating.</strong> Hormonal changes and your growing uterus can cause bloating or digestive issues like constipation or diarrhea. Eating slowly to avoid swallowing air can help reduce bloating.</li>
  <li><strong>Spotting or bleeding.</strong> Light bleeding or spotting may occur, possibly after sex. This is usually not a concern, but if the bleeding is heavier or accompanied by cramping, stomach pain, or lower back pain, contact your healthcare provider.</li>
</ul>""",
    "tips_mingguan_id": """<h2>12 Minggu Hamil: Hal yang Perlu Dipertimbangkan</h2>
<p>Saat Anda mendekati akhir trimester pertama dan bersiap memasuki trimester kedua, ada banyak hal yang perlu dipertimbangkan dan dinantikan. Lihat daftar di bawah ini.</p>
<ul>
  <li><strong>Ikuti diet kehamilan seimbang</strong> yang mencakup protein seperti daging atau pengganti nabati. Sertakan berbagai macam sayuran dan buah setiap hari untuk vitamin, mineral, dan serat penting, dan jangan lupakan makanan kaya kalsium seperti produk susu rendah lemak, kacang-kacangan, kacang almond, dan tahu.</li>
  <li><strong>Mulai melakukan Kegel</strong> jika belum melakukannya. Latihan Kegel menguatkan otot-otot lantai pelvis yang mendukung rahim dan kandung kemih Anda, memberikan manfaat seperti mencegah buang air kecil secara tidak sengaja selama dan setelah kehamilan. Latihan Kegel melibatkan mengecilkan otot lantai pelvis seolah-olah menghentikan aliran urin atau gas. Tahan beberapa detik, lalu lepaskan.</li>
  <li><strong>Mulailah jurnal kehamilan.</strong> Dokumentasikan aktivitas dan emosi Anda untuk direnungkan setelah kelahiran. Pertimbangkan untuk mengambil foto perut mingguan (12 minggu adalah waktu yang ideal untuk memulai) dan tambahkan hasil pemindaian ultrasound ke jurnal nantinya.</li>
  <li>Rencanakan bagaimana Anda akan <strong>mengumumkan kehamilan Anda kepada rekan kerja</strong>, terutama jika Anda seorang orangtua yang bekerja. Pengumuman awal pada trimester kedua umum dilakukan.</li>
  <li>Jika Anda menjalani <strong>USG sekitar waktu ini</strong> yang mengungkapkan kehamilan kembar atau lebih, selamat! Kembar fraternal dan identik membawa kebahagiaan ganda.</li>
</ul>""",
    "tips_mingguan_en": """<h2>12 Weeks Pregnant: Things to Consider</h2>
<p>As you approach the end of your first trimester and get ready for the second, there's much to ponder and anticipate. Take a look at our list below.</p>
<ul>
  <li><strong>Follow a balanced pregnancy diet</strong> that includes proteins like meat or plant-based substitutes. Incorporate a variety of vegetables and fruits daily for essential vitamins, minerals, and fiber, and don't overlook calcium-rich foods such as low-fat dairy, beans, nuts, and tofu.</li>
  <li><strong>Start doing Kegels</strong> if you haven’t already. Kegel exercises strengthen the pelvic floor muscles supporting your uterus and bladder, offering benefits like preventing accidental urination during and after pregnancy. Kegel exercises involve squeezing the pelvic floor muscles as if stopping urine flow or gas passage. Hold for a few seconds, then release.</li>
  <li><strong>Begin a pregnancy journal.</strong> Document your activities and emotions to reflect on your journey post-birth. Consider taking weekly belly pictures (12 weeks is ideal to start) and add ultrasound scan prints to the journal later.</li>
  <li>Plan how you’ll <strong>announce your pregnancy to colleagues</strong>, especially if you’re a working parent. Early second-trimester announcements are common.</li>
  <li>If you have an <strong>ultrasound around this time</strong> revealing a twin pregnancy or more, congratulations! Fraternal and identical twins bring double the joy.</li>
</ul>""",
    "bayi_img_path": "week_12.jpg",
    "ukuran_bayi_img_path": "week_12_lime.svg"
  },
  {
    "id": "13",
    "minggu_kehamilan": "13",
    "berat_janin": 73,
    "tinggi_badan_janin": 67,
    "ukuran_bayi_id": "Kacang Polong",
    "ukuran_bayi_en": "Peapod",
    "poin_utama_id": """<h2>Yang Perlu Diketahui Saat Hamil 13 Minggu</h2>
<ul>
  <li>Bayi Anda tumbuh dengan cepat, dan semua organ mereka sudah terbentuk sepenuhnya.</li>
  <li>Pada tahap ini, bayi Anda mulai bergerak dan meregangkan tangan dan kakinya.</li>
  <li>Gejala kehamilan seperti mual dan kelelahan mungkin mulai berkurang pada minggu ke-13.</li>
  <li>Anda mungkin melihat beberapa colostrum bocor dari payudara Anda, yang merupakan susu pertama bayi Anda setelah lahir.</li>
  <li>Pembesar perut Anda mungkin mulai terlihat sekitar saat ini, mendorong Anda untuk mengambil beberapa foto perut untuk melacak perubahan.</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 13 Weeks Pregnant</h2>
<ul>
  <li>Your baby is growing rapidly, and all their organs are now fully formed.</li>
  <li>At this stage, your baby starts moving and stretching their arms and legs.</li>
  <li>Pregnancy symptoms like morning sickness and fatigue may begin to lessen by the 13th week.</li>
  <li>You may observe some colostrum leaking from your breasts, which is your baby’s first milk after birth.</li>
  <li>Your baby bump might become noticeable around this time, prompting you to capture some belly pictures to track the changes.</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>Perkembangan Bayi Anda Saat Hamil 13 Minggu</h2>
<ul>
  <li>Pada minggu ini, organ-organ bayi Anda sudah terbentuk sepenuhnya dan berfungsi.</li>
  <li>Ginjal mulai memproduksi urine yang kemudian dilepaskan ke dalam cairan amnion, sementara limpa menghasilkan sel darah merah untuk transportasi oksigen.</li>
  <li>Usus bayi Anda telah berpindah ke dalam perut dari tali pusar untuk menyesuaikan pertumbuhan mereka.</li>
  <li>Beberapa tulang yang lebih besar, termasuk tulang tengkorak, mulai mengeras.</li>
  <li>Meskipun Anda tidak akan mendengar suara mereka sampai setelah lahir, pita suara bayi Anda sudah mulai berkembang.</li>
</ul>""",
    "perkembangan_bayi_en": """<h2>13 Weeks Pregnant: Your Baby’s Development</h2>
<ul>
  <li>This week, your baby’s organs are fully formed and functioning.</li>
  <li>The kidneys are beginning to produce urine, which is released into the amniotic fluid, while the spleen is generating red blood cells for oxygen transport.</li>
  <li>Your baby's intestines have relocated to the abdomen from the umbilical cord to accommodate their growth.</li>
  <li>Some of the larger bones, including those in the skull, are starting to harden.</li>
  <li>Although you won’t hear them until after birth, your baby’s vocal cords are developing.</li>
</ul>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda saat Hamil 13 Minggu</h2>
<p>Selamat, Anda hampir masuk ke trimester kedua, yang banyak calon ibu anggap sebagai periode kehamilan yang paling menyenangkan.</p>
<p>Ketidaknyamanan yang mungkin Anda rasakan di trimester pertama—seperti kelelahan, mual, dan sering buang air kecil—sering mulai mereda, dan Anda bahkan mungkin merasakan peningkatan energi selama trimester ini.</p>
<p>Pada tahap ini, pasokan darah Anda sepenuhnya terhubung ke plasenta, yang akan terus tumbuh selama kehamilan Anda. Saat Anda melahirkan, plasenta bisa memiliki berat sekitar satu setengah pon.</p>
<p>Dalam beberapa minggu mendatang, penyedia layanan kesehatan Anda mungkin mulai mengukur tinggi fundus—jarak dari tulang kemaluan Anda ke atas rahim Anda (fundus). Pengukuran ini membantu penyedia layanan Anda melacak pertumbuhan bayi Anda.</p>
<p>Masalah seperti sensitivitas payudara, sembelit, kembung, dan sakit maag mungkin masih berlanjut, karena tingkat hormon yang meningkat dapat memperlambat pencernaan.</p>""",
    "perubahan_tubuh_en": """<h2>Your Body at 13 Weeks Pregnant</h2>
<p>Congratulations, you're almost in your second trimester, which many expectant moms consider the most enjoyable part of pregnancy.</p>
<p>The discomforts you might have felt in the first trimester—like fatigue, nausea, and frequent urination—often start to ease up, and you might even experience a boost in energy during this trimester.</p>
<p>At this point, your blood supply is fully connected to the placenta, which will continue to grow throughout your pregnancy. By the time you deliver, the placenta could weigh around one and a half pounds.</p>
<p>In the upcoming weeks, your healthcare provider might start measuring your fundal height—the distance from your pubic bone to the top of your uterus (the fundus). This measurement helps your provider track your baby's growth.</p>
<p>Issues like breast tenderness, constipation, bloating, and heartburn may persist, as increased hormone levels can slow down digestion.</p>""",
    "gejala_umum_id": """<h2>Gejala Anda saat Hamil 13 Minggu</h2>
<p>Setiap kehamilan berbeda-beda, jadi sulit untuk mengetahui dengan pasti apa yang akan terjadi saat Anda hamil 13 minggu. Namun, berikut adalah beberapa gejala yang mungkin Anda alami:</p>
<ul>
  <li><strong>Sekresi vagina:</strong> Anda mungkin menyadari peningkatan cairan yang jernih hingga berwarna susu yang dikenal sebagai leukorrhea. Cairan ini membantu menjaga vagina dan saluran lahir agar tidak terkena infeksi dan iritasi. Penggunaan pembalut bisa membantu mengatasi kekotoran, tetapi hubungi penyedia layanan kesehatan Anda jika Anda melihat sekresi berwarna coklat atau berbau tidak sedap, atau jika Anda mengalami bercak atau pendarahan.</li>
  <li><strong>Perubahan hasrat seksual:</strong> Normal jika hasrat seksual Anda berfluktuasi selama kehamilan. Jika Anda dan pasangan merasa ingin, intimasi umumnya aman selama kehamilan. Namun, konsultasikan dengan penyedia layanan kesehatan Anda jika Anda memiliki kekhawatiran, terutama jika Anda memiliki riwayat keguguran atau berisiko mengalami persalinan prematur.</li>
  <li><strong>Sakit maag:</strong> Sakit maag dan masalah pencernaan mungkin datang dan pergi seiring perubahan posisi bayi dan rahim yang semakin membesar menekan lambung Anda. Hormon kehamilan juga dapat membuat otot di bagian atas lambung menjadi rileks, memungkinkan asam lambung naik ke kerongkongan dan menyebabkan sakit maag. Duduk tegak setelah makan dan menghindari makanan pemicu dapat membantu mengurangi ketidaknyamanan.</li>
  <li><strong>Kembung:</strong> Perubahan hormonal dapat memperlambat sistem pencernaan Anda, menyebabkan sembelit dan kram. Meningkatkan asupan serat dengan mengonsumsi lebih banyak buah, sayuran, dan biji-bijian, tetap terhidrasi, dan berolahraga secara teratur dapat membantu mengatasi sembelit.</li>
  <li><strong>Bocornya kolostrum:</strong> Beberapa wanita mungkin menyadari cairan kental berwarna kuning yang bocor dari payudara mereka, yang disebut kolostrum. Ini normal dan terjadi sebagai susu pertama setelah melahirkan. Menggunakan pelindung payudara dapat membantu mengelola bocornya cairan.</li>
</ul>""",
    "gejala_umum_en": """<h2>13 Weeks Pregnant: Your Symptoms</h2>
<p>Every pregnancy is different, so it’s hard to know exactly what to expect at 13 weeks pregnant. However, here are some symptoms you might be experiencing:</p>
<ul>
  <li><strong>Vaginal discharge:</strong> You may notice an increase in clear to milky-colored discharge known as leukorrhea. This discharge helps keep your vagina and birth canal clear of infection and irritation. Panty liners can help manage any messiness, but contact your healthcare provider if you notice brown or foul-smelling discharge, or if you experience spotting or bleeding.</li>
  <li><strong>Changing sex drive:</strong> It’s normal for your sexual desire to fluctuate during pregnancy. If both you and your partner feel inclined, intimacy is generally safe during pregnancy. However, consult your healthcare provider if you have concerns, especially if you have a history of miscarriage or are at risk of preterm labor.</li>
  <li><strong>Heartburn:</strong> Heartburn and indigestion may come and go as your baby’s position changes and your growing uterus puts pressure on your stomach. Pregnancy hormones can also relax the muscle at the top of your stomach, allowing stomach acid to cause heartburn. Sitting upright after eating and avoiding trigger foods can help alleviate discomfort.</li>
  <li><strong>Constipation:</strong> Hormonal changes can slow down your digestive system, leading to constipation and cramping. Increasing fiber intake by eating more fruits, vegetables, and whole grains, staying hydrated, and exercising regularly can help relieve constipation.</li>
  <li><strong>Leaking colostrum:</strong> Some women may notice a thick, yellow fluid leaking from their breasts, which is called colostrum. This is normal and occurs as the first milk after giving birth. Using breast pads can help manage any leakage.</li>
</ul>""",
    "tips_mingguan_id": """<h2>Hamil 13 Minggu: Hal yang Perlu Dipertimbangkan</h2>
<p>Saat hamil 13 minggu, ada beberapa hal penting yang perlu dipertimbangkan saat Anda menjalani perjalanan kehamilan:</p>
<ul>
  <li><strong>Berbagi kabar baik:</strong> Pertimbangkan apakah Anda telah membagikan kabar kehamilan dengan keluarga dan teman. Awal trimester kedua adalah waktu yang tepat untuk ini, karena risiko keguguran berkurang.</li>
  <li><strong>Memberi tahu tempat kerja:</strong> Rencanakan kapan dan bagaimana Anda akan memberi tahu atasan Anda tentang kehamilan Anda. Penting untuk tetap memberi informasi kepada mereka sehingga mereka dapat membuat pengaturan untuk cuti melahirkan Anda.</li>
  <li><strong>Latihan:</strong> Jika Anda berolahraga, lanjutkan dengan persetujuan penyedia layanan kesehatan Anda. Jika tidak, pertimbangkan untuk memulai rutinitas kebugaran dasar setelah berkonsultasi dengan penyedia Anda. Aktivitas seperti berjalan, berenang, dan yoga dapat bermanfaat.</li>
  <li><strong>Latihan perut:</strong> Berhati-hatilah dengan latihan yang melibatkan berbaring datar di punggung Anda, karena posisi ini dapat membatasi aliran darah akibat bobot rahim Anda. Konsultasikan dengan penyedia layanan kesehatan Anda untuk alternatif.</li>
  <li><strong>Latihan otot dasar panggul:</strong> Memperkuat otot dasar panggul dapat meningkatkan kontrol kandung kemih dan memberikan dukungan organ panggul. Latihan Kegel, yang melibatkan pengetatan dan relaksasi otot panggul, bermanfaat.</li>
</ul>""",
    "tips_mingguan_en": """<h2>13 Weeks Pregnant: Things to Consider</h2>
<p>At 13 weeks pregnant, there are several important things to think about as you progress through your pregnancy journey:</p>
<ul>
  <li><strong>Sharing the good news:</strong> Consider whether you've shared your pregnancy news with family and friends. The beginning of the second trimester is a good time for this, as the risk of miscarriage decreases.</li>
  <li><strong>Informing your workplace:</strong> Plan when and how you'll inform your employer about your pregnancy. It's essential to keep them informed so they can make arrangements for your maternity leave.</li>
  <li><strong>Exercise:</strong> If you're exercising, continue doing so with your healthcare provider's approval. If not, consider starting a basic fitness routine after consulting your provider. Activities like walking, swimming, and yoga can be beneficial.</li>
  <li><strong>Abdominal exercises:</strong> Be cautious with exercises that involve lying flat on your back, as this position can restrict blood flow due to the weight of your uterus. Consult your healthcare provider for alternatives.</li>
  <li><strong>Pelvic floor exercises:</strong> Strengthening pelvic floor muscles can improve bladder control and provide pelvic organ support. Kegel exercises, which involve squeezing and relaxing pelvic muscles, are beneficial.</li>
</ul>""",
    "bayi_img_path": "week_13.jpg",
    "ukuran_bayi_img_path": "week_13_pea_pod.svg"
  },
  {
    "id": "14",
    "minggu_kehamilan": "14",
    "berat_janin": 93,
    "tinggi_badan_janin": 147,
    "ukuran_bayi_id": "Lemon",
    "ukuran_bayi_en": "Lemon",
    "poin_utama_id": """<h2>Perkembangan pada Minggu ke-14 Kehamilan</h2>
<p>Berikut adalah beberapa hal menarik yang bisa dinantikan selama minggu ke-14 kehamilan Anda:</p>
<ul>
  <li><strong>Perkembangan bayi Anda:</strong> Bayi Anda sekarang mulai menggerakkan lengan dan kaki mereka dan mengembangkan indera penciuman dan pengecap. Mereka mulai menyerupai sosok kecil yang akan Anda temui setelah lahir.</li>
  <li><strong>Peningkatan energi:</strong> Anda mungkin akan merasakan peningkatan energi dan rambut yang lebih sehat selama trimester ini.</li>
  <li><strong>Puncak perut:</strong> Puncak perut Anda mungkin menjadi lebih terlihat sekarang atau dalam beberapa minggu mendatang. Pertimbangkan untuk mengambil foto perut Anda saat hamil 14 minggu dan selama kehamilan untuk mendokumentasikan perubahan ini.</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 14 Weeks Pregnant</h2>
<p>Here are some exciting things to anticipate during the 14th week of your pregnancy:</p>
<ul>
  <li><strong>Your baby's development:</strong> Your baby is now moving their arms and legs and developing their sense of smell and taste. They're starting to resemble the little person you'll meet after birth.</li>
  <li><strong>Increase in energy:</strong> You may notice an increase in energy and healthier-looking hair during this trimester.</li>
  <li><strong>Baby bump:</strong> Your baby bump might become more noticeable now or in the coming weeks. Consider taking pictures of your belly at 14 weeks pregnant and throughout your pregnancy to document these changes.</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>Perkembangan Bayi Anda pada Minggu ke-14 Kehamilan</h2>
<p>Temukan perkembangan menarik yang terjadi dengan bayi Anda pada usia kehamilan 14 minggu:</p>
<ul>
  <li><strong>Gerakan:</strong> Bayi Anda sedang mencoba gerakan baru minggu ini! Mata mereka mulai bergerak, dan lengan serta kaki mereka mulai bergerak.</li>
  <li><strong>Indra:</strong> Indra penciuman dan pengecap mulai berkembang, dan kulit bayi Anda semakin tebal.</li>
  <li><strong>Perkembangan rambut:</strong> Meskipun Anda harus menunggu untuk melihat apakah bayi Anda akan lahir dengan rambut tebal atau tidak, folikel rambut sedang terbentuk di bawah permukaan kulit mereka.</li>
  <li><strong>Penampilan:</strong> Minggu demi minggu, bayi Anda semakin mirip dengan sosok kecil yang akan Anda temui pada hari kelahiran mereka.</li>
  <li><strong>Jenis kelamin:</strong> Pada tahap ini, alat kelamin bayi Anda sudah terbentuk sepenuhnya, tetapi kemungkinan Anda belum tahu jenis kelaminnya.</li>
</ul>""",
    "perkembangan_bayi_en": """<h2>14 Weeks Pregnant: Your Baby’s Development</h2>
<p>Discover the exciting developments happening with your baby at 14 weeks pregnant:</p>
<ul>
  <li><strong>Movement:</strong> Your baby is exploring new movements this week! Their eyes are beginning to move, and their arms and legs are flexing.</li>
  <li><strong>Senses:</strong> The senses of smell and taste are starting to develop, and your baby's skin is becoming thicker.</li>
  <li><strong>Hair development:</strong> While you'll have to wait to see if your baby is born with a full head of hair, hair follicles are forming under their skin.</li>
  <li><strong>Appearance:</strong> Week by week, your baby is becoming more like the little person you'll meet on the big day of birth.</li>
  <li><strong>Gender:</strong> At this stage, your baby's genitals are fully formed, but it's unlikely that you'll know their gender yet.</li>
</ul>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda pada Minggu ke-14 Kehamilan</h2>
<p>Selamat atas kedatangan Anda ke trimester kedua, yang sering dianggap sebagai fase "emas" kehamilan. Berikut adalah apa yang mungkin Anda alami:</p>
<ul>
  <li><strong>Peningkatan energi:</strong> Banyak ibu hamil menemukan bahwa mereka memiliki lebih banyak energi selama trimester kedua, yang bisa menjadi perubahan yang menyenangkan dari kelelahan yang dialami pada trimester pertama. Manfaatkan waktu ini untuk menyelesaikan tugas sebelum tahap-tahap selanjutnya dari kehamilan di mana Anda mungkin merasa lebih besar dan kurang bertenaga.</li>
  <li><strong>Rambut sehat:</strong> Ini bukan hanya khayalan Anda! Kehamilan sering membawa pertumbuhan rambut yang lebih tebal, yang mungkin terlihat tumbuh lebih cepat dari biasanya. Nikmati perubahan fisik ini yang dialami oleh banyak wanita selama trimester ini!</li>
</ul>""",
    "perubahan_tubuh_en": """<h2>Your Body at 14 Weeks Pregnant</h2>
<p>Congratulations on reaching the second trimester, often considered the "golden" phase of pregnancy. Here's what you might experience:</p>
<ul>
  <li><strong>Increase in energy:</strong> Many expectant mothers find that they have more energy during the second trimester, which can be a welcome change from the fatigue experienced in the first trimester. Make the most of this time to accomplish tasks before the later stages of pregnancy when you may feel larger and less energetic.</li>
  <li><strong>Healthy hair:</strong> It's not just your imagination! Pregnancy often brings thicker hair growth, which may even appear to grow faster than usual. Enjoy this physical change that many women experience during this trimester!</li>
</ul>""",
    "gejala_umum_id": """<h2>Gejala Anda Saat Hamil 14 Minggu</h2>
<p>Pada usia kehamilan 14 minggu, gejala dapat bervariasi dari satu orang ke orang lain, sehingga sulit untuk mengetahui apa yang diharapkan. Namun, berikut adalah beberapa gejala yang mungkin Anda alami:</p>
<ul>
  <li><strong>Payudara bocor:</strong> Anda mungkin melihat cairan tebal berwarna kuning bocor dari payudara Anda, yang dikenal sebagai kolostrum. Ini adalah nutrisi awal untuk bayi Anda sebelum produksi ASI dimulai. Meskipun kebocoran tersebut mungkin membuat Anda terkejut, itu benar-benar normal. Pertimbangkan untuk menggunakan kapas penyerap untuk mengelola kebocoran cairan.</li>
  <li><strong>Kongesti sinus:</strong> Ini bisa disebabkan oleh alergi, pilek, atau gejala kehamilan lainnya. Peningkatan sirkulasi ke membran mukosa hidung yang disebabkan oleh hormon progesteron dapat menyebabkan pembengkakan saluran hidung, kondisi yang dikenal sebagai rinitis kehamilan. Meskipun tidak ada cara pasti untuk menghilangkannya, tetap terhidrasi dan menggunakan penghumidifier atau petroleum jelly di sekitar lubang hidung dapat memberikan sedikit bantuan.</li>
  <li><strong>Nafsu makan meningkat:</strong> Jika mual telah mereda, Anda mungkin merasa lebih lapar dari biasanya. Saat menikmati makanan, usahakan untuk mengonsumsi diet seimbang. Kebanyakan wanita dengan BMI sebelum hamil dalam kisaran normal hanya perlu tambahan 300 kalori per hari (atau 600 lebih banyak untuk mereka yang mengandung bayi kembar).</li>
  <li><strong>Kram kaki:</strong> Beberapa wanita mengalami kram pada kaki bagian bawah di trimester kedua, sering terjadi pada malam hari. Peregangan sebelum tidur dan tetap terhidrasi dapat membantu mencegahnya. Jika Anda mengalami kram betis, pijat otot atau mandi air hangat untuk meredakannya.</li>
</ul>""",
    "gejala_umum_en": """<h2>14 Weeks Pregnant: Your Symptoms</h2>
<p>At 14 weeks pregnant, symptoms can vary from person to person, making it hard to anticipate what to expect. However, here are some symptoms you might encounter:</p>
<ul>
  <li><strong>Leaky breasts:</strong> You may observe leakage of a thick, yellow substance from your breasts, known as colostrum. This is the initial nourishment for your baby before your breast milk production begins. While the leakage may surprise you, it's completely normal. Consider using cotton breast pads to manage any leakage.</li>
  <li><strong>Sinus congestion:</strong> This could be due to allergies, a cold, or another pregnancy symptom. Increased circulation to the nasal mucous membranes caused by the hormone progesterone might lead to swollen nasal passages, a condition known as pregnancy rhinitis. While there's no surefire way to eliminate it, staying hydrated and using a humidifier or petroleum jelly around the nostrils may provide some relief.</li>
  <li><strong>Increased appetite:</strong> If nausea has subsided, you might find yourself feeling hungrier than usual. While indulging in food, aim for a balanced diet. Most women with a pre-pregnancy BMI within the normal range need only an extra 300 calories per day (or 600 more for those carrying twins).</li>
  <li><strong>Leg cramps:</strong> Some women experience lower leg cramps in the second trimester, often occurring at night. Stretching before bedtime and staying hydrated can help prevent them. If you do experience calf cramps, massage the muscle or take a warm shower or bath for relief.</li>
</ul>""",
    "tips_mingguan_id": """<h2>14 Minggu Hamil: Hal yang Perlu Dipertimbangkan</h2>
<p>Pada usia kehamilan 14 minggu, luangkan waktu sejenak untuk mempertimbangkan hal-hal berikut:</p>
<ul>
  <li><strong>Pemeriksaan gigi:</strong> Jika Anda belum mengunjungi dokter gigi akhir-akhir ini, jadwalkan pemeriksaan dan pembersihan gigi. Kehamilan memerlukan perhatian khusus terhadap kesehatan gigi untuk mencegah penyakit gusi seperti gingivitis dan penyakit periodontal.</li>
  <li><strong>Tetap waspada terhadap kuman:</strong> Kehamilan mengubah respons kekebalan tubuh Anda, membuat Anda lebih rentan terhadap penyakit seperti pilek atau flu. Pastikan Anda mendapatkan suntikan flu dan menjaga praktek kebersihan yang baik, termasuk sering mencuci tangan dan menghindari kontak dengan orang sakit.</li>
  <li><strong>Kelas persalinan:</strong> Sudahkah Anda mempertimbangkan kelas persalinan? Sekarang adalah waktu yang tepat untuk mengeksplorasi pilihan yang tersedia di area Anda untuk menemukan kelas yang tepat untuk Anda.</li>
  <li><strong>Kehamilan kembar:</strong> Jika Anda sedang mengandung bayi kembar, Anda mungkin penasaran tentang bagaimana pengalaman kehamilan Anda berbeda, termasuk gejala dan penambahan berat badan. Cari nasihat dan bimbingan yang dipersonalisasi dari penyedia layanan kesehatan Anda.</li>
</ul>""",
    "tips_mingguan_en": """<h2>14 Weeks Pregnant: Things to Consider</h2>
<p>At 14 weeks pregnant, take a moment to consider the following:</p>
<ul>
  <li><strong>Dental checkup:</strong> If you haven't been to the dentist lately, schedule a checkup and cleaning. Pregnancy requires special attention to dental health to prevent gum diseases like gingivitis and periodontal disease.</li>
  <li><strong>Stay vigilant against germs:</strong> Pregnancy alters your immune response, making you more susceptible to illnesses like colds or flu. Ensure you get a flu shot and maintain good hygiene practices, including frequent handwashing and avoiding contact with sick individuals.</li>
  <li><strong>Childbirth classes:</strong> Have you considered childbirth classes? Now is an excellent time to explore available options in your area to find the right class for you.</li>
  <li><strong>Twin pregnancy:</strong> If you're expecting twins, you might be curious about how your pregnancy experience differs, including symptoms and weight gain. Seek personalized advice and guidance from your healthcare provider.</li>
</ul>""",
    "bayi_img_path": "week_14.jpg",
    "ukuran_bayi_img_path": "week_14_lemon.svg"
  },
  {
    "id": "15",
    "minggu_kehamilan": "15",
    "berat_janin": 117,
    "tinggi_badan_janin": 167,
    "ukuran_bayi_id": "Apel",
    "ukuran_bayi_en": "Apple",
    "poin_utama_id": """<h2>Perkembangan di Minggu ke-15 Kehamilan</h2>
<p>Saat Anda melalui perjalanan kehamilan, terjadi perubahan yang menggembirakan baik bagi Anda maupun bayi yang sedang berkembang. Berikut beberapa highlight penting yang perlu diperhatikan pada usia kehamilan 15 minggu:</p>
<ul>
  <li><strong>Perkembangan Rambut Bayi:</strong> Pola rambut bayi Anda mulai terbentuk karena pertumbuhan rambut awal menjadi terlihat.</li>
  <li><strong>Aktivitas Bayi:</strong> Si kecil semakin aktif dengan setiap minggu yang berlalu, meskipun Anda mungkin belum merasakan gerakannya.</li>
  <li><strong>Energy Meningkat:</strong> Anda mungkin merasakan peningkatan energi dan penurunan beberapa gejala yang menantang saat Anda mencapai usia kehamilan 15 minggu.</li>
  <li><strong>Buncit Kehamilan:</strong> Pada tahap ini, buncit kehamilan Anda mungkin mulai menjadi lebih terlihat. Pertimbangkan untuk merayakannya dengan cara tertentu, misalnya dengan mengambil foto perut kehamilan Anda yang berusia 15 minggu!</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 15 Weeks Pregnant</h2>
<p>As you progress through your pregnancy journey, exciting changes are occurring both for you and your growing baby. Here are some key highlights to note at 15 weeks pregnant:</p>
<ul>
  <li><strong>Baby's Hair Development:</strong> Your baby's hair pattern is starting to form as early hair growth becomes noticeable.</li>
  <li><strong>Baby's Activity:</strong> Your little one is becoming increasingly active with each passing week, although you may not yet feel their movements.</li>
  <li><strong>Increased Energy:</strong> You might notice a boost in energy levels and a reduction in some challenging symptoms as you reach 15 weeks of pregnancy.</li>
  <li><strong>Pregnancy Bump:</strong> At this stage, your pregnancy bump may begin to become more noticeable. Consider embracing it in some way, perhaps by taking photos of your 15-week pregnant belly!</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>Perkembangan Bayi Anda pada Usia Kehamilan 15 Minggu</h2>
<p>Meskipun setiap bayi berkembang dengan kecepatan yang berbeda-beda, berikut adalah beberapa perkembangan janin yang mungkin dialami bayi Anda pada usia kehamilan 15 minggu:</p>
<ul>
  <li><strong>Ciri-Ciri Wajah:</strong> Fitur wajah bayi Anda terus membentuk bentuknya, dengan telinga mereka terletak rendah di setiap sisi kepala.</li>
  <li><strong>Pertumbuhan Rambut:</strong> Pola rambut bayi Anda mulai terbentuk, dan mungkin ada beberapa pertumbuhan rambut awal.</li>
  <li><strong>Lanugo:</strong> Semua bayi mengembangkan lapisan rambut lembut bernama lanugo, yang mungkin mulai tumbuh minggu ini dan akan segera menutupi tubuh bayi Anda.</li>
  <li><strong>Kulit Transparan:</strong> Kulit tipis dan transparan menutupi pembuluh darah yang sekarang mengalirkan hingga 100 pint darah setiap hari, berkat jantung berkembang bayi Anda.</li>
  <li><strong>Gerakan Janin:</strong> Meskipun Anda mungkin belum merasakannya, bayi Anda menjadi lebih aktif minggu ini, bergerak, berbalik, dan berguling di dalam kantung amnion.</li>
</ul>""",
    "perkembangan_bayi_en": """<h2>15 Weeks Pregnant: Your Baby’s Development</h2>
<p>While each baby develops at their own pace, here are some typical fetal developments your little one might be experiencing at 15 weeks pregnant:</p>
<ul>
  <li><strong>Facial Features:</strong> Your baby's facial features are continuing to take shape, with their ears positioned low on each side of the head.</li>
  <li><strong>Hair Growth:</strong> Your baby's hair pattern is starting to form, and there may be some early hair growth.</li>
  <li><strong>Lanugo:</strong> All babies develop a layer of soft, downy hair called lanugo, which may begin growing this week and will eventually cover your baby's body.</li>
  <li><strong>Translucent Skin:</strong> Thin, translucent skin covers blood vessels that are now circulating up to 100 pints of blood daily, thanks to your baby's developing heart.</li>
  <li><strong>Fetal Movements:</strong> While you may not feel it yet, your little one is becoming more active this week, moving, turning, and rolling around in the amniotic sac.</li>
</ul>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda saat Hamil 15 Minggu</h2>
<p>Meskipun setiap calon ibu berbeda, biasanya perut mulai terlihat sekitar antara 13 dan 16 minggu kehamilan.</p>
<p>Jika Anda siap untuk membagikan kabar kehamilan Anda dengan dunia, Anda mungkin senang untuk menunjukkan perut Anda, tetapi jika Anda ingin menjaga hal-hal tetap rahasia untuk beberapa waktu lagi, Anda mungkin ingin mendapatkan beberapa baju yang lebih besar untuk memberi Anda waktu lebih.</p>
<p>Dalam perkembangan lain: Banyak ibu hamil melaporkan merasa lebih sedikit lelah dan lebih bersemangat pada saat ini dalam kehamilan, sering disebut sebagai periode bulan madu! Jika Anda menikmati energi ekstra ini, manfaatkanlah! Lakukan beberapa olahraga, pertimbangkan kelas persalinan, temukan kelompok orang tua lokal, atau mulailah merencanakan kamar bayi Anda.</p>""",
    "perubahan_tubuh_en": """<h2>Your Body at 15 Weeks Pregnant</h2>
<p>While every expectant mother is different, it's common for the baby bump to become noticeable sometime between 13 and 16 weeks into pregnancy.</p>
<p>If you're eager to share your pregnancy news with everyone, you might feel excited to flaunt your bump. However, if you prefer to keep it private a little while longer, oversized tops can help you keep it under wraps.</p>
<p>In other developments: Many pregnant women find themselves feeling less fatigued and more invigorated around this stage of pregnancy, often referred to as the honeymoon period! If you're enjoying this surge of energy, make the most of it! Consider engaging in some physical activity, exploring childbirth classes, connecting with local parent groups, or starting to plan your baby's nursery.</p>""",
    "gejala_umum_id": """<h2>Gejala saat Hamil 15 Minggu</h2>
<ul>
  <li><strong>Kaki dan kaki bengkak:</strong> Edema, jenis pembengkakan, dapat terjadi di kaki dan kaki bagian bawah Anda akibat penahanan cairan, yang umum terjadi selama kehamilan. Merendam kaki dalam air dingin dan mengangkatnya dapat membantu mengurangi pembengkakan.</li>
  <li><strong>Gusi bengkak, berdarah:</strong> Hormon kehamilan dapat meningkatkan risiko peradangan dan pendarahan gusi. Berkumur dengan air garam dan menggunakan sikat gigi berbulu lembut dapat mengurangi ketidaknyamanan. Perawatan gigi yang teratur sangat penting.</li>
  <li><strong>Kongesti hidung:</strong> Perubahan hormon selama kehamilan dapat menyebabkan pembengkakan hidung dan keringat. Tetap terhidrasi dan gunakan tetes hidung saline untuk meredakan gejala.</li>
  <li><strong>Sakit punggung bagian bawah:</strong> Banyak wanita hamil mengalami nyeri punggung bagian bawah, yang dapat dikurangi dengan mempraktikkan postur tubuh yang baik, menggunakan sepatu yang mendukung, dan melakukan latihan yang menguatkan otot punggung.</li>
  <li><strong>Kenaikan berat badan:</strong> Dengan meredanya mual di pagi hari, nafsu makan dapat kembali, menyebabkan penambahan berat badan seiring dengan pertumbuhan bayi. Perut Anda mungkin akan terlihat lebih menonjol.</li>
  <li><strong>“Otak kehamilan”:</strong> Perubahan hormon, kurang tidur, dan stres dapat menyebabkan lupa. Gunakan alat organisasi seperti daftar dan pengingat untuk tetap teratur.</li>
  <li><strong>Vena laba-laba:</strong> Perubahan sirkulasi yang terkait dengan kehamilan dapat menyebabkan munculnya vena tipis berwarna merah di wajah atau kaki. Latihan teratur dan mengangkat kaki Anda dapat membantu meningkatkan sirkulasi dan mengurangi vena laba-laba.</li>
  <li><strong>Infeksi saluran kemih (ISK):</strong> Kehamilan meningkatkan kerentanan terhadap ISK. Beritahu penyedia layanan kesehatan Anda jika Anda mengalami gejala seperti nyeri saat buang air kecil, sering ingin buang air kecil, demam, atau nyeri punggung.</li>
</ul>""",
    "gejala_umum_en": """<h2>15 Weeks Pregnant: Your Symptoms</h2>
<ul>
  <li><strong>Swollen feet and legs:</strong> Edema, a type of swelling, may occur in your feet and lower legs due to fluid retention, which is common during pregnancy. Soaking your feet in a cool foot bath and elevating them can help reduce swelling.</li>
  <li><strong>Swollen, bleeding gums:</strong> Pregnancy hormones can increase the risk of gum inflammation and bleeding. Rinse with salt water and use a soft-bristled toothbrush to alleviate discomfort. Regular dental care is essential.</li>
  <li><strong>Nasal congestion:</strong> Hormonal changes during pregnancy can cause nasal swelling and dryness. Stay hydrated and use saline nasal drops for relief.</li>
  <li><strong>Lower back pain:</strong> Many pregnant women experience lower back pain, which can be relieved by practicing good posture, wearing supportive shoes, and doing exercises that strengthen back muscles.</li>
  <li><strong>Weight gain:</strong> With morning sickness subsiding, appetite may return, leading to weight gain as your baby grows. Your belly may become more prominent.</li>
  <li><strong>“Pregnancy brain”:</strong> Hormonal changes, lack of sleep, and stress may contribute to forgetfulness. Use organizational tools like lists and reminders to stay on track.</li>
  <li><strong>Spider veins:</strong> Pregnancy-related changes in circulation can lead to the appearance of thin, red veins on the face or legs. Regular exercise and elevating your feet can help improve circulation and reduce spider veins.</li>
  <li><strong>Urinary tract infections (UTIs):</strong> Pregnancy increases susceptibility to UTIs. Inform your healthcare provider if you experience symptoms such as pain while urinating, frequent urge to urinate, fever, or back pain.</li>
</ul>""",
    "tips_mingguan_id": """<h2>Hal-hal yang Perlu Dipertimbangkan saat Hamil 15 Minggu</h2>
<ul>
  <li><strong>Olajraga:</strong> Lakukan olahraga ringan seperti berjalan, berenang, atau yoga untuk meningkatkan energi dan menguatkan otot. Konsultasikan dengan penyedia layanan kesehatan Anda sebelum memulai rutinitas olahraga baru.</li>
  <li><strong>Tempat Persalinan:</strong> Pertimbangkan tempat di mana Anda ingin melahirkan. Rumah sakit dan pusat persalinan yang terakreditasi dianggap sebagai pilihan yang aman. Diskusikan preferensi Anda dengan penyedia layanan kesehatan dan atur tur fasilitas jika memungkinkan.</li>
  <li><strong>Pembentukan Ikatan:</strong> Luangkan waktu untuk mendengarkan musik bersama bayi Anda yang sedang dikandung karena mereka akan segera dapat mendengar suara. Musik juga dapat membantu Anda rileks dan mengurangi stres selama kehamilan.</li>
  <li><strong>Seks selama kehamilan:</strong> Komunikasikan secara terbuka dengan pasangan Anda tentang keinginan dan kekhawatiran seksual Anda. Umumnya aman untuk berhubungan seks selama kehamilan, tetapi konsultasikan dengan penyedia layanan kesehatan jika Anda memiliki pertanyaan atau kekhawatiran.</li>
  <li><strong>USG pertengahan kehamilan:</strong> Jika Anda ingin tahu jenis kelamin bayi Anda, USG pertengahan kehamilan, biasanya dilakukan antara 16 dan 20 minggu kehamilan, akan segera datang. Manfaatkan kuis menyenangkan untuk menebak jenis kelamin bayi Anda sambil menunggu.</li>
</ul>""",
    "tips_mingguan_en": """<h2>15 Weeks Pregnant: Things to Consider</h2>
<ul>
  <li><strong>Exercise:</strong> Engage in mild exercises like walking, swimming, or yoga to boost energy levels and tone muscles. Consult your healthcare provider before starting any new exercise routine.</li>
  <li><strong>Birthplace:</strong> Consider where you want to give birth. Hospitals and accredited birth centers are considered safe options. Discuss your preferences with your healthcare provider and arrange a tour of the facility if possible.</li>
  <li><strong>Bonding:</strong> Spend time listening to music with your baby-to-be as they will soon be able to hear sounds. Music can also help you relax and reduce stress during pregnancy.</li>
  <li><strong>Sex during pregnancy:</strong> Communicate openly with your partner about your sexual desires and concerns. It's generally safe to have sex during pregnancy, but consult your healthcare provider if you have any questions or concerns.</li>
  <li><strong>Mid-pregnancy ultrasound:</strong> If you're eager to know your baby's gender, the mid-pregnancy ultrasound, usually done between 16 and 20 weeks of pregnancy, is approaching. Take advantage of fun quizzes to guess your baby's gender while you wait.</li>
</ul>""",
    "bayi_img_path": "week_15.jpg",
    "ukuran_bayi_img_path": "week_15_apple.svg"
  },
  {
    "id": "16",
    "minggu_kehamilan": "16",
    "berat_janin": 146,
    "tinggi_badan_janin": 186,
    "ukuran_bayi_id": "Alpukat",
    "ukuran_bayi_en": "Avocado",
    "poin_utama_id": """<h2>Pentingnya Kehamilan 16 Minggu</h2>
<ul>
  <li>Gerakan lengan dan kaki bayi Anda semakin terkoordinasi.</li>
  <li>Pada usia kehamilan 16 minggu, bayi Anda kira-kira seukuran apel.</li>
  <li>Trimester kedua seringkali menjadi bagian paling menyenangkan dari kehamilan, dengan banyak gejala yang tidak nyaman mereda dan potensi peningkatan energi.</li>
  <li>Anda mungkin melihat "kilau kehamilan" pada kulit Anda minggu ini, memberikannya penampilan yang bercahaya.</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 16 Weeks Pregnant</h2>
<ul>
  <li>Your baby's arm and leg movements are getting more coordinated.</li>
  <li>At 16 weeks pregnant, your baby is approximately the size of an apple.</li>
  <li>The second trimester is often the most enjoyable part of pregnancy, with many uncomfortable symptoms easing and a potential increase in energy levels.</li>
  <li>You might notice the "pregnancy glow" on your skin this week, giving it a radiant appearance.</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>Perkembangan Bayi Anda pada Usia Kehamilan 16 Minggu</h2>
<ul>
  <li>Kepala bayi Anda kini tegak.</li>
  <li>Mata mereka dapat bergerak perlahan-lahan.</li>
  <li>Pada usia kehamilan 16 minggu, bayi Anda mulai membuat gerakan terkoordinasi dengan lengan dan kaki mereka.</li>
  <li>Telinga mereka semakin mendekati posisi akhir mereka, dan segera mereka mungkin dapat mendengar suara. Jangan ragu untuk berbicara dan menyanyikan lagu kepada bayi Anda!</li>
  <li>Jika Anda menjalani USG pada usia kehamilan 16 minggu, Anda mungkin bisa melihat alat kelamin eksternal bayi Anda. Namun, jika tidak jelas, mungkin butuh beberapa minggu lagi bagi penyedia layanan kesehatan Anda untuk menentukan jenis kelamin bayi.</li>
</ul>""",
    "perkembangan_bayi_en": """<h2>16 Weeks Pregnant: Your Baby’s Development</h2>
<ul>
  <li>Your baby's head is now upright.</li>
  <li>Their eyes can move slowly.</li>
  <li>At around 16 weeks pregnant, your baby is starting to make coordinated movements with their arms and legs.</li>
  <li>Their ears are getting closer to their final position, and soon they may be able to hear sounds. Feel free to talk and sing to your baby!</li>
  <li>If you have an ultrasound at 16 weeks pregnant, you might be able to see your baby's external genitalia. However, if it's not clear, it may take a few more weeks for your healthcare provider to determine the gender.</li>
</ul>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda pada Usia Kehamilan 16 Minggu</h2>
<p>Sekarang Anda hanya empat minggu lagi menuju titik tengah kehamilan Anda. Apakah Anda cukup istirahat dan tidur? Sebagian besar penyedia layanan kesehatan merekomendasikan untuk tidur miring selama kehamilan.</p>
<p>Tidur tengkurap mungkin sedikit tidak nyaman pada usia kehamilan 16 minggu, dan para ahli percaya bahwa berbaring tengkurap dapat meningkatkan tekanan pada vena cava—pembuluh darah yang mengembalikan darah ke jantung Anda.</p>
<p>Tidur dengan posisi miring ke kiri dapat meningkatkan sirkulasi Anda, memungkinkan aliran darah yang lebih baik ke janin dan ke rahim serta ginjal Anda. Coba letakkan bantal di antara lutut Anda dan gunakan bantal lainnya untuk menopang perut Anda untuk meningkatkan kenyamanan; minta saran kepada penyedia layanan kesehatan Anda jika Anda masih kesulitan menemukan posisi tidur yang nyaman.</p>
<p>Bisakah Anda merasakan gerakan bayi Anda pada usia kehamilan 16 minggu? Pada suatu saat antara sekarang dan 20 minggu atau lebih, Anda mungkin mulai merasakan gerakan bayi Anda untuk pertama kalinya, yang disebut dengan quickening. Namun, jika Anda belum merasakan apa pun, jangan khawatir. Bayi Anda masih sangat kecil, dan setiap kehamilan berbeda.</p>
<p>Pada usia kehamilan 16 minggu, gerakan bayi Anda juga sangat kecil, sehingga sulit untuk membedakan apakah sensasi yang Anda rasakan disebabkan oleh perut yang lapar, gas, gerakan bayi, atau sesuatu yang lain.</p>""",
    "perubahan_tubuh_en": """<h2>Your Body at 16 Weeks Pregnant</h2>
<p>You’re now just four weeks away from reaching the halfway point of your pregnancy. Are you getting enough rest and sleep? Most healthcare providers suggest sleeping on your side during pregnancy.</p>
<p>Sleeping on your belly might be uncomfortable at 16 weeks pregnant, and lying on your back could put pressure on the vena cava—the blood vessel that returns blood to your heart.</p>
<p>Sleeping on your left side can improve circulation, facilitating better blood flow to the fetus, uterus, and kidneys. Consider placing a pillow between your knees and using another to support your abdomen for added comfort. If you’re still struggling to find a comfortable sleeping position, consult your healthcare provider for advice.</p>
<p>Can you feel your baby move at 16 weeks? Sometime between now and 20 weeks or later, you may begin to feel your baby move for the first time, known as quickening. However, if you haven’t sensed anything yet, don’t worry. Your baby is still very small, and every pregnancy is different.</p>
<p>At 16 weeks pregnant, your baby’s movements are tiny, making it challenging to distinguish whether the sensations you feel are caused by hunger, gas, the baby moving, or something else.</p>""",
    "gejala_umum_id": """<h2>Tanda-Tanda Anda Saat Hamil 16 Minggu</h2>
<p>Meskipun sulit untuk memprediksi apa yang terjadi pada usia kehamilan 16 minggu, berikut beberapa gejala yang mungkin Anda alami:</p>
<ul>
  <li><strong>Perubahan kulit:</strong> Anda mungkin melihat perubahan pada kulit Anda, seperti "cahaya kehamilan," yang disebabkan oleh peningkatan volume darah dan produksi minyak yang dipicu hormon. Meskipun banyak wanita menikmati cahaya ini, beberapa mungkin mengalami bercak gelap yang disebut melasma atau jerawat sesekali. Untuk mengelola jerawat, cuci wajah Anda dua kali sehari dengan pembersih ringan dan air hangat, dan konsultasikan dengan seorang ahli dermatologi untuk produk perawatan kulit yang aman.</li>
  <li><strong>Pendarahan hidung:</strong> Pendarahan hidung dapat terjadi akibat peningkatan sirkulasi dan perubahan hormon. Pertahankan kelembapan udara dalam ruangan, lembapkan tepi hidung Anda dengan petroleum jelly, dan tiup hidung dengan lembut untuk meminimalkan pendarahan hidung selama kehamilan.</li>
  <li><strong>Nyeri punggung bagian bawah:</strong> Nyeri punggung umum terjadi selama trimester kedua dan ketiga. Untuk meredakannya, mandi air hangat, regangkan tubuh secara teratur, pertahankan postur tubuh yang baik, kenakan sepatu hak rendah, dan berolahraga sesuai dengan saran dari penyedia layanan kesehatan Anda.</li>
  <li><strong>Pusing:</strong> Beberapa ibu hamil mengalami pusing akibat perubahan hormonal yang memengaruhi sirkulasi. Tetaplah terhidrasi, hindari berdiri terlalu lama, dan berbaringlah di sisi tubuh Anda jika merasa pusing. Jika pusing terjadi saat berolahraga, konsultasikan dengan penyedia layanan kesehatan Anda.</li>
</ul>""",
    "gejala_umum_en": """<h2>16 Weeks Pregnant: Your Symptoms</h2>
<p>Although it’s hard to predict what will happen at 16 weeks pregnant, here are some symptoms you might be experiencing:</p>
<ul>
  <li><strong>Skin changes:</strong> You may notice changes in your skin, like the "pregnancy glow," caused by increased blood volume and hormone-induced oil production. While many women enjoy this glow, some may experience dark spots called melasma or occasional acne. To manage breakouts, wash your face twice daily with a gentle cleanser and lukewarm water, and consult a dermatologist for safe skincare products.</li>
  <li><strong>Nosebleeds:</strong> Nosebleeds can occur due to increased circulation and hormonal changes. Keep indoor air humidified, moisturize the edges of your nostrils with petroleum jelly, and blow your nose gently to minimize pregnancy-related nosebleeds.</li>
  <li><strong>Lower back pain:</strong> Back pain is common during the second and third trimesters. To relieve it, take warm baths, stretch regularly, maintain good posture, wear low-heeled shoes, and exercise as recommended by your healthcare provider.</li>
  <li><strong>Dizziness:</strong> Some expectant mothers experience dizziness due to hormonal changes affecting circulation. Stay hydrated, avoid prolonged standing, and lie down on your side if you feel dizzy. If dizziness occurs during exercise, consult your healthcare provider.</li>
</ul>""",
    "tips_mingguan_id": """<h2>16 Minggu Hamil: Hal yang Perlu Dipertimbangkan</h2>
<p>Pada trimester kedua, Anda mungkin memiliki berbagai hal yang ada dalam pikiran, meskipun Anda sedang menikmati energi tambahan. Berikut adalah beberapa hal yang perlu dipertimbangkan pada usia kehamilan 16 minggu:</p>
<ul>
  <li>Nikmati kesenangan hamil selama tahap ini! Banyak gejala tidak nyaman dari awal kehamilan mungkin telah mereda, dan Anda mungkin merasa lebih bertenaga. Tetap aktif dengan aktivitas seperti berjalan, berenang, atau yoga prenatal.</li>
  <li>Pertimbangkan untuk mendapatkan fitting bra profesional untuk memastikan Anda mengenakan ukuran yang tepat seiring dengan pertumbuhan payudara. Cari bra dengan tali lebar, cakupan penuh, dan kait yang dapat diperlebar. Anda mungkin juga memerlukan bra olahraga yang mendukung dengan ukuran yang lebih besar untuk berolahraga.</li>
  <li>Jika Anda merasa tidak nyaman saat tidur, coba gunakan bantal ekstra untuk dukungan, seperti meletakkannya di antara lutut dan di bawah perut saat Anda berbaring telentang. Bantal hamil adalah pilihan lain untuk kenyamanan tambahan.</li>
  <li>Trimester kedua adalah waktu yang ideal untuk babymoon singkat. Baik itu liburan akhir pekan atau perjalanan lebih lama, konsultasikan dengan penyedia layanan kesehatan Anda sebelum bepergian, terutama jika naik pesawat. Ikuti kuis kami untuk menemukan tujuan babymoon yang ideal untuk Anda!</li>
  <li>Jika ini kehamilan Anda yang kedua, pertimbangkan bagaimana hal-hal mungkin berbeda kali ini. Pelajari lebih lanjut tentang perbedaan gejala selama kehamilan kedua.</li>
</ul>""",
    "tips_mingguan_en": """<h2>16 Weeks Pregnant: Things to Consider</h2>
<p>During your second trimester, you might have various things on your mind, even if you're enjoying a surge of energy. Here are some considerations to keep in mind at 16 weeks pregnant:</p>
<ul>
  <li>Embrace the fun of pregnancy during this stage! Many of the uncomfortable symptoms from early pregnancy may have eased, and you might feel more energetic. Stay moderately active with activities like walking, swimming, or prenatal yoga.</li>
  <li>Consider getting a professional bra fitting to ensure you're wearing the right size as your breasts grow. Look for bras with wide straps, full coverage, and expandable hooks. You may also need supportive sports bras in larger sizes for exercising.</li>
  <li>If you're experiencing discomfort while sleeping, try using extra pillows for support, such as placing them between your knees and under your belly while lying on your side. Pregnancy pillows are another option for added comfort.</li>
  <li>The second trimester is an ideal time for a short babymoon. Whether it's a weekend getaway or a longer trip, consult with your healthcare provider before traveling, especially if flying. Take our quiz to discover your ideal babymoon destination!</li>
  <li>If this is your second pregnancy, consider how things might be different this time around. Learn more about the variances in symptoms during a second pregnancy.</li>
</ul>""",
    "bayi_img_path": "week_16.jpg",
    "ukuran_bayi_img_path": "week_16_avocado.svg"
  },
  {
    "id": "17",
    "minggu_kehamilan": "17",
    "berat_janin": 181,
    "tinggi_badan_janin": 204,
    "ukuran_bayi_id": "Lobak",
    "ukuran_bayi_en": "Turnip",
    "poin_utama_id": """<h2>Highlights pada Usia Kehamilan 17 Minggu</h2>
<p>Berikut adalah beberapa perkembangan menarik yang dapat dinantikan pada usia kehamilan 17 minggu:</p>
<ul>
  <li>Kuku jari kaki bayi Anda mulai tumbuh!</li>
  <li>Bayi Anda semakin menambah berat badan dan mengembangkan lapisan pelindung pada kulitnya yang dikenal sebagai vernix.</li>
  <li>Anda mungkin mulai merasakan gerakan bayi Anda dalam beberapa minggu mendatang. Bersiaplah untuk sensasi gemeretak di perut Anda!</li>
  <li>Anda mungkin melihat payudara Anda semakin membesar pada tahap ini. Ini bisa menjadi waktu yang tepat untuk mempertimbangkan untuk membeli bra baru.</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 17 Weeks Pregnant</h2>
<p>Here are some exciting developments to look forward to at 17 weeks pregnant:</p>
<ul>
  <li>Your baby's tiny toenails are starting to grow!</li>
  <li>Your little one is gaining more weight and developing the protective vernix on their skin.</li>
  <li>You might begin to feel your baby's movements in the coming weeks. Get ready for those fluttering sensations in your belly!</li>
  <li>You may observe your breasts getting larger at this stage. It could be a good time to consider buying some new bras.</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>Perkembangannya Bayi pada Usia Kehamilan 17 Minggu</h2>
<p>Inilah yang terjadi dengan perkembangan bayi Anda pada usia kehamilan 17 minggu:</p>
<ul>
  <li>Bayi Anda mulai mengembangkan lemak coklat di bawah kulitnya, yang membantu menyediakan energi dan mengatur suhu tubuh.</li>
  <li>Kelenjar yang memproduksi minyak di kulit bayi Anda mungkin mulai menghasilkan verniks, sebuah lapisan putih pelindung.</li>
  <li>Bayi Anda menjadi lebih aktif dalam kantung amnion, meskipun Anda mungkin belum merasakannya.</li>
  <li>Kuku jari kaki mulai tumbuh minggu ini, dan pada akhir bulan, mereka mungkin akan membentang hingga ujung jari kaki dan jari tangan.</li>
</ul>""",
    "perkembangan_bayi_en": """<h2>17 Weeks Pregnant: Your Baby’s Development</h2>
<p>Here's what's happening with your baby's development at 17 weeks pregnant:</p>
<ul>
  <li>Your baby is starting to develop brown fat under their skin, which helps provide energy and regulates body temperature.</li>
  <li>The oil-producing glands in your baby's skin may begin to produce vernix, a protective white film.</li>
  <li>Your baby is becoming more active within the amniotic sac, although you may not feel it yet.</li>
  <li>Toenails are starting to grow this week, and by the end of the month, they may extend to the tips of the toes and fingers.</li>
</ul>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda pada Usia Kehamilan 17 Minggu</h2>
<p>Berikut adalah beberapa perubahan yang terjadi pada tubuh Anda pada usia kehamilan 17 minggu:</p>
<ul>
  <li>Payudara Anda mungkin sedang tumbuh dan mengalami perubahan. Lebih banyak darah mengalir ke dalamnya untuk persiapan produksi ASI, dan Anda mungkin melihat pembuluh darah yang lebih gelap muncul.</li>
  <li>Adalah umum bagi wanita hamil untuk meningkatkan satu atau dua ukuran cup, jadi pertimbangkan untuk mendapatkan fitting bra profesional untuk kenyamanan.</li>
  <li>Plasenta sedang tumbuh untuk memastikan bayi yang sedang berkembang menerima cukup nutrisi dan oksigen sambil menghilangkan limbah.</li>
  <li>Apakah Anda pernah memperhatikan kaki Anda menjadi lebih besar? Ini bisa disebabkan oleh penambahan berat badan selama kehamilan dan juga pembengkakan, yang dikenal sebagai edema, yang terjadi saat tubuh Anda menyimpan cairan ekstra. Coba rendam kaki Anda dalam bak air dingin dan angkat mereka jika memungkinkan untuk merasa lega.</li>
</ul>""",
    "perubahan_tubuh_en": """<h2>Your Body at 17 Weeks Pregnant</h2>
<p>Here are some changes happening in your body at 17 weeks pregnant:</p>
<ul>
  <li>Your breasts may be growing and changing. More blood is flowing to them in preparation for milk production, and you might notice darker veins appearing.</li>
  <li>It's common for pregnant women to increase one or two cup sizes, so consider getting a professional bra fitting for comfort.</li>
  <li>The placenta is growing to ensure your developing baby receives enough nutrients and oxygen while eliminating waste.</li>
  <li>Have you noticed your feet getting bigger? This could be due to pregnancy weight gain and swelling, known as edema, which occurs as your body retains extra fluid. Try soaking your feet in a cool foot bath and elevating them when possible for relief.</li>
</ul>""",
    "gejala_umum_id": """<h2>Gejala Anda pada Usia Kehamilan 17 Minggu</h2>
<ul>
  <li><strong>Wasir:</strong> Wasir adalah pembengkakan pembuluh darah di rektum akibat peningkatan volume dan aliran darah di area panggul. Untuk mencegahnya, pertahankan diet tinggi serat, tetap terhidrasi, dan berolahraga secara teratur. Merendam diri dalam bak air hangat dan menghindari duduk dalam jangka waktu lama dapat membantu meredakan ketidaknyamanan.</li>
  <li><strong>Kulit gatal atau sensitif:</strong> Peregangan pada perut dan payudara Anda pada usia kehamilan 17 minggu dapat menyebabkan gatal dan mungkin juga stretch mark. Meskipun Anda tidak dapat sepenuhnya mencegah stretch mark, tetap terhidrasi dan menggunakan pelembap pada kulit dapat membantu mengurangi rasa gatal.</li>
  <li><strong>Heartburn dan masalah pencernaan:</strong> Mual pada pagi hari mungkin telah reda, tetapi heartburn dan masalah pencernaan dapat muncul selama trimester ini. Mengonsumsi makanan dalam porsi kecil dan lebih sering serta menghindari makanan pedas dapat meredakan ketidaknyamanan. Makan secara perlahan dan menghindari berbaring langsung setelah makan juga dapat membantu.</li>
  <li><strong>Kram kaki:</strong> Kram kaki bisa mengganggu tidur Anda pada trimester kedua. Peregangan sebelum tidur dan pijat otot betis dapat memberikan bantuan. Menjaga tubuh tetap terhidrasi, tetap aktif secara fisik, dan menggunakan sepatu yang nyaman dan mendukung juga dapat membantu mencegah kram kaki.</li>
  <li><strong>Nyeri punggung bawah:</strong> Pertumbuhan rahim dan penambahan berat badan dapat menyebabkan nyeri punggung bawah. Olahraga, peregangan, dan penggunaan bantalan pemanas dapat mengurangi ketidaknyamanan. Menghindari berdiri dalam jangka waktu lama dan berkonsultasi dengan penyedia layanan kesehatan Anda disarankan.</li>
</ul>""",
    "gejala_umum_en": """<h2>17 Weeks Pregnant: Your Symptoms</h2>
<ul>
  <li><strong>Hemorrhoids:</strong> Hemorrhoids are swollen veins in the rectum due to increased blood volume and flow in the pelvic area. To prevent them, maintain a high-fiber diet, stay hydrated, and exercise regularly. Soaking in a warm bath and avoiding prolonged sitting can help soothe discomfort.</li>
  <li><strong>Itchy or sensitive skin:</strong> The stretching of your belly and breasts at 17 weeks pregnant may cause itching and possibly stretch marks. While you can't prevent stretch marks entirely, staying hydrated and moisturizing your skin can help reduce itchiness.</li>
  <li><strong>Heartburn and indigestion:</strong> Morning sickness may have subsided, but heartburn and indigestion could arise during this trimester. Eating smaller, more frequent meals and avoiding spicy foods can alleviate discomfort. Eating slowly and avoiding lying down immediately after eating may also help.</li>
  <li><strong>Leg cramps:</strong> Leg cramps may disrupt your sleep in the second trimester. Stretching before bed and massaging calf muscles can provide relief. Staying hydrated, staying physically active, and wearing supportive shoes may also help prevent leg cramps.</li>
  <li><strong>Lower back pain:</strong> The growing uterus and weight gain can cause lower back pain. Exercise, stretching, and applying a heating pad may alleviate discomfort. Avoiding prolonged standing and consulting your healthcare provider for guidance are recommended.</li>
</ul>""",
    "tips_mingguan_id": """<h2>Usia Kehamilan 17 Minggu: Hal yang Perlu Dipertimbangkan</h2>
<ul>
  <li>Mungkin Anda ingin mengetahui jenis kelamin bayi Anda, tetapi biasanya ditentukan selama pemeriksaan ultrasonografi sekitar 18 hingga 20 minggu. Mulailah mengeksplorasi kelas persalinan saat Anda mendekati setengah jalan kehamilan Anda. Pertimbangkan opsi tes genetik yang tersedia untuk Anda dan diskusikan dengan penyedia layanan kesehatan Anda.</li>
  <li>Jika Anda memiliki waktu luang, mulailah mencari penyedia layanan kesehatan untuk bayi Anda. Cari rekomendasi dari orang tua lain atau konsultasikan daftar penyedia yang dicover oleh asuransi Anda. Diskusikan dengan penyedia layanan kesehatan Anda dan jadwalkan pertemuan tatap muka dengan dokter anak potensial.</li>
  <li>Kehamilan dapat menyebabkan ketegangan dalam hubungan, jadi pastikan komunikasi terbuka dengan pasangan Anda. Libatkan mereka dalam acara terkait kehamilan dan cari dukungan jika diperlukan. Konseling dan kelompok dukungan tersedia jika Anda memerlukan bantuan dari luar.</li>
</ul>""",
    "tips_mingguan_en": """<h2>17 Weeks Pregnant: Things to Consider</h2>
<ul>
  <li>You might be eager to discover your baby's gender, but it's usually determined during an ultrasound exam around 18 to 20 weeks. Start exploring childbirth classes as you approach the halfway mark of your pregnancy. Consider genetic testing options available to you and discuss them with your healthcare provider.</li>
  <li>If you have spare time, begin researching healthcare providers for your baby. Seek recommendations from other parents or consult a list of providers covered by your insurance. Discuss with your healthcare provider and schedule face-to-face meetings with potential pediatricians.</li>
  <li>Pregnancy can strain relationships, so ensure open communication with your partner. Involve them in pregnancy-related events and seek support if needed. Counseling and support groups are available if you require outside assistance.</li>
</ul>""",
    "bayi_img_path": "week_17.jpg",
    "ukuran_bayi_img_path": "week_17_turnip.svg"
  },
  {
    "id": "18",
    "minggu_kehamilan": "18",
    "berat_janin": 223,
    "tinggi_badan_janin": 220,
    "ukuran_bayi_id": "Paprika",
    "ukuran_bayi_en": "Bell Pepper",
    "poin_utama_id": """<h2>Hal Menarik Saat Hamil 18 Minggu</h2>
<ul>
  <li>Pada usia kehamilan 18 minggu, bayi Anda kira-kira sebesar kentang manis!</li>
  <li>Tulang-tulang mulai menguat di tubuh bayi Anda.</li>
  <li>Telinga bayi Anda mungkin sedang berkembang, memungkinkan mereka mulai mendengar suara.</li>
  <li>Pada usia kehamilan 18 minggu atau beberapa minggu mendatang, Anda mungkin mulai merasakan gerakan bayi Anda. Siapkan diri untuk sensasi halus di perut Anda.</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 18 Weeks Pregnant</h2>
<ul>
  <li>At 18 weeks pregnant, your baby is approximately the size of a sweet potato!</li>
  <li>Bones are starting to strengthen in your baby's body.</li>
  <li>Your baby's ears may be developing, allowing them to start registering sounds.</li>
  <li>By 18 weeks pregnant or in the following weeks, you might begin to feel your baby's movements. Prepare for those gentle flutters in your belly.</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>Perkembangan Bayi Anda Saat Hamil 18 Minggu</h2>
<ul>
  <li>Tulang-tulang bayi Anda mulai mengeras minggu ini, sebuah proses yang disebut osifikasi. Beberapa tulang pertama yang mengeras termasuk tulang kaki, tulang selangka, dan telinga dalam.</li>
  <li>Sistem pencernaan yang sedang berkembang menjadi lebih aktif. Bayi Anda menelan cairan ketuban, yang melewati perut dan usus. Cairan ini bergabung dengan sel-sel mati dan sekresi dalam usus untuk membentuk mekonium — sebuah substansi hitam seperti tar yang akan Anda lihat pada penggantian popok pertama.</li>
  <li>Pada sekitar usia kehamilan 18 minggu, telinga bayi Anda akan mulai menonjol dari sisi kepala dan mungkin mulai merespons suara.</li>
  <li>Bayi Anda memerlukan empedu untuk mencerna nutrisi, dan pada usia kehamilan 18 minggu, kantung empedu, yang menyimpan empedu, mungkin mulai berfungsi.</li>
</ul>""",
    "perkembangan_bayi_en": """<h2>18 Weeks Pregnant: Your Baby’s Development</h2>
<ul>
  <li>Your baby's bones are starting to harden this week, a process known as ossification. Some of the first bones to harden include the leg bones, collarbone, and inner ear.</li>
  <li>The developing digestive system is becoming more active. Your baby swallows amniotic fluid, which passes through the stomach and intestines. This fluid combines with dead cells and secretions in the intestines to form meconium — a black, tar-like substance you'll notice during the first diaper change.</li>
  <li>Around 18 weeks, your baby’s ears will begin to protrude from the sides of the head and may start to respond to sounds.</li>
  <li>Your baby requires bile for digesting nutrients, and at 18 weeks, the gallbladder, which stores bile, may begin to function.</li>
</ul>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda Saat Hamil 18 Minggu</h2>
<p>Pada tahap kehamilan ini, Anda akan mengalami perubahan dalam peredaran darah, termasuk peningkatan volume darah dan pelebaran pembuluh darah yang dapat menyebabkan tekanan darah turun. Hal ini dapat membuat Anda merasa pusing jika aliran darah ke kepala dan bagian atas tubuh tidak mencukupi.</p>
<p>Anda mungkin juga menyadari bahwa kaki Anda menjadi lebih besar pada usia kehamilan 18 minggu. Sebagian dari pertumbuhan ini disebabkan oleh pembengkakan akibat penahanan air, yang dikenal sebagai edema, yang dapat terjadi mulai dari trimester kedua kehamilan.</p>
<p>Hormon juga berperan dalam pertumbuhan kaki. Hormon kehamilan yang disebut relaksin, yang melonggarkan sendi panggul agar bayi bisa melewati jalan lahir, juga mempengaruhi ligamen di kaki Anda, menyebabkan tulang kaki menyebar. Untuk mengurangi pembengkakan, coba rendam kaki Anda dalam air dingin dan jaga agar kaki tetap terangkat. Jika Anda merasa perlu sepatu yang lebih besar, jangan khawatir — itu semua bagian dari perjalanan kehamilan!</p>""",
    "perubahan_tubuh_en": """<h2>Your Body at 18 Weeks Pregnant</h2>
<p>During this stage of pregnancy, you may experience changes in your circulation, including increased blood volume and expanding blood vessels, which can lead to a drop in blood pressure. This might result in feelings of lightheadedness if there's insufficient blood flow to your head and upper body.</p>
<p>You might also observe that your feet are growing larger at 18 weeks of pregnancy. Some of this growth can be attributed to swelling caused by water retention, known as edema, which can occur from the second trimester onward.</p>
<p>Hormones also contribute to the growth of feet. The pregnancy hormone relaxing, which loosens pelvic joints to facilitate childbirth, also affects the ligaments in your feet, causing the bones to spread. To alleviate swelling, try soaking your feet in cool water and keeping them elevated. If you find yourself needing larger shoes, don't worry — it's all part of the journey!</p>""",
    "gejala_umum_id": """<h2>Gejala Anda saat Hamil 18 Minggu</h2>
<ul>
  <li><strong>Pusing:</strong> Jantung Anda bekerja lebih keras selama kehamilan, dan digabungkan dengan tekanan dari rahim yang semakin membesar pada pembuluh darah, ini kadang-kadang dapat menyebabkan pusing. Istirahat secara teratur dan berbaring di sisi Anda dapat membantu mengurangi gejala ini. Gula darah rendah juga bisa menyebabkan rasa pusing, jadi makan buah dapat membantu meningkatkan kadar gula darah.</li>
  <li><strong>Gerakan Janin:</strong> Sebagian besar wanita mulai merasakan gerakan janin mereka antara 16 dan 20 minggu kehamilan. Pada usia kehamilan 18 minggu, gerakan tersebut mungkin terasa seperti getaran lembut daripada tendangan yang kuat.</li>
  <li><strong>Kram Kaki:</strong> Kram kaki, biasanya terjadi pada malam hari, dapat terjadi sekitar 18 minggu kehamilan. Memanjangkan otot betis sebelum tidur, tetap terhidrasi, dan mandi air hangat dapat membantu mengurangi ketidaknyamanan ini.</li>
  <li><strong>Masalah Hidung:</strong> Perubahan hormon dan peningkatan volume darah selama kehamilan dapat menyebabkan pembengkakan pada selaput lendir, menyebabkan mimisan dan hidung tersumbat.</li>
  <li><strong>Sakit dan Nyeri Punggung:</strong> Pertumbuhan perut Anda dan perubahan hormon dapat menyebabkan ketidaknyamanan di area punggung bagian bawah pada usia kehamilan 18 minggu dan sepanjang kehamilan.</li>
</ul>""",
    "gejala_umum_en": """<h2>18 Weeks Pregnant: Your Symptoms</h2>
<ul>
  <li><strong>Dizziness:</strong> Your heart is working harder during pregnancy, and combined with the pressure from your growing uterus on blood vessels, it can sometimes cause dizziness. Resting frequently and lying down on your side can help alleviate this symptom. Low blood sugar may also contribute to dizziness, so eating a piece of fruit can help boost blood sugar levels.</li>
  <li><strong>Baby Movements:</strong> Most women begin to feel their baby's movements between 16 and 20 weeks of pregnancy. At 18 weeks, these movements may feel more like gentle flutters than forceful kicks.</li>
  <li><strong>Leg Cramps:</strong> Leg cramps, often experienced at night, may occur around 18 weeks pregnant. Stretching your calf muscles before bed, staying hydrated, and taking a warm bath or shower can help alleviate this discomfort.</li>
  <li><strong>Nasal Issues:</strong> Hormonal changes and increased blood volume during pregnancy can cause swelling of the mucous membranes, leading to nosebleeds and congestion.</li>
  <li><strong>Back Aches and Pains:</strong> The growth of your stomach and hormonal changes can result in discomfort in your lower back area at 18 weeks pregnant and throughout pregnancy.</li>
</ul>""",
    "tips_mingguan_id": """<h2>18 Minggu Hamil: Hal yang Perlu Dipertimbangkan</h2>
<ul>
  <li><strong>Perhatikan asam lemak omega-3:</strong> Memastikan Anda dan bayi Anda menerima nutrisi yang cukup sangat penting. Asam lemak omega-3 mendukung perkembangan otak yang sehat untuk bayi Anda selama kehamilan dan setelah kelahiran. Sertakan makanan yang kaya akan omega-3, seperti salmon, biji rami, brokoli, atau kenari, dalam pola makan Anda. Anda dapat menemukan informasi lebih lanjut tentang nutrisi selama kehamilan dalam panduan kehamilan yang dapat diunduh kami.</li>
  <li><strong>Maintain pola makan seimbang:</strong> Meskipun Anda memerlukan kalori ekstra untuk mendukung pertumbuhan bayi Anda, Anda tidak perlu menggandakan asupan makanan Anda. Pada trimester kedua, tambahkan sekitar 300 kalori tambahan per hari di atas rata-rata 2.000 kalori. Kalkulator penambahan berat badan selama kehamilan kami dapat membantu Anda memantau berat badan selama kehamilan.</li>
  <li><strong>Terima saran kehamilan yang tidak diminta dengan baik:</strong> Umum untuk menerima saran dari berbagai sumber, tetapi Anda tidak harus mengikuti semua saran. Tanggapi dengan sopan saran yang tidak diinginkan, mengakui masukan tanpa merasa terikat untuk mengimplementasikannya. Ingatlah bahwa kebanyakan orang bermaksud baik dan hanya merasa senang untuk Anda.</li>
  <li><strong>Percayakan pada penyedia layanan kesehatan Anda:</strong> Dalam kasus langka, pemeriksaan ultrasonografi pertengahan kehamilan dapat mengungkapkan masalah terkait plasenta seperti plasenta akreta atau plasenta previa. Percayakan pada penyedia layanan kesehatan Anda untuk memandu Anda dan memberikan perawatan yang sesuai untuk mengatasi potensi risiko yang terkait dengan kondisi-kondisi ini.</li>
</ul>""",
    "tips_mingguan_en": """<h2>18 Weeks Pregnant: Things to Consider</h2>
<ul>
  <li><strong>Focus on omega-3 fatty acids:</strong> Ensuring you and your baby receive adequate nutrition is crucial. Omega-3 fatty acids support healthy brain development for your baby during pregnancy and after birth. Incorporate foods rich in omega-3s, such as salmon, flaxseed, broccoli, or walnuts, into your diet. You can find more information on pregnancy nutrition in our downloadable pregnancy guide.</li>
  <li><strong>Maintain a balanced diet:</strong> While you'll need extra calories to support your baby's growth, you don’t need to double your food intake. In the second trimester, aim for an additional 300 calories per day on top of the average 2,000 calories. Our pregnancy weight gain calculator can help you monitor your weight during pregnancy.</li>
  <li><strong>Handle unsolicited pregnancy advice gracefully:</strong> It's common to receive advice from various sources, but you don't have to follow all suggestions. Respond politely to unwanted advice, acknowledging the input without feeling obligated to implement it. Remember that most people mean well and are simply excited for you.</li>
  <li><strong>Trust your healthcare provider:</strong> In rare cases, mid-pregnancy ultrasounds may reveal placenta-related issues such as placenta accreta or placenta previa. Trust your healthcare provider to guide you and provide appropriate care to address any potential risks associated with these conditions.</li>
</ul>""",
    "bayi_img_path": "week_18.jpg",
    "ukuran_bayi_img_path": "week_18_bellpepper.svg"
  },
  {
    "id": "19",
    "minggu_kehamilan": "19",
    "berat_janin": 273,
    "tinggi_badan_janin": 240,
    "ukuran_bayi_id": "Tomat Pusaka",
    "ukuran_bayi_en": "Heirloom Tomato",
    "poin_utama_id": """<h2>Highlights pada Minggu ke-19 Kehamilan</h2>
<ul>
  <li>Bayi Anda kira-kira sebesar mangga pada usia kehamilan 19 minggu.</li>
  <li>Anda mungkin merasakan gerakan bayi Anda pada usia kehamilan 19 minggu, tetapi jika belum, bersiaplah untuk getaran perut yang lembut dalam beberapa minggu mendatang.</li>
  <li>Ginjal bayi Anda sekarang dapat memproduksi urin.</li>
  <li>Saat perut kehamilan Anda semakin mencolok, pertimbangkan untuk berbagi pengumuman kehamilan atau mengatur acara pemaparan jenis kelamin jika Anda baru saja mengetahui jenis kelamin.</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 19 Weeks Pregnant</h2>
<ul>
  <li>Your baby is approximately the size of a mango at 19 weeks.</li>
  <li>You might notice your baby's movements at 19 weeks pregnant, but if not yet, be prepared for those gentle belly flutters in the upcoming weeks.</li>
  <li>Your baby's kidneys are now able to produce urine.</li>
  <li>As your baby bump becomes more noticeable, consider sharing pregnancy announcements or organizing a gender reveal if you've recently discovered the gender.</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>Perkembangan Bayi Anda pada Usia Kehamilan 19 Minggu</h2>
<ul>
  <li>Jika Anda sedang mengandung seorang anak perempuan, sistem reproduksinya sudah terbentuk dengan baik. Vagina, rahim, dan saluran tuba sudah berada di tempatnya, dan ovarium mengandung lebih dari 6 juta sel telur primitif. Angka itu akan berkurang menjadi sekitar 1 juta saat ia lahir.</li>
  <li>Jika Anda sedang mengandung seorang anak laki-laki, testisnya telah terbentuk dan telah mengeluarkan testosteron sejak sekitar minggu ke-10 kehamilan Anda. Alat kelamin eksternal terus tumbuh.</li>
  <li>Kulit mulai memproduksi lapisan pelindung yang disebut vernix caseosa, terbuat dari minyak kulit, sel-sel mati, dan lanugo (rambut tubuh halus). Vernix melindungi kulit bayi dari efek mengambang di dalam cairan amnion. Sebagian besar akan menghilang sebelum kelahiran, tetapi bayi prematur sering lahir masih tertutup banyak vernix.</li>
  <li>Ginjal bayi Anda sekarang cukup berkembang untuk memproduksi urin, yang dikeluarkan ke dalam cairan amnion.</li>
  <li>Sekitar usia kehamilan 19 minggu, bayi Anda mulai memiliki pola tidur dan bangun yang lebih teratur. Mereka mungkin akan terbangun karena gerakan dan suara.</li>
</ul>""",
    "perkembangan_bayi_en": """<h2>19 Weeks Pregnant: Your Baby’s Development</h2>
<ul>
  <li>If you're expecting a girl, her reproductive system is now fully formed, including the vagina, uterus, and fallopian tubes. Her ovaries contain over 6 million primitive egg cells, which will decrease to about 1 million by birth.</li>
  <li>If you're having a boy, his testicles have developed, and they've been producing testosterone since around week 10 of pregnancy. The external genitals continue to grow.</li>
  <li>The skin begins to produce a protective coating called vernix caseosa, made of skin oils, dead cells, and lanugo (fine body hair). Vernix shields the baby's skin from the amniotic fluid. Although most of it will vanish before birth, preterm babies may still be born covered in vernix.</li>
  <li>Your baby's kidneys are now mature enough to produce urine, which is released into the amniotic fluid.</li>
  <li>Around 19 weeks pregnant, your baby starts to establish more regular sleep and wake cycles. They may respond to movements and sounds by waking up.</li>
</ul>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda pada Usia Kehamilan 19 Minggu</h2>
<p>Pada usia kehamilan 19 minggu, Anda mungkin merasakan lebih banyak ketidaknyamanan karena perut Anda membesar, dengan kemungkinan bengkak di kaki dan kadang-kadang pusing, hidung tersumbat, dan sakit punggung.</p>
<p>Namun, kegembiraan merasakan gerakan bayi Anda, seperti sentuhan ringan atau tendangan, akan mengatasi segala ketidaknyamanan.</p>
<p>Jika Anda mengalami lonjakan energi, pertimbangkan untuk menggunakannya untuk mempersiapkan kedatangan bayi Anda, seperti mengatur daftar hadiah untuk pesta bayi Anda dan merencanakan perlengkapan bayi penting.</p>
<p>Tetapi ingatlah untuk membatasi diri dan memberi prioritas pada istirahat dan relaksasi kapan pun memungkinkan untuk menghindari kelelahan berlebihan.</p>""",
    "perubahan_tubuh_en": """<h2>Your Body at 19 Weeks</h2>
<p>At 19 weeks pregnant, you might notice more discomfort as your belly grows, with possible swelling in your feet and occasional dizziness, nasal congestion, and backaches.</p>
<p>However, the joy of feeling your baby's movements, like flutters or kicks, will outweigh any discomfort.</p>
<p>If you're experiencing bursts of energy, consider using them to prepare for your baby's arrival, such as organizing your baby shower registry and planning for essential baby items.</p>
<p>But remember to pace yourself and prioritize rest and relaxation whenever possible to avoid overexertion.</p>""",
    "gejala_umum_id": """<h2>Gejala Kehamilan 19 Minggu</h2>
<ul>
  <li><strong>Perubahan kulit:</strong> Bercak gelap di hidung, pipi, dan dahi, yang dikenal sebagai chloasma, umum terjadi selama kehamilan akibat perubahan hormonal. Bercak ini, bersama dengan garis gelap di perut (linea nigra), akan memudar setelah melahirkan. Paparan sinar matahari dapat memperdalam pigmentasi, jadi gunakan tabir surya dan pakaian pelindung.</li>
  <li><strong>Sakit ligamen bundar:</strong> Saat rahim Anda membesar, ligamen bundar yang menopangnya meregang, menyebabkan rasa sakit tajam atau tumpul sesekali di perut bagian bawah. Istirahat bisa memberikan bantuan, tetapi hubungi penyedia layanan kesehatan Anda jika rasa sakitnya parah atau disertai dengan gejala lain.</li>
  <li><strong>Sakit punggung bagian bawah:</strong> Sakit punggung sangat umum pada kehamilan, terutama ketika rahim Anda membesar dan mengubah pusat gravitasi tubuh Anda. Latihan, pakaian penyangga perut, dan terapi panas dapat membantu mengurangi ketidaknyamanan.</li>
  <li><strong>Konstipasi dan mimisan:</strong> Peningkatan kadar hormon dan produksi darah dapat menyebabkan hidung tersumbat dan mimisan. Gejala ini normal dan dapat diatasi dengan cara-cara yang lembut.</li>
  <li><strong>Pusing:</strong> Perubahan dalam sirkulasi darah dapat menyebabkan perasaan pingsan atau pusing. Hindari berdiri terlalu lama dan bergerak perlahan saat mengubah posisi. Berbaringlah di sisi Anda jika merasa pingsan dan tetap terhidrasi.</li>
</ul>""",
    "gejala_umum_en": """<h2>19 Weeks Pregnant: Your Symptoms</h2>
<ul>
  <li><strong>Skin changes:</strong> Dark patches on the nose, cheeks, and forehead, known as chloasma, are common during pregnancy due to hormonal changes. These patches, along with the linea nigra, will fade after giving birth. Sun exposure can darken the pigments further, so use sunscreen and protective clothing.</li>
  <li><strong>Round ligament pain:</strong> As your uterus expands, the round ligaments supporting it stretch, causing occasional sharp or dull pain in the lower abdomen. Rest can provide relief, but contact your healthcare provider if the pain is severe or accompanied by other symptoms.</li>
  <li><strong>Lower back pain:</strong> Backaches are common in pregnancy, especially as your uterus grows and shifts your center of gravity. Exercise, abdominal support garments, and heat therapy can help alleviate the discomfort.</li>
  <li><strong>Congestion and nosebleeds:</strong> Increased hormone levels and blood production may lead to nasal congestion and nosebleeds. These symptoms are normal and can be managed with gentle remedies.</li>
  <li><strong>Dizziness:</strong> Changes in circulation can cause feelings of faintness or lightheadedness. Avoid prolonged standing and move slowly when changing positions. Lie down on your side if feeling faint and stay hydrated.</li>
</ul>""",
    "tips_mingguan_id": """<h2>Kehamilan 19 Minggu: Hal-hal yang Perlu Dipertimbangkan</h2>
<ul>
  <li><strong>Tetap aktif:</strong> Menyertakan latihan ringan dalam rutinitas Anda bermanfaat baik untuk Anda maupun bayi Anda. Berjalan, berenang, dan yoga adalah pilihan yang bagus. Ingat untuk memakai sepatu yang nyaman dan bra olahraga yang pas. Konsultasikan dengan penyedia layanan kesehatan Anda untuk panduan tentang latihan yang sesuai selama kehamilan.</li>
  <li><strong>Posisi tidur:</strong> Saat perut Anda semakin membesar, tidur tengkurap dapat menimbulkan tekanan pada tulang belakang dan otot punggung, serta mengompresi pembuluh darah utama. Pilihlah untuk tidur dengan posisi miring dengan kedua kaki ditekuk dan sebuah bantal di antara kedua lutut. Jika Anda terbangun dalam posisi tengkurap, cukup pindah ke posisi miring.</li>
  <li><strong>Daftar hadiah untuk pesta bayi:</strong> Jika Anda akan mengadakan pesta bayi pada trimester ketiga, susun daftar hadiah dengan barang-barang penting jauh-jauh hari. Gunakan daftar periksa untuk memastikan Anda memiliki segala yang Anda butuhkan dan sertakan detail daftar hadiah dalam undangan.</li>
  <li><strong>Siapkan perlengkapan bayi:</strong> Luangkan waktu untuk melakukan penelitian dan berbelanja perlengkapan bayi, mempertimbangkan rekomendasi dari orangtua lain dan ulasan produk. Ingatlah, Anda mungkin tidak memerlukan semua yang diiklankan sebagai penting selama fase bayi baru lahir.</li>
  <li><strong>Revealisasi jenis kelamin:</strong> Jika Anda tertarik untuk mengetahui jenis kelamin bayi Anda, Anda kemungkinan besar akan memiliki kesempatan selama pemeriksaan ultrasonografi pertengahan kehamilan. Telusuri ilmu di balik penentuan jenis kelamin atau coba metode prediksi jenis kelamin yang ringan.</li>
</ul>""",
    "tips_mingguan_en": """<h2>19 Weeks Pregnant: Things to Consider</h2>
<ul>
  <li><strong>Stay active:</strong> Incorporating gentle exercise into your routine is beneficial for both you and your baby. Walking, swimming, and yoga are great options. Remember to wear supportive shoes and a well-fitted sports bra. Consult your healthcare provider for guidance on suitable exercises during pregnancy.</li>
  <li><strong>Sleeping positions:</strong> As your bump grows, sleeping on your back can put pressure on your spine and back muscles, as well as compress major blood vessels. Opt for sleeping on your side with both legs bent and a pillow between your knees. If you wake up on your back, simply switch to your side.</li>
  <li><strong>Baby shower registry:</strong> If you're having a baby shower in the third trimester, organize your registry with essential items well in advance. Use a checklist to ensure you have everything you need and include registry details in the invitations.</li>
  <li><strong>Prepare for baby gear:</strong> Take time to research and shop for baby gear, considering recommendations from other parents and product reviews. Remember, you may not need everything advertised as essential during the newborn phase.</li>
  <li><strong>Gender reveal:</strong> If you're interested in finding out your baby's gender, you'll likely have the opportunity during the mid-pregnancy ultrasound exam. Explore the science behind gender determination or try lighthearted gender prediction methods.</li>
</ul>""",
    "bayi_img_path": "week_19.jpg",
    "ukuran_bayi_img_path": "week_19_tomato.svg"
  },
  {
    "id": "20",
    "minggu_kehamilan": "20",
    "berat_janin": 331,
    "tinggi_badan_janin": 257,
    "ukuran_bayi_id": "Pisang",
    "ukuran_bayi_en": "Banana",
    "poin_utama_id": """<h2>Perkembangan Kehamilan 20 Minggu</h2>
<ul>
  <li>Bayi Anda kini memiliki ukuran sekitar sebesar paprika.</li>
  <li>Anda mungkin mulai merasakan gerakan bayi Anda lebih banyak minggu ini.</li>
  <li>Refleks menghisap bayi Anda sedang berkembang, dan mereka bahkan mungkin mulai mengisap jempol mereka.</li>
  <li>Kuku-kuku kecil mulai tumbuh di jari-jari tangan dan kaki bayi Anda.</li>
  <li>Jika Anda memiliki pemeriksaan rutin minggu ini, itu mungkin termasuk ultrasonografi untuk memantau pertumbuhan bayi Anda, dan Anda mungkin juga akan mengetahui jenis kelaminnya!</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 20 Weeks Pregnant</h2>
<ul>
  <li>Your baby is now approximately the size of a bell pepper.</li>
  <li>You might notice increased movement from your baby this week.</li>
  <li>Your baby's sucking reflex is developing, and they may start sucking their thumb.</li>
  <li>Small nails are beginning to grow on your baby's fingers and toes.</li>
  <li>If you have a checkup scheduled, it may include an ultrasound to monitor your baby's growth, and you may also find out the gender!</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>Kehamilan 20 Minggu: Perkembangan Bayi Anda</h2>
<ul>
  <li>Ciri-ciri wajah bayi Anda, termasuk hidung, mulai terbentuk lebih jelas, membuat mereka terlihat seperti bayi yang sebenarnya.</li>
  <li>Refleks mengisap mereka sedang berkembang dan mereka mungkin mulai mengisap jempol mereka minggu ini atau dalam waktu dekat.</li>
  <li>Kuku terus tumbuh di ujung jari tangan dan kaki mereka.</li>
  <li>Pertumbuhan otak yang cepat terus berlangsung, terutama di area yang didedikasikan untuk indra.</li>
  <li>Bayi Anda sedang menetapkan siklus tidur-bangun dan menjadi responsif terhadap suara di sekitarnya. Suara keras bahkan mungkin sesekali membangunkannya.</li>
  <li>Kulit mereka menjadi lebih tebal, dan lapisan-lapisan terbentuk, dilindungi oleh zat lilin dari cairan amnion yang disebut verniks.</li>
  <li>Pada sekitar 20 minggu kehamilan, sistem pencernaan mereka mulai memproduksi mekonium, suatu zat berwarna hijau-kehitaman yang menumpuk di usus mereka sampai lahir.</li>
</ul>""",
    "perkembangan_bayi_en": """<h2>20 Weeks Pregnant: Your Baby's Development</h2>
<ul>
  <li>Your baby's facial features, including the nose, are becoming more defined, making them look more like a baby.</li>
  <li>They are developing their sucking reflex and may start sucking their thumb this week or in the near future.</li>
  <li>Nails continue to grow on their fingertips and toes.</li>
  <li>Rapid brain growth is ongoing, especially in areas dedicated to the senses.</li>
  <li>Your baby is establishing a sleep-wake cycle and becoming responsive to sounds in their environment. Loud noises might even wake them occasionally.</li>
  <li>Their skin is thickening, and layers are forming, protected by a waxy substance called vernix from the amniotic fluid.</li>
  <li>By around 20 weeks of pregnancy, their digestive system starts producing meconium, a greenish-black substance that accumulates in their bowels until birth.</li>
</ul>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda Saat Hamil 20 Minggu</h2>
<p>Pada tahap kehamilan ini, Anda mungkin mulai merasakan gerakan janin, yang disebut quickening, untuk pertama kalinya. Waktu dan sensasi dari perasaan ini berbeda-beda dari wanita ke wanita, menjadikan setiap kehamilan unik. Anda mungkin merasakan getaran atau gemuruh kecil di perut Anda. Dalam beberapa minggu mendatang, Anda juga mungkin melihat gerakan berirama, yang mungkin disebabkan oleh bayi sedang cegukan!</p>""",
    "perubahan_tubuh_en": """<h2>Your Body at 20 Weeks Pregnant</h2>
<p>At this stage of your pregnancy, you may start to experience quickening, which is when you feel your baby move for the first time. The timing and sensation of this vary from woman to woman, making each pregnancy unique. You might feel tiny flutters or rumblings in your tummy. In the upcoming weeks, you may also notice rhythmic jerking, which could be your baby having hiccups!</p>""",
    "gejala_umum_id": """<h2>Gejala Anda saat Hamil 20 Minggu</h2>
<ul>
  <li><strong>Kesulitan Buang Air Besar:</strong> Perubahan hormonal dan tekanan dari janin yang berkembang pada usus Anda dapat menyebabkan kesulitan buang air besar. Meningkatkan asupan air dan konsumsi serat lebih banyak dapat membantu mengurangi ketidaknyamanan ini.</li>
  <li><strong>Kongesti dan Pendarahan Hidung:</strong> Fluktuasi hormon dan peningkatan volume darah selama kehamilan dapat menyebabkan pembengkakan dan pengeringan selaput lendir hidung, yang menyebabkan kongesti dan pendarahan hidung. Menggunakan pelembap udara dan menjaga asupan cairan dapat membantu mengurangi gejala ini.</li>
  <li><strong>Sakit Punggung Bawah:</strong> Saat perut Anda membesar dan Anda menambah berat badan selama kehamilan, Anda mungkin mengalami sakit punggung bagian bawah, terutama pada akhir hari. Menggunakan sepatu dengan hak rendah, melakukan latihan ringan untuk meregangkan dan menguatkan otot punggung, dan menggunakan ikat pinggang penyangga perut dapat memberikan bantuan.</li>
  <li><strong>Lupa:</strong> Kesulitan berkonsentrasi dan lupa adalah hal yang umum selama kehamilan. Membuat daftar periksa atau pengingat dan mengambil istirahat selama melakukan tugas yang membutuhkan konsentrasi dapat menjadi strategi yang membantu.</li>
  <li><strong>Kaki Bengkak:</strong> Kenaikan berat badan, retensi cairan, dan hormon relaxin dapat menyebabkan kaki bengkak selama kehamilan. Meninggikan kaki Anda, menggunakan sepatu yang nyaman dengan ruang ekstra, dan menggunakan alas kaki atau bantal untuk dukungan dapat mengurangi ketidaknyamanan.</li>
</ul>""",
    "gejala_umum_en": """<h2>20 Weeks Pregnant: Your Symptoms</h2>
<ul>
  <li><strong>Constipation:</strong> Hormonal changes and pressure from your growing baby on your intestines can cause constipation. Increasing your water intake and consuming more fiber can help alleviate this discomfort.</li>
  <li><strong>Congestion and Nosebleeds:</strong> Hormonal fluctuations and increased blood volume during pregnancy can lead to swollen and dry nasal membranes, resulting in congestion and nosebleeds. Using a humidifier and staying hydrated can help reduce these symptoms.</li>
  <li><strong>Lower Back Pain:</strong> As your belly expands and you gain weight during pregnancy, you may experience lower back pain, especially by the end of the day. Wearing low-heeled shoes, engaging in gentle exercises to stretch and strengthen your back muscles, and using a belly support band can provide relief.</li>
  <li><strong>Forgetfulness:</strong> Difficulty concentrating and forgetfulness are common during pregnancy. Creating checklists or reminders and taking breaks during tasks requiring concentration can be helpful coping strategies.</li>
  <li><strong>Swollen Feet:</strong> Weight gain, fluid retention, and the hormone relaxin can contribute to swollen feet during pregnancy. Elevating your feet, wearing comfortable shoes with extra space, and using footrests or pillows for support can alleviate discomfort.</li>
</ul>""",
    "tips_mingguan_id": """<h2>Hamil 20 Minggu: Hal yang Perlu Dipertimbangkan</h2>
<ul>
  <li>Dokter kandungan Anda mungkin menyarankan pemeriksaan ultrasonografi sekitar 18 hingga 20 minggu untuk memastikan segalanya berjalan lancar, termasuk ukuran, posisi, dan perkembangan organ bayi. Pemeriksaan ini juga dapat mengungkap usia kehamilan, gerakan bayi, detak jantung, posisi plasenta, dan kadar cairan ketuban.</li>
  <li>Anda mungkin mengetahui jenis kelamin bayi selama ultrasonografi ini atau memilih menunggu untuk dibuat kaget. Konsultasikan dengan dokter kandungan Anda jika Anda memiliki kekhawatiran tentang ultrasonografi.</li>
  <li>Trimester kedua adalah waktu yang cocok untuk melakukan perjalanan karena gejala kehamilan seringkali lebih ringan, dan perut Anda belum terlalu besar. Namun, bersikap fleksibel dengan rencana perjalanan Anda, tetap terhidrasi, beristirahat, dan periksa dengan dokter kandungan dan maskapai penerbangan jika Anda berencana terbang.</li>
  <li>Libatkan pasangan Anda dalam perjalanan kehamilan Anda dengan menghadiri janji dan ultrasonografi bersama, mendekorasi ruang bayi, dan menghadiri kelas persalinan. Pertimbangkan untuk mendiskusikan persiapan sebagai orang tua dan dekorasi ruang bayi bersama.</li>
  <li>Mulailah merencanakan skema warna atau tema untuk ruang bayi Anda, pertimbangkan warna cat netral atau dekorasi bertema. Cari inspirasi secara online dan libatkan pasangan Anda dalam proses pengambilan keputusan.</li>
  <li>Penelitian produk bayi dengan ulasan dari orang tua lainnya untuk membuat keputusan yang tepat tentang ranjang bayi, kereta dorong, dan kursi mobil.</li>
</ul>""",
    "tips_mingguan_en": """<h2>20 Weeks Pregnant: Things to Consider</h2>
<ul>
  <li>Your healthcare provider may suggest an ultrasound around 18 to 20 weeks to ensure everything is progressing well, including your baby's size, position, and organ development. This scan can also reveal the baby's gestational age, movement, heart rate, placenta position, and amniotic fluid levels.</li>
  <li>You might find out your baby's gender during this ultrasound or choose to wait for a surprise. Consult your healthcare provider if you have any concerns about the ultrasound.</li>
  <li>The second trimester is a suitable time for travel since pregnancy symptoms are often milder, and your belly isn't too large yet. However, be flexible with your plans, stay hydrated, take breaks, and check with your healthcare provider and airline if you plan to fly.</li>
  <li>Involve your partner in your pregnancy journey by attending appointments and ultrasounds together, decorating the nursery, and attending childbirth classes. Consider discussing fatherhood preparation and nursery decor together.</li>
  <li>Start planning the color scheme or theme for your baby's nursery, considering neutral paint colors or themed decorations. Seek inspiration online and involve your partner in the decision-making process.</li>
  <li>Research baby products with reviews from other parents to make informed decisions about cribs, strollers, and car seats.</li>
</ul>""",
    "bayi_img_path": "week_20.jpg",
    "ukuran_bayi_img_path": "week_20_banana.svg"
  },
  {
    "id": "21",
    "minggu_kehamilan": "21",
    "berat_janin": 399,
    "tinggi_badan_janin": 274,
    "ukuran_bayi_id": "Wortel",
    "ukuran_bayi_en": "Carrot",
    "poin_utama_id": """<h2>Perkembangan pada Minggu ke-21 Kehamilan</h2>
<ul>
  <li>Pola tidur dan bangun bayi Anda menjadi lebih teratur.</li>
  <li>Anda mungkin menyadari gerakan yang lebih kuat dari bayi di dalam perut Anda pada tahap ini.</li>
  <li>Meskipun Anda mungkin mengalami beberapa ketidaknyamanan pada usia kehamilan 21 minggu, Anda juga mungkin menikmati peningkatan energi selama trimester kedua.</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 21 Weeks Pregnant</h2>
<ul>
  <li>Your baby's sleep and wake pattern is becoming more consistent.</li>
  <li>You might notice stronger movements from your baby inside your belly at this stage.</li>
  <li>While you may experience some discomforts at 21 weeks pregnant, you might also enjoy a boost of energy during your second trimester.</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>Perkembangan Bayi Anda pada Minggu ke-21 Kehamilan</h2>
<ul>
  <li>Bayi Anda mulai membentuk siklus tidur dan bangun, dan mereka mungkin memiliki posisi tidur favorit di dalam kandungan pada saat ini.</li>
  <li>Pada usia kehamilan 21 minggu, bayi Anda mungkin terlihat mengisap ibu jari selama pemeriksaan ultrasonografi.</li>
  <li>Pada tahap ini, sistem pencernaan bayi Anda sedang berkembang, memungkinkan mereka menelan sejumlah kecil cairan amnion.</li>
  <li>Hati dan limpa bayi telah memproduksi sel darah, dan sekarang sumsum tulang juga turut serta dalam proses ini, yang akan menjadi fungsi utamanya sebelum kelahiran.</li>
</ul>""",
    "perkembangan_bayi_en": """<h2>21 Weeks Pregnant: Your Baby’s Development</h2>
<ul>
  <li>Your baby is starting to establish sleep and wake cycles, and they may have a preferred position for sleeping in the womb by now.</li>
  <li>Around 21 weeks, your baby might be seen sucking their thumb during an ultrasound.</li>
  <li>At this stage, your baby's digestive system is maturing, allowing them to swallow small amounts of amniotic fluid.</li>
  <li>The liver and spleen have been producing blood cells, and now the bone marrow is also aiding in this process, which will become its primary function before birth.</li>
</ul>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda saat Hamil 21 Minggu</h2>
<p>Pada awal kehamilan, Anda mungkin telah mengalami heartburn dan masalah pencernaan. Namun, sekitar usia kehamilan 21 minggu, seiring pertumbuhan bayi dan rahim Anda yang membesar, bisa saja menekan lambung Anda lebih sering, menyebabkan serangan heartburn yang lebih sering.</p>
<p>Pada tahap ini, hormon kehamilan Anda juga dapat menyebabkan hot flashes, sementara penambahan berat badan tambahan dapat menyebabkan berbagai rasa sakit baik saat ini maupun dalam beberapa minggu mendatang.</p>""",
    "perubahan_tubuh_en": """<h2>Your Body at 21 Weeks Pregnant</h2>
<p>Earlier in your pregnancy, you might have experienced heartburn and indigestion. However, at around 21 weeks pregnant, as your baby grows and your uterus expands, it can press against your stomach more, leading to more frequent episodes of heartburn.</p>
<p>Around this stage, your pregnancy hormones may also cause hot flashes, while the additional weight gain can result in various aches and pains both now and in the upcoming weeks.</p>""",
    "gejala_umum_id": """<h2>Gejala Hamil 21 Minggu: Anda Sedang Mengalami</h2>
<ul>
  <li><strong>Nyeri:</strong> Sakit punggung, terutama di bagian bawah, cukup umum terjadi selama kehamilan. Saat Anda hamil 21 minggu, perut yang membesar menggeser pusat gravitasi tubuh Anda, menyebabkan nyeri dan sakit di bagian bawah punggung. Perubahan hormonal juga melonggarkan sendi dan ligamen di daerah panggul, mempersiapkan persalinan.</li>
  <li><strong>Heartburn:</strong> Gejala umum lainnya adalah heartburn, disebabkan oleh rahim yang menekan lambung dan hormon kehamilan yang melemaskan katup antara kerongkongan dan lambung.</li>
  <li><strong>Hot flashes:</strong> Hormon kehamilan dan peningkatan laju metabolisme dapat menyebabkan rasa panas dan keringat. Tetaplah dingin dengan mengenakan pakaian longgar, minum banyak air, dan menggunakan kipas angin atau AC.</li>
  <li><strong>Stretch marks:</strong> Saat perut Anda membesar, Anda mungkin melihat garis-garis merah kecoklatan, merah muda, atau ungu di kulit Anda. Stretch marks terjadi saat kulit meregang dengan cepat, sering disertai dengan rasa gatal.</li>
  <li><strong>Kram kaki:</strong> Kram kaki, terutama pada malam hari, umum terjadi pada trimester kedua. Memanjangkan otot betis, minum banyak air, dan mandi air hangat dapat membantu mengurangi ketidaknyamanan.</li>
  <li><strong>Braxton Hicks:</strong> Kontraksi latihan ini, dirasakan sebagai sedikit perut yang mengencang, adalah normal pada trimester kedua atau ketiga. Berbeda dengan rasa sakit tajam, yang mungkin menunjukkan masalah lain seperti nyeri ligamen bulanannya.</li>
</ul>""",
    "gejala_umum_en": """<h2>21 Weeks Pregnant: Your Symptoms</h2>
<ul>
  <li><strong>Sore spots:</strong> Backaches, particularly in the lower back, are quite common during pregnancy. At 21 weeks pregnant, your growing belly shifts your center of gravity, leading to aches and pains in your lower back. Hormonal changes also loosen joints and ligaments in the pelvic area, preparing for delivery.</li>
  <li><strong>Heartburn:</strong> Another common symptom is heartburn, caused by the uterus pressing against the stomach and pregnancy hormones relaxing the valve between the esophagus and stomach.</li>
  <li><strong>Hot flashes:</strong> Pregnancy hormones and increased metabolic rate can cause feelings of heat and sweating. Stay cool by wearing loose clothing, staying hydrated, and using fans or air conditioning.</li>
  <li><strong>Stretch marks:</strong> As your belly expands, you may notice reddish-brown, pink, or purple lines on your skin. Stretch marks occur when the skin stretches rapidly, often accompanied by itching.</li>
  <li><strong>Leg cramps:</strong> Leg cramps, particularly at night, are common in the second trimester. Stretching calf muscles, staying hydrated, and warm baths may help alleviate discomfort.</li>
  <li><strong>Braxton Hicks:</strong> These practice contractions, felt as slight tightening in the abdomen, are normal in the second or third trimester. Different from sharp pains, which may indicate other issues like round ligament pain.</li>
</ul>""",
    "tips_mingguan_id": """<h2>Hamil 21 Minggu: Hal yang Perlu Dipertimbangkan</h2>
<ul>
  <li>Untuk mengurangi nyeri punggung, cobalah untuk mengubah rutinitas harian Anda. Gunakan alas kaki saat duduk untuk mengangkat kaki Anda, dan pertimbangkan untuk menaruh satu kaki di atas bangku kecil saat berdiri dalam waktu yang lama. Berendam air hangat juga bisa memberikan bantuan, dan konsultasikan dengan penyedia layanan kesehatan Anda jika nyeri tetap berlanjut.</li>
  <li>Vitamin B, seperti B1, B2, dan B6, sangat penting untuk perkembangan bayi Anda. Nutrisi ini menyediakan energi, mendukung penglihatan, dan berkontribusi pada pertumbuhan plasenta dan jaringan tubuh. Meskipun suplemen prenatal umumnya menyediakan cukup vitamin B, Anda juga bisa mendapatkannya dari makanan seperti hati, daging babi, unggas, pisang, dan kacang-kacangan.</li>
  <li>Kolin adalah nutrisi penting lainnya selama kehamilan, karena tubuh Anda mungkin tidak menghasilkan cukup untuk Anda dan bayi Anda. Tambahkan makanan yang kaya akan kolin ke dalam diet Anda, seperti ayam, daging sapi, telur, susu, dan kacang-kacangan. Untuk tips nutrisi lebih lanjut, lihat panduan kehamilan yang dapat diunduh kami.</li>
  <li>Saat rahim Anda membesar, pusat gravitasi tubuh Anda mungkin bergeser, meningkatkan risiko ketidakseimbangan. Gunakan sepatu datar, berhati-hatilah di tangga, dan hindari permukaan licin untuk mencegah jatuh. Jika Anda jatuh dan mengalami kekhawatiran, pendarahan, atau kontraksi, hubungi penyedia layanan kesehatan Anda.</li>
  <li>Gunakan beberapa bulan ke depan untuk mempersiapkan kedatangan bayi Anda, karena tingkat energi mungkin akan menurun di trimester ketiga. Siapkan kamar bayi, susun daftar barang bayi yang diperlukan, dan buat anggaran bayi jika Anda belum melakukannya.</li>
  <li>Tetap aktif selama kehamilan sangat bermanfaat. Konsultasikan dengan penyedia layanan kesehatan Anda untuk rekomendasi latihan yang aman. Berjalan, yoga prenatal, dan renang biasanya adalah pilihan yang cocok.</li>
</ul>""",
    "tips_mingguan_en": """<h2>21 Weeks Pregnant: Things to Consider</h2>
<ul>
  <li>To ease back pain, try adjusting your daily routine. Use a footrest when sitting to elevate your feet, and consider putting one foot on a small stool when standing for long periods. Treat yourself to a warm bath for added relief, and consult your healthcare provider if the pain persists.</li>
  <li>B vitamins, such as B1, B2, and B6, are crucial for your baby's development. These nutrients provide energy, support vision, and contribute to placental and tissue growth. While prenatal supplements typically provide sufficient B vitamins, you can also obtain them from foods like liver, pork, poultry, bananas, and beans.</li>
  <li>Choline is another essential nutrient during pregnancy, as your body may not produce enough for both you and your baby. Incorporate foods rich in choline into your diet, such as chicken, beef, eggs, milk, and peanuts. For more nutrition tips, refer to our downloadable pregnancy guide.</li>
  <li>As your uterus enlarges, your center of gravity may shift, increasing the risk of imbalance. Wear flat shoes, use caution on stairs, and avoid slippery surfaces to prevent falls. If you do fall and experience concerns, bleeding, or contractions, contact your healthcare provider.</li>
  <li>Use the next few months to prepare for your baby's arrival, as energy levels may decrease in the third trimester. Set up the nursery, compile a list of necessary baby items, and create a baby budget if you haven't already.</li>
  <li>Remaining active throughout pregnancy is beneficial. Consult your healthcare provider for safe exercise recommendations. Walking, prenatal yoga, and swimming are typically suitable options.</li>
</ul>""",
    "bayi_img_path": "week_21.jpg",
    "ukuran_bayi_img_path": "week_21_carrot.svg"
  },
  {
    "id": "22",
    "minggu_kehamilan": "22",
    "berat_janin": 478,
    "tinggi_badan_janin": 290,
    "ukuran_bayi_id": "Labu Spaghetti",
    "ukuran_bayi_en": "Spaghetti Squash",
    "poin_utama_id": """<h2>Hal-Hal Menarik pada Minggu ke-22 Kehamilan</h2>
<ul>
  <li>Bayi Anda sekarang memiliki alis mata kecil!</li>
  <li>Di sekitar usia kehamilan 22 minggu, bayi Anda menjadi lebih responsif terhadap suara, dan Anda mungkin melihat mereka bereaksi terhadap suara selama ultrasonografi.</li>
  <li>Pada usia kehamilan 22 minggu, indra sentuhan bayi Anda telah berkembang.</li>
  <li>Anda mungkin mulai merasakan sensasi mirip kontraksi ringan di perut Anda segera, yang kemungkinan adalah kontraksi Braxton Hicks dan normal.</li>
  <li>Saat perut Anda membesar dan Anda mendapatkan berat badan, Anda mungkin menyadari berbagai perubahan dalam tubuh Anda pada usia kehamilan 22 minggu. Jika Anda khawatir tentang penambahan berat badan, pantau diet kehamilan Anda, dan ingatlah, Anda membawa seorang manusia kecil! Penyedia layanan kesehatan Anda akan memantau berat badan Anda dan memberikan panduan jika diperlukan.</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 22 Weeks Pregnant</h2>
<ul>
  <li>Your baby now has small eyebrows!</li>
  <li>Around 22 weeks, your baby becomes more responsive to sounds, and you might notice them reacting to noises during an ultrasound.</li>
  <li>At 22 weeks pregnant, your baby's sense of touch has developed.</li>
  <li>You may start feeling mild contraction-like sensations in your abdomen soon, which are likely Braxton Hicks contractions and are normal.</li>
  <li>As your baby bump grows and you gain weight, you may notice various changes in your body at 22 weeks pregnant. If you're worried about weight gain, monitor your pregnancy diet, and remember, you're carrying a small human! Your healthcare provider will monitor your weight and provide guidance if necessary.</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>Perkembangan Bayi Anda pada Usia Kehamilan 22 Minggu</h2>
<ul>
  <li>Saat Anda berusia 22 minggu dalam kehamilan, meskipun kelopak mata bayi Anda masih menyatu, mata mereka mulai bergerak.</li>
  <li>Duktus air mata juga sedang terbentuk dan bayi Anda sekarang memiliki alis mata—gumpalan-gumpalan rambut putih halus. Bayi Anda mungkin sedang mengernyitkan kening!</li>
  <li>Bayi Anda semakin responsif terhadap rangsangan eksternal. Jika Anda menjalani [ultrasonografi](https://www.pampers.com/en-us/pregnancy/prenatal-health-and-wellness/article/ultrasounds-during-pregnancy) pada usia kehamilan 22 minggu dan terjadi suara keras selama pemeriksaan, Anda mungkin melihat reaksi bayi Anda, seperti menarik lengan dan kaki mereka lebih dekat satu sama lain.</li>
  <li>Pertumbuhan otak bayi Anda berlangsung cepat, dengan ujung saraf yang terbentuk. Pada tahap ini, bayi Anda telah mengembangkan indera sentuhan, yang memungkinkan mereka untuk menjelajahi dengan menyentuh bagian tubuh yang dapat mereka jangkau atau mengisap jempol.</li>
  <li>Bayi Anda mulai mengumpulkan lapisan lemak cokelat, yang membantu mengatur suhu tubuh mereka.</li>
</ul>""",
    "perkembangan_bayi_en": """<h2>22 Weeks Pregnant: Your Baby's Development</h2>
<ul>
  <li>At 22 weeks pregnant, although your baby's eyelids remain fused shut, their eyes are beginning to move.</li>
  <li>Tear ducts are forming, and your baby now has eyebrows—small tufts of fine white hair. Your baby might even be furrowing their brows!</li>
  <li>Your baby is becoming increasingly responsive to external stimuli. During an ultrasound at 22 weeks, if a loud noise occurs, you might observe your baby's reaction, such as pulling their arms and legs closer together.</li>
  <li>Rapid brain development is taking place, with nerve endings forming. At this stage, your baby has developed a sense of touch, allowing them to explore by stroking body parts they can reach or sucking their thumb.</li>
  <li>Your baby is beginning to accumulate layers of brown fat, which helps regulate their body temperature.</li>
</ul>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda saat Hamil 22 Minggu</h2>
<p>Saat perut Anda semakin terlihat pada usia kehamilan 22 minggu, Anda mungkin menemukan bahwa semakin banyak orang yang bisa mengatahui bahwa Anda sedang hamil, membuat tahap baru dalam hidup Anda terasa semakin nyata.</p>
<p>Dengan pertumbuhan perut Anda, Anda mungkin mengalami tantangan dengan citra tubuh Anda. Beberapa hari, Anda mungkin merasa positif tentang tubuh hamil Anda, sementara pada hari-hari lain, Anda mungkin merasa tidak nyaman dengan perubahan fisik dan khawatir apakah Anda akan kembali memiliki penampilan seperti sebelumnya.</p>
<p>Mengalami emosi seperti ini adalah hal yang umum, dan mungkin akan membantu untuk membicarakannya dengan orang-orang terdekat atau penyedia layanan kesehatan Anda. Makan dengan sehat dan berolahraga secara teratur juga dapat membantu Anda merasa lebih baik.</p>""",
    "perubahan_tubuh_en": """<h2>Your Body at 22 Weeks Pregnant</h2>
<p>As your belly becomes more noticeable around 22 weeks, you may find that more people can tell you're pregnant, which can make this new stage in your life feel more real.</p>
<p>With the growth of your belly, you might experience challenges with your body image. Some days, you may feel positively about your pregnant body, while on other days, you may feel uncomfortable with the physical changes and worry about whether you'll ever regain your previous appearance.</p>
<p>Experiencing these emotions is common, and it may be helpful to discuss them with your loved ones or healthcare provider. Eating healthily and engaging in regular exercise can also contribute to feeling better.</p>""",
    "gejala_umum_id": """<h2>Gejala Anda saat Hamil 22 Minggu</h2>
<ul>
  <li><strong>Heartburn:</strong> Anda mungkin mengalami sensasi terbakar di tenggorokan dan dada, yang dikenal sebagai heartburn, yang terjadi ketika asam lambung bocor ke kerongkongan. Ini umum terjadi selama kehamilan karena perubahan hormon. Makan dalam porsi kecil, tetap tegak setelah makan, dan menghindari makanan pedas dan digoreng dapat membantu meredakannya.</li>
  <li><strong>Hot flashes:</strong> Perubahan hormon dan metabolisme yang meningkat dapat membuat Anda merasa lebih panas dan berkeringat dari biasanya. Mengenakan pakaian longgar, minum banyak air, dan menggunakan kipas angin atau AC dapat membantu Anda tetap sejuk.</li>
  <li><strong>Jantung berdebar:</strong> Jantung Anda memompa hingga 30 hingga 50 persen lebih banyak darah selama kehamilan, memberikan lebih banyak oksigen dan nutrisi kepada bayi Anda. Merasa jantung berdebar bisa normal, tetapi jika disertai sesak napas atau detak jantung yang cepat dan berlangsung lama, hubungi penyedia layanan kesehatan Anda.</li>
  <li><strong>Nyeri panggul:</strong> Hormon kehamilan melonggarkan sendi, menyebabkan nyeri panggul. Hindari mengangkat benda berat dan berdiri terlalu lama untuk mengurangi ketidaknyamanan.</li>
  <li><strong>Nyeri atau kram perut:</strong> Anda mungkin mengalami kram rahim ringan atau nyeri perut, mungkin disebabkan oleh kontraksi Braxton Hicks atau peregangan otot perut. Hubungi penyedia layanan kesehatan Anda jika nyeri tersebut berlanjut, memburuk, atau disertai dengan gejala lain seperti pendarahan atau diare.</li>
</ul>""",
    "gejala_umum_en": """<h2>22 Weeks Pregnant: Your Symptoms</h2>
<ul>
  <li><strong>Heartburn:</strong> You might experience a burning sensation in your throat and chest, known as heartburn, which occurs when stomach acids leak into the esophagus. It's common during pregnancy due to hormonal changes. Eating small meals, staying upright after eating, and avoiding spicy and fried foods can help alleviate it.</li>
  <li><strong>Hot flashes:</strong> Hormonal changes and increased metabolism may cause you to feel hotter and sweatier than usual. Wearing loose clothes, staying hydrated, and using fans or air conditioning can help you stay cool.</li>
  <li><strong>Racing heart:</strong> Your heart pumps up to 30 to 50 percent more blood during pregnancy, delivering more oxygen and nutrients to your baby. Feeling a racing heart can be normal, but if accompanied by shortness of breath or persistent rapid heartbeat, contact your healthcare provider.</li>
  <li><strong>Pelvic pain:</strong> Pregnancy hormones loosen joints, causing pelvic pain. Avoid lifting heavy objects and prolonged standing to alleviate discomfort.</li>
  <li><strong>Abdominal pain or cramping:</strong> You may experience mild uterine cramps or abdominal pain, possibly due to Braxton Hicks contractions or abdominal muscle stretching. Contact your healthcare provider if the pain persists, worsens, or is accompanied by other symptoms such as bleeding or diarrhea.</li>
</ul>""",
    "tips_mingguan_id": """<h2>Hal yang Perlu Dipertimbangkan saat Hamil 22 Minggu</h2>
<ul>
  <li>Terapkan teknik-teknik pengurangan stres untuk mengelola kekhawatiran selama kehamilan. Strategi seperti mengurangi jam kerja, menyerahkan tugas kepada orang lain, berolahraga, dan berbicara dengan orang yang dipercaya tentang ketakutan dan kecemasan Anda dapat membantu mengurangi stres.</li>
  <li>Seks selama kehamilan umumnya aman untuk kehamilan yang sehat. Kedua pasangan harus merasa nyaman dan bersedia. Perubahan dalam dorongan seksual adalah hal biasa, dan beberapa bercak darah atau kram ringan setelahnya mungkin terjadi. Hubungi penyedia layanan kesehatan Anda jika Anda mengalami pendarahan berat atau kram yang persisten.</li>
  <li>Lanjutkan eksplorasi nama bayi. Jika Anda kesulitan mencari ide, pertimbangkan daftar nama bayi populer atau melibatkan orang yang dicintai dalam proses pengambilan keputusan, mungkin dengan mengadakan pesta pemilihan nama bayi.</li>
  <li>Berdiskusilah dengan pasangan Anda tentang cara memberi tahu anak-anak lain tentang bayi baru dan melibatkan mereka dalam perjalanan kehamilan.</li>
  <li>Mulailah merencanakan ruang tidur bayi dan lakukan penyesuaian yang diperlukan untuk memenuhi kebutuhan mereka. Jika bayi akan berbagi ruangan dengan balita, baca tentang cara menciptakan ruang bersama untuk keduanya.</li>
</ul>""",
    "tips_mingguan_en": """<h2>22 Weeks Pregnant: Things to Consider</h2>
<ul>
  <li>Practice stress-relief techniques to manage worries during pregnancy. Strategies like reducing work hours, delegating tasks, exercising, and confiding in a trusted person can help alleviate stress.</li>
  <li>Sex during pregnancy is generally safe for healthy pregnancies. Both partners should feel comfortable and willing. Changes in sex drive are common, and some spotting or mild cramping afterward may occur. Contact your healthcare provider if you experience heavy bleeding or persistent cramping.</li>
  <li>Continue exploring baby names. If you're struggling for ideas, consider popular baby name lists or involve loved ones in the decision-making process, perhaps by hosting a baby naming party.</li>
  <li>Discuss with your partner how to inform other children about the new baby and involve them in the pregnancy journey.</li>
  <li>Start planning the baby's nursery and make necessary adjustments to accommodate their needs. If the baby will share a room with a toddler, read up on creating a shared space for both.</li>
</ul>""",
    "bayi_img_path": "week_22.jpg",
    "ukuran_bayi_img_path": "week_22_spaghetti_squash.svg"
  },
  {
    "id": "23",
    "minggu_kehamilan": "23",
    "berat_janin": 568,
    "tinggi_badan_janin": 306,
    "ukuran_bayi_id": "Mangga Besar",
    "ukuran_bayi_en": "Large Mango",
    "poin_utama_id": """<h2>Hal Penting saat Hamil 23 Minggu</h2>
<ul>
  <li>Bayi Anda saat ini seukuran terong!</li>
  <li>Garis-garis unik sedang terbentuk di tangan dan kaki bayi Anda, yang akan segera menjadi sidik jari dan sidik jari kaki.</li>
  <li>Berinteraksilah dengan bayi Anda dengan menyanyi atau membacakan cerita—segera mereka mungkin akan merespons suara Anda dengan gerakan lembut.</li>
  <li>Jika Anda mengalami ketidaknyamanan atau nyeri saat hamil 23 minggu, luangkan waktu untuk bersantai dan memanjakan diri!</li>
  <li>Kenaikan berat badan adalah hal yang normal pada tahap ini saat bayi Anda tumbuh dan rahim Anda membesar. Penyedia layanan kesehatan Anda dapat memberikan panduan tentang diet dan olahraga untuk membantu mengelola kenaikan berat badan.</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 23 Weeks Pregnant</h2>
<ul>
  <li>Your baby is currently the size of an eggplant!</li>
  <li>Unique ridges are forming on your baby's hands and feet, soon to develop into fingerprints and toeprints.</li>
  <li>Engage with your baby by singing or reading to them—soon they may respond to your voice with gentle movements.</li>
  <li>If you're experiencing any discomforts or pains at 23 weeks pregnant, take some time to relax and treat yourself!</li>
  <li>Weight gain is normal at this stage as your baby grows and your uterus expands. Your healthcare provider can offer guidance on diet and exercise to help manage weight gain.</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>Perkembangan Bayi Anda saat Hamil 23 Minggu</h2>
<ul>
  <li>Bayi Anda sekarang dapat mengenali suara yang familiar, seperti suara Anda, berkat perkembangan telinga baru-baru ini. Jadikan membaca, berbicara, atau menyanyikan lagu sebagai kegiatan harian untuk mereka. Ajak juga pasangan, teman, dan orang yang Anda cintai untuk melakukan hal yang sama!</li>
  <li>Jika Anda dapat melihat jari dan jempol kaki bayi Anda, Anda akan melihat tonjolan kecil yang terbentuk. Ini adalah awal dari sidik jari dan sidik jari kaki.</li>
  <li>Pada usia kehamilan 23 minggu, bayi Anda menghabiskan sebagian besar waktu tidurnya dalam tidur gerak mata cepat (REM), di mana mata mereka bergerak, dan otak mereka sangat aktif.</li>
  <li>Cairan amnion yang melingkupi bayi Anda di kantung amnion sangat penting untuk pertumbuhan dan perkembangan mereka. Ini menciptakan lingkungan yang baik untuk pertumbuhan bayi yang sehat, menjaga mereka tetap hangat, dan melindungi mereka saat mereka tumbuh.</li>
</ul>
<p>Para ahli merekomendasikan untuk minum banyak air selama kehamilan, tidak hanya untuk kesehatan secara keseluruhan, tetapi juga karena air yang Anda minum membantu membentuk cairan amnion.</p>""",
    "perkembangan_bayi_en": """<h2>23 Weeks Pregnant: Your Baby's Development</h2>
<ul>
  <li>Your baby can now recognize familiar sounds, such as your voice, due to recent ear development. Make it a daily routine to read, talk, or sing to them. Encourage your partner, friends, and loved ones to do the same!</li>
  <li>If you could see your baby's fingers and toes, you'd notice tiny ridges forming, which are the early stages of fingerprints and toeprints.</li>
  <li>At 23 weeks pregnant, your baby spends most of their snooze time in rapid eye movement (REM) sleep, during which their eyes move, and their brain is highly active.</li>
  <li>The amniotic fluid surrounding your baby in the amniotic sac is vital for their growth and development. It provides a conducive environment for their healthy development, keeps them warm, and cushions them as they grow.</li>
</ul>
<p>Experts recommend drinking plenty of water during pregnancy, not only for your overall health but also because the water you drink contributes to the formation of amniotic fluid.</p>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda pada Minggu ke-23 Kehamilan</h2>
<p>Pada usia kehamilan 23 minggu, Anda mungkin telah menambah berat badan sekitar 10 hingga 15 pound. Pada usia 23 minggu dan kapan pun selama kehamilan Anda, selalu periksa dengan penyedia layanan kesehatan Anda untuk memastikan bahwa penambahan berat badan kehamilan Anda sehat dan sesuai untuk situasi Anda.</p>
<p>Jika penyedia layanan kesehatan Anda menentukan bahwa Anda menambah berat badan terlalu banyak atau terlalu sedikit, mereka dapat memberikan saran untuk membantu Anda tetap berada dalam jalur yang sehat. Misalnya, jika Anda menambah berat badan terlalu banyak selama kehamilan di usia 23 minggu, penyedia layanan Anda mungkin akan menyarankan penyesuaian diet dan peningkatan aktivitas fisik.</p>
<p>Menambah berat badan dengan jumlah yang sehat selama kehamilan akan memudahkan Anda untuk secara perlahan kehilangan berat badan ekstra setelah Anda melahirkan.</p>
<p>Pada usia kehamilan 23 minggu, Anda mungkin sudah mulai merasakan gerakan bayi Anda, meskipun beberapa calon orangtua mungkin perlu menunggu sedikit lebih lama.</p>
<p>Pada suatu saat dalam beberapa bulan mendatang, penyedia layanan kesehatan Anda mungkin akan meminta Anda untuk memantau gerakan bayi Anda dengan melakukan serangkaian "hitungan tendangan" setiap hari. Untuk melakukannya, Anda akan memilih waktu di mana bayi Anda biasanya aktif dan mencatat berapa lama waktu yang dibutuhkan untuk menghitung 10 gerakan yang dilakukan oleh bayi Anda.</p>
<p>Hubungi penyedia Anda jika lebih dari 2 jam berlalu tanpa merasakan 10 gerakan, jika Anda mengamati penurunan gerakan janin pada usia kehamilan 23 minggu, atau jika Anda melihat adanya perubahan signifikan dalam gerakan bayi Anda. Sebuah pelacak gerakan janin yang dapat diunduh mungkin membantu Anda dalam proses pemantauan ini.</p>""",
    "perubahan_tubuh_en": """<h2>Your Body at 23 Weeks Pregnant</h2>
<p>By the time you reach 23 weeks pregnant, you might have gained approximately 10 to 15 pounds of pregnancy weight. It's always a good idea to consult your healthcare provider to ensure that your weight gain during pregnancy is healthy and suitable for your individual circumstances.</p>
<p>If your healthcare provider determines that your weight gain is excessive or insufficient, they can provide guidance to help you maintain a healthy weight. For instance, if you're gaining too much weight during pregnancy at 23 weeks, your provider may suggest dietary adjustments and increased physical activity.</p>
<p>Gaining an appropriate amount of weight during pregnancy will facilitate gradual weight loss postpartum.</p>
<p>At 23 weeks pregnant, you may start feeling your baby's movements, although some expectant parents may need to wait a bit longer.</p>
<p>At some point in the coming months, your healthcare provider may advise you to monitor your baby's movements through daily "kick counts." During this activity, you would select a time of day when your baby is typically active and record the time it takes to count 10 movements made by your baby.</p>
<p>Contact your provider if more than 2 hours pass without feeling 10 movements, if you observe decreased fetal movement at 23 weeks, or if you notice any significant changes in your baby's movements. A downloadable fetal movement tracker may assist you in this monitoring process.</p>""",
    "gejala_umum_id": """<h2>Minggu ke-23 Kehamilan: Gejala Anda</h2>
<p>Pada usia kehamilan 23 minggu, Anda mungkin mengalami gejala-gejala berikut:</p>
<ul>
  <li><strong>Nyeri dan sakit:</strong> Lumrah untuk mengalami berbagai nyeri dan sakit saat perut Anda membesar dan Anda mengalami penambahan berat badan. Kelelahan otot dan sakit kepala sesekali adalah hal yang biasa pada tahap ini. Untuk mengurangi ketidaknyamanan otot, pertimbangkan untuk mandi air hangat, pijat area yang terasa sakit, atau menggunakan bantal pemanas. Untuk sakit kepala, istirahat sambil menggunakan kantong es pada kepala mungkin bisa memberikan bantuan. Konsultasikan dengan penyedia layanan kesehatan Anda jika mengalami nyeri parah atau sakit kepala yang persisten, dan sebelum mengonsumsi obat penghilang rasa sakit bebas.</li>
  <li><strong>Kram kaki:</strong> Kram kaki umum terjadi pada tahap-tahap akhir kehamilan. Jika Anda mengalami kram kaki pada usia kehamilan 23 minggu, cobalah pijat otot betis Anda dan fleksikan kaki Anda untuk meredakan kram tersebut.</li>
  <li><strong>Sakit maag:</strong> Hormon kehamilan dan uterus yang semakin membesar dapat menyebabkan sakit maag dengan merelaksasi tabung perut dan menekan lambung. Mengelola sakit maag mungkin melibatkan mengonsumsi makanan dalam porsi kecil sepanjang hari, menghindari makanan sebelum tidur, dan membatasi konsumsi makanan berlemak dan pedas.</li>
</ul>""",
    "gejala_umum_en": """<h2>23 Weeks Pregnant: Your Symptoms</h2>
<p>At 23 weeks pregnant, you might be encountering the following symptoms:</p>
<ul>
  <li><strong>Aches and pains:</strong> It's common to experience various aches and pains as your belly expands and you gain weight. Muscle soreness and occasional headaches are typical at this stage. To alleviate muscle discomfort, consider taking a warm bath, massaging the affected area, or applying a heating pad. For headaches, resting while applying a cool pack to your head may provide relief. Consult your healthcare provider for severe pains or persistent headaches, and before taking any over-the-counter pain medications.</li>
  <li><strong>Leg cramps:</strong> Leg cramps are prevalent in the later stages of pregnancy. If you experience leg cramps at 23 weeks pregnant, try massaging your calves and flexing your foot to alleviate the cramp.</li>
  <li><strong>Heartburn:</strong> Pregnancy hormones and the growing uterus can cause heartburn by relaxing the stomach tube and exerting pressure on the stomach. Managing heartburn may involve consuming smaller meals throughout the day, avoiding bedtime snacks, and limiting intake of fatty and spicy foods.</li>
</ul>""",
    "tips_mingguan_id": """<h2>Minggu ke-23 Kehamilan: Hal yang Perlu Dipertimbangkan</h2>
<p>Pada usia kehamilan 23 minggu, ada beberapa hal yang perlu dipertimbangkan:</p>
<ul>
  <li><strong>Monitor asupan garam:</strong> Periksa konsumsi garam Anda dan upayakan untuk mengonsumsi makanan asin dengan bijaksana, karena asupan natrium berlebih dapat berbahaya. Hindari makanan tinggi garam seperti makanan beku olahan, sup kalengan, dan produk olahan lainnya.</li>
  <li><strong>Preventif terhadap keracunan makanan:</strong> Ambil langkah-langkah pencegahan untuk menghindari keracunan makanan, karena dapat membahayakan selama kehamilan. Gejalanya termasuk muntah, diare, demam, dan kram perut. Ikuti pedoman keamanan makanan seperti menghindari makanan laut dan telur mentah, mencuci buah dan sayuran, dan menjaga kebersihan saat mempersiapkan makanan.</li>
  <li><strong>Waspadai preeklamsia:</strong> Tetap waspada terhadap tanda-tanda preeklamsia, komplikasi kehamilan yang ditandai oleh tekanan darah tinggi, pembengkakan, dan protein dalam urin. Deteksi dini sangat penting, jadi pantau tekanan darah Anda dan laporkan gejala seperti perubahan penglihatan, pembengkakan, atau penambahan berat badan tiba-tiba kepada penyedia layanan kesehatan Anda.</li>
  <li><strong>Mengenali tanda-tanda persalinan prematur:</strong> Kenali tanda-tanda persalinan prematur, termasuk nyeri punggung bawah, keluarnya cairan dari vagina, tekanan di panggul, kram perut, kontraksi, dan pecahnya air ketuban. Hubungi penyedia layanan kesehatan Anda segera jika Anda mengalami salah satu gejala ini.</li>
  <li><strong>Mempersiapkan anak-anak yang lebih tua:</strong> Jika Anda memiliki anak-anak yang lebih tua, libatkan mereka dalam perjalanan kehamilan dan tanggapi pertanyaan atau kekhawatiran yang mereka miliki tentang adik baru. Untuk anak-anak yang lebih kecil, jelaskan perubahan kehamilan saat muncul dan cari bimbingan dari penyedia layanan kesehatan Anda tentang cara menangani pertanyaan mereka.</li>
  <li><strong>Jelajahi nama-nama bayi:</strong> Gunakan generator nama bayi untuk menjelajahi berbagai tema penamaan dan temukan nama yang sempurna untuk bayi Anda.</li>
</ul>""",
    "tips_mingguan_en": """<h2>23 Weeks Pregnant: Things to Consider</h2>
<p>At 23 weeks pregnant, there are several factors to keep in mind:</p>
<ul>
  <li><strong>Monitor salt intake:</strong> Check your salt consumption and aim to consume salty foods in moderation, as excessive sodium intake can be harmful. Avoid high-sodium foods like processed frozen foods, canned soups, and other highly processed items.</li>
  <li><strong>Prevent food poisoning:</strong> Take precautions to avoid food poisoning, as it can pose risks during pregnancy. Symptoms include vomiting, diarrhea, fever, and abdominal cramps. Follow food safety guidelines such as avoiding raw seafood and eggs, washing fruits and vegetables, and maintaining proper hygiene during meal preparation.</li>
  <li><strong>Be aware of preeclampsia:</strong> Stay vigilant for signs of preeclampsia, a pregnancy complication characterized by high blood pressure, swelling, and protein in the urine. Early detection is crucial, so monitor your blood pressure and report any symptoms such as vision changes, swelling, or sudden weight gain to your healthcare provider.</li>
  <li><strong>Recognize signs of preterm labor:</strong> Familiarize yourself with the signs of preterm labor, including lower back pain, vaginal discharge, pelvic pressure, abdominal cramps, contractions, and water breaking. Contact your provider immediately if you experience any of these symptoms.</li>
  <li><strong>Prepare older children:</strong> If you have older children, involve them in the pregnancy journey and address any questions or concerns they may have about the new sibling. For younger children, explain pregnancy changes as they arise and seek guidance from your healthcare provider on how to handle their inquiries.</li>
  <li><strong>Explore baby names:</strong> Use a baby name generator to explore various naming themes and find the perfect name for your baby.</li>
</ul>""",
    "bayi_img_path": "week_23.jpg",
    "ukuran_bayi_img_path": "week_23_mango.svg"
  },
  {
    "id": "24",
    "minggu_kehamilan": "24",
    "berat_janin": 670,
    "tinggi_badan_janin": 320,
    "ukuran_bayi_id": "Tongkol Jagung",
    "ukuran_bayi_en": "Ear of Corn",
    "poin_utama_id": """<h2>Hal Penting pada Minggu ke-24 Kehamilan</h2>
<ul>
  <li>Bayi Anda saat ini memiliki ukuran sekitar satu tongkol jagung.</li>
  <li>Mereka semakin kuat, yang berarti Anda mungkin akan merasakan gerakan mereka lebih banyak saat ini!</li>
  <li>Mungkin saatnya untuk mulai memikirkan rencana persalinan Anda—selalu baik untuk siap!</li>
  <li>Bayi Anda semakin besar, dan bertambahnya berat badan selama kehamilan pada sekitar 24 minggu adalah normal dan sehat. Anda mungkin ingin memakai celana yang elastis dan pakaian longgar untuk kenyamanan lebih. Penyedia layanan kesehatan Anda akan membantu Anda tetap dalam jalur dengan berat badan Anda.</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 24 Weeks Pregnant</h2>
<ul>
  <li>Your baby is currently approximately the size of a full ear of corn.</li>
  <li>They're becoming stronger, which may result in increased movement sensations for you.</li>
  <li>It's a good idea to start considering your birth plan around this time to ensure preparedness.</li>
  <li>Your baby is growing larger, and it's completely normal to experience weight gain during pregnancy at 24 weeks. Consider wearing comfortable stretchy pants and loose-fitting tops for added comfort.</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>Perkembangan Bayi Anda pada Minggu ke-24 Kehamilan</h2>
<ul>
  <li>Pada usia kehamilan 24 minggu, gerakan bayi Anda mungkin terasa lebih kuat dan lebih sering terasa karena mereka memperoleh kendali otot dan kekuatan.</li>
  <li>Pada minggu ini, telinga dalam bayi Anda sudah sepenuhnya berkembang, yang membantu mengatur keseimbangan mereka di dalam kandungan.</li>
  <li>Meskipun paru-paru bayi Anda sudah terbentuk pada usia kehamilan 24 minggu, mereka belum akan berfungsi sepenuhnya sampai mereka mulai memproduksi zat yang disebut surfaktan, yang biasanya dimulai sekitar minggu ke-26.</li>
  <li>Anda mungkin melihat pola gerakan bayi Anda, seperti peningkatan aktivitas sebelum waktu tidur dan penurunan gerakan selama periode tidur.</li>
</ul>""",
    "perkembangan_bayi_en": """<h2>24 Weeks Pregnant: Your Baby’s Development</h2>
<ul>
  <li>At 24 weeks pregnant, your baby's movements may feel stronger and more frequent as they gain muscle control and strength.</li>
  <li>By this week, your baby's inner ear is fully developed, which helps regulate their sense of balance in the womb.</li>
  <li>While your baby's lungs are formed by 24 weeks, they won’t be fully functional until they start producing surfactant, which typically begins around week 26.</li>
  <li>You may notice distinct patterns in your baby's movements, such as increased activity before bedtime and decreased movement during periods of sleep.</li>
</ul>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda pada Usia Kehamilan 24 Minggu</h2>
<p>Pada usia kehamilan 24 minggu, Anda telah memasuki akhir trimester kedua, yang berakhir pada 27 minggu.</p>
<p>Mengalami kenaikan berat badan selama kehamilan adalah hal yang wajar dan penting untuk perkembangan bayi Anda. Pada tahap ini, Anda mungkin telah mengalami penambahan berat badan sekitar 10 hingga 15 pound. Mengonsumsi makanan seimbang dan melakukan latihan fisik secara teratur tidak hanya akan bermanfaat bagi Anda secara fisik dan emosional selama kehamilan tetapi juga akan memudahkan Anda untuk mengurangi berat badan setelah melahirkan.</p>""",
    "perubahan_tubuh_en": """<h2>Your Body at 24 Weeks Pregnant</h2>
<p>At 24 weeks pregnant, you're reaching the end of the second trimester, which concludes at 27 weeks.</p>
<p>Gaining weight during pregnancy is natural and essential for your baby's development. By this stage, you may have gained around 10 to 15 pounds. Eating a balanced diet and engaging in regular exercise will not only benefit you physically and emotionally during pregnancy but also make it easier to shed the extra weight postpartum.</p>""",
    "gejala_umum_id": """<h2>Gejala pada Kehamilan 24 Minggu</h2>
<ul>
  <li>
    <strong>Perubahan Kulit:</strong> Perubahan hormon selama kehamilan dapat menyebabkan munculnya bercak hitam pada kulit, seperti kloasma di wajah dan linea nigra di perut. Biasanya, bercak ini memudar setelah melahirkan, dan perlindungan dari sinar matahari dapat membantu mengurangi kloasma.
  </li>
  <li>
    <strong>Stretch mark:</strong> Peregangan kulit karena pertumbuhan tubuh dapat mengakibatkan munculnya garis-garis merah, biasanya terlihat di perut, bokong, dan payudara. Meskipun tidak bisa dicegah, stretch mark sering memudar seiring berjalannya waktu setelah melahirkan. Menggunakan pelembap dapat meredakan rasa gatal yang terkait dengan stretch mark.
  </li>
  <li>
    <strong>Nyeri Ligamen Bundar:</strong> Nyeri di daerah perut atau pinggul mungkin terjadi karena peregangan dan tegangan ligamen yang mendukung uterus. Peregangan lembut dan perubahan posisi bisa memberikan bantuan, tetapi konsultasikan dengan penyedia layanan kesehatan Anda jika nyeri menjadi parah atau mengkhawatirkan.
  </li>
  <li>
    <strong>Kesulitan Tidur:</strong> Ukuran perut yang semakin besar mungkin membuat sulit menemukan posisi tidur yang nyaman. Menggunakan bantal untuk dukungan dan tidur dengan posisi menyamping dengan lutut ditekuk dapat meningkatkan kenyamanan.
  </li>
  <li>
    <strong>Kehilangan keseimbangan dan pusing:</strong> Perubahan distribusi berat badan dan sirkulasi dapat menyebabkan rasa tidak seimbang dan pusing. Bergerak perlahan, tetap terhidrasi, dan tetap sejuk dapat membantu mengatasi gejala ini.
  </li>
  <li>
    <strong>Kram Kaki:</strong> Kontraksi otot yang menyakitkan di betis atau kaki umum terjadi selama kehamilan. Peregangan sebelum tidur, tetap aktif dengan olahraga rutin, dan menjaga kecukupan cairan dapat membantu meredakan kram kaki.
  </li>
</ul>""",
    "gejala_umum_en": """<h2>24 Weeks Pregnant: Your Symptoms</h2>
<ul>
  <li>
    <strong>Skin changes:</strong> Hormonal shifts during pregnancy can lead to the development of darker patches of skin, such as chloasma on the face and linea nigra on the abdomen. These typically fade after giving birth, and sun protection can help minimize chloasma.
  </li>
  <li>
    <strong>Stretch marks:</strong> The stretching of the skin as your body grows may result in the appearance of red streaks, commonly seen on the belly, buttocks, and breasts. While they cannot be prevented, they often fade over time postpartum. Moisturizing can alleviate itchiness associated with stretch marks.
  </li>
  <li>
    <strong>Round ligament pain:</strong> Pain in the abdomen or hip area may occur due to the stretching and straining of the ligaments supporting the uterus. Gentle stretching and position changes can provide relief, but consult your healthcare provider if the pain becomes severe or concerning.
  </li>
  <li>
    <strong>Trouble sleeping:</strong> The size of your belly may make finding a comfortable sleeping position challenging. Using pillows for support and sleeping on your side with knees bent can improve comfort.
  </li>
  <li>
    <strong>Loss of balance and dizziness:</strong> Changes in weight distribution and circulation may lead to feelings of imbalance and dizziness. Moving slowly, staying hydrated, and keeping cool can help manage these symptoms.
  </li>
  <li>
    <strong>Leg cramps:</strong> Painful muscle contractions in the calves or feet are common during pregnancy. Stretching before bedtime, staying active with regular exercise, and staying hydrated can help alleviate leg cramps.
  </li>
</ul>""",
    "tips_mingguan_id": """<h2>24 Minggu Hamil: Hal yang Perlu Dipertimbangkan</h2>
<ul>
  <li>
    <strong>Seks selama kehamilan:</strong> Saat perut Anda semakin membesar, Anda dan pasangan mungkin bertanya-tanya tentang keamanan berhubungan seks. Pada kebanyakan kasus, seks aman selama kehamilan, tetapi jika ada komplikasi, penyedia layanan kesehatan Anda mungkin menyarankan untuk tidak melakukannya. Diskusikan kekhawatiran Anda dengan penyedia dan pasangan Anda.
  </li>
  <li>
    <strong>Pemeriksaan gula darah:</strong> Antara 24 dan 28 minggu kehamilan, pemeriksaan gula darah mungkin disarankan untuk menilai risiko diabetes gestasional Anda. Penyedia layanan kesehatan Anda akan membimbing Anda apakah Anda memerlukan tes ini.
  </li>
  <li>
    <strong>Menyesuaikan rutinitas:</strong> Dengan perut yang semakin membesar, Anda perlu menyesuaikan rutinitas sehari-hari, seperti memasang sabuk pengaman mobil dengan benar untuk melindungi diri Anda dan bayi Anda saat mengemudi.
  </li>
  <li>
    <strong>Menjaga hidrasi:</strong> Minum cukup air penting selama kehamilan. Atur pengingat, gunakan aplikasi hidrasi, atau simpan botol air di dekat Anda untuk memastikan Anda tetap terhidrasi sepanjang hari.
  </li>
  <li>
    <strong>Preferensi persalinan:</strong> Diskusikan preferensi persalinan Anda dengan penyedia layanan kesehatan dan pasangan saat persalinan untuk memastikan mereka memahami dan dapat mendukung keinginan Anda selama proses persalinan.
  </li>
  <li>
    <strong>Perlindungan bayi:</strong> Mulailah mempersiapkan rumah Anda untuk kehadiran bayi selama trimester kedua ketika Anda memiliki energi tambahan. Meskipun beberapa tugas bisa diselesaikan sekarang, ingatlah bahwa perlindungan bayi adalah proses yang berkelanjutan.
  </li>
  <li>
    <strong>Pengalaman aneh:</strong> Anda mungkin menyadari hal-hal yang tidak biasa selama kehamilan, seperti mimpi yang jelas atau kesulitan berkonsentrasi. Baca pengalaman ini untuk memahami alasan mengapa hal tersebut terjadi.
  </li>
</ul>""",
    "tips_mingguan_en": """<h2>24 Weeks Pregnant: Things to Consider</h2>
<ul>
  <li>
    <strong>Sex during pregnancy:</strong> As your belly grows, you and your partner may wonder about the safety of sex. In most cases, sex is safe during pregnancy, but if there are complications, your healthcare provider may advise against it. Discuss your concerns with your provider and partner.
  </li>
  <li>
    <strong>Glucose screening test:</strong> Between 24 and 28 weeks of pregnancy, a glucose screening test may be recommended to assess your risk of gestational diabetes. Your healthcare provider will guide you on whether you need this test.
  </li>
  <li>
    <strong>Adjusting routines:</strong> With a growing belly, you'll need to adapt daily routines, such as fastening your seatbelt correctly to protect yourself and your baby while driving.
  </li>
  <li>
    <strong>Staying hydrated:</strong> Drinking enough water is essential during pregnancy. Set reminders, use hydration apps, or keep water bottles handy to ensure you stay hydrated throughout the day.
  </li>
  <li>
    <strong>Childbirth preferences:</strong> Discuss your childbirth preferences with your healthcare provider and birth partner to ensure they understand and can support your wishes during labor.
  </li>
  <li>
    <strong>Babyproofing:</strong> Start babyproofing your home during the second trimester when you have extra energy. While some tasks can be completed now, remember that babyproofing is an ongoing process.
  </li>
  <li>
    <strong>Strange experiences:</strong> You may notice unusual things during pregnancy, such as vivid dreams or difficulty focusing. Read up on these experiences to understand why they may be happening.
  </li>
</ul>""",
    "bayi_img_path": "week_24.jpg",
    "ukuran_bayi_img_path": "week_24_corn.svg"
  },
  {
    "id": "25",
    "minggu_kehamilan": "25",
    "berat_janin": 785,
    "tinggi_badan_janin": 337,
    "ukuran_bayi_id": "Lobak Swedia",
    "ukuran_bayi_en": "Rutabaga",
    "poin_utama_id": """<h2>Highlights di Minggu ke-25 Kehamilan</h2>
<ul>
  <li>Bayi Anda menambah lemak lebih banyak minggu ini, membuat mereka terlihat lebih halus.</li>
  <li>Otak mereka dan bagian lain dari sistem saraf terus berkembang.</li>
  <li>Menjaga rutinitas latihan fisik Anda saat hamil 25 minggu mungkin membantu mengurangi beberapa nyeri umum selama kehamilan.</li>
  <li>Saat tubuh Anda mengalami perubahan dan perut Anda terus membesar pada kehamilan minggu ke-25, disarankan untuk memantau kenaikan berat badan Anda dengan cermat.</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 25 Weeks Pregnant</h2>
<ul>
  <li>Your baby is accumulating more fat this week, giving them a smoother appearance.</li>
  <li>Their brain and other parts of the nervous system continue to progress.</li>
  <li>Maintaining your exercise routine during the 25th week of pregnancy might help alleviate some of the common aches and pains.</li>
  <li>As your body undergoes changes and your belly grows further, it's advisable to monitor your weight gain closely.</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>Kembang Bayi Anda pada Minggu ke-25 Kehamilan</h2>
<ul>
  <li>Pada minggu ke-25 kehamilan, bayi Anda mulai menambah berat badan, membantu menghaluskan kulit mereka.</li>
  <li>Dalam otak bayi Anda, lapisan korteks mulai terbentuk, meskipun sebagian besar fungsi masih dikendalikan oleh area otak yang lebih awal.</li>
  <li>Di samping otak, bagian lain dari sistem saraf juga sedang mengalami perkembangan, yang penting untuk memproses informasi dari dunia luar.</li>
  <li>Dengan pendengarannya yang berkembang pesat, bayi Anda mungkin mulai merespons suara yang familier seperti suara Anda dengan bergerak atau menyesuaikan posisi mereka.</li>
  <li>Anda mungkin melihat waktu-waktu tertentu di mana aktivitas bayi Anda meningkat dan waktu lain ketika gerakan janin sedikit berkurang, tetapi secara keseluruhan, Anda lebih mungkin merasakan gerakan mereka selama tahap kehamilan ini.</li>
</ul>""",
    "perkembangan_bayi_en": """<h2>25 Weeks Pregnant: Your Baby’s Development</h2>
<ul>
  <li>During the 25th week of pregnancy, your baby is starting to gain weight, helping to smoothen out their skin.</li>
  <li>In your baby's brain, layers of the cortex are forming, although most functions are still controlled by earlier developed brain areas.</li>
  <li>Aside from the brain, other parts of the nervous system are also undergoing development, which is crucial for processing information from the outside world.</li>
  <li>With their hearing rapidly developing, your baby may begin to respond to familiar sounds like your voice by moving or adjusting their position.</li>
  <li>You might notice certain times of increased activity and other times when fetal movements decrease slightly, but overall, you're more likely to feel their movements during this stage of pregnancy.</li>
</ul>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda saat Hamil 25 Minggu</h2>
<p>Anda sudah mendekati trimester ketiga, dan seiring dengan pertumbuhan bayi Anda, tubuh Anda juga ikut bertambah.</p>
<p>Pada usia kehamilan 25 minggu, rahim yang semakin membesar mungkin menekan lebih banyak pada perut dan organ lainnya, yang bisa menyebabkan masalah pencernaan dan bahkan sembelit.</p>""",
    "perubahan_tubuh_en": """<h2>Your Body at 25 Weeks Pregnant</h2>
<p>You’re nearing the third trimester, and as your baby grows, so does your body.</p>
<p>At 25 weeks, your expanding uterus might be exerting more pressure on your stomach and other organs, potentially causing digestive issues and even constipation.</p>""",
    "gejala_umum_id": """<h2>Gejala Anda saat Hamil 25 Minggu</h2>
<ul>
    <li><strong>Sciatica:</strong> Saat rahim Anda bertambah besar, tekanan pada saraf syaraf bisa menyebabkan nyeri pinggul dan punggung bagian bawah. Mengompres dengan es dan melakukan latihan peregangan yang disarankan oleh penyedia layanan kesehatan Anda mungkin bisa membantu meredakan ketidaknyamanan.</li>
    <li><strong>Kembung:</strong> Tekanan dari rahim yang membesar dan peningkatan kadar progesteron bisa menyebabkan sembelit. Menjaga hidrasi, mengonsumsi makanan tinggi serat, dan tetap aktif dapat membantu mencegah atau meredakan sembelit.</li>
    <li><strong>Asam lambung:</strong> Hormon kehamilan dapat mengendurkan katup lambung, menyebabkan heartburn. Mengonsumsi makanan dalam porsi kecil dan menghindari makanan pemicu dapat membantu mengelola asam lambung.</li>
    <li><strong>Nyeri panggul:</strong> Perubahan hormonal selama kehamilan bisa melonggarkan sendi panggul, menyebabkan nyeri panggul.</li>
    <li><strong>Kram kaki:</strong> Kram kaki, terutama pada malam hari, umum terjadi selama trimester kedua. Latihan ringan, peregangan, mandi air hangat, atau mengompres dengan es bisa memberikan bantuan.</li>
    <li><strong>Kontraksi Braxton Hicks:</strong> Kontraksi latihan, yang dikenal sebagai Braxton Hicks, mungkin terjadi. Kontraksi ini membantu persiapan tubuh untuk melahirkan dan sering kali terasa seperti ketegangan ringan di perut.</li>
</ul>""",
    "gejala_umum_en": """<h2>25 Weeks Pregnant: Your Symptoms</h2>
<ul>
    <li><strong>Sciatica:</strong> As your uterus grows, it can put pressure on the sciatic nerve, causing hip and lower back pain. Applying ice packs and doing stretching exercises recommended by your healthcare provider may help alleviate the discomfort.</li>
    <li><strong>Constipation:</strong> Pressure from the growing uterus and increased progesterone levels can lead to constipation. Staying hydrated, consuming fiber-rich foods, and staying active can help prevent or ease constipation.</li>
    <li><strong>Acid reflux:</strong> Pregnancy hormones can relax the stomach valve, causing heartburn. Eating smaller meals and avoiding trigger foods may help manage acid reflux.</li>
    <li><strong>Pelvic pain:</strong> Hormonal changes during pregnancy can loosen pelvic joints, leading to pelvic pain.</li>
    <li><strong>Leg cramps:</strong> Leg cramps, especially at night, are common during the second trimester. Gentle exercise, stretching, warm baths, or applying ice packs can provide relief.</li>
    <li><strong>Braxton Hicks contractions:</strong> Practice contractions, known as Braxton Hicks, may occur. These contractions help prepare the body for birth and often feel like mild abdominal tightness.</li>
</ul>""",
    "tips_mingguan_id": """<h2>25 Minggu Hamil: Hal yang Perlu Dipertimbangkan</h2>
<ul>
    <li>Sudahkah Anda mempertimbangkan bagaimana Anda akan mengelola nyeri saat persalinan? Ada berbagai opsi yang tersedia, jadi diskusikan dengan penyedia layanan kesehatan Anda untuk membuat keputusan yang tepat.</li>
    <li>Saat perut Anda bertambah besar, Anda mungkin mendapat komentar dari orang lain. Ingatlah bahwa detail tentang kehamilan Anda adalah pribadi, dan tidak apa-apa untuk menetapkan batasan.</li>
    <li>Jika Anda mengalami ketidaknyamanan, Anda mungkin ingin memodifikasi rutinitas olahraga Anda. Konsultasikan dengan penyedia layanan kesehatan Anda untuk latihan yang aman, dan pertimbangkan menggunakan bola latihan untuk peregangan dan pembentukan otot.</li>
    <li>Pertimbangkan untuk mendaftar di kelas orangtua untuk belajar tentang perawatan bayi baru lahir, termasuk praktik tidur yang aman untuk mengurangi risiko Sindrom Kematian Mendadak Bayi (SIDS).</li>
    <li>Jika Anda sedang merencanakan kamar bayi, buatlah daftar perlengkapan penting dan pertimbangkan untuk menambahkannya ke daftar hadiah pesta bayi Anda. Ikuti kuis gaya kamar bayi untuk inspirasi dekorasi.</li>
</ul>""",
    "tips_mingguan_en": """<h2>25 Weeks Pregnant: Things to Consider</h2>
<ul>
    <li>Have you considered how you'll manage labor pain? There are various options available, so discuss them with your healthcare provider to make an informed decision.</li>
    <li>As your belly grows, you may receive comments from others. Remember that details about your pregnancy are personal, and it's okay to set boundaries.</li>
    <li>If you're experiencing discomfort, you might want to modify your exercise routine. Consult your healthcare provider for safe exercises, and consider using an exercise ball for stretching and toning.</li>
    <li>Consider enrolling in a parenting class to learn about newborn care, including safe sleeping practices to reduce the risk of Sudden Infant Death Syndrome (SIDS).</li>
    <li>If you're planning your baby's nursery, make a list of essentials and consider adding them to your baby shower registry. Take a nursery style quiz for decorating inspiration.</li>
</ul>""",
    "bayi_img_path": "week_25.jpg",
    "ukuran_bayi_img_path": "week_25_rutabaga.svg"
  },
  {
    "id": "26",
    "minggu_kehamilan": "26",
    "berat_janin": 913,
    "tinggi_badan_janin": 351,
    "ukuran_bayi_id": "Daun Bawang",
    "ukuran_bayi_en": "Scallion",
    "poin_utama_id": """<h2>Sorotan pada Kehamilan 26 Minggu</h2>
<ul>
    <li>Pada kehamilan 26 minggu, bayi Anda sebesar zucchini.</li>
    <li>Paru-paru bayi Anda sedang bersiap untuk hidup di luar rahim dengan memproduksi surfaktan.</li>
    <li>Anda mungkin mulai mengalami kontraksi Braxton Hicks saat tubuh Anda mempersiapkan persalinan.</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 26 Weeks Pregnant</h2>
<ul>
    <li>At 26 weeks pregnant, your baby is about the size of a zucchini.</li>
    <li>Your baby's lungs are getting ready for life outside the womb by producing surfactant.</li>
    <li>You might start experiencing Braxton Hicks contractions as your body prepares for labor.</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>Perkembangan Bayi pada Kehamilan 26 Minggu</h2>
<p>Inilah yang terjadi pada perkembangan bayi Anda di usia kehamilan 26 minggu:</p>
<ul>
    <li>Pada 26 minggu, paru-paru bayi Anda bekerja keras, bersiap untuk mengambil napas pertama setelah lahir. Paru-paru sekarang mulai memproduksi surfaktan, zat yang membantu paru-paru mengembang dengan baik setiap kali bernafas.</li>
    <li>Refleks mengisap bayi Anda sudah cukup kuat sehingga jika tangan mereka melayang ke wajahnya, mereka mungkin mengisap jempol atau jarinya. Ultrasonografi pada tahap ini sering menunjukkan bayi mengisap jempol mereka.</li>
    <li>Kulit bayi Anda mulai berubah menjadi warna kemerahan, meskipun masih agak tembus pandang.</li>
    <li>Rambut terus tumbuh di kepala mereka, dan bulu mata mulai muncul.</li>
    <li>Jika Anda menantikan hari ketika Anda dapat melihat mata bayi Anda yang baru lahir, Anda semakin dekat. Semua komponen mata telah berkembang, dan meskipun mata masih tertutup rapat, dalam satu atau dua minggu, kelopak mata akan dapat terbuka, memungkinkan bayi Anda berlatih berkedip.</li>
</ul>
<p>Saat Anda hamil 26 minggu, mungkin ide yang baik untuk mulai melacak gerakan bayi Anda jika penyedia layanan kesehatan Anda menyetujui. Perhatikan frekuensi gerakan mereka dan apakah gerakan tersebut melambat. Penyedia layanan kesehatan Anda akan memberi tahu Anda lebih banyak tentang cara melakukannya.</p>""",
    "perkembangan_bayi_en": """<h2>26 Weeks Pregnant: Your Baby’s Development</h2>
<p>Here's what's happening with your baby's development at 26 weeks:</p>
<ul>
    <li>At 26 weeks, your baby's lungs are working hard, preparing to take their first breaths after birth. The lungs are now producing surfactant, a substance that helps the lungs inflate properly with each breath.</li>
    <li>Your baby's sucking reflex is strong enough that they might suck on their thumb or fingers if their hand floats by their face. Ultrasounds at this stage often show babies sucking their thumbs.</li>
    <li>Your baby's skin is starting to turn a reddish color, though it remains slightly translucent.</li>
    <li>Hair continues to grow on their head, and eyelashes are beginning to sprout.</li>
    <li>If you're looking forward to seeing your newborn's eyes, you're getting closer. All the components of the eyes are developed, and although the eyes have been sealed shut, in a week or two, the eyelids will open, allowing your baby to practice blinking.</li>
</ul>
<p>When you're 26 weeks pregnant, it might be a good idea to start tracking your baby's movements if your healthcare provider approves. Pay attention to the frequency of their movements and whether they’ve slowed down. Your healthcare provider will give you more details on how to do this.</p>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda pada Kehamilan 26 Minggu</h2>
<p>Pada usia kehamilan 26 minggu, perut dan payudara Anda terus tumbuh seiring dengan bertambahnya berat badan dan perkembangan bayi Anda. Penting untuk berpakaian nyaman dan memakai bra yang mendukung dengan tali lebar dan cakupan cup yang baik. Toko serba ada atau toko lingerie khusus dapat membantu Anda menemukan bra maternitas yang pas.</p>
<p>Anda mungkin melihat tanda peregangan di perut, payudara, dan paha Anda. Sayangnya, tanda ini tidak bisa dicegah, tetapi biasanya memudar setelah melahirkan. Jika kulit Anda terasa gatal, cobalah menggunakan pelembap lebih sering.</p>
<p>Jika Anda mengalami nyeri atau ketidaknyamanan di perut, penyedia layanan kesehatan Anda mungkin akan menyarankan USG untuk memeriksa jumlah cairan ketuban di dalam rahim Anda.</p>""",
    "perubahan_tubuh_en": """<h2>Your Body at 26 Weeks Pregnant</h2>
<p>At 26 weeks pregnant, your belly and breasts are still growing as you gain weight and your baby develops. It's important to dress comfortably and wear a supportive bra with wide straps and good cup coverage. A department store or specialty lingerie shop can help you find a well-fitting maternity bra.</p>
<p>You might notice stretch marks on your belly, breasts, and thighs. Unfortunately, these can't be prevented, but they usually fade after birth. If your skin feels itchy, try moisturizing more frequently.</p>
<p>If you experience any abdominal pain or discomfort, your healthcare provider might suggest an ultrasound to check the amount of amniotic fluid in your uterus.</p>""",
    "gejala_umum_id": """<h2>Gejala Kehamilan 26 Minggu</h2>
<p>Pada usia kehamilan 26 minggu, Anda mungkin mengalami gejala berikut:</p>
<ul>
  <li><strong>Nyeri panggul.</strong> Ligamen di panggul Anda mungkin melonggar untuk mempersiapkan persalinan, menyebabkan nyeri panggul dan punggung bawah. Anda mungkin merasakan nyeri ini saat duduk, berdiri, atau naik turun tangga. Bicarakan dengan penyedia layanan kesehatan Anda tentang latihan, peregangan, dan metode lain untuk mengatasi nyeri ini tanpa memberikan tekanan berlebih pada area tersebut.</li>
  <li><strong>Kontraksi Braxton Hicks.</strong> Kontraksi latihan ini bisa terjadi di trimester kedua, tetapi lebih umum terjadi di trimester ketiga. Mereka mungkin terasa seperti kekencangan perut atau nyeri ringan, sering terjadi di akhir hari atau setelah berolahraga atau berhubungan seks. Tetap terhidrasi dapat membantu mencegah kontraksi Braxton Hicks. Jika Anda tidak yakin apakah Anda mengalami kontraksi Braxton Hicks atau kontraksi persalinan sebenarnya, segera hubungi penyedia layanan kesehatan Anda.</li>
  <li><strong>Stres dan kecemasan.</strong> Merasa stres atau cemas saat mempersiapkan kelahiran bayi Anda adalah hal yang normal. Jika Anda memiliki riwayat depresi atau merasa lebih cemas dari biasanya, bicarakan dengan penyedia layanan kesehatan Anda. Latihan moderat dan berkumpul dengan teman dapat membantu mengatasi stres. Ingatlah untuk beristirahat dan ketahuilah bahwa Anda tidak sendirian.</li>
  <li><strong>Infeksi saluran kemih.</strong> Infeksi ini umum terjadi selama kehamilan dan dapat menjadi serius jika tidak diobati. Gejalanya meliputi nyeri saat buang air kecil, dorongan kuat untuk buang air kecil, atau demam. Hubungi penyedia layanan kesehatan Anda jika Anda mengalami gejala ini. Mereka mungkin akan meresepkan antibiotik untuk mengobati infeksi.</li>
</ul>""",
    "gejala_umum_en": """<h2>26 Weeks Pregnant: Your Symptoms</h2>
<p>At 26 weeks pregnant, you may experience the following symptoms:</p>
<ul>
  <li><strong>Pelvic pain.</strong> The ligaments in your pelvis might be loosening to prepare for labor, causing pelvic and lower back pain. You might feel this pain when sitting, standing, or climbing stairs. Talk to your healthcare provider about exercises, stretches, and other methods to manage this pain without putting too much pressure on these areas.</li>
  <li><strong>Braxton Hicks contractions.</strong> These practice contractions can happen in the second trimester but are more common in the third trimester. They may feel like abdominal tightness or slight pain, often occurring later in the day or after exercise or sex. Staying hydrated can help prevent Braxton Hicks contractions. If you're unsure whether you’re experiencing Braxton Hicks or true labor contractions, contact your healthcare provider immediately.</li>
  <li><strong>Stress and anxiety.</strong> It's normal to feel stressed or anxious as you prepare for your baby’s arrival. If you have a history of depression or find yourself more anxious than usual, talk to your healthcare provider. Moderate exercise and spending time with friends can help manage stress. Remember to take breaks and know that you're not alone.</li>
  <li><strong>Urinary tract infections.</strong> These infections are common during pregnancy and can become serious if untreated. Symptoms include painful urination, a strong urge to urinate, or fever. Contact your healthcare provider if you notice these symptoms. They may prescribe antibiotics to treat the infection.</li>
</ul>""",
    "tips_mingguan_id": """<h2>26 Minggu Hamil: Hal yang Perlu Dipertimbangkan</h2>
<p>Ketika Anda mendekati trimester ketiga, ada banyak hal yang perlu dipikirkan, dari membuat rencana persalinan hingga memilih nama bayi. Berikut beberapa tips:</p>
<ul>
  <li>Beberapa calon orang tua menyewa doula untuk mendukung selama persalinan dan setelah melahirkan. Doula memberikan dukungan emosional dan membantu dalam komunikasi dan menyusui. Mereka tidak menggantikan profesional medis seperti dokter dan bidan. Jika Anda tertarik, mintalah rekomendasi dari penyedia layanan kesehatan atau instruktur kelas persalinan Anda.</li>
  <li>Membuat rencana persalinan dapat membantu Anda menguraikan preferensi Anda untuk persalinan. Diskusikan rencana Anda dengan penyedia layanan kesehatan untuk mendapatkan saran yang berguna dan memastikan rencana tersebut cocok untuk situasi Anda. Ingatlah untuk tetap fleksibel, karena kelahiran mungkin tidak berjalan persis seperti yang direncanakan. Setelah rencana Anda siap, bagikan dengan pasangan dan staf rumah sakit.</li>
  <li>Tetap terhidrasi dengan minum enam hingga delapan gelas air setiap hari. Ini membantu pencernaan, mencegah infeksi, dan memastikan bayi Anda mendapatkan nutrisi yang dibutuhkan. Juga, konsumsi 25 gram serat setiap hari untuk menghindari sembelit dan mengurangi risiko diabetes dan penyakit jantung. Tingkatkan asupan serat dengan makanan seperti pisang, pasta gandum utuh, lentil, dan apel.</li>
  <li>Dengan perut yang semakin besar, Anda mungkin bertanya-tanya apakah berhubungan seks aman pada usia kehamilan 26 minggu. Secara umum, jika kehamilan Anda normal dan Anda berdua merasa nyaman, berhubungan seks aman. Konsultasikan dengan penyedia layanan kesehatan Anda untuk saran pribadi, dan coba posisi yang berbeda jika perut Anda menghalangi.</li>
  <li>Pertimbangkan untuk melakukan perjalanan sekarang, karena trimester kedua biasanya waktu yang baik untuk bepergian. Periksakan dengan penyedia layanan kesehatan Anda sebelum merencanakan perjalanan.</li>
</ul>""",
    "tips_mingguan_en": """<h2>26 Weeks Pregnant: Things to Consider</h2>
<p>As you approach the third trimester, there are many things to think about, from creating a birth plan to choosing baby names. Here are some tips:</p>
<ul>
  <li>Some parents-to-be hire a doula for support during labor and after delivery. A doula provides emotional support and helps with communication and breastfeeding. They do not replace medical professionals like doctors and midwives. If you're interested, ask your healthcare provider or childbirth class instructor for recommendations.</li>
  <li>Creating a birth plan can help you outline your preferences for labor and delivery. Discuss your plan with your healthcare provider for useful advice and to ensure it's suitable for your situation. Remember to stay flexible, as the birth may not go exactly as planned. Once your plan is ready, share it with your birth partner and hospital staff.</li>
  <li>Stay hydrated by drinking six to eight glasses of water daily. This helps with digestion, prevents infections, and ensures your baby gets needed nutrients. Also, aim for 25 grams of fiber each day to avoid constipation and reduce the risk of diabetes and heart disease. Increase fiber intake with foods like bananas, whole-wheat pasta, lentils, and apples.</li>
  <li>With your growing bump, you might wonder if sex is safe at 26 weeks pregnant. Generally, if your pregnancy is normal and both of you are comfortable, sex is safe. Consult your healthcare provider for personalized advice, and try different positions if your bump gets in the way.</li>
  <li>Consider taking a trip now, as the second trimester is usually a good time for travel. Check with your healthcare provider before planning any trips.</li>
</ul>""",
    "bayi_img_path": "week_26.jpg",
    "ukuran_bayi_img_path": "week_26_scallion.svg"
  },
  {
    "id": "27",
    "minggu_kehamilan": "27",
    "berat_janin": 1000,
    "tinggi_badan_janin": 366,
    "ukuran_bayi_id": "Kepala Kembang Kol",
    "ukuran_bayi_en": "Head of Cauliflower",
    "poin_utama_id": """<h2>Sorotan pada 27 Minggu Kehamilan</h2>
<p>Banyak yang terjadi pada kehamilan 27 minggu. Berikut beberapa poin penting:</p>
<ul>
  <li>Bayi Anda sekarang dapat mengenali suara Anda, jadi teruslah berbicara dan bernyanyi untuk mereka.</li>
  <li>Bayi Anda mungkin sering menendang dan bergerak, bahkan mungkin berubah posisi di dalam rahim Anda.</li>
  <li>Seiring dengan tumbuhnya perut, nyeri dan sakit adalah hal yang normal, tetapi perhatikan jika ada nyeri atau kram yang tidak biasa. Penting untuk mengetahui perbedaan antara persalinan sebenarnya dan kontraksi Braxton Hicks.</li>
  <li>Anda hampir memasuki trimester ketiga! Sekarang mungkin waktu yang tepat untuk melakukan perjalanan singkat atau memfinalisasi pilihan nama bayi Anda.</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 27 Weeks Pregnant</h2>
<p>There's a lot happening at 27 weeks pregnant. Here are some key points:</p>
<ul>
  <li>Your baby can now recognize your voice, so keep talking and singing to them.</li>
  <li>Your baby may be kicking and moving a lot and could change position in your uterus.</li>
  <li>As your belly grows, aches and pains are normal, but watch for any unusual pain or cramping. It's useful to know the difference between real labor and Braxton Hicks contractions.</li>
  <li>You're almost in your third trimester! Now might be a good time for a quick babymoon or to finalize your baby name choices.</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>27 Minggu Kehamilan: Perkembangan Bayi Anda</h2>
<p>Anda telah mencapai minggu terakhir trimester kedua! Inilah perkembangan bayi Anda pada 27 minggu:</p>
<ul>
  <li>Kulit bayi Anda menjadi lebih halus saat mereka menambah lemak—mereka tumbuh dengan cepat!</li>
  <li>Bayi Anda sedang berlatih menendang, meregangkan, dan bahkan mulai membuat gerakan menggenggam.</li>
  <li>Mereka juga mulai "tersenyum," terutama saat tidur.</li>
  <li>Setelah lebih dari empat bulan tertutup rapat, kelopak mata bayi Anda dapat terbuka lagi, memungkinkan mereka melihat cahaya dan bayangan.</li>
  <li>Bayi Anda mungkin mulai mengenali suara yang akrab, terutama suara Anda. Mereka mungkin merespons suara Anda dengan bergerak, dan detak jantung mereka mungkin melambat, menunjukkan mereka tenang dan rileks.</li>
  <li>Pada 27 minggu kehamilan, bayi Anda tetap aktif, sering mengubah posisi di dalam rahim Anda. Ini akan berlanjut hingga akhir kehamilan Anda.</li>
</ul>""",
    "perkembangan_bayi_en": """<h2>27 Weeks Pregnant: Your Baby’s Development</h2>
<p>You’ve reached the last week of your second trimester! Here’s what your baby is up to at 27 weeks:</p>
<ul>
  <li>Your baby’s skin is becoming smoother as they gain more fat—they’re growing quickly!</li>
  <li>Your baby is practicing kicks, stretches, and even starting to make grasping motions.</li>
  <li>They’re also starting to "smile," especially during sleep.</li>
  <li>After being fused shut for over four months, your baby's eyelids can open again, allowing them to see light and shadows.</li>
  <li>Your baby may begin recognizing familiar voices, especially yours. They might respond to your voice by moving, and their heart rate may slow down, indicating they’re calm and relaxed.</li>
  <li>At 27 weeks pregnant, your baby remains active, frequently changing positions in your uterus. This will continue until the end of your pregnancy.</li>
</ul>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda pada 27 Minggu Kehamilan</h2>
<p>Semakin dekat dengan hari kelahiran bayi Anda, ada baiknya mempelajari cara mengelola rasa sakit saat persalinan dan perbedaan antara kontraksi Braxton Hicks dan kontraksi persalinan sebenarnya. Mengetahui apa yang diharapkan bisa membuat Anda merasa lebih percaya diri saat mendekati tanggal kelahiran.</p>
<p>Anda mungkin merasa cemas sekarang karena Anda mendekati akhir kehamilan. Redakan ketakutan Anda dengan membaca tentang persalinan, kelahiran, dan hari-hari awal menjadi orang tua.</p>
<p>Ingatlah untuk bersenang-senang di sepanjang jalan untuk mengalihkan perhatian dari kekhawatiran. Cobalah berlatih yoga dan pastikan Anda tidur cukup untuk membantu mengurangi stres dan meningkatkan suasana hati Anda.</p>""",
    "perubahan_tubuh_en": """<h2>Your Body at 27 Weeks Pregnant</h2>
<p>As the day you meet your baby gets closer, it can be helpful to learn about managing labor pain and the difference between Braxton Hicks contractions and true labor contractions. Knowing what to expect can make you feel more confident as your due date approaches.</p>
<p>You might feel some anxiety now that you're nearing the end of your pregnancy. Ease your fears by reading about labor, delivery, and the early days of parenthood.</p>
<p>Remember to have some fun along the way to distract from any worries. Try practicing yoga and ensure you get enough sleep to help reduce stress and improve your mood.</p>""",
    "gejala_umum_id": """<h2>27 Minggu Hamil: Gejala Anda</h2>
<p>Pada 27 minggu kehamilan, Anda mungkin mengalami gejala berikut:</p>
<ul>
  <li><strong>Nyeri tulang panggul:</strong> Hormon menyebabkan sendi dan ligamen Anda melonggar untuk persiapan persalinan. Sendi yang menghubungkan kedua bagian panggul menjadi lebih fleksibel, yang bisa menyebabkan nyeri panggul. Hindari berdiri terlalu lama dan jangan mengangkat benda berat.</li>
  <li><strong>Sembelit:</strong> Hormon dan rahim yang semakin besar bisa memperlambat pencernaan dan menekan rektum, menyebabkan sembelit. Minumlah banyak air dan makan makanan tinggi serat seperti buah-buahan, sayuran, dan biji-bijian. Tanyakan kepada penyedia layanan kesehatan Anda tentang obat yang aman.</li>
  <li><strong>Cairan vagina:</strong> Cairan bening atau keputihan normal dan mungkin meningkat. Jika Anda melihat perubahan warna, konsistensi, atau bau, itu bisa menjadi infeksi. Hubungi penyedia layanan kesehatan Anda jika Anda melihat perubahan.</li>
  <li><strong>Perubahan pigmen kulit:</strong> Peningkatan melanin bisa menggelapkan kulit, puting, dan menyebabkan linea nigra. Beberapa orang mungkin mengembangkan bercak coklat di wajah yang disebut chloasma. Perubahan ini biasanya memudar setelah melahirkan. Lindungi diri dari matahari untuk mencegah bercak gelap semakin parah.</li>
  <li><strong>Mimpi yang jelas:</strong> Mimpi aneh umum terjadi, terutama di trimester ketiga. Ini bisa menghibur tetapi mungkin mengganggu tidur Anda.</li>
  <li><strong>Kram:</strong> Kram perut, nyeri perut bagian bawah, nyeri punggung, perdarahan, atau kontraksi sering bisa menjadi tanda persalinan prematur. Hubungi penyedia layanan kesehatan Anda jika Anda mengalami gejala ini.</li>
</ul>""",
    "gejala_umum_en": """<h2>27 Weeks Pregnant: Your Symptoms</h2>
<p>At 27 weeks pregnant, you might notice these symptoms:</p>
<ul>
  <li><strong>Pelvic bone pain:</strong> Hormones cause your joints and ligaments to loosen in preparation for labor. The joint connecting the halves of your pelvis becomes more flexible, which can cause pelvic pain. Try to avoid standing for long periods and don't lift heavy objects.</li>
  <li><strong>Constipation:</strong> Hormones and your growing uterus can slow digestion and put pressure on your rectum, causing constipation. Stay hydrated and eat high-fiber foods like fruits, vegetables, and whole grains. Ask your healthcare provider about safe remedies.</li>
  <li><strong>Vaginal discharge:</strong> A clear or whitish discharge is normal and may increase. If you notice changes in color, consistency, or odor, it could be an infection. Contact your healthcare provider if you notice any changes.</li>
  <li><strong>Skin pigmentation changes:</strong> Increased melanin can darken your skin, nipples, and cause a linea nigra. Some may develop brown patches on the face called chloasma. These changes usually fade after birth. Protect yourself from the sun to prevent dark patches from worsening.</li>
  <li><strong>Vivid dreams:</strong> Strange dreams are common, especially in the third trimester. They can be entertaining but might interfere with sleep.</li>
  <li><strong>Cramping:</strong> Abdominal cramps, lower abdominal pain, back pain, bleeding, or frequent contractions could signal preterm labor. Contact your healthcare provider if you experience these symptoms.</li>
</ul>""",
    "tips_mingguan_id": """<h2>27 Minggu Hamil: Hal-Hal yang Perlu Dipertimbangkan</h2>
<p>Wajar jika banyak pikiran muncul di usia 27 minggu kehamilan. Membuat daftar dan meminta bantuan bisa mendukung Anda selama trimester terakhir. Berikut beberapa hal yang perlu dipikirkan:</p>
<ul>
  <li>Bagaimana rutinitas olahraga Anda? Jika mencari cara baru untuk tetap aktif, cobalah berenang. Pada usia 27 minggu kehamilan, saat perut Anda semakin besar, berenang menawarkan latihan kardio yang baik dan lembut pada sendi serta dapat meredakan sakit dan nyeri. Ini juga cara yang baik untuk tetap sejuk selama bulan-bulan musim panas.</li>
  <li>Sekarang adalah waktu yang baik untuk memberi tahu penyedia layanan kesehatan Anda jika ingin mengumpulkan dan menyimpan darah tali pusat bayi Anda. Darah tali pusat yang mengandung sel induk dikumpulkan dari tali pusat dan plasenta setelah lahir dan bisa mengobati beberapa penyakit. Anda dapat menyumbang ke bank darah tali pusat publik atau menyimpannya di bank pribadi dengan biaya tertentu. Penyedia layanan kesehatan Anda dapat memberikan lebih banyak informasi tentang opsi penyimpanan darah tali pusat.</li>
  <li>Jika tes darah awal menunjukkan Anda Rh negatif, penyedia layanan kesehatan Anda mungkin akan memberi suntikan Rh immunoglobulin antara minggu 24 hingga 28. Ini mencegah tubuh Anda membuat antibodi terhadap sel darah bayi Anda jika mereka Rh positif. Setelah lahir, bayi Anda akan diuji. Jika mereka positif, Anda akan mendapatkan suntikan lain untuk melindungi kehamilan berikutnya.</li>
  <li>Pikirkan detail rencana kelahiran Anda. Misalnya, jika Anda ingin pasangan Anda memotong tali pusat, diskusikan ini dengan penyedia layanan kesehatan sebelumnya. Pastikan pasangan Anda merasa nyaman dengan itu. Ingat, kelahiran bisa tidak terduga, tetapi penyedia layanan kesehatan Anda akan mencoba mengikuti preferensi Anda jika aman.</li>
  <li>Jika naluri merapikan rumah muncul, Anda mungkin ingin mengatur barang-barang di rumah, membuat daftar perbaikan, atau mulai membuat rumah aman untuk bayi. Jangan berlebihan. Luangkan waktu untuk beristirahat dan minta bantuan untuk tugas-tugas yang mungkin tidak aman bagi Anda, seperti naik tangga.</li>
  <li>Pertimbangkan untuk pergi babymoon sebelum bayi Anda lahir saat Anda masih merasa nyaman untuk bepergian. Periksa dengan penyedia layanan kesehatan Anda sebelum merencanakan penerbangan.</li>
</ul>""",
    "tips_mingguan_en": """<h2>27 Weeks Pregnant: Things to Consider</h2>
<p>It’s normal to have many thoughts at 27 weeks pregnant. Making lists and asking for help can support you during your final trimester. Here are some things to think about:</p>
<ul>
  <li>How is your exercise routine? If you’re looking for a new way to stay active, try swimming. At 27 weeks pregnant, as your belly grows, swimming offers a good cardio workout that's gentle on your joints and can relieve aches and pains. It’s also a great way to stay cool during hot summer months.</li>
  <li>Now is a good time to tell your healthcare provider if you want to collect and store your baby’s cord blood. Cord blood, which contains stem cells, is collected from the umbilical cord and placenta after birth and can treat certain diseases. You can donate to a public cord blood bank or store it in a private bank, which charges fees. Your provider can give you more information on cord blood banking options.</li>
  <li>If initial blood tests show you are Rh negative, your provider might give you an Rh immune globulin shot between weeks 24 to 28. This prevents your body from making antibodies against your baby's blood cells if they are Rh positive. After birth, your baby will be tested. If they are positive, you'll get another shot to protect future pregnancies.</li>
  <li>Think about the details of your birth plan. For instance, if you want your birth partner to cut the umbilical cord, discuss this with your healthcare provider beforehand. Make sure your birth partner is comfortable with it. Remember, births can be unpredictable, but your provider will try to follow your preferences when it's safe.</li>
  <li>If your nesting instincts are kicking in, you might want to organize things at home, make a list of repairs, or start baby proofing. Don't overdo it. Make time to rest and ask for help with tasks that might be unsafe for you, like climbing a ladder.</li>
  <li>Consider going on a babymoon before your baby arrives while you still feel comfortable traveling. Check with your healthcare provider before planning a flight.</li>
</ul>""",
    "bayi_img_path": "week_27.jpg",
    "ukuran_bayi_img_path": "week_27_coliflor.svg"
  },
  {
    "id": "28",
    "minggu_kehamilan": "28",
    "berat_janin": 1200,
    "tinggi_badan_janin": 379,
    "ukuran_bayi_id": "Terong Besar",
    "ukuran_bayi_en": "Large Eggplant",
    "poin_utama_id": """<h2>Peristiwa Penting di Minggu ke-28 Kehamilan</h2>
<p>Inilah yang mungkin terjadi untuk Anda dan bayi Anda saat usia kehamilan 28 minggu:</p>
<ul>
  <li>Bayi Anda sekarang dapat membuka dan menutup matanya serta memiliki bulu mata kecil.</li>
  <li>Pada usia kehamilan 28 minggu, bayi Anda mungkin sangat aktif, bergerak dan mengubah posisi secara sering—siapkan diri untuk beberapa gerakan somersault yang menggemaskan!</li>
  <li>Ini adalah waktu yang tepat untuk mulai menghitung tendangan bayi Anda.</li>
  <li>Saat bayi dan perut Anda terus tumbuh, Anda mungkin merasa beberapa kelelahan, nyeri, dan kelelahan di sekitar usia kehamilan 28 minggu. Ingatlah untuk mengambil istirahat dan bersantai ketika diperlukan.</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 28 Weeks Pregnant</h2>
<p>Here's what you and your baby might be experiencing at 28 weeks pregnant:</p>
<ul>
  <li>Your baby can now open and close their eyes and even has tiny eyelashes.</li>
  <li>At 28 weeks pregnant, your baby may be quite active, moving around and changing positions frequently—get ready for some adorable somersaults!</li>
  <li>This is a good time to start counting your baby's kicks.</li>
  <li>As your baby and bump continue to grow, you may feel some heaviness, aches, and fatigue around 28 weeks pregnant. Remember to take breaks and rest when needed.</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>Perkembangan Bayi Anda di Usia Kehamilan 28 Minggu</h2>
<p>Selamat datang di trimester ketiga! Di usia kehamilan 28 minggu, bayi Anda mengalami beberapa perkembangan yang menarik, termasuk yang berikut ini:</p>
<ul>
  <li>Bayi Anda sekarang bisa membuka dan menutup mata mereka, bahkan mungkin sudah memiliki bulu mata kecil!</li>
  <li>Meskipun otak bayi Anda terus berkembang, sistem saraf pusat sudah cukup berkembang untuk mulai mengatur suhu tubuh bayi Anda.</li>
  <li>Pada usia kehamilan 28 minggu, posisi bayi Anda di dalam rahim mungkin dengan kepala menghadap ke bawah, atau dengan posisi sungsang di mana bokong, kaki, atau keduanya menghadap ke bawah.</li>
  <li>Penyedia layanan kesehatan Anda mungkin dapat menentukan posisi bayi Anda melalui ultrasound atau pemeriksaan. Namun, jika bayi Anda berada dalam posisi sungsang atau posisi lain yang tidak biasa, jangan khawatir—masih ada waktu bagi mereka untuk berputar dalam beberapa minggu mendatang.</li>
  <li>Anda mungkin ingin mulai memantau gerakan bayi Anda pada usia kehamilan 28 minggu. Perhatikan apakah mereka lebih aktif selama periode istirahat atau setelah makan. Menghitung tendangan mereka bisa menjadi pengalaman ikatan awal bagi Anda dan bayi Anda!</li>
</ul>""",
    "perkembangan_bayi_en": """<h2>28 Weeks Pregnant: Your Baby’s Development</h2>
<p>Welcome to the third trimester! At 28 weeks pregnant, your baby is undergoing some fascinating developments:</p>
<ul>
  <li>Your baby can now open and close their eyes, and they may even have tiny eyelashes!</li>
  <li>While your baby's brain continues to develop, their central nervous system has progressed enough to begin regulating their body temperature.</li>
  <li>By 28 weeks pregnant, your baby may be positioned with their head facing downward, or in the breech presentation with their buttocks, feet, or both pointing downward.</li>
  <li>Your healthcare provider may determine your baby's position through an ultrasound or examination. However, if your baby is in the breech position or another unusual posture, don't worry—there's still time for them to turn around in the coming weeks.</li>
  <li>You might consider starting to monitor your baby's movements at 28 weeks pregnant. Notice if they're more active during rest periods or after meals. Counting their kicks can be an early bonding experience for you and your baby!</li>
</ul>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda saat Usia Kehamilan 28 Minggu</h2>
<p>Saat memasuki trimester ketiga, ingatlah bahwa Anda dan bayi Anda masih memiliki beberapa tahap pertumbuhan. Perut Anda yang semakin membesar pada usia kehamilan 28 minggu mungkin terkadang menjadi tidak nyaman, dan Anda mungkin merasa lebih cepat lelah seiring berjalannya minggu-minggu. Tubuh Anda bekerja keras untuk menyediakan lingkungan yang mendukung bagi pertumbuhan bayi Anda selama bulan-bulan terakhir ini.</p>
<p>Lanjutkan untuk fokus pada menjaga pola makan yang sehat dengan mengonsumsi makanan dan camilan yang bergizi. Makan dengan baik dapat membantu menjaga tingkat energi Anda, terutama jika Anda merasa lelah.</p>
<p>Jika disarankan oleh penyedia layanan kesehatan Anda, pastikan Anda mengonsumsi vitamin prenatal atau suplemen untuk memenuhi kebutuhan kalsium dan zat besi Anda.</p>
<p>Selain itu, tetaplah berolahraga dengan moderat sesuai saran penyedia layanan kesehatan Anda untuk mengatasi kelelahan. Jika Anda khawatir tentang penambahan berat badan Anda, berkonsultasilah dengan penyedia Anda untuk memastikan berat badan Anda berada dalam kisaran yang sehat.</p>""",
    "perubahan_tubuh_en": """<h2>Your Body at 28 Weeks Pregnant</h2>
<p>As you enter the third trimester, remember that both you and your baby still have some growing to do. Your expanding belly at 28 weeks pregnant might become inconvenient at times, and you may find yourself feeling more fatigued as the weeks progress. Your body is working hard to provide a nurturing environment for your growing baby during these final months.</p>
<p>Continue to focus on maintaining a healthy diet by eating nutritious meals and snacks. Eating well can help sustain your energy levels, especially if you've been feeling tired.</p>
<p>If recommended by your healthcare provider, ensure you're taking prenatal vitamins or supplements to meet your calcium and iron needs.</p>
<p>Additionally, keep up with moderate exercise as advised by your healthcare provider to combat fatigue. If you're worried about your weight gain, consult with your provider to ensure it's within a healthy range.</p>""",
    "gejala_umum_id": """<h2>Gejala Anda saat Usia Kehamilan 28 Minggu</h2>
<ul>
  <li><strong>Nyeri punggung:</strong> Banyak individu hamil mengalami nyeri punggung bagian bawah selama trimester ketiga karena sendi dan ligamen di panggul mulai mengendur. Ketidaknyamanan ini mungkin bertambah parah dengan perubahan postur dan penambahan berat badan. Menggunakan sepatu yang nyaman dan bantal untuk kenyamanan saat duduk dapat membantu mengurangi nyeri ini.</li>
  <li><strong>Sesak napas:</strong> Saat rahim Anda membesar, dapat menekan organ-organ perut Anda, membuat pernapasan menjadi lebih sulit. Memperhatikan postur yang baik mungkin membantu menciptakan lebih banyak ruang bagi paru-paru Anda untuk memperluas.</li>
  <li><strong>Hemoroid:</strong> Tekanan dari rahim yang berkembang dapat menyebabkan hemoroid, yang dapat menyebabkan nyeri dan gatal. Menjaga tubuh terhidrasi, mengonsumsi makanan yang kaya serat, dan mandi air hangat mungkin membantu mengelola gejala.</li>
  <li><strong>Kontraksi Braxton Hicks:</strong> Kontraksi latihan ini dapat terjadi sepanjang kehamilan dan mungkin semakin intens saat tanggal kelahiran Anda semakin dekat. Ini bukan kontraksi persalinan sejati dan biasanya mereda dengan istirahat dan hidrasi yang cukup.</li>
  <li><strong>Sering buang air kecil:</strong> Tekanan dari bayi yang berkembang mungkin menyebabkan seringnya kunjungan ke kamar mandi. Ini normal dan biasanya terselesaikan setelah melahirkan. Menggunakan pembalut mungkin membantu mengelola kebocoran urine.</li>
</ul>""",
    "gejala_umum_en": """<h2>28 Weeks Pregnant: Your Symptoms</h2>
<ul>
  <li><strong>Back pain:</strong> Many pregnant individuals experience lower back pain during the third trimester due to loosening joints and ligaments in the pelvis. This discomfort may worsen with changes in posture and weight gain. Wearing supportive shoes and using pillows for comfort while sitting can help alleviate this pain.</li>
  <li><strong>Shortness of breath:</strong> As your uterus expands, it can press against your abdominal organs, making it harder to breathe deeply. Maintaining good posture may help create more space for your lungs to expand.</li>
  <li><strong>Hemorrhoids:</strong> Pressure from the growing uterus can lead to hemorrhoids, which can cause pain and itching. Staying hydrated, consuming fiber-rich foods, and taking warm baths may help manage symptoms.</li>
  <li><strong>Braxton Hicks contractions:</strong> These practice contractions can occur throughout pregnancy and may intensify as your due date approaches. They are not true labor contractions and typically subside with rest and hydration.</li>
  <li><strong>Frequent urination:</strong> Pressure from your growing baby may cause frequent trips to the bathroom. This is normal and typically resolves after childbirth. Wearing a panty liner may help manage any leakage.</li>
</ul>""",
    "tips_mingguan_id": """<h2>28 Minggu Hamil: Hal yang Perlu Dipertimbangkan</h2>
<ul>
  <li>Dokter kesehatan Anda mungkin menyarankan Anda untuk mulai melacak gerakan bayi Anda, yang dikenal sebagai perhitungan tendangan, saat usia kehamilan 28 minggu. Ini melibatkan mencatat kapan Anda merasakan 10 tendangan, berguling, atau gerakan dalam waktu dua jam. Jika Anda tidak merasakan gerakan yang cukup, hubungi dokter kesehatan Anda.</li>
  <li>Apakah Anda melakukan latihan Kegel? Memperkuat otot panggul Anda dapat membantu mengendalikan kandung kemih, baik selama kehamilan maupun setelah melahirkan.</li>
  <li>Pertimbangkan pilihan Anda untuk kontrasepsi pasca melahirkan dan diskusikan dengan dokter kesehatan Anda, karena beberapa metode mungkin tidak cocok digunakan untuk individu yang menyusui.</li>
  <li>Saat perut Anda semakin besar, tanyakan dengan dokter kesehatan Anda tentang posisi tidur yang nyaman dan pertimbangkan untuk membeli bantal kehamilan untuk dukungan tambahan.</li>
  <li>Jika Anda merasa dorongan untuk bersarang, penuhilah dengan mengatur rumah Anda atau menyiapkan kamar bayi Anda. Ingatlah untuk mengambil istirahat dan menjaga energi Anda untuk hari-hari yang akan datang.</li>
</ul>""",
    "tips_mingguan_en": """<h2>28 Weeks Pregnant: Things to Consider</h2>
<ul>
  <li>Your healthcare provider might advise you to begin tracking your baby’s movements, known as kick counting, at 28 weeks pregnant. This involves noting when you feel 10 kicks, rolls, or movements in a two-hour period. If you don’t feel enough movement, contact your healthcare provider.</li>
  <li>Are you doing your Kegel exercises? Strengthening your pelvic floor muscles can help with bladder control, both during pregnancy and after childbirth.</li>
  <li>Consider your options for postpartum birth control and discuss them with your healthcare provider, as some methods may not be suitable for breastfeeding individuals.</li>
  <li>As your belly grows, inquire with your healthcare provider about comfortable sleeping positions and consider purchasing a pregnancy pillow for added support.</li>
  <li>If you feel the urge to nest, indulge it by organizing your home or preparing your baby’s nursery. Just remember to take breaks and conserve your energy for the days ahead.</li>
</ul>""",
    "bayi_img_path": "week_28.jpg",
    "ukuran_bayi_img_path": "week_28_egg_plant.svg"
  },
  {
    "id": "29",
    "minggu_kehamilan": "29",
    "berat_janin": 1400,
    "tinggi_badan_janin": 393,
    "ukuran_bayi_id": "Labu Butternut",
    "ukuran_bayi_en": "Butternut Squash",
    "poin_utama_id": """<h2>Hal Menarik Saat Hamil 29 Minggu</h2>
<ul>
  <li>Pada usia kehamilan 29 minggu, perkembangan utama bayi Anda telah selesai dan kini mereka fokus pada pertumbuhan dan penambahan berat badan untuk persiapan kelahiran.</li>
  <li>Ini adalah waktu yang tepat untuk mulai menghitung tendangan bayi Anda, karena mereka mungkin lebih aktif sekarang.</li>
  <li>Anda mungkin mengalami sedikit ketidaknyamanan dan kelelahan karena perut Anda yang semakin membesar, tapi ingatlah, Anda mendekati akhir kehamilan!</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 29 Weeks Pregnant</h2>
<ul>
  <li>At 29 weeks pregnant, your baby has completed major developments and is now focusing on growing and gaining weight in preparation for birth.</li>
  <li>This is a good time to start counting your baby's kicks, as they may be more active now.</li>
  <li>You might experience some discomfort and fatigue due to your growing bump, but remember, you're nearing the end of your pregnancy!</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>Perkembangan Bayi Anda Saat Hamil 29 Minggu</h2>
<ul>
  <li>Pada usia kehamilan 29 minggu, bayi Anda sedang cepat menambah berat badan. Selama dua setengah bulan berikutnya, mereka akan terus menambah berat badan lebih banyak, kemungkinan menggandakan berat badan saat ini.</li>
  <li>Meskipun perkembangan tubuh dan organ utama hampir selesai, paru-paru bayi Anda mungkin masih memerlukan waktu lebih lama untuk matang agar siap untuk hidup di luar kandungan.</li>
  <li>Bayi Anda menjadi lebih aktif, menendang, meregangkan, dan menggenggam. Anda mungkin akan memperhatikan peningkatan frekuensi dan kekuatan tendangan saat mereka berubah posisi dari waktu ke waktu.</li>
  <li>Disarankan oleh penyedia layanan kesehatan untuk menghitung gerakan bayi Anda sekali sehari saat hamil 29 minggu untuk memastikan perkembangan yang normal. Anda dapat menggunakan pelacak gerakan janin untuk membantu Anda melacaknya.</li>
</ul>""",
    "perkembangan_bayi_en": """<h2>29 Weeks Pregnant: Your Baby’s Development</h2>
<ul>
  <li>At 29 weeks pregnant, your baby is rapidly gaining weight. Over the next two and a half months, they will continue to put on more weight, likely doubling their current weight.</li>
  <li>While major body and organ development is nearly complete, your baby's lungs may still need more time to mature for life outside the womb.</li>
  <li>Your baby is becoming more active, kicking, stretching, and grasping. You may notice increased kicking frequency and strength as they change positions.</li>
  <li>It's recommended by healthcare providers to count your baby's movements once a day at 29 weeks pregnant to ensure normal development. You can use a fetal movement tracker to help you keep track.</li>
</ul>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda Saat Hamil 29 Minggu</h2>
<p>Saat ini, menjaga pola makan yang sehat sangat penting untuk pertumbuhan bayi Anda. Dua nutrisi penting yang mungkin Anda butuhkan adalah zat besi dan kalsium. Zat besi membantu tubuh Anda memperbarui sel darah merah, yang mengangkut oksigen ke seluruh tubuh dan mencegah anemia.</p>
<p>Selama kehamilan, disarankan untuk mengonsumsi setidaknya 30 miligram zat besi setiap hari, yang dapat diperoleh dari makanan kaya zat besi seperti hati sapi atau babi, kacang, sereal gandum utuh yang diperkaya, dan bubur oat. Penyedia layanan kesehatan Anda akan memantau kadar zat besi Anda dan mungkin meresepkan suplemen jika diperlukan.</p>
<p>Kalsium juga penting untuk tubuh Anda dan perkembangan bayi Anda, karena tidak hanya memperkuat tulang dan gigi Anda, tetapi juga membantu membentuk dan menguatkan tulang dan gigi bayi Anda.</p>
<p>Anda harus mendapatkan sekitar 1.000 miligram kalsium setiap hari (1.300 miligram jika Anda berusia di bawah 19 tahun). Sumber kalsium yang baik meliputi keju, brokoli, yogurt, dan roti gandum utuh.</p>
<p>Secara keseluruhan, selama trimester terakhir, Anda akan membutuhkan sekitar 450 kalori ekstra per hari. Saat hamil 29 minggu, Anda dapat mengharapkan penambahan berat sekitar satu pon per minggu hingga akhir kehamilan, dengan total sekitar 12 pon, dengan asumsi Anda memiliki BMI normal sebelum hamil dan melahirkan pada usia 40 minggu.</p>""",
    "perubahan_tubuh_en": """<h2>Your Body at 29 Weeks Pregnant</h2>
<p>Right now, maintaining a healthy diet is crucial for your baby's growth. Two essential nutrients you may require are iron and calcium. Iron aids in replenishing red blood cells, which transport oxygen throughout the body and prevent anemia.</p>
<p>During pregnancy, it's recommended to consume at least 30 milligrams of iron daily, which can be obtained from iron-rich foods such as liver, beans, fortified whole-grain cereals, and oatmeal. Your healthcare provider will monitor your iron levels and may prescribe a supplement if needed.</p>
<p>Calcium is also vital for both your body and your baby's development, as it strengthens bones and teeth and contributes to your baby's bone and teeth formation.</p>
<p>You should aim for about 1,000 milligrams of calcium daily (1,300 milligrams if you're younger than 19). Good sources of calcium include cheese, broccoli, yogurt, and whole-grain bread.</p>
<p>Overall, during the final trimester, you'll need approximately 450 extra calories per day. At 29 weeks pregnant, you can anticipate gaining about one pound per week until the end of your pregnancy, totaling around 12 pounds, assuming you had a normal BMI before pregnancy and deliver at 40 weeks.</p>""",
    "gejala_umum_id": """<h2>29 Minggu Hamil: Gejala yang Mungkin Dirasakan</h2>
<ul>
  <li><strong>Varises:</strong> Jika Anda melihat pembengkakan dan mungkin gatal pada pembuluh darah biru di kaki Anda, kemungkinan itu adalah varises. Hal ini disebabkan oleh tekanan dari uterus yang semakin membesar pada pembuluh darah utama di kaki Anda. Mengangkat kaki dan menghindari duduk atau berdiri dalam waktu lama dapat membantu mengurangi ketidaknyamanan.</li>
  <li><strong>Kelelahan:</strong> Merasa lelah adalah hal yang umum pada kehamilan 29 minggu, karena tubuh Anda bekerja keras untuk mendukung bayi Anda. Beristirahat sejenak sepanjang hari dan pertimbangkan menggunakan bantal di bawah perut Anda untuk dukungan saat tidur.</li>
  <li><strong>Kram kaki:</strong> Kram kaki sering terjadi selama kehamilan, terutama di malam hari. Memanjangkan kaki sebelum tidur dan memijat perlahan betis Anda dapat membantu mencegah atau mengurangi kram.</li>
  <li><strong>Sesak napas:</strong> Uterus yang semakin membesar dapat menekan paru-paru Anda, menyebabkan sesak napas. Praktikkan postur tubuh yang baik dan hindari overexertion untuk membantu meningkatkan pernapasan. Nyeri dada tidak boleh diabaikan, jadi hubungi penyedia layanan kesehatan Anda jika Anda mengalaminya.</li>
</ul>""",
    "gejala_umum_en": """<h2>29 Weeks Pregnant: Your Symptoms</h2>
<ul>
  <li><strong>Varicose veins:</strong> If you notice swollen and possibly itchy blue veins on your legs, these are likely varicose veins. They occur due to the pressure of your growing uterus on the major veins in your legs. Elevating your feet and avoiding long periods of sitting or standing can help relieve discomfort.</li>
  <li><strong>Fatigue:</strong> Feeling exhausted is common at 29 weeks pregnant, as your body works hard to support your baby. Take short breaks to rest throughout the day and consider using a pillow under your belly for support while sleeping.</li>
  <li><strong>Leg cramps:</strong> Leg cramps are a frequent occurrence during pregnancy, especially at night. Stretching your legs before bedtime and gently massaging your calves can help prevent or alleviate cramps.</li>
  <li><strong>Shortness of breath:</strong> Your growing uterus can press against your lungs, causing shortness of breath. Practice good posture and avoid overexertion to help improve breathing. Chest pains should not be ignored, so contact your healthcare provider if you experience them.</li>
</ul>""",
    "tips_mingguan_id": """<h2>29 Minggu Hamil: Hal yang Perlu Dipertimbangkan</h2>
<ul>
  <li><strong>Teknik relaksasi:</strong> Jika Anda merasa sedikit stres saat ini, pertimbangkan untuk mencoba metode relaksasi seperti prenatal yoga atau meditasi. Teknik-teknik ini dapat membantu menurunkan tekanan darah, mengurangi ketegangan otot, dan mengurangi nyeri pinggang bagian bawah, membuat Anda merasa lebih nyaman selama tahap akhir kehamilan Anda.</li>
  <li><strong>Persiapan persalinan:</strong> Jelajahi berbagai metode persiapan persalinan seperti metode Lamaze, Bradley, dan Read. Mengikuti kelas persiapan persalinan atau menonton video pendidikan persalinan online dapat mengajarkan teknik relaksasi dan membantu mengelola nyeri dan kecemasan selama persalinan.</li>
  <li><strong>Fasilitas persalinan:</strong> Jika belum, jadwalkan tur ke rumah sakit atau pusat persalinan tempat Anda berencana melahirkan. Ini akan membuat Anda lebih familiar dengan fasilitas, lokasi parkir, dan pintu masuk, dan memungkinkan Anda untuk bertanya tentang kebijakan dan prosedur.</li>
  <li><strong>Mitra persalinan:</strong> Tentukan siapa yang ingin Anda miliki bersama Anda selama persalinan, apakah itu pasangan Anda, teman, atau anggota keluarga. Diskusikan preferensi dan perasaan Anda tentang persalinan dengan mitra persalinan yang Anda pilih dengan baik sebelumnya.</li>
  <li><strong>Penitipan anak:</strong> Rencanakan pengaturan penitipan anak setelah bayi Anda lahir, terutama jika Anda dan pasangan Anda akan kembali bekerja. Teliti berbagai pilihan, seperti pusat penitipan anak atau perawatan di rumah, dan buat pengaturan sebelumnya untuk mengurangi stres setelah bayi Anda lahir.</li>
</ul>""",
    "tips_mingguan_en": """<h2>29 Weeks Pregnant: Things to Consider</h2>
<ul>
  <li><strong>Relaxation techniques:</strong> If you’re feeling stressed, consider trying relaxation methods like prenatal yoga or meditation. These techniques can help lower your blood pressure, reduce muscle tension, and ease lower back pain, making you feel more comfortable during the final stretch of your pregnancy.</li>
  <li><strong>Childbirth preparation:</strong> Explore different childbirth preparation methods such as Lamaze, Bradley, and Read techniques. Taking a childbirth preparation class or watching online childbirth education videos can teach you relaxation techniques and help manage pain and anxiety during labor.</li>
  <li><strong>Birth facility:</strong> If you haven't already, schedule a tour of the hospital or birthing center where you plan to give birth. This will familiarize you with the facilities, parking, and entrance locations, and allow you to ask questions about policies and procedures.</li>
  <li><strong>Birth partner:</strong> Decide who you want to be with you during labor and delivery, whether it's your partner, a friend, or a family member. Discuss your preferences and feelings about labor and delivery with your chosen birth partner well in advance.</li>
  <li><strong>Child care:</strong> Plan ahead for child care arrangements after your baby is born, especially if you and your partner will be returning to work. Research different options, such as child care centers or in-home care, and make arrangements in advance to alleviate stress after your baby arrives.</li>
</ul>""",
    "bayi_img_path": "week_29.jpg",
    "ukuran_bayi_img_path": "week_29_butternut_squash.svg"
  },
  {
    "id": "30",
    "minggu_kehamilan": "30",
    "berat_janin": 1600,
    "tinggi_badan_janin": 405,
    "ukuran_bayi_id": "Kol Besar",
    "ukuran_bayi_en": "Large Cabbage",
    "poin_utama_id": """<h2>Peristiwa Penting saat Hamil 30 Minggu</h2>
<ul>
  <li>Pada usia kehamilan 30 minggu, bayi Anda memiliki ukuran sebesar kubis.</li>
  <li>Bayi Anda mulai tumbuh rambut di kepala mereka sambil kehilangan rambut halus (lanugo) yang menutupi kulit mereka.</li>
  <li>Anda mungkin mengalami kontraksi latihan (Braxton Hicks) sekitar usia kehamilan ini atau dalam beberapa minggu mendatang. Kontraksi ini normal dan membantu persiapan tubuh Anda untuk persalinan.</li>
  <li>Pertimbangkan untuk melakukan penelitian tentang produk bayi terbaik yang tersedia untuk mempersiapkan kedatangan bayi Anda.</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 30 Weeks Pregnant</h2>
<ul>
  <li>At 30 weeks pregnant, your baby is approximately the size of a cabbage.</li>
  <li>Your little one is developing hair on their head while shedding the fine hair (lanugo) that covered their skin.</li>
  <li>You may notice practice contractions (Braxton Hicks) around this time or in the coming weeks. These contractions are normal and help prepare your body for labor.</li>
  <li>Consider researching the top baby products available to prepare for your baby's arrival.</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>30 Minggu Hamil: Perkembangan Bayi Anda</h2>
<ul>
  <li>Gerakan ritmis sesekali yang Anda rasakan di perut mungkin adalah bayi Anda sedang cegukan!</li>
  <li>Pada usia kehamilan 30 minggu, mata bayi Anda dapat terbuka dan tertutup, dan mereka bisa merasakan perubahan cahaya.</li>
  <li>Rambut halus yang menutupi kulit bayi Anda, yang disebut lanugo, mulai menghilang sekitar saat ini. Anda akan menemukan seberapa banyak lanugo bayi Anda lepas saat mereka lahir; beberapa bayi lahir dengan sedikit lanugo yang masih ada di bahu, punggung, atau telinga mereka.</li>
  <li>Bicara tentang rambut: Tahukah Anda bahwa beberapa bayi lahir dengan rambut kepala yang lebat? Pada usia kehamilan 30 minggu, rambut di kepala bayi Anda mulai tumbuh dan menebal. Tentu saja, Anda harus menunggu sampai bayi Anda lahir untuk mengetahui seberapa tebal rambut mereka!</li>
</ul>""",
    "perkembangan_bayi_en": """<h2>30 Weeks Pregnant: Your Baby’s Development</h2>
<ul>
  <li>Your baby may be hiccupping, causing rhythmic movements in your belly.</li>
  <li>At 30 weeks pregnant, your baby's eyes can open and close, and they can sense changes in light.</li>
  <li>The fine hair covering your baby's skin, known as lanugo, starts to disappear around this time. Some lanugo may remain at birth, usually on the shoulders, back, or ears.</li>
  <li>Some babies are born with a full head of hair. By 30 weeks, your baby's head hair is growing and thickening, but you'll have to wait until they're born to see how thick it is!</li>
  <li>If you're expecting twins, learn more about their development in our article on twin pregnancy week-by-week.</li>
</ul>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda Saat Hamil 30 Minggu</h2>
<p>Saat tanggal kelahiran semakin dekat, Anda mungkin merasa stres atau cemas, dan sangat penting untuk menjaga kesehatan pikiran, tubuh, dan jiwa Anda. Teknik relaksasi mungkin dapat membantu Anda merasa lebih tenang; Anda bisa mencoba beberapa dan melihat mana yang paling cocok.</p>
<p>Bagi beberapa orang, pijatan bisa menjadi solusi. Orang lain mendengarkan musik dengan mata tertutup atau melakukan yoga prenatal.</p>
<p>Jika Anda masih merasa overwhelmed dan tidak ada yang berhasil, jangan ragu untuk meminta saran tambahan dari penyedia layanan kesehatan Anda, dan pastikan Anda berbagi perasaan Anda dengan orang yang Anda cintai.</p>""",
    "perubahan_tubuh_en": """<h2>Your Body at 30 Weeks Pregnant</h2>
<p>As your due date approaches, you might be experiencing stress or anxiety, and it's crucial to take care of your overall well-being. Trying relaxation techniques can help you feel calmer and more centered. Some find relief through massages, while others prefer listening to calming music or practicing prenatal yoga.</p>
<p>If you're feeling overwhelmed and none of these techniques seem to work, don't hesitate to reach out to your healthcare provider for further advice. Remember to share your feelings with your loved ones for additional support.</p>""",
    "gejala_umum_id": """<h2>30 Minggu Hamil: Gejala yang Mungkin Dialami</h2>
<ul>
    <li><strong>Kontraksi Braxton Hicks:</strong> Sekitar 30 minggu kehamilan, Anda mungkin mengalami kontraksi Braxton Hicks, yang merupakan kontraksi latihan yang mempersiapkan tubuh Anda untuk persalinan. Mereka biasanya terjadi lebih sering saat Anda lelah atau dehidrasi, dan bisa menjadi lebih kuat menjelang tanggal kelahiran. Jika Anda tidak yakin apakah Anda mengalami kontraksi Braxton Hicks atau kontraksi persalinan yang sebenarnya, konsultasikan dengan penyedia layanan kesehatan Anda.</li>
    <li><strong>Kulit gatal:</strong> Penambahan berat badan selama kehamilan dan perut yang semakin membesar dapat menyebabkan rasa gatal karena kulit Anda meregang dan mengering. Mengoleskan lotion pelembap secara lembut dan menjaga kecukupan hidrasi dapat membantu mengurangi ketidaknyamanan ini.</li>
    <li><strong>Merasa sesak napas:</strong> Rahim yang membesar dapat mendorong perut dan diafragma Anda ke atas, membuat pernapasan menjadi lebih sulit sekitar 30 minggu kehamilan. Bergerak perlahan dan menjaga postur tubuh yang tepat dapat memberikan sedikit bantuan. Segera konsultasikan dengan penyedia layanan kesehatan Anda jika Anda mengalami nyeri dada atau perubahan signifikan dalam pernapasan.</li>
</ul>
<p>Penasaran apakah mengandung anak perempuan atau laki-laki memengaruhi gejala kehamilan pada usia kehamilan 30 minggu? Nah, bukti ilmiah menunjukkan bahwa gejala kehamilan tidak dipengaruhi oleh jenis kelamin bayi.</p>""",
    "gejala_umum_en": """<h2>30 Weeks Pregnant: Your Symptoms</h2>
<ul>
    <li><strong>Braxton Hicks contractions:</strong> Around 30 weeks pregnant, you may experience Braxton Hicks contractions, which are practice contractions preparing your body for labor. They typically occur more often when you're tired or dehydrated, and they can become stronger as your due date approaches. If you're uncertain whether you're experiencing Braxton Hicks or true labor contractions, consult your healthcare provider.</li>
    <li><strong>Itchy skin:</strong> Pregnancy weight gain and a growing belly may lead to itchiness as your skin stretches and dries out. Applying moisturizing lotion and staying hydrated can help alleviate this discomfort.</li>
    <li><strong>Feeling short of breath:</strong> Your expanding uterus can push your stomach and diaphragm upward, making breathing more challenging around 30 weeks pregnant. Moving slowly and maintaining proper posture can provide relief. Consult your healthcare provider immediately if you experience chest pains or significant changes in breathing.</li>
</ul>
<p>Curious about whether carrying a girl or a boy affects pregnancy symptoms at 30 weeks? Well, scientific evidence suggests that pregnancy symptoms are not influenced by the baby's assigned gender.</p>""",
    "tips_mingguan_id": """<h2>30 Minggu Hamil: Hal yang Perlu Dipertimbangkan</h2>
<ul>
    <li><strong>Babymoon:</strong> Jika disetujui oleh penyedia layanan kesehatan Anda, pertimbangkan untuk pergi babymoon dengan pasangan atau teman sebelum bayi Anda lahir. Perjalanan selama kehamilan dapat aman jika tindakan pencegahan diambil.</li>
    <li><strong>Diet Sehat:</strong> Pastikan Anda menjaga pola makan yang seimbang dan bergizi untuk mendukung pertumbuhan bayi Anda. Kalsium khususnya penting untuk perkembangan tulang dan gigi bayi Anda. Jika diperlukan, konsultasikan dengan penyedia layanan kesehatan Anda untuk suplemen kalsium.</li>
    <li><strong>Gerakan Bayi:</strong> Memantau gerakan bayi Anda dapat memberikan keyakinan tentang kesejahteraannya. Beberapa ahli menyarankan untuk memulai penghitungan tendangan sekitar 30 minggu kehamilan. Konsultasikan dengan penyedia layanan kesehatan Anda untuk panduan tentang cara melakukan penghitungan tendangan.</li>
    <li><strong>Pesta Bayi:</strong> Selesaikan detail registrasi bayi Anda sehingga tuan rumah pesta bayi Anda dapat mengirimkan undangan tepat waktu. Pastikan Anda telah mencantumkan semua keperluan penting pada daftar periksa registrasi Anda.</li>
    <li><strong>Doula:</strong> Pertimbangkan untuk menyewa seorang doula untuk dukungan persalinan. Seorang doula dapat memberikan kenyamanan dan bantuan sebelum, selama, dan setelah persalinan.</li>
</ul>""",
    "tips_mingguan_en": """<h2>30 Weeks Pregnant: Things to Consider</h2>
<ul>
    <li><strong>Babymoon:</strong> If approved by your healthcare provider, consider going on a babymoon with your partner or friends before your baby arrives. Traveling during pregnancy can be safe if precautions are taken.</li>
    <li><strong>Healthy Diet:</strong> Ensure you're maintaining a well-balanced and nutritious diet to support your baby's growth. Calcium is particularly important for your baby's bone and teeth development. If needed, consult your healthcare provider for calcium supplements.</li>
    <li><strong>Baby's Movements:</strong> Monitoring your baby's movements can provide reassurance about their well-being. Some experts recommend starting kick counts around 30 weeks of pregnancy. Consult your healthcare provider for guidance on how to perform kick counts.</li>
    <li><strong>Baby Shower:</strong> Finalize your baby registry details so your baby shower host can send out invitations in time. Ensure you've included all the essentials on your registry checklist.</li>
    <li><strong>Doula:</strong> Consider hiring a doula for labor support. A doula can offer comfort and assistance before, during, and after labor and childbirth.</li>
</ul>""",
    "bayi_img_path": "week_30.jpg",
    "ukuran_bayi_img_path": "week_30_cabage.svg"
  },
  {
    "id": "31",
    "minggu_kehamilan": "31",
    "berat_janin": 1800,
    "tinggi_badan_janin": 418,
    "ukuran_bayi_id": "Kelapa",
    "ukuran_bayi_en": "Coconut",
    "poin_utama_id": """<h2>31 Minggu Hamil: Sorotan</h2>
<ul>
    <li>Bayi Anda sekarang sekitar ukuran kelapa!</li>
    <li>Pertimbangkan untuk mendapatkan bra maternity untuk dukungan dan kenyamanan ekstra saat payudara Anda bertumbuh.</li>
    <li>Luangkan waktu untuk mengeksplorasi pilihan persalinan Anda dan memutuskan cara Anda merencanakan memberi makan bayi Anda setelah mereka lahir.</li>
</ul>""",
    "poin_utama_en": """<h2>31 Weeks Pregnant: Highlights</h2>
<ul>
    <li>Your baby is now approximately the size of a coconut!</li>
    <li>Consider getting maternity bras for better support and comfort as your breasts grow.</li>
    <li>Take some time to explore your delivery options and decide on how you plan to feed your baby once they are born.</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>31 Minggu Hamil: Perkembangan Bayi Anda</h2>
<ul>
    <li>Saat hamil 31 minggu, bayi Anda sedang cepat mengalami penambahan berat badan, dengan berat badannya diperkirakan akan mengalami penggandaan dalam beberapa bulan terakhir.</li>
    <li>Otak bayi Anda sedang berkembang dengan cepat, memungkinkan mereka untuk mulai mengatur suhu tubuh mereka sendiri, mengurangi ketergantungan mereka pada cairan ketuban untuk kehangatan.</li>
    <li>Menariknya, bayi Anda juga mengalami buang air kecil yang sering karena mereka menelan dan membuang beberapa cangkir cairan ketuban setiap hari.</li>
</ul>""",
    "perkembangan_bayi_en": """<h2>31 Weeks Pregnant: Your Baby’s Development</h2>
<ul>
    <li>Around 31 weeks of pregnancy, your baby is rapidly gaining weight, with their weight expected to double in the last few months.</li>
    <li>Your baby's brain is developing quickly, allowing them to begin regulating their own body temperature, reducing their reliance on the amniotic fluid for warmth.</li>
    <li>Interestingly, your baby is also experiencing frequent urination as they swallow and excrete several cups of amniotic fluid daily.</li>
</ul>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda Saat Hamil 31 Minggu</h2>
<p>Saat hamil 31 minggu, Anda mungkin akan melihat beberapa perubahan pada payudara Anda akibat kehamilan. Anda mungkin melihat garis-garis merah pada kulit Anda, yang merupakan tanda stretch mark. Sayangnya, tidak banyak yang dapat Anda lakukan untuk mencegah stretch mark dari muncul, tetapi mereka mungkin akan memudar seiring waktu setelah melahirkan. Tetap terhidrasi dan menjaga kelembapan kulit Anda dapat membantu mengurangi gatal-gatal pada kulit.</p>
<p>Saat payudara Anda bertambah besar, Anda mungkin perlu menambah ukuran bra Anda untuk mendapatkan dukungan yang lebih baik. Pertimbangkan untuk mengunjungi toko pakaian hamil atau departemen untuk fitting bra profesional. Bra hamil biasanya memiliki tali yang lebih lebar, cakupan yang lebih besar pada cup, dan kait bra ekstra untuk penyesuaian. Mereka bisa digunakan bahkan setelah melahirkan. Ada juga bra hamil khusus untuk digunakan saat tidur, serta bra olahraga hamil.</p>
<p>Pada tahap akhir trimester ketiga, Anda mungkin mengalami kebocoran kolostrum, cairan kental berwarna kekuningan, dari payudara Anda. Tidak semua individu hamil mengalami hal ini, tetapi jika Anda mengalami, Anda bisa menggunakan gaza atau nursing pad di dalam bra Anda untuk menyerap kolostrum. Kolostrum menyediakan protein dan antibodi penting bagi bayi yang disusui selama beberapa hari pertama sebelum produksi ASI dimulai.</p>""",
    "perubahan_tubuh_en": """<h2>Your Body at 31 Weeks Pregnant</h2>
<p>Around 31 weeks pregnant, you might notice some changes in your breasts due to pregnancy. You may observe reddish streaks on your skin, which are stretch marks. Unfortunately, there isn't much you can do to prevent stretch marks from forming, but they may fade over time after giving birth. Staying hydrated and moisturizing your skin can help alleviate any itchiness.</p>
<p>As your breasts grow, you may need to increase your bra size for better support. Consider visiting a maternity wear or department store for a professional fitting. Maternity bras typically have wider straps, more cup coverage, and extra bra hooks for adjustments. They can be used even after childbirth. There are also specialized nighttime maternity bras for extra support while sleeping, as well as maternity sports bras.</p>
<p>In the later stages of the third trimester, you might experience leakage of colostrum, a thick, yellowish fluid, from your breasts. Not all pregnant individuals experience this, but if you do, you can use gauze pads or nursing pads in your bra to absorb the colostrum. Colostrum provides essential proteins and antibodies to breastfed babies during the first few days before breast milk production begins.</p>""",
    "gejala_umum_id": """<h2>Gejala Anda Saat Hamil 31 Minggu</h2>
<ul>
  <li><strong>Nyeri pada tangan:</strong> Anda mungkin mengalami sindrom terowongan karpal karena pembengkakan jaringan di tangan, menyebabkan sensasi kesemutan atau mati rasa. Menggunakan splint pergelangan tangan dan istirahat tangan Anda dapat memberikan bantuan.</li>
  <li><strong>Ketidaknyamanan dari gerakan bayi:</strong> Gerakan aktif bayi Anda kadang-kadang bisa membuat tidak nyaman, tetapi juga bisa menenangkan Anda. Provider kesehatan Anda mungkin merekomendasikan memantau gerakan bayi Anda dengan "perhitungan tendangan" harian.</li>
  <li><strong>Merasa lelah:</strong> Normal merasa lelah pada usia kehamilan 31 minggu karena tekanan pada tubuh Anda. Tidur siang, makan dengan baik, dan berolahraga dapat membantu meningkatkan energi Anda.</li>
  <li><strong>Kulit gatal:</strong> Saat perut Anda membesar, Anda mungkin mengalami gatal-gatal pada perut dan area lain seperti payudara dan pantat. Menggunakan pelembap yang menenangkan dan minum banyak air dapat mengurangi ketidaknyamanan ini.</li>
  <li><strong>Kram kaki:</strong> Kram pada kaki bagian bawah, terutama pada malam hari, umum terjadi selama trimester ketiga. Peregangan, melenturkan kaki Anda, dan memijat betis Anda dapat membantu mengurangi kram ini.</li>
</ul>""",
    "gejala_umum_en": """<h2>31 Weeks Pregnant: Your Symptoms</h2>
<ul>
  <li><strong>Hand pain:</strong> You might experience carpal tunnel syndrome due to swelling tissues in your hands, causing tingling or numbness. Using a wrist splint and resting your hands can provide relief.</li>
  <li><strong>Discomfort from baby’s movements:</strong> Your active baby's movements may sometimes be uncomfortable, but they can also reassure you. Your healthcare provider may recommend monitoring your baby's movements with daily "kick counts."</li>
  <li><strong>Feeling exhausted:</strong> It's normal to feel tired at 31 weeks pregnant due to the strain on your body. Taking naps, eating well, and exercising can help boost your energy.</li>
  <li><strong>Itchy skin:</strong> As your belly grows, you may experience itchiness on your abdomen and other areas like breasts and buttocks. Using a soothing moisturizer and staying hydrated can alleviate this discomfort.</li>
  <li><strong>Leg cramps:</strong> Cramps in your lower legs, especially at night, are common during the third trimester. Stretching, flexing your feet, and massaging your calves can help relieve these cramps.</li>
</ul>""",
    "tips_mingguan_id": """<h2>31 Minggu Hamil: Hal yang Perlu Dipertimbangkan</h2>
<ul>
  <li><strong>Posisi Tidur:</strong> Mencari posisi tidur yang nyaman saat perut Anda semakin membesar bisa menjadi tantangan. Para ahli menyarankan untuk berbaring dengan posisi miring dan lutut ditekuk, serta menggunakan bantal kehamilan untuk kenyamanan tambahan.</li>
  <li><strong>Seks Selama Kehamilan:</strong> Jika kehamilan Anda normal dan Anda dan pasangan merasa nyaman, seks umumnya aman bahkan di trimester ketiga. Coba berbagai posisi dan konsultasikan dengan penyedia layanan kesehatan Anda jika memiliki kekhawatiran.</li>
  <li><strong>Rencana Pemberian Makan:</strong> Mulailah memikirkan apakah Anda berencana memberi ASI atau susu formula. Diskusikan opsi Anda dengan penyedia layanan kesehatan Anda, hadiri kelas laktasi jika diperlukan, dan cari tahu tentang perlengkapan yang mungkin Anda butuhkan.</li>
  <li><strong>Persalinan Alami:</strong> Pertimbangkan untuk mempersiapkan persalinan alami jika sesuai dengan preferensi Anda dan disetujui oleh penyedia layanan kesehatan Anda. Teliti opsi alternatif untuk mengurangi rasa sakit dan diskusikan rencana persalinan Anda dengan pasangan atau doula Anda.</li>
</ul>""",
    "tips_mingguan_en": """<h2>31 Weeks Pregnant: Things to Consider</h2>
<ul>
  <li><strong>Sleeping Positions:</strong> Finding a comfortable sleeping position as your belly grows can be challenging. Experts recommend lying on your side with knees bent and using pregnancy pillows for added comfort.</li>
  <li><strong>Sex During Pregnancy:</strong> If your pregnancy is normal and both you and your partner feel comfortable, sex is generally safe even in the third trimester. Experiment with different positions and consult your healthcare provider if you have any concerns.</li>
  <li><strong>Feeding Plans:</strong> Start thinking about whether you plan to breastfeed or formula feed. Discuss your options with your healthcare provider, attend lactation classes if necessary, and gather information about equipment you may need.</li>
  <li><strong>Natural Childbirth:</strong> Consider preparing for a natural delivery if it aligns with your preferences and your healthcare provider approves. Research alternative pain relief options and discuss your birth plan with your partner or doula.</li>
</ul>""",
    "bayi_img_path": "week_31.jpg",
    "ukuran_bayi_img_path": "week_31_coconut.svg"
  },
  {
    "id": "32",
    "minggu_kehamilan": "32",
    "berat_janin": 2000,
    "tinggi_badan_janin": 430,
    "ukuran_bayi_id": "Bengkuang",
    "ukuran_bayi_en": "Jicama",
    "poin_utama_id": """<h2>Info Penting pada Usia Kehamilan 32 Minggu</h2>
<ul>
  <li>Bayi Anda mungkin akan mengubah posisinya menjadi kepala turun dalam persiapan persalinan sekitar usia kehamilan 32 minggu.</li>
  <li>Pada usia kehamilan 32 minggu, bayi Anda mungkin sudah memiliki rambut di kepala, bulu mata, alis, dan kuku jari kaki yang terlihat.</li>
  <li>Kenali tanda dan gejala persalinan pada usia kehamilan 32 minggu dan rencanakan rute ke rumah sakit sesuai kebutuhan.</li>
  <li>Pastikan Anda memiliki semua perlengkapan penting untuk bayi baru Anda.</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 32 Weeks Pregnant</h2>
<ul>
  <li>Your baby may position head-down in preparation for birth around 32 weeks.</li>
  <li>By 32 weeks, your baby may have developed hair on their head, eyelashes, eyebrows, and visible toenails.</li>
  <li>Be aware of the signs and symptoms of labor and plan your route to the hospital accordingly.</li>
  <li>Ensure you have all the essential items for your newborn ready.</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>32 Minggu Hamil: Perkembangan Bayi Anda</h2>
<ul>
  <li>Pada tahap ini, bayi Anda mulai menyerupai bayi yang akan Anda jumpai nanti, dengan fitur seperti bulu mata, alis, dan rambut di kepala sudah terbentuk sepenuhnya.</li>
  <li>Mereka mulai menghilangkan lanugo, rambut halus yang menutupi tubuh mereka, dengan sebagian besar sudah hilang pada saat ini, meskipun beberapa bayi mungkin masih memiliki sisa-sisa lanugo saat lahir.</li>
  <li>Untuk bayi laki-laki, testisnya mulai turun ke dalam skrotum.</li>
  <li>Bayi Anda kemungkinan besar sudah berada dalam posisi kepala ke bawah, yang umum terjadi dalam beberapa minggu menjelang persalinan, meskipun mereka mungkin masih sering mengubah posisi.</li>
  <li>Ada penumpukan lemak yang semakin banyak di bawah kulit, membuatnya berubah dari transparan menjadi tidak tembus pandang.</li>
  <li>Kuku jari kaki bayi Anda telah tumbuh dan sekarang terlihat, menunjukkan perlunya gunting kuku bayi segera.</li>
</ul>""",
    "perkembangan_bayi_en": """<h2>32 Weeks Pregnant: Your Baby’s Growth</h2>
<ul>
  <li>At this stage, your baby is beginning to resemble the newborn you'll soon meet, with features like eyelashes, eyebrows, and hair on their head fully formed.</li>
  <li>They're shedding the lanugo, the fine hair covering their body, with most of it gone by now, although some babies may still have traces of it at birth.</li>
  <li>For baby boys, their testicles are descending into the scrotum.</li>
  <li>Your baby is likely positioning head-down, a common occurrence in the weeks leading up to birth, although they might still change positions frequently.</li>
  <li>There's increasing fat deposition under the skin, transitioning it from translucent to opaque.</li>
  <li>Your baby's toenails have grown and are now visible, indicating the need for baby nail clippers soon.</li>
</ul>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda pada Minggu ke-32 Kehamilan</h2>
<p>Selama kehamilan, Anda mungkin mengalami perubahan di mulut, gigi, dan gusi yang dapat menyebabkan ketidaknyamanan. Perubahan tersebut mungkin termasuk:</p>
<ul>
  <li><strong>Gusi sensitif:</strong> Jika gusi Anda terasa lebih sensitif, bengkak, atau berdarah saat menyikat atau menggosok gigi, berkumur dengan air garam dan menggunakan sikat yang lebih lembut mungkin dapat membantu.</li>
  <li><strong>Gigi terasa longgar:</strong> Perubahan hormonal dapat membuat ligamen Anda menjadi lebih rileks, termasuk ligamen kecil yang menjaga gigi tetap pada tempatnya. Meskipun gigi Anda mungkin terasa lebih longgar, kemungkinan kehilangan gigi karena alasan ini rendah, dan sensasi ini biasanya akan berkurang setelah melahirkan.</li>
  <li><strong>Luka di mulut:</strong> Aktivitas kekebalan tubuh yang meningkat selama kehamilan dapat menyebabkan luka di mulut, yang biasanya hilang setelah persalinan.</li>
</ul>
<p>Merawat kebersihan mulut yang baik sangat penting dengan cara menggosok gigi dua kali sehari, menggunakan benang gigi setiap hari, dan melakukan pemeriksaan gigi rutin setiap enam bulan sekali. Jika prosedur gigi elektif diperlukan dan belum dilakukan pada trimester kedua, disarankan untuk menjadwalkannya pada paruh pertama trimester ketiga. Pekerjaan gigi besar mungkin ditunda hingga setelah melahirkan, sesuai dengan rekomendasi dokter gigi Anda.</p>""",
    "perubahan_tubuh_en": """<h2>Your Body at 32 Weeks Pregnant</h2>
<p>During pregnancy, you may notice changes in your mouth, teeth, and gums that could cause discomfort. These changes may include:</p>
<ul>
  <li><strong>Sensitive gums:</strong> If your gums feel more sensitive, swell, or bleed while brushing or flossing, rinsing with salt water and using a softer brush might help.</li>
  <li><strong>Looser teeth:</strong> Hormonal shifts can relax ligaments, including those that hold your teeth in place. While your teeth may feel looser, it's unlikely you'll lose any, and this sensation typically diminishes after childbirth.</li>
  <li><strong>Mouth sores:</strong> Increased immune activity during pregnancy may lead to mouth sores, which usually resolve after delivery.</li>
</ul>
<p>It's essential to maintain good oral hygiene by flossing daily, brushing twice a day, and attending regular dental checkups every six months. If elective dental procedures are necessary and weren't completed in the second trimester, it's advisable to schedule them during the first half of the third trimester. Major dental work may be deferred until after childbirth, as recommended by your dentist.</p>""",
    "gejala_umum_id": """<h2>32 Minggu Hamil: Gejala yang Mungkin Dirasakan</h2>
<p>Pada usia kehamilan 32 minggu, Anda mungkin mengalami beberapa gejala berikut:</p>
<ul>
  <li><strong>Kram kaki:</strong> Banyak wanita hamil mengalami kram yang menyakitkan di betis saat memasuki tahap akhir kehamilan. Meskipun penyebab pastinya tidak diketahui, memanjangkan kaki sebelum tidur malam dan memijat betis dapat membantu mengurangi ketidaknyamanan.</li>
  <li><strong>Diare:</strong> Meskipun tidak menyenangkan, diare bisa terjadi selama kehamilan, termasuk pada usia kehamilan 32 minggu. Pastikan untuk tetap terhidrasi dengan minum banyak air. Dalam beberapa kasus, diare mungkin menjadi tanda persalinan prematur, terutama jika disertai dengan gejala lain seperti kram perut atau tekanan panggul. Hubungi penyedia layanan kesehatan Anda jika Anda mengalami gejala tersebut.</li>
  <li><strong>"Pregnancy brain":</strong> Lupa dan sulit berkonsentrasi, yang sering disebut "pregnancy brain", adalah pengalaman umum bagi banyak ibu hamil. Meskipun tidak diakui secara medis, membuat daftar tugas bisa membantu mengelola gejala tersebut.</li>
</ul>""",
    "gejala_umum_en": """<h2>32 Weeks Pregnant: Your Symptoms</h2>
<p>At 32 weeks pregnant, you might experience the following symptoms:</p>
<ul>
  <li><strong>Leg cramps:</strong> Many pregnant individuals suffer from painful cramps in their calves during the late stages of pregnancy. While the exact cause is unknown, stretching your legs before bedtime and massaging your calves can help alleviate discomfort.</li>
  <li><strong>Diarrhea:</strong> Though unpleasant, diarrhea can occur during pregnancy, including around 32 weeks. Stay hydrated by drinking plenty of water. In some cases, diarrhea may signal preterm labor, especially if accompanied by other symptoms like abdominal cramps or pelvic pressure. Contact your healthcare provider if you experience such symptoms.</li>
  <li><strong>“Pregnancy brain”:</strong> Forgetfulness and difficulty concentrating, often referred to as “pregnancy brain,” are common experiences for many expectant parents. While not medically recognized, keeping to-do lists can help manage these symptoms.</li>
</ul>""",
    "tips_mingguan_id": """<h2>32 Minggu Hamil: Hal yang Perlu Dipertimbangkan</h2>
<p>Berikut adalah beberapa hal penting yang perlu Anda pertimbangkan saat hamil 32 minggu:</p>
<ul>
  <li>Perhatikan gejala seperti penambahan berat badan tiba-tiba, sakit kepala yang persisten, perubahan penglihatan, nyeri di bagian atas perut atau bahu, dan pembengkakan. Ini bisa menjadi tanda preeklampsia, gangguan tekanan darah tinggi yang terkait dengan kehamilan. Jika Anda mengalami gejala tersebut, segera beritahu penyedia layanan kesehatan Anda.</li>
  <li>Kenali tanda dan gejala persalinan prematur untuk tetap siap pada usia kehamilan 32 minggu. Pelajari perbedaan antara kontraksi nyata dan kontraksi Braxton Hicks. Jika Anda mencurigai persalinan prematur, segera hubungi penyedia layanan kesehatan Anda. Mereka mungkin merekomendasikan tindakan seperti istirahat di tempat tidur, hidrasi, atau obat-obatan untuk menghentikan kontraksi.</li>
  <li>Pada usia kehamilan 32 minggu, penyedia layanan kesehatan Anda mungkin akan menyarankan Anda untuk memantau gerakan janin. Salah satu metode adalah melakukan "perhitungan tendangan" untuk melacak gerakan bayi Anda. Pilih waktu ketika bayi Anda biasanya aktif, seperti setelah makan.</li>
  <li>Meskipun Anda masih memiliki waktu hingga kehamilan penuh, minggu-minggu terakhir kehamilan bisa membuat Anda merasa kewalahan. Vereifikasi persiapan Anda dengan menjelajahi daftar produk bayi yang direkomendasikan. Popok akan menjadi salah satu barang penting Anda, jadi lihatlah panduan ukuran popok dan berat badan untuk bantuan.</li>
</ul>""",
    "tips_mingguan_en": """<h2>32 Weeks Pregnant: Things to Consider</h2>
<p>Here are some important considerations for you at 32 weeks pregnant:</p>
<ul>
  <li>Be vigilant for symptoms such as sudden weight gain, persistent headaches, changes in vision, upper abdominal or shoulder pains, and swelling or puffiness. These could indicate preeclampsia, a pregnancy-related high blood pressure disorder. If you notice any of these symptoms, inform your healthcare provider immediately.</li>
  <li>Familiarize yourself with the signs and symptoms of preterm labor to stay prepared at 32 weeks pregnant. Learn to differentiate between real contractions and Braxton Hicks contractions. If you suspect preterm labor, contact your healthcare provider promptly. They may recommend measures like bed rest, hydration, or medications to stop contractions.</li>
  <li>Around 32 weeks, your healthcare provider may advise you to monitor fetal movements. One method is doing "kick counts" to track your baby's movements. Choose a time when your baby is usually active, such as after a meal.</li>
  <li>Although you still have some time until full term, the final weeks of pregnancy can be overwhelming. Simplify your preparations by exploring a list of recommended baby products. Diapers will be one of your essential items, so refer to a diaper size and weight chart guide for assistance.</li>
</ul>""",
    "bayi_img_path": "week_32.jpg",
    "ukuran_bayi_img_path": "week_32_jicama.svg"
  },
  {
    "id": "33",
    "minggu_kehamilan": "33",
    "berat_janin": 2200,
    "tinggi_badan_janin": 440,
    "ukuran_bayi_id": "Nanas",
    "ukuran_bayi_en": "Pineapple",
    "poin_utama_id": """<h2>Perkembangan pada Usia Kehamilan 33 Minggu</h2>
<p>Berikut adalah beberapa poin penting dan wawasan untuk ibu hamil pada usia kehamilan 33 minggu:</p>
<ul>
  <li>Bayi Anda kini sekitar seukuran nanas kecil!</li>
  <li>Tulang-tulangnya semakin mengeras, namun tengkorak masih lembut, yang membantu proses persalinan.</li>
  <li>Pada usia 33 minggu, indra pendengaran bayi Anda berkembang, dan mereka mungkin merespons cahaya.</li>
  <li>Pastikan Anda memberi prioritas pada tidur pada tahap ini! Dapatkan bantal tambahan untuk meningkatkan kenyamanan Anda saat malam hari, dan tidurlah sesuai kebutuhan.</li>
  <li>Anda mungkin sedang mempertimbangkan posisi persalinan yang paling cocok bagi Anda saat Anda memasuki minggu ke-33 kehamilan.</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 33 Weeks Pregnant</h2>
<p>Here are some key highlights and insights for those who are 33 weeks pregnant:</p>
<ul>
  <li>Your baby is now approximately the size of a small pineapple!</li>
  <li>Their bones are getting stronger, but the skull remains soft, which aids in the birthing process.</li>
  <li>At 33 weeks, your baby's sense of hearing is developing, and they may respond to light.</li>
  <li>Ensure you prioritize sleep at this stage! Invest in extra pillows to enhance your comfort during the night, and take naps whenever necessary.</li>
  <li>You might be contemplating the most suitable labor and birthing positions for you as you progress through week 33 of pregnancy.</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>Perkembangan Bayi Anda pada Usia Kehamilan 33 Minggu</h2>
<p>Berikut adalah beberapa perkembangan menakjubkan yang terjadi pada bayi Anda pada usia kehamilan 33 minggu:</p>
<ul>
  <li>Pada tahap kehamilan ini, otak bayi Anda aktif, dengan kelima indra kini sudah berfungsi!</li>
  <li>Bayi Anda sekarang dapat mendengar beberapa suara dari luar rahim. Mendengar suara Anda mungkin dapat menenangkan mereka, sehingga detak jantungnya melambat.</li>
  <li>Mereka juga dapat membedakan antara cahaya dan kegelapan dalam lingkungan mereka yang terbatas. Mata mereka sudah cukup berkembang sehingga pupilnya bereaksi terhadap perubahan cahaya.</li>
  <li>Bayi Anda sedang mengalami penambahan berat badan yang cepat pada usia kehamilan 33 minggu, meskipun panjang tubuh mereka mungkin tidak meningkat secara signifikan hingga saat hari kelahiran.</li>
  <li>Selain itu, tulang-tulangnya mulai mengeras, meskipun tengkoraknya tetap lentur untuk memfasilitasi kelahiran. Penampilan kepala yang sedikit tidak beraturan saat lahir adalah normal dan akan membaik seiring dengan penyatuan dan pengerasan tulang tengkorak selama dua tahun pertama kehidupan.</li>
  <li>Jika belum dipastikan sebelumnya, penyedia layanan kesehatan Anda akan menilai posisi bayi Anda dalam beberapa minggu mendatang. Jika mereka mencurigai posisi sungsang—dimana bokong atau kaki bayi berada di bagian bawah—sebuah USG mungkin direkomendasikan untuk memastikan.</li>
  <li>Bagi yang berusia 33 minggu dan hamil dengan bayi kembar, pelajari lebih lanjut tentang aspek unik kehamilan kembar selama trimester ketiga.</li>
</ul>""",
    "perkembangan_bayi_en": """<h2>33 Weeks Pregnant: Your Baby’s Development</h2>
<p>Here are some remarkable developments happening with your baby at 33 weeks pregnant:</p>
<ul>
  <li>At this stage of your pregnancy, your baby's brain is active, with all five senses now operational!</li>
  <li>Your little one can now perceive some sounds from outside the womb. Hearing your voice may have a calming effect, causing their heart rate to slow down.</li>
  <li>They can also differentiate between light and dark within their confined space. Their eyes are developed enough for their pupils to react to changes in light.</li>
  <li>Your baby is rapidly gaining weight by week 33 of pregnancy, although their length may not increase significantly from now until their due date.</li>
  <li>Moreover, their bones are starting to harden, although their skull remains pliable to facilitate passage through the birth canal. Any misshapen appearance of the head at birth is normal and will resolve as the skull bones fuse and harden during the first two years of life.</li>
  <li>If not already determined, your healthcare provider will assess your baby's position in the coming weeks. If they suspect a breech presentation—where the baby's buttocks or feet are positioned downward—an ultrasound may be recommended to confirm.</li>
  <li>For those who are 33 weeks pregnant with twins, learn more about the unique aspects of twin pregnancy during the third trimester.</li>
</ul>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda pada Usia Kehamilan 33 Minggu</h2>
<p>Pada tahap kehamilan ini, Anda mungkin mengalami kesulitan untuk tidur nyenyak. Karena ukuran tubuh Anda yang semakin besar dan perut yang menonjol, tidur sepanjang malam pada usia kehamilan 33 minggu bisa menjadi lebih sulit, yang mungkin membuat Anda merasa sangat lelah.</p>
<p>Usahakan membuat tempat tidur Anda sebaik mungkin dengan menambahkan bantal di bawah kaki dan perut Anda. Untuk merasa lebih istirahat, coba tidur siang kapan pun memungkinkan.</p>
<p>Merasa sakit pinggang bagian bawah dan tekanan pada panggul mungkin menjadi penyebab ketidaknyamanan sekitar usia kehamilan 33 minggu karena ukuran perut yang membesar. Jika bayi Anda "turun" ke posisi yang lebih rendah di panggul Anda, hal ini dapat menyebabkan peningkatan tekanan tidak hanya di daerah panggul tetapi juga di pinggul dan kandung kemih.</p>
<p>Anda dapat melakukan beberapa gerakan membungkuk ke belakang yang lembut untuk membantu mengurangi ketidaknyamanan: Berdiri tegak, letakkan tangan Anda di bagian bawah punggung, dan condongkan tubuh secara perlahan ke belakang (sekitar 15 hingga 20 derajat). Ulangi gerakan ini sesuai kebutuhan.</p>
<p>Konsultasikan dengan penyedia layanan kesehatan Anda untuk mendapatkan informasi lebih lanjut tentang latihan dan peregangan yang tepat untuk meredakan nyeri punggung, serta metode lain untuk mengelola ketidaknyamanan.</p>""",
    "perubahan_tubuh_en": """<h2>Your Body at 33 Weeks Pregnant</h2>
<p>At this stage of pregnancy, you might notice difficulties in getting enough sleep. Due to your increased size and prominent belly, sleeping through the night may become challenging, leading to feelings of exhaustion.</p>
<p>Enhance the comfort of your bed by adding pillows under your legs and abdomen. Taking daytime naps whenever possible can help you feel more rested.</p>
<p>Experiencing lower back pain and pelvic pressure around 33 weeks pregnant is common due to the enlarged belly. When your baby descends into a lower position in your pelvis, it can increase pressure not only in the pelvic region but also in the hips and bladder.</p>
<p>You can alleviate discomfort by performing gentle backbends: Stand upright, place your hands on your lower back, and gently lean backward (approximately 15 to 20 degrees). Repeat this movement as needed.</p>
<p>Consult your healthcare provider for guidance on appropriate exercises and stretches to relieve back pain, as well as other methods to manage discomfort.</p>""",
    "gejala_umum_id": """<h2>Gejala Anda pada Usia Kehamilan 33 Minggu</h2>
<ul>
    <li>
        <strong>Sering buang air kecil:</strong> Penurunan bayi dapat memberikan tekanan pada kandung kemih Anda, menyebabkan buang air kecil lebih sering, bahkan kadang-kadang saat tertawa atau bersin. Meskipun Anda tidak dapat menghindari gejala ini, mengenakan panty liner mungkin dapat membantu mengatasi kebocoran kandung kemih. Tetap terhidrasi, tetapi pertimbangkan untuk menggunakan toilet sebelum meninggalkan rumah atau menghadiri pertemuan.
    </li>
    <li>
        <strong>Kontraksi Braxton Hicks:</strong> Saat tanggal kelahiran Anda semakin dekat, kontraksi latihan ini mungkin semakin intens. Bedakan dengan kontraksi persalinan sejati dengan mengukurnya; kontraksi sejati berlangsung hingga 90 detik dan terjadi dengan interval teratur. Kontraksi Braxton Hicks biasanya terjadi pada malam hari atau setelah aktivitas fisik dan mereda dengan gerakan.
    </li>
    <li>
        <strong>Pembengkakan kaki:</strong> Tekanan dari rahim yang semakin membesar dapat menyebabkan pembengkakan pada kaki atau kaki. Hindari berdiri dalam waktu lama, angkat kaki Anda saat memungkinkan, dan pertimbangkan untuk menggunakan kaus kaki atau stoking yang mendukung.
    </li>
    <li>
        <strong>Sindrom terowongan karpal:</strong> Pembengkakan dapat menekan saraf di pergelangan tangan dan tangan Anda, menyebabkan ketidaknyamanan seperti mati rasa atau rasa kesemutan. Biasanya gejala ini akan mereda setelah melahirkan, tetapi penyangga pergelangan tangan mungkin dapat memberikan bantuan. Konsultasikan dengan penyedia layanan kesehatan Anda untuk panduan lebih lanjut.
    </li>
    <li>
        <strong>Kulit gatal:</strong> Peregangan kulit dapat menyebabkan kekeringan dan rasa gatal. Oleskan pelembap secara teratur dan pertimbangkan untuk mandi dengan tepung jagung untuk mengurangi rasa tidak nyaman. Konsultasikan dengan penyedia layanan kesehatan Anda jika gatal terus berlanjut atau memburuk.
    </li>
    <li>
        <strong>Kram perut:</strong> Kadang-kadang, kram perut dapat menandakan persalinan prematur. Kenali tanda dan gejala yang tidak boleh diabaikan, terutama jika disertai dengan diare. Beri tahu penyedia layanan kesehatan Anda segera jika Anda mengalami gejala ini.
    </li>
</ul>""",
    "gejala_umum_en": """<h2>33 Weeks Pregnant: Your Symptoms</h2>
<ul>
    <li>
        <strong>Frequent urination:</strong> Your baby's descent can put pressure on your bladder, causing more frequent urination, sometimes even during activities like laughing or sneezing. While you can't avoid this symptom, wearing a panty liner may help manage bladder leakage. Stay hydrated, but consider using the bathroom before leaving the house or attending meetings.
    </li>
    <li>
        <strong>Braxton Hicks contractions:</strong> As your due date approaches, these practice contractions may intensify. Differentiate them from true labor contractions by timing them; genuine contractions last up to 90 seconds and occur at regular intervals. Braxton Hicks contractions usually happen in the evening or after physical activities and ease with movement.
    </li>
    <li>
        <strong>Leg swelling:</strong> Pressure from your growing uterus can cause swollen legs or feet. Avoid prolonged standing, elevate your feet when possible, and consider wearing supportive socks or stockings.
    </li>
    <li>
        <strong>Carpal tunnel syndrome:</strong> Swelling can compress nerves in your wrists and hands, leading to discomfort like numbness or tingling. This typically resolves after birth, but wrist braces may provide relief. Consult your healthcare provider for further guidance.
    </li>
    <li>
        <strong>Itchy skin:</strong> Skin stretching can cause dryness and itchiness. Apply moisturizer regularly and consider bathing with cornstarch for relief. Consult your healthcare provider if itching persists or worsens.
    </li>
    <li>
        <strong>Abdominal cramping:</strong> Occasionally, abdominal cramps may signal preterm labor. Familiarize yourself with signs and symptoms not to ignore, especially if accompanied by diarrhea. Inform your healthcare provider immediately if you experience these symptoms.
    </li>
</ul>""",
    "tips_mingguan_id": """<h2>33 Minggu Hamil: Hal yang Perlu Dipertimbangkan</h2>
<ul>
    <li>
        <strong>Menjelajahi posisi persalinan:</strong> Saat tanggal kelahiran semakin dekat, telusuri berbagai posisi yang mungkin membantu dalam persalinan yang lebih nyaman. Pilihan termasuk kursi persalinan, bangku, bola, atau persalinan di dalam kolam atau bak air. Diskusikan dengan penyedia layanan kesehatan Anda dan tanyakan tentang opsi yang tersedia di rumah sakit atau pusat persalinan Anda.
    </li>
    <li>
        <strong>Atur penitipan anak untuk anak-anak yang lebih besar:</strong> Rencanakan siapa yang akan merawat anak-anak Anda yang lebih besar selama persalinan dan masa tinggal di rumah sakit. Pertimbangkan untuk meminta anggota keluarga berjaga-jaga atau menyewa pengasuh yang dapat tersedia dengan cepat.
    </li>
    <li>
        <strong>Pastikan Anda memiliki kursi keselamatan mobil yang disetujui:</strong> Jika Anda bepergian dengan mobil, pastikan Anda memiliki kursi mobil menghadap ke belakang yang terpasang dengan benar di kursi belakang untuk kedatangan bayi Anda. Mintalah bantuan dari departemen pemadam kebakaran setempat atau kunjungi situs web Administrasi Keselamatan Lalu Lintas Jalan Raya Nasional untuk panduan tentang cara membeli, memasang, dan menggunakan kursi bayi.
    </li>
    <li>
        <strong>Siapkan tas rumah sakit Anda:</strong> Pastikan Anda membawa semua perlengkapan penting untuk diri Anda, pasangan Anda, dan bayi Anda selama masa tinggal di rumah sakit. Unduh daftar perlengkapan tas rumah sakit untuk memastikan Anda memiliki semua yang Anda butuhkan.
    </li>
</ul>""",
    "tips_mingguan_en": """<h2>33 Weeks Pregnant: Things to Consider</h2>
<ul>
    <li>
        <strong>Explore labor and birthing positions:</strong> As your due date nears, research different positions that may aid in a more comfortable delivery. Options include birthing chairs, stools, balls, or water laboring in pools or tubs. Discuss with your healthcare provider and inquire about available options at your hospital or birthing center.
    </li>
    <li>
        <strong>Arrange childcare for older children:</strong> Plan who will care for your older children during your labor and hospital stay. Consider asking a family member to be on standby or hire a babysitter who can be available at short notice.
    </li>
    <li>
        <strong>Ensure you have an approved car safety seat:</strong> If you travel by car, ensure you have a rear-facing car seat installed correctly in the backseat for your baby's arrival. Seek assistance from local fire departments or visit the National Highway Traffic Safety Administration's website for guidance on purchasing, installing, and using an infant seat.
    </li>
    <li>
        <strong>Prepare your hospital bag:</strong> Make sure you pack all essentials for yourself, your birth partner, and your baby for your hospital stay. Download a hospital bag checklist to ensure you have everything you need.
    </li>
</ul>""",
    "bayi_img_path": "week_33.jpg",
    "ukuran_bayi_img_path": "week_33_pineapple.svg"
  },
  {
    "id": "34",
    "minggu_kehamilan": "34",
    "berat_janin": 2400,
    "tinggi_badan_janin": 452,
    "ukuran_bayi_id": "Blewah",
    "ukuran_bayi_en": "Cantaloupe",
    "poin_utama_id": """<h2>Hal-Hal Penting pada Minggu ke-34 Kehamilan</h2>
<ul>
    <li>
        <strong>Bayi Anda sekarang seukuran dengan melon cantaloupe:</strong> Pada usia 34 minggu, buah hati Anda terus tumbuh!
    </li>
    <li>
        <strong>Mulai melakukan perhitungan tendangan:</strong> Pantau gerakan bayi Anda dengan melakukan perhitungan tendangan, yang dapat membantu Anda memantau kesejahteraannya.
    </li>
    <li>
        <strong>Perhatikan tekanan di area panggul Anda:</strong> Bayi Anda mungkin mulai turun ke bawah dalam persiapan untuk kelahiran, menyebabkan beberapa tekanan di daerah panggul Anda.
    </li>
    <li>
        <strong>Pelajari tentang kontraksi Braxton Hicks:</strong> Pahami perbedaan antara kontraksi Braxton Hicks dan kontraksi nyata untuk lebih mempersiapkan diri menghadapi kelahiran yang akan datang.
    </li>
    <li>
        <strong>Siapkan untuk ke rumah sakit:</strong> Pertimbangkan untuk menyiapkan tas rumah sakit, mempersiapkan makanan yang dapat dibekukan, dan mendiskusikan kedatangan bayi baru dengan anak-anak Anda yang lain.
    </li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 34 Weeks Pregnant</h2>
<ul>
    <li>
        <strong>Your baby is now the size of a cantaloupe:</strong> At 34 weeks, your little one continues to grow!
    </li>
    <li>
        <strong>Start doing kick counts:</strong> Keep track of your baby's movements by doing kick counts, which can help you monitor their well-being.
    </li>
    <li>
        <strong>Notice any pressure in your pelvic area:</strong> Your baby may be dropping down in preparation for birth, causing some pressure in your pelvic region.
    </li>
    <li>
        <strong>Learn about Braxton Hicks contractions:</strong> Understand the difference between Braxton Hicks contractions and real labor contractions to better prepare for the upcoming birth.
    </li>
    <li>
        <strong>Prepare for the hospital:</strong> Consider packing your hospital bag, preparing meals to freeze, and discussing the arrival of the new baby with your other children.
    </li>
</ul>""",
    "perkembangan_bayi_id": """<h2>Perkembangan Bayi Anda pada Usia Kehamilan 34 Minggu</h2>
<ul>
    <li>
        <strong>Gerakan Bayi:</strong> Pada usia kehamilan 34 minggu, bayi Anda semakin membesar, dan Anda mungkin akan merasakan gerakan mereka terasa berbeda karena ruang di rahim Anda semakin sempit. Meskipun gerakan mereka mungkin terasa kurang kuat, Anda masih akan merasakan goyangan dan rentangan mereka. Pertimbangkan untuk menghitung tendangan untuk memantau aktivitas mereka.
    </li>
    <li>
        <strong>Bayi Menurun:</strong> Bayi Anda mungkin turun lebih rendah dalam persiapan untuk kelahiran sekitar waktu ini. Penyedia layanan kesehatan Anda dapat mengkonfirmasi apakah bayi Anda telah bergerak ke posisi kepala ke bawah.
    </li>
    <li>
        <strong>Penambahan Berat Badan:</strong> Bayi Anda terus menambah berat badan pada usia kehamilan 34 minggu, dengan lebih banyak lemak ditambahkan di bawah kulit mereka.
    </li>
    <li>
        <strong>Warna Mata:</strong> Warna mata pada saat lahir bergantung pada jumlah pigmen melanin yang ada. Bayi dengan sedikit atau tidak ada pigmen cenderung memiliki mata biru pada awalnya, tetapi ini dapat berubah dalam setahun atau dua tahun pertama. Warna mata yang lebih gelap pada saat lahir kemungkinan lebih sedikit berubah.
    </li>
    <li>
        <strong>Persiapan Akhir:</strong> Dengan tanggal kelahiran Anda semakin dekat, sudah waktunya untuk mulai menyelesaikan persiapan untuk kedatangan bayi Anda. Ambil langkah-langkah yang diperlukan untuk memastikan Anda siap menghadapi hari besar tersebut.
    </li>
    <li>
        <strong>Penurunan Testis:</strong> Untuk bayi laki-laki, biasanya testis mereka akan turun ke skrotum pada usia kehamilan 34 minggu. Jika tidak, mereka kemungkinan akan turun dalam enam bulan pertama setelah kelahiran.
    </li>
</ul>""",
    "perkembangan_bayi_en": """<h2>34 Weeks Pregnant: Your Baby’s Development</h2>
<ul>
    <li>
        <strong>Baby’s movements:</strong> At 34 weeks pregnant, your baby is growing bigger, and you may notice their movements feeling different as there's less room in your womb. While their movements may be less forceful, you'll still feel their wiggles and stretches. Consider counting kicks to monitor their activity.
    </li>
    <li>
        <strong>Baby dropping:</strong> Your baby may be dropping lower in preparation for birth around this time. Your healthcare provider can confirm if your baby has moved into a head-down position.
    </li>
    <li>
        <strong>Weight gain:</strong> Your baby continues to gain weight at 34 weeks, with more fat being added under their skin.
    </li>
    <li>
        <strong>Eye color:</strong> Eye color at birth depends on the amount of pigment melanin present. Babies with little or no pigment tend to have blue eyes initially, but this may change over the first year or two. Darker eye colors at birth are less likely to change.
    </li>
    <li>
        <strong>Final preparations:</strong> With your due date approaching, it's time to start finalizing preparations for your baby's arrival. Take necessary steps to ensure you're ready for the big day.
    </li>
    <li>
        <strong>Testicle descent:</strong> For baby boys, their testicles typically descend into the scrotum by 34 weeks. If not, they're likely to drop within the first 6 months after birth.
    </li>
</ul>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda pada Usia Kehamilan 34 Minggu</h2>
<p>
    Pada usia kehamilan 34 minggu dan beberapa minggu ke depannya, penting untuk waspada terhadap tanda-tanda persalinan prematur, yang terjadi ketika persalinan dimulai sebelum usia kehamilan mencapai 37 minggu.
</p>
<p>
    Persalinan prematur dan kelahiran prematur menyebabkan kekhawatiran karena bayi yang lahir terlalu dini mungkin belum sepenuhnya berkembang dan berisiko tinggi mengalami masalah kesehatan serius.
</p>
<p>
    Beberapa tanda persalinan prematur meliputi:
</p>
<ul>
    <li>Kram perut ringan dengan atau tanpa diare</li>
    <li>Penyakit keluaran vagina yang meningkat</li>
    <li>Perubahan dalam cairan vagina, seperti berair, berdarah, atau mengandung lebih banyak lendir</li>
    <li>Sakit pinggang konstan di bagian bawah belakang</li>
    <li>Kontraksi reguler atau sering</li>
    <li>Pecahnya air ketuban, yang bisa berupa aliran besar atau aliran lambat</li>
</ul>
<p>
    Jika Anda hamil 34 minggu dengan bayi kembar, sangat penting untuk tidak mengabaikan tanda dan gejala persalinan prematur ini. Kemungkinan mengalami persalinan dini sekitar 50% lebih tinggi ketika mengandung bayi kembar atau multipel dibandingkan dengan kehamilan satu anak.
</p>
<p>
    Jangan ragu untuk menghubungi penyedia layanan kesehatan Anda jika Anda memiliki pertanyaan atau kekhawatiran. Anda juga dapat mempelajari lebih lanjut tentang kehamilan bayi kembar dalam panduan lengkap minggu demi minggu kami.
</p>""",
    "perubahan_tubuh_en": """<h2>Your Body at 34 Weeks Pregnant</h2>
<p>
    At 34 weeks pregnant and in the weeks ahead, it's important to be vigilant for any signs of preterm labor, which occurs when labor begins before 37 weeks of pregnancy.
</p>
<p>
    Preterm labor and birth raise concerns because babies born prematurely may not be fully developed and are at a higher risk of experiencing serious health issues.
</p>
<p>
    Some indicators of preterm labor include:
</p>
<ul>
    <li>Mild abdominal cramps with or without diarrhea</li>
    <li>Increased vaginal discharge</li>
    <li>Changes in vaginal discharge, such as being watery, bloody, or containing more mucus</li>
    <li>Constant dull backache in the lower back</li>
    <li>Regular or frequent contractions</li>
    <li>Breaking of the water, which could be a significant flow or a slow stream</li>
</ul>
<p>
    If you're 34 weeks pregnant with twins, it's especially crucial not to overlook these signs and symptoms of preterm labor. The likelihood of experiencing early labor is approximately 50% higher when expecting twins or multiples compared to a singleton pregnancy.
</p>
<p>
    Don't hesitate to reach out to your healthcare provider if you have any questions or concerns. You can also learn more about twin pregnancies in our comprehensive week-by-week guide.
</p>""",
    "gejala_umum_id": """<h2>Gejala Anda Saat Hamil 34 Minggu</h2>
<p>
    Pada usia kehamilan 34 minggu, Anda mungkin mengalami beberapa gejala berikut:
</p>
<ul>
    <li><strong>Kontraksi Braxton Hicks:</strong> Kontraksi ini, juga dikenal sebagai kontraksi pra-persalinan atau latihan, bisa menjadi lebih kuat dan lebih sering menjelang tanggal kelahiran Anda. Meskipun biasanya tidak perlu dikhawatirkan jika tidak teratur dan mereda dengan perubahan posisi, hubungi penyedia layanan kesehatan Anda jika Anda mencurigai kontraksi persalinan prematur.</li>
    <li><strong>Payudara membesar:</strong> Payudara Anda mungkin terasa lebih penuh dan elastis, yang dapat menyebabkan ketidaknyamanan dan gatal. Menggunakan lotion pelembap dan mengenakan bra yang pas dapat memberikan bantuan.</li>
    <li><strong>Nyeri panggul:</strong> Ketidaknyamanan panggul bawah, sakit punggung, atau tekanan pada kandung kemih dapat terjadi jika bayi Anda telah turun lebih rendah ke panggul Anda dalam persiapan untuk melahirkan. Beristirahat dan mandi air hangat dapat membantu mengurangi gejala ini.</li>
    <li><strong>Kaki dan pergelangan kaki bengkak:</strong> Pembengkakan di pergelangan kaki dan kaki umum terjadi pada tahap ini. Mengangkat kaki, mengenakan sepatu yang mendukung, dan mengurangi waktu berdiri dapat membantu mengurangi ketidaknyamanan.</li>
    <li><strong>Konstipasi:</strong> Gerakan usus yang sulit dan jarang bisa menyebabkan ketidaknyamanan. Minum banyak air, makan makanan tinggi serat, dan berolahraga ringan dapat membantu pencernaan dan meredakan konstipasi.</li>
</ul>""",
    "gejala_umum_en": """<h2>34 Weeks Pregnant: Your Symptoms</h2>
<p>
    At 34 weeks pregnant, you might be experiencing the following symptoms:
</p>
<ul>
    <li><strong>Braxton Hicks contractions:</strong> These contractions, also known as pre-labor or practice contractions, can become stronger and more frequent as you approach your due date. While usually nothing to worry about if irregular and easing with position changes, contact your healthcare provider if you suspect preterm labor contractions.</li>
    <li><strong>Enlarged breasts:</strong> Your breasts may feel fuller and stretchier, potentially causing discomfort and itchiness. Using moisturizing lotion and wearing a properly fitting bra can provide relief.</li>
    <li><strong>Pelvic pain:</strong> Lower pelvic discomfort, backache, or bladder pressure may occur if your baby has descended lower into your pelvis in preparation for birth. Resting and warm baths can help alleviate these symptoms.</li>
    <li><strong>Swollen ankles and feet:</strong> Swelling in the ankles and feet is common at this stage. Elevating your legs, wearing supportive shoes, and reducing standing time can help ease the discomfort.</li>
    <li><strong>Constipation:</strong> Hard-to-pass and infrequent bowel movements can be uncomfortable. Drinking plenty of water, eating high-fiber foods, and engaging in gentle exercises can aid digestion and relieve constipation.</li>
</ul>""",
    "tips_mingguan_id": """<h2>34 Minggu Hamil: Hal yang Perlu Dipertimbangkan</h2>
<ul>
    <li><strong>Menyiapkan Kakak-Kakak Tua:</strong> Menyesuaikan diri dengan kehadiran bayi baru bisa menantang bagi kakak-kakak yang lebih tua. Orang tua dapat memudahkan transisi dengan melibatkan mereka dalam persiapan, menghabiskan waktu berkualitas bersama, dan meyakinkan mereka akan nilai mereka dalam keluarga.</li>
    <li><strong>Keberhasilan Kalsium:</strong> Kalsium sangat penting untuk perkembangan tulang dan gigi bayi Anda. Meskipun vitamin prenatal mungkin mengandung kalsium, penting untuk mengonsumsi makanan yang kaya kalsium seperti produk susu, sayuran berdaun hijau, dan jus yang diperkaya kalsium. Konsultasikan dengan penyedia layanan kesehatan Anda untuk memastikan Anda memenuhi kebutuhan kalsium Anda.</li>
    <li><strong>Daftar Periksa Tas Rumah Sakit:</strong> Pastikan Anda siap untuk persalinan dengan mempersiapkan tas rumah sakit Anda sebelumnya. Daftar periksa yang komprehensif dapat membantu Anda mengingat barang-barang penting untuk Anda, pasangan, dan bayi baru lahir Anda.</li>
    <li><strong>Menyiapkan Persediaan Makanan:</strong> Pertimbangkan untuk menyimpan persediaan makanan di dapur dan mempersiapkan makanan yang akan dibekukan untuk kenyamanan pasca persalinan. Pengiriman barang dagangan online atau bantuan dari teman dan keluarga juga dapat meringankan beban Anda setelah kedatangan bayi.</li>
    <li><strong>Tindakan Kenyamanan Selama Persalinan:</strong> Rencanakan tindakan kenyamanan selama persalinan, seperti bantuan nyeri medis atau teknik non-medis seperti pijat atau latihan pernapasan. Diskusikan opsi dengan penyedia layanan kesehatan Anda untuk menentukan yang terbaik untuk Anda.</li>
</ul>""",
    "tips_mingguan_en": """<h2>34 Weeks Pregnant: Things to Consider</h2>
<ul>
    <li><strong>Preparing Older Siblings:</strong> Adjusting to a new baby can be challenging for older siblings. Parents can ease the transition by involving them in preparations, spending quality time together, and reassuring them of their value in the family.</li>
    <li><strong>Importance of Calcium:</strong> Calcium is crucial for your baby's bone and teeth development. While prenatal vitamins may contain calcium, it's essential to consume calcium-rich foods like dairy, leafy greens, and calcium-fortified juices. Consult your healthcare provider to ensure you're meeting your calcium needs.</li>
    <li><strong>Hospital Bag Checklist:</strong> Ensure you're prepared for labor by packing your hospital bag in advance. A comprehensive checklist can help you remember essential items for you, your partner, and your newborn.</li>
    <li><strong>Stocking Up Pantry:</strong> Consider stocking your pantry and preparing meals to freeze for postpartum convenience. Online grocery deliveries or assistance from friends and family can also lighten your load after the baby's arrival.</li>
    <li><strong>Comfort Measures During Labor:</strong> Plan comfort measures for labor, such as medical pain relief or non-medical techniques like massage or breathing exercises. Discuss options with your healthcare provider to determine what's best for you.</li>
</ul>""",
    "bayi_img_path": "week_34.jpg",
    "ukuran_bayi_img_path": "week_34_cantalope.svg"
  },
  {
    "id": "35",
    "minggu_kehamilan": "35",
    "berat_janin": 2600,
    "tinggi_badan_janin": 463,
    "ukuran_bayi_id": "Melon Madu",
    "ukuran_bayi_en": "Honeydew Melon",
    "poin_utama_id": """<h2>Highlights pada Usia Kehamilan 35 Minggu</h2>
<ul>
    <li>Bayi Anda sekarang memiliki ukuran sekitar sebesar melon madu.</li>
    <li>Peningkatan berat badan terus berlanjut saat bayi Anda bersiap untuk kelahiran pada usia yang tepat. Lapisan lemak yang berkembang akan membantu mengatur suhu tubuh mereka setelah lahir.</li>
    <li>Jika Anda merasa tekanan tambahan di bagian bawah tubuh Anda pada usia kehamilan 35 minggu, hal itu mungkin menandakan bahwa bayi Anda mulai turun lebih dalam ke dalam panggul Anda.</li>
    <li>Pertimbangkan untuk menjelajahi opsi bantuan nyeri untuk persalinan dan bereksperimen dengan posisi berbeda untuk persalinan dan kelahiran.</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 35 Weeks Pregnant</h2>
<ul>
    <li>Your baby is now approximately the size of a honeydew melon.</li>
    <li>Weight gain continues as your baby prepares for full-term birth. The layer of fat developing will help regulate their body temperature after birth.</li>
    <li>If you're feeling increased pressure in your lower body, it may indicate your baby is descending deeper into your pelvis.</li>
    <li>Consider exploring pain relief options for labor and experimenting with different positions for labor and childbirth.</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>Kehamilan 35 Minggu: Perkembangan Bayi Anda</h2>
<ul>
    <li>Saat Anda semakin dekat dengan tanggal kelahiran, lengan dan kaki bayi Anda menjadi lebih gemuk, dan kulit mereka menjadi lebih halus dan berwarna merah muda.</li>
    <li>Verniks, yang melindungi kulit bayi Anda dari cairan ketuban, terus menjadi lebih tebal, sementara rambut halus yang disebut lanugo hampir hilang pada saat ini.</li>
    <li>Paru-paru bayi Anda masih terus berkembang dan memproduksi surfaktan, suatu zat yang penting untuk fungsi paru-paru yang baik.</li>
    <li>Otak dan sistem saraf bayi Anda terus berkembang, dengan otak memiliki berat sekitar dua pertiga dari berat bayi saat mencapai usia kehamilan 39 atau 40 minggu, di mana mereka dianggap cukup bulan.</li>
    <li>Pada usia kehamilan 35 minggu atau dalam beberapa minggu ke depan, bayi Anda mungkin berpindah ke posisi kepala ke bawah sebagai persiapan untuk lahir.</li>
    <li>Jika Anda hamil 35 minggu dengan bayi kembar atau bayi lainnya, penting untuk mengetahui tanda dan gejala persalinan prematur, karena risikonya lebih tinggi dibandingkan dengan kehamilan tunggal.</li>
    <li>Tanda-tanda persalinan prematur yang perlu diwaspadai termasuk kram, sakit pinggang, diare, dan peningkatan keluarnya cairan vagina. Segera hubungi penyedia layanan kesehatan Anda jika Anda memperhatikan salah satu tanda tersebut.</li>
</ul>""",
    "perkembangan_bayi_en": """<h2>35 Weeks Pregnant: Your Baby’s Development</h2>
<ul>
    <li>As you approach your due date, your baby's arms and legs are becoming chunkier, and their skin is becoming smoother and pinker in color.</li>
    <li>Vernix, which protects your baby's skin from the amniotic fluid, continues to thicken, while the fine hair known as lanugo is nearly gone by now.</li>
    <li>Your baby's lungs are still developing and producing surfactant, a substance essential for proper lung function.</li>
    <li>The brain and nervous system are continuing to mature, with the brain weighing about two-thirds of its full-term weight by 35 weeks.</li>
    <li>By 35 weeks, your baby may have shifted into a head-down position in preparation for birth.</li>
    <li>If you're expecting twins or multiples, it's important to be aware of the signs of preterm labor, as the risk is higher compared to a single pregnancy.</li>
    <li>Signs of preterm labor to watch for include cramps, backaches, diarrhea, and increased vaginal discharge. Contact your healthcare provider immediately if you notice any of these signs.</li>
</ul>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda pada Kehamilan 35 Minggu</h2>
<p>Apakah Anda penasaran berapa lama lagi kehamilan Anda akan mencapai usia kehamilan penuh? Pada usia kehamilan 35 minggu, Anda memiliki sekitar 4 atau 5 minggu lagi hingga kehamilan dianggap penuh, yang umumnya dihitung dari awal minggu ke-39 hingga akhir minggu ke-40. Hari besar semakin dekat!</p>
<p>Saat tanggal kelahiran Anda semakin dekat, Anda mungkin memikirkan kemungkinan membutuhkan persalinan caesar, di mana bayi dilahirkan melalui sayatan di perut ibu.</p>
<p>Meskipun kebanyakan bayi lahir melalui jalan lahir, persalinan caesar tidak jarang terjadi. Ada beberapa kondisi di mana persalinan caesar dapat dianggap sebagai pilihan yang lebih aman untuk Anda atau bayi Anda. Misalnya, jika persalinan melambat atau berhenti, jika ada kekhawatiran tentang detak jantung bayi, atau jika tali pusat terjepit, persalinan caesar mungkin direkomendasikan.</p>
<p>Penyedia layanan kesehatan Anda mungkin menyarankan persalinan caesar yang dijadwalkan jika bayi Anda berada dalam posisi sungsang, jika Anda memiliki plasenta previa, jika bayi Anda terlalu besar untuk melewati panggul, atau jika Anda pernah melakukan persalinan caesar sebelumnya.</p>
<p>Selama kunjungan Anda sekitar 35 minggu, Anda dapat membahas dengan penyedia layanan kesehatan Anda tentang kemungkinan membutuhkan operasi caesar dan apa yang bisa diharapkan jika memang diperlukan.</p>""",
    "perubahan_tubuh_en": """<h2>Your Body at 35 Weeks Pregnant</h2>
<p>Are you curious about how much longer you have until your pregnancy reaches full term? At 35 weeks, you're about 4 or 5 weeks away from that milestone, typically considered from the beginning of the 39th week to the end of the 40th week. The big day is getting closer!</p>
<p>As your due date approaches, you might be thinking about the possibility of needing a cesarean delivery, where the baby is delivered through incisions in the mother’s abdomen.</p>
<p>Although most babies are born vaginally, cesarean deliveries are not uncommon. Certain conditions may make a cesarean delivery a safer option for either you or your baby. For instance, if labor slows down or stops, if there are concerns about the baby's heart rate, or if the umbilical cord is compressed, a cesarean delivery may be recommended.</p>
<p>Your healthcare provider may suggest a scheduled cesarean delivery if your baby is in a breech position, if you have placenta previa, if your baby is too large to pass through the pelvis, or if you've had a previous cesarean section.</p>
<p>During your appointment around 35 weeks, you can discuss with your healthcare provider the likelihood of needing a cesarean section and what to expect if one is necessary.</p>""",
    "gejala_umum_id": """<h2>Kehamilan 35 Minggu: Gejala yang Mungkin Dialami</h2>
<p>Pada usia kehamilan 35 minggu, Anda mungkin mengalami gejala berikut:</p>
<ul>
  <li><strong>Sering Buang Air Kecil:</strong> Ketika bayi Anda turun lebih rendah ke panggul Anda untuk persiapan melahirkan, Anda mungkin mengalami kebocoran saat tertawa, batuk, bersin, atau membungkuk karena tekanan pada kandung kemih. Perbanyak ke toilet dan lakukan latihan Kegel dapat membantu mengatasi ini.</li>
  <li><strong>Sulit Tidur:</strong> Susah tidur umum terjadi pada minggu-minggu terakhir kehamilan. Coba eksperimen dengan bantal untuk dukungan dan tidur dengan posisi miring dengan bantal di antara lutut.</li>
  <li><strong>Pembengkakan dan Nyeri pada Kaki:</strong> Pembengkakan di kaki dan kaki umum terjadi karena peningkatan retensi cairan dan tekanan dari rahim pada pembuluh darah. Hindari berdiri dalam waktu lama, kenakan pakaian longgar dan sepatu yang nyaman, dan angkat kaki Anda saat duduk.</li>
  <li><strong>Kebas pada Tangan dan Kaki:</strong> Pembengkakan dapat menyebabkan tekanan pada saraf, menyebabkan kebas atau kesemutan. Sampaikan hal ini kepada penyedia layanan kesehatan Anda untuk saran. Menggunakan pelindung pergelangan tangan dan istirahat dengan bantuan bantal untuk dukungan dapat membantu meredakan gejala.</li>
  <li><strong>Heartburn:</strong> Perubahan hormon selama kehamilan dapat menyebabkan heartburn. Hindari makanan berlemak atau pedas, buah jeruk, dan cokelat, serta makan dalam porsi kecil dan sering dapat membantu mencegahnya.</li>
</ul>""",
    "gejala_umum_en": """<h2>35 Weeks Pregnant: Your Symptoms</h2>
<p>At 35 weeks pregnant, you might be experiencing the following symptoms:</p>
<ul>
  <li><strong>Frequent urination:</strong> As your baby drops lower into your pelvis in preparation for birth, you may notice leakage when laughing, coughing, sneezing, or bending over due to pressure on your bladder. Going to the bathroom more often and doing Kegel exercises can help manage this.</li>
  <li><strong>Trouble sleeping:</strong> Insomnia is common in the last weeks of pregnancy. Experiment with pillows for support and try sleeping on your side with pillows between your knees.</li>
  <li><strong>Leg swelling and pain:</strong> Swelling in the legs and feet is common due to increased fluid retention and pressure from the uterus on veins. Avoid standing for long periods, wear loose clothing and supportive shoes, and prop up your legs when sitting.</li>
  <li><strong>Numbness in hands and feet:</strong> Swelling can compress nerves, causing numbness or tingling. Mention this to your healthcare provider for advice. Using wrist splints and resting with pillows for support may help alleviate symptoms.</li>
  <li><strong>Heartburn:</strong> Hormonal changes during pregnancy can cause heartburn. Avoiding fried or spicy foods, citrus fruits, and chocolate, and eating smaller, more frequent meals can help prevent it.</li>
</ul>""",
    "tips_mingguan_id": """<h2>Kehamilan 35 Minggu: Hal yang Perlu Dipertimbangkan</h2>
<p>Saat Anda semakin mendekati tanggal kelahiran, berikut adalah beberapa pertimbangan penting yang perlu Anda perhatikan:</p>
<ul>
  <li><strong>Membentuk Ikatan dengan Bayi Anda:</strong> Membangun hubungan yang erat dengan bayi Anda membutuhkan waktu dan kesabaran. Jangan khawatir jika itu tidak terjadi secara instan setelah kelahiran. Ikatan Anda akan tumbuh seiring waktu yang Anda habiskan bersama bayi Anda.</li>
  <li><strong>Jadwal Perawatan Kesehatan:</strong> Pada tahap ini, Anda mungkin memiliki janji temu setiap dua minggu sekali. Penyedia Anda mungkin akan menguji Anda untuk Streptococcus Grup B (GBS) antara 36 dan 38 minggu untuk melindungi bayi Anda selama persalinan.</li>
  <li><strong>Kesadaran Preeklamsia:</strong> Waspadai tanda-tanda preeklamsia, kondisi serius yang ditandai dengan tekanan darah tinggi. Gejalanya termasuk sakit kepala yang persisten, perubahan penglihatan, kesulitan bernapas, atau nyeri di bagian atas perut.</li>
  <li><strong>Persiapan untuk Persalinan Normal:</strong> Mulailah mempertimbangkan posisi persalinan yang berbeda yang mungkin membantu selama persalinan. Diskusikan opsi yang tersedia dengan penyedia layanan kesehatan Anda dan bersikaplah terbuka untuk mencoba posisi baru selama persalinan.</li>
  <li><strong>Perawatan Diri:</strong> Luangkan waktu untuk fokus pada diri sendiri dan melakukan aktivitas yang membawa kebahagiaan dan relaksasi. Baik itu menghabiskan waktu sendirian, pergi kencan dengan pasangan, atau bertemu teman, prioritaskan perawatan diri.</li>
  <li><strong>Memilih Dokter Anak:</strong> Mulailah proses mencari dokter anak untuk bayi Anda jika belum melakukannya. Cari rekomendasi dari penyedia layanan kesehatan Anda dan orang tua lain di komunitas Anda.</li>
</ul>""",
    "tips_mingguan_en": """<h2>35 Weeks Pregnant: Things to Consider</h2>
<p>As you approach your due date, here are some important considerations to keep in mind:</p>
<ul>
  <li><strong>Bonding with Your Baby:</strong> Building a close relationship with your baby takes time and patience. Don't worry if it doesn't happen instantly after birth. Your bond will grow as you spend more time with your little one.</li>
  <li><strong>Healthcare Appointments:</strong> At this stage, you likely have appointments every other week. Your provider may test you for Group B streptococcus (GBS) between 36 and 38 weeks to protect your baby during delivery.</li>
  <li><strong>Preeclampsia Awareness:</strong> Be vigilant for signs of preeclampsia, a serious condition characterized by high blood pressure. Symptoms include persistent headaches, changes in vision, difficulty breathing, or upper abdominal pain.</li>
  <li><strong>Preparing for Vaginal Birth:</strong> Start considering different labor positions that may help during childbirth. Discuss available options with your healthcare provider and keep an open mind about trying new positions during labor.</li>
  <li><strong>Self-Care:</strong> Take some time to focus on yourself and indulge in activities that bring you joy and relaxation. Whether it's spending time alone, going on a date with your partner, or meeting friends, prioritize self-care.</li>
  <li><strong>Choosing a Pediatrician:</strong> Begin the process of finding a pediatrician for your baby if you haven't already. Seek recommendations from your healthcare provider and other parents in your community.</li>
</ul>""",
    "bayi_img_path": "week_35.jpg",
    "ukuran_bayi_img_path": "week_35_honeydew.svg"
  },
  {
    "id": "36",
    "minggu_kehamilan": "36",
    "berat_janin": 2800,
    "tinggi_badan_janin": 473,
    "ukuran_bayi_id": "Kepala Selada Romaine",
    "ukuran_bayi_en": "Head of Romaine Lettuce",
    "poin_utama_id": """<h2>Info Penting pada Kehamilan 36 Minggu</h2>
<p>Berikut adalah beberapa poin penting yang perlu diperhatikan pada kehamilan 36 minggu:</p>
<ul>
  <li>Bayi Anda sekarang sekitar seukuran kepala selada romaine.</li>
  <li>Mereka terus menambah lemak pada tahap ini, meskipun pertumbuhan mereka dalam hal panjang kemungkinan sudah selesai.</li>
  <li>Pada usia kehamilan 36 minggu, Anda mungkin merasakan bayi Anda bergerak lebih rendah ke dalam panggul Anda, yang dapat memberikan sedikit kelegaan dari tekanan pada paru-paru dan diafragma, suatu proses yang kadang disebut "pencahayaan."</li>
  <li>Anda mungkin merasakan ketidaknyamanan akibat ukuran perut Anda, tetapi menggunakan bantal ekstra di malam hari atau melakukan latihan ringan dapat membantu menguranginya.</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 36 Weeks Pregnant</h2>
<p>Here are some key points to note about being 36 weeks pregnant:</p>
<ul>
  <li>Your baby is now about the size of a head of romaine lettuce.</li>
  <li>They continue to gain fat at this stage, although their growth in length is likely complete.</li>
  <li>Around 36 weeks, you may feel your baby moving lower into your pelvis, which can provide some relief from pressure on your lungs and diaphragm, a process sometimes referred to as "lightening."</li>
  <li>You might experience discomfort due to the size of your belly, but using extra pillows at night or engaging in gentle exercise can help alleviate it.</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>36 Minggu Hamil: Perkembangan Bayi Anda</h2>
<p>Berikut adalah perkembangan bayi Anda pada usia kehamilan 36 minggu:</p>
<ul>
  <li>Pada sekitar 36 minggu, bayi Anda sedang bertambah berat badan, menjadi lebih halus, dan mulai menyerupai bayi yang akan Anda temui dalam beberapa minggu ke depan.</li>
  <li>Karena pertumbuhannya, bayi Anda memiliki lebih sedikit ruang untuk bergerak di dalam kantung ketuban pada tahap ini, tetapi Anda masih akan merasakan gerakan mereka sesekali.</li>
  <li>Tertarik bagaimana bayi Anda akan melewati jalan lahir saat Anda masuk ke dalam persalinan? Pada titik ini, tulang tengkorak mereka telah terbentuk tetapi belum menyatu bersama. Hal ini memungkinkan tulang-tulang tersebut dapat bergerak dan tumpang tindih, memungkinkan kepala dan tubuh untuk melewati leher rahim dan panggul Anda dengan sedikit lebih mudah.</li>
  <li>Oleh karena itu, jika Anda melahirkan secara normal, kepala bayi Anda mungkin terlihat sedikit tidak beraturan saat lahir tetapi akan kembali menjadi bentuk yang lebih normal dalam beberapa jam atau beberapa hari karena tulang tengkorak secara bertahap menyatu selama dua tahun pertama kehidupan.</li>
</ul>""",
    "perkembangan_bayi_en": """<h2>36 Weeks Pregnant: Your Baby’s Development</h2>
<p>Here's what's happening with your baby's development at 36 weeks pregnant:</p>
<ul>
  <li>Around 36 weeks, your baby is gaining weight, becoming less wrinkled, and starting to resemble the newborn you'll soon meet.</li>
  <li>Due to their growth, your baby has less space to move inside the amniotic sac by this stage, but you'll still feel their movements occasionally.</li>
  <li>Wondering how your baby will navigate the birth canal during labor? Their skull bones have formed but are not yet fused together, allowing for easier passage through your cervix and pelvis.</li>
  <li>As a result, if you deliver vaginally, your baby's head may appear slightly misshapen at birth but will normalize within hours or days as the skull bones fuse gradually over the first two years of life.</li>
</ul>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda pada Minggu ke-36 Kehamilan</h2>
<p>Dari sekarang hingga Anda melahirkan, Anda mungkin akan menjalani pemeriksaan mingguan dengan penyedia layanan kesehatan Anda. Selama kunjungan kehamilan 36 minggu dan minggu-minggu berikutnya, Anda dapat mengharapkan berat badan, tekanan darah, dan tinggi fundus diperiksa. Penyedia Anda mungkin juga memeriksa leher rahim Anda untuk melihat apakah itu sedang mempersiapkan diri untuk persalinan.</p>
<p>Penyedia kesehatan Anda juga akan memeriksa Anda untuk mengetahui apakah bayi Anda telah bergerak ke posisi kepala ke bawah dalam persiapan untuk kelahiran. Jika bayi Anda berada dalam posisi sungsang, di mana bokong atau kaki mereka posisinya keluar terlebih dahulu, penyedia akan memberi tahu Anda apakah mencoba untuk memutar bayi Anda direkomendasikan.</p>
<p>Anda mungkin merasakan peningkatan tekanan di daerah panggul dan kandung kemih sekitar 36 minggu saat bayi Anda menetap lebih rendah di panggul Anda. Meskipun ini mungkin menyebabkan ketidaknyamanan, itu juga mengurangi tekanan pada diafragma dan paru-paru Anda, sering disebut sebagai "pencahayaan," memungkinkan Anda untuk sedikit bernapas lebih lega.</p>""",
    "perubahan_tubuh_en": """<h2>Your Body at 36 Weeks Pregnant</h2>
<p>From now until delivery, you'll likely have weekly checkups with your healthcare provider. At 36 weeks pregnant and beyond, these checkups typically include monitoring your weight, blood pressure, and fundal height. Your provider may also check your cervix to assess if it's getting ready for labor.</p>
<p>During these appointments, your healthcare provider will also determine if your baby has moved into a head-down position in preparation for birth. If your baby is in a breech position, where their bottom or feet are positioned to come out first, your provider will advise you on whether attempting to turn the baby is recommended.</p>
<p>You might feel increased pressure in your pelvic area and bladder around 36 weeks as your baby settles lower in your pelvis. While this may cause discomfort, it also relieves some pressure on your diaphragm and lungs, often referred to as "lightening," allowing you to breathe a bit easier.</p>""",
    "gejala_umum_id": """<h2>Minggu ke-36 Kehamilan: Gejala yang Mungkin Anda Alami</h2>
<ul>
    <li><strong>Sering buang air kecil:</strong> Saat bayi turun lebih rendah ke dalam panggul Anda, Anda mungkin merasa perlu buang air kecil lebih sering sekitar 36 minggu kehamilan. Hal ini mungkin mengganggu tidur Anda, tetapi tetap penting untuk tetap terhidrasi meskipun merepotkan. Latihan Kegel dapat membantu meningkatkan kontrol kandung kemih.</li>
    <li><strong>Kontraksi Braxton Hicks:</strong> Kontraksi latihan ini mungkin menjadi lebih kuat saat Anda mendekati tanggal kelahiran. Membedakan mereka dari kontraksi persalinan sejati melibatkan pengamatan terhadap waktu dan intensitasnya. Interval teratur dan peningkatan frekuensi menunjukkan persalinan, sedangkan kontraksi Braxton Hicks tidak teratur dan sering dapat mereda dengan gerakan.</li>
    <li><strong>Kesulitan tidur:</strong> Perut yang lebih besar dapat membuat mencari posisi tidur yang nyaman menjadi sulit. Menggunakan bantal ekstra untuk dukungan dan menciptakan lingkungan tidur yang nyaman mungkin membantu. Jika insomnia berlanjut, pertimbangkan teknik relaksasi atau tidur siang untuk istirahat tambahan.</li>
    <li><strong>Kebas di kaki dan kaki:</strong> Tekanan yang meningkat pada saraf akibat tubuh yang semakin besar dapat menyebabkan kebasan atau sensasi kesemutan sesekali. Gejala ini biasanya hilang setelah persalinan tetapi diskusikan setiap kekhawatiran dengan penyedia layanan kesehatan Anda.</li>
    <li><strong>Pembengkakan kaki:</strong> Penahanan cairan selama kehamilan dapat menyebabkan pembengkakan di kaki dan kaki Anda. Kurangi ketidaknyamanan dengan membatasi waktu berdiri, mengangkat kaki Anda saat duduk, dan memakai sepatu yang nyaman atau kaus kaki penyangga.</li>
    <li><strong>Sakit punggung bawah:</strong> Perubahan hormon melonggarkan sendi dan ligamen dalam persiapan persalinan, menyebabkan sakit punggung bawah. Latihan peregangan lembut yang direkomendasikan oleh penyedia layanan kesehatan Anda mungkin memberikan bantuan.</li>
</ul>""",
    "gejala_umum_en": """<h2>36 Weeks Pregnant: Your Symptoms</h2>
<ul>
    <li><strong>Frequent urination:</strong> As your baby drops lower into your pelvis, you’ll likely find yourself needing to urinate more often around 36 weeks of pregnancy. This might disrupt your sleep, but staying hydrated is important despite the inconvenience. Kegel exercises can help improve bladder control.</li>
    <li><strong>Braxton Hicks contractions:</strong> These practice contractions may become stronger as you approach your due date. Differentiating them from true labor contractions involves observing their timing and intensity. Regular intervals and increasing frequency suggest labor, whereas Braxton Hicks contractions are irregular and can often be relieved by movement.</li>
    <li><strong>Difficulty sleeping:</strong> A larger belly can make finding a comfortable sleeping position challenging. Using extra pillows for support and creating a comfortable sleeping environment may help. If insomnia persists, consider relaxation techniques or daytime naps for added rest.</li>
    <li><strong>Numbness in legs and feet:</strong> Increased pressure on nerves due to your growing body can cause occasional numbness or tingling sensations. These symptoms typically resolve after childbirth but discuss any concerns with your healthcare provider.</li>
    <li><strong>Leg swelling:</strong> Fluid retention during pregnancy may lead to swelling in your legs and feet. Minimize discomfort by limiting time spent standing, elevating your legs when seated, and wearing comfortable shoes or support hose.</li>
    <li><strong>Lower back pain:</strong> Hormonal changes loosen joints and ligaments in preparation for labor, resulting in lower back pain. Gentle stretching exercises recommended by your healthcare provider may offer relief.</li>
</ul>""",
    "tips_mingguan_id": """<h2>Minggu ke-36 Kehamilan: Hal yang Perlu Dipertimbangkan</h2>
<ul>
    <li><strong>Buat rencana persalinan:</strong> Pertimbangkan untuk menulis rencana persalinan dan diskusikan dengan penyedia layanan kesehatan Anda. Pastikan untuk membawa salinan dalam tas rumah sakit Anda. Rencana persalinan dapat membantu mengingatkan penyedia tentang preferensi Anda, seperti manajemen nyeri dan siapa yang Anda inginkan di ruang persalinan. Ingatlah, persalinan bisa tidak terduga, dan Anda mungkin berubah pikiran saat dalam persalinan. Membuat rencana membantu Anda mempertimbangkan pilihan Anda.</li>
    <li><strong>Cukupi kebutuhan vitamin C:</strong> Pastikan Anda mendapatkan setidaknya 85 miligram vitamin C setiap hari untuk mendukung sistem kekebalan tubuh, tulang, dan otot. Sumber yang baik termasuk buah jeruk, stroberi, brokoli, dan tomat. Satu jeruk sedang mengandung sekitar 70 miligram, dan satu cangkir jus jeruk mengandung lebih dari 90 miligram. Periksa dengan penyedia layanan kesehatan Anda jika Anda mendapatkan cukup dari vitamin prenatal Anda.</li>
    <li><strong>Olahraga ringan:</strong> Olahraga ringan dapat membuat Anda merasa lebih nyaman selama minggu-minggu terakhir kehamilan. Berjalan dan peregangan lembut dapat mengurangi tekanan punggung. Cobalah membungkuk dengan menempatkan tangan Anda di pinggul dan membungkuk ke belakang tidak lebih dari 20 derajat.</li>
    <li><strong>Insting bersarang:</strong> Gunakan energi bersarang untuk menyiapkan rumah Anda untuk bayi. Selesaikan proyek-proyek terakhir, dekorasi kamar bayi, atau berbelanja perlengkapan bayi. Hindari kelelahan dan mintalah bantuan jika diperlukan.</li>
    <li><strong>Hitung gerakan bayi:</strong> Hitung gerakan bayi setiap hari. Hitung setidaknya 10 gerakan dalam periode 2 jam, seringkali setelah makan. Jika Anda tidak merasakan 10 gerakan, coba lagi nanti atau periksa dengan penyedia layanan kesehatan Anda untuk mendapatkan kepastian.</li>
    <li><strong>Posisi bayi:</strong> Penyedia layanan kesehatan Anda akan memeriksa posisi bayi Anda. Jika bayi Anda tampaknya dalam posisi sungsang, penyedia mungkin menyarankan ultrasonografi untuk mengonfirmasi. Masih ada beberapa minggu bagi bayi Anda untuk mengubah posisi, tetapi penyedia Anda akan memantau ini dengan cermat.</li>
</ul>""",
    "tips_mingguan_en": """<h2>36 Weeks Pregnant: Things to Consider</h2>
<ul>
    <li><strong>Create a birth plan:</strong> Consider writing a birth plan to discuss with your healthcare provider. Make sure to pack copies in your hospital bag. A birth plan can help remind your providers about your preferences, like pain management and who you want in the delivery room. Remember, labor can be unpredictable, and you might change your mind once you're in labor. Creating a plan helps you think through your options.</li>
    <li><strong>Get enough vitamin C:</strong> Ensure you're getting at least 85 milligrams of vitamin C daily to support your immune system, bones, and muscles. Good sources include citrus fruits, strawberries, broccoli, and tomatoes. One medium orange has about 70 milligrams, and a cup of orange juice has over 90 milligrams. Check with your healthcare provider if you're getting enough from your prenatal vitamins.</li>
    <li><strong>Gentle exercise:</strong> Light exercise can help you feel more comfortable during the last weeks of pregnancy. Walking and gentle stretching can relieve back pressure. Try standing backbends by placing your hands on your hips and bending backward no more than 20 degrees.</li>
    <li><strong>Nesting instincts:</strong> Use any nesting energy to prepare your home for the baby. Finish last-minute projects, decorate the nursery, or shop for baby items. Avoid overexerting yourself and ask for help when needed.</li>
    <li><strong>Track baby movements:</strong> Track your baby's movements daily. Count at least 10 movements in a 2-hour period, often after a meal. If you don't feel 10 movements, try again later or check with your healthcare provider for reassurance.</li>
    <li><strong>Baby's position:</strong> Your healthcare provider will check your baby's position. If your baby seems to be in the breech position, your provider may suggest an ultrasound to confirm. There are still a few weeks for your baby to change positions, but your provider will monitor this closely.</li>
</ul>""",
    "bayi_img_path": "week_36.jpg",
    "ukuran_bayi_img_path": "week_36_roman_lettuce.svg"
  },
  {
    "id": "37",
    "minggu_kehamilan": "37",
    "berat_janin": 3000,
    "tinggi_badan_janin": 480,
    "ukuran_bayi_id": "Seikat Swiss Chard",
    "ukuran_bayi_en": "Bunch of Swiss Chard",
    "poin_utama_id": """<h2>Perkembangan di Minggu ke-37 Kehamilan</h2>
<ul>
    <li><strong>Menambah lemak:</strong> Bayi Anda menambah lemak untuk menjaga kehangatan setelah lahir.</li>
    <li><strong>Posisi kepala di bawah:</strong> Mungkin sudah dalam posisi kepala di bawah, siap untuk lahir.</li>
    <li><strong>Perubahan serviks:</strong> Serviks Anda mungkin mulai melebar, dan Anda bisa kehilangan sumbat lendir, tanda bahwa persalinan semakin dekat.</li>
    <li><strong>Kontraksi:</strong> Pelajari tentang kontraksi agar siap saat mereka mulai. Juga, cari tahu tentang posisi persalinan dan cara untuk merasa nyaman.</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 37 Weeks Pregnant</h2>
<ul>
    <li><strong>Gaining fat:</strong> Your baby is gaining fat to stay warm after birth.</li>
    <li><strong>Head-down position:</strong> They might be in a head-down position, ready for delivery.</li>
    <li><strong>Cervix changes:</strong> Your cervix may start to dilate, and you might lose your mucus plug, signaling labor is close.</li>
    <li><strong>Contractions:</strong> Learn about contractions so you're prepared when they start. Also, look into labor positions and comfort measures.</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>Minggu ke-37 Kehamilan: Perkembangan Bayi Anda</h2>
<p>Kehamilan Anda hampir berakhir, tetapi bayi Anda masih tumbuh dan berkembang. Inilah yang terjadi:</p>
<ul>
    <li><strong>Peningkatan berat harian:</strong> Minggu ini, bayi Anda menambah berat sekitar setengah ons setiap hari, menambah lemak dan semakin gemuk sebelum lahir.</li>
    <li><strong>Tahap awal:</strong> Meskipun Anda sangat dekat dengan tanggal jatuh tempo pada minggu ke-37, kehamilan Anda masih dianggap sebagai "awal masa" dan belum dianggap "masa penuh" sampai minggu ke-39.</li>
    <li><strong>Perkembangan berlanjut:</strong> Paru-paru, otak, dan sistem saraf bayi Anda masih berkembang. Otak mereka akan terus tumbuh sampai usia 2 tahun.</li>
    <li><strong>Pelepasan lanugo:</strong> Bayi Anda telah melepaskan sebagian besar rambut halus yang disebut lanugo yang menutupi tubuh mereka.</li>
    <li><strong>Gerakan menggenggam:</strong> Bayi Anda sekarang bisa melakukan gerakan menggenggam dengan jari-jari mereka dan mungkin merespons cahaya terang dengan bergerak atau berbalik menuju cahaya.</li>
    <li><strong>Posisi kepala di bawah:</strong> Jika belum, bayi Anda mungkin sedang bergeser ke posisi kepala di bawah sebagai persiapan untuk persalinan.</li>
</ul>""",
    "perkembangan_bayi_en": """<h2>37 Weeks Pregnant: Your Baby’s Development</h2>
<p>Your pregnancy is nearly at its end, but your baby is still growing and developing. Here's what’s happening:</p>
<ul>
    <li><strong>Daily weight gain:</strong> This week, your baby is gaining about half an ounce each day, adding fat and plumping up before birth.</li>
    <li><strong>Early term stage:</strong> Even though you’re very close to your due date at 37 weeks, your pregnancy is still considered "early term" and won’t be "full term" until 39 weeks.</li>
    <li><strong>Development continues:</strong> Your baby’s lungs, brain, and nervous system are still developing. Their brain will keep growing until they’re 2 years old.</li>
    <li><strong>Lanugo shedding:</strong> Your baby has shed most of the fine body hair called lanugo that covered their body.</li>
    <li><strong>Grasping motions:</strong> Your baby can now make grasping motions with their fingers and may respond to bright lights by moving or turning toward the light.</li>
    <li><strong>Head-down position:</strong> If not already, your baby may be shifting into a head-down position in preparation for labor.</li>
</ul>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda pada Kehamilan 37 Minggu</h2>
<p>Pada usia kehamilan 37 minggu, serviks Anda mungkin mulai melebar. Ketika ini terjadi, Anda mungkin kehilangan segel yang melindungi rahim Anda dari infeksi. Segel ini dikenal sebagai sumbat lendir.</p>
<p>Jika Anda melihat keputihan ekstra yang jernih, agak merah muda, atau berdarah sedikit, itu mungkin sumbat lendir. Keputihan ini berarti persalinan sudah mulai atau tidak lama lagi.</p>
<p>Ingat, Anda bisa kehilangan sumbat lendir beberapa jam, hari, atau bahkan minggu sebelum persalinan dimulai. Beberapa orang tidak menyadarinya sama sekali. Kehilangan sumbat lendir atau sedikit bercak bukanlah hal yang aneh pada kehamilan 37 minggu. Namun, jika Anda melihat pendarahan hebat, hubungi penyedia layanan kesehatan Anda.</p>
<p>Jika Anda melihat sumbat lendir di pakaian dalam atau kertas toilet, atau jika Anda tidak yakin apakah persalinan sudah dimulai, Anda mungkin ingin menelepon penyedia layanan kesehatan Anda untuk meminta saran.</p>
<p>Bayi kembar dan triplet lebih mungkin lahir lebih awal daripada bayi tunggal, jadi perhatikan tanda-tanda persalinan jika Anda hamil 37 minggu dengan kembar atau lebih.</p>""",
    "perubahan_tubuh_en": """<h2>Your Body at 37 Weeks Pregnant</h2>
<p>At 37 weeks pregnant, your cervix may start to dilate. When this happens, you might lose the seal that has protected your uterus from infection. This seal is known as the mucus plug.</p>
<p>If you notice extra vaginal discharge that is clear, pinkish, or slightly bloody, it might be the mucus plug. This discharge means labor is starting or not far off.</p>
<p>Remember, you can lose the mucus plug hours, days, or even weeks before labor begins. Some people don’t notice it at all. Losing your mucus plug or having a little spotting isn't unusual at 37 weeks. However, if you notice severe bleeding, contact your healthcare provider.</p>
<p>If you see the mucus plug on your underwear or toilet paper, or if you are unsure if labor has started, you may want to call your healthcare provider for advice.</p>
<p>Twins and triplets are more likely to be born earlier than a single baby, so watch for signs of labor if you’re 37 weeks pregnant with multiples.</p>""",
    "gejala_umum_id": """<h2>Gejala di Kehamilan 37 Minggu</h2>
<p>Pada usia kehamilan 37 minggu, berikut beberapa gejala yang mungkin Anda alami:</p>
<ul>
  <li><strong>Nyeri atau tekanan panggul.</strong> Apakah bayi Anda berada lebih rendah di panggul? Penurunan ini, juga disebut lightening atau engagement, bisa terjadi beberapa minggu sebelum kelahiran. Anda mungkin merasakan tekanan ekstra di perut bawah, membuat berjalan sulit. Mandi air hangat dapat membantu meredakan nyeri ini. Hubungi penyedia layanan kesehatan Anda untuk saran lebih lanjut.</li>
  <li><strong>Sulit bernapas.</strong> Jika bayi Anda belum turun, mereka mungkin menekan paru-paru Anda, membuat pernapasan lebih sulit. Cobalah lebih banyak istirahat, bergerak perlahan, dan duduk atau berdiri tegak untuk membantu paru-paru Anda mengembang. Setelah bayi Anda turun lebih rendah, pernapasan mungkin menjadi lebih mudah.</li>
  <li><strong>Mual.</strong> Beberapa orang hamil merasakan mual di usia 37 minggu. Cobalah makan empat atau lima kali makan kecil daripada tiga kali makan besar. Makanan hambar seperti nasi, roti panggang, atau pisang bisa membantu. Jika Anda mengalami mual atau muntah yang parah, hubungi penyedia layanan kesehatan Anda.</li>
  <li><strong>Mendengkur.</strong> Perubahan hormon selama kehamilan bisa menyebabkan mendengkur. Tetap terhidrasi dan menggunakan pelembab udara di kamar tidur Anda bisa membantu jika mendengkur menjadi masalah.</li>
  <li><strong>Tidak stabil di kaki.</strong> Penambahan berat badan kehamilan menggeser pusat gravitasi Anda, membuat lebih mudah kehilangan keseimbangan. Berhati-hatilah saat bergerak. Berdirilah dengan kaki mengarah ke arah yang sama dan jaga keseimbangan berat badan. Hindari mengangkat barang berat.</li>
  <li><strong>Kontraksi.</strong> Anda mungkin mulai merasakan kontraksi seperti kram menstruasi. Jika kontraksi tidak teratur dan hilang saat Anda bergerak, kemungkinan itu adalah Braxton Hicks. Jika kontraksi teratur dan semakin kuat, hubungi penyedia layanan kesehatan Anda. Mengetahui waktu kontraksi dapat memberikan informasi yang berguna.</li>
</ul>""",
    "gejala_umum_en": """<h2>37 Weeks Pregnant: Your Symptoms</h2>
<p>At 37 weeks pregnant, here are some symptoms you might be feeling:</p>
<ul>
  <li><strong>Pelvic pain or pressure.</strong> Is your baby sitting lower in your pelvis? This dropping, also known as lightening or engagement, can happen a few weeks before birth. You might feel extra pressure on your lower abdomen, making it hard to walk. A warm bath might help relieve this pain. Contact your healthcare provider for more advice.</li>
  <li><strong>Shortness of breath.</strong> If your baby hasn’t dropped yet, they might be pressing against your lungs, making breathing harder. Try to rest more, move slowly, and sit or stand up straight to help your lungs expand. Once your baby drops lower, breathing might become easier.</li>
  <li><strong>Nausea.</strong> Some pregnant people feel nausea around 37 weeks. Try eating four or five smaller meals instead of three big ones. Bland foods like rice, toast, or bananas can help. If you have severe nausea or vomiting, contact your healthcare provider.</li>
  <li><strong>Snoring.</strong> Hormonal changes during pregnancy can cause snoring. Staying hydrated and using a humidifier in your bedroom can help if snoring is a problem.</li>
  <li><strong>Unstable on your feet.</strong> Your pregnancy weight gain shifts your center of gravity, making it easier to lose balance. Be extra careful when moving around. Stand with your feet pointed in the same direction and keep your weight balanced. Avoid lifting heavy items.</li>
  <li><strong>Contractions.</strong> You might start feeling contractions similar to period cramps. If the contractions are irregular and go away when you move, they are likely Braxton Hicks. If they are regular and get stronger, contact your healthcare provider. Timing your contractions can help provide useful information.</li>
</ul>""",
    "tips_mingguan_id": """<h2>Kehamilan 37 Minggu: Hal-Hal yang Perlu Dipertimbangkan</h2>
<p>Seiring mendekatnya tanggal kelahiran, berikut beberapa hal yang perlu diingat:</p>
<ul>
  <li><strong>Posisi melahirkan dan cara nyaman.</strong> Ada banyak posisi dan metode untuk membantu saat persalinan, beberapa memerlukan peralatan seperti tempat tidur melahirkan, kursi, kolam, atau bola. Tanyakan kepada rumah sakit atau pusat persalinan apa yang tersedia. Bersikaplah terbuka karena Anda mungkin menemukan hal-hal yang berbeda nyaman saat persalinan.</li>
  <li><strong>Pelajari opsi pemberian makan.</strong> Pelajari tentang menyusui dan pemberian susu formula sebelum bayi Anda lahir. Penyedia layanan kesehatan atau konsultan laktasi dapat memberikan informasi dan saran.</li>
  <li><strong>Pasang kursi mobil bayi menghadap ke belakang.</strong> Pastikan Anda memiliki kursi mobil untuk perjalanan pulang bayi Anda. Kursi baru adalah yang paling aman. Jika menggunakan kursi bekas, pastikan dalam kondisi baik dan tidak kedaluwarsa. Pemadam kebakaran lokal atau teknisi CPS dapat membantu pemasangan.</li>
  <li><strong>Mintalah bantuan.</strong> Teman, tetangga, atau keluarga yang terpercaya dapat membantu berbelanja, mencuci pakaian, atau merawat anak yang lebih tua dan hewan peliharaan di minggu-minggu pertama dengan bayi baru lahir Anda. Buat daftar tugas untuk memandu para pembantu Anda.</li>
  <li><strong>Tes streptococcus Grup B.</strong> Penyedia Anda mungkin menawarkan tes untuk memeriksa apakah Anda membawa bakteri GBS. Jika positif, penyedia Anda akan memberi tahu tentang perawatan untuk melindungi bayi Anda saat melahirkan.</li>
  <li><strong>Kehamilan penuh.</strong> Kehamilan Anda dianggap penuh pada 39 minggu. Bayi Anda masih memiliki beberapa perkembangan yang harus dilakukan, tetapi Anda hanya beberapa minggu lagi untuk bertemu dengan bayi baru lahir Anda!</li>
</ul>""",
    "tips_mingguan_en": """<h2>37 Weeks Pregnant: Things to Consider</h2>
<p>As your due date gets closer, here are a few things to keep in mind:</p>
<ul>
  <li><strong>Birthing positions and comfort measures.</strong> There are many positions and methods to help during labor and delivery, some requiring equipment like a birthing bed, chair, pool, or ball. Ask your hospital or birth center what they have available. Keep an open mind as you might find different things comfortable during labor.</li>
  <li><strong>Research feeding options.</strong> Learn about breastfeeding and formula feeding before your baby arrives. Your healthcare provider or a lactation consultant can offer information and advice.</li>
  <li><strong>Install a rear-facing infant car seat.</strong> Make sure you have a car seat ready for your baby’s trip home. A new seat is safest. If using a hand-me-down, ensure it’s in good condition and not expired. Your local fire department or a CPS technician can help with installation.</li>
  <li><strong>Ask for help.</strong> Trusted friends, neighbors, or family can assist with shopping, laundry, or caring for older children and pets in the first weeks with your newborn. Make a list of tasks to guide your helpers.</li>
  <li><strong>Group B strep test.</strong> Your provider may offer a test to check if you carry GBS bacteria. If positive, your provider will advise on treatment to protect your baby during birth.</li>
  <li><strong>Full-term pregnancy.</strong> Your pregnancy is considered full term at 39 weeks. Your baby still has some developing to do, but you’re only weeks away from meeting your newborn!</li>
</ul>""",
    "bayi_img_path": "week_37.jpg",
    "ukuran_bayi_img_path": "week_37_swiss_chard.svg"
  },
  {
    "id": "38",
    "minggu_kehamilan": "38",
    "berat_janin": 3200,
    "tinggi_badan_janin": 490,
    "ukuran_bayi_id": "Bawang Prei",
    "ukuran_bayi_en": "Leek",
    "poin_utama_id": """<h2>Sorotan pada Kehamilan 38 Minggu</h2>
<p>Berikut beberapa poin penting yang perlu diingat pada kehamilan 38 minggu:</p>
<ul>
  <li>Bayi Anda mengisi sebagian besar ruang di kantung ketuban, sehingga sedikit ruang untuk bergerak.</li>
  <li>Pada 38 minggu, bayi Anda kemungkinan berada dalam posisi kepala di bawah, siap untuk lahir.</li>
  <li>Persiapkan diri untuk persalinan dengan memilih pasangan persalinan Anda, mengenali tanda-tanda persalinan, dan mengetahui kapan harus pergi ke rumah sakit.</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 38 Weeks Pregnant</h2>
<p>Here are some important points to remember at 38 weeks pregnant:</p>
<ul>
  <li>Your baby is taking up most of the space in the amniotic sac, leaving little room for movement.</li>
  <li>At 38 weeks, your baby is likely in a head-down position, ready for birth.</li>
  <li>Prepare for labor by choosing your labor partner, recognizing the signs of labor, and knowing when to go to the hospital.</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>38 Minggu Kehamilan: Perkembangan Bayi Anda</h2>
<p>Bayi Anda hampir siap lahir namun masih tumbuh setiap hari. Berikut beberapa perkembangan yang terjadi sekarang:</p>
<ul>
  <li>Dalam beberapa minggu terakhir ini, otak bayi Anda masih berkembang. Otak mereka bisa tumbuh hingga sepertiga ukurannya antara 35 dan 39 minggu. Si kecil Anda semakin pintar!</li>
  <li>Hati bayi Anda hampir sepenuhnya berkembang sekarang.</li>
  <li>Setelah lahir, buang air besar pertama bayi Anda akan berupa zat yang disebut mekonium. Kotoran yang lengket berwarna hijau kehitaman ini terbentuk di usus dari bahan limbah seperti sel kulit mati dan lanugo, rambut halus yang sedang rontok.</li>
  <li>Meski tanggal jatuh tempo Anda masih beberapa minggu lagi, Anda mungkin mulai melihat tanda-tanda persalinan segera, dan bayi Anda bisa lahir kapan saja. Hanya sekitar lima persen bayi yang lahir tepat pada tanggal jatuh tempo mereka.</li>
  <li>Jika Anda mengandung bayi kembar atau lebih, mereka lebih mungkin lahir lebih awal, jadi perhatikan tanda-tanda persalinan.</li>
</ul>""",
    "perkembangan_bayi_en": """<h2>38 Weeks Pregnant: Your Baby's Development</h2>
<p>Your baby is almost ready to be born but is still growing every day. Here are some of the developments happening now:</p>
<ul>
  <li>In these last few weeks, your baby’s brain is still growing. It can increase by up to one-third in size between 35 and 39 weeks. Your little one is getting smarter!</li>
  <li>Your baby’s liver is almost fully developed by now.</li>
  <li>After birth, your baby’s first bowel movements will be a substance called meconium. This greenish-black, sticky poop forms in the intestines from waste materials like dead skin cells and lanugo, the fine hair your baby is shedding.</li>
  <li>Even though your due date is a couple of weeks away, you might start to see signs of labor soon, and your baby could arrive any day. Only about five percent of babies are born exactly on their due date.</li>
  <li>If you’re expecting twins or multiples, they are more likely to be born early, so watch for signs of labor.</li>
</ul>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda pada 38 Minggu Kehamilan</h2>
<p>Pada 38 minggu kehamilan, Anda mungkin masih mengalami penambahan berat badan. Jika BMI Anda normal sebelum hamil, Anda bisa menambah sekitar setengah hingga satu pon per minggu di trimester ketiga.</p>
<p>Perut yang semakin besar mungkin membuat sulit untuk tidur nyenyak atau bergerak normal, tetapi akhir sudah dekat!</p>
<p>Olahraga mungkin semakin sulit sekarang. Jika demikian, Anda bisa mencoba latihan pernapasan. Latihan ini bisa membantu Anda rileks dan mempersiapkan diri untuk persalinan. Mereka juga berguna untuk mengelola rasa sakit dan ketidaknyamanan selama persalinan.</p>""",
    "perubahan_tubuh_en": """<h2>Your Body at 38 Weeks Pregnant</h2>
<p>At 38 weeks pregnant, you might still be gaining weight. If your BMI was normal before pregnancy, you could be gaining about half a pound to one pound per week in the third trimester.</p>
<p>Your growing belly might be making it hard to sleep well or move normally, but the end is near!</p>
<p>Exercise might be getting harder now. If so, you might want to try breathing exercises. These exercises can help you relax and prepare for labor. They are also useful for managing pain and discomfort during labor.</p>""",
    "gejala_umum_id": """<h2>38 Minggu Kehamilan: Gejala Anda</h2>
<p>Pada 38 minggu kehamilan, Anda mungkin mengalami gejala berikut:</p>
<ul>
    <li><strong>Sering buang air kecil.</strong> Saat bayi dan rahim Anda tumbuh, mereka memberi lebih banyak tekanan pada kandung kemih Anda, sehingga Anda mungkin perlu lebih sering ke kamar mandi. Meskipun mengganggu, tetap minum banyak air untuk tetap terhidrasi.</li>
    <li><strong>Tekanan panggul.</strong> Ketika bayi Anda turun lebih rendah ke panggul, Anda mungkin merasakan tekanan lebih pada kandung kemih dan pinggul Anda. Hormon relaksin, yang melunakkan ligamen, otot, dan sendi untuk persalinan, juga bisa menyebabkan beberapa nyeri punggung atau panggul. Cobalah untuk tidak terlalu banyak berdiri, bergerak perlahan, dan mandi air hangat jika merasa tidak nyaman.</li>
    <li><strong>Pembengkakan pergelangan kaki dan kaki.</strong> Tubuh Anda menahan lebih banyak cairan, menyebabkan pembengkakan di tangan dan kaki. Istirahat dengan kaki diangkat, minum lebih banyak air untuk mengeluarkan kelebihan cairan, dan kenakan pakaian dan sepatu longgar. Stoking atau kaus kaki penyangga mungkin membantu mengurangi pembengkakan. Jika Anda melihat pembengkakan mendadak di wajah atau tangan, hubungi penyedia layanan kesehatan Anda karena bisa jadi tanda preeklamsia.</li>
    <li><strong>Mual.</strong> Sedikit mual dapat muncul kembali pada 38 minggu atau dalam minggu-minggu mendatang dan mungkin menunjukkan bahwa persalinan sudah dekat. Jika merasa mual, makanlah makanan kecil beberapa kali sehari dan pilih makanan hambar seperti pisang, nasi, atau roti panggang.</li>
    <li><strong>Kontraksi.</strong> Anda mungkin sudah merasakan kontraksi Braxton Hicks. Kontraksi "latihan" ini biasanya terjadi tidak teratur dan berhenti saat Anda bergerak atau mengubah posisi. Kontraksi persalinan sejati datang secara teratur, semakin dekat satu sama lain, dan semakin kuat. Mereka sering dimulai dari punggung dan bergerak ke depan perut Anda. Menghitung waktu kontraksi akan membantu Anda mengetahui apakah itu persalinan sebenarnya atau hanya Braxton Hicks.</li>
</ul>""",
    "gejala_umum_en": """<h2>38 Weeks Pregnant: Your Symptoms</h2>
<p>At 38 weeks pregnant, you may notice these symptoms:</p>
<ul>
    <li><strong>Frequent urination.</strong> As your baby and uterus grow, they put more pressure on your bladder, so you might need to use the bathroom more often. Even though it's annoying, keep drinking lots of water to stay hydrated.</li>
    <li><strong>Pelvic pressure.</strong> When your baby moves lower into your pelvis, you may feel more pressure on your bladder and hips. The hormone relaxin, which softens your ligaments, muscles, and joints for childbirth, might also cause some back or pelvic pain. Try to stay off your feet, move slowly, and take warm baths if you feel uncomfortable.</li>
    <li><strong>Swollen ankles and feet.</strong> Your body retains more fluid, causing swelling in your hands and legs. Rest with your feet up, drink more water to flush out excess fluid, and wear loose clothes and shoes. Support tights or socks might help reduce swelling. If you notice sudden swelling in your face or hands, contact your healthcare provider as it could be a sign of preeclampsia.</li>
    <li><strong>Nausea.</strong> Slight nausea can appear again at 38 weeks or in the coming weeks and might indicate labor is near. If you're feeling nauseous, eat smaller meals throughout the day and stick to bland foods like bananas, rice, or toast.</li>
    <li><strong>Contractions.</strong> You might have felt Braxton Hicks contractions already. These "practice contractions" usually happen irregularly and stop when you move or change positions. True labor contractions come regularly, get closer together, and increase in strength. They often start in the back and move to the front of your abdomen. Timing your contractions will help you know if it's real labor or just more Braxton Hicks.</li>
</ul>""",
    "tips_mingguan_id": """<h2>38 Minggu Kehamilan: Hal yang Perlu Dipertimbangkan</h2>
<p>Menjelang tanggal kelahiran Anda, berikut adalah beberapa pertimbangan penting:</p>
<ul>
    <li><strong>Pilihan Penghilang Nyeri:</strong> Sudahkah Anda memikirkan bagaimana Anda akan mengatasi nyeri saat persalinan? Berbicaralah dengan penyedia layanan kesehatan Anda tentang opsi analgesik dan anestesi, seperti epidural, dan diskusikan teknik kenyamanan yang Anda pelajari dalam kelas persalinan.</li>
    <li><strong>Memilih Pasangan Persalinan:</strong> Tentukan siapa yang akan mendukung Anda selama persalinan dan kelahiran. Orang ini dapat memberikan dukungan emosional dan bantuan praktis, yang dapat menghasilkan persalinan yang lebih singkat dan penggunaan obat penghilang nyeri yang lebih sedikit.</li>
    <li><strong>Kebijakan Rumah Sakit:</strong> Periksa kebijakan rumah sakit Anda tentang makan dan minum selama persalinan, terutama jika Anda akan menjalani operasi caesar. Pahami persyaratan puasa dan apakah Anda bisa minum cairan bening selama persalinan pervaginan.</li>
    <li><strong>Kehamilan Penuh:</strong> Rayakan mencapai usia kehamilan penuh pada 39 minggu dan pelajari tentang istilah-istilah yang digunakan untuk menjelaskan tahapan kehamilan.</li>
    <li><strong>Penelitian Tentang Menyusui:</strong> Pertimbangkan untuk melakukan penelitian tentang konsultan laktasi yang dapat membantu mengatasi tantangan menyusui. Mengetahui di mana mencari dukungan dapat membuat perbedaan besar.</li>
    <li><strong>Mempersiapkan Diri untuk Postpartum:</strong> Luangkan waktu untuk mempelajari tentang periode pascapersalinan, termasuk pemulihan, diastasis rekti, kerontokan rambut pascapersalinan, dan pengalaman umum lainnya.</li>
</ul>""",
    "tips_mingguan_en": """<h2>38 Weeks Pregnant: Things to Consider</h2>
<p>As your due date approaches, here are some important considerations:</p>
<ul>
    <li><strong>Pain Relief Options:</strong> Have you thought about how you'll manage pain during labor? Talk to your healthcare provider about analgesic and anesthetic options, such as epidurals, and discuss comfort techniques you learned in childbirth class.</li>
    <li><strong>Choosing a Birth Partner:</strong> Decide who will support you during labor and delivery. This person can offer emotional support and practical assistance, which can lead to shorter labor and less pain medication usage.</li>
    <li><strong>Hospital Policies:</strong> Check your hospital's policies on eating and drinking during labor, especially if you're having a cesarean section. Understand fasting requirements and whether you can have clear liquids during a vaginal delivery.</li>
    <li><strong>Full-Term Pregnancy:</strong> Celebrate reaching full term at 39 weeks and learn about the different terms used to describe stages of pregnancy.</li>
    <li><strong>Researching Breastfeeding:</strong> Consider researching lactation consultants who can help with breastfeeding challenges. Knowing where to find support can make a big difference.</li>
    <li><strong>Preparing for Postpartum:</strong> Take some time to educate yourself about the postpartum period, including recovery, diastasis recti, postpartum hair loss, and other common experiences.</li>
</ul>""",
    "bayi_img_path": "week_38.jpg",
    "ukuran_bayi_img_path": "week_38_leek.svg"
  },
  {
    "id": "39",
    "minggu_kehamilan": "39",
    "berat_janin": 3400,
    "tinggi_badan_janin": 500,
    "ukuran_bayi_id": "Semangka Kecil",
    "ukuran_bayi_en": "Mini Watermelon",
    "poin_utama_id": """<h2>Highlights pada Minggu Kehamilan ke-39</h2>
<p>Saat Anda mencapai usia kehamilan 39 minggu, berikut adalah beberapa poin penting yang perlu diperhatikan:</p>
<ul>
    <li>Kehamilan Anda sekarang dianggap sebagai kehamilan penuh! Waktunya hampir tiba untuk menyambut kedatangan buah hati Anda yang baru.</li>
    <li>Pada usia kehamilan 39 minggu, bayi Anda kira-kira seukuran semangka mini.</li>
    <li>Tetap waspada terhadap tanda-tanda bahwa persalinan mungkin akan segera datang, seperti kehilangan sumbat lendir atau pecahnya air ketuban.</li>
    <li>Pertimbangkan posisi persalinan yang berbeda untuk menemukan yang paling nyaman bagi Anda. Lihat panduan visual kami di bawah ini untuk beberapa ide.</li>
    <li>Sisihkan waktu untuk bersantai dan menikmati hari-hari atau minggu-minggu terakhir kehamilan ini. Anda telah melakukan pekerjaan yang luar biasa!</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 39 Weeks Pregnant</h2>
<p>As you reach 39 weeks pregnant, here are some key points to note:</p>
<ul>
    <li>Your pregnancy has reached full term, and you're eagerly awaiting the arrival of your new baby.</li>
    <li>At 39 weeks pregnant, your baby is approximately the size of a mini watermelon.</li>
    <li>Stay vigilant for signs indicating that labor may be imminent, such as the loss of your mucus plug or your water breaking.</li>
    <li>Consider different labor positions to find what's most comfortable for you. Check out our visual guide below for some ideas.</li>
    <li>Take some time to relax and savor these final days or weeks of pregnancy. You've done an incredible job!</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>Usia Kehamilan 39 Minggu: Perkembangan Bayi Anda</h2>
<p>Selamat atas pencapaian usia kehamilan 39 minggu! Berikut perkembangan bayi Anda:</p>
<ul>
    <li>Paru-paru dan otak bayi Anda masih dalam tahap perkembangan dan akan terus berkembang setelah lahir. Otak akan mencapai ukuran penuh sekitar usia 2 tahun, sementara paru-paru akan matang sekitar usia 3 tahun.</li>
    <li>Pada saat ini, paru-paru sedang memproduksi surfaktan, zat yang mencegah sakelar udara agar tidak saling menempel ketika bayi mengambil napas pertamanya.</li>
    <li>Karena ruang yang terbatas di dalam rahim Anda, bayi Anda mungkin tidak bergerak sebanyak sebelumnya. Namun, Anda masih seharusnya merasakan beberapa tendangan dan gerakan. Jika Anda mengalami penurunan gerakan, disarankan untuk berkonsultasi dengan penyedia layanan kesehatan Anda untuk ketenangan pikiran.</li>
</ul>""",
    "perkembangan_bayi_en": """<h2>39 Weeks Pregnant: Your Baby’s Development</h2>
<p>Congratulations on reaching 39 weeks of pregnancy! Here’s how your baby is developing:</p>
<ul>
    <li>Your baby’s lungs and brain are still undergoing development, which will continue even after birth. The brain will reach full size by around age 2, while the lungs will mature by around age 3.</li>
    <li>At this stage, the lungs are producing surfactant, a substance that prevents the air sacs from sticking together when the baby takes their first breath.</li>
    <li>Due to limited space in your uterus, your baby may not be moving around as much as before. However, you should still feel some kicks and movements. If you notice a decrease in movement, it’s a good idea to consult your healthcare provider for peace of mind.</li>
</ul>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda saat Hamil 39 Minggu</h2>
<p>Pada saat ini, Anda mungkin sangat menantikan kelahiran bayi Anda! Saat hamil 39 minggu, berjalan bisa sulit bagi beberapa orang, dan setiap gerakan, besar atau kecil, mungkin terasa sulit.</p>
<p>Penting untuk bergerak perlahan dan hati-hati, serta memprioritaskan istirahat sebisa mungkin. Meskipun tidur mungkin sulit, cobalah untuk menghemat energi Anda dengan istirahat sebentar atau tidur siang selama siang hari.</p>""",
    "perubahan_tubuh_en": """<h2>Your Body at 39 Weeks Pregnant</h2>
<p>By now, you might be eagerly awaiting the arrival of your baby! At 39 weeks pregnant, walking can be challenging for some, and any movement, big or small, may feel difficult.</p>
<p>It's important to move slowly and carefully, and prioritize rest whenever possible. While sleeping might be hard, try to conserve your energy by taking short breaks or napping during the day.</p>""",
    "gejala_umum_id": """<h2>39 Minggu Hamil: Gejala yang Anda Alami</h2>
<ul>
    <li><strong>Kesulitan tidur:</strong> Mendapatkan tidur malam yang nyenyak mungkin sulit saat hamil 39 minggu. Perut yang semakin membesar bisa membuat mencari posisi yang nyaman sulit, dan perasaan gugup dan cemas bisa menyebabkan sulit tidur. Untuk meningkatkan kualitas tidur, pastikan tempat tidur dan kamar tidur Anda sesuai kenyamanannya, dengan bantal tambahan untuk dukungan.</li>
    <li><strong>Keilangan tutup lendir:</strong> Sekitar 39 minggu hamil, Anda mungkin melihat tutup lendir, yang menutupi leher rahim, dikeluarkan. Ini bisa muncul sebagai lendir vagina yang jernih, kemerahan, atau sedikit berdarah. Tutup lendir bisa terlepas beberapa jam hingga beberapa minggu sebelum persalinan dimulai. Jika Anda mengalami pendarahan vagina berat pada tahap ini atau kapan pun selama kehamilan, hubungi penyedia layanan kesehatan Anda segera.</li>
    <li><strong>Robeknya ketuban:</strong> Ketika kantung ketuban pecah, mengakibatkan keluarnya cairan dalam jumlah besar atau sedikit, itu menandakan bahwa persalinan telah dimulai. Hubungi penyedia layanan kesehatan Anda jika ketuban Anda pecah, terutama jika Anda mencatat bau tidak sedap dari cairan atau mengalami demam, karena ini bisa menunjukkan infeksi.</li>
    <li><strong>Preeklampsia:</strong> Beberapa orang mengalami preeklampsia, gangguan tekanan darah tinggi, sekitar 39 minggu hamil atau selama minggu-minggu terakhir kehamilan. Gejala mungkin termasuk bengkak di wajah dan tangan, sakit kepala, mual, penambahan berat badan secara tiba-tiba, sesak napas, dan perubahan penglihatan. Jika Anda mengalami salah satu gejala ini, hubungi penyedia layanan kesehatan Anda segera.</li>
</ul>""",
    "gejala_umum_en": """<h2>39 Weeks Pregnant: Your Symptoms</h2>
<ul>
    <li><strong>Trouble sleeping:</strong> Getting a good night's sleep might be challenging at 39 weeks pregnant. Your growing belly can make finding a comfortable position difficult, and feelings of nerves and anxiety can contribute to sleeplessness. To improve sleep quality, ensure your bed and bedroom are as comfortable as possible, with extra pillows for support.</li>
    <li><strong>Losing the mucus plug:</strong> Around 39 weeks pregnant, you may notice the mucus plug, which seals the cervix, being discharged. This can appear as a clear, pinkish, or slightly bloody vaginal discharge. The mucus plug can detach hours to weeks before labor begins. If you experience heavy vaginal bleeding at this stage or at any time during pregnancy, contact your healthcare provider immediately.</li>
    <li><strong>Water breaking:</strong> When the amniotic sac ruptures, leading to a gush or trickle of fluid, it signifies that labor has started. Contact your healthcare provider if your water breaks, especially if you notice a foul odor from the fluid or develop a fever, as these could indicate an infection.</li>
    <li><strong>Preeclampsia:</strong> Some individuals develop preeclampsia, a high blood pressure disorder, around 39 weeks pregnant or during the final weeks of pregnancy. Symptoms may include swelling of the face and hands, headaches, nausea, sudden weight gain, shortness of breath, and vision changes. If you experience any of these symptoms, contact your healthcare provider promptly.</li>
</ul>""",
    "tips_mingguan_id": """<h2>39 Minggu Hamil: Hal yang Perlu Dipertimbangkan</h2>
<ul>
    <li>Saat Anda mendekati tanggal kelahiran, penting untuk mulai menghitung kontraksi untuk membedakan antara kontraksi Braxton Hicks dan kontraksi persalinan yang sebenarnya. Kontraksi Braxton Hicks biasanya terjadi secara tidak teratur dan berhenti saat Anda mengubah posisi, sementara kontraksi persalinan yang sebenarnya datang secara teratur dan meningkat intensitasnya.</li>
    <li>Jika Anda mengalami pecah ketuban atau kram dan nyeri punggung sekitar 39 minggu hamil, hubungi penyedia layanan kesehatan Anda, karena ini bisa menjadi tanda-tanda persalinan.</li>
    <li>Dalam beberapa kasus, penyedia layanan kesehatan Anda mungkin menyarankan untuk memicu persalinan jika ada kondisi medis tertentu atau jika persalinan tidak berlangsung seperti yang diharapkan.</li>
    <li>Selama persalinan, eksplorasi berbagai posisi untuk menemukan yang paling nyaman untuk Anda. Ini bisa mencakup menggunakan bola persalinan, jongkok, berdiri, berlutut, atau rebahan dengan kaki Anda di stirrup.</li>
    <li>Luangkan waktu untuk menyelesaikan rencana persalinan Anda, mempertimbangkan preferensi Anda untuk persalinan dan teknik kenyamanan. Namun, bersiaplah untuk menyesuaikan rencana Anda sesuai kebutuhan selama persalinan.</li>
    <li>Gunakan waktu ini untuk menyelesaikan belanja terakhir untuk perlengkapan bayi baru lahir dan kenali apa yang perlu Anda harapkan setelah melahirkan, termasuk kontak kulit-menyentuh, skor Apgar, perawatan dan pemulihan pasca melahirkan.</li>
</ul>""",
    "tips_mingguan_en": """<h2>39 Weeks Pregnant: Things to Consider</h2>
<ul>
    <li>As you approach your due date, it's important to start timing your contractions to distinguish between Braxton Hicks contractions and real labor. Braxton Hicks contractions typically occur irregularly and stop when you change positions, while real labor contractions come at regular intervals and increase in intensity.</li>
    <li>If you experience your water breaking or cramps and back pain around 39 weeks pregnant, contact your healthcare provider, as these could be signs of labor.</li>
    <li>In some cases, your healthcare provider may suggest inducing labor if certain medical conditions are present or if labor is not progressing as expected.</li>
    <li>During labor, explore different positions to find what's most comfortable for you. This could include using a birthing ball, squatting, standing, kneeling, or reclining with your feet in stirrups.</li>
    <li>Take time to finalize your birth plan, considering your preferences for labor and comfort techniques. However, be prepared to adapt your plan as needed during labor.</li>
    <li>Use this time to complete any last-minute shopping for newborn essentials and familiarize yourself with what to expect after giving birth, including skin-to-skin contact, the Apgar score, postpartum care, and recovery.</li>
</ul>""",
    "bayi_img_path": "week_39.jpg",
    "ukuran_bayi_img_path": "week_39_watermelon.svg"
  },
  {
    "id": "40",
    "minggu_kehamilan": "40",
    "berat_janin": 3600,
    "tinggi_badan_janin": 510,
    "ukuran_bayi_id": "Labu Kecil",
    "ukuran_bayi_en": "Small Pumkin",
    "poin_utama_id": """<h2>Peristiwa Penting pada Minggu ke-40 Kehamilan</h2>
<ul>
    <li>Tiba di usia kehamilan 40 minggu menandai tonggak penting dalam perjalanan Anda. Berikut yang perlu Anda ketahui:</li>
    <li>Bayi Anda sekarang memiliki ukuran sekitar sebesar labu kecil dan dengan antusias bersiap untuk menyambut kedatangan Anda di dunia.</li>
    <li>Mereka mungkin telah mengambil posisi kepala ke bawah dalam antisipasi kelahiran.</li>
    <li>Mengamati adanya debit vagina berwarna kemerahan atau berdarah pada saat ini bisa menjadi tanda pelepasan sumbat lendir, yang mengindikasikan bahwa persalinan mungkin akan segera terjadi.</li>
    <li>Tidak peduli apakah Anda mengantisipasi persalinan pervaginan atau persalinan dengan operasi caesar, penting untuk mempelajari dan menginformasikan diri tentang kedua pilihan tersebut.</li>
</ul>""",
    "poin_utama_en": """<h2>Highlights at 40 Weeks Pregnant</h2>
<ul>
    <li>Arriving at 40 weeks pregnant marks a significant milestone in your journey. Here's what you should be aware of:</li>
    <li>Your baby is now approximately the size of a small pumpkin and is eagerly preparing for their grand entrance into the world.</li>
    <li>They may have assumed a head-down position in anticipation of birth.</li>
    <li>Observing a pinkish or bloody vaginal discharge around this time could indicate the shedding of the mucus plug, signaling that labor may be imminent.</li>
    <li>Regardless of whether you're anticipating a vaginal birth or a cesarean delivery, it's essential to educate yourself about both options.</li>
</ul>""",
    "perkembangan_bayi_id": """<h2>Perkembangan Bayi Anda pada Minggu ke-40 Kehamilan</h2>
<p>Pada usia kehamilan 40 minggu, bayi Anda bisa datang kapan saja, tetapi mereka mungkin lebih memilih sedikit waktu lagi dalam kenyamanan perut Anda. Jika persalinan tidak dimulai dalam seminggu setelah tanggal perkiraan lahir Anda, penyedia layanan kesehatan Anda akan memantau detak jantung dan gerakan bayi Anda dengan lebih cermat untuk memastikan bahwa semuanya berjalan dengan baik.</p>
<ul>
    <li>Kepala bayi Anda kemungkinan besar sudah turun lebih rendah ke panggul Anda, dan tubuhnya terlipat rapat. Mereka tidak memiliki banyak pilihan - ruang di dalam sana cukup sempit.</li>
    <li>Jika bayi Anda berada dalam posisi sungsang (bokong ke bawah atau bokong dan kaki ke bawah), penyedia layanan Anda mungkin akan mencoba untuk membalikkan mereka dengan memberi tekanan yang kuat pada perut Anda. Jika itu tidak berhasil, mereka mungkin akan membahas kemungkinan persalinan dengan operasi caesar dengan Anda.</li>
    <li>Anda telah bersiap untuk bertemu dengan bayi Anda, dan mereka juga telah bersiap untuk bertemu dengan Anda! Tubuh kecil mereka telah mengumpulkan lemak sampai saat ini untuk membantu dalam transisi ke kehidupan di luar rahim, sementara hati, paru-paru, dan otak mereka terus berkembang.</li>
</ul>""",
    "perkembangan_bayi_en": """<h2>40 Weeks Pregnant: Your Baby's Development</h2>
<p>At 40 weeks pregnant, your baby could arrive any day now, but they might also choose to stay a little longer in the comfort of your belly. If labor doesn't begin within a week of your expected due date, your healthcare provider will closely monitor your baby's heart rate and movements to ensure everything is progressing well.</p>
<ul>
    <li>Your baby's head has likely descended lower into your pelvis, and their body is tightly curled up. With limited space inside, it's quite cramped for them.</li>
    <li>If your baby is in a breech position (bottom down or bottom and feet down), your provider may attempt to turn them by applying firm pressure to your abdomen. If unsuccessful, they may discuss the possibility of a cesarean delivery.</li>
    <li>You've been preparing to meet your baby, and they've been preparing to meet you too! Up until now, their little body has been accumulating fat to help with the transition to life outside the womb, while their liver, lungs, and brain continue to develop.</li>
</ul>""",
    "perubahan_tubuh_id": """<h2>Tubuh Anda pada Minggu ke-40 Kehamilan</h2>
<p>Tubuh Anda telah melakukan pekerjaan luar biasa dalam merawat dan memberi makan bayi Anda selama kehamilan. Berikut adalah apa yang terjadi selama persalinan dan kelahiran baik untuk persalinan normal maupun persalinan caesar:</p>
<h3>Kelahiran Normal</h3>
<p>Selama kelahiran normal, Anda akan mengalami tiga tahap persalinan:</p>
<ul>
    <li><strong>Tahap Pertama:</strong> Tahap ini melibatkan awal persalinan, di mana leher rahim Anda mulai menipis dan terbuka, dan persalinan aktif, ketika kontraksi intensif membantu memindahkan bayi ke dalam saluran lahir. Awal persalinan bisa berlangsung hingga 14-20 jam, diikuti oleh persalinan aktif, yang mungkin berlangsung 4-8 jam.</li>
    <li><strong>Tahap Kedua:</strong> Ketika leher rahim Anda sepenuhnya terbuka, biasanya sekitar 10 sentimeter, Anda memasuki tahap kedua. Di sini, Anda akan mendorong untuk membantu memandu bayi melalui saluran lahir. Tahap ini dapat berlangsung 30 menit hingga 3 jam.</li>
    <li><strong>Tahap Ketiga:</strong> Setelah melahirkan bayi Anda, Anda akan memasuki tahap terakhir, di mana Anda akan melahirkan plasenta. Kontraksi terus berlanjut saat plasenta terlepas, tetapi tahap ini umumnya lebih cepat dan kurang menyakitkan daripada melahirkan bayi.</li>
</ul>
<h3>Kelahiran Melalui Operasi Caesar</h3>
<p>Dalam beberapa kasus, operasi caesar mungkin diperlukan:</p>
<ul>
    <li>Untuk persalinan caesar, anestesi diberikan untuk membius atau membuat Anda tertidur sebelum operasi. Dokter Anda kemudian membuat sayatan di perut dan rahim Anda untuk secara manual melahirkan bayi dan plasenta.</li>
    <li>Jika c-section Anda direncanakan, pasangan Anda mungkin diperbolehkan menemani Anda ke ruang operasi.</li>
</ul>""",
    "perubahan_tubuh_en": """<h2>Your Body at 40 Weeks Pregnant</h2>
<p>Your body has done an incredible job nurturing your baby throughout pregnancy. Here's what to expect during labor and delivery for both vaginal birth and cesarean section:</p>
<h3>Vaginal Birth</h3>
<p>During a vaginal birth, you'll experience three stages of labor:</p>
<ul>
    <li><strong>First Stage:</strong> This stage involves early labor, where your cervix begins to thin and open, and active labor, when contractions intensify, helping move the baby down the birth canal. Early labor can last up to 14-20 hours, followed by active labor, which may span 4-8 hours.</li>
    <li><strong>Second Stage:</strong> When your cervix is fully dilated, typically 10 centimeters, you'll enter the second stage. Here, you'll push to guide your baby through the birth canal. This stage may last 30 minutes to 3 hours.</li>
    <li><strong>Third Stage:</strong> After delivering your baby, you'll enter the final stage, where you'll deliver the placenta. Contractions continue as the placenta detaches, but this stage is generally quicker and less painful than delivering the baby.</li>
</ul>
<h3>Cesarean Birth</h3>
<p>In some cases, a cesarean section may be necessary:</p>
<ul>
    <li>For a cesarean delivery, anesthesia is administered to numb or sedate you before surgery. Your doctor then makes incisions in your abdomen and uterus to manually deliver the baby and placenta.</li>
    <li>If your c-section is planned, your partner may accompany you to the operating room.</li>
</ul>""",
    "gejala_umum_id": """<h2>Gejala Kehamilan 40 Minggu: Tanda-tandanya</h2>
<p>Pada usia kehamilan 40 minggu, Anda mungkin mengalami beberapa gejala berikut:</p>
<ul>
    <li><strong> Mendengkur:</strong> Karena perubahan hormonal, Anda mungkin mengalami peningkatan mendengkur menjelang tanggal kelahiran. Pertimbangkan untuk menggunakan pelembap udara atau strip hidung untuk mengurangi ini.</li>
    <li><strong> Kehilangan Tutup Mucosa:</strong> Tutup ini, yang menutupi serviks selama kehamilan, mungkin dikeluarkan sebelum atau selama persalinan. Ini bisa muncul sebagai keluarnya cairan berwarna pink, berdarah, atau bening.</li>
    <li><strong> Kontraksi:</strong> Kontraksi Braxton Hicks mungkin dirasakan sebelumnya, tetapi kontraksi persalinan yang sebenarnya akan terjadi dalam interval yang teratur dan meningkat dalam frekuensi dan intensitasnya.</li>
    <li><strong> Pecahnya Air Ketuban:</strong> Keretakan kantung amnion yang menyelubungi bayi, melepaskan cairan amnion, bisa menjadi tanda persalinan. Ini bisa terjadi beberapa jam sebelum persalinan atau begitu persalinan dimulai.</li>
</ul>""",
    "gejala_umum_en": """<h2>40 Weeks Pregnant: Your Symptoms</h2>
<p>At 40 weeks pregnant, you might be experiencing the following symptoms:</p>
<ul>
    <li><strong>Snoring:</strong> Due to hormonal changes, you may notice increased snoring as your due date approaches. Consider using a humidifier or nasal strips to alleviate this.</li>
    <li><strong>Losing the Mucus Plug:</strong> This plug, which seals your cervix during pregnancy, may be discharged before or during labor. It could appear as pinkish, bloody, or clear discharge.</li>
    <li><strong>Contractions:</strong> Braxton Hicks contractions may have been felt earlier, but true labor contractions will occur at regular intervals and increase in frequency and intensity.</li>
    <li><strong>Water Breaking:</strong> The rupture of the amniotic sac, releasing amniotic fluid, can be a sign of labor. This may happen hours before labor or once it has begun.</li>
</ul>""",
    "tips_mingguan_id": """<h2>40 Minggu Hamil: Hal yang Perlu Dipertimbangkan</h2>
<p>Saat Anda menunggu kedatangan bayi Anda, berikut adalah beberapa hal yang perlu Anda perhatikan:</p>
<ul>
    <li><strong>Perkiraan Tanggal Lahir yang Fleksibel:</strong> Jangan terkejut jika bayi Anda tidak lahir tepat pada tanggal lahir perkiraan. Tanggal lahir hanya perkiraan, dan kehamilan dianggap penuh sampai 42 minggu.</li>
    <li><strong>Pemeriksaan Rutin:</strong> Selama minggu-minggu terakhir, Anda kemungkinan akan menjalani pemeriksaan rutin mingguan dengan penyedia layanan kesehatan Anda untuk memantau serviks Anda dan kesehatan serta gerakan bayi.</li>
    <li><strong>Perawatan Diri:</strong> Anggaplah hari-hari terakhir ini sebagai kesempatan untuk merawat diri. Berikan diri Anda kegiatan seperti perawatan kuku, menonton film, atau menambah wawasan dengan membaca.</li>
    <li><strong>Dukungan Selama Persalinan:</strong> Libatkan pasangan Anda untuk memberikan dukungan selama persalinan. Mereka dapat menemani Anda, mengukur kontraksi, dan memberikan kenyamanan.</li>
    <li><strong>Siapkan Diri untuk Pasca Melahirkan:</strong> Luangkan waktu untuk membaca tentang apa yang akan terjadi setelah melahirkan, termasuk pemulihan pasca melahirkan, diastasis recti, kerontokan rambut pasca melahirkan, dan tanda-tanda depresi pasca melahirkan.</li>
</ul>""",
    "tips_mingguan_en": """h2>40 Weeks Pregnant: Things to Consider</h2>
<p>As you await your baby's arrival, here are some things to keep in mind:</p>
<ul>
    <li><strong>Expect Variability in Due Dates:</strong> Don't be surprised if your baby doesn't arrive exactly on their due date. Due dates are just estimates, and pregnancies are considered full-term until 42 weeks.</li>
    <li><strong>Regular Checkups:</strong> During the final weeks, you'll likely have weekly checkups with your healthcare provider to monitor your cervix and the baby's health and movements.</li>
    <li><strong>Self-Indulgence:</strong> Consider these last days as an opportunity for self-care. Treat yourself to activities like a pedicure, watching a movie, or catching up on reading.</li>
    <li><strong>Support During Labor:</strong> Enlist your birth partner to support you during labor. They can keep you company, time contractions, and offer comfort.</li>
    <li><strong>Prepare for Postpartum:</strong> Take some time to read about what to expect after giving birth, including postpartum recovery, diastasis recti, postpartum hair loss, and signs of postpartum depression.</li>
</ul>""",
    "bayi_img_path": "week_40.jpg",
    "ukuran_bayi_img_path": "week_40_pumpkin.svg"
  }
];

List<Map<String, dynamic>> initialTbMasterNewmoon = [
  {'id': 1, 'lunar_month': 1, 'new_moon': '1979-01-28', 'shio': 'Goat'},
  {'id': 2, 'lunar_month': 2, 'new_moon': '1979-02-27', 'shio': 'Goat'},
  {'id': 3, 'lunar_month': 3, 'new_moon': '1979-03-28', 'shio': 'Goat'},
  {'id': 4, 'lunar_month': 4, 'new_moon': '1979-04-26', 'shio': 'Goat'},
  {'id': 5, 'lunar_month': 5, 'new_moon': '1979-05-26', 'shio': 'Goat'},
  {'id': 6, 'lunar_month': 6, 'new_moon': '1979-06-24', 'shio': 'Goat'},
  {'id': 7, 'lunar_month': 6, 'new_moon': '1979-07-24', 'shio': 'Goat'},
  {'id': 8, 'lunar_month': 7, 'new_moon': '1979-08-23', 'shio': 'Goat'},
  {'id': 9, 'lunar_month': 8, 'new_moon': '1979-09-21', 'shio': 'Goat'},
  {'id': 10, 'lunar_month': 9, 'new_moon': '1979-10-21', 'shio': 'Goat'},
  {'id': 11, 'lunar_month': 10, 'new_moon': '1979-11-20', 'shio': 'Goat'},
  {'id': 12, 'lunar_month': 11, 'new_moon': '1979-12-19', 'shio': 'Goat'},
  {'id': 13, 'lunar_month': 12, 'new_moon': '1980-01-18', 'shio': 'Monkey'},
  {'id': 14, 'lunar_month': 1, 'new_moon': '1980-02-16', 'shio': 'Monkey'},
  {'id': 15, 'lunar_month': 2, 'new_moon': '1980-03-17', 'shio': 'Monkey'},
  {'id': 16, 'lunar_month': 3, 'new_moon': '1980-04-15', 'shio': 'Monkey'},
  {'id': 17, 'lunar_month': 4, 'new_moon': '1980-05-14', 'shio': 'Monkey'},
  {'id': 18, 'lunar_month': 5, 'new_moon': '1980-06-13', 'shio': 'Monkey'},
  {'id': 19, 'lunar_month': 6, 'new_moon': '1980-07-12', 'shio': 'Monkey'},
  {'id': 20, 'lunar_month': 7, 'new_moon': '1980-08-11', 'shio': 'Monkey'},
  {'id': 21, 'lunar_month': 8, 'new_moon': '1980-09-09', 'shio': 'Monkey'},
  {'id': 22, 'lunar_month': 9, 'new_moon': '1980-10-09', 'shio': 'Monkey'},
  {'id': 23, 'lunar_month': 10, 'new_moon': '1980-11-08', 'shio': 'Monkey'},
  {'id': 24, 'lunar_month': 11, 'new_moon': '1980-12-07', 'shio': 'Monkey'},
  {'id': 25, 'lunar_month': 12, 'new_moon': '1981-01-06', 'shio': 'Rooster'},
  {'id': 26, 'lunar_month': 1, 'new_moon': '1981-02-05', 'shio': 'Rooster'},
  {'id': 27, 'lunar_month': 2, 'new_moon': '1981-03-06', 'shio': 'Rooster'},
  {'id': 28, 'lunar_month': 3, 'new_moon': '1981-04-05', 'shio': 'Rooster'},
  {'id': 29, 'lunar_month': 4, 'new_moon': '1981-05-04', 'shio': 'Rooster'},
  {'id': 30, 'lunar_month': 5, 'new_moon': '1981-06-02', 'shio': 'Rooster'},
  {'id': 31, 'lunar_month': 6, 'new_moon': '1981-07-02', 'shio': 'Rooster'},
  {'id': 32, 'lunar_month': 7, 'new_moon': '1981-07-31', 'shio': 'Rooster'},
  {'id': 33, 'lunar_month': 8, 'new_moon': '1981-08-29', 'shio': 'Rooster'},
  {'id': 34, 'lunar_month': 9, 'new_moon': '1981-09-28', 'shio': 'Rooster'},
  {'id': 35, 'lunar_month': 10, 'new_moon': '1981-10-28', 'shio': 'Rooster'},
  {'id': 36, 'lunar_month': 11, 'new_moon': '1981-11-26', 'shio': 'Rooster'},
  {'id': 37, 'lunar_month': 12, 'new_moon': '1981-12-26', 'shio': 'Rooster'},
  {'id': 38, 'lunar_month': 1, 'new_moon': '1982-01-25', 'shio': 'Dog'},
  {'id': 39, 'lunar_month': 2, 'new_moon': '1982-02-24', 'shio': 'Dog'},
  {'id': 40, 'lunar_month': 3, 'new_moon': '1982-03-25', 'shio': 'Dog'},
  {'id': 41, 'lunar_month': 4, 'new_moon': '1982-04-24', 'shio': 'Dog'},
  {'id': 42, 'lunar_month': 4, 'new_moon': '1982-05-23', 'shio': 'Dog'},
  {'id': 43, 'lunar_month': 5, 'new_moon': '1982-06-21', 'shio': 'Dog'},
  {'id': 44, 'lunar_month': 6, 'new_moon': '1982-07-21', 'shio': 'Dog'},
  {'id': 45, 'lunar_month': 7, 'new_moon': '1982-08-19', 'shio': 'Dog'},
  {'id': 46, 'lunar_month': 8, 'new_moon': '1982-09-17', 'shio': 'Dog'},
  {'id': 47, 'lunar_month': 9, 'new_moon': '1982-10-17', 'shio': 'Dog'},
  {'id': 48, 'lunar_month': 10, 'new_moon': '1982-11-15', 'shio': 'Dog'},
  {'id': 49, 'lunar_month': 11, 'new_moon': '1982-12-15', 'shio': 'Dog'},
  {'id': 50, 'lunar_month': 12, 'new_moon': '1983-01-14', 'shio': 'Pig'},
  {'id': 51, 'lunar_month': 1, 'new_moon': '1983-02-13', 'shio': 'Pig'},
  {'id': 52, 'lunar_month': 2, 'new_moon': '1983-03-15', 'shio': 'Pig'},
  {'id': 53, 'lunar_month': 3, 'new_moon': '1983-04-13', 'shio': 'Pig'},
  {'id': 54, 'lunar_month': 4, 'new_moon': '1983-05-13', 'shio': 'Pig'},
  {'id': 55, 'lunar_month': 5, 'new_moon': '1983-06-11', 'shio': 'Pig'},
  {'id': 56, 'lunar_month': 6, 'new_moon': '1983-07-10', 'shio': 'Pig'},
  {'id': 57, 'lunar_month': 7, 'new_moon': '1983-08-09', 'shio': 'Pig'},
  {'id': 58, 'lunar_month': 8, 'new_moon': '1983-09-07', 'shio': 'Pig'},
  {'id': 59, 'lunar_month': 9, 'new_moon': '1983-10-06', 'shio': 'Pig'},
  {'id': 60, 'lunar_month': 10, 'new_moon': '1983-11-05', 'shio': 'Pig'},
  {'id': 61, 'lunar_month': 11, 'new_moon': '1983-12-04', 'shio': 'Pig'},
  {'id': 62, 'lunar_month': 12, 'new_moon': '1984-01-03', 'shio': 'Mouse'},
  {'id': 63, 'lunar_month': 1, 'new_moon': '1984-02-02', 'shio': 'Mouse'},
  {'id': 64, 'lunar_month': 2, 'new_moon': '1984-03-03', 'shio': 'Mouse'},
  {'id': 65, 'lunar_month': 3, 'new_moon': '1984-04-01', 'shio': 'Mouse'},
  {'id': 66, 'lunar_month': 4, 'new_moon': '1984-05-01', 'shio': 'Mouse'},
  {'id': 67, 'lunar_month': 5, 'new_moon': '1984-05-31', 'shio': 'Mouse'},
  {'id': 68, 'lunar_month': 6, 'new_moon': '1984-06-29', 'shio': 'Mouse'},
  {'id': 69, 'lunar_month': 7, 'new_moon': '1984-07-28', 'shio': 'Mouse'},
  {'id': 70, 'lunar_month': 8, 'new_moon': '1984-08-27', 'shio': 'Mouse'},
  {'id': 71, 'lunar_month': 9, 'new_moon': '1984-09-25', 'shio': 'Mouse'},
  {'id': 72, 'lunar_month': 10, 'new_moon': '1984-10-24', 'shio': 'Mouse'},
  {'id': 73, 'lunar_month': 10, 'new_moon': '1984-11-23', 'shio': 'Mouse'},
  {'id': 74, 'lunar_month': 11, 'new_moon': '1984-12-22', 'shio': 'Mouse'},
  {'id': 75, 'lunar_month': 12, 'new_moon': '1985-01-21', 'shio': 'Ox'},
  {'id': 76, 'lunar_month': 1, 'new_moon': '1985-02-20', 'shio': 'Ox'},
  {'id': 77, 'lunar_month': 2, 'new_moon': '1985-03-21', 'shio': 'Ox'},
  {'id': 78, 'lunar_month': 3, 'new_moon': '1985-04-20', 'shio': 'Ox'},
  {'id': 79, 'lunar_month': 4, 'new_moon': '1985-05-20', 'shio': 'Ox'},
  {'id': 80, 'lunar_month': 5, 'new_moon': '1985-06-18', 'shio': 'Ox'},
  {'id': 81, 'lunar_month': 6, 'new_moon': '1985-07-18', 'shio': 'Ox'},
  {'id': 82, 'lunar_month': 7, 'new_moon': '1985-08-16', 'shio': 'Ox'},
  {'id': 83, 'lunar_month': 8, 'new_moon': '1985-09-15', 'shio': 'Ox'},
  {'id': 84, 'lunar_month': 9, 'new_moon': '1985-10-14', 'shio': 'Ox'},
  {'id': 85, 'lunar_month': 10, 'new_moon': '1985-11-12', 'shio': 'Ox'},
  {'id': 86, 'lunar_month': 11, 'new_moon': '1985-12-12', 'shio': 'Ox'},
  {'id': 87, 'lunar_month': 12, 'new_moon': '1986-01-10', 'shio': 'Tiger'},
  {'id': 88, 'lunar_month': 1, 'new_moon': '1986-02-09', 'shio': 'Tiger'},
  {'id': 89, 'lunar_month': 2, 'new_moon': '1986-03-10', 'shio': 'Tiger'},
  {'id': 90, 'lunar_month': 3, 'new_moon': '1986-04-09', 'shio': 'Tiger'},
  {'id': 91, 'lunar_month': 4, 'new_moon': '1986-05-09', 'shio': 'Tiger'},
  {'id': 92, 'lunar_month': 5, 'new_moon': '1986-06-07', 'shio': 'Tiger'},
  {'id': 93, 'lunar_month': 6, 'new_moon': '1986-07-07', 'shio': 'Tiger'},
  {'id': 94, 'lunar_month': 7, 'new_moon': '1986-08-06', 'shio': 'Tiger'},
  {'id': 95, 'lunar_month': 8, 'new_moon': '1986-09-04', 'shio': 'Tiger'},
  {'id': 96, 'lunar_month': 9, 'new_moon': '1986-10-04', 'shio': 'Tiger'},
  {'id': 97, 'lunar_month': 10, 'new_moon': '1986-11-02', 'shio': 'Tiger'},
  {'id': 98, 'lunar_month': 11, 'new_moon': '1986-12-02', 'shio': 'Tiger'},
  {'id': 99, 'lunar_month': 12, 'new_moon': '1986-12-31', 'shio': 'Tiger'},
  {'id': 100, 'lunar_month': 1, 'new_moon': '1987-01-29', 'shio': 'Rabbit'},
  {'id': 101, 'lunar_month': 2, 'new_moon': '1987-02-28', 'shio': 'Rabbit'},
  {'id': 102, 'lunar_month': 3, 'new_moon': '1987-03-29', 'shio': 'Rabbit'},
  {'id': 103, 'lunar_month': 4, 'new_moon': '1987-04-28', 'shio': 'Rabbit'},
  {'id': 104, 'lunar_month': 5, 'new_moon': '1987-05-27', 'shio': 'Rabbit'},
  {'id': 105, 'lunar_month': 6, 'new_moon': '1987-06-26', 'shio': 'Rabbit'},
  {'id': 106, 'lunar_month': 6, 'new_moon': '1987-07-26', 'shio': 'Rabbit'},
  {'id': 107, 'lunar_month': 7, 'new_moon': '1987-08-24', 'shio': 'Rabbit'},
  {'id': 108, 'lunar_month': 8, 'new_moon': '1987-09-23', 'shio': 'Rabbit'},
  {'id': 109, 'lunar_month': 9, 'new_moon': '1987-10-23', 'shio': 'Rabbit'},
  {'id': 110, 'lunar_month': 10, 'new_moon': '1987-11-21', 'shio': 'Rabbit'},
  {'id': 111, 'lunar_month': 11, 'new_moon': '1987-12-21', 'shio': 'Rabbit'},
  {'id': 112, 'lunar_month': 12, 'new_moon': '1988-01-19', 'shio': 'Dragon'},
  {'id': 113, 'lunar_month': 1, 'new_moon': '1988-02-17', 'shio': 'Dragon'},
  {'id': 114, 'lunar_month': 2, 'new_moon': '1988-03-18', 'shio': 'Dragon'},
  {'id': 115, 'lunar_month': 3, 'new_moon': '1988-04-16', 'shio': 'Dragon'},
  {'id': 116, 'lunar_month': 4, 'new_moon': '1988-05-16', 'shio': 'Dragon'},
  {'id': 117, 'lunar_month': 5, 'new_moon': '1988-06-14', 'shio': 'Dragon'},
  {'id': 118, 'lunar_month': 6, 'new_moon': '1988-07-14', 'shio': 'Dragon'},
  {'id': 119, 'lunar_month': 7, 'new_moon': '1988-08-12', 'shio': 'Dragon'},
  {'id': 120, 'lunar_month': 8, 'new_moon': '1988-09-11', 'shio': 'Dragon'},
  {'id': 121, 'lunar_month': 9, 'new_moon': '1988-10-11', 'shio': 'Dragon'},
  {'id': 122, 'lunar_month': 10, 'new_moon': '1988-11-09', 'shio': 'Dragon'},
  {'id': 123, 'lunar_month': 11, 'new_moon': '1988-12-09', 'shio': 'Dragon'},
  {'id': 124, 'lunar_month': 12, 'new_moon': '1989-01-08', 'shio': 'Snake'},
  {'id': 125, 'lunar_month': 1, 'new_moon': '1989-02-06', 'shio': 'Snake'},
  {'id': 126, 'lunar_month': 2, 'new_moon': '1989-03-08', 'shio': 'Snake'},
  {'id': 127, 'lunar_month': 3, 'new_moon': '1989-04-06', 'shio': 'Snake'},
  {'id': 128, 'lunar_month': 4, 'new_moon': '1989-05-05', 'shio': 'Snake'},
  {'id': 129, 'lunar_month': 5, 'new_moon': '1989-06-04', 'shio': 'Snake'},
  {'id': 130, 'lunar_month': 6, 'new_moon': '1989-07-03', 'shio': 'Snake'},
  {'id': 131, 'lunar_month': 7, 'new_moon': '1989-08-02', 'shio': 'Snake'},
  {'id': 132, 'lunar_month': 8, 'new_moon': '1989-08-31', 'shio': 'Snake'},
  {'id': 133, 'lunar_month': 9, 'new_moon': '1989-09-30', 'shio': 'Snake'},
  {'id': 134, 'lunar_month': 10, 'new_moon': '1989-10-29', 'shio': 'Snake'},
  {'id': 135, 'lunar_month': 11, 'new_moon': '1989-11-28', 'shio': 'Snake'},
  {'id': 136, 'lunar_month': 12, 'new_moon': '1989-12-28', 'shio': 'Snake'},
  {'id': 137, 'lunar_month': 1, 'new_moon': '1990-01-27', 'shio': 'Horse'},
  {'id': 138, 'lunar_month': 2, 'new_moon': '1990-02-25', 'shio': 'Horse'},
  {'id': 139, 'lunar_month': 3, 'new_moon': '1990-03-27', 'shio': 'Horse'},
  {'id': 140, 'lunar_month': 4, 'new_moon': '1990-04-25', 'shio': 'Horse'},
  {'id': 141, 'lunar_month': 5, 'new_moon': '1990-05-24', 'shio': 'Horse'},
  {'id': 142, 'lunar_month': 5, 'new_moon': '1990-06-23', 'shio': 'Horse'},
  {'id': 143, 'lunar_month': 6, 'new_moon': '1990-07-22', 'shio': 'Horse'},
  {'id': 144, 'lunar_month': 7, 'new_moon': '1990-08-20', 'shio': 'Horse'},
  {'id': 145, 'lunar_month': 8, 'new_moon': '1990-09-19', 'shio': 'Horse'},
  {'id': 146, 'lunar_month': 9, 'new_moon': '1990-10-18', 'shio': 'Horse'},
  {'id': 147, 'lunar_month': 10, 'new_moon': '1990-11-17', 'shio': 'Horse'},
  {'id': 148, 'lunar_month': 11, 'new_moon': '1990-12-17', 'shio': 'Horse'},
  {'id': 149, 'lunar_month': 12, 'new_moon': '1991-01-16', 'shio': 'Goat'},
  {'id': 150, 'lunar_month': 1, 'new_moon': '1991-02-15', 'shio': 'Goat'},
  {'id': 151, 'lunar_month': 2, 'new_moon': '1991-03-16', 'shio': 'Goat'},
  {'id': 152, 'lunar_month': 3, 'new_moon': '1991-04-15', 'shio': 'Goat'},
  {'id': 153, 'lunar_month': 4, 'new_moon': '1991-05-14', 'shio': 'Goat'},
  {'id': 154, 'lunar_month': 5, 'new_moon': '1991-06-12', 'shio': 'Goat'},
  {'id': 155, 'lunar_month': 6, 'new_moon': '1991-07-12', 'shio': 'Goat'},
  {'id': 156, 'lunar_month': 7, 'new_moon': '1991-08-10', 'shio': 'Goat'},
  {'id': 157, 'lunar_month': 8, 'new_moon': '1991-09-08', 'shio': 'Goat'},
  {'id': 158, 'lunar_month': 9, 'new_moon': '1991-10-08', 'shio': 'Goat'},
  {'id': 159, 'lunar_month': 10, 'new_moon': '1991-11-06', 'shio': 'Goat'},
  {'id': 160, 'lunar_month': 11, 'new_moon': '1991-12-06', 'shio': 'Goat'},
  {'id': 161, 'lunar_month': 12, 'new_moon': '1992-01-05', 'shio': 'Monkey'},
  {'id': 162, 'lunar_month': 1, 'new_moon': '1992-02-04', 'shio': 'Monkey'},
  {'id': 163, 'lunar_month': 2, 'new_moon': '1992-03-04', 'shio': 'Monkey'},
  {'id': 164, 'lunar_month': 3, 'new_moon': '1992-04-03', 'shio': 'Monkey'},
  {'id': 165, 'lunar_month': 4, 'new_moon': '1992-05-03', 'shio': 'Monkey'},
  {'id': 166, 'lunar_month': 5, 'new_moon': '1992-06-01', 'shio': 'Monkey'},
  {'id': 167, 'lunar_month': 6, 'new_moon': '1992-06-30', 'shio': 'Monkey'},
  {'id': 168, 'lunar_month': 7, 'new_moon': '1992-07-30', 'shio': 'Monkey'},
  {'id': 169, 'lunar_month': 8, 'new_moon': '1992-08-28', 'shio': 'Monkey'},
  {'id': 170, 'lunar_month': 9, 'new_moon': '1992-09-26', 'shio': 'Monkey'},
  {'id': 171, 'lunar_month': 10, 'new_moon': '1992-10-26', 'shio': 'Monkey'},
  {'id': 172, 'lunar_month': 11, 'new_moon': '1992-11-24', 'shio': 'Monkey'},
  {'id': 173, 'lunar_month': 12, 'new_moon': '1992-12-24', 'shio': 'Monkey'},
  {'id': 174, 'lunar_month': 1, 'new_moon': '1993-01-23', 'shio': 'Rooster'},
  {'id': 175, 'lunar_month': 2, 'new_moon': '1993-02-21', 'shio': 'Rooster'},
  {'id': 176, 'lunar_month': 3, 'new_moon': '1993-03-23', 'shio': 'Rooster'},
  {'id': 177, 'lunar_month': 3, 'new_moon': '1993-04-22', 'shio': 'Rooster'},
  {'id': 178, 'lunar_month': 4, 'new_moon': '1993-05-21', 'shio': 'Rooster'},
  {'id': 179, 'lunar_month': 5, 'new_moon': '1993-06-20', 'shio': 'Rooster'},
  {'id': 180, 'lunar_month': 6, 'new_moon': '1993-07-19', 'shio': 'Rooster'},
  {'id': 181, 'lunar_month': 7, 'new_moon': '1993-08-18', 'shio': 'Rooster'},
  {'id': 182, 'lunar_month': 8, 'new_moon': '1993-09-16', 'shio': 'Rooster'},
  {'id': 183, 'lunar_month': 9, 'new_moon': '1993-10-15', 'shio': 'Rooster'},
  {'id': 184, 'lunar_month': 10, 'new_moon': '1993-11-14', 'shio': 'Rooster'},
  {'id': 185, 'lunar_month': 11, 'new_moon': '1993-12-13', 'shio': 'Rooster'},
  {'id': 186, 'lunar_month': 12, 'new_moon': '1994-01-12', 'shio': 'Dog'},
  {'id': 187, 'lunar_month': 1, 'new_moon': '1994-02-10', 'shio': 'Dog'},
  {'id': 188, 'lunar_month': 2, 'new_moon': '1994-03-12', 'shio': 'Dog'},
  {'id': 189, 'lunar_month': 3, 'new_moon': '1994-04-11', 'shio': 'Dog'},
  {'id': 190, 'lunar_month': 4, 'new_moon': '1994-05-11', 'shio': 'Dog'},
  {'id': 191, 'lunar_month': 5, 'new_moon': '1994-06-09', 'shio': 'Dog'},
  {'id': 192, 'lunar_month': 6, 'new_moon': '1994-07-09', 'shio': 'Dog'},
  {'id': 193, 'lunar_month': 7, 'new_moon': '1994-08-07', 'shio': 'Dog'},
  {'id': 194, 'lunar_month': 8, 'new_moon': '1994-09-06', 'shio': 'Dog'},
  {'id': 195, 'lunar_month': 9, 'new_moon': '1994-10-05', 'shio': 'Dog'},
  {'id': 196, 'lunar_month': 10, 'new_moon': '1994-11-03', 'shio': 'Dog'},
  {'id': 197, 'lunar_month': 11, 'new_moon': '1994-12-03', 'shio': 'Dog'},
  {'id': 198, 'lunar_month': 12, 'new_moon': '1995-01-01', 'shio': 'Pig'},
  {'id': 199, 'lunar_month': 1, 'new_moon': '1995-01-31', 'shio': 'Pig'},
  {'id': 200, 'lunar_month': 2, 'new_moon': '1995-03-02', 'shio': 'Pig'},
  {'id': 201, 'lunar_month': 3, 'new_moon': '1995-03-31', 'shio': 'Pig'},
  {'id': 202, 'lunar_month': 4, 'new_moon': '1995-04-30', 'shio': 'Pig'},
  {'id': 203, 'lunar_month': 5, 'new_moon': '1995-05-29', 'shio': 'Pig'},
  {'id': 204, 'lunar_month': 6, 'new_moon': '1995-06-28', 'shio': 'Pig'},
  {'id': 205, 'lunar_month': 7, 'new_moon': '1995-07-27', 'shio': 'Pig'},
  {'id': 206, 'lunar_month': 8, 'new_moon': '1995-08-26', 'shio': 'Pig'},
  {'id': 207, 'lunar_month': 8, 'new_moon': '1995-09-25', 'shio': 'Pig'},
  {'id': 208, 'lunar_month': 9, 'new_moon': '1995-10-24', 'shio': 'Pig'},
  {'id': 209, 'lunar_month': 10, 'new_moon': '1995-11-22', 'shio': 'Pig'},
  {'id': 210, 'lunar_month': 11, 'new_moon': '1995-12-22', 'shio': 'Pig'},
  {'id': 211, 'lunar_month': 12, 'new_moon': '1996-01-20', 'shio': 'Mouse'},
  {'id': 212, 'lunar_month': 1, 'new_moon': '1996-02-19', 'shio': 'Mouse'},
  {'id': 213, 'lunar_month': 2, 'new_moon': '1996-03-19', 'shio': 'Mouse'},
  {'id': 214, 'lunar_month': 3, 'new_moon': '1996-04-18', 'shio': 'Mouse'},
  {'id': 215, 'lunar_month': 4, 'new_moon': '1996-05-17', 'shio': 'Mouse'},
  {'id': 216, 'lunar_month': 5, 'new_moon': '1996-06-16', 'shio': 'Mouse'},
  {'id': 217, 'lunar_month': 6, 'new_moon': '1996-07-16', 'shio': 'Mouse'},
  {'id': 218, 'lunar_month': 7, 'new_moon': '1996-08-14', 'shio': 'Mouse'},
  {'id': 219, 'lunar_month': 8, 'new_moon': '1996-09-13', 'shio': 'Mouse'},
  {'id': 220, 'lunar_month': 9, 'new_moon': '1996-10-12', 'shio': 'Mouse'},
  {'id': 221, 'lunar_month': 10, 'new_moon': '1996-11-11', 'shio': 'Mouse'},
  {'id': 222, 'lunar_month': 11, 'new_moon': '1996-12-11', 'shio': 'Mouse'},
  {'id': 223, 'lunar_month': 12, 'new_moon': '1997-01-09', 'shio': 'Ox'},
  {'id': 224, 'lunar_month': 1, 'new_moon': '1997-02-07', 'shio': 'Ox'},
  {'id': 225, 'lunar_month': 2, 'new_moon': '1997-03-09', 'shio': 'Ox'},
  {'id': 226, 'lunar_month': 3, 'new_moon': '1997-04-07', 'shio': 'Ox'},
  {'id': 227, 'lunar_month': 4, 'new_moon': '1997-05-07', 'shio': 'Ox'},
  {'id': 228, 'lunar_month': 5, 'new_moon': '1997-06-05', 'shio': 'Ox'},
  {'id': 229, 'lunar_month': 6, 'new_moon': '1997-07-05', 'shio': 'Ox'},
  {'id': 230, 'lunar_month': 7, 'new_moon': '1997-08-03', 'shio': 'Ox'},
  {'id': 231, 'lunar_month': 8, 'new_moon': '1997-09-02', 'shio': 'Ox'},
  {'id': 232, 'lunar_month': 9, 'new_moon': '1997-10-02', 'shio': 'Ox'},
  {'id': 233, 'lunar_month': 10, 'new_moon': '1997-10-31', 'shio': 'Ox'},
  {'id': 234, 'lunar_month': 11, 'new_moon': '1997-11-30', 'shio': 'Ox'},
  {'id': 235, 'lunar_month': 12, 'new_moon': '1997-12-30', 'shio': 'Ox'},
  {'id': 236, 'lunar_month': 1, 'new_moon': '1998-01-28', 'shio': 'Tiger'},
  {'id': 237, 'lunar_month': 2, 'new_moon': '1998-02-27', 'shio': 'Tiger'},
  {'id': 238, 'lunar_month': 3, 'new_moon': '1998-03-28', 'shio': 'Tiger'},
  {'id': 239, 'lunar_month': 4, 'new_moon': '1998-04-26', 'shio': 'Tiger'},
  {'id': 240, 'lunar_month': 5, 'new_moon': '1998-05-26', 'shio': 'Tiger'},
  {'id': 241, 'lunar_month': 5, 'new_moon': '1998-06-24', 'shio': 'Tiger'},
  {'id': 242, 'lunar_month': 6, 'new_moon': '1998-07-23', 'shio': 'Tiger'},
  {'id': 243, 'lunar_month': 7, 'new_moon': '1998-08-22', 'shio': 'Tiger'},
  {'id': 244, 'lunar_month': 8, 'new_moon': '1998-09-21', 'shio': 'Tiger'},
  {'id': 245, 'lunar_month': 9, 'new_moon': '1998-10-20', 'shio': 'Tiger'},
  {'id': 246, 'lunar_month': 10, 'new_moon': '1998-11-19', 'shio': 'Tiger'},
  {'id': 247, 'lunar_month': 11, 'new_moon': '1998-12-19', 'shio': 'Tiger'},
  {'id': 248, 'lunar_month': 12, 'new_moon': '1999-01-17', 'shio': 'Rabbit'},
  {'id': 249, 'lunar_month': 1, 'new_moon': '1999-02-16', 'shio': 'Rabbit'},
  {'id': 250, 'lunar_month': 2, 'new_moon': '1999-03-18', 'shio': 'Rabbit'},
  {'id': 251, 'lunar_month': 3, 'new_moon': '1999-04-16', 'shio': 'Rabbit'},
  {'id': 252, 'lunar_month': 4, 'new_moon': '1999-05-15', 'shio': 'Rabbit'},
  {'id': 253, 'lunar_month': 5, 'new_moon': '1999-06-14', 'shio': 'Rabbit'},
  {'id': 254, 'lunar_month': 6, 'new_moon': '1999-07-13', 'shio': 'Rabbit'},
  {'id': 255, 'lunar_month': 7, 'new_moon': '1999-08-11', 'shio': 'Rabbit'},
  {'id': 256, 'lunar_month': 8, 'new_moon': '1999-09-10', 'shio': 'Rabbit'},
  {'id': 257, 'lunar_month': 9, 'new_moon': '1999-10-09', 'shio': 'Rabbit'},
  {'id': 258, 'lunar_month': 10, 'new_moon': '1999-11-08', 'shio': 'Rabbit'},
  {'id': 259, 'lunar_month': 11, 'new_moon': '1999-12-08', 'shio': 'Rabbit'},
  {'id': 260, 'lunar_month': 12, 'new_moon': '2000-01-07', 'shio': 'Dragon'},
  {'id': 261, 'lunar_month': 1, 'new_moon': '2000-02-05', 'shio': 'Dragon'},
  {'id': 262, 'lunar_month': 2, 'new_moon': '2000-03-06', 'shio': 'Dragon'},
  {'id': 263, 'lunar_month': 3, 'new_moon': '2000-04-05', 'shio': 'Dragon'},
  {'id': 264, 'lunar_month': 4, 'new_moon': '2000-05-04', 'shio': 'Dragon'},
  {'id': 265, 'lunar_month': 5, 'new_moon': '2000-06-02', 'shio': 'Dragon'},
  {'id': 266, 'lunar_month': 6, 'new_moon': '2000-07-02', 'shio': 'Dragon'},
  {'id': 267, 'lunar_month': 7, 'new_moon': '2000-07-31', 'shio': 'Dragon'},
  {'id': 268, 'lunar_month': 8, 'new_moon': '2000-08-29', 'shio': 'Dragon'},
  {'id': 269, 'lunar_month': 9, 'new_moon': '2000-09-28', 'shio': 'Dragon'},
  {'id': 270, 'lunar_month': 10, 'new_moon': '2000-10-27', 'shio': 'Dragon'},
  {'id': 271, 'lunar_month': 11, 'new_moon': '2000-11-26', 'shio': 'Dragon'},
  {'id': 272, 'lunar_month': 12, 'new_moon': '2000-12-26', 'shio': 'Dragon'},
  {'id': 273, 'lunar_month': 1, 'new_moon': '2001-01-24', 'shio': 'Snake'},
  {'id': 274, 'lunar_month': 2, 'new_moon': '2001-02-23', 'shio': 'Snake'},
  {'id': 275, 'lunar_month': 3, 'new_moon': '2001-03-25', 'shio': 'Snake'},
  {'id': 276, 'lunar_month': 4, 'new_moon': '2001-04-23', 'shio': 'Snake'},
  {'id': 277, 'lunar_month': 4, 'new_moon': '2001-05-23', 'shio': 'Snake'},
  {'id': 278, 'lunar_month': 5, 'new_moon': '2001-06-21', 'shio': 'Snake'},
  {'id': 279, 'lunar_month': 6, 'new_moon': '2001-07-21', 'shio': 'Snake'},
  {'id': 280, 'lunar_month': 7, 'new_moon': '2001-08-19', 'shio': 'Snake'},
  {'id': 281, 'lunar_month': 8, 'new_moon': '2001-09-17', 'shio': 'Snake'},
  {'id': 282, 'lunar_month': 9, 'new_moon': '2001-10-17', 'shio': 'Snake'},
  {'id': 283, 'lunar_month': 10, 'new_moon': '2001-11-15', 'shio': 'Snake'},
  {'id': 284, 'lunar_month': 11, 'new_moon': '2001-12-15', 'shio': 'Snake'},
  {'id': 285, 'lunar_month': 12, 'new_moon': '2002-01-13', 'shio': 'Horse'},
  {'id': 286, 'lunar_month': 1, 'new_moon': '2002-02-12', 'shio': 'Horse'},
  {'id': 287, 'lunar_month': 2, 'new_moon': '2002-03-14', 'shio': 'Horse'},
  {'id': 288, 'lunar_month': 3, 'new_moon': '2002-04-13', 'shio': 'Horse'},
  {'id': 289, 'lunar_month': 4, 'new_moon': '2002-05-12', 'shio': 'Horse'},
  {'id': 290, 'lunar_month': 5, 'new_moon': '2002-06-11', 'shio': 'Horse'},
  {'id': 291, 'lunar_month': 6, 'new_moon': '2002-07-10', 'shio': 'Horse'},
  {'id': 292, 'lunar_month': 7, 'new_moon': '2002-08-09', 'shio': 'Horse'},
  {'id': 293, 'lunar_month': 8, 'new_moon': '2002-09-07', 'shio': 'Horse'},
  {'id': 294, 'lunar_month': 9, 'new_moon': '2002-10-06', 'shio': 'Horse'},
  {'id': 295, 'lunar_month': 10, 'new_moon': '2002-11-05', 'shio': 'Horse'},
  {'id': 296, 'lunar_month': 11, 'new_moon': '2002-12-04', 'shio': 'Horse'},
  {'id': 297, 'lunar_month': 12, 'new_moon': '2003-01-03', 'shio': 'Goat'},
  {'id': 298, 'lunar_month': 1, 'new_moon': '2003-02-01', 'shio': 'Goat'},
  {'id': 299, 'lunar_month': 2, 'new_moon': '2003-03-03', 'shio': 'Goat'},
  {'id': 300, 'lunar_month': 3, 'new_moon': '2003-04-02', 'shio': 'Goat'},
  {'id': 301, 'lunar_month': 4, 'new_moon': '2003-05-01', 'shio': 'Goat'},
  {'id': 302, 'lunar_month': 5, 'new_moon': '2003-05-31', 'shio': 'Goat'},
  {'id': 303, 'lunar_month': 6, 'new_moon': '2003-06-30', 'shio': 'Goat'},
  {'id': 304, 'lunar_month': 7, 'new_moon': '2003-07-29', 'shio': 'Goat'},
  {'id': 305, 'lunar_month': 8, 'new_moon': '2003-08-28', 'shio': 'Goat'},
  {'id': 306, 'lunar_month': 9, 'new_moon': '2003-09-26', 'shio': 'Goat'},
  {'id': 307, 'lunar_month': 10, 'new_moon': '2003-10-25', 'shio': 'Goat'},
  {'id': 308, 'lunar_month': 11, 'new_moon': '2003-11-24', 'shio': 'Goat'},
  {'id': 309, 'lunar_month': 12, 'new_moon': '2003-12-23', 'shio': 'Goat'},
  {'id': 310, 'lunar_month': 1, 'new_moon': '2004-01-22', 'shio': 'Monkey'},
  {'id': 311, 'lunar_month': 2, 'new_moon': '2004-02-20', 'shio': 'Monkey'},
  {'id': 312, 'lunar_month': 2, 'new_moon': '2004-03-21', 'shio': 'Monkey'},
  {'id': 313, 'lunar_month': 3, 'new_moon': '2004-04-19', 'shio': 'Monkey'},
  {'id': 314, 'lunar_month': 4, 'new_moon': '2004-05-19', 'shio': 'Monkey'},
  {'id': 315, 'lunar_month': 5, 'new_moon': '2004-06-18', 'shio': 'Monkey'},
  {'id': 316, 'lunar_month': 6, 'new_moon': '2004-07-17', 'shio': 'Monkey'},
  {'id': 317, 'lunar_month': 7, 'new_moon': '2004-08-16', 'shio': 'Monkey'},
  {'id': 318, 'lunar_month': 8, 'new_moon': '2004-09-14', 'shio': 'Monkey'},
  {'id': 319, 'lunar_month': 9, 'new_moon': '2004-10-14', 'shio': 'Monkey'},
  {'id': 320, 'lunar_month': 10, 'new_moon': '2004-11-12', 'shio': 'Monkey'},
  {'id': 321, 'lunar_month': 11, 'new_moon': '2004-12-12', 'shio': 'Monkey'},
  {'id': 322, 'lunar_month': 12, 'new_moon': '2005-01-10', 'shio': 'Rooster'},
  {'id': 323, 'lunar_month': 1, 'new_moon': '2005-02-09', 'shio': 'Rooster'},
  {'id': 324, 'lunar_month': 2, 'new_moon': '2005-03-10', 'shio': 'Rooster'},
  {'id': 325, 'lunar_month': 3, 'new_moon': '2005-04-09', 'shio': 'Rooster'},
  {'id': 326, 'lunar_month': 4, 'new_moon': '2005-05-08', 'shio': 'Rooster'},
  {'id': 327, 'lunar_month': 5, 'new_moon': '2005-06-07', 'shio': 'Rooster'},
  {'id': 328, 'lunar_month': 6, 'new_moon': '2005-07-06', 'shio': 'Rooster'},
  {'id': 329, 'lunar_month': 7, 'new_moon': '2005-08-05', 'shio': 'Rooster'},
  {'id': 330, 'lunar_month': 8, 'new_moon': '2005-09-04', 'shio': 'Rooster'},
  {'id': 331, 'lunar_month': 9, 'new_moon': '2005-10-03', 'shio': 'Rooster'},
  {'id': 332, 'lunar_month': 10, 'new_moon': '2005-11-02', 'shio': 'Rooster'},
  {'id': 333, 'lunar_month': 11, 'new_moon': '2005-12-01', 'shio': 'Rooster'},
  {'id': 334, 'lunar_month': 12, 'new_moon': '2005-12-31', 'shio': 'Rooster'},
  {'id': 335, 'lunar_month': 1, 'new_moon': '2006-01-29', 'shio': 'Dog'},
  {'id': 336, 'lunar_month': 2, 'new_moon': '2006-02-28', 'shio': 'Dog'},
  {'id': 337, 'lunar_month': 3, 'new_moon': '2006-03-29', 'shio': 'Dog'},
  {'id': 338, 'lunar_month': 4, 'new_moon': '2006-04-28', 'shio': 'Dog'},
  {'id': 339, 'lunar_month': 5, 'new_moon': '2006-05-27', 'shio': 'Dog'},
  {'id': 340, 'lunar_month': 6, 'new_moon': '2006-06-26', 'shio': 'Dog'},
  {'id': 341, 'lunar_month': 7, 'new_moon': '2006-07-25', 'shio': 'Dog'},
  {'id': 342, 'lunar_month': 7, 'new_moon': '2006-08-24', 'shio': 'Dog'},
  {'id': 343, 'lunar_month': 8, 'new_moon': '2006-09-22', 'shio': 'Dog'},
  {'id': 344, 'lunar_month': 9, 'new_moon': '2006-10-22', 'shio': 'Dog'},
  {'id': 345, 'lunar_month': 10, 'new_moon': '2006-11-21', 'shio': 'Dog'},
  {'id': 346, 'lunar_month': 11, 'new_moon': '2006-12-20', 'shio': 'Dog'},
  {'id': 347, 'lunar_month': 12, 'new_moon': '2007-01-19', 'shio': 'Pig'},
  {'id': 348, 'lunar_month': 1, 'new_moon': '2007-02-18', 'shio': 'Pig'},
  {'id': 349, 'lunar_month': 2, 'new_moon': '2007-03-19', 'shio': 'Pig'},
  {'id': 350, 'lunar_month': 3, 'new_moon': '2007-04-17', 'shio': 'Pig'},
  {'id': 351, 'lunar_month': 4, 'new_moon': '2007-05-17', 'shio': 'Pig'},
  {'id': 352, 'lunar_month': 5, 'new_moon': '2007-06-15', 'shio': 'Pig'},
  {'id': 353, 'lunar_month': 6, 'new_moon': '2007-07-14', 'shio': 'Pig'},
  {'id': 354, 'lunar_month': 7, 'new_moon': '2007-08-13', 'shio': 'Pig'},
  {'id': 355, 'lunar_month': 8, 'new_moon': '2007-09-11', 'shio': 'Pig'},
  {'id': 356, 'lunar_month': 9, 'new_moon': '2007-10-11', 'shio': 'Pig'},
  {'id': 357, 'lunar_month': 10, 'new_moon': '2007-11-10', 'shio': 'Pig'},
  {'id': 358, 'lunar_month': 11, 'new_moon': '2007-12-10', 'shio': 'Pig'},
  {'id': 359, 'lunar_month': 12, 'new_moon': '2008-01-08', 'shio': 'Mouse'},
  {'id': 360, 'lunar_month': 1, 'new_moon': '2008-02-07', 'shio': 'Mouse'},
  {'id': 361, 'lunar_month': 2, 'new_moon': '2008-03-08', 'shio': 'Mouse'},
  {'id': 362, 'lunar_month': 3, 'new_moon': '2008-04-06', 'shio': 'Mouse'},
  {'id': 363, 'lunar_month': 4, 'new_moon': '2008-05-05', 'shio': 'Mouse'},
  {'id': 364, 'lunar_month': 5, 'new_moon': '2008-06-04', 'shio': 'Mouse'},
  {'id': 365, 'lunar_month': 6, 'new_moon': '2008-07-03', 'shio': 'Mouse'},
  {'id': 366, 'lunar_month': 7, 'new_moon': '2008-08-01', 'shio': 'Mouse'},
  {'id': 367, 'lunar_month': 8, 'new_moon': '2008-08-31', 'shio': 'Mouse'},
  {'id': 368, 'lunar_month': 9, 'new_moon': '2008-09-29', 'shio': 'Mouse'},
  {'id': 369, 'lunar_month': 10, 'new_moon': '2008-10-29', 'shio': 'Mouse'},
  {'id': 370, 'lunar_month': 11, 'new_moon': '2008-11-28', 'shio': 'Mouse'},
  {'id': 371, 'lunar_month': 12, 'new_moon': '2008-12-27', 'shio': 'Mouse'},
  {'id': 372, 'lunar_month': 1, 'new_moon': '2009-01-26', 'shio': 'Ox'},
  {'id': 373, 'lunar_month': 2, 'new_moon': '2009-02-25', 'shio': 'Ox'},
  {'id': 374, 'lunar_month': 3, 'new_moon': '2009-03-27', 'shio': 'Ox'},
  {'id': 375, 'lunar_month': 4, 'new_moon': '2009-04-25', 'shio': 'Ox'},
  {'id': 376, 'lunar_month': 5, 'new_moon': '2009-05-24', 'shio': 'Ox'},
  {'id': 377, 'lunar_month': 5, 'new_moon': '2009-06-23', 'shio': 'Ox'},
  {'id': 378, 'lunar_month': 6, 'new_moon': '2009-07-22', 'shio': 'Ox'},
  {'id': 379, 'lunar_month': 7, 'new_moon': '2009-08-20', 'shio': 'Ox'},
  {'id': 380, 'lunar_month': 8, 'new_moon': '2009-09-19', 'shio': 'Ox'},
  {'id': 381, 'lunar_month': 9, 'new_moon': '2009-10-18', 'shio': 'Ox'},
  {'id': 382, 'lunar_month': 10, 'new_moon': '2009-11-17', 'shio': 'Ox'},
  {'id': 383, 'lunar_month': 11, 'new_moon': '2009-12-16', 'shio': 'Ox'},
  {'id': 384, 'lunar_month': 12, 'new_moon': '2010-01-15', 'shio': 'Tiger'},
  {'id': 385, 'lunar_month': 1, 'new_moon': '2010-02-14', 'shio': 'Tiger'},
  {'id': 386, 'lunar_month': 2, 'new_moon': '2010-03-16', 'shio': 'Tiger'},
  {'id': 387, 'lunar_month': 3, 'new_moon': '2010-04-14', 'shio': 'Tiger'},
  {'id': 388, 'lunar_month': 4, 'new_moon': '2010-05-14', 'shio': 'Tiger'},
  {'id': 389, 'lunar_month': 5, 'new_moon': '2010-06-12', 'shio': 'Tiger'},
  {'id': 390, 'lunar_month': 6, 'new_moon': '2010-07-12', 'shio': 'Tiger'},
  {'id': 391, 'lunar_month': 7, 'new_moon': '2010-08-10', 'shio': 'Tiger'},
  {'id': 392, 'lunar_month': 8, 'new_moon': '2010-09-08', 'shio': 'Tiger'},
  {'id': 393, 'lunar_month': 9, 'new_moon': '2010-10-08', 'shio': 'Tiger'},
  {'id': 394, 'lunar_month': 10, 'new_moon': '2010-11-06', 'shio': 'Tiger'},
  {'id': 395, 'lunar_month': 11, 'new_moon': '2010-12-06', 'shio': 'Tiger'},
  {'id': 396, 'lunar_month': 12, 'new_moon': '2011-01-04', 'shio': 'Rabbit'},
  {'id': 397, 'lunar_month': 1, 'new_moon': '2011-02-03', 'shio': 'Rabbit'},
  {'id': 398, 'lunar_month': 2, 'new_moon': '2011-03-05', 'shio': 'Rabbit'},
  {'id': 399, 'lunar_month': 3, 'new_moon': '2011-04-03', 'shio': 'Rabbit'},
  {'id': 400, 'lunar_month': 4, 'new_moon': '2011-05-03', 'shio': 'Rabbit'},
  {'id': 401, 'lunar_month': 5, 'new_moon': '2011-06-02', 'shio': 'Rabbit'},
  {'id': 402, 'lunar_month': 6, 'new_moon': '2011-07-01', 'shio': 'Rabbit'},
  {'id': 403, 'lunar_month': 7, 'new_moon': '2011-07-31', 'shio': 'Rabbit'},
  {'id': 404, 'lunar_month': 8, 'new_moon': '2011-08-29', 'shio': 'Rabbit'},
  {'id': 405, 'lunar_month': 9, 'new_moon': '2011-09-27', 'shio': 'Rabbit'},
  {'id': 406, 'lunar_month': 10, 'new_moon': '2011-10-27', 'shio': 'Rabbit'},
  {'id': 407, 'lunar_month': 11, 'new_moon': '2011-11-25', 'shio': 'Rabbit'},
  {'id': 408, 'lunar_month': 12, 'new_moon': '2011-12-25', 'shio': 'Rabbit'},
  {'id': 409, 'lunar_month': 1, 'new_moon': '2012-01-23', 'shio': 'Dragon'},
  {'id': 410, 'lunar_month': 2, 'new_moon': '2012-02-22', 'shio': 'Dragon'},
  {'id': 411, 'lunar_month': 3, 'new_moon': '2012-03-22', 'shio': 'Dragon'},
  {'id': 412, 'lunar_month': 4, 'new_moon': '2012-04-21', 'shio': 'Dragon'},
  {'id': 413, 'lunar_month': 4, 'new_moon': '2012-05-21', 'shio': 'Dragon'},
  {'id': 414, 'lunar_month': 5, 'new_moon': '2012-06-19', 'shio': 'Dragon'},
  {'id': 415, 'lunar_month': 6, 'new_moon': '2012-07-19', 'shio': 'Dragon'},
  {'id': 416, 'lunar_month': 7, 'new_moon': '2012-08-17', 'shio': 'Dragon'},
  {'id': 417, 'lunar_month': 8, 'new_moon': '2012-09-16', 'shio': 'Dragon'},
  {'id': 418, 'lunar_month': 9, 'new_moon': '2012-10-15', 'shio': 'Dragon'},
  {'id': 419, 'lunar_month': 10, 'new_moon': '2012-11-14', 'shio': 'Dragon'},
  {'id': 420, 'lunar_month': 11, 'new_moon': '2012-12-13', 'shio': 'Dragon'},
  {'id': 421, 'lunar_month': 12, 'new_moon': '2013-01-12', 'shio': 'Snake'},
  {'id': 422, 'lunar_month': 1, 'new_moon': '2013-02-10', 'shio': 'Snake'},
  {'id': 423, 'lunar_month': 2, 'new_moon': '2013-03-12', 'shio': 'Snake'},
  {'id': 424, 'lunar_month': 3, 'new_moon': '2013-04-10', 'shio': 'Snake'},
  {'id': 425, 'lunar_month': 4, 'new_moon': '2013-05-10', 'shio': 'Snake'},
  {'id': 426, 'lunar_month': 5, 'new_moon': '2013-06-08', 'shio': 'Snake'},
  {'id': 427, 'lunar_month': 6, 'new_moon': '2013-07-08', 'shio': 'Snake'},
  {'id': 428, 'lunar_month': 7, 'new_moon': '2013-08-07', 'shio': 'Snake'},
  {'id': 429, 'lunar_month': 8, 'new_moon': '2013-09-05', 'shio': 'Snake'},
  {'id': 430, 'lunar_month': 9, 'new_moon': '2013-10-05', 'shio': 'Snake'},
  {'id': 431, 'lunar_month': 10, 'new_moon': '2013-11-03', 'shio': 'Snake'},
  {'id': 432, 'lunar_month': 11, 'new_moon': '2013-12-03', 'shio': 'Snake'},
  {'id': 433, 'lunar_month': 12, 'new_moon': '2014-01-01', 'shio': 'Horse'},
  {'id': 434, 'lunar_month': 1, 'new_moon': '2014-01-31', 'shio': 'Horse'},
  {'id': 435, 'lunar_month': 2, 'new_moon': '2014-03-01', 'shio': 'Horse'},
  {'id': 436, 'lunar_month': 3, 'new_moon': '2014-03-31', 'shio': 'Horse'},
  {'id': 437, 'lunar_month': 4, 'new_moon': '2014-04-29', 'shio': 'Horse'},
  {'id': 438, 'lunar_month': 5, 'new_moon': '2014-05-29', 'shio': 'Horse'},
  {'id': 439, 'lunar_month': 6, 'new_moon': '2014-06-27', 'shio': 'Horse'},
  {'id': 440, 'lunar_month': 7, 'new_moon': '2014-07-27', 'shio': 'Horse'},
  {'id': 441, 'lunar_month': 8, 'new_moon': '2014-08-25', 'shio': 'Horse'},
  {'id': 442, 'lunar_month': 9, 'new_moon': '2014-09-24', 'shio': 'Horse'},
  {'id': 443, 'lunar_month': 9, 'new_moon': '2014-10-24', 'shio': 'Horse'},
  {'id': 444, 'lunar_month': 10, 'new_moon': '2014-11-22', 'shio': 'Horse'},
  {'id': 445, 'lunar_month': 11, 'new_moon': '2014-12-22', 'shio': 'Horse'},
  {'id': 446, 'lunar_month': 12, 'new_moon': '2015-01-20', 'shio': 'Goat'},
  {'id': 447, 'lunar_month': 1, 'new_moon': '2015-02-19', 'shio': 'Goat'},
  {'id': 448, 'lunar_month': 2, 'new_moon': '2015-03-20', 'shio': 'Goat'},
  {'id': 449, 'lunar_month': 3, 'new_moon': '2015-04-19', 'shio': 'Goat'},
  {'id': 450, 'lunar_month': 4, 'new_moon': '2015-05-18', 'shio': 'Goat'},
  {'id': 451, 'lunar_month': 5, 'new_moon': '2015-06-16', 'shio': 'Goat'},
  {'id': 452, 'lunar_month': 6, 'new_moon': '2015-07-16', 'shio': 'Goat'},
  {'id': 453, 'lunar_month': 7, 'new_moon': '2015-08-14', 'shio': 'Goat'},
  {'id': 454, 'lunar_month': 8, 'new_moon': '2015-09-13', 'shio': 'Goat'},
  {'id': 455, 'lunar_month': 9, 'new_moon': '2015-10-13', 'shio': 'Goat'},
  {'id': 456, 'lunar_month': 10, 'new_moon': '2015-11-12', 'shio': 'Goat'},
  {'id': 457, 'lunar_month': 11, 'new_moon': '2015-12-11', 'shio': 'Goat'},
  {'id': 458, 'lunar_month': 12, 'new_moon': '2016-01-10', 'shio': 'Monkey'},
  {'id': 459, 'lunar_month': 1, 'new_moon': '2016-02-08', 'shio': 'Monkey'},
  {'id': 460, 'lunar_month': 2, 'new_moon': '2016-03-09', 'shio': 'Monkey'},
  {'id': 461, 'lunar_month': 3, 'new_moon': '2016-04-07', 'shio': 'Monkey'},
  {'id': 462, 'lunar_month': 4, 'new_moon': '2016-05-07', 'shio': 'Monkey'},
  {'id': 463, 'lunar_month': 5, 'new_moon': '2016-06-05', 'shio': 'Monkey'},
  {'id': 464, 'lunar_month': 6, 'new_moon': '2016-07-04', 'shio': 'Monkey'},
  {'id': 465, 'lunar_month': 7, 'new_moon': '2016-08-03', 'shio': 'Monkey'},
  {'id': 466, 'lunar_month': 8, 'new_moon': '2016-09-01', 'shio': 'Monkey'},
  {'id': 467, 'lunar_month': 9, 'new_moon': '2016-10-01', 'shio': 'Monkey'},
  {'id': 468, 'lunar_month': 10, 'new_moon': '2016-10-31', 'shio': 'Monkey'},
  {'id': 469, 'lunar_month': 11, 'new_moon': '2016-11-29', 'shio': 'Monkey'},
  {'id': 470, 'lunar_month': 12, 'new_moon': '2016-12-29', 'shio': 'Monkey'},
  {'id': 471, 'lunar_month': 1, 'new_moon': '2017-01-28', 'shio': 'Rooster'},
  {'id': 472, 'lunar_month': 2, 'new_moon': '2017-02-26', 'shio': 'Rooster'},
  {'id': 473, 'lunar_month': 3, 'new_moon': '2017-03-28', 'shio': 'Rooster'},
  {'id': 474, 'lunar_month': 4, 'new_moon': '2017-04-26', 'shio': 'Rooster'},
  {'id': 475, 'lunar_month': 5, 'new_moon': '2017-05-26', 'shio': 'Rooster'},
  {'id': 476, 'lunar_month': 6, 'new_moon': '2017-06-24', 'shio': 'Rooster'},
  {'id': 477, 'lunar_month': 6, 'new_moon': '2017-07-23', 'shio': 'Rooster'},
  {'id': 478, 'lunar_month': 7, 'new_moon': '2017-08-22', 'shio': 'Rooster'},
  {'id': 479, 'lunar_month': 8, 'new_moon': '2017-09-20', 'shio': 'Rooster'},
  {'id': 480, 'lunar_month': 9, 'new_moon': '2017-10-20', 'shio': 'Rooster'},
  {'id': 481, 'lunar_month': 10, 'new_moon': '2017-11-18', 'shio': 'Rooster'},
  {'id': 482, 'lunar_month': 11, 'new_moon': '2017-12-18', 'shio': 'Rooster'},
  {'id': 483, 'lunar_month': 12, 'new_moon': '2018-01-17', 'shio': 'Dog'},
  {'id': 484, 'lunar_month': 1, 'new_moon': '2018-02-16', 'shio': 'Dog'},
  {'id': 485, 'lunar_month': 2, 'new_moon': '2018-03-17', 'shio': 'Dog'},
  {'id': 486, 'lunar_month': 3, 'new_moon': '2018-04-16', 'shio': 'Dog'},
  {'id': 487, 'lunar_month': 4, 'new_moon': '2018-05-15', 'shio': 'Dog'},
  {'id': 488, 'lunar_month': 5, 'new_moon': '2018-06-14', 'shio': 'Dog'},
  {'id': 489, 'lunar_month': 6, 'new_moon': '2018-07-13', 'shio': 'Dog'},
  {'id': 490, 'lunar_month': 7, 'new_moon': '2018-08-11', 'shio': 'Dog'},
  {'id': 491, 'lunar_month': 8, 'new_moon': '2018-09-10', 'shio': 'Dog'},
  {'id': 492, 'lunar_month': 9, 'new_moon': '2018-10-09', 'shio': 'Dog'},
  {'id': 493, 'lunar_month': 10, 'new_moon': '2018-11-08', 'shio': 'Dog'},
  {'id': 494, 'lunar_month': 11, 'new_moon': '2018-12-07', 'shio': 'Dog'},
  {'id': 495, 'lunar_month': 12, 'new_moon': '2019-01-06', 'shio': 'Pig'},
  {'id': 496, 'lunar_month': 1, 'new_moon': '2019-02-05', 'shio': 'Pig'},
  {'id': 497, 'lunar_month': 2, 'new_moon': '2019-03-07', 'shio': 'Pig'},
  {'id': 498, 'lunar_month': 3, 'new_moon': '2019-04-05', 'shio': 'Pig'},
  {'id': 499, 'lunar_month': 4, 'new_moon': '2019-05-05', 'shio': 'Pig'},
  {'id': 500, 'lunar_month': 5, 'new_moon': '2019-06-03', 'shio': 'Pig'},
  {'id': 501, 'lunar_month': 6, 'new_moon': '2019-07-03', 'shio': 'Pig'},
  {'id': 502, 'lunar_month': 7, 'new_moon': '2019-08-01', 'shio': 'Pig'},
  {'id': 503, 'lunar_month': 8, 'new_moon': '2019-08-30', 'shio': 'Pig'},
  {'id': 504, 'lunar_month': 9, 'new_moon': '2019-09-29', 'shio': 'Pig'},
  {'id': 505, 'lunar_month': 10, 'new_moon': '2019-10-28', 'shio': 'Pig'},
  {'id': 506, 'lunar_month': 11, 'new_moon': '2019-11-26', 'shio': 'Pig'},
  {'id': 507, 'lunar_month': 12, 'new_moon': '2019-12-26', 'shio': 'Pig'},
  {'id': 508, 'lunar_month': 1, 'new_moon': '2020-01-25', 'shio': 'Mouse'},
  {'id': 509, 'lunar_month': 2, 'new_moon': '2020-02-23', 'shio': 'Mouse'},
  {'id': 510, 'lunar_month': 3, 'new_moon': '2020-03-24', 'shio': 'Mouse'},
  {'id': 511, 'lunar_month': 4, 'new_moon': '2020-04-23', 'shio': 'Mouse'},
  {'id': 512, 'lunar_month': 4, 'new_moon': '2020-05-23', 'shio': 'Mouse'},
  {'id': 513, 'lunar_month': 5, 'new_moon': '2020-06-21', 'shio': 'Mouse'},
  {'id': 514, 'lunar_month': 6, 'new_moon': '2020-07-21', 'shio': 'Mouse'},
  {'id': 515, 'lunar_month': 7, 'new_moon': '2020-08-19', 'shio': 'Mouse'},
  {'id': 516, 'lunar_month': 8, 'new_moon': '2020-09-17', 'shio': 'Mouse'},
  {'id': 517, 'lunar_month': 9, 'new_moon': '2020-10-17', 'shio': 'Mouse'},
  {'id': 518, 'lunar_month': 10, 'new_moon': '2020-11-15', 'shio': 'Mouse'},
  {'id': 519, 'lunar_month': 11, 'new_moon': '2020-12-15', 'shio': 'Mouse'},
  {'id': 520, 'lunar_month': 12, 'new_moon': '2021-01-13', 'shio': 'Ox'},
  {'id': 521, 'lunar_month': 1, 'new_moon': '2021-02-12', 'shio': 'Ox'},
  {'id': 522, 'lunar_month': 2, 'new_moon': '2021-03-13', 'shio': 'Ox'},
  {'id': 523, 'lunar_month': 3, 'new_moon': '2021-04-12', 'shio': 'Ox'},
  {'id': 524, 'lunar_month': 4, 'new_moon': '2021-05-12', 'shio': 'Ox'},
  {'id': 525, 'lunar_month': 5, 'new_moon': '2021-06-10', 'shio': 'Ox'},
  {'id': 526, 'lunar_month': 6, 'new_moon': '2021-07-10', 'shio': 'Ox'},
  {'id': 527, 'lunar_month': 7, 'new_moon': '2021-08-08', 'shio': 'Ox'},
  {'id': 528, 'lunar_month': 8, 'new_moon': '2021-09-07', 'shio': 'Ox'},
  {'id': 529, 'lunar_month': 9, 'new_moon': '2021-10-06', 'shio': 'Ox'},
  {'id': 530, 'lunar_month': 10, 'new_moon': '2021-11-05', 'shio': 'Ox'},
  {'id': 531, 'lunar_month': 11, 'new_moon': '2021-12-04', 'shio': 'Ox'},
  {'id': 532, 'lunar_month': 12, 'new_moon': '2022-01-03', 'shio': 'Tiger'},
  {'id': 533, 'lunar_month': 1, 'new_moon': '2022-02-01', 'shio': 'Tiger'},
  {'id': 534, 'lunar_month': 2, 'new_moon': '2022-03-03', 'shio': 'Tiger'},
  {'id': 535, 'lunar_month': 3, 'new_moon': '2022-04-01', 'shio': 'Tiger'},
  {'id': 536, 'lunar_month': 4, 'new_moon': '2022-05-01', 'shio': 'Tiger'},
  {'id': 537, 'lunar_month': 5, 'new_moon': '2022-06-30', 'shio': 'Tiger'},
  {'id': 538, 'lunar_month': 6, 'new_moon': '2022-07-29', 'shio': 'Tiger'},
  {'id': 539, 'lunar_month': 7, 'new_moon': '2022-08-29', 'shio': 'Tiger'},
  {'id': 540, 'lunar_month': 8, 'new_moon': '2022-08-27', 'shio': 'Tiger'},
  {'id': 541, 'lunar_month': 9, 'new_moon': '2022-09-26', 'shio': 'Tiger'},
  {'id': 542, 'lunar_month': 10, 'new_moon': '2022-10-25', 'shio': 'Tiger'},
  {'id': 543, 'lunar_month': 11, 'new_moon': '2022-11-24', 'shio': 'Tiger'},
  {'id': 544, 'lunar_month': 12, 'new_moon': '2022-12-23', 'shio': 'Tiger'},
  {'id': 545, 'lunar_month': 1, 'new_moon': '2023-01-22', 'shio': 'Rabbit'},
  {'id': 546, 'lunar_month': 2, 'new_moon': '2023-02-20', 'shio': 'Rabbit'},
  {'id': 547, 'lunar_month': 2, 'new_moon': '2023-03-22', 'shio': 'Rabbit'},
  {'id': 548, 'lunar_month': 3, 'new_moon': '2023-04-20', 'shio': 'Rabbit'},
  {'id': 549, 'lunar_month': 4, 'new_moon': '2023-05-19', 'shio': 'Rabbit'},
  {'id': 550, 'lunar_month': 5, 'new_moon': '2023-06-18', 'shio': 'Rabbit'},
  {'id': 551, 'lunar_month': 6, 'new_moon': '2023-07-18', 'shio': 'Rabbit'},
  {'id': 552, 'lunar_month': 7, 'new_moon': '2023-08-16', 'shio': 'Rabbit'},
  {'id': 553, 'lunar_month': 8, 'new_moon': '2023-09-15', 'shio': 'Rabbit'},
  {'id': 554, 'lunar_month': 9, 'new_moon': '2023-10-15', 'shio': 'Rabbit'},
  {'id': 555, 'lunar_month': 10, 'new_moon': '2023-11-13', 'shio': 'Rabbit'},
  {'id': 556, 'lunar_month': 11, 'new_moon': '2023-12-13', 'shio': 'Rabbit'},
  {'id': 557, 'lunar_month': 12, 'new_moon': '2024-01-11', 'shio': 'Dragon'},
  {'id': 558, 'lunar_month': 1, 'new_moon': '2024-02-10', 'shio': 'Dragon'},
  {'id': 559, 'lunar_month': 2, 'new_moon': '2024-03-10', 'shio': 'Dragon'},
  {'id': 560, 'lunar_month': 3, 'new_moon': '2024-04-09', 'shio': 'Dragon'},
  {'id': 561, 'lunar_month': 4, 'new_moon': '2024-05-08', 'shio': 'Dragon'},
  {'id': 562, 'lunar_month': 5, 'new_moon': '2024-06-06', 'shio': 'Dragon'},
  {'id': 563, 'lunar_month': 6, 'new_moon': '2024-07-06', 'shio': 'Dragon'},
  {'id': 564, 'lunar_month': 7, 'new_moon': '2024-08-04', 'shio': 'Dragon'},
  {'id': 565, 'lunar_month': 8, 'new_moon': '2024-09-03', 'shio': 'Dragon'},
  {'id': 566, 'lunar_month': 9, 'new_moon': '2024-10-03', 'shio': 'Dragon'},
  {'id': 567, 'lunar_month': 10, 'new_moon': '2024-11-01', 'shio': 'Dragon'},
  {'id': 568, 'lunar_month': 11, 'new_moon': '2024-12-01', 'shio': 'Dragon'},
  {'id': 569, 'lunar_month': 12, 'new_moon': '2024-12-31', 'shio': 'Dragon'},
  {'id': 570, 'lunar_month': 1, 'new_moon': '2025-01-29', 'shio': 'Snake'},
  {'id': 571, 'lunar_month': 2, 'new_moon': '2025-02-28', 'shio': 'Snake'},
  {'id': 572, 'lunar_month': 3, 'new_moon': '2025-03-29', 'shio': 'Snake'},
  {'id': 573, 'lunar_month': 4, 'new_moon': '2025-04-28', 'shio': 'Snake'},
  {'id': 574, 'lunar_month': 5, 'new_moon': '2025-05-27', 'shio': 'Snake'},
  {'id': 575, 'lunar_month': 6, 'new_moon': '2025-06-25', 'shio': 'Snake'},
  {'id': 576, 'lunar_month': 6, 'new_moon': '2025-07-25', 'shio': 'Snake'},
  {'id': 577, 'lunar_month': 7, 'new_moon': '2025-08-23', 'shio': 'Snake'},
  {'id': 578, 'lunar_month': 8, 'new_moon': '2025-09-22', 'shio': 'Snake'},
  {'id': 579, 'lunar_month': 9, 'new_moon': '2025-10-21', 'shio': 'Snake'},
  {'id': 580, 'lunar_month': 10, 'new_moon': '2025-11-20', 'shio': 'Snake'},
  {'id': 581, 'lunar_month': 11, 'new_moon': '2025-12-20', 'shio': 'Snake'},
  {'id': 582, 'lunar_month': 12, 'new_moon': '2026-01-19', 'shio': 'Horse'},
  {'id': 583, 'lunar_month': 1, 'new_moon': '2026-02-17', 'shio': 'Horse'},
  {'id': 584, 'lunar_month': 2, 'new_moon': '2026-03-19', 'shio': 'Horse'},
  {'id': 585, 'lunar_month': 3, 'new_moon': '2026-04-17', 'shio': 'Horse'},
  {'id': 586, 'lunar_month': 4, 'new_moon': '2026-05-17', 'shio': 'Horse'},
  {'id': 587, 'lunar_month': 5, 'new_moon': '2026-06-15', 'shio': 'Horse'},
  {'id': 588, 'lunar_month': 6, 'new_moon': '2026-07-14', 'shio': 'Horse'},
  {'id': 589, 'lunar_month': 7, 'new_moon': '2026-08-13', 'shio': 'Horse'},
  {'id': 590, 'lunar_month': 8, 'new_moon': '2026-09-11', 'shio': 'Horse'},
  {'id': 591, 'lunar_month': 9, 'new_moon': '2026-10-10', 'shio': 'Horse'},
  {'id': 592, 'lunar_month': 10, 'new_moon': '2026-11-09', 'shio': 'Horse'},
  {'id': 593, 'lunar_month': 11, 'new_moon': '2026-12-09', 'shio': 'Horse'},
  {'id': 594, 'lunar_month': 12, 'new_moon': '2027-01-08', 'shio': 'Goat'},
  {'id': 595, 'lunar_month': 1, 'new_moon': '2027-02-06', 'shio': 'Goat'},
  {'id': 596, 'lunar_month': 2, 'new_moon': '2027-03-08', 'shio': 'Goat'},
  {'id': 597, 'lunar_month': 3, 'new_moon': '2027-04-07', 'shio': 'Goat'},
  {'id': 598, 'lunar_month': 4, 'new_moon': '2027-05-06', 'shio': 'Goat'},
  {'id': 599, 'lunar_month': 5, 'new_moon': '2027-06-05', 'shio': 'Goat'},
  {'id': 600, 'lunar_month': 6, 'new_moon': '2027-07-04', 'shio': 'Goat'},
  {'id': 601, 'lunar_month': 7, 'new_moon': '2027-08-02', 'shio': 'Goat'},
  {'id': 602, 'lunar_month': 8, 'new_moon': '2027-09-01', 'shio': 'Goat'},
  {'id': 603, 'lunar_month': 9, 'new_moon': '2027-09-30', 'shio': 'Goat'},
  {'id': 604, 'lunar_month': 10, 'new_moon': '2027-10-29', 'shio': 'Goat'},
  {'id': 605, 'lunar_month': 11, 'new_moon': '2027-11-28', 'shio': 'Goat'},
  {'id': 606, 'lunar_month': 12, 'new_moon': '2027-12-28', 'shio': 'Goat'},
  {'id': 607, 'lunar_month': 1, 'new_moon': '2028-01-26', 'shio': 'Monkey'},
  {'id': 608, 'lunar_month': 2, 'new_moon': '2028-02-25', 'shio': 'Monkey'},
  {'id': 609, 'lunar_month': 3, 'new_moon': '2028-03-26', 'shio': 'Monkey'},
  {'id': 610, 'lunar_month': 4, 'new_moon': '2028-04-25', 'shio': 'Monkey'},
  {'id': 611, 'lunar_month': 5, 'new_moon': '2028-05-24', 'shio': 'Monkey'},
  {'id': 612, 'lunar_month': 5, 'new_moon': '2028-06-23', 'shio': 'Monkey'},
  {'id': 613, 'lunar_month': 6, 'new_moon': '2028-07-22', 'shio': 'Monkey'},
  {'id': 614, 'lunar_month': 7, 'new_moon': '2028-08-20', 'shio': 'Monkey'},
  {'id': 615, 'lunar_month': 8, 'new_moon': '2028-09-19', 'shio': 'Monkey'},
  {'id': 616, 'lunar_month': 9, 'new_moon': '2028-10-18', 'shio': 'Monkey'},
  {'id': 617, 'lunar_month': 10, 'new_moon': '2028-11-16', 'shio': 'Monkey'},
  {'id': 618, 'lunar_month': 11, 'new_moon': '2028-12-16', 'shio': 'Monkey'},
  {'id': 619, 'lunar_month': 12, 'new_moon': '2029-01-15', 'shio': 'Rooster'},
  {'id': 620, 'lunar_month': 1, 'new_moon': '2029-02-13', 'shio': 'Rooster'},
  {'id': 621, 'lunar_month': 2, 'new_moon': '2029-03-15', 'shio': 'Rooster'},
  {'id': 622, 'lunar_month': 3, 'new_moon': '2029-04-14', 'shio': 'Rooster'},
  {'id': 623, 'lunar_month': 4, 'new_moon': '2029-05-13', 'shio': 'Rooster'},
  {'id': 624, 'lunar_month': 5, 'new_moon': '2029-06-12', 'shio': 'Rooster'},
  {'id': 625, 'lunar_month': 6, 'new_moon': '2029-07-11', 'shio': 'Rooster'},
  {'id': 626, 'lunar_month': 7, 'new_moon': '2029-08-10', 'shio': 'Rooster'},
  {'id': 627, 'lunar_month': 8, 'new_moon': '2029-09-08', 'shio': 'Rooster'},
  {'id': 628, 'lunar_month': 9, 'new_moon': '2029-10-08', 'shio': 'Rooster'},
  {'id': 629, 'lunar_month': 10, 'new_moon': '2029-11-06', 'shio': 'Rooster'},
  {'id': 630, 'lunar_month': 11, 'new_moon': '2029-12-05', 'shio': 'Rooster'},
  {'id': 631, 'lunar_month': 12, 'new_moon': '2030-01-04', 'shio': 'Dog'},
  {'id': 632, 'lunar_month': 1, 'new_moon': '2030-02-03', 'shio': 'Dog'},
  {'id': 633, 'lunar_month': 2, 'new_moon': '2030-03-04', 'shio': 'Dog'},
  {'id': 634, 'lunar_month': 3, 'new_moon': '2030-04-03', 'shio': 'Dog'},
  {'id': 635, 'lunar_month': 4, 'new_moon': '2030-05-02', 'shio': 'Dog'},
  {'id': 636, 'lunar_month': 5, 'new_moon': '2030-06-01', 'shio': 'Dog'},
  {'id': 637, 'lunar_month': 6, 'new_moon': '2030-07-01', 'shio': 'Dog'},
  {'id': 638, 'lunar_month': 7, 'new_moon': '2030-07-30', 'shio': 'Dog'},
  {'id': 639, 'lunar_month': 8, 'new_moon': '2030-08-29', 'shio': 'Dog'},
  {'id': 640, 'lunar_month': 9, 'new_moon': '2030-09-27', 'shio': 'Dog'},
  {'id': 641, 'lunar_month': 10, 'new_moon': '2030-10-27', 'shio': 'Dog'},
  {'id': 642, 'lunar_month': 11, 'new_moon': '2030-11-25', 'shio': 'Dog'},
  {'id': 643, 'lunar_month': 12, 'new_moon': '2030-12-25', 'shio': 'Dog'}
];

List<Map<String, dynamic>> initialTbMasterNewmoonPhase = [
  {'id': 1, 'year': 2019, 'new_moon': '2019-01-06'},
  {'id': 2, 'year': 2019, 'new_moon': '2019-02-05'},
  {'id': 3, 'year': 2019, 'new_moon': '2019-03-06'},
  {'id': 4, 'year': 2019, 'new_moon': '2019-04-05'},
  {'id': 5, 'year': 2019, 'new_moon': '2019-05-05'},
  {'id': 6, 'year': 2019, 'new_moon': '2019-06-03'},
  {'id': 7, 'year': 2019, 'new_moon': '2019-07-03'},
  {'id': 8, 'year': 2019, 'new_moon': '2019-08-01'},
  {'id': 9, 'year': 2019, 'new_moon': '2019-08-30'},
  {'id': 10, 'year': 2019, 'new_moon': '2019-09-29'},
  {'id': 11, 'year': 2019, 'new_moon': '2019-10-28'},
  {'id': 12, 'year': 2019, 'new_moon': '2019-11-26'},
  {'id': 13, 'year': 2019, 'new_moon': '2019-12-26'},
  {'id': 14, 'year': 2020, 'new_moon': '2020-01-25'},
  {'id': 15, 'year': 2020, 'new_moon': '2020-02-23'},
  {'id': 16, 'year': 2020, 'new_moon': '2020-03-24'},
  {'id': 17, 'year': 2020, 'new_moon': '2020-04-23'},
  {'id': 18, 'year': 2020, 'new_moon': '2020-05-23'},
  {'id': 19, 'year': 2020, 'new_moon': '2020-06-21'},
  {'id': 20, 'year': 2020, 'new_moon': '2020-07-21'},
  {'id': 21, 'year': 2020, 'new_moon': '2020-08-19'},
  {'id': 22, 'year': 2020, 'new_moon': '2020-09-17'},
  {'id': 23, 'year': 2020, 'new_moon': '2020-10-17'},
  {'id': 24, 'year': 2020, 'new_moon': '2020-11-15'},
  {'id': 25, 'year': 2020, 'new_moon': '2020-12-14'},
  {'id': 26, 'year': 2021, 'new_moon': '2021-01-13'},
  {'id': 27, 'year': 2021, 'new_moon': '2021-02-12'},
  {'id': 28, 'year': 2021, 'new_moon': '2021-03-13'},
  {'id': 29, 'year': 2021, 'new_moon': '2021-04-12'},
  {'id': 30, 'year': 2021, 'new_moon': '2021-05-12'},
  {'id': 31, 'year': 2021, 'new_moon': '2021-06-10'},
  {'id': 32, 'year': 2021, 'new_moon': '2021-07-10'},
  {'id': 33, 'year': 2021, 'new_moon': '2021-08-08'},
  {'id': 34, 'year': 2021, 'new_moon': '2021-09-07'},
  {'id': 35, 'year': 2021, 'new_moon': '2021-10-06'},
  {'id': 36, 'year': 2021, 'new_moon': '2021-11-05'},
  {'id': 37, 'year': 2021, 'new_moon': '2021-12-04'},
  {'id': 38, 'year': 2022, 'new_moon': '2022-01-03'},
  {'id': 39, 'year': 2022, 'new_moon': '2022-02-01'},
  {'id': 40, 'year': 2022, 'new_moon': '2022-03-03'},
  {'id': 41, 'year': 2022, 'new_moon': '2022-04-01'},
  {'id': 42, 'year': 2022, 'new_moon': '2022-05-01'},
  {'id': 43, 'year': 2022, 'new_moon': '2022-05-30'},
  {'id': 44, 'year': 2022, 'new_moon': '2022-06-29'},
  {'id': 45, 'year': 2022, 'new_moon': '2022-07-29'},
  {'id': 46, 'year': 2022, 'new_moon': '2022-08-27'},
  {'id': 47, 'year': 2022, 'new_moon': '2022-09-26'},
  {'id': 48, 'year': 2022, 'new_moon': '2022-10-25'},
  {'id': 49, 'year': 2022, 'new_moon': '2022-11-24'},
  {'id': 50, 'year': 2022, 'new_moon': '2022-12-23'},
  {'id': 51, 'year': 2023, 'new_moon': '2023-01-22'},
  {'id': 52, 'year': 2023, 'new_moon': '2023-02-20'},
  {'id': 53, 'year': 2023, 'new_moon': '2023-03-22'},
  {'id': 54, 'year': 2023, 'new_moon': '2023-04-20'},
  {'id': 55, 'year': 2023, 'new_moon': '2023-05-19'},
  {'id': 56, 'year': 2023, 'new_moon': '2023-06-18'},
  {'id': 57, 'year': 2023, 'new_moon': '2023-07-18'},
  {'id': 58, 'year': 2023, 'new_moon': '2023-08-16'},
  {'id': 59, 'year': 2023, 'new_moon': '2023-09-15'},
  {'id': 60, 'year': 2023, 'new_moon': '2023-10-15'},
  {'id': 61, 'year': 2023, 'new_moon': '2023-11-13'},
  {'id': 62, 'year': 2023, 'new_moon': '2023-12-13'},
  {'id': 63, 'year': 2024, 'new_moon': '2024-01-11'},
  {'id': 64, 'year': 2024, 'new_moon': '2024-02-10'},
  {'id': 65, 'year': 2024, 'new_moon': '2024-03-10'},
  {'id': 66, 'year': 2024, 'new_moon': '2024-04-09'},
  {'id': 67, 'year': 2024, 'new_moon': '2024-05-08'},
  {'id': 68, 'year': 2024, 'new_moon': '2024-06-06'},
  {'id': 69, 'year': 2024, 'new_moon': '2024-07-06'},
  {'id': 70, 'year': 2024, 'new_moon': '2024-08-04'},
  {'id': 71, 'year': 2024, 'new_moon': '2024-09-03'},
  {'id': 72, 'year': 2024, 'new_moon': '2024-10-03'},
  {'id': 73, 'year': 2024, 'new_moon': '2024-11-01'},
  {'id': 74, 'year': 2024, 'new_moon': '2024-12-01'},
  {'id': 75, 'year': 2024, 'new_moon': '2024-12-31'},
  {'id': 76, 'year': 2025, 'new_moon': '2024-12-31'},
  {'id': 77, 'year': 2025, 'new_moon': '2025-01-29'},
  {'id': 78, 'year': 2025, 'new_moon': '2025-02-28'},
  {'id': 79, 'year': 2025, 'new_moon': '2025-03-29'},
  {'id': 80, 'year': 2025, 'new_moon': '2025-04-28'},
  {'id': 81, 'year': 2025, 'new_moon': '2025-05-27'},
  {'id': 82, 'year': 2025, 'new_moon': '2025-06-25'},
  {'id': 83, 'year': 2025, 'new_moon': '2025-07-25'},
  {'id': 84, 'year': 2025, 'new_moon': '2025-08-23'},
  {'id': 85, 'year': 2025, 'new_moon': '2025-09-22'},
  {'id': 86, 'year': 2025, 'new_moon': '2025-10-21'},
  {'id': 87, 'year': 2025, 'new_moon': '2025-11-20'},
  {'id': 88, 'year': 2025, 'new_moon': '2025-12-20'},
  {'id': 89, 'year': 2026, 'new_moon': '2026-01-19'},
  {'id': 90, 'year': 2026, 'new_moon': '2026-02-17'},
  {'id': 91, 'year': 2026, 'new_moon': '2026-03-19'},
  {'id': 92, 'year': 2026, 'new_moon': '2026-04-17'},
  {'id': 93, 'year': 2026, 'new_moon': '2026-05-17'},
  {'id': 94, 'year': 2026, 'new_moon': '2026-06-15'},
  {'id': 95, 'year': 2026, 'new_moon': '2026-07-14'},
  {'id': 96, 'year': 2026, 'new_moon': '2026-08-13'},
  {'id': 97, 'year': 2026, 'new_moon': '2026-09-11'},
  {'id': 98, 'year': 2026, 'new_moon': '2026-10-10'},
  {'id': 99, 'year': 2026, 'new_moon': '2026-11-09'},
  {'id': 100, 'year': 2026, 'new_moon': '2026-12-09'},
  {'id': 101, 'year': 2027, 'new_moon': '2027-01-08'},
  {'id': 102, 'year': 2027, 'new_moon': '2027-02-06'},
  {'id': 103, 'year': 2027, 'new_moon': '2027-03-08'},
  {'id': 104, 'year': 2027, 'new_moon': '2027-04-07'},
  {'id': 105, 'year': 2027, 'new_moon': '2027-05-06'},
  {'id': 106, 'year': 2027, 'new_moon': '2027-06-05'},
  {'id': 107, 'year': 2027, 'new_moon': '2027-07-04'},
  {'id': 108, 'year': 2027, 'new_moon': '2027-08-02'},
  {'id': 109, 'year': 2027, 'new_moon': '2027-09-01'},
  {'id': 110, 'year': 2027, 'new_moon': '2027-09-30'},
  {'id': 111, 'year': 2027, 'new_moon': '2027-10-29'},
  {'id': 112, 'year': 2027, 'new_moon': '2027-11-28'},
  {'id': 113, 'year': 2027, 'new_moon': '2027-12-28'},
  {'id': 114, 'year': 2028, 'new_moon': '2028-01-26'},
  {'id': 115, 'year': 2028, 'new_moon': '2028-02-25'},
  {'id': 116, 'year': 2028, 'new_moon': '2028-03-26'},
  {'id': 117, 'year': 2028, 'new_moon': '2028-04-25'},
  {'id': 118, 'year': 2028, 'new_moon': '2028-05-24'},
  {'id': 119, 'year': 2028, 'new_moon': '2028-06-23'},
  {'id': 120, 'year': 2028, 'new_moon': '2028-07-22'},
  {'id': 121, 'year': 2028, 'new_moon': '2028-08-20'},
  {'id': 122, 'year': 2028, 'new_moon': '2028-09-19'},
  {'id': 123, 'year': 2028, 'new_moon': '2028-10-18'},
  {'id': 124, 'year': 2028, 'new_moon': '2028-11-16'},
  {'id': 125, 'year': 2028, 'new_moon': '2028-12-16'},
  {'id': 126, 'year': 2029, 'new_moon': '2029-01-15'},
  {'id': 127, 'year': 2029, 'new_moon': '2029-02-13'},
  {'id': 128, 'year': 2029, 'new_moon': '2029-03-15'},
  {'id': 129, 'year': 2029, 'new_moon': '2029-04-14'},
  {'id': 130, 'year': 2029, 'new_moon': '2029-05-13'},
  {'id': 131, 'year': 2029, 'new_moon': '2029-06-12'},
  {'id': 132, 'year': 2029, 'new_moon': '2029-07-11'},
  {'id': 133, 'year': 2029, 'new_moon': '2029-08-10'},
  {'id': 134, 'year': 2029, 'new_moon': '2029-09-08'},
  {'id': 135, 'year': 2029, 'new_moon': '2029-10-08'},
  {'id': 136, 'year': 2029, 'new_moon': '2029-11-06'},
  {'id': 137, 'year': 2029, 'new_moon': '2029-12-05'},
  {'id': 138, 'year': 2030, 'new_moon': '2030-01-04'},
  {'id': 139, 'year': 2030, 'new_moon': '2030-02-02'},
  {'id': 140, 'year': 2030, 'new_moon': '2030-03-04'},
  {'id': 141, 'year': 2030, 'new_moon': '2030-04-03'},
  {'id': 142, 'year': 2030, 'new_moon': '2030-05-02'},
  {'id': 143, 'year': 2030, 'new_moon': '2030-06-01'},
  {'id': 144, 'year': 2030, 'new_moon': '2030-07-01'},
  {'id': 145, 'year': 2030, 'new_moon': '2030-07-30'},
  {'id': 146, 'year': 2030, 'new_moon': '2030-08-29'},
  {'id': 147, 'year': 2030, 'new_moon': '2030-09-27'},
  {'id': 148, 'year': 2030, 'new_moon': '2030-10-27'},
  {'id': 149, 'year': 2030, 'new_moon': '2030-11-25'},
  {'id': 150, 'year': 2030, 'new_moon': '2030-12-25'}
];

List<Map<String, dynamic>> initialTbMasterFood = [
  {
    "id": 1,
    "food_id": "Makanan Laut Mentah (misalnya Sushi, sashimi, tiramisu mentah, kerang mentah, scallop mentah, ceviche)",
    "food_en": "Raw Seafood (e.g Sushi, sashimi, raw oysters, raw clams, raw scallops, ceviche)",
    "description_id": "Makanan laut mentah dapat mengandung parasit atau bakteri seperti Listeria, yang dapat menyebabkan penyakit pada ibu hamil dan mungkin membahayakan bayi.",
    "description_en": "Raw seafood can contain parasites or bacteria like Listeria, which can cause illness in pregnant women and may harm the baby.",
    "food_safety": "Unsafe",
    "created_at": "2024-08-09 16:44:44",
    "updated_at": "2024-08-09 16:44:44"
  },
  {
    "id": 2,
    "food_id": "Makanan Laut Asap (misalnya Salmon asap dingin, trout, ikan putih, cod, tuna, mackerel)",
    "food_en": "Smoked Seafood (e.g Cold-smoked salmon, trout, whitefish, cod, tuna, mackerel)",
    "description_id": "Makanan laut asap yang didinginkan mungkin mengandung Listeria, yang berbahaya selama kehamilan. Aman untuk dimakan hanya jika dimasak hingga suhu internal 165°F (74°C) atau jika dikemas dalam kaleng atau tahan rak.",
    "description_en": "Refrigerated smoked seafood may contain Listeria, which is harmful during pregnancy. It's safe to eat only if it’s cooked to an internal temperature of 165°F (74°C) or if it’s canned or shelf-stable.",
    "food_safety": "Unsafe",
    "created_at": "2024-08-09 16:44:44",
    "updated_at": "2024-08-09 16:44:44"
  },
  {
    "id": 3,
    "food_id": "Ikan Bermerkuri Tinggi (Shark, swordfish, king mackerel, bigeye tuna, marlin, tilefish, orange roughy)",
    "food_en": "High-Mercury Fish (Shark, swordfish, king mackerel, bigeye tuna, marlin, tilefish, orange roughy)",
    "description_id": "Ikan bermerkuri tinggi dapat merusak sistem saraf, sistem kekebalan tubuh, dan ginjal serta menyebabkan masalah perkembangan pada anak-anak. Sebaiknya hindari ikan ini selama kehamilan dan menyusui.",
    "description_en": "High-mercury fish can damage the nervous system, immune system, and kidneys and cause developmental issues in children. It’s best to avoid them during pregnancy and breastfeeding.",
    "food_safety": "Unsafe",
    "created_at": "2024-08-09 16:44:44",
    "updated_at": "2024-08-09 16:44:44"
  },
  {
    "id": 4,
    "food_id": "Jus atau Cider Tidak Dipasteurisasi (misalnya Jus segar, cider tidak dipasteurisasi)",
    "food_en": "Unpasteurized Juice or Cider (e.g Fresh-squeezed juice, unpasteurized cider)",
    "description_id": "Jus tidak dipasteurisasi dapat mengandung bakteri berbahaya seperti E. coli. Lebih aman memilih versi yang dipasteurisasi atau merebus jus tidak dipasteurisasi selama setidaknya satu menit sebelum diminum.",
    "description_en": "Unpasteurized juice can contain harmful bacteria like E. coli. It’s safer to choose pasteurized versions or boil unpasteurized juice for at least one minute before drinking.",
    "food_safety": "Unsafe",
    "created_at": "2024-08-09 16:44:44",
    "updated_at": "2024-08-09 16:44:44"
  },
  {
    "id": 5,
    "food_id": "Produk Susu Mentah (misalnya Susu mentah, keju lembut seperti Brie, feta, camembert, queso blanco)",
    "food_en": "Raw Milk Products (e.g Raw milk, soft cheeses like Brie, feta, camembert, queso blanco)",
    "description_id": "Susu mentah dan produk yang terbuat darinya mungkin mengandung bakteri berbahaya seperti Listeria. Hanya konsumsi susu dan produk susu yang dipasteurisasi selama kehamilan.",
    "description_en": "Raw milk and products made from it may contain harmful bacteria like Listeria. Only consume pasteurized milk and milk products during pregnancy.",
    "food_safety": "Unsafe",
    "created_at": "2024-08-09 16:44:44",
    "updated_at": "2024-08-09 16:44:44"
  },
  {
    "id": 6,
    "food_id": "Telur Setengah Matang (misalnya Dressing salad Caesar buatan sendiri, tiramisu, eggs benedict, adonan mentah)",
    "food_en": "Undercooked Eggs (e.g Homemade Caesar salad dressing, tiramisu, eggs benedict, raw batter)",
    "description_id": "Telur setengah matang mungkin mengandung Salmonella. Pastikan telur matang sepenuhnya dan hindari makanan yang dibuat dengan telur mentah selama kehamilan.",
    "description_en": "Undercooked eggs may contain Salmonella. Ensure eggs are fully cooked and avoid foods made with raw eggs during pregnancy.",
    "food_safety": "Unsafe",
    "created_at": "2024-08-09 16:44:44",
    "updated_at": "2024-08-09 16:44:44"
  },
  {"id": 7, "food_id": "Salad Siap Saji (misalnya Salad ham, ayam, atau makanan laut siap saji)", "food_en": "Premade Salads (e.g Premade ham, chicken, seafood salads)", "description_id": "Salad ini mungkin mengandung Listeria, yang berbahaya selama kehamilan.", "description_en": "These salads may contain Listeria, which is dangerous during pregnancy.", "food_safety": "Unsafe", "created_at": "2024-08-09 16:44:44", "updated_at": "2024-08-09 16:44:44"},
  {
    "id": 8,
    "food_id": "Tunas Mentah (misalnya Alfalfa, clover, kacang hijau, tunas lobak)",
    "food_en": "Raw Sprouts (e.g Alfalfa, clover, mung bean, radish sprouts)",
    "description_id": "Tunas mentah mungkin mengandung bakteri berbahaya seperti E. coli atau Salmonella. Masak tunas hingga matang sebelum dimakan.",
    "description_en": "Raw sprouts may contain harmful bacteria like E. coli or Salmonella. Cook sprouts thoroughly before eating.",
    "food_safety": "Unsafe",
    "created_at": "2024-08-09 16:44:44",
    "updated_at": "2024-08-09 16:44:44"
  },
  {
    "id": 9,
    "food_id": "Daging dan Unggas Setengah Matang",
    "food_en": "Undercooked Meat and Poultry",
    "description_id": "Daging dan unggas setengah matang dapat mengandung bakteri berbahaya seperti Salmonella atau E. coli. Pastikan mereka dimasak hingga suhu internal yang direkomendasikan.",
    "description_en": "Undercooked meat and poultry can contain harmful bacteria like Salmonella or E. coli. Ensure they are cooked to the recommended internal temperatures.",
    "food_safety": "Unsafe",
    "created_at": "2024-08-09 16:44:44",
    "updated_at": "2024-08-09 16:44:44"
  },
  {
    "id": 10,
    "food_id": "Hot Dog dan Daging Selingan (misalnya Hot dog, potongan dingin, daging gaya deli)",
    "food_en": "Hot Dogs and Luncheon Meats (e.g Hot dogs, cold cuts, deli-style meats)",
    "description_id": "Daging ini mungkin mengandung Listeria. Panaskan hingga mendidih atau 165°F (74°C) sebelum dikonsumsi selama kehamilan.",
    "description_en": "These meats may contain Listeria. Reheat them to steaming hot or 165°F (74°C) before consuming during pregnancy.",
    "food_safety": "Unsafe",
    "created_at": "2024-08-09 16:44:44",
    "updated_at": "2024-08-09 16:44:44"
  },
  {"id": 11, "food_id": "Saus Daging atau Pâté (misalnya Pâté yang didinginkan, saus daging dari deli)", "food_en": "Meat Spreads or Pâté (e.g Refrigerated pâté, meat spreads from delis)", "description_id": "Ini mungkin mengandung Listeria. Pilih versi kalengan atau tahan rak sebagai gantinya.", "description_en": "These may contain Listeria. Choose canned or shelf-stable versions instead.", "food_safety": "Unsafe", "created_at": "2024-08-09 16:44:44", "updated_at": "2024-08-09 16:44:44"},
  {"id": 12, "food_id": "Adonan Mentah", "food_en": "Raw Dough", "description_id": "Adonan mentah dapat mengandung bakteri berbahaya seperti E. coli atau Salmonella. Selalu panggang atau masak adonan sebelum dimakan.", "description_en": "Raw dough can contain harmful bacteria like E. coli or Salmonella. Always bake or cook dough before eating.", "food_safety": "Unsafe", "created_at": "2024-08-09 16:44:44", "updated_at": "2024-08-09 16:44:44"},
  {"id": 13, "food_id": "Buah dan Sayuran Tidak Dicuci", "food_en": "Unwashed Fruits and Vegetables", "description_id": "Buah dan sayuran yang tidak dicuci mungkin mengandung bakteri seperti E. coli atau Listeria. Cuci dengan bersih sebelum dimakan.", "description_en": "Unwashed produce may contain bacteria like E. coli or Listeria. Wash thoroughly before eating.", "food_safety": "Unsafe", "created_at": "2024-08-09 16:44:44", "updated_at": "2024-08-09 16:44:44"},
  {
    "id": 14,
    "food_id": "Makanan Olahan (misalnya Camilan kemasan, sereal manis, makanan beku)",
    "food_en": "Processed Foods (e.g Packaged snacks, sugary cereals, frozen meals)",
    "description_id": "Makanan olahan seringkali rendah nutrisi dan tinggi kalori, gula, dan lemak tidak sehat. Pilih makanan dan camilan bergizi selama kehamilan.",
    "description_en": "Processed foods are often low in nutrients and high in calories, sugar, and unhealthy fats. Opt for nutritious meals and snacks during pregnancy.",
    "food_safety": "Caution",
    "created_at": "2024-08-09 16:44:44",
    "updated_at": "2024-08-09 16:44:44"
  },
  {"id": 15, "food_id": "Alkohol", "food_en": "Alcohol", "description_id": "Alkohol meningkatkan risiko komplikasi kehamilan dan sindrom alkohol janin. Sebaiknya hindari alkohol sepenuhnya selama kehamilan.", "description_en": "Alcohol increases the risk of pregnancy complications and fetal alcohol syndrome. It’s best to avoid alcohol completely during pregnancy.", "food_safety": "Unsafe", "created_at": "2024-08-09 16:44:44", "updated_at": "2024-08-09 16:44:44"},
  {
    "id": 16,
    "food_id": "Kafein (misalnya Kopi, teh, minuman ringan, kakao)",
    "food_en": "Caffeine (e.g Coffee, tea, soft drinks, cocoa)",
    "description_id": "Konsumsi kafein yang tinggi dapat menyebabkan kehilangan kehamilan dan masalah perkembangan. Batasi kafein hingga kurang dari 200 mg per hari selama kehamilan.",
    "description_en": "High caffeine intake can lead to pregnancy loss and developmental issues. Limit caffeine to less than 200 mg per day during pregnancy.",
    "food_safety": "Caution",
    "created_at": "2024-08-09 16:44:44",
    "updated_at": "2024-08-09 16:44:44"
  },
  {"id": 17, "food_id": "Daging atau unggas yang dimasak", "food_en": "Cooked meat or poultry", "description_id": null, "description_en": null, "food_safety": "Safe", "created_at": "2024-08-09 16:44:44", "updated_at": "2024-08-09 16:44:44"},
  {
    "id": 18,
    "food_id": "Ikan Bermerkuri Rendah",
    "food_en": "Lower-Mercury Fish",
    "description_id": "(Anchovy, Atlantic croaker, Atlantic mackerel, Black sea bass, Butterfish, Catfish, Clam, Cod, Crab, Crawfish, Flounder, Haddock, Hake, Herring, Lobster, American dan spiny, Mullet, Oyster, Pacific chub mackerel, Perch, air tawar dan laut, Pickerel, Plaice, Pollock, Salmon, Sardine, Scallop, Shad, Shrimp, Skate, Smelt, Sole, Squid, Tilapia, Trout, air tawar, Tuna, kalengan ringan (termasuk skipjack), Whitefish, Whiting)",
    "description_en": "(Anchovy, Atlantic croaker, Atlantic mackerel, Black sea bass, Butterfish, Catfish, Clam, Cod, Crab, Crawfish, Flounder, Haddock, Hake, Herring, Lobster, American and spiny, Mullet, Oyster, Pacific chub mackerel, Perch, freshwater and ocean, Pickerel, Plaice, Pollock, Salmon, Sardine, Scallop, Shad, Shrimp, Skate, Smelt, Sole, Squid, Tilapia, Trout, freshwater, Tuna, canned light (includes skipjack), Whitefish, Whiting)",
    "food_safety": "Safe",
    "created_at": "2024-08-09 16:44:44",
    "updated_at": "2024-08-09 16:44:44"
  },
  {
    "id": 19,
    "food_id": "Ikan atau makanan laut yang dimasak",
    "food_en": "Fully cooked fish or seafood",
    "description_id": null,
    "description_en": null,
    "food_safety": "Safe",
    "created_at": "2024-08-09 16:44:44",
    "updated_at": "2024-08-09 16:44:44",
  },
  {
    "id": 20,
    "food_id": "Ikan dan makanan laut kalengan",
    "food_en": "Canned fish and seafood",
    "description_id": null,
    "description_en": null,
    "food_safety": "Safe",
    "created_at": "2024-08-09 16:44:44",
    "updated_at": "2024-08-09 16:44:44",
  },
  {
    "id": 21,
    "food_id": "Susu yang dipasteurisasi",
    "food_en": "Pasteurized milk",
    "description_id": null,
    "description_en": null,
    "food_safety": "Safe",
    "created_at": "2024-08-09 16:44:44",
    "updated_at": "2024-08-09 16:44:44",
  },
  {
    "id": 22,
    "food_id": "Resep dengan telur mentah menggunakan telur pasteurisasi",
    "food_en": "Recipes with raw eggs use pasteurized eggs",
    "description_id": null,
    "description_en": null,
    "food_safety": "Safe",
    "created_at": "2024-08-09 16:44:44",
    "updated_at": "2024-08-09 16:44:44",
  },
  {
    "id": 23,
    "food_id": "Tunas yang dimasak",
    "food_en": "Cooked sprouts",
    "description_id": null,
    "description_en": null,
    "food_safety": "Safe",
    "created_at": "2024-08-09 16:44:44",
    "updated_at": "2024-08-09 16:44:44",
  },
  {
    "id": 24,
    "food_id": "Buah dan Sayuran segar yang dicuci, termasuk salad",
    "food_en": "Washed fresh fruits and vegetables, including salads",
    "description_id": null,
    "description_en": null,
    "food_safety": "Safe",
    "created_at": "2024-08-09 16:44:44",
    "updated_at": "2024-08-09 16:44:44",
  },
  {
    "id": 25,
    "food_id": "Sayuran yang dimasak",
    "food_en": "Cooked vegetables",
    "description_id": null,
    "description_en": null,
    "food_safety": "Safe",
    "created_at": "2024-08-09 16:44:44",
    "updated_at": "2024-08-09 16:44:44",
  },
  {
    "id": 26,
    "food_id": "Keju keras atau olahan",
    "food_en": "Hard or processed cheeses",
    "description_id": "(Keju keras, keju olahan, keju krim, mozzarella)",
    "description_en": "(Hard cheeses, processed cheeses, cream cheese, mozzarella)",
    "food_safety": "Safe",
    "created_at": "2024-08-09 16:44:44",
    "updated_at": "2024-08-09 16:44:44",
  },
  {
    "id": 27,
    "food_id": "Keju lunak terbuat dari susu yang dipasteurisasi.",
    "food_en": "Soft cheeses made from pasteurized milk.",
    "description_id": null,
    "description_en": null,
    "food_safety": "Safe",
    "created_at": "2024-08-09 16:44:44",
    "updated_at": "2024-08-09 16:44:44",
  },
  {
    "id": 28,
    "food_id": "Hot dog, daging makan siang, dan daging deli yang dipanaskan",
    "food_en": "Hot dogs, luncheon meats, and deli meats reheated to steaming hot",
    "description_id": null,
    "description_en": null,
    "food_safety": "Safe",
    "created_at": "2024-08-09 16:44:44",
    "updated_at": "2024-08-09 16:44:44",
  },
  {
    "id": 29,
    "food_id": "Salad deli yang baru disiapkan di rumah",
    "food_en": "Deli salads freshly prepared at home",
    "description_id": null,
    "description_en": null,
    "food_safety": "Safe",
    "created_at": "2024-08-09 16:44:44",
    "updated_at": "2024-08-09 16:44:44",
  },
  {
    "id": 30,
    "food_id": "Pâté atau selai daging kalengan atau tahan rak",
    "food_en": "Canned or shelf-stable pâtés or meat spreads",
    "description_id": null,
    "description_en": null,
    "food_safety": "Safe",
    "created_at": "2024-08-09 16:44:44",
    "updated_at": "2024-08-09 16:44:44",
  }
];

List<Map<String, dynamic>> initialTbMasterVaccines = [
  {
    "id": 1,
    "vaccines_id": "Vaksin Influenza",
    "vaccines_en": "Influenza Vaccine",
    "description_id":
        "Mendapatkan vaksin flu selama musim flu dapat mencegah ibu dari komplikasi medis dan kehamilan yang serius, serta melindungi bayi baru lahir selama awal masa bayi. Vaksin ini aman diberikan kapan saja selama kehamilan. Wanita hamil dan pasca melahirkan lebih rentan terhadap penyakit parah dan komplikasi dari flu karena perubahan pada sistem kekebalan tubuh, jantung, dan paru-paru mereka. Wanita yang sedang hamil atau akan hamil selama musim flu sebaiknya mendapatkan vaksin influenza inaktif (IIV) atau vaksin influenza rekombinan (RIV).",
    "description_en":
        "Getting the flu vaccine during flu season can help prevent serious health and pregnancy-related complications for mothers and protect their newborns in early infancy. This vaccine is safe to take at any stage of pregnancy. Pregnant and postpartum women are at higher risk for severe illness and complications from the flu because of changes in their immune systems, hearts, and lungs. Women who are pregnant or will be pregnant during flu season should get either the inactivated influenza vaccine (IIV) or the recombinant influenza vaccine (RIV).",
    "created_at": "2024-08-09 15:03:11",
    "updated_at": "2024-08-09 15:03:14"
  },
  {
    "id": 2,
    "vaccines_id": "Vaksin Tdap",
    "vaccines_en": "Tdap Vaccine",
    "description_id":
        "Vaksin Tdap, yang melindungi dari tetanus, difteri, dan batuk rejan, disarankan diberikan pada trimester ketiga kehamilan. Vaksin ini membantu melindungi ibu dan bayi baru lahir dari batuk rejan. Vaksin ini juga disarankan bagi siapa saja yang akan berdekatan dengan bayi di bawah satu tahun, seperti kakek-nenek atau pengasuh di daycare. Penyedia layanan kesehatan harus memberikan dosis Tdap selama setiap kehamilan, terlepas dari riwayat vaksinasi sebelumnya. Waktu terbaik untuk mendapatkan vaksin Tdap adalah antara minggu ke-27 dan ke-36 kehamilan, karena waktu ini meningkatkan respons antibodi ibu dan menyalurkan antibodi ini ke bayi. Namun, vaksin ini dapat diberikan kapan saja selama kehamilan. Jika tidak diberikan selama kehamilan, harus diberikan segera setelah melahirkan.",
    "description_en":
        "The Tdap vaccine, which protects against tetanus, diphtheria, and whooping cough, is recommended during the third trimester of pregnancy. It helps protect both the mother and the newborn from whooping cough. This vaccine is also recommended for anyone who will be in close contact with infants under one year old, such as grandparents or daycare workers. Healthcare providers should give a Tdap dose during each pregnancy, regardless of previous vaccinations. The best time to get the Tdap vaccine is between 27 and 36 weeks of pregnancy, as this timing boosts the mother’s antibody response and passes these antibodies to the baby. However, it can be given at any time during pregnancy. If not given during pregnancy, it should be administered right after birth.",
    "created_at": "2024-08-09 15:05:12",
    "updated_at": "2024-08-09 15:05:14"
  },
  {
    "id": 3,
    "vaccines_id": "COVID-19",
    "vaccines_en": "COVID-19",
    "description_id": "Wanita hamil yang terinfeksi SARS-CoV-2 memiliki risiko lebih tinggi terkena penyakit COVID-19 yang parah dibandingkan dengan wanita yang tidak hamil. Wanita hamil yang sehat hingga empat kali lebih mungkin membutuhkan perawatan intensif dan dukungan pernapasan daripada wanita yang tidak hamil. Bayi yang lahir dari ibu dengan COVID-19 hingga tujuh kali lebih mungkin lahir prematur dan hingga lima kali lebih mungkin membutuhkan perawatan intensif untuk bayi baru lahir.",
    "description_en": "Pregnant women who get infected with SARS-CoV-2 are at a higher risk of severe COVID-19 compared to non-pregnant women. Healthy pregnant women are up to four times more likely to need intensive care and breathing support than non-pregnant women. Babies born to mothers with COVID-19 are up to seven times more likely to be born prematurely and up to five times more likely to need newborn intensive care.",
    "created_at": "2024-08-09 15:07:24",
    "updated_at": "2024-08-09 15:07:26"
  },
  {
    "id": 4,
    "vaccines_id": "Vaksin Tambahan",
    "vaccines_en": "Additional Vaccines",
    "description_id": "Vaksin Hepatitis A, Hepatitis B, dan pneumokokus mungkin disarankan jika Anda memiliki faktor risiko tertentu atau sedang melanjutkan rangkaian vaksinasi yang dimulai sebelum kehamilan. Konsultasikan dengan dokter Anda untuk menentukan apakah vaksin ini bermanfaat bagi Anda.",
    "description_en": "Hepatitis A, Hepatitis B, and pneumococcal vaccines may be recommended if you have certain risk factors or are in the middle of a vaccination series that started before pregnancy. Talk to your doctor to see if these vaccines are beneficial for you.",
    "created_at": "2024-08-09 15:08:19",
    "updated_at": "2024-08-09 15:08:21"
  },
];

List<Map<String, dynamic>> initialTbMasterVitamins = [
  {
    "id": 1,
    "vitamins_id": "Asam Folat (Folat)",
    "vitamins_en": "Folic Acid (Folate)",
    "description_id":
        "Asam folat sangat penting untuk mencegah cacat tabung saraf pada bayi, seperti spina bifida dan anensefali. Cacat ini berkembang pada awal kehamilan, sering kali sebelum seorang wanita tahu bahwa dia hamil. Itulah mengapa disarankan untuk mulai mengonsumsi asam folat sebelum konsepsi dan melanjutkan hingga trimester pertama. Meskipun asam folat secara alami ditemukan dalam makanan seperti sayuran berdaun hijau, kacang-kacangan, dan kacang polong, suplemen disarankan untuk memastikan asupan yang cukup, terutama selama tahap awal kehamilan.",
    "description_en":
        "Folic acid is vital for preventing neural tube defects in babies, such as spina bifida and anencephaly. These defects develop early in pregnancy, often before a woman knows she’s pregnant. That’s why it’s recommended to start taking folic acid before conception and continue through the first trimester. While folic acid is naturally found in foods like green leafy vegetables, nuts, and beans, supplementation is recommended to ensure adequate intake, especially during the early stages of pregnancy.",
    "created_at": "2024-08-09 15:13:55",
    "updated_at": "2024-08-09 15:13:57"
  },
  {
    "id": 2,
    "vitamins_id": "Kalsium",
    "vitamins_en": "Calcium",
    "description_id": "Kalsium sangat penting untuk perkembangan tulang dan gigi bayi. Meskipun beberapa vitamin prenatal mengandung kalsium, suplemen tambahan mungkin diperlukan untuk memenuhi kebutuhan yang meningkat selama kehamilan. Asupan kalsium yang cukup juga mendukung kesehatan tulang ibu selama kehamilan.",
    "description_en": "Calcium is crucial for the development of the baby’s bones and teeth. While some prenatal vitamins contain calcium, additional supplementation may be needed to meet the increased demands of pregnancy. Adequate calcium intake also supports the mother’s bone health during pregnancy.",
    "created_at": "2024-08-09 15:14:24",
    "updated_at": "2024-08-09 15:14:26"
  },
  {
    "id": 3,
    "vitamins_id": "Yodium",
    "vitamins_en": "Iodine",
    "description_id": "Yodium penting untuk menjaga fungsi tiroid yang sehat selama kehamilan. Kekurangan yodium dapat menyebabkan keguguran, lahir mati, atau masalah perkembangan pada bayi, seperti pertumbuhan yang terhambat, disabilitas mental parah, atau ketulian. Penting untuk memastikan asupan yodium yang cukup, baik melalui diet atau suplemen.",
    "description_en": "Iodine is important for maintaining healthy thyroid function during pregnancy. Not getting enough iodine can lead to miscarriage, stillbirth, or developmental issues in the baby, like stunted growth, severe mental disability, or deafness. It’s important to ensure enough iodine intake either through diet or supplementation.",
    "created_at": "2024-08-09 15:14:28",
    "updated_at": "2024-08-09 15:14:30"
  },
  {
    "id": 4,
    "vitamins_id": "Zat Besi",
    "vitamins_en": "Iron",
    "description_id": "Zat besi diperlukan untuk memproduksi sel darah merah, yang membawa oksigen ke bayi untuk perkembangan yang tepat. Banyak wanita hamil tidak mendapatkan cukup zat besi dari diet mereka untuk memenuhi kebutuhan yang meningkat selama kehamilan, yang mengarah pada anemia defisiensi besi. Suplementasi zat besi selama kehamilan membantu mencegah anemia dan mengurangi risiko kelahiran prematur dan berat lahir rendah.",
    "description_en": "Iron is necessary for producing red blood cells, which carry oxygen to the baby for proper development. Many pregnant women don’t get enough iron from their diet to meet the increased demands of pregnancy, leading to iron deficiency anemia. Iron supplementation during pregnancy helps prevent anemia and reduces the risk of preterm delivery and low birth weight.",
    "created_at": "2024-08-09 15:16:16",
    "updated_at": "2024-08-09 15:16:19"
  },
  {
    "id": 5,
    "vitamins_id": "Asam Lemak Omega-3",
    "vitamins_en": "Omega-3 Fatty Acids",
    "description_id": "Asam lemak omega-3, termasuk DHA dan EPA, penting untuk perkembangan otak, saraf, dan mata bayi. Meskipun beberapa vitamin prenatal mungkin tidak mengandung asam lemak omega-3, mereka dapat ditemukan dalam makanan seperti ikan berlemak dan kacang-kacangan. Suplementasi mungkin diperlukan jika asupan makanan tidak mencukupi.",
    "description_en": "Omega-3 fatty acids, including DHA and EPA, are essential for the development of the baby’s brain, nerves, and eyes. While some prenatal vitamins may not include omega-3 fatty acids, they can be found in foods like fatty fish and nuts. Supplementation may be necessary if dietary intake is not enough.",
    "created_at": "2024-08-09 15:16:21",
    "updated_at": "2024-08-09 15:16:23"
  },
  {
    "id": 6,
    "vitamins_id": "Vitamin D",
    "vitamins_en": "Vitamin D",
    "description_id": "Vitamin D penting untuk membangun tulang dan gigi bayi serta menjaga kadar kalsium dan fosfor dalam tubuh. Asupan vitamin D yang cukup selama kehamilan membantu mencegah masalah tulang pada ibu dan bayi. Kekurangan vitamin D telah dikaitkan dengan peningkatan risiko komplikasi kehamilan seperti preeklamsia dan diabetes gestasional.",
    "description_en": "Vitamin D is important for building the baby’s bones and teeth and maintaining calcium and phosphorus levels in the body. Adequate vitamin D intake during pregnancy helps prevent bone-related issues in both the mother and the baby. Deficiency in vitamin D has been linked to a higher risk of pregnancy complications like preeclampsia and gestational diabetes.",
    "created_at": "2024-08-09 15:16:25",
    "updated_at": "2024-08-09 15:16:27"
  },
  {
    "id": 7,
    "vitamins_id": "Kolin",
    "vitamins_en": "Choline",
    "description_id": "Kolin sangat penting untuk perkembangan otak bayi yang sehat. Meskipun tubuh dapat memproduksi sebagian kolin, sebagian besar berasal dari sumber makanan seperti daging dan telur. Wanita hamil harus memastikan asupan kolin yang cukup melalui diet atau suplemen untuk mendukung perkembangan otak bayi.",
    "description_en": "Choline is crucial for healthy brain development in the baby. While the body can produce some choline, most of it comes from food sources like meat and eggs. Pregnant women should ensure enough choline intake through diet or supplements to support the baby’s brain development.",
    "created_at": "2024-08-09 15:16:29",
    "updated_at": "2024-08-09 15:16:31"
  },
  {
    "id": 8,
    "vitamins_id": "Protein",
    "vitamins_en": "Protein",
    "description_id": "Asupan protein perlu ditingkatkan selama kehamilan untuk mendukung kebutuhan ibu dan bayi yang sedang tumbuh. Asupan protein yang cukup membantu pembentukan jaringan baru, termasuk plasenta, yang menyediakan oksigen dan nutrisi untuk bayi. Makanan yang kaya protein harus dimasukkan dalam diet ibu untuk memenuhi kebutuhan protein yang meningkat selama kehamilan.",
    "description_en": "Protein intake needs to increase during pregnancy to support the growing needs of both the mother and the baby. Adequate protein intake helps form new tissue, including the placenta, which provides oxygen and nutrients to the baby. Protein-rich foods should be included in the mother’s diet to meet the increased protein requirements during pregnancy.",
    "created_at": "2024-08-09 15:16:33",
    "updated_at": "2024-08-09 15:16:36"
  },
];
