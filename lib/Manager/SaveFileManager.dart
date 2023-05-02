import 'dart:io';

import '../dev.dart';

class BackupFileManager {
  String targetDirectoryName = "";
  String targetFileName = r"hs_mv_continue.sav";
  String backupDirectoryName = ".ftlsaves";

  bool setup() {
    var targetFile = _getTargetFile();
    if (!targetFile.existsSync()) {
      return false;
    }
    _makeBackupDirectoryIfNotExists();
    return true;
  }

  void _makeBackupDirectoryIfNotExists() {
    var directory = _getDirectory();

    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
  }

  bool copyTargetFile(String destNameFormat) {
    var targetFile = _getTargetFile();
    if (!targetFile.existsSync()) {
      return false;
    }
    else {
      var destFileName = getBackupFilename(destNameFormat);
      var destFullPath = "$backupDirectoryName\\$destFileName";
      targetFile.copySync(destFullPath);

      return true;
    }
  }

  bool deleteBackupFile(String fileName) {
    if (existsBackupFile(fileName)) {
      var file = _getBackupFile(fileName);
      file.deleteSync();
      return true;
    }
    else {
      return false;
    }
  }

  bool existsBackupFile(String fileName) {
    var file = _getBackupFile(fileName);

    return file.existsSync();
  }

  bool revertTargetFile(String fileName) {
    var file = _getBackupFile(fileName);
    var targetFileName = _getTargetFileName();

    file.copySync(targetFileName);
    return true;
  }

  String getBackupFilename(String nameFormat) {
    var date = DateTime.now();
    var name = nameFormat;

    var dateFormat = "${date.year}${date.month}${date.day}${date.hour}${date.minute}${date.second}";
    name = name.replaceAll(RegExp('{DATETIME}'), dateFormat);

    return name;
  }

  Directory _getDirectory() {
    return Directory(backupDirectoryName);
  }

  File _getBackupFile(String backupFileName) {
    if (backupDirectoryName == "") {
      return File(backupFileName);
    }
    else if (backupDirectoryName.endsWith(r"\")) {
      return File("$backupDirectoryName$backupFileName");
    }
    else {
      return File("$backupDirectoryName\\$backupFileName");
    }
  }

  File _getTargetFile() {
    return File(_getTargetFileName());
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


