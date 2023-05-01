


import 'dart:convert';
import 'dart:io';

class FTLConfigManager {
  final String _fileName;
  var directoryPath = ".";
  final config = <String, dynamic>{
    "AutoSaveIntervalSec" : 60,
    "DeleteSaveWhenExit" : false,
  };

  int get autoSaveIntervalSec => config["AutoSaveIntervalSec"] as int;
  bool get deleteSaveWhenExit => config["DeleteSaveWhenExit"] as bool;

  set autoSaveIntervalSec(int value) => config["AutoSaveIntervalSec"] = value;
  set deleteSaveWhenExit(bool value) => config["DeleteSaveWhenExit"] = value;

  FTLConfigManager(this._fileName);

  bool load() {
    var file = File(_fileName);
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
    var file = File(_fileName);
    var jsonString = jsonEncode(config);
    file.writeAsStringSync(jsonString);
  }
}