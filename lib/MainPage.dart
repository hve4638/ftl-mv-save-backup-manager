import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ftl_mv_save_manager/FTLMVSaveInfo.dart';
import 'package:ftl_mv_save_manager/FileSaveNames.dart';
import 'package:ftl_mv_save_manager/Messages/SettingMessages.dart';
import 'package:ftl_mv_save_manager/SettingPage.dart';
import 'ColorStates.dart';
import 'FTLStyle.dart';
import 'Manager/FTLConfigManager.dart';
import 'Manager/FTLSaveManager.dart';
import 'SaveListPage.dart';
import 'SaveInformationPage.dart';
import 'Messages/FTLMessage.dart';
import 'Messages/Messages.dart';
import 'ListenerSignatures.dart';
import 'Manager/ShipNames.dart';
import 'package:window_size/window_size.dart';

class MainPage extends StatefulWidget {
  final String title;
  final String versionMain;
  final String versionDev;
  final bool dev;
  final bool hideDevButton;
  const MainPage({
    required this.title,
    required this.versionMain,
    this.versionDev = "",
    this.dev = false,
    this.hideDevButton = false,
    Key? key,
  }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  OverlayEntry? _overlayEntry;
  Timer? _autoSaveTimer;
  final manager = FTLSaveManager();
  final fileSaveNames = FileSaveNames(".ftlsaves\\list.yaml");
  final configManager = FTLConfigManager(".ftlsaves\\config.json");
  var notepadProgramPath = r"C:\Program Files\HxD\HxD.exe";
  SaveInfoFunc? removeFTLSaveInfo;
  SaveInfoFunc? addFTLSaveInfo;
  Func? resetFTLSaveInfo;

  bool hideInfoWidget = true;
  FTLMVSaveInfo? currentInfo;
  Widget currentInfoWidget = Container();

  bool autoButtonSelected = false;

  void _dev() {
    var configManager = FTLConfigManager(".ftlsaves\\config.json");
    configManager.load();
    configManager.save();
  }

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

      case Messages.changeSetting:
          _changeSetting(args[0], args[1]);
          break;

      case Messages.captureSave:
        _captureSaveMessage(args);
      default:
          break;
    }
  }

  void _changeSetting(SettingMessages message, dynamic args) {
    switch(message) {
      case SettingMessages.deleteSaveWhenExit:
        {
          bool enabled = args as bool;
          configManager.deleteSaveWhenExit = enabled;
        }

      case SettingMessages.autoSaveInterval:
        {
          int time = args as int;
          configManager.autoSaveIntervalSec = time;
        }
        break;
      default:
        break;
    }

    configManager.save();
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
      builder: (BuildContext context) {
          return Stack(
            children: [
              const ModalBarrier(
                color: Color(0xb2000000),
                dismissible: false,
              ),
              Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: SettingPage(
                    config: configManager,
                    onExit: _hideOverlay,
                  ),
                ),
              ),
            ],
        );
      },
    );
    overlayState.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  String _getVersion() {
    if (widget.dev) {
      if (widget.versionMain == "") {
        return "dev ${widget.versionDev}";
      }
      else {
        return "dev ${widget.versionDev} (branch from ${widget.versionMain})";
      }
    }
    else {
      return widget.versionMain;
    }
  }

  @override
  void initState() {
    super.initState();

    configManager.load();
    if (configManager.deleteSaveWhenExit && fileSaveNames.load()) {
      for (var name in fileSaveNames.names) {
        var id = manager.readBackup(name);
        if (id != -1) {
          manager.deleteBackup(name);
        }
      }
      fileSaveNames.remove();
      manager.clear();
    }

    setWindowTitle(widget.title);
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
                                Text("${widget.title}\n${_getVersion()}",
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
                                child: FTLIconButton(Icons.refresh,
                                  width: 35,
                                  margin: const EdgeInsets.all(4.0),
                                  onClick: () => FTLMessage.refreshSaveList(),
                                ),
                              ),
                              Expanded(
                                child: FTLIconButton(Icons.settings,
                                  width: 35,
                                  margin: const EdgeInsets.all(4.0),
                                  onClick: () => _showOverlay(context),
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
                          (
                            (widget.dev && !widget.hideDevButton)
                                ? FTLTextButton("DEV",
                                    fontSize : 20,
                                    width: 100,
                                    margin : const EdgeInsets.all(8),
                                    onClick: () {
                                      _dev();
                                    },
                                  )
                                : const SizedBox()
                          ),
                          FTLToggleTextButton("Auto",
                            selected: autoButtonSelected,
                            width: 80,
                            normalButtonStyle: FTLButtonStyle(
                              background: ColorStates(
                                  normal: const Color(0xff555557),
                                  hover: const Color(0xffb5b6b9)
                              ),
                              border: ColorStates(normal: FTLColors.normal, hover: FTLColors.normal),
                              child: ColorStates(normal: FTLColors.normal, hover: const Color(0xff425160)),
                            ),
                            selectedButtonStyle: FTLButtonStyle(
                              background: ColorStates(normal: FTLColors.orange, hover: FTLColors.orangeSelected),
                              border: ColorStates(normal: FTLColors.normal, hover: FTLColors.normal),
                              child: ColorStates(normal: FTLColors.normal, hover: FTLColors.normal),
                            ),
                            onChanged: (selected) {
                              if (selected) {
                                var sec = configManager.autoSaveIntervalSec;
                                _autoSaveTimer = Timer.periodic(Duration(seconds: sec), (timer) {
                                    FTLMessage.backupCurrentSave();
                                });
                              }
                              else {
                                _autoSaveTimer?.cancel();
                              }
                              setState(() {
                                autoButtonSelected = selected;
                              });
                            },
                          ),
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
