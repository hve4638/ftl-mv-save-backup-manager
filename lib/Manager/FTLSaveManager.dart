import 'dart:io';
import 'package:ftl_mv_save_manager/Manager/SaveFileManager.dart';
import 'package:ftl_mv_save_manager/Manager/BackupFileManager.dart';
import 'package:ftl_mv_save_manager/dev.dart';

import '../FTLMVSaveInfo.dart';

class FTLSaveManager {
  static int _cacheIdCounter = 1;
  static final _savFileParser = MVSaveInfoParser();

  String backupDirectoryName = "";
  String targetDirectoryName = "";
  String targetFileName = "hs_mv_continue.sav";
  String backupFileFormat = "backup_{DATETIME}.sav";

  final backupFileManager = BackupFileManager();
  final _saveInfoCache = <int, FTLMVSaveInfo>{};
  int _lastId = -1;

  void clear() {
    _lastId = -1;
    _saveInfoCache.clear();
  }

  String getLastInfoHash() {
    return _saveInfoCache[_lastId]?.hash ?? "";
  }

  int captureTarget() {
    if (!backupFileManager.setup()) {
      devPrint("capture: fail to setup");
      return -1;
    }
    else {
      var dest = backupFileManager.getBackupFilename(backupFileFormat);
      if (!backupFileManager.copyTargetFile(dest)) {
        devPrint("capture: fail to copy target");
        return -1;
      }
      else {
        devPrint("capture: parse");
        return _parseBackup(dest);
      }
    }
  }

  void revertBackup(String filename) {
    backupFileManager.revertTargetFile(filename);
  }

  void deleteBackup(String filename) {
    backupFileManager.deleteBackupFile(filename);
  }

  int readBackup(String filename) {
    return _parseBackup(filename);
  }

  int _parseBackup(String filename) {
    if (backupFileManager.existsBackupFile(filename)) {
      var saveInfo = _savFileParser.parse(filename, filePath: backupDirectoryName);

      if (getLastInfoHash() == saveInfo.hash) {
        return -1;
      }
      else {
        var id = _cacheIdCounter++;
        _saveInfoCache[id] = saveInfo;
        _lastId = id;

        return id;
      }
    }
    else {
      return -1;
    }
  }

  FTLMVSaveInfo? getSaveInfo(int id) {
    if (_saveInfoCache.containsKey(id)) {
      return _saveInfoCache[id];
    }
    else {
      return null;
    }
  }

  void openExplorerBackUpDirectory() {
    var directory = Directory(backupDirectoryName);

    Process.runSync('explorer', [directory.path]);
  }

  String _getTargetFileName() {
    if (targetDirectoryName == "") {
      return targetFileName;
    }
    else if (targetDirectoryName.endsWith(r"\")) {
      return "$targetDirectoryName$targetFileName";
    }
    else {
      return "$targetDirectoryName\\$targetFileName";
    }
  }
}


