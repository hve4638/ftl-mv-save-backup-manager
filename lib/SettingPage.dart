import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ftl_mv_save_manager/Clickable.dart';
import 'package:ftl_mv_save_manager/Manager/FTLConfigManager.dart';
import 'package:ftl_mv_save_manager/Manager/TextManager.dart';
import 'package:ftl_mv_save_manager/Messages/SettingMessages.dart';
import 'FTLStyle.dart';
import 'Messages/FTLMessage.dart';
import 'dev.dart';

class SettingPage extends StatefulWidget {
  final ConfigManager config;
  final TextManager textManager;
  final void Function() onExit;
  const SettingPage({
    required this.config,
    required this.textManager,
    required this.onExit,
    Key? key,
  }) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool saveDirectoryHover = false;
  bool deleteSaveWhenExit = false;
  int autoSaveCurrentIndex = 0;
  var autoSaveItems = <String>[
    "10초", "30초", "1분", "3분", "5분", "10분", "15분", "30분", "1시간"
  ];
  var autoSaveItemsActual = <int>[
    10, 30, 60, 60*3, 60*5, 60*10, 60*15, 60*30, 60*60,
  ];

  @override
  void initState() {
    super.initState();

    deleteSaveWhenExit = widget.config.deleteSaveWhenExit;
    autoSaveCurrentIndex = -1;

    var sec = widget.config.autoSaveIntervalSec;
    for(var i = 0; i < autoSaveItemsActual.length; i++) {
      if (autoSaveItemsActual[i] == sec) {
        autoSaveCurrentIndex = i;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var ftlTextStyle = const TextStyle(
        color: FTLColors.normal,
        fontSize: 20.0
    );

    return FTLDialog(
      width: 400,
      height: 240,
      padding: const EdgeInsets.all(8.0),
      color: FTLColors.blueAccent,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.textManager["!configtext"],
                  style: const TextStyle(
                      color: FTLColors.normal,
                      fontSize: 25.0
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Clickable(
                  child: Text("세이브파일 경로 지정",
                      style: TextStyle(
                        fontSize: 20.0,
                        color : saveDirectoryHover ? FTLColors.selected : FTLColors.normal,
                      )
                  ),
                  onClick: () {
                    FilePicker.platform.getDirectoryPath().then((result) {
                      devPrint("dev? $result");
                      if (result != null) {
                        devPrint("dev? $result");
                        //FTLMessage.changeSetting(SettingMessages.targetDirectory, result);
                      }
                      //devPrint("click? $result");
                    });
                  },
                  onHover: (hovered) {
                    setState(() {
                      saveDirectoryHover = hovered;
                    });
                  },
                )
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(widget.textManager["!deletewhenexittext"], style: ftlTextStyle),
                const SizedBox(width: 20),
                FTLCheckBox(
                  width: 20,
                  height: 20,
                  selected: deleteSaveWhenExit,
                  onClick: (selected) {
                    FTLMessage.changeSetting(SettingMessages.deleteSaveWhenExit, selected);
                    setState(() {
                      deleteSaveWhenExit = selected;
                    });
                  },
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                FTLSwitchableTextButton(
                  message: "${widget.textManager["!autosaveintervaltext"]} : ",
                  errorMessage: "${widget.config.autoSaveIntervalSec} 초",
                  items: autoSaveItems,
                  onClick: (index) {
                    int nextIndex;
                    var length = autoSaveItems.length;
                    if (index >= 0 && index < length) {
                      nextIndex = (index+1) % length;
                    }
                    else {
                      nextIndex = 0;
                    }

                    FTLMessage.changeSetting(SettingMessages.autoSaveInterval, autoSaveItemsActual[nextIndex]);
                    setState(() {
                      autoSaveCurrentIndex = nextIndex;
                    });
                  },
                  currentIndex: autoSaveCurrentIndex,
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
          //Text("Open as..", style: ftlTextStyle),
          const Expanded(child: SizedBox()),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FTLTextButton("닫기",
                width: 80,
                height: 40,
                onClick: widget.onExit,
              ),
            ],
          )
        ],
      )
    );
  }
}
