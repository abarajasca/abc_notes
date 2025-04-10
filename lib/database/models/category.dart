
import 'package:flutter/material.dart';
import 'package:sqlitemodel/model/model_base.dart';

class Category extends ModelBase {
  final int? id;
  final String name;
  final int color;


  static const TABLE_NAME = 'categories';

  Category({this.id,required this.name,required this.color});

  // Convert a entity into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color
    };
  }

  // Implement toString to make it easier to see information about
  // each portfolio when using the print statement.
  @override
  String toString() {
    return 'Category{id: $id, name: $name, color: $color}';
  }

  @override
  int? getId(){
    return id;
  }

  @override
  dynamic create(Map<String, dynamic> map) {
    return Category(id: map['id'] != null ? map['id'] : null, name: map['name'], color: map['color']);
  }

  @override
  static dynamic getDummyReference() {
    return Category(id: 1, name: 'dummy',color: Colors.blue.value);
  }

  @override
  String getTableName(){
    return TABLE_NAME;
  }

}