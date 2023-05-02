import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'FTLStyle.dart';

class LoadingPage extends StatefulWidget {
  final void Function(void Function(String))? updateLoadMessage;
  final Color background;

  const LoadingPage({
    required this.background,
    this.updateLoadMessage,
    Key? key,
  }) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  var message = "";

  @override
  void initState() {
    super.initState();

    widget.updateLoadMessage?.call((value) {
      setState(() {
        message = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor : widget.background,
      body : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: LoadingAnimationWidget.twoRotatingArc(
                color: FTLColors.normal,
                size: 40,
              ),
            ),
            Text(message,
              style: const TextStyle(
                color: FTLColors.normal,
                fontSize: 16,
              ),
            ),
          ],
        ),
      )
    );
  }
}
