import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:ftl_mv_save_manager/Loading.dart';
import 'package:ftl_mv_save_manager/Manager/TextManager.dart';
import 'package:ftl_mv_save_manager/dev.dart';
import 'package:window_size/window_size.dart';
import 'dart:io';
import 'FTLBackupManagerInitializer.dart';
import 'Manager/FTLConfigManager.dart';
import 'Manager/FTLSaveManager.dart';
import 'FTLStyle.dart';
import 'Manager/BackListManager.dart';
import 'LoadFailPage.dart';
import 'LoadingPage.dart';
import 'MainPage.dart';
import 'envpath.dart';

const String pathDataDirectory = ".mvsvdata";
const String pathTextData = "$pathDataDirectory/text.csv";

const String title = "MV Save Backup Manager";
const bool dev = true;
const bool hideDevButton = true;
const String versionMain = "";
const String versionDev = "230813";

final backupListManager = BackupListManager();
final configManager = ConfigManager();
final textManager = TextManager(targetFile: pathTextData);
final saveManager = FTLSaveManager(textManager: textManager);

void main() {
  setDev(dev);

  devPrint("[Dev] ${personal()}");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const backgroundColor = FTLColors.redBackground;
  //final backupListManager = BackupListManager();
  //final configManager = ConfigManager();
  //final textManager = TextManager(targetFile: pathTextData);
  //final saveManager = FTLSaveManager(textManager: textManager);

  void Function(String a)? setLoadingMessage;

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
        ),
      ),
      home: Loading(
        onLoadPage: MainPage(
            title: title,
            dev: dev,
            background : backgroundColor,
            hideDevButton: hideDevButton,
            versionMain : versionMain,
            versionDev : versionDev,
            backupListManager : backupListManager,
            configManager : configManager,
            ftlSaveManager: saveManager,
            textManager : textManager,
        ),
        loadingPage: LoadingPage(
          background: backgroundColor,
          updateLoadMessage: (setMessage) {
            setLoadingMessage = setMessage;
          },
        ),
        loadFailPage: const LoadFailPage(

        ),
        load: () async {
          var initializer = FTLBackupManagerInitializer(
            backupListManager : backupListManager,
            configManager : configManager,
            saveManager : saveManager,
            textManager : textManager,
          );

          await Future.delayed(const Duration(milliseconds: 300));
          setLoadingMessage?.call("load config");
          initializer.loadConfig();

          setLoadingMessage?.call("initialize");
          initializer.initializeManager();

          setLoadingMessage?.call("load language pack...");
          initializer.loadLanguagePack();

          setLoadingMessage?.call("window initialize");
          setWindowTitle(textManager["!caption"]);
          setWindowMinSize(const Size(1035, 483));

          setLoadingMessage?.call("validation");
          initializer.checkBackupDirectory();

          //setLoadingMessage?.call("read ship metadata...");
          //initializer.loadShipImageCSV();
          //initializer.loadShipNamesCSV();

          //setLoadingMessage?.call("check directory...");
          //initializer.loadConfig();

          setLoadingMessage?.call("loading...");
          return true;
        },
      ),
    );
  }
}
