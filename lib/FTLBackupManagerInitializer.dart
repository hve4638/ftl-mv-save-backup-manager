import 'dart:io';
import 'Manager/BackListManager.dart';
import 'Manager/FTLConfigManager.dart';
import 'Manager/FTLSaveManager.dart';
import 'Manager/TextManager.dart';
import 'dev.dart';
import 'envpath.dart';

class FTLBackupManagerInitializer {
  final backupDirectory = ".ftlbackup";
  final dataDirectory = ".mvsvdata";
  final FTLSaveManager saveManager;
  final BackupListManager backupListManager;
  final ConfigManager configManager;
  final TextManager textManager;

  FTLBackupManagerInitializer({
    required this.saveManager,
    required this.configManager,
    required this.backupListManager,
    required this.textManager,
  });

  initializeManager() {
    backupListManager.filePath = backupDirectory;
    backupListManager.fileName = "saves.json";

    configManager.filePath = backupDirectory;
    configManager.fileName = "config.json";

    saveManager.backupDirectoryName = backupDirectory;

    var targetDirectory = configManager.targetDirectory;
    if (targetDirectory == "") {
      saveManager.targetDirectoryName = "${personal()}\\My Games\\FasterThanLight";
    }
    else {
      saveManager.targetDirectoryName = targetDirectory;
    }

    devPrint("targetDirectory: ${saveManager.targetDirectoryName}");
    saveManager.targetFileName = "hs_mv_continue.sav";
    saveManager.backupFileFormat = "backup_{DATETIME}.sav";

    saveManager.backupFileManager.backupDirectoryName = saveManager.backupDirectoryName;
    saveManager.backupFileManager.targetFileName = saveManager.targetFileName;
    saveManager.backupFileManager.targetDirectoryName = saveManager.targetDirectoryName;
  }

  checkBackupDirectory() {
    var keys = Platform.environment.keys.toList();
    var dir = Platform.environment["ONEDRIVE"];

    var directory = Directory(backupDirectory);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

  }

  loadConfig() {
    configManager.load();
  }

  loadShipNamesCSV() {
    devPrint("[loadShipNamesCSV] load...");
  }

  loadShipImageCSV() {
    devPrint("[loadShipImageCSV] load...");
  }

  loadLanguagePack() {
    setDef(String key, String defText) {
      if (key == textManager[key]) {
        textManager[defText];
      }
    }
    devPrint("[loadLanguagePack] loading...");

    textManager.loadFile();
    //devPrint("----");
    //devPrint(textManager["!autobutton"]);
    //devPrint(textManager["!AutoButton"]);
    //devPrint("----");

    setDef("!caption", "MV Save Manager");
  }

  loadBackupList() {}
}