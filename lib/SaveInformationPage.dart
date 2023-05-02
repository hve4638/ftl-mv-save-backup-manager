import 'package:flutter/material.dart';
import 'package:ftl_mv_save_manager/FTLMVSaveInfo.dart';
import 'package:ftl_mv_save_manager/Messages/FTLMessage.dart';
import 'ColorStates.dart';
import 'FTLStyle.dart';

class SaveInformationPage extends StatefulWidget {
  final FTLMVSaveInfo info;
  const SaveInformationPage(this.info, {
    Key? key
  }) : super(key: key);

  @override
  State<SaveInformationPage> createState() => _SaveInformationPageState();
}

class _SaveInformationPageState extends State<SaveInformationPage> {
  final alertColorStates = ColorStates(
      normal: FTLColors.normal,
      hover : FTLColors.redSelected,
  );
  Color buttonTextColor = FTLColors.normal;

  @override
  Widget build(BuildContext context) {
    var date = widget.info.dateTime;

    return FTLDialog(
        margin : const EdgeInsets.all(4),
        padding : const EdgeInsets.all(4),
        child : Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.info.name,
                          style: const TextStyle(
                            fontSize: 28,
                            color: FTLColors.normal,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Ship : ${widget.info.ship}",
                          style: const TextStyle(
                            fontSize: 15,
                            color: FTLColors.normal,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "DateTime : ${_pad(date.year, 4)}.${_pad(date.month)}.${_pad(date.day)} ${_pad(date.hour)}:${_pad(date.minute)}:${_pad(date.second)}",
                          style: const TextStyle(
                            fontSize: 15,
                            color: FTLColors.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    width: 196,
                    child: Image.asset("assets/ships/${widget.info.img}")
                ),
              ],
            ),
            const Expanded(child : SizedBox()),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Hash: ${widget.info.hash}",
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                  FTLTextButton("X",
                    width: 56,
                    height: 56,
                    margin : const EdgeInsets.all(6),
                    onClick: () => FTLMessage.closeInfo(),
                  ),
                  FTLIconButton(Icons.edit_note,
                    width: 56,
                    height: 56,
                    margin : const EdgeInsets.all(6),
                    onClick: () => FTLMessage.openSaveFileWith(widget.info),
                  ),
                  const Expanded(child: SizedBox()),
                  FTLTextButton("Delete",
                    width: 100,
                    height: 56,
                    margin : const EdgeInsets.all(6),
                    textColors: alertColorStates,
                    borderColors: alertColorStates,
                    onClick: () => FTLMessage.deleteInfo(context, widget.info),
                  ),
                  FTLTextButton("Revert this",
                    width: 140,
                    height: 56,
                    margin : const EdgeInsets.all(6),
                    onClick: () => FTLMessage.revertSave(widget.info),
                  ),
              ],
            ),
          ]
        )
    );
  }


  String _pad(int num, [int width = 2]) {
    return num.toString().padLeft(2, '0');
  }
}
