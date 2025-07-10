import 'package:sqlitebackup/backup_messages.dart';
import '../../l10n/l10n.dart';

class AppBackupMessages extends BackupMessages {
  @override
  String get cancel => l10n.loc!.cancel;

  @override
  String get restore => l10n.loc!.restore;

  @override
  String get title => l10n.loc!.select_backup;

  @override
  Map<String, String> translateMap() {
    Map<String,String> translateMapValues = {
      '{database_backed_up_to}' : l10n.loc!.database_backed_up_to,
      '{could_not_get_backup_directory_path}' : l10n.loc!.could_not_get_backup_directory_path,
      '{original_database_file_not_found}': l10n.loc!.original_database_file_not_found,
      '{backup_file_not_found}': l10n.loc!.backup_file_not_found,
      '{error_restoring_database}': l10n.loc!.error_restoring_database,
      '{database_restored_from}' : l10n.loc!.database_restored_from,
      '{error_deleting_backup}' : l10n.loc!.error_deleting_backup,
      '{backup_deleted}' : l10n.loc!.backup_deleted
    };

    return translateMapValues;
  }
}