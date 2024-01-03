import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: AlwaysStoppedAnimation(0),
          builder: (BuildContext context, Widget? child) {
            return Transform.rotate(
              angle: 2 * 3.1415 * 0.5,
              child: child,
            );
          },
          child: Text(
            'Debug',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
