import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:abc_notes/main.dart';
import 'package:abc_notes/database/store/store.dart';
import 'package:abc_notes/database/config/test_database_config.dart';
import 'package:abc_notes/widgets/floating_button.dart';

import 'package:integration_test/integration_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sqlitemodel/test_sqlite_database.dart';

Future setupApp(tester) async {
  Store.databaseProvider = TestSqLiteDatabase(TestDatabaseConfig());

  await tester.pumpWidget(const MaterialApp(localizationsDelegates: [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ], supportedLocales: [
    Locale('en'), // English
    Locale('es'), // Spanish
  ], home: const NotesApp()));
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-end test', () {
    testWidgets('Create, modify and delete new note.', (tester) async {
      await setupApp(tester);
      await tester.pumpAndSettle();

      // create a note
      var fab = find.byType(FloatingButton);
      await tester.tap(fab);

      await tester.pumpAndSettle();
      var tapTitle = find.text('New Note');
      expect(tapTitle, findsOne);

      var title = find.byKey(const ValueKey('title'));
      await tester.enterText(title, 'my new note');
      await tester.pumpAndSettle();

      final body = find.byKey(const ValueKey('body'));
      await tester.enterText(body, 'body of new note');
      await tester.pumpAndSettle();

      fab = find.byType(FloatingButton);

      await tester.tap(fab.last);
      await tester.pumpAndSettle();

      title = find.text('my new note');

      expect(title, findsOne);

      // Update note
      await tester.tap(title);
      await tester.pumpAndSettle();

      title = find.byKey(const ValueKey('title'));
      await tester.enterText(title, 'my new note modified');
      await tester.pumpAndSettle();

      await tester.tap(fab.last);
      await tester.pumpAndSettle();

      title = find.text('my new note modified');

      expect(title, findsOne);

      // Delete a note

      var iconButton = find.byKey(ValueKey('icon-select'));
      await tester.tap(iconButton);
      await tester.pumpAndSettle();

      var checkNote = find.byKey(ValueKey('chk-note'));
      await tester.tap(checkNote);
      await tester.pumpAndSettle();

      var iconDelete = find.byKey(ValueKey('icon-delete'));
      await tester.tap(iconDelete);
      await tester.pumpAndSettle();

      title = find.text('my new note modified');

      expect(title, findsNothing);
    });

    testWidgets('Create, modify and delete new category.', (tester) async {
      await setupApp(tester);
      await tester.pumpAndSettle();

      // Create new category
      var bnb = find.byKey(ValueKey('bnbi-categories'));

      expect(bnb, findsOne);
      await tester.tap(bnb);
      await tester.pumpAndSettle();

      var fab = find.byType(FloatingButton);
      await tester.tap(fab);
      await tester.pumpAndSettle();

      var tapTitle = find.text('Add Category');
      expect(tapTitle, findsOne);

      var name = find.byKey(const ValueKey('name'));
      await tester.enterText(name, 'my new category');
      await tester.pumpAndSettle();

      fab = find.byType(FloatingButton);

      await tester.tap(fab.last);
      await tester.pumpAndSettle();

      name = find.text('my new category');

      expect(name, findsOne);

      // Update category
      await tester.tap(name);
      await tester.pumpAndSettle();

      name = find.byKey(const ValueKey('name'));
      await tester.enterText(name, 'my new category modified');
      await tester.pumpAndSettle();

      await tester.tap(fab.last);
      await tester.pumpAndSettle();

      name = find.text('my new category modified');

      expect(name, findsOne);

      // Delete a note

      var iconButton = find.byKey(ValueKey('icon-select'));
      await tester.tap(iconButton);
      await tester.pumpAndSettle();

      var checkNote = find.byKey(ValueKey('chk-category'));
      await tester.tap(checkNote.last);
      await tester.pumpAndSettle();

      var iconDelete = find.byKey(ValueKey('icon-delete'));
      await tester.tap(iconDelete);
      await tester.pumpAndSettle();

      name = find.text('my new category modified');

      expect(name, findsNothing);
    });
  });
}
