import 'package:flutter/material.dart';

class FfAlertDialog extends StatelessWidget {
  final Widget child;
  const FfAlertDialog({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Stack(children: [
      Container(
        width: MediaQuery.sizeOf(context).width * 0.7,
        height: MediaQuery.sizeOf(context).height / 2,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Theme.of(context).colorScheme.surfaceBright,
                Theme.of(context).colorScheme.surfaceDim,
              ]),
          border: Border.all(
              color: Theme.of(context).colorScheme.secondary.withAlpha(127),
              width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ),
      ),
      Transform.translate(
        offset: const Offset(-1, -1),
        child: IgnorePointer(
          child: Container(
              width: MediaQuery.sizeOf(context).width * 0.7 * 0.7,
              height: MediaQuery.sizeOf(context).height / 4,
              decoration: BoxDecoration(
                border: Border(
                    left: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2,
                    ),
                    top: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2,
                    )),
              )),
        ),
      ),
      Positioned(
        top: 4,
        left: 4,
        child: IgnorePointer(
          child: Container(
              width: MediaQuery.sizeOf(context).width * 0.7 * 0.55,
              height: MediaQuery.sizeOf(context).height / 4 * 0.8,
              decoration: BoxDecoration(
                border: Border(
                    left: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2,
                    ),
                    top: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2,
                    )),
              )),
        ),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: Transform.translate(
          offset: const Offset(1, 1),
          child: IgnorePointer(
            child: Container(
                width: MediaQuery.sizeOf(context).width * 0.7 * 0.7,
                height: MediaQuery.sizeOf(context).height / 4,
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 2,
                      ),
                      right: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 2,
                      )),
                )),
          ),
        ),
      ),
      Positioned(
        bottom: 4,
        right: 4,
        child: IgnorePointer(
          child: Container(
              width: MediaQuery.sizeOf(context).width * 0.7 * 0.55,
              height: MediaQuery.sizeOf(context).height / 4 * 0.8,
              decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2,
                    ),
                    bottom: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2,
                    )),
              )),
        ),
      ),
    ]));
  }
}
