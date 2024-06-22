import 'package:flutter/material.dart';

class DraggableAdminPanel extends StatefulWidget {
  @override
  final VoidCallback onButton1Pressed;
  final VoidCallback onButton2Pressed;
  final String button1Text;
  final String button2Text;

  const DraggableAdminPanel({super.key, required this.onButton1Pressed, required this.onButton2Pressed, required this.button1Text, required this.button2Text});
  @override
  _DraggableAdminPanelState createState() => _DraggableAdminPanelState();
}

class _DraggableAdminPanelState extends State<DraggableAdminPanel> {
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
            this.offset = Offset(offset.dx, offset.dy - MediaQuery.of(context).padding.top - kToolbarHeight);
          });
        },
      ),
    );
  }

  Widget adminPanel() {
    return Card(
      child: SizedBox(
        width: 200,
        height: 200,
        child: Column(
          children: <Widget>[
            const Text('Admin Panel'),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {widget.onButton1Pressed();},
                  child: Text(widget.button1Text),
                ),
                ElevatedButton(
                  onPressed: () {widget.onButton2Pressed();},
                  child: Text(widget.button2Text),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}