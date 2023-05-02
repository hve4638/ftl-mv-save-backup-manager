import 'package:flutter/material.dart';

class LoadFailPage extends StatefulWidget {
  const LoadFailPage({Key? key}) : super(key: key);

  @override
  State<LoadFailPage> createState() => _LoadFailPageState();
}

class _LoadFailPageState extends State<LoadFailPage> {

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("load fail"),
    );
  }
}
