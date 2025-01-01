import 'package:ffapp/components/ff_app_button.dart';
import 'package:ffapp/components/button_themes.dart';
import 'package:ffapp/components/resuables/gradiented_container.dart';
import 'package:flutter/material.dart';

class DraggableAdminPanel extends StatefulWidget {
  final VoidCallback onButton1Pressed;
  final VoidCallback onButton2Pressed;
  final String button1Text;
  final String button2Text;

  const DraggableAdminPanel({
    super.key,
    required this.onButton1Pressed,
    required this.onButton2Pressed,
    required this.button1Text,
    required this.button2Text,
  });
  @override
  DraggableAdminPanelState createState() => DraggableAdminPanelState();
}

class DraggableAdminPanelState extends State<DraggableAdminPanel> {
  Offset offset = const Offset(0.0, 0.0);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: Draggable(
        feedback: adminPanel(),
        child: adminPanel(),
        onDraggableCanceled: (velocity, offset) {
          setState(() {
            this.offset = Offset(
              offset.dx,
              offset.dy - MediaQuery.of(context).padding.top - kToolbarHeight,
            );
          });
        },
      ),
    );
  }

  Widget adminPanel() {
    return GradientedContainer(
      child: SizedBox(
        width: 200,
        height: 200,
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            Text(
              'Admin Panel',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            FFAppButton(
              size: 200,
              height: 40,
              text: widget.button1Text,
              onPressed: widget.onButton1Pressed,
            ),
            FFAppButton(
              size: 200,
              height: 40,
              text: widget.button2Text,
              onPressed: widget.onButton2Pressed,
            ),
          ],
        ),
      ),
    );
  }
}
