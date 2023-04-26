import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ftl_mv_save_manager/FTLMVSaveInfo.dart';
import 'package:ftl_mv_save_manager/FileSaveNames.dart';
import 'ColorStates.dart';
import 'FTLButton.dart';
import 'FTLColors.dart';
import 'FTLDialog.dart';
import 'FTLTextButton.dart';
import 'Manager/FTLSaveManager.dart';
import 'SaveListPage.dart';
import 'SaveInformationPage.dart';
import 'Messages/FTLMessage.dart';
import 'Messages/Messages.dart';
import 'ListenerSignatures.dart';
import 'Manager/ShipNames.dart';
import 'package:window_size/window_size.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final title = "FTL: Multiverse Save Manager";
  final version = "dev 230426";
  OverlayEntry? _overlayEntry;
  final manager = FTLSaveManager();
  final fileSaveNames = FileSaveNames(".ftlsaves\\list.yaml");
  //var notepadProgramPath = "notepad.exe";
  var notepadProgramPath = r"C:\Program Files\HxD\HxD.exe";
  bool refreshButtonHover = false;
  bool settingButtonHover = false;
  SaveInfoFunc? removeFTLSaveInfo;
  SaveInfoFunc? addFTLSaveInfo;
  Func? resetFTLSaveInfo;

  bool hideInfoWidget = true;
  FTLMVSaveInfo? currentInfo;
  Widget currentInfoWidget = Container();

  void messageHandler(Messages message, List<dynamic> args) {
    switch(message) {
      case Messages.openInfo:
          _openInfoMessage(args);
          break;
      case Messages.closeInfo:
          _closeInfoMessage(args);
          break;
      case Messages.openFileWith:
          if (args.isNotEmpty && args[0] is String) {
            var script = File.fromUri(Platform.script);
            var currentPath = "${script.parent.path}\\${args[0]}";

            _runProcess(notepadProgramPath, [ currentPath ]);
          }
          break;
      case Messages.revertSave:
        if (args.isNotEmpty && args[0] is FTLMVSaveInfo) {
          _revertSaveMessage(args[0]);
        }
          break;
      case Messages.deleteInfo:
          if (args.length >= 2 && args[0] is BuildContext && args[1] is FTLMVSaveInfo) {
              var info = args[1] as FTLMVSaveInfo;
              //_showOverlay(args[0]);
              manager.deleteBackup(info.fileName);
              fileSaveNames.names.remove(info.fileName);
              removeFTLSaveInfo?.call(info);
              fileSaveNames.save();
              _changeInfo();
          }

      //manager.backupCurrent();
        break;
      case Messages.refreshSaveList:
        _refreshSaveListMessage();
        break;
      case Messages.openBackupDirectory:
          manager.openExplorerBackUpDirectory();
          break;

      case Messages.captureSave:
        _captureSaveMessage(args);
      default:
          break;
    }
  }

  void _openInfoMessage(List<dynamic> args) {
    if (args.isEmpty) return;

    if (args[0] is FTLMVSaveInfo) {
      _changeInfo(args[0]);
    }
  }

  void _closeInfoMessage(List<dynamic> args) {
    _changeInfo();

  }

  void _changeInfo([FTLMVSaveInfo? info]) {
    if (currentInfo == info) {
      return;
    }
    else if (info == null) {
      currentInfo = null;
      setState(() => currentInfoWidget = Container());
    }
    else {
      currentInfo = info;
      setState(() => currentInfoWidget = SaveInformationPage(info));
    }
  }

  void _captureSaveMessage(List<dynamic> args) {
    var id = manager.captureBackup();
    if (id != -1) {
      var info = manager.getSaveInfo(id)!;
      addFTLSaveInfo?.call(info);

      fileSaveNames.names.add(info.fileName);
      fileSaveNames.save();
    }
  }

  void _refreshSaveListMessage() {
    manager.clear();
    resetFTLSaveInfo?.call();
    _changeInfo();

    if (fileSaveNames.load()) {
      var count = 0;
      for (var name in fileSaveNames.names) {
        var id = manager.readBackup(name);
        if (id != -1) {
          var info = manager.getSaveInfo(id)!;
          addFTLSaveInfo?.call(info);

          count++;
        }
      }
    }
    else {
      print("load fail");
    }
  }

  void _runProcess(String programPath, List<String> args) {
    Process.run(programPath, args)
        .then((ProcessResult result) {
        print(result.stdout);
    });
  }

  void _revertSaveMessage(FTLMVSaveInfo saveInfo) {
    manager.revertBackup(saveInfo.fileName);
  }

  void _showOverlay(BuildContext context) {
    var overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => const Center(
        child: Material(
          child: FTLDialog(
            width: 300,
            height: 80,
            padding: EdgeInsets.all(8.0),
            color: FTLColors.blueBackground,
            child: Center(
              child: Text("정말 삭제하시겠습니까?",
                style: TextStyle(
                  color: FTLColors.normal,
                  fontSize: 16.0
                ),
              ),
            ),
          ),
        ),
      ),
    );
    overlayState.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void initState() {
    super.initState();

    setWindowTitle(title);
    setWindowMinSize(const Size(1035, 483));
    FTLMessage.setHandler(messageHandler);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Container(
        color: FTLColors.redBackground,
        child: Row(
          children: [
            SizedBox(
              width: 400,
              height : double.infinity,
              child: Column(
                children: [
                  Expanded(
                      child:SaveListPage(
                        onSetupAdder: (onAdd) => addFTLSaveInfo = onAdd,
                        onSetupResetFunc: (onReset) => resetFTLSaveInfo = onReset,
                        onSetupRemoveFunc : (onRemove) => removeFTLSaveInfo = onRemove,
                        onLoad : () {
                          _refreshSaveListMessage();
                        },
                      ),
                  ),
                  SizedBox(
                    height: 78,
                    child : Row(
                      children: [
                        Expanded(
                          child: FTLDialog(
                            margin: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("$title\n$version",
                                  style: const TextStyle(
                                    color: FTLColors.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding : const EdgeInsets.all(4.0),
                          width: 35 + 8,
                          child: Column(
                            children: [
                              Expanded(
                                child: FTLButton(
                                  width: 35,
                                  margin: const EdgeInsets.all(4.0),
                                  onHover: (hover) => setState(() => refreshButtonHover = hover),
                                  onClick: () => FTLMessage.refreshSaveList(),
                                  child : Icon(Icons.refresh,
                                    color: refreshButtonHover ? FTLColors.selected : FTLColors.normal,
                                    size: 18,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: FTLButton(
                                  width: 35,
                                  margin: const EdgeInsets.all(4.0),
                                  onClick: () => FTLMessage.openSetting(),
                                  onHover: (hover) => setState(() => settingButtonHover = hover),
                                  child : Icon(Icons.settings,
                                    color: settingButtonHover ? FTLColors.selected : FTLColors.normal,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ),
                ],
              )
            ),
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 340,
                    child : currentInfoWidget,
                  ),
                  const Expanded(child: SizedBox()),
                  Container(
                      padding : const EdgeInsets.all(8),
                      height : 78,
                      child: Row(
                        children: [
                          FTLTextButton("Open",
                            fontSize : 20,
                            width: 100,
                            margin : const EdgeInsets.all(8),
                            onClick: () {
                              FTLMessage.openBackUpDirectory();
                            },
                          ),
                          const Expanded(child: SizedBox()),
                          FTLTextButton("Save",
                            fontSize : 20,
                            width: 140,
                            margin : const EdgeInsets.all(8),
                            onClick: () {
                              FTLMessage.backupCurrentSave();
                            },
                          ),
                        ],
                      )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
