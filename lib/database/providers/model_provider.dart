import 'dart:async';
import 'package:abc_notes/database/providers/sqlite_database.dart';
import 'package:sqflite/sqflite.dart';

import '../models/model_base.dart';
import '../providers/database_provider.dart';

class ModelProvider<T extends ModelBase> {
  late DatabaseProvider databaseProvider;

  ModelProvider({DatabaseProvider? databaseProvider}) {
    this.databaseProvider = databaseProvider ??  SqLiteDatabase();
  }


// Define a function that inserts record into the database
  Future<int?> insert(T model) async {
    int? newId = 0 ;
    // Get a reference to the database.
    final db = await databaseProvider.database;

    // Insert the record into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    try {
      newId = await db?.insert(
          model.getTableName(),
          model.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace
      );
      return newId;
    } on Exception {
      return newId;
    }
  }

// A method that retrieves all records from the table.
  Future<List<T>> getAll(T referenceModel,{String? where}) async {
    // Get a reference to the database.
    final db = await databaseProvider.database;

    // Query the table for all records
    final List<Map<String, dynamic>>? maps = await db?.query(referenceModel.getTableName(),where: where);

    // Convert the List<Map<String, dynamic> into a List<Object>.
    if (maps != null ) {
      return List.generate(maps.length, (i) {
        return referenceModel.create(maps[i]);
      });
    } else {
      return [];
    }
  }

  Future<int> update(T model) async {
    // Get a reference to the database.
    final db = await databaseProvider.database;
    int? recordsUpdated = 0 ;

    // Update the given record.
    recordsUpdated =  await db?.update(
      model.getTableName(),
      model.toMap(),
      // Ensure that the record has a matching id.
      where: 'id = ?',
      // Pass the record's id as a whereArg to prevent SQL injection.
      whereArgs: [model.getId()],
    );

    return recordsUpdated!;
  }

  Future<void> delete(T model,{String? where,List<Object>? whereArgs}) async {
    // Get a reference to the database.
    final db = await databaseProvider.database;

    // Remove the Record from the database.
    await db?.delete(
      model.getTableName(),      // Use a `where` clause to delete a specific record.
      where: where ?? 'id = ?',
      // Pass the record's id as a whereArg to prevent SQL injection.
      whereArgs: whereArgs ?? [model.getId()],
    );
  }

  Future<void> deleteRaw({required String tableName, required String where,required List<Object> whereArgs}) async {
    // Get a reference to the database.
    final db = await databaseProvider.database;

    // Remove the Record from the database.
    await db?.delete(
      tableName,
      // Use a `where` clause to delete a specific record.
      where: where,
      // Pass the record's id as a whereArg to prevent SQL injection.
      whereArgs: whereArgs
    );
  }

  // Raw query
  Future<List<Map<String, Object?>>> rawQuery(String sql,[List<Object?>? arguments]) async {
    final db = await databaseProvider.database;
    return db!.rawQuery(sql,arguments);
  }
}

