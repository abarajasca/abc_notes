import 'dart:async';
import 'package:sqflite/sqflite.dart';

abstract class DatabaseProvider {
  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    throw UnimplementedError('database getDatabaseInstance not implemented.');
  }

  FutureOr<void> onCreate(db, version) {
    // Run the CREATE TABLE statement on the database.
    if (version == 1){
      createScript(db);
    }
    return 1;
  }

  FutureOr<void> onUpgrade(db,oldVersion,newVersion){
    if (oldVersion == 1 && newVersion == 2){
      updateScript1_2(db);
    }
  }

  void createScript(Database db){
    List<String> tables = [
      'CREATE TABLE IF NOT EXISTS notes(id INTEGER PRIMARY KEY, title TEXT,body TEXT,created_at TEXT NOT NULL,updated_at TEXT NOT NULL,id_category INTEGER);',
      'CREATE TABLE IF NOT EXISTS categories(id INTEGER PRIMARY KEY,name TEXT,color INTEGER);',
      "INSERT INTO categories(id,name,color) VALUES(1,'General',4280391411);"
    ];
    tables.forEach((table) async {
      await db.execute(table);
    });
  }

  void updateScript1_2(Database db){
    List<String> queries = [
      'TABLE CHANGES HERE'
    ];
    //queries.forEach((query) async {
    //  await db.execute(query);
    //});
  }

}
