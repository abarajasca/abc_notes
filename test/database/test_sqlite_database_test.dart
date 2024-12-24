import 'package:flutter_test/flutter_test.dart';
import 'package:abc_notes/database/models/note.dart';
import 'package:abc_notes/database/store/store.dart';

import 'package:abc_notes/database/providers/test_sqlite_database.dart';

Future main() async {
  test("Test SQLiteTest Provider ", () async {
    Store.databaseProvider = TestSqLiteDatabase();

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
