import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:sqlitemodel/database_config.dart';

class AppDatabaseConfig implements DatabaseConfig {
  @override
  String getDatabaseFilename() {
    return "abc_notes.db";
  }

  @override
  int? getInitialDatabaseVersion() {
    return 1;
  }

  @override
  FutureOr<void> onCreate(db, version) {
    // Run the CREATE TABLE statement on the database.
    if (version == 1){
      _createScript(db);
    }
    return 1;
  }

  void _createScript(Database db){
    List<String> tables = [
      'CREATE TABLE IF NOT EXISTS notes(id INTEGER PRIMARY KEY, title TEXT,body TEXT,created_at TEXT NOT NULL,updated_at TEXT NOT NULL,id_category INTEGER);',
      'CREATE TABLE IF NOT EXISTS categories(id INTEGER PRIMARY KEY,name TEXT,color INTEGER);',
      "INSERT INTO categories(id,name,color) VALUES(1,'General',4280391411);"
    ];
    tables.forEach((table) async {
      await db.execute(table);
    });
  }

  @override
  FutureOr<void> onUpgrade(db, oldVersion, newVersion) {
    if (oldVersion == 1 && newVersion == 2){
      _updateScript1_2(db);
    }
  }

  void _updateScript1_2(Database db){
    List<String> queries = [
      'TABLE CHANGES HERE'
    ];
    //queries.forEach((query) async {
    //  await db.execute(query);
    //});
  }

}