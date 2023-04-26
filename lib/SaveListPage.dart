import 'package:flutter/material.dart';
import 'package:ftl_mv_save_manager/FTLMVSaveInfo.dart';
import 'TimelineButton.dart';
import 'ListenerSignatures.dart';

typedef OnSetUpAddFunc = void Function(OnAddFTLSaveInfoFunc);

class SaveListPage extends StatefulWidget {
  final OnSetUpAddFunc onSetupAdder;
  final FuncFunc onSetupResetFunc;
  final OnSetUpAddFunc onSetupRemoveFunc;
  final Func onLoad;
  const SaveListPage({
    required this.onSetupAdder,
    required this.onSetupRemoveFunc,
    required this.onSetupResetFunc,
    required this.onLoad,
    Key? key
  }) : super(key: key);

  @override
  State<SaveListPage> createState() => _SaveListPageState();
}

class _SaveListPageState extends State<SaveListPage> {
  var savList = <FTLMVSaveInfo>[];

  @override
  void initState() {
    super.initState();

    widget.onSetupAdder((info) {
      setState(() => savList.add(info));
    });
    widget.onSetupRemoveFunc((info) {
      var hash = info.hash;
      int index = savList.indexWhere((save) {
        return save.hash == hash;
      });

      if (index != -1) {
        setState(() => savList.removeAt(index));
      }
    });
    widget.onSetupResetFunc(() {
      setState(() => savList.clear());
    });
    widget.onLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListView.builder(
          itemCount: savList.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return TimelineButton(
              saveInfo: savList[savList.length - index - 1],
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 4),
            );
          }
      ),
    );
  }
}