import 'dart:convert';
import 'dart:io';

class ConfigManager {
  String filePath = "";
  String fileName = "config.json";
  final config = <String, dynamic>{
    "AutoSaveIntervalSec" : 60,
    "DeleteSaveWhenExit" : false,
    "openBackUpFileAs" : "notepad",
  };

  int get autoSaveIntervalSec => config["AutoSaveIntervalSec"] as int;
  bool get deleteSaveWhenExit => config["DeleteSaveWhenExit"] as bool;
  set autoSaveIntervalSec(int value) => config["AutoSaveIntervalSec"] = value;
  set deleteSaveWhenExit(bool value) => config["DeleteSaveWhenExit"] = value;

  ConfigManager();

  bool load() {
    var file = _getFile();
    if (!file.existsSync()) {
      return false;
    }
    else {
      var jsonString = file.readAsStringSync();
      dynamic json;
      try {
        json = jsonDecode(jsonString);
      }
      on FormatException {
        return false;
      }

      bool fail = false;
      fail |= !_trySetAsInt("AutoSaveIntervalSec", json: json);
      fail |= !_trySetAsBool("DeleteSaveWhenExit", json: json);

      return !fail;
    }
  }

  bool _trySetAsInt(String key, { required json }) {
    var item = json[key];
    if (item is int) {
      config[key] = item;
      return true;
    }
    else {
      return false;
    }
  }

  bool _trySetAsBool(String key, { required json }) {
    var item = json[key];
    if (item is bool) {
      config[key] = item;
      return true;
    }
    else {
      return false;
    }
  }

  save() {
    var file = _getFile();
    var jsonString = jsonEncode(config);
    file.writeAsStringSync(jsonString);
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