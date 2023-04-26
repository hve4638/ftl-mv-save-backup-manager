import 'package:flutter/cupertino.dart';
import 'package:ftl_mv_save_manager/FTLMVSaveInfo.dart';

import './Messages.dart';
typedef MessageHandler = void Function(Messages, List<dynamic>);

class FTLMessage {
  static MessageHandler _handler = (a, b) {};

  static void setHandler(MessageHandler handler) {
    _handler = handler;
  }

  static void resetHandler(MessageHandler handler) {
    _handler = (p0, p1) {};
  }

  static void openInfo(FTLMVSaveInfo saveInfo) {
    _handler(Messages.openInfo, [saveInfo]);
  }
  static void closeInfo() {
    _handler(Messages.closeInfo, []);
  }
  static void openSaveFileWith(FTLMVSaveInfo info) {
    _handler(Messages.openFileWith, [info.filePath]);
  }
  static void deleteInfo(BuildContext context, FTLMVSaveInfo info) {
    _handler(Messages.deleteInfo, [context, info]);
  }
  static void revertSave(FTLMVSaveInfo info) {
    _handler(Messages.revertSave, [info]);
  }
  static void backupCurrentSave() {
    _handler(Messages.captureSave, []);
  }

  static void openBackUpDirectory() {
    _handler(Messages.openBackupDirectory, []);
  }

  static void refreshSaveList() {
    _handler(Messages.refreshSaveList, []);
  }

  static void openSetting() {
    _handler(Messages.openSetting, []);
  }
}