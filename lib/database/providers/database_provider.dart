import 'dart:async';
import 'package:sqflite/sqflite.dart';

abstract class DatabaseProvider {

  Future<Database?> get database async {
    throw UnimplementedError('database getter not implemented.');
  }

}
