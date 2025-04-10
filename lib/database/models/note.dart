import 'package:sqlitemodel/model/model_base.dart';

import 'category.dart';

class Note extends ModelBase {
  late int? id;
  final int idCategory;
  late String title;
  late String body;
  late String created_at;
  late String updated_at;
  late Category _category;

  static const TABLE_NAME = 'notes';

  Note(
      {this.id,
      required this.title,
      required this.body,
      required this.created_at,
      required this.updated_at,
      required this.idCategory});

  // Convert a Entity into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'created_at': created_at,
      'updated_at': updated_at,
      'id_category': idCategory,
    };
  }

  // Implement toString to make it easier to see information about
  // each portfolio when using the print statement.
  @override
  String toString() {
    return 'Note{id: $id, title: $title, body: $body, created_at: $created_at, created_at: $created_at, id_category: $idCategory}';
  }

  @override
  int? getId() {
    return id;
  }

  @override
  dynamic create(Map<String, dynamic> map) {
    return Note(
        id: map['id'] != null ? map['id'] : null,
        title: map['title'],
        body: map['body'] ?? '',
        created_at: map['created_at'] ?? '',
        updated_at: map['updated_at'] ?? '',
        idCategory: map['id_category']);
  }

  @override
  static dynamic getDummyReference() {
    return Note(id: 1, title: 'dummy', body: '', created_at: '',updated_at: '', idCategory: 1);
  }

  @override
  String getTableName() {
    return TABLE_NAME;
  }

  Category get category {
    return _category;
  }

  void set category(Category category){
    _category = category;
  }

}
