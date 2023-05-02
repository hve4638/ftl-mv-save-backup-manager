import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  final Widget onLoadPage;
  final Widget loadingPage;
  final Widget loadFailPage;
  final Future<bool> Function() load;
  const Loading({
    required this.onLoadPage,
    required this.loadingPage,
    required this.loadFailPage,
    required this.load,
    Key? key,
  }) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  bool loading = true;
  bool loadSuccess = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    var value = await widget.load();

    setState(() {
      loading = false;
      loadSuccess = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (
        loading
          ? (widget.loadingPage)
          : (loadSuccess
            ? widget.onLoadPage
            : widget.loadFailPage
          )
    );
  }
}
