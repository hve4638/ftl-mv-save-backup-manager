import 'dart:io';

class FTLSaveFileManager {
  String targetFilePath = r"C:\Use<rs\hve46\Documents\My Games\FasterThanLight\hs_mv_continue.sav";
  String backupDirectoryPath = ".ftlsaves";

  bool setup() {
    if (!File(targetFilePath).existsSync()) {
      return false;
    }
    _makeBackupDirectoryIfNotExists();
    return true;
  }

  void _makeBackupDirectoryIfNotExists() {
    var directory = Directory(backupDirectoryPath);

    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
  }

  bool deleteBackupFile(String fileName) {
    if (existsBackupFile(fileName)) {
      var file = File("$backupDirectoryPath\\$fileName");
      file.deleteSync();
      return true;
    }
    else {
      return false;
    }
  }

  bool existsBackupFile(String fileName) {
    var file = File("$backupDirectoryPath\\$fileName");

    if (file.existsSync()) {
      return true;
    }
    else {
      return false;
    }
  }

  bool revertTargetFile(String fileName) {
    var file = File("$backupDirectoryPath\\$fileName");
    file.copySync(targetFilePath);
    return true;
  }

  bool copyTargetFile(String destNameFormat) {
    var targetFile = File(targetFilePath);
    if (!targetFile.existsSync()) {
      return false;
    }
    else {
      var destFileName = getBackupFilename(destNameFormat);
      var destFullPath = "$backupDirectoryPath\\$destFileName";
      targetFile.copySync(destFullPath);

      return true;
    }
  }

  String getBackupFilename(String nameFormat) {
    var date = DateTime.now();
    var name = nameFormat;

    var dateFormat = "${date.year}${date.month}${date.day}${date.hour}${date.minute}${date.second}";
    name = name.replaceAll(RegExp('{DATETIME}'), dateFormat);

    return name;
  }

  void openExplorerTargetDirectory() {

  }
}


