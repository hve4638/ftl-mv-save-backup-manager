import 'dart:io';
import 'dart:convert';

class BackupListManager {
  String filePath = "";
  String fileName = "saves.json";
  List<String> names = [];

  BackupListManager();

  bool load() {
    names.clear();

    var file = _getFile();
    if (!file.existsSync()) {
      return false;
    }
    else {
      var jsonString = file.readAsStringSync();
      var root = jsonDecode(jsonString);

      var nameList = root["saves"] as List<dynamic>;
      for(var name in nameList) {
        names.add(name);
      }
      return true;
    }
  }

  save() {
    var root = <String, dynamic>{
      "saves" : names,
    };
    var jsonString = jsonEncode(root);

    var file = _getFile();
    file.writeAsStringSync(jsonString);
  }

  remove() {
    var file = _getFile();
    if (file.existsSync()) {
      file.deleteSync();
    }
    names.clear();
  }

  File _getFile() {
    if (filePath == "") {
      return File(fileName);
    }
    else if (filePath.endsWith(r"\")) {
      return File("$filePath$fileName");
    }
    else {
      return File("$filePath\\$fileName");
    }
  }
}