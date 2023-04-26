import 'dart:io';
import 'package:ftl_mv_save_manager/Manager/SaveFileManager.dart';
import 'package:ftl_mv_save_manager/Manager/SavFileParser.dart';

import '../FTLMVSaveInfo.dart';

class FTLSaveManager {
  final _saveInfoDict = <int, FTLMVSaveInfo>{};
  final _savFileParser = SavFileParser();
  final _manager = FTLSaveFileManager();
  String backupFileFormat = "backup_{DATETIME}.sav";
  int _infoIdCounter = 1;
  String _lastBackupHash = "";
  String _baseDirectory = ".ftlsaves";
  String get baseDirectory => _baseDirectory;
  set baseDirectory(String path) {
    _baseDirectory = path;
    _manager.backupDirectoryPath = path;
    _savFileParser.basePath = path;
  }

  FTLSaveManager() {
    var homeDir = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
    var targetFilePath = "$homeDir\\Documents\\My Games\\FasterThanLight\\hs_mv_continue.sav";

    _manager.targetFilePath = targetFilePath;
    baseDirectory = _baseDirectory;
    _manager.setup();
  }

  void clear() {
    _saveInfoDict.clear();
    _lastBackupHash = "";
  }

  int captureBackup() {
    if (!_manager.setup()) {
      return -1;
    }
    else {
      var dest = _manager.getBackupFilename(backupFileFormat);
      if (!_manager.copyTargetFile(dest)) {
        return -1;
      }
      else {
        return _parseBackup(dest);
      }
    }
  }

  void revertBackup(String filename) {
    _manager.revertTargetFile(filename);
  }

  void deleteBackup(String filename) {
    _manager.deleteBackupFile(filename);
  }

  int readBackup(String filename) {
    return _parseBackup(filename);
  }

  int _parseBackup(String filename) {
    if (_manager.existsBackupFile(filename)) {
      var saveInfo = _savFileParser.parse(filename);

      if (_lastBackupHash == saveInfo.hash) {
        return -1;
      }
      else {
        var id = _infoIdCounter++;
        _saveInfoDict[id] = saveInfo;
        _lastBackupHash = saveInfo.hash;

        return id;
      }
    }
    else {
      return -1;
    }
  }

  FTLMVSaveInfo? getSaveInfo(int id) {
    if (_saveInfoDict.containsKey(id)) {
      return _saveInfoDict[id];
    }
    else {
      return null;
    }
  }

  void openExplorerBackUpDirectory() {
    var directory = Directory(_manager.backupDirectoryPath);

    Process.runSync('explorer', [directory.path]);
  }
}


