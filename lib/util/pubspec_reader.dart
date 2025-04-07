import 'dart:convert';

import 'package:flutter/services.dart';

class PubspecReader {

  late String _version;
  late String _build;

  Future<PubspecReader> Read() async {
    const splitter = LineSplitter();
    final String source = await rootBundle.loadString("pubspec.yaml");
    final sourceLines = splitter.convert(source);
    sourceLines.forEach((line){
      if (line.contains("version:")){
        var versionData = line.split(":")[1].split('+');
        _version =  versionData[0];
        _build = versionData[1];
      }
    });
    return this;
  }

  String get version { return _version; }
  String get  build { return _build; }

}