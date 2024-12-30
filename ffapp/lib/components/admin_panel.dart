import 'package:ffapp/components/button_themes.dart';
import 'package:flutter/material.dart';

class DraggableAdminPanel extends StatefulWidget {
  final VoidCallback onButton1Pressed;
  final VoidCallback onButton2Pressed;
  final String button1Text;
  final String button2Text;

  const DraggableAdminPanel(
      {super.key,
      required this.onButton1Pressed,
      required this.onButton2Pressed,
      required this.button1Text,
      required this.button2Text,});
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
                offset.dy -
                    MediaQuery.of(context).padding.top -
                    kToolbarHeight,);
          });
        },
      ),
    );
  }

  Widget adminPanel() {
    return Card(
      color: Theme.of(context).colorScheme.primaryFixedDim,
      child: SizedBox(
        width: 200,
        height: 200,
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            Text('Admin Panel',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FfButton(
                      text: widget.button1Text,
                      textColor: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      onPressed: widget.onButton1Pressed,),
                  const SizedBox(
                    height: 10,
                  ),
                  FfButton(
                      text: widget.button2Text,
                      textColor: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      onPressed: widget.onButton2Pressed,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
