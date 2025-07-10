
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sqlitemodel/sqlite_database.dart';

import 'package:abc_notes/database/store/store.dart';

import 'database/config/app_database_config.dart';
import 'forms/main_form.dart';

void main(){
    WidgetsFlutterBinding.ensureInitialized();
    Store.databaseProvider = SqLiteDatabase(AppDatabaseConfig());

    runApp(const MaterialApp(
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
      home: NotesApp(),
    ));
}

class NotesApp extends StatelessWidget {
  const NotesApp();

  @override
  Widget build(BuildContext context) {
    return  MainForm();
  }
}
