
import '../providers/model_provider.dart';
import '../models/note.dart';
import '../models/category.dart';

class Store {
  static ModelProvider<Category> categories = ModelProvider<Category>(model: Category.getDummyReference());
  static ModelProvider<Note> notes = ModelProvider<Note>(model: Note.getDummyReference());
}