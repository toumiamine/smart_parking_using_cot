import 'package:flutter/widgets.dart';

class RestartController extends StatefulWidget {
  final Widget child;

  const RestartController({Key? key, required this.child}) : super(key: key);

  @override
  _RestartController createState() => _RestartController();

  static rebirth(BuildContext context) {
    context.findAncestorStateOfType<_RestartController>()!.restartApp();
  }
}

class _RestartController extends State<RestartController> {
  Key _key = UniqueKey();

  void restartApp() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      child: widget.child,
    );
  }
}


