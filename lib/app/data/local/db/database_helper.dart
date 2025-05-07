import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const String databaseName = "ai_blueberry.db";
  static const int databaseVersion = 1;
  static const bool debug = true;

  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  DatabaseHelper.internal();

  static const int tableSearchHistoryMaxNum = 50;

  static const String tableDownloadInfo = "downloadInfo";

  static const String tableDownloadInfoSql = "CREATE TABLE $tableDownloadInfo ("
      "id INTEGER PRIMARY KEY autoincrement,"
      "fileId TEXT unique,"
      "fileName TEXT,"
      "fileImgUrl TEXT,"
      "mainInfo TEXT,"
      "url TEXT,"
      "loadedSize INTEGER,"
      "fileSize INTEGER,"
      "filePath TEXT,"
      "version TEXT,"
      "status INTEGER,"
      "type INTEGER,"
      "packageMd5 TEXT,"
      "relyIds TEXT,"
      "extraId TEXT,"
      "extraOne INTEGER,"
      "extraTwo TEXT,"
      "saveTime INTEGER,"
      "describe TEXT);";

  static const tableDownloadInfoColumns = [
    "fileId",
    "fileName",
    "fileImgUrl",
    "mainInfo",
    "url",
    "loadedSize",
    "fileSize",
    "filePath",
    "version",
    "status",
    "type",
    "packageMd5",
    "relyIds",
    "extraId",
    "extraOne",
    "extraTwo",
    "saveTime",
    "describe",
  ];

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await _initDb();

    return _db!;
  }

  _initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, databaseName);

    var db = await openDatabase(path, version: databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(tableDownloadInfoSql);
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
  }

}


