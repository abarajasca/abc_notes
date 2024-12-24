import 'package:abc_notes/database/models/category.dart';
import 'package:abc_notes/database/models/note.dart';
import 'package:abc_notes/database/providers/database_provider.dart';
import 'package:abc_notes/database/providers/model_provider.dart';

class Store {
  static late ModelProvider<Category> categories;
  static late ModelProvider<Note> notes;

  static void set databaseProvider(DatabaseProvider? databaseProvider) {
    categories = ModelProvider<Category>(databaseProvider: databaseProvider, model: Category.getDummyReference());
    notes = ModelProvider<Note>(databaseProvider:databaseProvider, model: Note.getDummyReference());
  }
}