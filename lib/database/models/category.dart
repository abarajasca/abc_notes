import 'package:abc_notes/database/models/model_base.dart';

class Category extends ModelBase {
  final int? id;
  final String name;

  static const TABLE_NAME = 'categories';

  Category({this.id,required this.name});

  // Convert a entity into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name
    };
  }

  // Implement toString to make it easier to see information about
  // each portfolio when using the print statement.
  @override
  String toString() {
    return 'Category{id: $id, name: $name}';
  }

  @override
  int? getId(){
    return id;
  }

  @override
  dynamic create(Map<String, dynamic> map) {
    return Category(id: map['id'] != null ? map['id'] : null, name: map['name']);
  }

  @override
  static dynamic getDummyReference() {
    return Category(id: 1, name: 'dummy');
  }

  @override
  String getTableName(){
    return TABLE_NAME;
  }

}