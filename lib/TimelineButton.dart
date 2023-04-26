import 'package:flutter/material.dart';
import 'package:ftl_mv_save_manager/Messages/FTLMessage.dart';
import 'ColorStates.dart';
import 'FTLButton.dart';
import 'FTLMVSaveInfo.dart';
import 'FTLColors.dart';
import 'winmove.dart';

class TimelineButton extends StatefulWidget {
  final EdgeInsets margin;
  final ColorStates? colorStates;
  final FTLMVSaveInfo saveInfo;
  TimelineButton({
        required this.saveInfo,
        this.margin = const EdgeInsets.all(0.0),
        this.colorStates,
        Key? key
    }) : super(key: key);

  @override
  State<TimelineButton> createState() => _TimelineButtonState();
}

class _TimelineButtonState extends State<TimelineButton> {
  @override
  Widget build(BuildContext context) {
    var colorStates = widget.colorStates ?? ColorStates();
    var date = widget.saveInfo.dateTime;

    return FTLButton(
      onClick: () {
        FTLMessage.openInfo(widget.saveInfo);
      },
      width: double.infinity,
      height: 56.0,
      margin : widget.margin,
      child: Row(
        children: [
          Container(
              width : 64.0,
              padding : const EdgeInsets.all(3),
              child: Image.asset("assets/ships/${widget.saveInfo.img}")
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(widget.saveInfo.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  color: colorStates.normal,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child : Align(
              alignment: Alignment.bottomRight,
              child : Text("${_pad(date.year, 4)}.${_pad(date.month)}.${_pad(date.day)} ${_pad(date.hour)}:${_pad(date.minute)}:${_pad(date.second)}",
                style: TextStyle(
                  fontSize: 12,
                  color: colorStates.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _pad(int num, [int width = 2]) {
    return num.toString().padLeft(2, '0');
  }
}
