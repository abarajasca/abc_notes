import 'package:abc_notes/database/models/category.dart';
import 'package:abc_notes/database/providers/model_provider.dart';

import '../models/note.dart';

class Store {
  static ModelProvider<Note> notes = ModelProvider<Note>();
  static ModelProvider<Category> categories = ModelProvider<Category>();
}