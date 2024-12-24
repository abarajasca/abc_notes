import 'dart:async';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'database_provider.dart';

class TestSqLiteDatabase extends DatabaseProvider {

  Future<Database> getDatabaseInstance() async {
    // Init ffi loader if needed.
    sqfliteFfiInit();

    // Open the database and store the reference.
    return await  databaseFactoryFfi.openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        onCreate: onCreate,
        onUpgrade: onUpgrade,
        // Set the version. This executes the onCreate function and provides a
        // path to perform database upgrades and downgrades.
        version: 1,
    ));
  }
}
