import 'package:flutter/material.dart';

class AnimatedOverlayWidget extends StatefulWidget {
  final VoidCallback onRemoveOverlay;
  const AnimatedOverlayWidget({super.key, required this.onRemoveOverlay});

  @override
  _AnimatedOverlayWidgetState createState() => _AnimatedOverlayWidgetState();
}

class _AnimatedOverlayWidgetState extends State<AnimatedOverlayWidget>
    with SingleTickerProviderStateMixin {
  double _width = 0;
  double _height = 0;
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    WidgetsBinding.instance.addPostFrameCallback((_) => _animate());
  }

  void _animate() async {
    setState(() {
      _width = MediaQuery.of(context).size.height * 2.5;
      _height = MediaQuery.of(context).size.height * 2.5;
    });
    await Future.delayed(Duration(milliseconds: 500));
    _controller.forward(from: 0);
  }

  void _unanimate() async {
    setState(() {
      _width = 0;
      _height = 0;
    });
    _controller.reverse();
    await Future.delayed(Duration(seconds: 1));
    widget.onRemoveOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Positioned(
        child: OverflowBox(
          maxHeight: MediaQuery.of(context).size.height * 2.5,
          maxWidth: MediaQuery.of(context).size.width * 2.5,
          child: AnimatedContainer(
              width: _width,
              height: _height,
              duration: Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _opacityAnimation.value,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('3213'),
                              Icon(Icons.currency_exchange_outlined)
                            ],
                          ),
                          Text('Core'),
                          ElevatedButton(
                              onPressed: () => {},
                              child: Text('Convert Currency To Evo')),
                          ElevatedButton(
                              onPressed: _unanimate, child: Text('back'))
                        ]),
                  );
                },
              )),
        ),
      ),
    );
  }
}
