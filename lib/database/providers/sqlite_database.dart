import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:abc_notes/database/providers/database_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqLiteDatabase implements DatabaseProvider {
  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _getDatabaseInstance();
    return _database;
  }

  Future<Database> _getDatabaseInstance() async {
    // Avoid errors caused by flutter upgrade.
    // Importing 'package:flutter/widgets.dart' is required.
    WidgetsFlutterBinding.ensureInitialized();
    // Open the database and store the reference.
    return await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'abc_notes.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        if (version == 1){
          _createScript(db);
        }
        return 1;
      },
      onUpgrade: (db,oldVersion,newVersion){
        if (oldVersion == 1 && newVersion == 2){
          _updateScript1_2(db);
        }
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }


  void _createScript(Database db){
    List<String> tables = [
      'CREATE TABLE IF NOT EXISTS notes(id INTEGER PRIMARY KEY, title TEXT,body TEXT,date TEXT NOT NULL,id_category INTEGER);',
      'CREATE TABLE IF NOT EXISTS categories(id INTEGER PRIMARY KEY,name TEXT,color INTEGER);',
      "INSERT INTO categories(id,name,color) VALUES(1,'General',4280391411);"
    ];
    tables.forEach((table) async {
      await db.execute(table);
    });
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
