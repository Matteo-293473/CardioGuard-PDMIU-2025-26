import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  // torna una sola istanza (singleton)
  factory DatabaseService(){
    return _instance;
  }
  DatabaseService._internal();

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    String path;
    
    if (defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.linux) {
      // Inizializzazione per Desktop
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;

      // getApplicationSupportDirectory per Windows e Linux
      final dir = await getApplicationSupportDirectory();
      path = join(dir.path, 'cardioguard.db');
    } else {
      // getDatabasesPath per android e ios
      final databasesPath = await getDatabasesPath();
      path = join(databasesPath, 'cardioguard.db');
    }

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) => db.execute('''
        CREATE TABLE measurements (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          systolic INTEGER NOT NULL,
          diastolic INTEGER NOT NULL,
          pulse INTEGER NOT NULL,
          timestamp TEXT NOT NULL
        )
      '''),
    );
  }
}
