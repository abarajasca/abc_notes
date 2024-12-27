import 'package:abc_notes/database/providers/test_sqlite_database.dart';
import 'package:abc_notes/database/store/store.dart';
import 'package:abc_notes/main.dart';
import 'package:abc_notes/widgets/floating_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future setupApp(tester) async {
  Store.databaseProvider = TestSqLiteDatabase();

  await tester.pumpWidget(const MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('es'), // Spanish
      ],
      home: const NotesApp()
  ));
}

void main(){
  group("Test main form", (){

    testWidgets('Should validate initial state.', ( tester ) async {
      await setupApp(tester);

      final title = await find.text('Abc Notes');
      final bottomNavigation = await find.byType(BottomNavigationBar);
      final floatingButton = await find.byType(FloatingButton);

      expect(title, findsOneWidget);
      expect(bottomNavigation, findsOneWidget);
      expect(floatingButton, findsOneWidget);

      await tester.tap(floatingButton);
    });

  });

}
