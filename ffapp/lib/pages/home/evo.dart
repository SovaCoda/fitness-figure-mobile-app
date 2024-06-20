import 'package:ffapp/components/robot_image_holder.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EvolutionPage extends StatefulWidget {
  EvolutionPage({Key? key}) : super(key: key);

  @override
  _EvolutionPageState createState() => _EvolutionPageState();
}

class _EvolutionPageState extends State<EvolutionPage> {
  late AuthService auth;

  void evolveFigure() {
    Provider.of<FigureModel>(context, listen: false).setFigureLevel(
        Provider.of<FigureModel>(context, listen: false).EVLevel! + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Consumer<FigureModel>(
      builder: (context, figure, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Evolution Page'),
            RobotImageHolder(
              url: (figure.figure != null)
                  ? ("${figure.figure!.figureName}/${figure.figure!.figureName}_skin${figure.figure!.curSkin}_evo${(figure.EVLevel != null) ? figure.EVLevel : 0}_cropped")
                  : "robot1/robot1_skin0_evo0_cropped_happy",
              height: 400,
              width: 600,
            ),
            ElevatedButton(
              onPressed: () {
                evolveFigure();
              },
              child: Text('Evolve Figure'),
            ),
          ],
        );
      },
    ));
  }
}
