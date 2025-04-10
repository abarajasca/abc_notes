import 'package:abc_notes/database/config/app_database_config.dart';

class TestDatabaseConfig extends AppDatabaseConfig {

  @override
  String getDatabaseFilename() {
    return "test_notes.db";
  }

}