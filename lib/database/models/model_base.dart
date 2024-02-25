abstract class ModelBase {

  // Convert a Portfolio into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap();

  static String TABLE_NAME = 'table_name_not_define';

  // Implement toString to make it easier to see information about
  // each record when using the print statement.
  String toString();

  int? getId();

  String getTableName();

  dynamic create(Map<String, dynamic> map) {
    return null;
  }

  static dynamic getDummyReference(){
    return null;
  }
}