import 'dart:io';
import 'Manager/BackListManager.dart';
import 'Manager/FTLConfigManager.dart';
import 'Manager/FTLSaveManager.dart';

class FTLBackupManagerInitializer {
  final backupDirectory = ".ftlbackup";
  final FTLSaveManager saveManager;
  final BackupListManager backupListManager;
  final ConfigManager configManager;

  FTLBackupManagerInitializer({
    required this.saveManager,
    required this.configManager,
    required this.backupListManager,
  });

  initializeManager() {
    backupListManager.filePath = backupDirectory;
    backupListManager.fileName = "saves.json";

    configManager.filePath = backupDirectory;
    configManager.fileName = "config.json";

    var homeDir = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
    saveManager.backupDirectoryName = backupDirectory;
    saveManager.targetDirectoryName = "$homeDir\\Documents\\My Games\\FasterThanLight";
    saveManager.targetFileName = "hs_mv_continue.sav";
    saveManager.backupFileFormat = "backup_{DATETIME}.sav";

    saveManager.backupFileManager.backupDirectoryName = saveManager.backupDirectoryName;
    saveManager.backupFileManager.targetFileName = saveManager.targetFileName;
    saveManager.backupFileManager.targetDirectoryName = saveManager.targetDirectoryName;
  }

  checkBackupDirectory() {
    var directory = Directory(backupDirectory);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
  }

  loadConfig() {
    configManager.load();
  }

  loadShipNamesCSV() {}

  loadShipImageCSV() {}

  loadLocale() {}

  loadBackupList() {}
}