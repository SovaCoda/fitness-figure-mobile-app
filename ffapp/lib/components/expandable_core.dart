import 'package:ffapp/components/core_overlay.dart';
import 'package:ffapp/pages/home/store.dart';
import 'package:flutter/material.dart';

class ExpandableCore extends StatefulWidget {
  bool isExpanded;
  final Duration duration;
  final Curve curve;

  ExpandableCore({
    super.key,
    required this.isExpanded,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.fastOutSlowIn,
  });

  @override
  _ExpandableCoreState createState() => _ExpandableCoreState();
}

class _ExpandableCoreState extends State<ExpandableCore> {
  void showOverlay(BuildContext context) {
    try {
      Overlay.of(context).insert(coreOverlay);
    } on FlutterError catch (e) {
      logger.e(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showOverlay(context);
      },
      child: Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
              border: Border.all(),
              shape: BoxShape.rectangle,
              color: Theme.of(context).primaryColor),
          child: Center(child: Text('core'))),
    );
  }
}
