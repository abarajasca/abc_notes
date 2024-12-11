import '../export/export_format.dart';
import '../database/models/note.dart';

class ExportNote {
  late ExportFormat _exporter;
  late String selectedDirectory;

  ExportNote(String selectedDirectory,ExportFormat exporter){
    this._exporter = exporter;
    this.selectedDirectory = selectedDirectory;
  }

  export(Note note) {
    Map<String, Object> context = {
      'selectedDirectory': this.selectedDirectory,
      'note': note,
    };
    this._exporter.export(context);
  }
}
