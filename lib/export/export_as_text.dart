import 'dart:io';

import '../export/export_format.dart';
import '../database/models/note.dart';

class ExportAsText implements ExportFormat {
  @override
  void export(Map<String,Object> context) async {
    String? selectedDirectory = context['selectedDirectory'] as String;
    Note note = context['note'] as Note;

    String nameFilePath = '$selectedDirectory/${note.title}.txt';
    String bodyContent =
        'category:${note.category.name}\n\n${note.body}';
    await _saveNoteFile(nameFilePath, bodyContent);
  }

  Future<void> _saveNoteFile(String nameFilePath,String bodyContent) async {
    await File(nameFilePath).writeAsString(bodyContent);
  }
}