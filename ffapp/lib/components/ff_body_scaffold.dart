import 'package:flutter/material.dart';

class FfBodyScaffold extends StatelessWidget {
  const FfBodyScaffold({
    super.key,
    required int? selectedIndex,
    required List<Widget> pages,
  })  : _selectedIndex = selectedIndex,
        _pages = pages;

  final int? _selectedIndex;
  final List<Widget> _pages;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Transform.translate(
          offset: const Offset(0, -80),
          child: OverflowBox(
              maxWidth: MediaQuery.sizeOf(context).width,
              maxHeight: MediaQuery.sizeOf(context).height,
              child: Image.asset(
                'lib/assets/art/ff_background.png',
                width: MediaQuery.sizeOf(context).width + 200,
                height: MediaQuery.sizeOf(context).height,
              ))),
      IndexedStack(
        index: _selectedIndex,
        children: _pages,
      )
    ]);
  }
}
