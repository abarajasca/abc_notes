import 'package:abc_notes/database/config/test_database_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlitemodel/test_sqlite_database.dart';

import 'package:abc_notes/database/models/note.dart';
import 'package:abc_notes/database/store/store.dart';

Future main() async {
  test("Test SQLiteTest Provider ", () async {
    Store.databaseProvider = TestSqLiteDatabase(TestDatabaseConfig());

    await Store.notes.insert(Note(
        title: 'Note 1',
        body: 'Body 1',
        idCategory: 1,
        created_at: 'now',
        updated_at: 'now'));

    var note = (await Store.notes.getAll()).first;

    expect(note.title,'Note 1');
    expect(note.body,'Body 1');
    expect(note.created_at,'now');
    expect(note.updated_at,'now');

  });
}
