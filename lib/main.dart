import 'package:flutter/material.dart';
import 'package:ftl_mv_save_manager/Loading.dart';
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

const String title = "MV Save Backup Manager";
const bool dev = true;
const bool hideDevButton = true;
const String versionMain = "";
const String versionDev = "230503";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const backgroundColor = FTLColors.redBackground;
  final saveManager = FTLSaveManager();
  final backupListManager = BackupListManager();
  final configManager = ConfigManager();

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
          );

          await Future.delayed(const Duration(milliseconds: 300));
          setLoadingMessage?.call("initialize");
          initializer.initializeManager();

          setLoadingMessage?.call("window initialize");
          setWindowTitle(title);
          setWindowMinSize(const Size(1035, 483));
          //setLoadingMessage?.call("load locale...");
          //initializer.loadLocale();

          setLoadingMessage?.call("validation");
          initializer.checkBackupDirectory();

          setLoadingMessage?.call("load config");
          initializer.loadConfig();
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
