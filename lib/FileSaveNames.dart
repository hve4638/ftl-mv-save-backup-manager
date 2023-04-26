import 'dart:io';
import 'package:yaml/yaml.dart';
import 'dart:convert';

class FileSaveNames {
  final String fileName;
  var names = <String>[];

  FileSaveNames(this.fileName);

  bool load() {
    names.clear();

    var file = File(fileName);
    if (!file.existsSync()) {
      return false;
    }
    else {
      var contents = file.readAsStringSync();
      var root = loadYaml(contents);

      List<String> saves = root['saves']?.split(" ") ?? [];
      for(var name in saves) {
        names.add(name);
      }
      return true;
    }
  }

  save() {
    var buffer = StringBuffer();
    buffer.writeln("saves:");
    for(var name in names) {
      buffer.writeln("    $name");
    }

    var result = buffer.toString();
    var file = File(fileName);
    file.writeAsStringSync(result);
  }
}