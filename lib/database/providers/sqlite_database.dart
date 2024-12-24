import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:abc_notes/database/providers/database_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqLiteDatabase extends DatabaseProvider {

  @override
  Future<Database> getDatabaseInstance() async {
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
      onCreate: onCreate,
      onUpgrade: onUpgrade,
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }



}
