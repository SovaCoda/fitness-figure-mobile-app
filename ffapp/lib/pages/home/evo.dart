import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EvolutionPage extends StatefulWidget {
  EvolutionPage({Key? key}) : super(key: key);

  @override
  _EvolutionPageState createState() => _EvolutionPageState();
}

class _EvolutionPageState extends State<EvolutionPage>
    with TickerProviderStateMixin {
  late AuthService auth;
  late AnimationController _controller;

  late Animation<Color?> _colorAnimation;
  late Animation<double> _sizeAnimation;
  late Animation<double> _opacityAnimation;

  late AnimationController _flashController;
  late Animation<double> _flashAnimation;

  late AnimationController _figureFadeController;
  late Animation<double> _figureFadeAnimation;

  bool _isEvolved = false;
  bool _disabledButtons = false;

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthService>(context, listen: false);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _flashController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _flashAnimation = Tween<double>(begin: 0, end: 1).animate(_flashController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _flashController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _flashController.reset();
          _flashController.stop();
        }
      });

    _colorAnimation = ColorTween(
      begin: Colors.transparent,
      end: Colors.green,
    ).animate(_controller);

    _sizeAnimation = Tween<double>(begin: 400, end: 700).animate(_controller);

    _opacityAnimation = Tween<double>(begin: 1, end: 0).animate(_controller);
  }

  void evolveFigure() async {
    setState(() {
      _disabledButtons = true;
    });
    await _controller.forward(from: 0);
    await _controller.status == AnimationStatus.completed;
    await _flashController.forward(from: 0);
    await Future.delayed(Duration(seconds: 1));
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      Provider.of<FigureModel>(context, listen: false).setFigureLevel(
          Provider.of<FigureModel>(context, listen: false).figure!.evLevel + 1);
      _isEvolved = true;
      auth.updateFigureInstance(Provider.of<FigureModel>(context, listen: false).figure!);
    });
    await Future.delayed(Duration(seconds: 1));
    await _controller.reverse();
    await _flashController.reverse();
    setState(() {
      _disabledButtons = false;
    });
  }

  void viewRewards() {
    context.goNamed("Home");
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Consumer<FigureModel>(
      builder: (context, figure, child) {
        return AnimatedBuilder(
            animation: _colorAnimation,
            builder: (context, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 100,
                    child: Opacity(
                      opacity: _opacityAnimation.value ?? 0,
                      child: !_isEvolved
                          ? Text(
                              'Evolve Your Figure!',
                              style: (Theme.of(context).textTheme.displayLarge),
                              textAlign: TextAlign.center,
                            )
                          : Text('Congratulations!',
                              style: (Theme.of(context).textTheme.displayLarge),
                              textAlign: TextAlign.center),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(
                            _flashAnimation.value * 10 ?? 0),
                        boxShadow: [
                          BoxShadow(
                            color: _colorAnimation.value!,
                            spreadRadius: _flashAnimation.value! * 100 ?? 0,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ]),
                    child: RobotImageHolder(
                      url: (figure.figure != null)
                          ? ("${figure.figure!.figureName}/${figure.figure!.figureName}_skin${figure.figure!.curSkin}_evo${(figure.EVLevel != null) ? figure.EVLevel : 0}_cropped")
                          : "robot1/robot1_skin0_evo0_cropped_happy",
                      height: _sizeAnimation.value!.toDouble() ?? 400,
                      width: _sizeAnimation.value!.toDouble() ?? 400,
                    ),
                  ),
                  Opacity(
                    opacity: _opacityAnimation.value ?? 0,
                    child: !_isEvolved
                        ? ElevatedButton(
                            onPressed: () {
                              _disabledButtons ? () : evolveFigure();
                            },
                            child: Text('Evolve Figure'),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              _disabledButtons ? () : viewRewards();
                            },
                            child: Text('Awesome!')),
                  ),
                ],
              );
            });
      },
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
